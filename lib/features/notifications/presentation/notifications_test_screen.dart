import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notification_provider.dart';
import '../../../services/notification_service.dart';

class NotificationsTestScreen extends ConsumerStatefulWidget {
  const NotificationsTestScreen({super.key});

  @override
  ConsumerState<NotificationsTestScreen> createState() => _NotificationsTestScreenState();
}

class _NotificationsTestScreenState extends ConsumerState<NotificationsTestScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String _statusMessage = 'Ready to test notifications';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading notifications...';
    });

    try {
      final response = await NotificationService.getUserNotifications();
      
      setState(() {
        _notifications = response;
        _statusMessage = 'Loaded ${_notifications.length} notifications';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading notifications: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _sendTestNotification() async {
    setState(() {
      _statusMessage = 'Sending test notification...';
    });

    try {
      await NotificationService.sendTestNotification(
        title: 'Test Notification',
        message: 'This is a test notification sent from the app',
      );
      
      setState(() {
        _statusMessage = 'Test notification sent successfully!';
      });
      
      // Reload notifications after sending
      await _loadNotifications();
    } catch (e) {
      setState(() {
        _statusMessage = 'Error sending notification: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Test'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Message
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withOpacity(0.1),
            child: Text(
              _statusMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Test Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sendTestNotification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Send Test Notification'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadNotifications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reload Notifications'),
                  ),
                ),
              ],
            ),
          ),
          
          // Notifications List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notifications.isEmpty
                    ? const Center(
                        child: Text('No notifications found'),
                      )
                    : ListView.builder(
                        itemCount: _notifications.length,
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: notification.isRead
                                    ? Colors.grey
                                    : AppColors.primary,
                                child: Icon(
                                  notification.isRead
                                      ? Icons.mark_email_read
                                      : Icons.notifications,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: notification.isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.message),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Channels: ${notification.channels.join(', ')} | Status: ${notification.status}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    'Created: ${notification.createdAt}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'read':
                                      try {
                                        await NotificationService.markAsRead(notification.id);
                                        await _loadNotifications();
                                      } catch (e) {
                                        setState(() {
                                          _statusMessage = 'Error marking as read: $e';
                                        });
                                      }
                                      break;
                                    case 'delete':
                                      try {
                                        await NotificationService.deleteNotification(notification.id);
                                        await _loadNotifications();
                                      } catch (e) {
                                        setState(() {
                                          _statusMessage = 'Error deleting notification: $e';
                                        });
                                      }
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  if (!notification.isRead)
                                    const PopupMenuItem(
                                      value: 'read',
                                      child: Text('Mark as Read'),
                                    ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
