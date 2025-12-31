import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_colors.dart';
import '../providers/notification_provider.dart';
import 'push_topics_screen.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'الكل';
  final List<String> _filters = ['الكل', 'مهم', 'تذكير', 'تحديث', 'عام'];
  bool _showUnreadOnly = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ar', ArMessages()); // Register Arabic locale
    _scrollController.addListener(_onScroll);
    // Refresh notifications on enter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider.notifier).loadNotifications(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationProvider.notifier).loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notificationState = ref.watch(notificationProvider);
    final notifications = notificationState.notifications;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(notificationProvider.notifier).loadNotifications(refresh: true);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 160,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              actions: [
                IconButton(
                  icon: Icon(Icons.tune),
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
                          Text(
                            l10n.notifications,
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
                                onTap: () {
                                  ref.read(notificationProvider.notifier).markAllAsRead();
                                },
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
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.shadow,
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
                                    : context.colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : context.colors.textPrimary,
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
                                ? Icon(Icons.check,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'عرض غير المقروء فقط',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.colors.textPrimary,
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
            if (notificationState.isLoading && notifications.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (notifications.isEmpty)
               const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('لا توجد إشعارات', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= notifications.length) {
                       return notificationState.isLoading ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())) : const SizedBox.shrink();
                    }
                    
                    final notification = notifications[index];
                    final isRead = notification['readAt'] != null || notification['isRead'] == true;
                    // Filter logic
                    if (_showUnreadOnly && isRead) {
                      return const SizedBox.shrink();
                    }
                     // TODO: Add Category filtering if backend supports it in list or map client side
                    // if (_selectedFilter != l10n.allNotifications && notification['category'] != _selectedFilter) {
                    //   return const SizedBox.shrink();
                    // }

                    return _buildNotificationCard(context, notification);
                  },
                  childCount: notifications.length + (notificationState.isLoading ? 1 : 0),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, dynamic notification) {
    if (notification is! Map) return const SizedBox.shrink();

    final isRead = notification['readAt'] != null || notification['isRead'] == true;
    final title = notification['title'] ?? 'إشعار جديد';
    final message = notification['body'] ?? notification['message'] ?? '';
    final createdAt = notification['createdAt'] != null 
        ? DateTime.tryParse(notification['createdAt'].toString()) 
        : DateTime.now();
    final timeStr = createdAt != null ? timeago.format(createdAt, locale: 'ar') : '';
    final id = notification['_id']?.toString() ?? notification['id']?.toString() ?? '';

    // Determine category styling
    final category = notification['type'] ?? 'general';
    final IconData icon;
    final Color iconColor;

    if (category.toString().contains('alert') || title.toString().contains('مهم')) {
        icon = Icons.error_outline;
        iconColor = Colors.red;
    } else if (category.toString().contains('reminder')) {
        icon = Icons.notifications_active;
        iconColor = Colors.orange;
    } else {
        icon = Icons.info_outline;
        iconColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: isRead ? context.colors.card : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: isRead ? null : Border.all(color: AppColors.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          ref.read(notificationProvider.notifier).markAsRead(id);
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
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  !isRead ? FontWeight.bold : FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead)
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
                      message,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 4),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                icon: Icon(Icons.close,
                    size: 20, color: context.colors.textTertiary),
                onPressed: () {
                   _showDeleteConfirmation(context, id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('حذف الإشعار'),
        content: Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(notificationProvider.notifier).deleteNotification(id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الإشعار')),
              );
            },
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ArMessages implements timeago.LookupMessages {
  @override String prefixAgo() => 'منذ';
  @override String prefixFromNow() => 'بعد';
  @override String suffixAgo() => '';
  @override String suffixFromNow() => '';
  @override String lessThanOneMinute(int seconds) => 'الآن';
  @override String aboutAMinute(int minutes) => 'دقيقة';
  @override String minutes(int minutes) => '$minutes دقائق';
  @override String aboutAnHour(int minutes) => 'ساعة';
  @override String hours(int hours) => '$hours ساعات';
  @override String aDay(int hours) => 'يوم';
  @override String days(int days) => '$days أيام';
  @override String aboutAMonth(int days) => 'شهر';
  @override String months(int months) => '$months أشهر';
  @override String aboutAYear(int year) => 'سنة';
  @override String years(int years) => '$years سنوات';
  @override String wordSeparator() => ' ';
}
