import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/storage_helper.dart';
import '../models/notification_model.dart' hide NotificationResponse;

/// خدمة الإشعارات المركزية
/// تدير جميع الإشعارات في التطبيق
class NotificationService {
  static String get _baseUrl => ApiConstants.baseUrl;
  static const String _notificationsEndpoint = '/api/notifications';

  // مفتاح الـ GlobalKey للـ ScaffoldMessenger
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // مثيل الإشعارات المحلية
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// الحصول على مفتاح ScaffoldMessenger
  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  /// تهيئة خدمة الإشعارات
  static Future<void> initialize() async {
    // تهيئة الإشعارات المحلية
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    debugPrint('✅ [NOTIFICATION] تم تهيئة خدمة الإشعارات');
  }

  /// معالج النقر على الإشعار
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 [NOTIFICATION] تم النقر على الإشعار: ${response.payload}');
    // يمكن إضافة منطق التنقل هنا
  }

  /// عرض رسالة نجاح
  static Future<void> showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) async {
    _showSnackBar(
      title: title,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle,
      duration: duration,
    );

    debugPrint('✅ [NOTIFICATION] رسالة نجاح: $title - $message');
  }

  /// عرض رسالة خطأ
  static Future<void> showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) async {
    _showSnackBar(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error,
      duration: duration,
    );

    debugPrint('❌ [NOTIFICATION] رسالة خطأ: $title - $message');
  }

  /// عرض رسالة تحذير
  static Future<void> showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) async {
    _showSnackBar(
      title: title,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning,
      duration: duration,
    );

    debugPrint('⚠️ [NOTIFICATION] رسالة تحذير: $title - $message');
  }

  /// عرض رسالة معلومات
  static Future<void> showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) async {
    _showSnackBar(
      title: title,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info,
      duration: duration,
    );

    debugPrint('ℹ️ [NOTIFICATION] رسالة معلومات: $title - $message');
  }

  /// عرض SnackBar مخصص
  static void _showSnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final scaffoldMessenger = _scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null) {
      debugPrint('❌ [NOTIFICATION] ScaffoldMessenger غير متاح');
      return;
    }

    // إخفاء أي SnackBar موجود
    scaffoldMessenger.hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      action: SnackBarAction(
        label: 'إغلاق',
        textColor: Colors.white,
        onPressed: () {
          scaffoldMessenger.hideCurrentSnackBar();
        },
      ),
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// عرض إشعار محلي (Push Notification)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'idec_channel',
      'IDEC Conference',
      channelDescription: 'إشعارات مؤتمر IDEC لطب الأسنان',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    debugPrint('🔔 [NOTIFICATION] إشعار محلي: $title - $body');
  }

  /// إرسال إشعار للخادم
  static Future<bool> sendNotification({
    required String title,
    required String message,
    required String type, // success, error, warning, info
    String? userId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse('$_baseUrl$_notificationsEndpoint/send'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'message': message,
          'type': type,
          'userId': userId,
          'data': data,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ [NOTIFICATION] تم إرسال الإشعار بنجاح: $title');
        return true;
      } else {
        debugPrint(
            '❌ [NOTIFICATION] فشل إرسال الإشعار: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATION] خطأ في إرسال الإشعار: $e');
      return false;
    }
  }

  /// جلب الإشعارات من الخادم
  static Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
        if (isRead != null) 'isRead': isRead.toString(),
      };

      final uri = Uri.parse('$_baseUrl$_notificationsEndpoint')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final notifications = (data['notifications'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        debugPrint('✅ [NOTIFICATION] تم جلب ${notifications.length} إشعار');
        return notifications;
      } else {
        debugPrint(
            '❌ [NOTIFICATION] فشل جلب الإشعارات: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATION] خطأ في جلب الإشعارات: $e');
      return [];
    }
  }

  /// تحديد إشعار كمقروء
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.patch(
        Uri.parse('$_baseUrl$_notificationsEndpoint/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [NOTIFICATION] تم تحديد الإشعار كمقروء: $notificationId');
        return true;
      } else {
        debugPrint(
            '❌ [NOTIFICATION] فشل تحديد الإشعار كمقروء: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATION] خطأ في تحديد الإشعار كمقروء: $e');
      return false;
    }
  }

  /// تحديد جميع الإشعارات كمقروءة
  static Future<bool> markAllAsRead() async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.patch(
        Uri.parse('$_baseUrl$_notificationsEndpoint/read-all'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [NOTIFICATION] تم تحديد جميع الإشعارات كمقروءة');
        return true;
      } else {
        debugPrint(
            '❌ [NOTIFICATION] فشل تحديد جميع الإشعارات كمقروءة: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATION] خطأ في تحديد جميع الإشعارات كمقروءة: $e');
      return false;
    }
  }

  /// حذف إشعار
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.delete(
        Uri.parse('$_baseUrl$_notificationsEndpoint/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [NOTIFICATION] تم حذف الإشعار: $notificationId');
        return true;
      } else {
        debugPrint('❌ [NOTIFICATION] فشل حذف الإشعار: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATION] خطأ في حذف الإشعار: $e');
      return false;
    }
  }

  /// إرسال إشعار نجاح للخادم
  static Future<void> sendSuccessNotification({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    await sendNotification(
      title: title,
      message: message,
      type: 'success',
      data: data,
    );
  }

  /// إرسال إشعار خطأ للخادم
  static Future<void> sendErrorNotification({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    await sendNotification(
      title: title,
      message: message,
      type: 'error',
      data: data,
    );
  }

  /// إرسال إشعار تحذير للخادم
  static Future<void> sendWarningNotification({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    await sendNotification(
      title: title,
      message: message,
      type: 'warning',
      data: data,
    );
  }

  /// إرسال إشعار معلومات للخادم
  static Future<void> sendInfoNotification({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    await sendNotification(
      title: title,
      message: message,
      type: 'info',
      data: data,
    );
  }

  /// إرسال إشعار توثيق للحسابات غير الموثقة
  static Future<void> showVerificationReminder({
    required String userId,
  }) async {
    await sendNotification(
      title: 'تذكير التوثيق',
      message: 'يرجى إكمال عملية توثيق حسابك لتتمكن من التسجيل في الفعاليات',
      type: 'warning',
      userId: userId,
      data: {
        'action': 'verification_reminder',
        'redirectTo': '/profile',
      },
    );
  }

  /// إرسال إشعار تحديث حالة التوثيق
  static Future<void> notifyVerificationStatusUpdate({
    required String userId,
    required String status,
    String? rejectionReason,
  }) async {
    String title;
    String message;
    String type;

    switch (status) {
      case 'verified':
        title = 'تم توثيق حسابك';
        message =
            'تهانينا! تم توثيق حسابك بنجاح. يمكنك الآن التسجيل في جميع الفعاليات';
        type = 'success';
        break;
      case 'rejected':
        title = 'تم رفض طلب التوثيق';
        message = rejectionReason ??
            'تم رفض طلب التوثيق. يرجى مراجعة الوثائق المرفوعة وإعادة المحاولة';
        type = 'error';
        break;
      case 'pending':
        title = 'طلب التوثيق قيد المراجعة';
        message =
            'تم استلام طلب التوثيق وهو قيد المراجعة. سيتم إشعارك بالنتيجة قريباً';
        type = 'info';
        break;
      default:
        title = 'تحديث حالة التوثيق';
        message = 'تم تحديث حالة التوثيق الخاصة بك';
        type = 'info';
    }

    await sendNotification(
      title: title,
      message: message,
      type: type,
      userId: userId,
      data: {
        'action': 'verification_status_update',
        'status': status,
        'rejectionReason': rejectionReason,
        'redirectTo': '/profile',
      },
    );
  }

  /// الحصول على إشعارات المستخدم (مرادف لـ getNotifications)
  static Future<List<NotificationModel>> getUserNotifications({
    int page = 1,
    int limit = 20,
    bool? isRead,
    String? type,
  }) async {
    return getNotifications(
      page: page,
      limit: limit,
      isRead: isRead,
      type: type,
    );
  }

  /// إرسال إشعار تجريبي
  static Future<bool> sendTestNotification({
    required String title,
    required String message,
    String type = 'info',
    String? userId,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null) {
        await showError(
          title: 'خطأ في المصادقة',
          message: 'يرجى تسجيل الدخول أولاً',
        );
        return false;
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/notifications/test'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'message': message,
          'type': type,
          'userId': userId,
          'data': data,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await showSuccess(
          title: 'تم الإرسال',
          message: 'تم إرسال الإشعار التجريبي بنجاح',
        );
        return true;
      } else {
        await showError(
          title: 'خطأ في الإرسال',
          message: 'فشل في إرسال الإشعار التجريبي',
        );
        return false;
      }
    } catch (e) {
      await showError(
        title: 'خطأ',
        message: 'حدث خطأ أثناء إرسال الإشعار التجريبي: $e',
      );
      return false;
    }
  }
}

/// نموذج الإشعار
// تم نقل NotificationModel إلى models/notification_model.dart لتجنب التضارب

// Extension لإضافة دوال مساعدة للـ NotificationModel
extension NotificationModelUI on NotificationModel {
  /// لون الإشعار حسب النوع
  Color get color {
    switch (type) {
      case 'success':
        return AppColors.success;
      case 'error':
        return AppColors.error;
      case 'warning':
        return AppColors.warning;
      case 'info':
      default:
        return AppColors.primary;
    }
  }

  /// أيقونة الإشعار حسب النوع
  IconData get icon {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      case 'info':
      default:
        return Icons.info;
    }
  }
}
