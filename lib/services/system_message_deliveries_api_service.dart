import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'enhanced_dio_service_v2.dart';

/// خدمة API لجلب رسائل النظام (system_message_deliveries)
/// هذا هو الجدول الرئيسي للإشعارات والرسائل
class SystemMessageDeliveriesApiService {
  /// الحصول على Dio instance مع ضمان التهيئة
  static Future<Dio> get _dio async {
    final dioService = EnhancedDioServiceV2.instance;
    await dioService.initialize();
    return dioService.dio;
  }

  /// جلب جميع الرسائل IN_APP (للعرض في صفحة الإشعارات)
  static Future<Map<String, dynamic>> getInAppDeliveries({
    int page = 1,
    int limit = 20,
    String? category,
    String? priority,
    bool? isRead,
    String? search,
  }) async {
    try {
      final dio = await _dio;

      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
        if (priority != null && priority.isNotEmpty) 'priority': priority,
        if (isRead != null) 'isRead': isRead.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      debugPrint('📊 [SYSTEM_MESSAGE_API] Fetching IN_APP deliveries: $queryParams');

      final response = await dio.get(
        '/api/v1/system-message-deliveries/in-app',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['success'] == true) {
          debugPrint('✅ [SYSTEM_MESSAGE_API] Fetched ${(data['data'] as List?)?.length ?? 0} deliveries');
          return {
            'success': true,
            'data': data['data'] ?? [],
            'pagination': data['pagination'] ?? {},
          };
        }
      }

      debugPrint('⚠️ [SYSTEM_MESSAGE_API] Unexpected response: ${response.statusCode}');
      return {
        'success': false,
        'data': [],
        'pagination': {},
      };
    } on DioException catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] DioException: ${e.message}');
      debugPrint('❌ [SYSTEM_MESSAGE_API] Response: ${e.response?.data}');
      return {
        'success': false,
        'data': [],
        'pagination': {},
        'error': e.response?.data?['messageAr'] ?? e.message ?? 'حدث خطأ',
      };
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error: $e');
      return {
        'success': false,
        'data': [],
        'pagination': {},
        'error': 'حدث خطأ غير متوقع',
      };
    }
  }

  /// جلب جميع الرسائل (جميع القنوات)
  static Future<Map<String, dynamic>> getAllDeliveries({
    int page = 1,
    int limit = 20,
    String? channel,
    String? category,
    String? priority,
    bool? isRead,
    String? search,
  }) async {
    try {
      final dio = await _dio;

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (channel != null && channel.isNotEmpty) 'channel': channel,
        if (category != null && category.isNotEmpty) 'category': category,
        if (priority != null && priority.isNotEmpty) 'priority': priority,
        if (isRead != null) 'isRead': isRead.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      debugPrint('📊 [SYSTEM_MESSAGE_API] Fetching all deliveries: $queryParams');

      final response = await dio.get(
        '/api/v1/system-message-deliveries',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['success'] == true) {
          debugPrint('✅ [SYSTEM_MESSAGE_API] Fetched ${(data['data'] as List?)?.length ?? 0} deliveries');
          return {
            'success': true,
            'data': data['data'] ?? [],
            'pagination': data['pagination'] ?? {},
          };
        }
      }

      return {
        'success': false,
        'data': [],
        'pagination': {},
      };
    } on DioException catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] DioException: ${e.message}');
      return {
        'success': false,
        'data': [],
        'pagination': {},
        'error': e.response?.data?['messageAr'] ?? e.message ?? 'حدث خطأ',
      };
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error: $e');
      return {
        'success': false,
        'data': [],
        'pagination': {},
        'error': 'حدث خطأ غير متوقع',
      };
    }
  }

  /// عدد الرسائل غير المقروءة
  static Future<int> getUnreadCount({String? channel}) async {
    try {
      final dio = await _dio;

      final queryParams = <String, dynamic>{
        if (channel != null && channel.isNotEmpty) 'channel': channel,
      };

      final response = await dio.get(
        '/api/v1/system-message-deliveries/unread-count',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Backend يرجع { success: true, data: { unreadCount: count } }
        if (data is Map && data['success'] == true && data['data'] is Map) {
          final count = data['data']['unreadCount'] as int? ?? 0;
          debugPrint('📊 [SYSTEM_MESSAGE_API] Unread count: $count');
          return count;
        } else if (data is int) {
          debugPrint('📊 [SYSTEM_MESSAGE_API] Unread count: $data');
          return data;
        }
      }

      return 0;
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error getting unread count: $e');
      return 0;
    }
  }

  /// إحصائيات الرسائل
  static Future<Map<String, dynamic>> getStats() async {
    try {
      final dio = await _dio;

      final response = await dio.get('/api/v1/system-message-deliveries/stats');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['success'] == true && data['data'] is Map) {
          debugPrint('📊 [SYSTEM_MESSAGE_API] Stats: ${data['data']}');
          return {
            'success': true,
            'data': data['data'],
          };
        }
      }

      return {
        'success': false,
        'data': {},
      };
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error getting stats: $e');
      return {
        'success': false,
        'data': {},
      };
    }
  }

  /// تحديد رسالة كمقروءة
  static Future<bool> markAsRead(String id) async {
    try {
      final dio = await _dio;

      debugPrint('📝 [SYSTEM_MESSAGE_API] Marking message as read: $id');

      final response = await dio.put(
        '/api/v1/system-message-deliveries/$id/read',
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [SYSTEM_MESSAGE_API] Message marked as read');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error marking as read: $e');
      return false;
    }
  }

  /// تحديد جميع الرسائل كمقروءة
  static Future<bool> markAllAsRead({String? channel}) async {
    try {
      final dio = await _dio;

      final queryParams = <String, dynamic>{
        if (channel != null && channel.isNotEmpty) 'channel': channel,
      };

      debugPrint('📝 [SYSTEM_MESSAGE_API] Marking all messages as read');

      final response = await dio.put(
        '/api/v1/system-message-deliveries/read-all',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['success'] == true) {
          final count = data['data']?['count'] ?? 0;
          debugPrint('✅ [SYSTEM_MESSAGE_API] $count messages marked as read');
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error marking all as read: $e');
      return false;
    }
  }

  /// تحديد رسائل متعددة كمقروءة
  static Future<bool> bulkMarkAsRead(List<String> ids) async {
    try {
      final dio = await _dio;

      debugPrint('📝 [SYSTEM_MESSAGE_API] Bulk marking ${ids.length} messages as read');

      final response = await dio.put(
        '/api/v1/system-message-deliveries/bulk-read',
        data: {'ids': ids},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['success'] == true) {
          final count = data['data']?['count'] ?? 0;
          debugPrint('✅ [SYSTEM_MESSAGE_API] $count messages marked as read');
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ [SYSTEM_MESSAGE_API] Error bulk marking as read: $e');
      return false;
    }
  }
}

