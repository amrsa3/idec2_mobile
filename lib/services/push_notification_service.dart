import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as js_util;

import '../core/constants/firebase_constants.dart';
import '../core/utils/storage_helper.dart';
import '../features/notifications/providers/push_topics_provider.dart';
import '../firebase_options.dart';
import '../models/auth_models.dart';
import '../core/router/deep_link_handler.dart';
import '../providers/enhanced_auth_provider_v2.dart';
import '../providers/registration_provider.dart';
import '../providers/conference_provider.dart';
import '../providers/notification_provider.dart';
import '../features/profile/providers/profile_provider.dart';
import '../features/registrations/presentation/my_registrations_screen.dart';
import '../features/registrations/presentation/registration_detail_screen.dart';
import '../models/profile_model.dart';
import '../services/compatible_auth_service.dart';
import '../services/navigation_service.dart';
import 'notification_service.dart';
import 'push_api_service.dart';
import 'push/service_worker_registration_stub.dart'
    if (dart.library.html) 'push/service_worker_registration_web.dart'
        as sw;

const _fcmTokenStorageKey = 'fcm_device_token';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ إصلاح: حفظ بيانات profileStatus في Storage لتحديثها تلقائياً عند فتح التطبيق
  // في background handler، لا يمكن الوصول إلى providers مباشرة
  // لذا نحفظ البيانات في Storage ونقوم بتحديثها عند فتح التطبيق
  try {
    final data = message.data;
    if (data.containsKey('profileStatus') || data.containsKey('profileId')) {
      debugPrint('📬 [FCM-BG] Background message contains profileStatus: ${data['profileStatus']}');
      
      // حفظ البيانات في Storage لتحديثها عند فتح التطبيق
      final storageData = {
        'profileStatus': data['profileStatus'],
        'profileId': data['profileId'],
        'timestamp': DateTime.now().toIso8601String(),
        'messageId': message.messageId,
      };
      
      try {
        await StorageHelper.setString('pending_profile_update', jsonEncode(storageData));
        debugPrint('✅ [FCM-BG] Saved profile update data to storage for later processing');
      } catch (e) {
        debugPrint('⚠️ [FCM-BG] Failed to save profile update data: $e');
      }
    }
  } catch (e) {
    debugPrint('⚠️ [FCM-BG] Error processing background message data: $e');
  }

  if (!kIsWeb) {
    await NotificationService.initialize();
    final notification = message.notification;
    await NotificationService.showLocalNotification(
      title: notification?.title ?? 'IDEC',
      body: notification?.body ?? '',
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  // Lazy-load FirebaseMessaging to avoid errors when Firebase is not initialized
  FirebaseMessaging? _messaging;
  FirebaseMessaging get messaging {
    try {
      _messaging ??= FirebaseMessaging.instance;
      return _messaging!;
    } catch (e) {
      debugPrint('⚠️ [FCM] FirebaseMessaging not available: $e');
      // Return a dummy instance that won't be used
      // This prevents crashes when Firebase is not initialized
      throw StateError('FirebaseMessaging is not initialized. Please call initialize() first.');
    }
  }
  
  bool _initialized = false;
  String? _currentToken;
  ProviderSubscription<AuthState>? _authSubscription;
  ProviderSubscription<CompatibleAuthState>? _compatAuthSubscription;
  WidgetRef? _ref;
  bool _isSyncingToken = false; // ✅ Guard لمنع الاستدعاءات المكررة
  
  // Stream Controller لتحديث صفحة الإشعارات عند وصول إشعار جديد
  final _notificationReceivedController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNotificationReceived => _notificationReceivedController.stream;

  Future<void> initialize(WidgetRef ref) async {
    if (_initialized) {
      _ref = ref;
      return;
    }

    _ref = ref;

    try {
      await NotificationService.initialize();
    } catch (error) {
      debugPrint('⚠️ [FCM] Notification service init failed: $error');
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // ✅ إصلاح: فحص Storage عند التهيئة لمعالجة أي تحديثات معلقة للملف الشخصي
    // هذا يضمن تحديث حالة الملف الشخصي حتى لو تم استقبال الإشعار في الخلفية
    _processPendingProfileUpdates(ref);
    
    // ✅ إصلاح: إضافة listener لـ postMessage و BroadcastChannel في web لاستقبال البيانات من Service Worker
    if (kIsWeb) {
      try {
        // استخدام BroadcastChannel لاستقبال البيانات من Service Worker
        try {
          final channel = html.BroadcastChannel('fcm_notifications');
          channel.onMessage.listen((event) {
            debugPrint('📬 [FCM] Web: Received message via BroadcastChannel');
            debugPrint('📬 [FCM] Web: Event data type: ${event.data.runtimeType}');
            debugPrint('📬 [FCM] Web: Event data: ${event.data}');
            
            try {
              // تحويل event.data إلى Map إذا لزم الأمر
              Map<String, dynamic>? dataMap;
              if (event.data is Map) {
                dataMap = Map<String, dynamic>.from(event.data as Map);
              } else if (event.data is String) {
                try {
                  dataMap = jsonDecode(event.data as String) as Map<String, dynamic>;
                } catch (e) {
                  debugPrint('⚠️ [FCM] Web: Failed to parse event.data as JSON: $e');
                }
              }
              
              if (dataMap != null) {
                final messageType = dataMap['type'] as String?;
                debugPrint('📬 [FCM] Web: Message type: $messageType');
                
                if (messageType == 'NOTIFICATION_RECEIVED' || messageType == 'NOTIFICATION_CLICKED') {
                  final notificationData = dataMap['data'];
                  debugPrint('📬 [FCM] Web: Notification data type: ${notificationData.runtimeType}');
                  
                  Map<String, dynamic>? notificationDataMap;
                  if (notificationData is Map) {
                    notificationDataMap = Map<String, dynamic>.from(notificationData);
                  } else if (notificationData is String) {
                    try {
                      notificationDataMap = jsonDecode(notificationData as String) as Map<String, dynamic>;
                    } catch (e) {
                      debugPrint('⚠️ [FCM] Web: Failed to parse notificationData as JSON: $e');
                    }
                  }
                  
                  if (notificationDataMap != null) {
                    debugPrint('📤 [FCM] Web: Processing notification from BroadcastChannel');
                    debugPrint('📤 [FCM] Web: Notification data keys: ${notificationDataMap.keys.toList()}');
                    debugPrint('📤 [FCM] Web: Has profileStatus: ${notificationDataMap.containsKey('profileStatus')}');
                    debugPrint('📤 [FCM] Web: profileStatus value: ${notificationDataMap['profileStatus']}');
                    debugPrint('📤 [FCM] Web: _ref is null: ${_ref == null}');
                    
                    // ✅ إصلاح: التحقق من _ref قبل معالجة البيانات
                    // إنشاء نسخة محلية من notificationDataMap لتجنب مشاكل null safety
                    final dataToProcess = notificationDataMap;
                    
                    if (_ref == null) {
                      debugPrint('⚠️ [FCM] Web: _ref is null, waiting for initialization...');
                      // محاولة الانتظار قليلاً ثم إعادة المحاولة
                      Future.delayed(const Duration(milliseconds: 500), () async {
                        if (_ref != null && dataToProcess != null) {
                          debugPrint('✅ [FCM] Web: _ref is now available, processing notification');
                          _handleIncomingMessageWithData(
                            RemoteMessage(
                              messageId: dataToProcess['messageId']?.toString(),
                              notification: RemoteNotification(
                                title: dataToProcess['title']?.toString(),
                                body: dataToProcess['body']?.toString(),
                              ),
                              data: {},
                            ),
                            dataToProcess,
                            foreground: false,
                          );
                        } else {
                          debugPrint('⚠️ [FCM] Web: _ref is still null after delay, saving to storage');
                          // حفظ البيانات في Storage لمعالجتها لاحقاً
                          if (dataToProcess != null) {
                            await _saveNotificationDataToStorage(dataToProcess);
                          }
                        }
                      });
                    } else {
                      // معالجة البيانات مباشرة
                      if (dataToProcess != null) {
                        _handleIncomingMessageWithData(
                          RemoteMessage(
                            messageId: dataToProcess['messageId']?.toString(),
                            notification: RemoteNotification(
                              title: dataToProcess['title']?.toString(),
                              body: dataToProcess['body']?.toString(),
                            ),
                            data: {},
                          ),
                          dataToProcess,
                          foreground: false,
                        );
                      }
                    }
                  } else {
                    debugPrint('⚠️ [FCM] Web: notificationData is null or invalid');
                  }
                } else {
                  debugPrint('⚠️ [FCM] Web: Unknown message type: $messageType');
                }
              } else {
                debugPrint('⚠️ [FCM] Web: Failed to convert event.data to Map');
              }
            } catch (e, stackTrace) {
              debugPrint('⚠️ [FCM] Web: Error processing BroadcastChannel message: $e');
              debugPrint('Stack trace: $stackTrace');
            }
          });
          debugPrint('✅ [FCM] Web: BroadcastChannel listener registered');
        } catch (e) {
          debugPrint('⚠️ [FCM] Web: BroadcastChannel not supported: $e');
        }
        
        // أيضاً استخدام postMessage كبديل
        html.window.addEventListener('message', (event) {
          debugPrint('📬 [FCM] Web: Received message event: ${event.runtimeType}');
          if (event is html.MessageEvent) {
            try {
              debugPrint('📬 [FCM] Web: Message event data type: ${event.data.runtimeType}');
              debugPrint('📬 [FCM] Web: Message event data: ${event.data}');
              final data = event.data;
              if (data is Map) {
                final messageType = data['type'] as String?;
                debugPrint('📬 [FCM] Web: Message type: $messageType');
                
                // معالجة NOTIFICATION_RECEIVED (عند استقبال الإشعار في الخلفية)
                if (messageType == 'NOTIFICATION_RECEIVED') {
                  debugPrint('📬 [FCM] Web: Received notification data from Service Worker (background)');
                  final notificationData = data['data'] as Map<String, dynamic>?;
                  if (notificationData != null) {
                    debugPrint('📤 [FCM] Web: Notification data: ${notificationData.keys.toList()}');
                    debugPrint('📤 [FCM] Web: Full notification data: $notificationData');
                    // معالجة البيانات تلقائياً لتحديث حالة الملف الشخصي
                    _handleIncomingMessageWithData(
                      RemoteMessage(
                        messageId: notificationData['messageId']?.toString(),
                        notification: RemoteNotification(
                          title: notificationData['title']?.toString(),
                          body: notificationData['body']?.toString(),
                        ),
                        data: {},
                      ),
                      notificationData,
                      foreground: false,
                    );
                  } else {
                    debugPrint('⚠️ [FCM] Web: notificationData is null');
                  }
                }
                // معالجة NOTIFICATION_CLICKED (عند النقر على الإشعار)
                else if (messageType == 'NOTIFICATION_CLICKED') {
                  debugPrint('📬 [FCM] Web: Received notification click data from Service Worker');
                  final notificationData = data['data'] as Map<String, dynamic>?;
                  if (notificationData != null) {
                    debugPrint('📤 [FCM] Web: Notification data: ${notificationData.keys.toList()}');
                    debugPrint('📤 [FCM] Web: Full notification data: $notificationData');
                    // معالجة البيانات كما لو كانت من onMessageOpenedApp
                    _handleIncomingMessageWithData(
                      RemoteMessage(
                        messageId: notificationData['messageId']?.toString(),
                        notification: RemoteNotification(
                          title: notificationData['title']?.toString(),
                          body: notificationData['body']?.toString(),
                        ),
                        data: {},
                      ),
                      notificationData,
                      foreground: false,
                    );
                  } else {
                    debugPrint('⚠️ [FCM] Web: notificationData is null');
                  }
                } else {
                  debugPrint('⚠️ [FCM] Web: Unknown message type: $messageType');
                }
              } else {
                debugPrint('⚠️ [FCM] Web: Message data is not a Map: ${data.runtimeType}');
              }
            } catch (e, stackTrace) {
              debugPrint('⚠️ [FCM] Web: Error handling postMessage: $e');
              debugPrint('Stack trace: $stackTrace');
            }
          } else {
            debugPrint('⚠️ [FCM] Web: Event is not MessageEvent: ${event.runtimeType}');
          }
        });
        debugPrint('✅ [FCM] Web: postMessage listener registered');
      } catch (e, stackTrace) {
        debugPrint('⚠️ [FCM] Web: Failed to register postMessage listener: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    }

    // على Web، لا نطلب الأذونات تلقائياً - يجب أن يتم من خلال user gesture
    if (!kIsWeb) {
      await _requestPermission();
    } else {
      debugPrint('🌐 [FCM] Web platform detected - skipping automatic permission request');
      debugPrint('💡 [FCM] Use WebNotificationPermissionCard widget to request permissions');
    }
    
    await _registerForegroundHandlers();
    
    // ✅ إصلاح: فحص localStorage عند التهيئة لمعالجة أي بيانات معلقة من Service Worker
    if (kIsWeb) {
      _checkForPendingNotificationData(ref);
    }
    
    // ✅ إصلاح: تسجيل listeners أولاً، ثم sync مرة واحدة فقط
    _authSubscription = ref.listenManual<AuthState>(
      enhancedAuthProvider,
      (previous, next) async {
        // Only sync token when user becomes authenticated
        if (next.maybeWhen(authenticated: (_) => true, orElse: () => false)) {
          await _syncTokenWithServer();
        } 
        // Only unregister token when user explicitly logs out (transition from authenticated to unauthenticated)
        // Don't unregister if previous state was also unauthenticated (e.g., app restart before auth is restored)
        else if (next.maybeWhen(
            unauthenticated: () => true, orElse: () => false)) {
          // Check if previous state was authenticated - only then should we unregister
          final wasAuthenticated = previous?.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          ) ?? false;
          
          if (wasAuthenticated) {
            // User explicitly logged out - unregister token
            await _unregisterCurrentToken();
          }
          // If previous state was not authenticated, this is likely app initialization
          // Don't unregister token in this case
        }
      },
    );

    _compatAuthSubscription = ref.listenManual<CompatibleAuthState>(
      compatibleAuthProvider,
      (previous, next) async {
        // Only sync token when user becomes authenticated
        if (next.isAuthenticated == true) {
          await _syncTokenWithServer();
        } 
        // Only unregister token when user explicitly logs out (transition from authenticated to unauthenticated)
        // Don't unregister if previous state was also unauthenticated (e.g., app restart before auth is restored)
        else if (next.isAuthenticated == false) {
          // Check if previous state was authenticated - only then should we unregister
          final wasAuthenticated = previous?.isAuthenticated ?? false;
          
          if (wasAuthenticated) {
            // User explicitly logged out - unregister token
            await _unregisterCurrentToken();
          }
          // If previous state was not authenticated, this is likely app initialization
          // Don't unregister token in this case
        }
      },
    );

    // ✅ إصلاح: sync مرة واحدة فقط بعد تسجيل جميع listeners
    final currentState = ref.read(enhancedAuthProvider);
    if (currentState.maybeWhen(
        authenticated: (_) => true, orElse: () => false)) {
      await _syncTokenWithServer();
    }

    _initialized = true;
  }

  Future<void> dispose() async {
    final subscription = _authSubscription;
    if (subscription != null) {
      await Future.sync(() => subscription.close());
    }
    final compatSubscription = _compatAuthSubscription;
    if (compatSubscription != null) {
      await Future.sync(() => compatSubscription.close());
    }
    _authSubscription = null;
    // إغلاق Stream Controller
    await _notificationReceivedController.close();
    _compatAuthSubscription = null;
    _ref = null;
    _initialized = false;
  }

  Future<void> _requestPermission() async {
    try {
      if (kIsWeb) {
        // Check current permission status first
        final currentStatus = await messaging.getNotificationSettings();
        debugPrint('🔍 [FCM] Current web notification permission: ${currentStatus.authorizationStatus}');
        
        if (currentStatus.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('✅ [FCM] Web notification permission already granted');
          return;
        }
        
        if (currentStatus.authorizationStatus == AuthorizationStatus.denied) {
          debugPrint('⚠️ [FCM] Web notification permission was denied. Requesting again...');
        }
        
        final status = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        
        debugPrint('✅ [FCM] Web notification permission request result: ${status.authorizationStatus}');
        
        if (status.authorizationStatus == AuthorizationStatus.authorized) {
          debugPrint('✅ [FCM] Web notification permission granted successfully');
        } else if (status.authorizationStatus == AuthorizationStatus.denied) {
          debugPrint('❌ [FCM] Web notification permission denied by user');
        } else if (status.authorizationStatus == AuthorizationStatus.notDetermined) {
          debugPrint('⚠️ [FCM] Web notification permission not determined');
        } else {
          debugPrint('⚠️ [FCM] Web notification permission: ${status.authorizationStatus}');
        }
        return;
      }

      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint(
          '✅ [FCM] Authorization granted: ${settings.authorizationStatus}');
    } catch (error, stackTrace) {
      debugPrint('❌ [FCM] Permission request failed: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _registerForegroundHandlers() async {
    try {
      FirebaseMessaging.onMessage.listen((message) async {
        Map<String, dynamic> actualData = message.data;
        if (kIsWeb && message.data.isEmpty && message.notification != null) {
          try {
            final storedData = html.window.sessionStorage['notificationData'];
            if (storedData != null) {
              actualData = jsonDecode(storedData) as Map<String, dynamic>;
              html.window.sessionStorage.remove('notificationData');
            } else {
              actualData = {
                '_reloadProfile': true,
              };
            }
          } catch (e) {
            actualData = {
              '_reloadProfile': true,
            };
          }
        }
        
        await _handleIncomingMessage(message, customData: actualData, foreground: true);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      Map<String, dynamic> actualData = message.data;
      if (kIsWeb && message.data.isEmpty) {
        try {
          String? storedData;
          try {
            storedData = html.window.localStorage['notificationData'];
            if (storedData != null) {
              html.window.localStorage.remove('notificationData');
            }
          } catch (e) {
            // Ignore
          }
          
          if (storedData == null) {
            try {
              storedData = html.window.sessionStorage['notificationData'];
              if (storedData != null) {
                html.window.sessionStorage.remove('notificationData');
              }
            } catch (e) {
              // Ignore
            }
          }
          
          if (storedData != null && storedData.isNotEmpty) {
            actualData = jsonDecode(storedData) as Map<String, dynamic>;
          } else {
            actualData = {
              '_reloadProfile': true,
            };
          }
        } catch (e, stackTrace) {
          actualData = {
            '_reloadProfile': true,
          };
        }
      }
      
      final deepLinkHandler = DeepLinkHandler();
      final navigatorKey = NavigationService.navigatorKey;
      if (navigatorKey.currentContext != null) {
        await deepLinkHandler.handlePushDataDeepLink(
          navigatorKey.currentContext!,
          actualData,
        );
      }
      
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      await _handleIncomingMessageWithData(message, actualData, foreground: false);
    });

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
      Map<String, dynamic> actualData = initialMessage.data;
      if (kIsWeb && initialMessage.data.isEmpty) {
        try {
          final storedData = html.window.sessionStorage['notificationData'];
          if (storedData != null) {
            actualData = jsonDecode(storedData) as Map<String, dynamic>;
            html.window.sessionStorage.remove('notificationData');
          } else {
            actualData = {
              '_reloadProfile': true,
            };
          }
        } catch (e) {
          actualData = {
            '_reloadProfile': true,
          };
        }
      }
      
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }
      
      await _handleIncomingMessageWithData(initialMessage, actualData, foreground: false);
    }

    messaging.onTokenRefresh.listen((newToken) async {
      final oldToken = _currentToken;
      if (oldToken != null && oldToken != newToken) {
        try {
          await PushApiService.instance.unregisterToken(oldToken);
        } catch (error) {
          debugPrint('⚠️ [FCM] Failed to unregister old token: $error');
        }
      }
      await _registerToken(newToken);
    });
    } catch (e, stackTrace) {
      debugPrint('⚠️ [FCM] Error registering foreground handlers: $e');
      debugPrint('Stack trace: $stackTrace');
      // في web، قد لا يكون Firebase مهيأ بعد، لذا لا نرمي الخطأ
      if (!kIsWeb) {
        rethrow;
      }
    }
  }

  /// Handle incoming message with custom data (for web when data is empty)
  Future<void> _handleIncomingMessageWithData(
    RemoteMessage message,
    Map<String, dynamic> customData,
    {required bool foreground}
  ) async {
    // إنشاء message جديد بالبيانات المخصصة
    // للأسف، RemoteMessage لا يدعم إنشاء instance جديد مباشرة
    // لذا نستخدم reflection أو نمرر البيانات بشكل منفصل
    // الحل: استخدام customData مباشرة في _handleIncomingMessage
    await _handleIncomingMessage(message, customData: customData, foreground: foreground);
  }

  Future<void> _handleIncomingMessage(
    RemoteMessage message, {
    Map<String, dynamic>? customData,
    required bool foreground
  }) async {
    // استخدام customData إذا كان متاحاً (لـ web عندما تكون البيانات فارغة)
    final actualData = customData ?? message.data;
    
    if (kDebugMode) {
      debugPrint('📬 [FCM] Message received: ${message.messageId}');
      if (actualData.isNotEmpty) {
        debugPrint('📬 [FCM] Data keys: ${actualData.keys.toList()}');
      }
    }

    // ✅ إصلاح: عرض notification محلي حتى في web عندما يكون التطبيق مفتوح
    final notification = message.notification;
    if (notification != null) {
      debugPrint('🔔 [FCM] Showing local notification: ${notification.title} - ${notification.body}');
      if (!kIsWeb) {
        await NotificationService.showLocalNotification(
          title: notification.title ?? 'IDEC',
          body: notification.body ?? '',
          payload: actualData.isNotEmpty ? jsonEncode(actualData) : null,
        );
      } else {
        // ✅ إصلاح: عرض الإشعار فقط في foreground (عندما يكون التطبيق مفتوحاً)
        // في background، الـ Service Worker يعرض الإشعار تلقائياً
        if (foreground) {
          debugPrint('🌐 [FCM] Web: Showing notification manually in foreground');
          try {
            // ✅ إصلاح: عرض Web Notification يدوياً
            final notificationTitle = notification.title ?? 'IDEC';
            final notificationBody = notification.body ?? 'لديك إشعار جديد';
            
            // التحقق من أذونات الإشعارات
            if (html.Notification.permission == 'granted') {
              try {
                // إنشاء options للإشعار باستخدام js_util
                final options = js_util.jsify({
                  'body': notificationBody,
                  'icon': '/icons/Icon-192.png',
                  'tag': actualData['messageCode'] ?? 'default',
                  'requireInteraction': false,
                  'data': actualData,
                  'vibrate': [200, 100, 200],
                });
                
                // إنشاء Notification باستخدام JavaScript
                final notificationConstructor = js_util.getProperty(html.window, 'Notification');
                final webNotification = js_util.callConstructor(
                  notificationConstructor,
                  [notificationTitle, options],
                );
                
                // معالجة النقر على الإشعار
                js_util.setProperty(webNotification, 'onclick', js_util.allowInterop((event) {
                  debugPrint('🔔 [FCM] Web notification clicked');
                  // إغلاق الإشعار
                  js_util.callMethod(webNotification, 'close', []);
                  
                  // معالجة deep linking إذا كان هناك actionType
                  if (actualData.containsKey('actionType')) {
                    final navigatorKey = NavigationService.navigatorKey;
                    if (navigatorKey.currentContext != null) {
                      final deepLinkHandler = DeepLinkHandler();
                      deepLinkHandler.handlePushDataDeepLink(
                        navigatorKey.currentContext!,
                        actualData,
                      );
                    }
                  }
                }));
                
                debugPrint('✅ [FCM] Web notification shown successfully: $notificationTitle');
              } catch (e, stackTrace) {
                debugPrint('⚠️ [FCM] Error creating web notification: $e');
                debugPrint('Stack trace: $stackTrace');
              }
            } else {
              debugPrint('⚠️ [FCM] Web notification permission not granted: ${html.Notification.permission}');
            }
          } catch (e, stackTrace) {
            debugPrint('⚠️ [FCM] Web: Error showing notification: $e');
            debugPrint('Stack trace: $stackTrace');
          }
        } else {
          // في background، الـ Service Worker يعرض الإشعار تلقائياً، لا حاجة لعرضه هنا
          debugPrint('🌐 [FCM] Web: App in background - Service Worker will handle notification display');
        }
      }
    } else {
      debugPrint('⚠️ [FCM] No notification object in message');
    }

    // إرسال إشعار عبر Stream لتحديث صفحة الإشعارات
    try {
      _notificationReceivedController.add(actualData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [FCM] Error sending notification to stream: $e');
      }
    }
    
    final container = _ref;
    if (container != null) {
      try {
        container.read(pushTopicsProvider.notifier).refreshFromServer();
      } catch (e) {
        // Ignore
      }
      
      // ✅ إصلاح: تحديث صفحة الإشعارات عند وصول إشعار جديد
      try {
        // تحديث قائمة الإشعارات
        container.invalidate(notificationsProvider);
        // تحديث عدد الإشعارات غير المقروءة
        container.invalidate(unreadCountProvider);
        // تحديث إحصائيات الإشعارات
        container.invalidate(notificationStatsProvider);
        debugPrint('✅ [FCM] Notification providers invalidated - UI will refresh');
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ [FCM] Error invalidating notification providers: $e');
        }
      }
      
      final data = actualData;
      
      // Debounce provider invalidation to prevent excessive updates
      Future.delayed(const Duration(milliseconds: 500), () {
        if (container == null) {
          return;
        }
        
        try {
          // Handle registration status updates
          if (data.containsKey('registrationStatus')) {
            final eventId = data['eventId'] as String?;
            final conferenceId = data['conferenceId'] as String?;
            final registrationId = data['registrationId'] as String?;
            
            if (eventId != null && eventId.isNotEmpty) {
              container.invalidate(eventRegistrationStatusProvider(eventId));
            }
            
            if (conferenceId != null && conferenceId.isNotEmpty) {
              container.invalidate(conferenceRegistrationProvider(conferenceId));
            }
            
            if (registrationId != null && registrationId.isNotEmpty) {
              container.invalidate(registrationDetailProvider(registrationId));
            }
            
            container.invalidate(myRegistrationsProvider);
          } else {
            if (data.containsKey('eventId') || data.containsKey('registrationId')) {
              final eventId = data['eventId'] as String?;
              final registrationId = data['registrationId'] as String?;
              
              if (eventId != null && eventId.isNotEmpty) {
                container.invalidate(eventRegistrationStatusProvider(eventId));
              }
              
              if (registrationId != null && registrationId.isNotEmpty) {
                container.invalidate(registrationDetailProvider(registrationId));
              }
              
              container.invalidate(myRegistrationsProvider);
            }
            
            if (data.containsKey('conferenceId')) {
              final conferenceId = data['conferenceId'] as String?;
              if (conferenceId != null && conferenceId.isNotEmpty) {
                container.invalidate(conferenceRegistrationProvider(conferenceId));
              }
            }
          }
          
          // Handle payment status updates
          if (data.containsKey('paymentStatus')) {
            final registrationId = data['registrationId'] as String?;
            
            if (registrationId != null && registrationId.isNotEmpty) {
              final eventId = data['eventId'] as String?;
              final conferenceId = data['conferenceId'] as String?;
              
              if (eventId != null && eventId.isNotEmpty) {
                container.invalidate(eventRegistrationStatusProvider(eventId));
              }
              
              if (conferenceId != null && conferenceId.isNotEmpty) {
                container.invalidate(conferenceRegistrationProvider(conferenceId));
              }
              
              container.invalidate(registrationDetailProvider(registrationId));
            }
            
            container.invalidate(myRegistrationsProvider);
          }
          
          // Handle profile updates
          if (data.containsKey('profileStatus') || 
              data.containsKey('profileId') || 
              data.containsKey('_reloadProfile')) {
            
            if (data.containsKey('_reloadProfile') && kIsWeb) {
              try {
                container.read(profileProvider.notifier).loadCurrentProfile(forceRefresh: true);
              } catch (e) {
                if (kDebugMode) {
                  debugPrint('⚠️ [FCM] Error reloading profile: $e');
                }
              }
              return;
            }
            
            final profileId = data['profileId'] as String?;
            final profileStatusStr = data['profileStatus'] as String?;
            
            if (profileStatusStr != null && profileStatusStr.isNotEmpty) {
              try {
                VerificationStatus? newStatus;
                switch (profileStatusStr.toUpperCase()) {
                  case 'UNVERIFIED':
                    newStatus = VerificationStatus.unverified;
                    break;
                  case 'PENDING_VERIFICATION':
                    newStatus = VerificationStatus.underReview;
                    break;
                  case 'VERIFIED':
                    newStatus = VerificationStatus.verified;
                    break;
                  case 'REJECTED':
                    newStatus = VerificationStatus.rejected;
                    break;
                  default:
                    break;
                }

                if (newStatus != null) {
                  try {
                    final currentContainer = _ref;
                    if (currentContainer == null) {
                      _saveNotificationDataToStorage(data);
                      return;
                    }
                    
                    final profileNotifier = currentContainer.read(profileProvider.notifier);
                    final currentState = currentContainer.read(profileProvider);
                    final currentProfile = currentState.currentProfile;

                    if (currentProfile != null) {
                      final updatedProfile = currentProfile.copyWith(
                        verificationStatus: newStatus,
                      );

                      profileNotifier.state = currentState.copyWith(
                        currentProfile: updatedProfile,
                      );
                      
                      try {
                        _notificationReceivedController.add({
                          ...data,
                          '_profileStatusUpdated': true,
                          '_newStatus': profileStatusStr,
                        });
                      } catch (e) {
                        // Ignore
                      }
                      
                      Future.delayed(const Duration(seconds: 2), () {
                        try {
                          profileNotifier.loadCurrentProfile(forceRefresh: true);
                        } catch (e) {
                          // Ignore
                        }
                      });
                    } else {
                      currentContainer.invalidate(profileProvider);
                      Future.delayed(const Duration(seconds: 1), () {
                        final delayedContainer = _ref;
                        if (delayedContainer != null) {
                          try {
                            delayedContainer.read(profileProvider.notifier).loadCurrentProfile(forceRefresh: true);
                          } catch (e) {
                            // Ignore
                          }
                        }
                      });
                    }
                  } catch (e, stackTrace) {
                    if (kDebugMode) {
                      debugPrint('⚠️ [FCM] Error updating profile status: $e');
                    }
                    container.invalidate(profileProvider);
                    Future.delayed(const Duration(seconds: 1), () {
                      try {
                        container.read(profileProvider.notifier).loadCurrentProfile(forceRefresh: true);
                      } catch (err) {
                        // Ignore
                      }
                    });
                  }
                }
              } catch (e, stackTrace) {
                if (kDebugMode) {
                  debugPrint('⚠️ [FCM] Error processing profile status: $e');
                }
                container.invalidate(profileProvider);
                Future.delayed(const Duration(seconds: 1), () {
                  try {
                    container.read(profileProvider.notifier).loadCurrentProfile(forceRefresh: true);
                  } catch (err) {
                    // Ignore
                  }
                });
              }
            } else if (profileId != null && profileId.isNotEmpty) {
              container.invalidate(profileProvider);
              Future.delayed(const Duration(seconds: 1), () {
                try {
                  container.read(profileProvider.notifier).loadCurrentProfile(forceRefresh: true);
                } catch (e) {
                  // Ignore
                }
              });
            }
          }
          
          // Handle transaction updates
          if (data.containsKey('transactionId')) {
            // Could invalidate transaction detail provider if available
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            debugPrint('⚠️ [FCM] Error invalidating providers: $e');
          }
        }
      });
    } else {
      if (kIsWeb) {
        for (int attempt = 1; attempt <= 5; attempt++) {
          await Future.delayed(Duration(seconds: attempt));
          if (_ref != null) {
            await _handleIncomingMessage(message, foreground: foreground);
            return;
          }
        }
        final data = message.data;
        if (data.containsKey('profileStatus')) {
          try {
            _notificationReceivedController.add({
              ...data,
              '_forceProfileRefresh': true,
              '_profileStatus': data['profileStatus'],
            });
          } catch (e) {
            // Ignore
          }
        }
      } else {
        Future.delayed(const Duration(seconds: 2), () async {
          if (_ref != null) {
            await _handleIncomingMessage(message, foreground: foreground);
          }
        });
      }
    }
  }

  /// Public method to sync a specific token with server
  Future<void> syncTokenWithServer(String token) async {
    try {
      if (token.isEmpty) {
        return;
      }

      final container = _ref;
      if (container == null) {
        return;
      }

      final enhancedState = container.read(enhancedAuthProvider);
      final compatibleState = container.read(compatibleAuthProvider);
      final isAuthenticated = enhancedState.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          ) ||
          compatibleState.isAuthenticated;
      
      if (!isAuthenticated) {
        return;
      }

      await _registerToken(token);
      _currentToken = token;
      await StorageHelper.setString(_fcmTokenStorageKey, token);
    } catch (error, stackTrace) {
      debugPrint('❌ [FCM] Failed to sync token: $error');
      if (kDebugMode) {
        debugPrint('$stackTrace');
      }
    }
  }

  Future<void> _syncTokenWithServer() async {
    // ✅ إصلاح: منع الاستدعاءات المكررة
    if (_isSyncingToken) {
      return;
    }
    
    _isSyncingToken = true;
    try {
      final container = _ref;
      if (container == null) {
        return;
      }

      final enhancedState = container.read(enhancedAuthProvider);
      final compatibleState = container.read(compatibleAuthProvider);
      final isAuthenticated = enhancedState.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          ) ||
          compatibleState.isAuthenticated;
      
      if (!isAuthenticated) {
        return;
      }

      try {
        // على الويب، تأكد من أن الأذونات ممنوحة أولاً
        if (kIsWeb) {
          final settings = await messaging.getNotificationSettings();
          if (settings.authorizationStatus != AuthorizationStatus.authorized &&
              settings.authorizationStatus != AuthorizationStatus.provisional) {
            return;
          }
        }

        final token = await _getToken();
        if (token == null || token.isEmpty) {
          return;
        }

        await syncTokenWithServer(token);
      } catch (error, stackTrace) {
        debugPrint('❌ [FCM] Token sync failed: $error');
        if (kDebugMode) {
          debugPrint('$stackTrace');
        }
      }
    } finally {
      _isSyncingToken = false;
    }
  }

  Future<String?> _getToken() async {
    final storedToken = await StorageHelper.getString(_fcmTokenStorageKey);
    if (storedToken != null && storedToken.isNotEmpty) {
      _currentToken = storedToken;
      debugPrint('📱 [FCM] Using stored token: ${storedToken.substring(0, 8)}...');
    }

    if (kIsWeb) {
      // Check permission first
      final settings = await messaging.getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('❌ [FCM] Cannot get token: permission not granted (${settings.authorizationStatus})');
        return _currentToken;
      }
      
      const vapidKey = FirebaseConstants.webVapidKey;
      if (vapidKey.isEmpty) {
        debugPrint(
            '⚠️ [FCM] FIREBASE_WEB_VAPID_KEY not provided; web push will be disabled.');
        return _currentToken;
      }
      
      debugPrint('🔧 [FCM] Registering service worker...');
      final registration = await sw.ensureFirebaseMessagingServiceWorker();
      if (registration == null) {
        debugPrint(
            '❌ [FCM] Unable to register firebase-messaging service worker; skipping token retrieval.');
        return _currentToken;
      }
      debugPrint('✅ [FCM] Service worker registered successfully');

      debugPrint('🔑 [FCM] Requesting FCM token...');
      String? token = await messaging.getToken(vapidKey: vapidKey);

      if (token == null || token.isEmpty) {
        debugPrint('⚠️ [FCM] Firebase returned empty token; retrying after short delay...');
        await Future.delayed(const Duration(seconds: 2));
        token = await messaging.getToken(vapidKey: vapidKey);
      }

      if (token != null && token.isNotEmpty) {
        final preview = token.length > 8 ? token.substring(0, 8) : token;
        debugPrint('✅ [FCM] Web token received ($preview...)');
      } else {
        debugPrint('❌ [FCM] Unable to retrieve web token after retry.');
      }

      return token;
    }

    return messaging.getToken();
  }

  Future<void> _registerToken(String token) async {
    final container = _ref;
    if (container == null) {
      return;
    }

    final enhancedState = container.read(enhancedAuthProvider);
    final compatibleState = container.read(compatibleAuthProvider);
    final isAuthenticated = enhancedState.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        ) ||
        compatibleState.isAuthenticated;
    
    if (!isAuthenticated) {
      return;
    }

    final platform = FcmPlatformType.currentPlatform();
    final deviceInfo = await _collectDeviceInfo();

    try {
      await PushApiService.instance.registerToken(
        token: token,
        platform: platform,
        deviceInfo: deviceInfo,
      );
    } catch (error, stackTrace) {
      debugPrint('❌ [FCM] Failed to register token: $error');
      if (kDebugMode) {
        debugPrint('$stackTrace');
      }
      return;
    }

    _currentToken = token;
    await StorageHelper.setString(_fcmTokenStorageKey, token);

    container.read(pushTokenProvider.notifier).state = token;
    await container.read(pushTopicsProvider.notifier).syncWithServer(token);
  }

  Future<void> _unregisterCurrentToken() async {
    final token =
        _currentToken ?? await StorageHelper.getString(_fcmTokenStorageKey);
    if (token == null || token.isEmpty) {
      return;
    }

    try {
      await PushApiService.instance.unregisterToken(token);
    } catch (error) {
      debugPrint('⚠️ [FCM] Token unregister failed: $error');
    } finally {
      _currentToken = null;
      await StorageHelper.remove(_fcmTokenStorageKey);
      final container = _ref;
      if (container != null) {
        try {
          container.read(pushTokenProvider.notifier).state = null;
          container.read(pushTopicsProvider.notifier).clearLocal();
        } catch (e) {
          // قد يكون container تم dispose، تجاهل الخطأ
          debugPrint('⚠️ [FCM] Container disposed, skipping provider updates: $e');
        }
      }
    }
  }

  /// ✅ حفظ بيانات الإشعار في Storage لمعالجتها لاحقاً
  Future<void> _saveNotificationDataToStorage(Map<String, dynamic> notificationData) async {
    try {
      if (notificationData.containsKey('profileStatus') || notificationData.containsKey('profileId')) {
        final storageData = {
          'profileStatus': notificationData['profileStatus'],
          'profileId': notificationData['profileId'],
          'timestamp': DateTime.now().toIso8601String(),
          'messageId': notificationData['messageId'],
          ...notificationData,
        };
        await StorageHelper.setString('pending_profile_update', jsonEncode(storageData));
        debugPrint('✅ [FCM] Web: Saved notification data to storage for later processing');
      }
    } catch (e) {
      debugPrint('⚠️ [FCM] Web: Error saving notification data to storage: $e');
    }
  }

  /// ✅ فحص localStorage للبيانات المعلقة من Service Worker
  void _checkForPendingNotificationData(WidgetRef ref) {
    try {
      if (!kIsWeb) return;
      
      // فحص localStorage للبيانات المعلقة
      final storedData = html.window.localStorage['notificationData'];
      if (storedData != null && storedData.isNotEmpty) {
        debugPrint('✅ [FCM] Web: Found pending notification data in localStorage');
        try {
          final data = jsonDecode(storedData) as Map<String, dynamic>;
          debugPrint('📤 [FCM] Web: Pending data: ${data.keys.toList()}');
          
          // حذف البيانات من localStorage
          html.window.localStorage.remove('notificationData');
          
          // معالجة البيانات تلقائياً
          if (data.containsKey('profileStatus') || data.containsKey('profileId')) {
            debugPrint('🔄 [FCM] Web: Processing pending profile update from localStorage');
            final fakeMessage = RemoteMessage(
              messageId: data['messageId']?.toString(),
              notification: RemoteNotification(
                title: data['title']?.toString(),
                body: data['body']?.toString(),
              ),
              data: {},
            );
            
            // معالجة التحديث بعد تأخير صغير للتأكد من أن providers جاهزة
            Future.delayed(const Duration(milliseconds: 500), () {
              _handleIncomingMessage(fakeMessage, customData: data, foreground: false);
            });
          }
        } catch (e, stackTrace) {
          debugPrint('⚠️ [FCM] Web: Error processing pending notification data: $e');
          debugPrint('Stack trace: $stackTrace');
          html.window.localStorage.remove('notificationData');
        }
      }
    } catch (e) {
      debugPrint('⚠️ [FCM] Web: Error checking for pending notification data: $e');
    }
  }

  Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        final info = await deviceInfoPlugin.webBrowserInfo;
        return {
          'browserName': describeEnum(info.browserName),
          'appVersion': info.appVersion,
          'platform': info.platform,
          'userAgent': info.userAgent,
          'hardwareConcurrency': info.hardwareConcurrency,
        };
      }

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final androidInfo = await deviceInfoPlugin.androidInfo;
          return {
            'brand': androidInfo.brand,
            'device': androidInfo.device,
            'model': androidInfo.model,
            'manufacturer': androidInfo.manufacturer,
            'version': androidInfo.version.release,
          };
        case TargetPlatform.iOS:
          final iosInfo = await deviceInfoPlugin.iosInfo;
          return {
            'name': iosInfo.name,
            'model': iosInfo.model,
            'systemName': iosInfo.systemName,
            'systemVersion': iosInfo.systemVersion,
          };
        default:
          final info = await deviceInfoPlugin.deviceInfo;
          return Map<String, dynamic>.from(info.data);
      }
    } catch (error) {
      debugPrint('⚠️ [FCM] Failed to collect device info: $error');
      return {};
    }
  }

  /// ✅ معالجة التحديثات المعلقة للملف الشخصي من Storage
  /// هذا يضمن تحديث حالة الملف الشخصي حتى لو تم استقبال الإشعار في الخلفية
  Future<void> _processPendingProfileUpdates(WidgetRef ref) async {
    try {
      final pendingUpdateStr = await StorageHelper.getString('pending_profile_update');
      if (pendingUpdateStr == null || pendingUpdateStr.isEmpty) {
        return; // لا توجد تحديثات معلقة
      }

      debugPrint('🔄 [FCM] Found pending profile update in storage');
      final pendingUpdate = jsonDecode(pendingUpdateStr) as Map<String, dynamic>;
      final profileStatusStr = pendingUpdate['profileStatus'] as String?;
      final timestampStr = pendingUpdate['timestamp'] as String?;
      
      // التحقق من أن التحديث حديث (أقل من 24 ساعة)
      if (timestampStr != null) {
        try {
          final timestamp = DateTime.parse(timestampStr);
          final now = DateTime.now();
          final difference = now.difference(timestamp);
          if (difference.inHours > 24) {
            debugPrint('⚠️ [FCM] Pending profile update is too old (${difference.inHours}h), ignoring');
            await StorageHelper.remove('pending_profile_update');
            return;
          }
        } catch (e) {
          debugPrint('⚠️ [FCM] Error parsing timestamp: $e');
        }
      }

      if (profileStatusStr != null && profileStatusStr.isNotEmpty) {
        debugPrint('✅ [FCM] Processing pending profile update: $profileStatusStr');
        
        // إنشاء message وهمي لمعالجة التحديث
        final fakeMessage = RemoteMessage(
          messageId: pendingUpdate['messageId']?.toString(),
          notification: null,
          data: {
            'profileStatus': profileStatusStr,
            'profileId': pendingUpdate['profileId']?.toString(),
          },
        );

        // معالجة التحديث باستخدام نفس المنطق
        await _handleIncomingMessage(fakeMessage, foreground: false);
        
        // حذف التحديث المعلق بعد معالجته
        await StorageHelper.remove('pending_profile_update');
        debugPrint('✅ [FCM] Pending profile update processed and removed from storage');
      }
    } catch (e, stackTrace) {
      debugPrint('⚠️ [FCM] Error processing pending profile updates: $e');
      debugPrint('$stackTrace');
      // في حالة الخطأ، نحاول حذف البيانات المعلقة لتجنب التكرار
      try {
        await StorageHelper.remove('pending_profile_update');
      } catch (_) {
        // ignore
      }
    }
  }
}
