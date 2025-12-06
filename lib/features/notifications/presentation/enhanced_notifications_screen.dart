import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../services/system_message_deliveries_api_service.dart';
import '../../settings/widgets/web_notification_permission_card.dart';

/// شاشة إشعارات محسّنة - تعرض الرسائل من system_message_deliveries
class EnhancedNotificationsScreen extends ConsumerStatefulWidget {
  const EnhancedNotificationsScreen({super.key});

  @override
  ConsumerState<EnhancedNotificationsScreen> createState() =>
      _EnhancedNotificationsScreenState();
}

class _EnhancedNotificationsScreenState
    extends ConsumerState<EnhancedNotificationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _selectedChannel = 'الكل';
  String _selectedCategory = 'الكل';
  String _selectedPriority = 'الكل';
  bool _showUnreadOnly = false;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Timer? _searchDebounceTimer;
  
  List<Map<String, dynamic>> _deliveries = [];
  int _unreadCount = 0;
  int _totalCount = 0;

  final List<String> _channels = [
    'الكل',
    'PUSH',
    'EMAIL',
    'SMS',
    'WHATSAPP',
  ];

  final Map<String, String> _channelLabels = {
    'الكل': 'الكل',
    'PUSH': 'إشعارات فورية',
    'EMAIL': 'بريد إلكتروني',
    'SMS': 'رسائل نصية',
    'WHATSAPP': 'واتساب',
  };

  final List<String> _categories = [
    'الكل',
    'registration',
    'conference',
    'profile',
    'payment',
    'system',
  ];

  final Map<String, String> _categoryLabels = {
    'الكل': 'الكل',
    'registration': 'التسجيلات',
    'conference': 'المؤتمرات',
    'profile': 'الملف الشخصي',
    'payment': 'المدفوعات',
    'system': 'النظام',
  };

  final List<String> _priorities = [
    'الكل',
    'URGENT',
    'HIGH',
    'NORMAL',
    'LOW',
  ];

  final Map<String, String> _priorityLabels = {
    'الكل': 'الكل',
    'URGENT': 'عاجل',
    'HIGH': 'مهم',
    'NORMAL': 'عادي',
    'LOW': 'منخفض',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadDeliveries();
    _loadUnreadCount();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  Future<void> _loadDeliveries() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _deliveries = [];
    });

    try {
      final result = await SystemMessageDeliveriesApiService.getAllDeliveries(
        page: _currentPage,
        limit: 20,
        channel: _selectedChannel == 'الكل' ? null : _selectedChannel,
        category: _selectedCategory == 'الكل' ? null : _selectedCategory,
        priority: _selectedPriority == 'الكل' ? null : _selectedPriority,
        isRead: _showUnreadOnly ? false : null,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (mounted && result['success'] == true) {
        final data = result['data'] as List;
        final pagination = result['pagination'] as Map?;

        setState(() {
          _deliveries = data.cast<Map<String, dynamic>>();
          _totalCount = pagination?['total'] ?? 0;
          _hasMore = _deliveries.length < _totalCount;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error loading deliveries: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
      final result = await SystemMessageDeliveriesApiService.getAllDeliveries(
        page: nextPage,
        limit: 20,
        channel: _selectedChannel == 'الكل' ? null : _selectedChannel,
        category: _selectedCategory == 'الكل' ? null : _selectedCategory,
        priority: _selectedPriority == 'الكل' ? null : _selectedPriority,
        isRead: _showUnreadOnly ? false : null,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );

      if (mounted && result['success'] == true) {
        final data = result['data'] as List;

        setState(() {
          _currentPage = nextPage;
          _deliveries.addAll(data.cast<Map<String, dynamic>>());
          _hasMore = _deliveries.length < _totalCount;
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
      final count = await SystemMessageDeliveriesApiService.getUnreadCount(
        channel: _selectedChannel == 'الكل' ? null : _selectedChannel,
      );
      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error loading unread count: $e');
    }
  }

  Future<void> _refresh() async {
    await _loadDeliveries();
    await _loadUnreadCount();
  }

  Future<void> _markAsRead(String id) async {
    try {
      final success = await SystemMessageDeliveriesApiService.markAsRead(id);
      if (success) {
        setState(() {
          final index = _deliveries.indexWhere((d) => d['id'] == id);
          if (index != -1) {
            _deliveries[index]['isRead'] = true;
            _deliveries[index]['readAt'] = DateTime.now().toIso8601String();
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
      final success = await SystemMessageDeliveriesApiService.markAllAsRead(
        channel: _selectedChannel == 'الكل' ? null : _selectedChannel,
      );
      if (success) {
        await _refresh();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ تم تحديد جميع الرسائل كمقروءة'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS] Error marking all as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('الإشعارات${_unreadCount > 0 ? ' ($_unreadCount)' : ''}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Mark all as read
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _unreadCount > 0 ? _markAllAsRead : null,
            tooltip: 'تحديد الكل كمقروء',
          ),
          // Refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Column(
        children: [
          // Web Notification Permission Card
          if (kIsWeb) const WebNotificationPermissionCard(),
          
          // Channel Filter (Tabs)
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: _channels.map((channel) {
                  final isSelected = _selectedChannel == channel;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(_channelLabels[channel] ?? channel),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedChannel = channel;
                          });
                          _refresh();
                        }
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث في الرسائل...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          _refresh();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _searchDebounceTimer?.cancel();
                _searchDebounceTimer = Timer(const Duration(milliseconds: 800), () {
                  if (_searchController.text == value && mounted) {
                    _refresh();
                  }
                });
              },
            ),
          ),

          // Filters Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Priority Filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'الأولوية',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _priorities.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(_priorityLabels[priority] ?? priority),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPriority = value;
                        });
                        _refresh();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Unread Only Toggle
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: _showUnreadOnly,
                  onChanged: (value) {
                    setState(() {
                      _showUnreadOnly = value ?? false;
                    });
                    _refresh();
                  },
                  activeColor: AppColors.primary,
                ),
                const Text('غير المقروءة فقط'),
              ],
            ),
          ),

          const Divider(height: 1),

          // Deliveries List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _deliveries.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _deliveries.length + (_isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _deliveries.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final delivery = _deliveries[index];
                            return _buildDeliveryCard(delivery);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد رسائل',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على رسائل بالفلاتر المحددة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(Map<String, dynamic> delivery) {
    final id = delivery['id'] as String;
    final messageAr = delivery['messageAr'] as String? ?? '';
    final messageEn = delivery['messageEn'] as String? ?? '';
    final channel = delivery['channel'] as String? ?? 'IN_APP';
    final status = delivery['status'] as String? ?? 'SENT';
    final isRead = delivery['isRead'] as bool? ?? false;
    final priority = delivery['priority'] as String? ?? 'NORMAL';
    final category = delivery['category'] as String? ?? 'system';
    final createdAt = delivery['createdAt'] as String?;
    final readAt = delivery['readAt'] as String?;

    DateTime? createdDate;
    if (createdAt != null) {
      try {
        createdDate = DateTime.parse(createdAt);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead ? Colors.grey[300]! : AppColors.primary.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: () async {
          if (!isRead) {
            await _markAsRead(id);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Channel Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getChannelColor(channel).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _channelLabels[channel] ?? channel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getChannelColor(channel),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Priority Badge
                  if (priority != 'NORMAL')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _priorityLabels[priority] ?? priority,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(priority),
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Unread indicator
                  if (!isRead)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                messageAr.isNotEmpty ? messageAr : messageEn,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              // Footer Row
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    createdDate != null ? _formatDate(createdDate) : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  // Status
                  Text(
                    status == 'SENT' ? 'مرسل' : status,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getChannelColor(String channel) {
    switch (channel) {
      case 'IN_APP':
        return AppColors.primary;
      case 'PUSH':
        return Colors.orange;
      case 'EMAIL':
        return Colors.blue;
      case 'SMS':
        return Colors.green;
      case 'WHATSAPP':
        return const Color(0xFF25D366);
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'URGENT':
        return AppColors.error;
      case 'HIGH':
        return Colors.orange;
      case 'NORMAL':
        return Colors.blue;
      case 'LOW':
        return Colors.grey;
      default:
        return Colors.grey;
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
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    }
  }
}
