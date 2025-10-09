// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String?,
      category: json['category'] as String?,
      status: json['status'] as String? ?? 'unread',
      priority: json['priority'] as String? ?? 'normal',
      actionUrl: json['actionUrl'] as String?,
      actionType: json['actionType'] as String?,
      actionData: json['actionData'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
      iconUrl: json['iconUrl'] as String?,
      channels: (json['channels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      templateId: json['templateId'] as String?,
      templateData: json['templateData'] as Map<String, dynamic>?,
      recipientId: json['recipientId'] as String?,
      recipientType: json['recipientType'] as String?,
      senderId: json['senderId'] as String?,
      senderType: json['senderType'] as String?,
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'category': instance.category,
      'status': instance.status,
      'priority': instance.priority,
      'actionUrl': instance.actionUrl,
      'actionType': instance.actionType,
      'actionData': instance.actionData,
      'imageUrl': instance.imageUrl,
      'iconUrl': instance.iconUrl,
      'channels': instance.channels,
      'templateId': instance.templateId,
      'templateData': instance.templateData,
      'recipientId': instance.recipientId,
      'recipientType': instance.recipientType,
      'senderId': instance.senderId,
      'senderType': instance.senderType,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$NotificationSettingsImpl _$$NotificationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingsImpl(
      userId: json['userId'] as String,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? true,
      inAppNotifications: json['inAppNotifications'] as bool? ?? true,
      eventReminders: json['eventReminders'] as bool? ?? true,
      systemUpdates: json['systemUpdates'] as bool? ?? true,
      marketingEmails: json['marketingEmails'] as bool? ?? true,
      securityAlerts: json['securityAlerts'] as bool? ?? true,
      frequency: json['frequency'] as String? ?? 'all',
      mutedCategories: (json['mutedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferences: json['preferences'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationSettingsImplToJson(
        _$NotificationSettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'smsNotifications': instance.smsNotifications,
      'inAppNotifications': instance.inAppNotifications,
      'eventReminders': instance.eventReminders,
      'systemUpdates': instance.systemUpdates,
      'marketingEmails': instance.marketingEmails,
      'securityAlerts': instance.securityAlerts,
      'frequency': instance.frequency,
      'mutedCategories': instance.mutedCategories,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$NotificationTemplateImpl _$$NotificationTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      description: json['description'] as String?,
      type: json['type'] as String?,
      category: json['category'] as String?,
      channels: (json['channels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      priority: json['priority'] as String? ?? 'normal',
      isActive: json['isActive'] as bool? ?? true,
      defaultData: json['defaultData'] as Map<String, dynamic>?,
      requiredVariables: (json['requiredVariables'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationTemplateImplToJson(
        _$NotificationTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'message': instance.message,
      'description': instance.description,
      'type': instance.type,
      'category': instance.category,
      'channels': instance.channels,
      'priority': instance.priority,
      'isActive': instance.isActive,
      'defaultData': instance.defaultData,
      'requiredVariables': instance.requiredVariables,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$SendNotificationRequestImpl _$$SendNotificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendNotificationRequestImpl(
      templateId: json['templateId'] as String,
      recipients: (json['recipients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      templateData: json['templateData'] as Map<String, dynamic>?,
      channels: (json['channels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['in_app'],
      priority: json['priority'] as String? ?? 'normal',
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
    );

Map<String, dynamic> _$$SendNotificationRequestImplToJson(
        _$SendNotificationRequestImpl instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'recipients': instance.recipients,
      'templateData': instance.templateData,
      'channels': instance.channels,
      'priority': instance.priority,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
    };

_$NotificationResponseImpl _$$NotificationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
      notificationId: json['notificationId'] as String?,
      sentTo: (json['sentTo'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      failedRecipients: (json['failedRecipients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NotificationResponseImplToJson(
        _$NotificationResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'notificationId': instance.notificationId,
      'sentTo': instance.sentTo,
      'failedRecipients': instance.failedRecipients,
      'metadata': instance.metadata,
    };

_$NotificationStatsImpl _$$NotificationStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationStatsImpl(
      totalNotifications: (json['totalNotifications'] as num).toInt(),
      unreadCount: (json['unreadCount'] as num).toInt(),
      readCount: (json['readCount'] as num).toInt(),
      categoryStats: (json['categoryStats'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      typeStats: (json['typeStats'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      priorityStats: (json['priorityStats'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      lastNotificationAt: json['lastNotificationAt'] == null
          ? null
          : DateTime.parse(json['lastNotificationAt'] as String),
      lastReadAt: json['lastReadAt'] == null
          ? null
          : DateTime.parse(json['lastReadAt'] as String),
    );

Map<String, dynamic> _$$NotificationStatsImplToJson(
        _$NotificationStatsImpl instance) =>
    <String, dynamic>{
      'totalNotifications': instance.totalNotifications,
      'unreadCount': instance.unreadCount,
      'readCount': instance.readCount,
      'categoryStats': instance.categoryStats,
      'typeStats': instance.typeStats,
      'priorityStats': instance.priorityStats,
      'lastNotificationAt': instance.lastNotificationAt?.toIso8601String(),
      'lastReadAt': instance.lastReadAt?.toIso8601String(),
    };
