import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/firebase_constants.dart';
import '../core/utils/storage_helper.dart';
import '../features/notifications/providers/push_topics_provider.dart';
import '../firebase_options.dart';
import '../models/auth_models.dart';
import '../providers/enhanced_auth_provider_v2.dart';
import '../services/compatible_auth_service.dart';
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

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _initialized = false;
  String? _currentToken;
  ProviderSubscription<AuthState>? _authSubscription;
  ProviderSubscription<CompatibleAuthState>? _compatAuthSubscription;
  WidgetRef? _ref;

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

    await _requestPermission();
    await _registerForegroundHandlers();
    await _syncTokenWithServer();

    _authSubscription = ref.listenManual<AuthState>(
      enhancedAuthProvider,
      (previous, next) async {
        if (next.maybeWhen(authenticated: (_) => true, orElse: () => false)) {
          await _syncTokenWithServer();
        } else if (next.maybeWhen(
            unauthenticated: () => true, orElse: () => false)) {
          await _unregisterCurrentToken();
        }
      },
    );

    _compatAuthSubscription = ref.listenManual<CompatibleAuthState>(
      compatibleAuthProvider,
      (previous, next) async {
        if (next.isAuthenticated == true) {
          await _syncTokenWithServer();
        } else if (next.isAuthenticated == false) {
          await _unregisterCurrentToken();
        }
      },
    );

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
    _compatAuthSubscription = null;
    _ref = null;
    _initialized = false;
  }

  Future<void> _requestPermission() async {
    try {
      if (kIsWeb) {
        final status = await _messaging.requestPermission();
        debugPrint(
            '✅ [FCM] Web notification permission: ${status.authorizationStatus}');
        return;
      }

      final settings = await _messaging.requestPermission(
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
    } catch (error) {
      debugPrint('❌ [FCM] Permission request failed: $error');
    }
  }

  Future<void> _registerForegroundHandlers() async {
    FirebaseMessaging.onMessage.listen((message) async {
      await _handleIncomingMessage(message, foreground: true);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _handleIncomingMessage(message, foreground: false);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleIncomingMessage(initialMessage, foreground: false);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
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
  }

  Future<void> _handleIncomingMessage(RemoteMessage message,
      {required bool foreground}) async {
    if (!kIsWeb) {
      final notification = message.notification;
      if (notification != null) {
        await NotificationService.showLocalNotification(
          title: notification.title ?? 'IDEC',
          body: notification.body ?? '',
          payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
        );
      }
    }

    final container = _ref;
    if (container != null) {
      container.read(pushTopicsProvider.notifier).refreshFromServer();
    }
  }

  Future<void> _syncTokenWithServer() async {
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
      debugPrint('ℹ️ [FCM] Skipping token sync while user is unauthenticated');
      return;
    }

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ [FCM] No token returned from Firebase');
        return;
      }

      if (_currentToken == token) {
        return;
      }

      await _registerToken(token);
    } catch (error, stackTrace) {
      debugPrint('❌ [FCM] Token sync failed: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<String?> _getToken() async {
    final storedToken = await StorageHelper.getString(_fcmTokenStorageKey);
    if (storedToken != null && storedToken.isNotEmpty) {
      _currentToken = storedToken;
    }

    if (kIsWeb) {
      const vapidKey = FirebaseConstants.webVapidKey;
      if (vapidKey.isEmpty) {
        debugPrint(
            '⚠️ [FCM] FIREBASE_WEB_VAPID_KEY not provided; web push will be disabled.');
        return _currentToken;
      }
      final registration = await sw.ensureFirebaseMessagingServiceWorker();
      if (registration == null) {
        debugPrint(
            '❌ [FCM] Unable to register firebase-messaging service worker; skipping token retrieval.');
        return _currentToken;
      }

      String? token = await _messaging.getToken(vapidKey: vapidKey);

      if (token == null || token.isEmpty) {
        debugPrint('⚠️ [FCM] Firebase returned empty token; retrying after short delay...');
        await Future.delayed(const Duration(seconds: 2));
        token = await _messaging.getToken(vapidKey: vapidKey);
      }

      if (token != null && token.isNotEmpty) {
        final preview = token.length > 8 ? token.substring(0, 8) : token;
        debugPrint('✅ [FCM] Web token received ($preview...)');
      } else {
        debugPrint('❌ [FCM] Unable to retrieve web token after retry.');
      }

      return token;
    }

    return _messaging.getToken();
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
      debugPrint(
          'ℹ️ [FCM] Skipping token registration because user is not authenticated');
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
      final preview = token.length > 8 ? token.substring(0, 8) : token;
      debugPrint('✅ [FCM] Token registered with backend ($preview...)');
    } catch (error, stackTrace) {
      debugPrint('❌ [FCM] Failed to register token with backend: $error');
      debugPrint('$stackTrace');
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
        container.read(pushTokenProvider.notifier).state = null;
        container.read(pushTopicsProvider.notifier).clearLocal();
      }
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
}
