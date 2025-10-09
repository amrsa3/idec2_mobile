import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// خدمة الإشعارات المركزية
class NotificationService {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  /// عرض إشعار نجاح
  static void showSuccess(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  /// عرض إشعار خطأ
  static void showError(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  /// عرض إشعار تحذير
  static void showWarning(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  /// عرض إشعار معلومات
  static void showInfo(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }

  /// عرض إشعار مخصص
  static void showCustom({
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration? duration,
  }) {
    _showSnackBar(
      message,
      backgroundColor: backgroundColor ?? Colors.grey,
      icon: icon ?? Icons.notifications,
      duration: duration,
    );
  }

  /// عرض SnackBar
  static void _showSnackBar(
    String message, {
    required Color backgroundColor,
    required IconData icon,
    Duration? duration,
  }) {
    final scaffoldMessenger = _scaffoldMessengerKey.currentState;
    if (scaffoldMessenger != null) {
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          duration: duration ?? const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  /// إخفاء الإشعار الحالي
  static void hideCurrentNotification() {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  /// عرض حوار تأكيد
  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// عرض حوار تحميل
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }

  /// إخفاء حوار التحميل
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Provider لخدمة الإشعارات
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
