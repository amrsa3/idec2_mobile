import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/compatible_auth_service.dart';
import 'notification_service.dart';

class VerificationNotificationService {
  static Timer? _notificationTimer;
  static bool _isServiceActive = false;

  /// Start the verification notification service
  static void startService(WidgetRef ref) {
    if (_isServiceActive) return;

    _isServiceActive = true;
    debugPrint('🔔 VerificationNotificationService: Service started');

    // Check immediately
    _checkAndShowNotification(ref);

    // Set up periodic checks (every 30 minutes by default)
    _notificationTimer = Timer.periodic(
      const Duration(minutes: 30),
      (timer) => _checkAndShowNotification(ref),
    );
  }

  /// Stop the verification notification service
  static void stopService() {
    if (!_isServiceActive) return;

    _isServiceActive = false;
    _notificationTimer?.cancel();
    _notificationTimer = null;
    debugPrint('🔔 VerificationNotificationService: Service stopped');
  }

  /// Check if user needs verification notification and show it
  static void _checkAndShowNotification(WidgetRef ref) {
    try {
      final authState = ref.read(compatibleAuthProvider);
      final user = authState.user;

      debugPrint(
          '🔔 VerificationNotificationService: Checking user verification status');
      debugPrint('🔔 User: ${user?.id}');
      debugPrint(
          '🔔 Is verified: ${user?.phoneVerified}'); // Use phoneVerified instead of isVerified

      // Only show notification for logged-in, unverified users
      if (user != null && !user.phoneVerified) {
        // Use phoneVerified instead of isVerified
        debugPrint(
            '🔔 VerificationNotificationService: Showing verification notification');

        _showVerificationNotification();
      } else {
        debugPrint(
            '🔔 VerificationNotificationService: User is verified or not logged in, skipping notification');
      }
    } catch (e) {
      debugPrint(
          '🔔 VerificationNotificationService: Error checking verification status: $e');
    }
  }

  /// Show verification notification
  static void _showVerificationNotification() {
    NotificationService.showWarning(
        'يرجى توثيق حسابك لتتمكن من الاشتراك في المؤتمر والفعاليات المصاحبة');
  }

  /// Show account verified notification
  static void showAccountVerifiedNotification() {
    NotificationService.showSuccess(
        'تم توثيق حسابك بنجاح! يمكنك الآن الاشتراك في المؤتمر والفعاليات المصاحبة');
  }

  /// Show account verification rejected notification
  static void showAccountRejectedNotification(String reason) {
    NotificationService.showError('تم رفض طلب توثيق حسابك. السبب: $reason');
  }

  /// Show account under review notification
  static void showAccountUnderReviewNotification() {
    NotificationService.showInfo(
        'تم استلام طلب توثيق حسابك وهو قيد المراجعة من قبل الإدارة');
  }

  /// Update notification settings
  static void updateNotificationSettings({
    required bool isEnabled,
    required int intervalMinutes,
    required String message,
  }) {
    debugPrint('🔔 VerificationNotificationService: Updating settings');
    debugPrint('🔔 Enabled: $isEnabled');
    debugPrint('🔔 Interval: $intervalMinutes minutes');
    debugPrint('🔔 Message: $message');

    // Stop current timer
    _notificationTimer?.cancel();

    if (isEnabled && intervalMinutes > 0) {
      // Start new timer with updated interval
      _notificationTimer = Timer.periodic(
        Duration(minutes: intervalMinutes),
        (timer) => _showCustomVerificationNotification(message),
      );
    }
  }

  /// Show custom verification notification with custom message
  static void _showCustomVerificationNotification(String customMessage) {
    NotificationService.showWarning(customMessage);
  }

  /// Check if service is active
  static bool get isServiceActive => _isServiceActive;

  /// Get current timer interval (for debugging)
  static Duration? get currentInterval {
    return _notificationTimer?.isActive == true
        ? const Duration(minutes: 30) // Default interval
        : null;
  }
}

/// Provider for verification notification service
final verificationNotificationServiceProvider =
    Provider<VerificationNotificationService>((ref) {
  return VerificationNotificationService();
});

/// Provider for verification notification settings
final verificationNotificationSettingsProvider = StateNotifierProvider<
    VerificationNotificationSettingsNotifier,
    VerificationNotificationSettings>((ref) {
  return VerificationNotificationSettingsNotifier();
});

class VerificationNotificationSettings {
  final bool isEnabled;
  final int intervalMinutes;
  final String message;

  const VerificationNotificationSettings({
    this.isEnabled = true,
    this.intervalMinutes = 30,
    this.message = 'يرجى توثيق حسابك',
  });

  VerificationNotificationSettings copyWith({
    bool? isEnabled,
    int? intervalMinutes,
    String? message,
  }) {
    return VerificationNotificationSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'intervalMinutes': intervalMinutes,
      'message': message,
    };
  }

  factory VerificationNotificationSettings.fromJson(Map<String, dynamic> json) {
    return VerificationNotificationSettings(
      isEnabled: json['isEnabled'] ?? true,
      intervalMinutes: json['intervalMinutes'] ?? 30,
      message: json['message'] ?? 'يرجى توثيق حسابك',
    );
  }
}

class VerificationNotificationSettingsNotifier
    extends StateNotifier<VerificationNotificationSettings> {
  VerificationNotificationSettingsNotifier()
      : super(const VerificationNotificationSettings());

  void updateSettings({
    bool? isEnabled,
    int? intervalMinutes,
    String? message,
  }) {
    state = state.copyWith(
      isEnabled: isEnabled,
      intervalMinutes: intervalMinutes,
      message: message,
    );

    // Update the service with new settings
    VerificationNotificationService.updateNotificationSettings(
      isEnabled: state.isEnabled,
      intervalMinutes: state.intervalMinutes,
      message: state.message,
    );
  }

  void loadSettings(Map<String, dynamic> settings) {
    state = VerificationNotificationSettings.fromJson(settings);
  }
}
