import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import '../services/notifications_api_service.dart';
import '../models/notification_model.dart';

// Provider for NotificationService (static class - no instance needed)
final notificationServiceProvider = Provider<Type>((ref) {
  return NotificationService;
});

// Provider for notifications list (basic)
final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  return await NotificationService.getNotifications();
});

// Provider for notifications with filtering
final filteredNotificationsProvider = FutureProvider.family<List<NotificationModel>, NotificationFilter>((ref, filter) async {
  return await NotificationsApiService.getNotifications(
    page: filter.page,
    limit: filter.limit,
    category: filter.category,
    type: filter.type,
    priority: filter.priority,
    isRead: filter.isRead,
    searchQuery: filter.searchQuery,
  );
});

// Provider for unread count
final unreadCountProvider = FutureProvider<int>((ref) async {
  final notifications = await NotificationService.getNotifications();
  return notifications.where((n) => n.isUnread).length;
});

// Provider for notification stats
final notificationStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await NotificationsApiService.getNotificationStats();
});

// Provider for search results
final notificationSearchProvider = FutureProvider.family<List<NotificationModel>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }
  return await NotificationsApiService.searchNotifications(query);
});

// Filter class for notifications
class NotificationFilter {
  final int page;
  final int limit;
  final String? category;
  final String? type;
  final String? priority;
  final bool? isRead;
  final String? searchQuery;

  const NotificationFilter({
    this.page = 1,
    this.limit = 20,
    this.category,
    this.type,
    this.priority,
    this.isRead,
    this.searchQuery,
  });

  NotificationFilter copyWith({
    int? page,
    int? limit,
    String? category,
    String? type,
    String? priority,
    bool? isRead,
    String? searchQuery,
  }) {
    return NotificationFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      category: category ?? this.category,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationFilter &&
        other.page == page &&
        other.limit == limit &&
        other.category == category &&
        other.type == type &&
        other.priority == priority &&
        other.isRead == isRead &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    return Object.hash(
      page,
      limit,
      category,
      type,
      priority,
      isRead,
      searchQuery,
    );
  }
}
