import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../services/notification_center_api_service.dart';
import '../../../services/push_notification_service.dart';
import '../widgets/web_notification_permission_card.dart';

/// صفحة إشعارات احترافية وجميلة مع تصميم حديث ومميز
class ProfessionalNotificationsScreen extends StatefulWidget {
  const ProfessionalNotificationsScreen({super.key});

  @override
  State<ProfessionalNotificationsScreen> createState() =>
      _ProfessionalNotificationsScreenState();
}

class _ProfessionalNotificationsScreenState
    extends State<ProfessionalNotificationsScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounceTimer;

  // State variables
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String _searchQuery = '';
  Map<String, dynamic>? _statistics;
  StreamSubscription<Map<String, dynamic>>? _notificationStreamSubscription;

  // Animations
  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);

    // Initialize animations
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    );

    _loadNotifications();
    _loadUnreadCount();
    _loadStatistics();
    _headerAnimationController.forward();
    
    // الاستماع لتحديثات Push Notifications لتحديث الصفحة عند وصول إشعار جديد فقط
    // هذا حل احترافي لا يسبب ضغط على السيرفر
    // إضافة فحص Firebase قبل الاستماع لتجنب الأخطاء في web
    if (kIsWeb) {
      // في web، ننتظر قليلاً للتأكد من أن Firebase مهيأ
      Future.delayed(const Duration(milliseconds: 500), () {
        try {
          _notificationStreamSubscription = PushNotificationService.instance.onNotificationReceived.listen(
            (data) {
              if (mounted) {
                debugPrint('🔄 [NOTIFICATIONS] Push notification received, refreshing notifications page');
                _refresh();
              }
            },
            onError: (error) {
              debugPrint('⚠️ [NOTIFICATIONS] Error listening to notification stream: $error');
            },
          );
        } catch (e) {
          debugPrint('⚠️ [NOTIFICATIONS] Failed to initialize notification stream listener: $e');
          // لا نرمي الخطأ، فقط نسجلها - الصفحة ستعمل بدون push notifications
        }
      });
    } else {
      // في mobile، يمكننا الاستماع مباشرة
      try {
        _notificationStreamSubscription = PushNotificationService.instance.onNotificationReceived.listen(
          (data) {
            if (mounted) {
              debugPrint('🔄 [NOTIFICATIONS] Push notification received, refreshing notifications page');
              _refresh();
            }
          },
          onError: (error) {
            debugPrint('⚠️ [NOTIFICATIONS] Error listening to notification stream: $error');
          },
        );
      } catch (e) {
        debugPrint('⚠️ [NOTIFICATIONS] Failed to initialize notification stream listener: $e');
        // لا نرمي الخطأ، فقط نسجلها - الصفحة ستعمل بدون push notifications
      }
    }
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _notificationStreamSubscription?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
        _loadNotifications();
      }
    });
  }

  Future<void> _loadNotifications() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _notifications = [];
    });

    try {
      final result = await NotificationCenterApiService.getUserNotifications(
        page: _currentPage,
        limit: 20,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (mounted) {
        if (result['success'] == true) {
          final notifications = result['notifications'] as List? ?? [];
          final pagination = result['pagination'] as Map?;

          setState(() {
            _notifications = notifications.cast<Map<String, dynamic>>();
            _hasMore = _notifications.length < (pagination?['total'] ?? 0);
            _isLoading = false;
          });
          _cardAnimationController.forward(from: 0);
          
          debugPrint('✅ [NOTIFICATIONS] Loaded ${_notifications.length} notifications');
        } else {
          final error = result['error'] as String?;
          debugPrint('⚠️ [NOTIFICATIONS] Failed to load: $error');
          
          setState(() {
            _isLoading = false;
          });
          
          if (mounted && error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ $error'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error loading: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ في تحميل الإشعارات: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final result = await NotificationCenterApiService.getUserNotifications(
        page: nextPage,
        limit: 20,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (mounted && result['success'] == true) {
        final notifications = result['notifications'] as List;

        setState(() {
          _currentPage = nextPage;
          _notifications.addAll(notifications.cast<Map<String, dynamic>>());
          _hasMore = _notifications.length < (result['pagination']?['total'] ?? 0);
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error loading more: $e');
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await NotificationCenterApiService.getUnreadCount();
      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error loading unread count: $e');
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await NotificationCenterApiService.getStatistics();
      if (mounted) {
        setState(() {
          _statistics = stats;
        });
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error loading statistics: $e');
    }
  }

  Future<void> _refresh() async {
    HapticFeedback.mediumImpact();
    await Future.wait([
      _loadNotifications(),
      _loadUnreadCount(),
      _loadStatistics(),
    ]);
  }

  Future<void> _markAsRead(String id) async {
    try {
      final success = await NotificationCenterApiService.markAsRead(id);
      if (success) {
        HapticFeedback.lightImpact();
        setState(() {
          final index = _notifications.indexWhere((n) => n['id'] == id);
          if (index != -1) {
            _notifications[index]['isRead'] = true;
            _notifications[index]['readAt'] = DateTime.now().toIso8601String();
          }
        });
        await _loadUnreadCount();
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error marking as read: $e');
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final success = await NotificationCenterApiService.markAllAsRead();
      if (success) {
        HapticFeedback.mediumImpact();
        await _refresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('✅ تم تحديد جميع الإشعارات كمقروءة'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error marking all as read: $e');
    }
  }

  Future<void> _deleteNotification(String id) async {
    try {
      final success = await NotificationCenterApiService.deleteNotification(id);
      if (success) {
        HapticFeedback.mediumImpact();
        setState(() {
          _notifications.removeWhere((n) => n['id'] == id);
        });
        await _loadUnreadCount();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('✅ تم حذف الإشعار'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error deleting: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Beautiful App Bar with Gradient
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: FadeTransition(
              opacity: _headerAnimation,
              child: const Text(
                'الإشعارات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            actions: [
              // Mark all as read button - always visible
              IconButton(
                icon: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mark_email_read, color: Colors.white, size: 20),
                    ),
                    if (_unreadCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              _unreadCount > 99 ? '99+' : '$_unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: _unreadCount > 0 ? _markAllAsRead : null,
                tooltip: 'تحديد الكل كمقروء',
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                ),
                onPressed: _refresh,
                tooltip: 'تحديث',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Statistics Cards with beautiful design
          if (_statistics != null)
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _headerAnimation,
                child: _buildStatisticsCards(),
              ),
            ),

          // Web Notification Permission Card
          if (kIsWeb)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: const WebNotificationPermissionCard(),
              ),
            ),

          // Search Bar with modern design
          SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),

          // Notifications List
          if (_isLoading && _notifications.isEmpty)
            SliverFillRemaining(
              child: _buildSkeletonLoading(),
            )
          else if (_notifications.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == _notifications.length) {
                    return _isLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }

                  final notification = _notifications[index];
                  final previousNotification =
                      index > 0 ? _notifications[index - 1] : null;

                  final showDateSeparator = _shouldShowDateSeparator(
                    notification,
                    previousNotification,
                  );

                  return Column(
                    children: [
                      if (showDateSeparator) _buildDateSeparator(notification),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: _buildNotificationCard(notification, index),
                      ),
                    ],
                  );
                },
                childCount: _notifications.length + (_isLoadingMore ? 1 : 0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    final total = _statistics?['total'] ?? 0;
    final unread = _statistics?['unread'] ?? 0;
    final read = _statistics?['read'] ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'إجمالي',
              total.toString(),
              Icons.notifications_active,
              AppColors.primary,
              const [Color(0xFFD32F2F), Color(0xFFEF5350)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'غير مقروء',
              unread.toString(),
              Icons.mark_email_unread,
              AppColors.warning,
              const [Color(0xFFFF9800), Color(0xFFFFB74D)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'مقروء',
              read.toString(),
              Icons.mark_email_read,
              AppColors.success,
              const [Color(0xFF4CAF50), Color(0xFF81C784)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    List<Color> gradientColors,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '🔍 ابحث في الإشعارات...',
          hintStyle: TextStyle(color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: AppColors.primary),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _loadNotifications();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }


  bool _shouldShowDateSeparator(
    Map<String, dynamic> current,
    Map<String, dynamic>? previous,
  ) {
    if (previous == null) return true;

    final currentDate = _getDate(current['createdAt']);
    final previousDate = _getDate(previous['createdAt']);

    return currentDate != previousDate;
  }

  DateTime _getDate(String? dateString) {
    if (dateString == null) return DateTime.now();
    try {
      final date = DateTime.parse(dateString);
      return DateTime(date.year, date.month, date.day);
    } catch (e) {
      return DateTime.now();
    }
  }

  Widget _buildDateSeparator(Map<String, dynamic> notification) {
    final date = _getDate(notification['createdAt']);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    String dateText;
    IconData icon;
    Color color;
    if (date == today) {
      dateText = 'اليوم';
      icon = Icons.today;
      color = AppColors.primary;
    } else if (date == yesterday) {
      dateText = 'أمس';
      icon = Icons.calendar_today;
      color = AppColors.warning;
    } else {
      dateText = DateFormat('yyyy-MM-dd', 'ar').format(date);
      icon = Icons.calendar_month;
      color = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            dateText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Expanded(child: Divider(color: AppColors.border, height: 1)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final id = notification['id'] as String;
    final title = notification['title'] as String? ?? '';
    final message = notification['message'] as String? ?? '';
    final isRead = notification['isRead'] as bool? ?? false;
    final priority = notification['priority'] as String? ?? 'NORMAL';
    final category = notification['category'] as String? ?? 'system';
    final createdAt = notification['createdAt'] as String?;
    final channelsStatus = notification['channelsStatus'] as Map? ?? {};

    DateTime? createdDate;
    if (createdAt != null) {
      try {
        createdDate = DateTime.parse(createdAt);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }

    final categoryColor = _getCategoryColor(category);
    final categoryGradient = _getCategoryGradient(category);

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      ),
      onDismissed: (direction) {
        _deleteNotification(id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (!isRead) {
                await _markAsRead(id);
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: isRead
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          categoryColor.withOpacity(0.05),
                        ],
                      ),
                color: isRead ? Colors.white : null,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isRead
                      ? AppColors.border
                      : categoryColor.withOpacity(0.3),
                  width: isRead ? 1 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isRead
                        ? Colors.black.withOpacity(0.04)
                        : categoryColor.withOpacity(0.2),
                    blurRadius: isRead ? 8 : 16,
                    offset: Offset(0, isRead ? 2 : 4),
                    spreadRadius: isRead ? 0 : 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Category Icon with Gradient
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: categoryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: categoryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getCategoryIcon(category),
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread indicator
                      if (!isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Message
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  // Footer Row
                  Row(
                    children: [
                      // Priority Badge
                      if (priority != 'NORMAL')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getPriorityColor(priority),
                                _getPriorityColor(priority).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: _getPriorityColor(priority).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _getPriorityLabel(priority),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (priority != 'NORMAL') const SizedBox(width: 8),
                      // Channels Status
                      ...channelsStatus.entries.take(3).map((entry) {
                        return Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _getChannelColor(entry.key).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getChannelIcon(entry.key),
                            size: 16,
                            color: _getChannelColor(entry.key),
                          ),
                        );
                      }),
                      const Spacer(),
                      // Time
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            createdDate != null ? _formatDate(createdDate) : '',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على إشعارات بالفلاتر المحددة',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
            ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
              _loadNotifications();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('تحديث'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'system':
        return AppColors.info;
      case 'registration':
        return AppColors.success;
      case 'payment':
        return AppColors.warning;
      case 'profile':
        return AppColors.primary;
      case 'event':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  LinearGradient _getCategoryGradient(String category) {
    switch (category) {
      case 'system':
        return const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        );
      case 'registration':
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        );
      case 'payment':
        return const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
        );
      case 'profile':
        return const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFFEF5350)],
        );
      case 'event':
        return const LinearGradient(
          colors: [Color(0xFFF44336), Color(0xFFE57373)],
        );
      default:
        return LinearGradient(
          colors: [AppColors.textSecondary, AppColors.textSecondary],
        );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'system':
        return Icons.settings;
      case 'registration':
        return Icons.how_to_reg;
      case 'payment':
        return Icons.payment;
      case 'profile':
        return Icons.person;
      case 'event':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'URGENT':
        return AppColors.error;
      case 'HIGH':
        return AppColors.warning;
      case 'NORMAL':
        return AppColors.info;
      case 'LOW':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'URGENT':
        return 'عاجل';
      case 'HIGH':
        return 'مهم';
      case 'NORMAL':
        return 'عادي';
      case 'LOW':
        return 'منخفض';
      default:
        return priority;
    }
  }

  IconData _getChannelIcon(String channel) {
    switch (channel) {
      case 'SMS':
        return Icons.sms;
      case 'EMAIL':
        return Icons.email;
      case 'WHATSAPP':
        return Icons.chat;
      case 'PUSH':
        return Icons.notifications_active;
      case 'IN_APP':
        return Icons.notifications;
      default:
        return Icons.notifications;
    }
  }

  Color _getChannelColor(String channel) {
    switch (channel) {
      case 'SMS':
        return AppColors.success;
      case 'EMAIL':
        return AppColors.info;
      case 'WHATSAPP':
        return const Color(0xFF25D366);
      case 'PUSH':
        return AppColors.warning;
      case 'IN_APP':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return DateFormat('yyyy-MM-dd HH:mm', 'ar').format(date);
    }
  }
}
