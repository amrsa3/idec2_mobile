import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/notification_model.dart';
import '../../services/notification_router_service.dart';
import 'app_router.dart';

/// Service for handling deep links from notifications
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final _routerService = NotificationRouterService();

  /// Handle deep link from notification
  Future<void> handleNotificationDeepLink(
    BuildContext context,
    NotificationModel notification,
  ) async {
    try {
      if (notification.actionType != null && notification.actionData != null) {
        await _routerService.navigateFromNotification(context, notification);
      } else {
        debugPrint('⚠️ [DEEP_LINK] Notification has no actionType or actionData');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [DEEP_LINK] Error handling notification deep link: $e');
      debugPrint('$stackTrace');
    }
  }

  /// Handle deep link from push notification data
  Future<void> handlePushDataDeepLink(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    try {
      await _routerService.navigateFromPushData(context, data);
    } catch (e, stackTrace) {
      debugPrint('❌ [DEEP_LINK] Error handling push data deep link: $e');
      debugPrint('$stackTrace');
    }
  }

  /// Handle deep link from URL
  Future<void> handleUrlDeepLink(
    BuildContext context,
    String url,
  ) async {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      final params = uri.queryParameters;

      // Parse path to determine route
      if (path.startsWith('/event/')) {
        final eventId = path.split('/event/')[1];
        if (eventId.isNotEmpty) {
          context.push('/event/$eventId');
          return;
        }
      }

      if (path.startsWith('/registration/')) {
        final registrationId = path.split('/registration/')[1];
        if (registrationId.isNotEmpty) {
          context.push('/registration/$registrationId');
          return;
        }
      }

      if (path.startsWith('/conference/')) {
        final conferenceId = path.split('/conference/')[1];
        if (conferenceId.isNotEmpty) {
          context.push('/conference/$conferenceId');
          return;
        }
      }

      if (path.startsWith('/payment/')) {
        final transactionId = path.split('/payment/')[1];
        if (transactionId.isNotEmpty) {
          context.push('/payment/$transactionId');
          return;
        }
      }

      if (path == '/profile') {
        context.push(AppRoutes.profile);
        return;
      }

      debugPrint('⚠️ [DEEP_LINK] Unknown URL path: $path');
    } catch (e, stackTrace) {
      debugPrint('❌ [DEEP_LINK] Error handling URL deep link: $e');
      debugPrint('$stackTrace');
    }
  }

  /// Handle deep link from action type and data
  Future<void> handleActionDeepLink(
    BuildContext context,
    String actionType,
    Map<String, dynamic>? actionData,
  ) async {
    try {
      final notification = NotificationModel(
        id: '',
        title: '',
        message: '',
        actionType: actionType,
        actionData: actionData,
        createdAt: DateTime.now(),
      );

      await handleNotificationDeepLink(context, notification);
    } catch (e, stackTrace) {
      debugPrint('❌ [DEEP_LINK] Error handling action deep link: $e');
      debugPrint('$stackTrace');
    }
  }
}


