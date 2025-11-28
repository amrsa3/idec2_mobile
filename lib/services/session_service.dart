import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/session_model.dart';
import 'platform_storage_service.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final PlatformStorageService _storageService = PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

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
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (conferenceId != null) 'conferenceId': conferenceId,
        if (eventId != null) 'eventId': eventId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (startDateFrom != null) 'startDateFrom': startDateFrom,
        if (endDateTo != null) 'endDateTo': endDateTo,
        if (location != null) 'location': location,
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/sessions')
          .replace(queryParameters: queryParams);

      print('🔍 [SESSION_SERVICE] Fetching sessions from: $uri');

      final response = await http.get(uri, headers: headers);

      print('📊 [SESSION_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print('📦 [SESSION_SERVICE] Decoded data type: ${decodedData.runtimeType}');
        print('📦 [SESSION_SERVICE] Decoded data keys: ${decodedData is Map ? decodedData.keys.toList() : 'N/A'}');
        
        // Handle different response formats
        List<SessionModel> sessions = [];
        int total = 0;
        int totalPages = 0;

        if (decodedData is Map<String, dynamic>) {
          print('📦 [SESSION_SERVICE] Response is Map, checking for data...');
          if (decodedData['data'] != null) {
            final dataList = decodedData['data'];
            print('📦 [SESSION_SERVICE] Data list type: ${dataList.runtimeType}');
            print('📦 [SESSION_SERVICE] Data list length: ${dataList is List ? dataList.length : 'N/A'}');
            if (dataList is List) {
              try {
                sessions = dataList
                    .map((json) {
                      print('📦 [SESSION_SERVICE] Parsing session: ${json['id']} - ${json['title']}');
                      return SessionModel.fromJson(json as Map<String, dynamic>);
                    })
                    .toList();
                total = decodedData['pagination']?['total'] ?? 0;
                totalPages = decodedData['pagination']?['totalPages'] ?? 0;
                print('✅ [SESSION_SERVICE] Successfully parsed ${sessions.length} sessions');
              } catch (e) {
                print('❌ [SESSION_SERVICE] Error parsing sessions: $e');
                print('❌ [SESSION_SERVICE] Stack trace: ${StackTrace.current}');
                rethrow;
              }
            } else {
              print('⚠️ [SESSION_SERVICE] data is not a List, it is: ${dataList.runtimeType}');
            }
          } else {
            print('⚠️ [SESSION_SERVICE] No data field in response');
          }
        } else if (decodedData is List) {
          print('📦 [SESSION_SERVICE] Response is direct List');
          try {
            sessions = decodedData
                .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
                .toList();
            total = sessions.length;
            totalPages = 1;
            print('✅ [SESSION_SERVICE] Successfully parsed ${sessions.length} sessions from list');
          } catch (e) {
            print('❌ [SESSION_SERVICE] Error parsing sessions from list: $e');
            rethrow;
          }
        } else {
          print('⚠️ [SESSION_SERVICE] Unknown response format: ${decodedData.runtimeType}');
        }

        print('📊 [SESSION_SERVICE] Final result: ${sessions.length} sessions, total: $total');
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
        print('❌ [SESSION_SERVICE] Error response: ${response.statusCode}');
        print('❌ [SESSION_SERVICE] Response body: ${response.body}');
        try {
          final errorBody = json.decode(response.body);
          final errorMessage = errorBody['message'] ?? 'فشل جلب الجلسات';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('فشل جلب الجلسات: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('❌ [SESSION_SERVICE] Exception: $e');
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب الجلسات: ${e.toString()}');
    }
  }

  /// Get sessions by conference ID
  Future<Map<String, dynamic>> getConferenceSessions({
    required String conferenceId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/events/conferences/$conferenceId/sessions')
          .replace(queryParameters: queryParams);

      print('🔍 [SESSION_SERVICE] Fetching conference sessions from: $uri');

      final response = await http.get(uri, headers: headers);

      print('📊 [SESSION_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        
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
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب جلسات المؤتمر';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب جلسات المؤتمر: ${e.toString()}');
    }
  }

  /// Get session by ID
  Future<SessionModel> getSessionById(String sessionId) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}/api/v1/sessions/$sessionId';

      print('🔍 [SESSION_SERVICE] Fetching session from: $url');

      final response = await http.get(Uri.parse(url), headers: headers);

      print('📊 [SESSION_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SessionModel.fromJson(data);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب الجلسة';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب الجلسة: ${e.toString()}');
    }
  }
}

