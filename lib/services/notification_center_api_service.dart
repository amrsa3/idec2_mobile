import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'enhanced_dio_service_v2.dart';

/// خدمة API للاتصال بـ NotificationCenter API
/// توفر واجهة موحدة لجميع الإشعارات بغض النظر عن القناة
class NotificationCenterApiService {
  /// الحصول على Dio instance مع ضمان التهيئة
  static Future<Dio> get _dio async {
    final dioService = EnhancedDioServiceV2.instance;
    await dioService.initialize();
    return dioService.dio;
  }

  /// جلب إشعارات المستخدم من NotificationCenter
  static Future<Map<String, dynamic>> getUserNotifications({
    int page = 1,
    int limit = 20,
    bool? isRead,
    String? category,
    String? priority,
    String? search,
  }) async {
    try {
      final dio = await _dio;

      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (isRead != null) 'isRead': isRead.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
        if (priority != null && priority.isNotEmpty) 'priority': priority,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      debugPrint('📊 [NOTIFICATION_CENTER] Fetching notifications: $queryParams');

      final response = await dio.get(
        '/api/v1/notification-center',
        queryParameters: queryParams,
      );

      debugPrint('📡 [NOTIFICATION_CENTER] Response status: ${response.statusCode}');
      debugPrint('📡 [NOTIFICATION_CENTER] Response data type: ${response.data.runtimeType}');
      if (response.data is Map) {
        debugPrint('📡 [NOTIFICATION_CENTER] Response keys: ${(response.data as Map).keys.toList()}');
      }

      if (response.statusCode == 200) {
        final data = response.data;

        // Backend returns { notifications: [], pagination: {} } directly (no success field)
        if (data is Map) {
          final notifications = data['notifications'] as List? ?? [];
          final pagination = data['pagination'] as Map? ?? {};
          
          debugPrint('✅ [NOTIFICATION_CENTER] Fetched ${notifications.length} notifications');
          debugPrint('📊 [NOTIFICATION_CENTER] Pagination total: ${pagination['total']}');
          
          return {
            'success': true,
            'notifications': notifications,
            'pagination': pagination,
          };
        } else {
          debugPrint('⚠️ [NOTIFICATION_CENTER] Response data is not a Map: ${data.runtimeType}');
        }
      }

      debugPrint('⚠️ [NOTIFICATION_CENTER] Unexpected response: ${response.statusCode}');
      return {
        'success': false,
        'notifications': [],
        'pagination': {},
        'error': 'استجابة غير متوقعة من الخادم',
      };
    } on DioException catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] DioException: ${e.message}');
      debugPrint('❌ [NOTIFICATION_CENTER] Response: ${e.response?.data}');
      return {
        'success': false,
        'notifications': [],
        'pagination': {},
        'error': e.response?.data?['messageAr'] ?? e.message ?? 'حدث خطأ',
      };
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error: $e');
      return {
        'success': false,
        'notifications': [],
        'pagination': {},
        'error': 'حدث خطأ غير متوقع',
      };
    }
  }

  /// جلب عدد الإشعارات غير المقروءة
  static Future<int> getUnreadCount() async {
    try {
      final dio = await _dio;

      final response = await dio.get('/api/v1/notification-center/unread-count');

      if (response.statusCode == 200) {
        final data = response.data;
        // Backend returns { count: number } directly
        if (data is Map && data['count'] != null) {
          return data['count'] as int;
        }
        // Or might return just the number directly
        if (data is int) {
          return data;
        }
      }

      return 0;
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error getting unread count: $e');
      return 0;
    }
  }

  /// تحديد إشعار كمقروء
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final dio = await _dio;

      final response = await dio.patch(
        '/api/v1/notification-center/$notificationId/read',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Backend might return { success: true } or just status 200
        if (data is Map) {
          return data['success'] == true || data['success'] == null;
        }
        return true; // If status is 200, consider it success
      }

      return false;
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error marking as read: $e');
      return false;
    }
  }

  /// تحديد جميع الإشعارات كمقروءة
  static Future<bool> markAllAsRead() async {
    try {
      final dio = await _dio;

      final response = await dio.patch('/api/v1/notification-center/read-all');

      if (response.statusCode == 200) {
        final data = response.data;
        // Backend might return { success: true } or just status 200
        if (data is Map) {
          return data['success'] == true || data['success'] == null;
        }
        return true; // If status is 200, consider it success
      }

      return false;
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error marking all as read: $e');
      return false;
    }
  }

  /// جلب تفاصيل إشعار مع جميع deliveries
  static Future<Map<String, dynamic>?> getNotificationDetails(String notificationId) async {
    try {
      final dio = await _dio;

      final response = await dio.get('/api/v1/notification-center/$notificationId');

      if (response.statusCode == 200) {
        final data = response.data;
        // Backend might return { success: true, data: {} } or { data: {} } directly
        if (data is Map) {
          if (data['success'] == true && data['data'] != null) {
            return data['data'] as Map<String, dynamic>?;
          }
          // Or might return data directly
          if (data['data'] != null) {
            return data['data'] as Map<String, dynamic>?;
          }
          // Or might return the notification object directly
          if (data['id'] != null) {
            return data as Map<String, dynamic>?;
          }
        }
      }

      return null;
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error getting notification details: $e');
      return null;
    }
  }

  /// حذف إشعار (soft delete)
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final dio = await _dio;

      final response = await dio.delete('/api/v1/notification-center/$notificationId');

      if (response.statusCode == 200) {
        final data = response.data;
        // Backend might return { success: true } or just status 200
        if (data is Map) {
          return data['success'] == true || data['success'] == null;
        }
        return true; // If status is 200, consider it success
      }

      return false;
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error deleting notification: $e');
      return false;
    }
  }

  /// جلب إحصائيات الإشعارات
  static Future<Map<String, dynamic>?> getStatistics() async {
    try {
      final dio = await _dio;

      final response = await dio.get('/api/v1/notification-center/statistics');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>?;
      }

      return null;
    } catch (e) {
      debugPrint('❌ [NOTIFICATION_CENTER] Error getting statistics: $e');
      return null;
    }
  }
}

