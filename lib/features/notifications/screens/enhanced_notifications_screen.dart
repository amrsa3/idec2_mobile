import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';
import '../../../services/notification_service.dart';
import '../../../services/notifications_api_service.dart';
import '../widgets/rich_notification_card.dart';
import '../widgets/web_notification_permission_card.dart';

/// شاشة الإشعارات المحسّنة مع دعم Rich Notifications
class EnhancedNotificationsScreen extends ConsumerStatefulWidget {
  const EnhancedNotificationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnhancedNotificationsScreen> createState() =>
      _EnhancedNotificationsScreenState();
}

class _EnhancedNotificationsScreenState
    extends ConsumerState<EnhancedNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _filteredNotifications = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, unread, read
  String _searchQuery = '';
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await NotificationsApiService.getNotifications(
        limit: 100,
        offset: 0,
      );

      setState(() {
        _notifications = notifications;
        _filteredNotifications = notifications;
        _unreadCount = notifications.where((n) => !n.isRead).length;
        _isLoading = false;
      });

      _applyFilters();
    } catch (error) {
      debugPrint('❌ [NOTIFICATIONS] Error loading: $error');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        NotificationService.showError(
          title: 'خطأ',
          message: 'حدث خطأ أثناء تحميل الإشعارات',
        );
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredNotifications = _notifications.where((notification) {
        // Filter by read status
        if (_selectedFilter == 'unread' && notification.isRead) {
          return false;
        }
        if (_selectedFilter == 'read' && !notification.isRead) {
          return false;
        }

        // Filter by tab (notification type)
        final currentTab = _tabController.index;
        if (currentTab == 1 && notification.type != 'registration') {
          return false;
        }
        if (currentTab == 2 && notification.type != 'payment') {
          return false;
        }
        if (currentTab == 3 && notification.type != 'event') {
          return false;
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return notification.title.toLowerCase().contains(query) ||
              notification.message.toLowerCase().contains(query);
        }

        return true;
      }).toList();
    });
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    try {
      await NotificationsApiService.markAsRead(notification.id);

      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = notification.copyWith(isRead: true);
        }
        _unreadCount = _notifications.where((n) => !n.isRead).length;
      });

      _applyFilters();
    } catch (error) {
      debugPrint('❌ [NOTIFICATIONS] Error marking as read: $error');
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await NotificationsApiService.markAllAsRead();

      setState(() {
        _notifications = _notifications
            .map((n) => n.copyWith(isRead: true))
            .toList();
        _unreadCount = 0;
      });

      _applyFilters();

      if (mounted) {
        NotificationService.showSuccess(
          title: 'تم',
          message: 'تم تحديد جميع الإشعارات كمقروءة',
        );
      }
    } catch (error) {
      debugPrint('❌ [NOTIFICATIONS] Error marking all as read: $error');
      if (mounted) {
        NotificationService.showError(
          title: 'خطأ',
          message: 'حدث خطأ أثناء تحديد الإشعارات كمقروءة',
        );
      }
    }
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    try {
      await NotificationsApiService.deleteNotification(notification.id);

      setState(() {
        _notifications.removeWhere((n) => n.id == notification.id);
        if (!notification.isRead) {
          _unreadCount--;
        }
      });

      _applyFilters();

      if (mounted) {
        NotificationService.showSuccess(
          title: 'تم',
          message: 'تم حذف الإشعار',
        );
      }
    } catch (error) {
      debugPrint('❌ [NOTIFICATIONS] Error deleting: $error');
      if (mounted) {
        NotificationService.showError(
          title: 'خطأ',
          message: 'حدث خطأ أثناء حذف الإشعار',
        );
      }
    }
  }

  void _handleNotificationTap(NotificationModel notification) {
    _markAsRead(notification);

    // Handle deep linking based on notification type
    if (notification.data != null) {
      final data = notification.data as Map<String, dynamic>;
      final actionType = data['actionType'] as String?;

      if (actionType != null) {
        _handleActionNavigation(actionType, data);
      }
    }
  }

  void _handleActionNavigation(String actionType, Map<String, dynamic> data) {
    switch (actionType) {
      case 'VIEW_REGISTRATION':
        if (data['registrationId'] != null) {
          context.push('/registration/${data['registrationId']}');
        }
        break;
      case 'VIEW_EVENT':
        if (data['eventId'] != null) {
          context.push('/event/${data['eventId']}');
        }
        break;
      case 'VIEW_PAYMENT':
        if (data['paymentId'] != null) {
          context.push('/payment/${data['paymentId']}');
        }
        break;
      case 'VIEW_PROFILE':
        context.push('/profile');
        break;
      default:
        debugPrint('⚠️ [NOTIFICATIONS] Unknown action type: $actionType');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Text('الإشعارات'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          // Mark all as read
          if (_unreadCount > 0)
            IconButton(
              icon: Icon(Icons.done_all),
              onPressed: _markAllAsRead,
              tooltip: 'تحديد الكل كمقروء',
            ),
          // Filter menu
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
              _applyFilters();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive,
                        color: _selectedFilter == 'all'
                            ? AppColors.primary
                            : null),
                    const SizedBox(width: 8),
                    Text('الكل'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'unread',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_unread,
                        color: _selectedFilter == 'unread'
                            ? AppColors.primary
                            : null),
                    const SizedBox(width: 8),
                    Text('غير المقروء'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read,
                        color: _selectedFilter == 'read'
                            ? AppColors.primary
                            : null),
                    const SizedBox(width: 8),
                    Text('المقروء'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث في الإشعارات...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _applyFilters();
                  },
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                onTap: (_) => _applyFilters(),
                tabs: [
                  Tab(text: 'الكل'),
                  Tab(text: 'التسجيلات'),
                  Tab(text: 'المدفوعات'),
                  Tab(text: 'الفعاليات'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: Column(
          children: [
            // Web Permission Card
            if (kIsWeb) WebNotificationPermissionCard(),

            // Notifications List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredNotifications.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = _filteredNotifications[index];
                            return RichNotificationCard(
                              notification: notification,
                              onTap: () => _handleNotificationTap(notification),
                              onDismiss: () => _deleteNotification(notification),
                              onActionTap: _handleActionNavigation,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر إشعاراتك هنا',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}



