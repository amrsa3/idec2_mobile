import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../core/utils/storage_helper.dart';
import '../models/notification_model.dart';

/// خدمة API محسّنة لجلب الإشعارات من Backend
class NotificationsApiService {
  static String get _baseUrl => ApiConstants.baseUrl;
  static const String _notificationsEndpoint = '/api/v1/notifications';

  /// جلب الإشعارات مع دعم Pagination و Filtering
  static Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
    String? category,
    String? type,
    String? priority,
    bool? isRead,
    String? searchQuery,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
        if (type != null && type.isNotEmpty) 'type': type,
        if (priority != null && priority.isNotEmpty) 'priority': priority,
        if (isRead != null) 'isRead': isRead.toString(),
        if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
      };

      final uri = Uri.parse('$_baseUrl$_notificationsEndpoint')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ [NOTIFICATIONS_API] Response received: ${data is Map ? 'Map with keys: ${(data as Map).keys.join(", ")}' : 'List with ${(data as List).length} items'}');
        
        // Backend returns: { notifications: [...], pagination: {...} }
        List<dynamic> notificationsList;
        if (data is Map && data.containsKey('notifications')) {
          notificationsList = data['notifications'] as List;
          debugPrint('📋 [NOTIFICATIONS_API] Found ${notificationsList.length} notifications in response');
        } else if (data is List) {
          notificationsList = data;
          debugPrint('📋 [NOTIFICATIONS_API] Response is a list with ${notificationsList.length} items');
        } else if (data is Map && data.containsKey('data')) {
          notificationsList = data['data'] as List? ?? [];
          debugPrint('📋 [NOTIFICATIONS_API] Found ${notificationsList.length} notifications in data field');
        } else {
          notificationsList = [];
          debugPrint('⚠️ [NOTIFICATIONS_API] No notifications found in response');
        }
        
        final transformed = notificationsList
            .map((json) {
              try {
                final notificationJson = json as Map<String, dynamic>;
                // Transform backend format to mobile app format
                final transformedJson = <String, dynamic>{
                  ...notificationJson,
                  // Backend sends 'content', mobile app expects 'message'
                  'message': notificationJson['message'] ?? notificationJson['content'] ?? '',
                  // Backend sends 'isRead' boolean, mobile app expects 'status' string
                  'status': (notificationJson['isRead'] == true || notificationJson['readAt'] != null) 
                      ? 'read' 
                      : 'unread',
                  // Ensure priority is lowercase
                  'priority': (notificationJson['priority'] as String?)?.toLowerCase() ?? 'normal',
                  // Parse actionData if it's a string
                  if (notificationJson['actionData'] != null)
                    'actionData': notificationJson['actionData'] is String
                        ? jsonDecode(notificationJson['actionData'] as String)
                        : notificationJson['actionData'],
                };
                return NotificationModel.fromJson(transformedJson);
              } catch (e, stackTrace) {
                debugPrint('❌ [NOTIFICATIONS_API] Error parsing notification: $e');
                debugPrint('Stack trace: $stackTrace');
                debugPrint('Notification JSON: $json');
                rethrow;
              }
            })
            .toList();
        
        debugPrint('✅ [NOTIFICATIONS_API] Successfully parsed ${transformed.length} notifications');
        return transformed;
      } else {
        debugPrint('❌ [NOTIFICATIONS_API] Failed to fetch: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// جلب إحصائيات الإشعارات
  static Future<Map<String, dynamic>> getNotificationStats() async {
    try {
      final token = await StorageHelper.getToken();

      // Use unread-count endpoint
      final unreadUri = Uri.parse('$_baseUrl$_notificationsEndpoint/unread-count');

      final unreadResponse = await http.get(
        unreadUri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (unreadResponse.statusCode == 200) {
        final unreadData = jsonDecode(unreadResponse.body);
        // Backend returns: { count: number } or { unreadCount: number }
        final unreadCount = unreadData is Map 
            ? (unreadData['unreadCount'] as int? ?? unreadData['count'] as int? ?? 0)
            : 0;
        
        debugPrint('📊 [NOTIFICATIONS_API] Unread count: $unreadCount');
        
        // Get total from first page response (with pagination info)
        final firstPageResponse = await http.get(
          Uri.parse('$_baseUrl$_notificationsEndpoint').replace(queryParameters: {
            'page': '1',
            'limit': '1',
          }),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        );
        
        int total = 0;
        if (firstPageResponse.statusCode == 200) {
          final firstPageData = jsonDecode(firstPageResponse.body);
          if (firstPageData is Map && firstPageData.containsKey('pagination')) {
            total = firstPageData['pagination']['total'] as int? ?? 0;
            debugPrint('📊 [NOTIFICATIONS_API] Total notifications: $total');
          }
        }
        
        return {
          'unreadCount': unreadCount,
          'totalNotifications': total,
        };
      } else {
        debugPrint('❌ [NOTIFICATIONS_API] Failed to get stats: ${unreadResponse.statusCode}');
        return {
          'unreadCount': 0,
          'totalNotifications': 0,
        };
      }
    } catch (e) {
      debugPrint('❌ [NOTIFICATIONS_API] Error getting stats: $e');
      return {
        'unreadCount': 0,
        'totalNotifications': 0,
      };
    }
  }

  /// البحث في الإشعارات (client-side filtering)
  static Future<List<NotificationModel>> searchNotifications(String query) async {
    try {
      // Fetch all notifications and filter client-side
      // In production, you might want to add a search endpoint in backend
      final allNotifications = await getNotifications(page: 1, limit: 1000);
      
      if (query.isEmpty) {
        return allNotifications;
      }
      
      final queryLower = query.toLowerCase();
      return allNotifications.where((notification) {
        return notification.title.toLowerCase().contains(queryLower) ||
            notification.message.toLowerCase().contains(queryLower);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// تحديد إشعار كمقروء
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final token = await StorageHelper.getToken();

      final uri = Uri.parse('$_baseUrl$_notificationsEndpoint/$notificationId/read');

      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// تحديد جميع الإشعارات كمقروءة
  static Future<bool> markAllAsRead() async {
    try {
      final token = await StorageHelper.getToken();

      final uri = Uri.parse('$_baseUrl$_notificationsEndpoint/read-all');

      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// حذف إشعار
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final token = await StorageHelper.getToken();

      final uri = Uri.parse('$_baseUrl$_notificationsEndpoint/$notificationId');

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}

