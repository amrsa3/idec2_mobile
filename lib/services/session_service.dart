import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/api_constants.dart';
import '../models/session_model.dart';
import 'enhanced_dio_service_v2.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  Dio get _dio => EnhancedDioServiceV2.instance.dio;

  /// Get all sessions with optional filters
  Future<Map<String, dynamic>> getSessions({
    int page = 1,
    int limit = 20,
    String? conferenceId,
    String? eventId,
    String? search,
    String? startDateFrom,
    String? endDateTo,
    String? location,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (conferenceId != null) 'conferenceId': conferenceId,
        if (eventId != null) 'eventId': eventId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (startDateFrom != null) 'startDateFrom': startDateFrom,
        if (endDateTo != null) 'endDateTo': endDateTo,
        if (location != null) 'location': location,
      };

      final url = '${ApiConstants.baseUrl}/api/v1/sessions';
      debugPrint('🔍 [SESSION_SERVICE] Fetching sessions from: $url');
      debugPrint('🔍 [SESSION_SERVICE] Query params: $queryParams');

      final response = await _dio.get(
        url,
        queryParameters: queryParams,
      );

      debugPrint('📊 [SESSION_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = response.data;
        // debugPrint('📦 [SESSION_SERVICE] Data type: ${decodedData.runtimeType}');

        List<SessionModel> sessions = [];
        int total = 0;
        int totalPages = 0;

        if (decodedData is Map<String, dynamic>) {
          if (decodedData['data'] != null) {
            final dataList = decodedData['data'];
            if (dataList is List) {
              try {
                sessions = dataList
                    .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
                    .toList();
                total = decodedData['pagination']?['total'] ?? 0;
                totalPages = decodedData['pagination']?['totalPages'] ?? 0;
                debugPrint('✅ [SESSION_SERVICE] Successfully parsed ${sessions.length} sessions');
              } catch (e) {
                debugPrint('❌ [SESSION_SERVICE] Error parsing sessions: $e');
                rethrow;
              }
            }
          }
        } else if (decodedData is List) {
          try {
            sessions = decodedData
                .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
                .toList();
            total = sessions.length;
            totalPages = 1;
            debugPrint('✅ [SESSION_SERVICE] Successfully parsed ${sessions.length} sessions from list');
          } catch (e) {
             debugPrint('❌ [SESSION_SERVICE] Error parsing sessions from list: $e');
             rethrow;
          }
        }

        return {
          'data': sessions,
          'pagination': {
            'page': page,
            'limit': limit,
            'total': total,
            'totalPages': totalPages,
          },
        };
      } else {
        throw Exception('فشل جلب الجلسات: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [SESSION_SERVICE] Exception: $e');
      if (e is DioException) {
         if (e.response?.statusCode == 401) {
            throw Exception('جلسة العمل انتهت، يرجى تسجيل الدخول مجدداً');
         }
         final msg = e.response?.data?['message'] ?? e.message;
         throw Exception('خطأ في الاتصال: $msg');
      }
      if (e is Exception) rethrow;
      throw Exception('خطأ غير متوقع: ${e.toString()}');
    }
  }

  /// Get sessions by conference ID
  Future<Map<String, dynamic>> getConferenceSessions({
    required String conferenceId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      final url = '${ApiConstants.baseUrl}/api/v1/events/conferences/$conferenceId/sessions';
      debugPrint('🔍 [SESSION_SERVICE] Fetching conference sessions from: $url');

      final response = await _dio.get(
        url,
        queryParameters: queryParams,
      );

      debugPrint('📊 [SESSION_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = response.data;
        
        List<SessionModel> sessions = [];
        int total = 0;
        int totalPages = 0;

        if (decodedData is Map<String, dynamic>) {
          if (decodedData['data'] != null) {
            final dataList = decodedData['data'];
            if (dataList is List) {
              sessions = dataList
                  .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
                  .toList();
              total = decodedData['pagination']?['total'] ?? 0;
              totalPages = decodedData['pagination']?['totalPages'] ?? 0;
            }
          }
        } else if (decodedData is List) {
          sessions = decodedData
              .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
              .toList();
          total = sessions.length;
          totalPages = 1;
        }

        return {
          'data': sessions,
          'pagination': {
            'page': page,
            'limit': limit,
            'total': total,
            'totalPages': totalPages,
          },
        };
      } else {
        throw Exception('فشل جلب جلسات المؤتمر: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [SESSION_SERVICE] Error: $e');
      if (e is DioException) {
         if (e.response?.statusCode == 401) {
            throw Exception('جلسة العمل انتهت، يرجى تسجيل الدخول مجدداً');
         }
         throw Exception(e.response?.data?['message'] ?? 'فشل الاتصال بالخادم');
      }
      throw Exception('خطأ في جلب جلسات المؤتمر');
    }
  }

  /// Get session by ID
  Future<SessionModel> getSessionById(String sessionId) async {
    try {
      final url = '${ApiConstants.baseUrl}/api/v1/sessions/$sessionId';

      debugPrint('🔍 [SESSION_SERVICE] Fetching session from: $url');

      final response = await _dio.get(url);

      debugPrint('📊 [SESSION_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return SessionModel.fromJson(response.data);
      } else {
        throw Exception('فشل جلب الجلسة: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [SESSION_SERVICE] Error: $e');
      if (e is DioException) {
         throw Exception(e.response?.data?['message'] ?? 'فشل الاتصال بالخادم');
      }
      throw Exception('خطأ في جلب الجلسة');
    }
  }
}
