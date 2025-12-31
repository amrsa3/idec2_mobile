import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/notification_model.dart';
import '../../../services/notification_center_api_service.dart';

// State for the notification list
class NotificationListState {
  final List<dynamic> notifications; // Dynamic for now as I need to check model compatibility
  final bool isLoading;
  final String? error;
  final int unreadCount;
  final bool hasMore;
  final int page;

  const NotificationListState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
    this.hasMore = true,
    this.page = 1,
  });

  NotificationListState copyWith({
    List<dynamic>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
    bool? hasMore,
    int? page,
  }) {
    return NotificationListState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationListState> {
  NotificationNotifier() : super(const NotificationListState()) {
    loadNotifications(refresh: true);
    refreshUnreadCount();
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (state.isLoading) return;
    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, notifications: [], error: null);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: true);
    }

    try {
      final result = await NotificationCenterApiService.getUserNotifications(
        page: state.page,
        limit: 20,
      );

      if (result['success'] == true) {
        final newNotifications = result['notifications'] as List;
        final pagination = result['pagination'] as Map;
        final total = pagination['total'] as int? ?? 0;
        
        // Update unread count from separate call usually, but maybe we can update locally
        
        state = state.copyWith(
          notifications: refresh 
              ? newNotifications 
              : [...state.notifications, ...newNotifications],
          isLoading: false,
          page: state.page + 1,
          hasMore: (state.notifications.length + newNotifications.length) < total,
        );
      } else {
        state = state.copyWith(isLoading: false, error: result['error']);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshUnreadCount() async {
    final count = await NotificationCenterApiService.getUnreadCount();
    state = state.copyWith(unreadCount: count);
  }

  Future<void> markAsRead(String id) async {
    // Optimistic update
    final index = state.notifications.indexWhere((n) => n['_id'] == id || n['id'] == id);
    if (index != -1) {
      final updatedList = List.from(state.notifications);
      final item = Map<String, dynamic>.from(updatedList[index]);
      if (item['readAt'] == null && item['isRead'] != true) {
         item['readAt'] = DateTime.now().toIso8601String();
         item['isRead'] = true;
         updatedList[index] = item;
         
         state = state.copyWith(
           notifications: updatedList, 
           unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0
         );
      }
    }
    
    await NotificationCenterApiService.markAsRead(id);
    refreshUnreadCount();
  }

  Future<void> markAllAsRead() async {
     // Optimistic update
     final updatedList = state.notifications.map((n) {
       final item = Map<String, dynamic>.from(n);
       item['readAt'] = DateTime.now().toIso8601String();
       item['isRead'] = true;
       return item;
     }).toList();
     
     state = state.copyWith(notifications: updatedList, unreadCount: 0);
     
     await NotificationCenterApiService.markAllAsRead();
  }

  Future<void> deleteNotification(String id) async {
    final updatedList = state.notifications.where((n) => n['_id'] != id && n['id'] != id).toList();
    state = state.copyWith(notifications: updatedList);
    
    await NotificationCenterApiService.deleteNotification(id);
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationListState>((ref) {
  return NotificationNotifier();
});

// A provider just for unread count to be used in badges
final notificationUnreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});
