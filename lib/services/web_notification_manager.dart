import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/firebase_constants.dart';
import 'push_api_service.dart';
import 'push/service_worker_registration_stub.dart'
    if (dart.library.html) 'push/service_worker_registration_web.dart' as sw;

/// مدير الإشعارات للويب - يتعامل مع طلب الأذونات وحفظ Token
class WebNotificationManager {
  static final WebNotificationManager instance = WebNotificationManager._();
  WebNotificationManager._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  WidgetRef? _ref;

  /// تهيئة المدير
  void initialize(WidgetRef ref) {
    _ref = ref;
  }

  /// فحص حالة Token الحالية
  Future<TokenStatus> checkTokenStatus() async {
    if (!kIsWeb) {
      return TokenStatus.notApplicable;
    }

    try {
      // فحص الأذونات
      final settings = await _messaging.getNotificationSettings();
      
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return TokenStatus.denied;
      }
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // فحص إذا كان Token محفوظ في Backend
        final hasToken = await _checkTokenInBackend();
        if (hasToken) {
          return TokenStatus.registered;
        } else {
          return TokenStatus.permissionGrantedButNotRegistered;
        }
      }

      return TokenStatus.notRequested;
    } catch (e) {
      debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Error checking status: $e');
      return TokenStatus.error;
    }
  }

  /// طلب الأذونات وحفظ Token
  Future<RequestPermissionResult> requestPermissionAndRegisterToken() async {
    if (!kIsWeb) {
      return RequestPermissionResult(
        success: false,
        message: 'Not applicable on this platform',
      );
    }

    try {
      debugPrint('🔔 [WEB_NOTIFICATION_MANAGER] Requesting permission...');

      // طلب الأذونات
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Permission denied');
        return RequestPermissionResult(
          success: false,
          message: 'تم رفض أذونات الإشعارات',
          status: settings.authorizationStatus,
        );
      }

      debugPrint('✅ [WEB_NOTIFICATION_MANAGER] Permission granted');

      // تسجيل Service Worker
      final registration = await sw.ensureFirebaseMessagingServiceWorker();
      if (registration == null) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Service worker registration failed');
        return RequestPermissionResult(
          success: false,
          message: 'فشل في تسجيل Service Worker',
        );
      }

      // الحصول على Token
      const vapidKey = FirebaseConstants.webVapidKey;
      if (vapidKey.isEmpty) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] VAPID key is empty');
        return RequestPermissionResult(
          success: false,
          message: 'VAPID key غير متوفر',
        );
      }

      final token = await _messaging.getToken(vapidKey: vapidKey);
      if (token == null || token.isEmpty) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Failed to get token');
        return RequestPermissionResult(
          success: false,
          message: 'فشل في الحصول على Token',
        );
      }

      debugPrint('✅ [WEB_NOTIFICATION_MANAGER] Token received: ${token.substring(0, 20)}...');

      // حفظ Token في Backend
      try {
        await PushApiService.instance.registerToken(
          token: token,
          platform: FcmPlatformType.web,
        );
        debugPrint('✅ [WEB_NOTIFICATION_MANAGER] Token registered in backend');

        return RequestPermissionResult(
          success: true,
          message: 'تم تفعيل الإشعارات بنجاح',
          token: token,
        );
      } catch (e) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Failed to register token: $e');
        return RequestPermissionResult(
          success: false,
          message: 'فشل في حفظ Token: ${e.toString()}',
          token: token,
        );
      }
    } catch (e) {
      debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Error: $e');
      return RequestPermissionResult(
        success: false,
        message: 'حدث خطأ: ${e.toString()}',
      );
    }
  }

  /// محاولة تسجيل Token تلقائياً (بعد تسجيل الدخول)
  Future<bool> tryAutoRegisterToken() async {
    if (!kIsWeb) return false;

    try {
      debugPrint('🔄 [WEB_NOTIFICATION_MANAGER] Trying auto-register...');

      // فحص الأذونات الحالية
      final settings = await _messaging.getNotificationSettings();
      
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('ℹ️ [WEB_NOTIFICATION_MANAGER] Permission not granted, skipping auto-register');
        return false;
      }

      // فحص إذا كان Token محفوظ بالفعل
      final hasToken = await _checkTokenInBackend();
      if (hasToken) {
        debugPrint('ℹ️ [WEB_NOTIFICATION_MANAGER] Token already registered');
        return true;
      }

      // محاولة الحصول على Token وحفظه
      debugPrint('🔄 [WEB_NOTIFICATION_MANAGER] Getting and registering token...');
      
      const vapidKey = FirebaseConstants.webVapidKey;
      if (vapidKey.isEmpty) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] VAPID key is empty');
        return false;
      }

      final registration = await sw.ensureFirebaseMessagingServiceWorker();
      if (registration == null) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Service worker registration failed');
        return false;
      }

      final token = await _messaging.getToken(vapidKey: vapidKey);
      if (token == null || token.isEmpty) {
        debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Failed to get token');
        return false;
      }

      await PushApiService.instance.registerToken(
        token: token,
        platform: FcmPlatformType.web,
      );
      debugPrint('✅ [WEB_NOTIFICATION_MANAGER] Token auto-registered successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Auto-register failed: $e');
      return false;
    }
  }

  /// فحص إذا كان Token محفوظ في Backend
  Future<bool> _checkTokenInBackend() async {
    try {
      // محاولة جلب Tokens من Backend
      // إذا نجح ووجد tokens، معناه Token موجود
      final tokens = await PushApiService.instance.listDeviceTokens();
      return tokens.isNotEmpty;
    } catch (e) {
      debugPrint('❌ [WEB_NOTIFICATION_MANAGER] Error checking token: $e');
      return false;
    }
  }
}

/// حالة Token
enum TokenStatus {
  notApplicable, // ليس Web
  notRequested, // لم يتم طلب الأذونات
  denied, // تم رفض الأذونات
  permissionGrantedButNotRegistered, // الأذونات ممنوحة لكن Token غير محفوظ
  registered, // Token محفوظ في Backend
  error, // خطأ
}

/// نتيجة طلب الأذونات
class RequestPermissionResult {
  final bool success;
  final String message;
  final String? token;
  final AuthorizationStatus? status;

  RequestPermissionResult({
    required this.success,
    required this.message,
    this.token,
    this.status,
  });
}

