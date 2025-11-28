import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/event_model.dart';
import 'platform_storage_service.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final PlatformStorageService _storageService = PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get all events with optional filters
  Future<Map<String, dynamic>> getEvents({
    int page = 1,
    int limit = 20,
    String? conferenceId,
    String? type,
    String? search,
    String? startDateFrom,
    String? endDateTo,
    List<String>? statuses, // Filter by statuses
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (conferenceId != null) 'conferenceId': conferenceId,
        if (type != null) 'type': type,
        if (search != null && search.isNotEmpty) 'search': search,
        if (startDateFrom != null) 'startDateFrom': startDateFrom,
        if (endDateTo != null) 'endDateTo': endDateTo,
        // Note: Backend doesn't support status filter yet, so we filter on frontend
        // if (statuses != null && statuses.isNotEmpty) 'status': statuses.join(','),
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/events')
          .replace(queryParameters: queryParams);

      print('🔍 [EVENT_SERVICE] Fetching events from: $uri');

      final response = await http.get(uri, headers: headers);

      print('📊 [EVENT_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print('📦 [EVENT_SERVICE] Decoded data type: ${decodedData.runtimeType}');
        print('📦 [EVENT_SERVICE] Decoded data keys: ${decodedData is Map ? decodedData.keys.toList() : 'N/A'}');
        
        // Handle different response formats
        List<EventModel> events = [];
        int total = 0;
        int totalPages = 0;

        if (decodedData is Map<String, dynamic>) {
          // Paginated response or object response
          print('📦 [EVENT_SERVICE] Response is Map, checking for data...');
          if (decodedData['data'] != null) {
            final dataList = decodedData['data'];
            print('📦 [EVENT_SERVICE] Data list type: ${dataList.runtimeType}');
            print('📦 [EVENT_SERVICE] Data list length: ${dataList is List ? dataList.length : 'N/A'}');
            if (dataList is List) {
              try {
                events = dataList
                    .map((json) {
                      print('📦 [EVENT_SERVICE] Parsing event: ${json['id']} - ${json['title']}');
                      return EventModel.fromJson(json as Map<String, dynamic>);
                    })
                    .toList();
                total = decodedData['pagination']?['total'] ?? 0;
                totalPages = decodedData['pagination']?['totalPages'] ?? 0;
                print('✅ [EVENT_SERVICE] Successfully parsed ${events.length} events');
              } catch (e) {
                print('❌ [EVENT_SERVICE] Error parsing events: $e');
                print('❌ [EVENT_SERVICE] Stack trace: ${StackTrace.current}');
                rethrow;
              }
            } else {
              print('⚠️ [EVENT_SERVICE] data is not a List, it is: ${dataList.runtimeType}');
            }
          } else {
            print('⚠️ [EVENT_SERVICE] No data field in response');
          }
        } else if (decodedData is List) {
          // Direct list response
          print('📦 [EVENT_SERVICE] Response is direct List');
          try {
            events = decodedData
                .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
                .toList();
            total = events.length;
            totalPages = 1;
            print('✅ [EVENT_SERVICE] Successfully parsed ${events.length} events from list');
          } catch (e) {
            print('❌ [EVENT_SERVICE] Error parsing events from list: $e');
            rethrow;
          }
        } else {
          print('⚠️ [EVENT_SERVICE] Unknown response format: ${decodedData.runtimeType}');
        }

        print('📊 [EVENT_SERVICE] Final result: ${events.length} events, total: $total');
        return {
          'data': events,
          'pagination': {
            'page': page,
            'limit': limit,
            'total': total,
            'totalPages': totalPages,
          },
        };
      } else {
        print('❌ [EVENT_SERVICE] Error response: ${response.statusCode}');
        print('❌ [EVENT_SERVICE] Response body: ${response.body}');
        try {
          final errorBody = json.decode(response.body);
          final errorMessage = errorBody['message'] ?? 'فشل جلب الفعاليات';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('فشل جلب الفعاليات: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('❌ [EVENT_SERVICE] Exception: $e');
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب الفعاليات: ${e.toString()}');
    }
  }

  /// Get event by ID
  Future<EventModel> getEventById(String eventId) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}/api/v1/events/$eventId';

      print('🔍 [EVENT_SERVICE] Fetching event from: $url');

      final response = await http.get(Uri.parse(url), headers: headers);

      print('📊 [EVENT_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return EventModel.fromJson(data);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب الفعالية';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب الفعالية: ${e.toString()}');
    }
  }

  /// Get event speakers
  Future<List<Map<String, dynamic>>> getEventSpeakers(String eventId) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}/api/v1/events/$eventId/speakers';

      print('🔍 [EVENT_SERVICE] Fetching event speakers from: $url');

      final response = await http.get(Uri.parse(url), headers: headers);

      print('📊 [EVENT_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب متحدثي الفعالية';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب متحدثي الفعالية: ${e.toString()}');
    }
  }
}

