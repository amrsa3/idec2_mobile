import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String message,
    String? type,
    String? category,
    @Default('unread') String status,
    @Default('normal') String priority,
    String? actionUrl,
    String? actionType,
    Map<String, dynamic>? actionData,
    String? imageUrl,
    String? iconUrl,
    @Default([]) List<String> channels,
    String? templateId,
    Map<String, dynamic>? templateData,
    String? recipientId,
    String? recipientType,
    String? senderId,
    String? senderType,
    DateTime? scheduledAt,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required String userId,
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(true) bool smsNotifications,
    @Default(true) bool inAppNotifications,
    @Default(true) bool eventReminders,
    @Default(true) bool systemUpdates,
    @Default(true) bool marketingEmails,
    @Default(true) bool securityAlerts,
    @Default('all') String frequency,
    @Default([]) List<String> mutedCategories,
    Map<String, dynamic>? preferences,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

@freezed
class NotificationTemplate with _$NotificationTemplate {
  const factory NotificationTemplate({
    required String id,
    required String name,
    required String title,
    required String message,
    String? description,
    String? type,
    String? category,
    @Default([]) List<String> channels,
    @Default('normal') String priority,
    @Default(true) bool isActive,
    Map<String, dynamic>? defaultData,
    List<String>? requiredVariables,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NotificationTemplate;

  factory NotificationTemplate.fromJson(Map<String, dynamic> json) =>
      _$NotificationTemplateFromJson(json);
}

@freezed
class SendNotificationRequest with _$SendNotificationRequest {
  const factory SendNotificationRequest({
    required String templateId,
    required List<String> recipients,
    Map<String, dynamic>? templateData,
    @Default(['in_app']) List<String> channels,
    @Default('normal') String priority,
    DateTime? scheduledAt,
  }) = _SendNotificationRequest;

  factory SendNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$SendNotificationRequestFromJson(json);
}

@freezed
class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    required bool success,
    String? message,
    String? notificationId,
    @Default([]) List<String> sentTo,
    @Default([]) List<String> failedRecipients,
    Map<String, dynamic>? metadata,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}

@freezed
class NotificationStats with _$NotificationStats {
  const factory NotificationStats({
    required int totalNotifications,
    required int unreadCount,
    required int readCount,
    Map<String, int>? categoryStats,
    Map<String, int>? typeStats,
    Map<String, int>? priorityStats,
    DateTime? lastNotificationAt,
    DateTime? lastReadAt,
  }) = _NotificationStats;

  factory NotificationStats.fromJson(Map<String, dynamic> json) =>
      _$NotificationStatsFromJson(json);
}

// Extension for NotificationModel
extension NotificationModelExtension on NotificationModel {
  bool get isRead => status == 'read' || readAt != null;
  bool get isUnread => !isRead;
  bool get isPending => status == 'pending';
  bool get isSent => status == 'sent' || sentAt != null;
  bool get isFailed => status == 'failed';
  
  bool get isHighPriority => priority == 'high' || priority == 'urgent';
  bool get isLowPriority => priority == 'low';
  bool get isNormalPriority => priority == 'normal' || priority == 'medium';
}
