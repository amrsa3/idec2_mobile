import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

// Provider for NotificationService (static class - no instance needed)
final notificationServiceProvider = Provider<Type>((ref) {
  return NotificationService;
});

// Provider for notifications list
final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  return await NotificationService.getNotifications();
});

// Provider for unread count
final unreadCountProvider = FutureProvider<int>((ref) async {
  final notifications = await NotificationService.getNotifications();
  return notifications.where((n) => n.isUnread).length;
});

// Provider for notification stats
final notificationStatsProvider = FutureProvider((ref) async {
  final notifications = await NotificationService.getNotifications();
  return {
    'total': notifications.length,
    'unread': notifications.where((n) => n.isUnread).length,
    'read': notifications.where((n) => n.isRead).length,
  };
});
