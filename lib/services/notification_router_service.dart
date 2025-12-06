import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';
import '../models/notification_model.dart';

/// Service for routing notifications to appropriate screens
class NotificationRouterService {
  static final NotificationRouterService _instance = NotificationRouterService._internal();
  factory NotificationRouterService() => _instance;
  NotificationRouterService._internal();

  /// Navigate to screen based on notification action
  Future<void> navigateFromNotification(
    BuildContext context,
    NotificationModel notification,
  ) async {
    try {
      final actionType = notification.actionType;
      final actionData = notification.actionData;

      if (actionType == null || actionData == null) {
        debugPrint('⚠️ [NOTIFICATION_ROUTER] No actionType or actionData in notification');
        return;
      }

      switch (actionType) {
        case 'VIEW_REGISTRATION':
          final registrationId = actionData['registrationId'] as String?;
          if (registrationId != null) {
            context.push('/registration/$registrationId');
            debugPrint('🔄 [NOTIFICATION_ROUTER] Navigating to registration: $registrationId');
          }
          break;

        case 'VIEW_EVENT':
          final eventId = actionData['eventId'] as String?;
          if (eventId != null) {
            context.push('/event/$eventId');
            debugPrint('🔄 [NOTIFICATION_ROUTER] Navigating to event: $eventId');
          }
          break;

        case 'VIEW_CONFERENCE':
          final conferenceId = actionData['conferenceId'] as String?;
          if (conferenceId != null) {
            context.push('/conference/$conferenceId');
            debugPrint('🔄 [NOTIFICATION_ROUTER] Navigating to conference: $conferenceId');
          }
          break;

        case 'VIEW_PROFILE':
          context.push(AppRoutes.profile);
          debugPrint('🔄 [NOTIFICATION_ROUTER] Navigating to profile');
          break;

        case 'VIEW_PAYMENT':
          final transactionId = actionData['transactionId'] as String?;
          final registrationId = actionData['registrationId'] as String?;
          if (transactionId != null) {
            context.push('/payment/$transactionId');
            debugPrint('🔄 [NOTIFICATION_ROUTER] Navigating to payment: $transactionId');
          } else if (registrationId != null) {
            // Navigate to registration which contains payment info
            context.push('/registration/$registrationId');
            debugPrint('🔄 [NOTIFICATION_ROUTER] Navigating to registration for payment: $registrationId');
          }
          break;

        default:
          debugPrint('⚠️ [NOTIFICATION_ROUTER] Unknown actionType: $actionType');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [NOTIFICATION_ROUTER] Error navigating from notification: $e');
      debugPrint('$stackTrace');
    }
  }

  /// Navigate from push notification data
  Future<void> navigateFromPushData(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      final actionType = data['actionType'] as String?;
      if (actionType == null) {
        // Try to infer from available IDs
        if (data.containsKey('registrationId')) {
          final registrationId = data['registrationId'] as String?;
          if (registrationId != null) {
            context.push('/registration/$registrationId');
            return;
          }
        }
        if (data.containsKey('eventId')) {
          final eventId = data['eventId'] as String?;
          if (eventId != null) {
            context.push('/event/$eventId');
            return;
          }
        }
        if (data.containsKey('conferenceId')) {
          final conferenceId = data['conferenceId'] as String?;
          if (conferenceId != null) {
            context.push('/conference/$conferenceId');
            return;
          }
        }
        if (data.containsKey('transactionId')) {
          final transactionId = data['transactionId'] as String?;
          if (transactionId != null) {
            context.push('/payment/$transactionId');
            return;
          }
        }
        debugPrint('⚠️ [NOTIFICATION_ROUTER] No actionType or IDs in push data');
        return;
      }

      // Parse actionData if it's a string (JSON)
      Map<String, dynamic>? actionData;
      if (data.containsKey('actionData')) {
        final actionDataValue = data['actionData'];
        if (actionDataValue is Map) {
          actionData = actionDataValue as Map<String, dynamic>;
        } else if (actionDataValue is String) {
          try {
            actionData = Map<String, dynamic>.from(
              jsonDecode(actionDataValue) as Map,
            );
          } catch (e) {
            debugPrint('⚠️ [NOTIFICATION_ROUTER] Failed to parse actionData: $e');
          }
        }
      }

      // Create a temporary notification model for routing
      final notification = NotificationModel(
        id: '',
        title: '',
        message: '',
        actionType: actionType,
        actionData: actionData ?? data,
        createdAt: DateTime.now(),
      );

      await navigateFromNotification(context, notification);
    } catch (e, stackTrace) {
      debugPrint('❌ [NOTIFICATION_ROUTER] Error navigating from push data: $e');
      debugPrint('$stackTrace');
    }
  }
}

