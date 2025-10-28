import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/profile_model.dart';
import '../../../services/compatible_auth_service.dart';
import '../../../services/notification_service.dart';
import '../providers/profile_provider.dart';

/// خدمة إشعارات التوثيق
/// تدير إرسال الإشعارات المتعلقة بحالة توثيق الملف الشخصي
class ProfileNotificationService {
  static Timer? _notificationTimer;
  static bool _isServiceActive = false;

  /// بدء خدمة إشعارات التوثيق
  static void startService(WidgetRef ref) {
    if (_isServiceActive) return;

    _isServiceActive = true;
    if (kDebugMode) {
      debugPrint('🔔 ProfileNotificationService: Service started');
    }

    // فحص حالة التوثيق كل 30 ثانية
    _notificationTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _checkVerificationStatus(ref),
    );
  }

  /// إيقاف خدمة إشعارات التوثيق
  static void stopService() {
    if (!_isServiceActive) return;

    _isServiceActive = false;
    _notificationTimer?.cancel();
    _notificationTimer = null;
    if (kDebugMode) {
      debugPrint('🔔 ProfileNotificationService: Service stopped');
    }
  }

  /// فحص حالة التوثيق
  static Future<void> _checkVerificationStatus(WidgetRef ref) async {
    try {
      final authState = ref.read(compatibleAuthProvider);
      final user = authState.user;

      if (user == null) return;

      // الحصول على الملف الشخصي من profileProvider
      final profileState = ref.read(profileProvider);
      final profile = profileState.currentProfile;

      if (profile == null) return;

      // فحص إذا كان المستخدم تم توثيقه حديثاً
      if (profile.isVerified) {
        await _sendVerificationSuccessNotification(user.id);
        // TODO: إضافة آلية لتجنب إرسال الإشعار مرة أخرى
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ ProfileNotificationService: Error checking verification status: $e');
      }
    }
  }

  /// إرسال إشعار نجاح التوثيق
  static Future<void> _sendVerificationSuccessNotification(String userId) async {
    try {
      // إرسال إشعار محلي
      await NotificationService.showLocalNotification(
        title: 'تم توثيق حسابك',
        body: 'تم توثيق حسابك يمكنك الآن الاشتراك بالمؤتمر والفعاليات المصاحبة',
        payload: 'verification_success',
      );

      // إرسال إشعار للخادم
      await NotificationService.sendNotification(
        title: 'تم توثيق حسابك',
        message: 'تم توثيق حسابك يمكنك الآن الاشتراك بالمؤتمر والفعاليات المصاحبة',
        type: 'success',
        userId: userId,
        data: {
          'type': 'verification_success',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('✅ ProfileNotificationService: Verification success notification sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ ProfileNotificationService: Error sending verification notification: $e');
      }
    }
  }

  /// إرسال إشعار رفض التوثيق
  static Future<void> sendVerificationRejectionNotification({
    required String userId,
    required String reason,
  }) async {
    try {
      // إرسال إشعار محلي
      await NotificationService.showLocalNotification(
        title: 'تم رفض طلب التوثيق',
        body: 'تم رفض طلب توثيق حسابك. السبب: $reason',
        payload: 'verification_rejected',
      );

      // إرسال إشعار للخادم
      await NotificationService.sendNotification(
        title: 'تم رفض طلب التوثيق',
        message: 'تم رفض طلب توثيق حسابك. السبب: $reason',
        type: 'error',
        userId: userId,
        data: {
          'type': 'verification_rejected',
          'reason': reason,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('✅ ProfileNotificationService: Verification rejection notification sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ ProfileNotificationService: Error sending rejection notification: $e');
      }
    }
  }

  /// إرسال إشعار تذكير بإكمال الملف الشخصي
  static Future<void> sendProfileCompletionReminder({
    required String userId,
    required List<String> missingFields,
  }) async {
    try {
      final fieldsText = missingFields.join('، ');
      
      // إرسال إشعار محلي
      await NotificationService.showLocalNotification(
        title: 'أكمل ملفك الشخصي',
        body: 'يرجى إكمال البيانات المطلوبة: $fieldsText',
        payload: 'profile_completion_reminder',
      );

      // إرسال إشعار للخادم
      await NotificationService.sendNotification(
        title: 'أكمل ملفك الشخصي',
        message: 'يرجى إكمال البيانات المطلوبة: $fieldsText',
        type: 'info',
        userId: userId,
        data: {
          'type': 'profile_completion_reminder',
          'missing_fields': missingFields,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('✅ ProfileNotificationService: Profile completion reminder sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ ProfileNotificationService: Error sending completion reminder: $e');
      }
    }
  }

  /// إرسال إشعار تحديث الملف الشخصي
  static Future<void> sendProfileUpdateNotification({
    required String userId,
    required String updateType,
  }) async {
    try {
      String title = '';
      String message = '';

      switch (updateType) {
        case 'profile_picture':
          title = 'تم تحديث صورة الملف الشخصي';
          message = 'تم تحديث صورة ملفك الشخصي بنجاح';
          break;
        case 'personal_info':
          title = 'تم تحديث البيانات الشخصية';
          message = 'تم تحديث بياناتك الشخصية بنجاح';
          break;
        case 'documents':
          title = 'تم تحديث الوثائق';
          message = 'تم تحديث وثائقك بنجاح';
          break;
        default:
          title = 'تم تحديث الملف الشخصي';
          message = 'تم تحديث ملفك الشخصي بنجاح';
      }

      // إرسال إشعار للخادم
      await NotificationService.sendNotification(
        title: title,
        message: message,
        type: 'success',
        userId: userId,
        data: {
          'type': 'profile_update',
          'update_type': updateType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('✅ ProfileNotificationService: Profile update notification sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ ProfileNotificationService: Error sending update notification: $e');
      }
    }
  }

  /// إرسال إشعار تذكير برفع الوثائق
  static Future<void> sendDocumentUploadReminder({
    required String userId,
    required List<String> requiredDocuments,
  }) async {
    try {
      final documentsText = requiredDocuments.join('، ');
      
      // إرسال إشعار محلي
      await NotificationService.showLocalNotification(
        title: 'ارفع الوثائق المطلوبة',
        body: 'يرجى رفع الوثائق التالية: $documentsText',
        payload: 'document_upload_reminder',
      );

      // إرسال إشعار للخادم
      await NotificationService.sendNotification(
        title: 'ارفع الوثائق المطلوبة',
        message: 'يرجى رفع الوثائق التالية: $documentsText',
        type: 'warning',
        userId: userId,
        data: {
          'type': 'document_upload_reminder',
          'required_documents': requiredDocuments,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (kDebugMode) {
        debugPrint('✅ ProfileNotificationService: Document upload reminder sent');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ ProfileNotificationService: Error sending document reminder: $e');
      }
    }
  }
}

/// Provider لخدمة إشعارات التوثيق
final profileNotificationServiceProvider = Provider<ProfileNotificationService>((ref) {
  return ProfileNotificationService();
});
