import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import 'push_topics_screen.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'الكل';
  final List<String> _filters = ['الكل', 'مهم', 'تذكير', 'تحديث', 'عام'];
  bool _showUnreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotifications();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'تفضيلات الإشعارات',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PushTopicsScreen(),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'الإشعارات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${notifications.length} إشعار',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'تحديد الكل كمقروء',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter Section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Filter Pills
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isSelected = filter == _selectedFilter;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Toggle Unread Only
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showUnreadOnly = !_showUnreadOnly;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.primary, width: 2),
                            borderRadius: BorderRadius.circular(4),
                            color: _showUnreadOnly
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          child: _showUnreadOnly
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'عرض غير المقروء فقط',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notifications List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (_showUnreadOnly && notifications[index]['read'] == true) {
                  return const SizedBox.shrink();
                }
                if (_selectedFilter != 'الكل' &&
                    notifications[index]['category'] != _selectedFilter) {
                  return const SizedBox.shrink();
                }
                return _buildNotificationCard(context, notifications[index]);
              },
              childCount: notifications.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, Map<String, dynamic> notification) {
    final isUnread = notification['read'] == false;
    final IconData icon;
    final Color iconColor;

    switch (notification['category']) {
      case 'مهم':
        icon = Icons.error_outline;
        iconColor = Colors.red;
        break;
      case 'تذكير':
        icon = Icons.notifications_active;
        iconColor = Colors.orange;
        break;
      case 'تحديث':
        icon = Icons.update;
        iconColor = Colors.blue;
        break;
      default:
        icon = Icons.info_outline;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            isUnread ? Border.all(color: AppColors.primary, width: 2) : null,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Handle notification tap
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.bold : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          notification['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        if (notification['action'] != null) ...[
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              notification['action'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Icons.close,
                    size: 20, color: AppColors.textTertiary),
                onPressed: () {
                  _showDeleteConfirmation(context, notification['id']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حذف الإشعار'),
        content: const Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الإشعار')),
              );
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getNotifications() {
    return [
      {
        'id': 1,
        'title': 'تذكير: دورة قادمة',
        'message': 'دورة تبييض الأسنان ستبدأ خلال ساعة واحدة',
        'category': 'تذكير',
        'read': false,
        'time': 'منذ 5 دقائق',
        'action': 'فتح الدورة',
      },
      {
        'id': 2,
        'title': 'تحديث مهم',
        'message': 'تم تحديث جدول المؤتمر. يرجى مراجعة التغييرات',
        'category': 'مهم',
        'read': false,
        'time': 'منذ 15 دقيقة',
        'action': 'عرض الجدول',
      },
      {
        'id': 3,
        'title': 'تأكيد التسجيل',
        'message': 'تم تأكيد تسجيلك في دورة التقنيات الحديثة بنجاح',
        'category': 'عام',
        'read': true,
        'time': 'منذ ساعة',
      },
      {
        'id': 4,
        'title': 'مقابلة متحدث',
        'message': 'هل تريد مقابلة د. أحمد محمد بعد الجلسة؟',
        'category': 'عام',
        'read': false,
        'time': 'منذ ساعتين',
        'action': 'إرسال طلب',
      },
      {
        'id': 5,
        'title': 'تحديث المكان',
        'message': 'تم نقل الجلسة 2 إلى القاعة الكبرى',
        'category': 'تحديث',
        'read': true,
        'time': 'منذ 3 ساعات',
      },
      {
        'id': 6,
        'title': 'تذكير: ورشة عمل',
        'message': 'ورشة عمل اليدوية تبدأ غداً الساعة 9 صباحاً',
        'category': 'تذكير',
        'read': true,
        'time': 'منذ 5 ساعات',
      },
    ];
  }
}
