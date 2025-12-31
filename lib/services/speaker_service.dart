import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/speaker_model.dart';
import 'platform_storage_service.dart';

class SpeakerService {
  static final SpeakerService _instance = SpeakerService._internal();
  factory SpeakerService() => _instance;
  SpeakerService._internal();

  final PlatformStorageService _storageService = PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get all speakers with optional filters
  Future<Map<String, dynamic>> getSpeakers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/speakers')
          .replace(queryParameters: queryParams);

      print('🔍 [SPEAKER_SERVICE] Fetching speakers from: $uri');

      final response = await http.get(uri, headers: headers);

      print('📊 [SPEAKER_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        print('📦 [SPEAKER_SERVICE] Decoded data type: ${decodedData.runtimeType}');
        print('📦 [SPEAKER_SERVICE] Decoded data: $decodedData');
        
        // Handle different response formats
        List<SpeakerModel> speakers = [];
        int total = 0;
        int totalPages = 0;

        if (decodedData is Map<String, dynamic>) {
          // Paginated response or object response
          print('📦 [SPEAKER_SERVICE] Response is Map, checking for data...');
          if (decodedData['data'] != null) {
            final dataList = decodedData['data'];
            print('📦 [SPEAKER_SERVICE] Data list type: ${dataList.runtimeType}');
            print('📦 [SPEAKER_SERVICE] Data list length: ${dataList is List ? dataList.length : 'N/A'}');
            if (dataList is List) {
              try {
                speakers = dataList
                    .map((json) {
                      print('📦 [SPEAKER_SERVICE] Parsing speaker: $json');
                      return SpeakerModel.fromJson(json as Map<String, dynamic>);
                    })
                    .toList();
                total = decodedData['pagination']?['total'] ?? 0;
                totalPages = decodedData['pagination']?['totalPages'] ?? 0;
                print('✅ [SPEAKER_SERVICE] Successfully parsed ${speakers.length} speakers');
              } catch (e) {
                print('❌ [SPEAKER_SERVICE] Error parsing speakers: $e');
                rethrow;
              }
            } else {
              print('⚠️ [SPEAKER_SERVICE] data is not a List, it is: ${dataList.runtimeType}');
            }
          } else {
            print('⚠️ [SPEAKER_SERVICE] No data field in response');
          }
        } else if (decodedData is List) {
          // Direct list response
          print('📦 [SPEAKER_SERVICE] Response is direct List');
          try {
            speakers = decodedData
                .map((json) => SpeakerModel.fromJson(json as Map<String, dynamic>))
                .toList();
            total = speakers.length;
            totalPages = 1;
            print('✅ [SPEAKER_SERVICE] Successfully parsed ${speakers.length} speakers from list');
          } catch (e) {
            print('❌ [SPEAKER_SERVICE] Error parsing speakers from list: $e');
            rethrow;
          }
        } else {
          print('⚠️ [SPEAKER_SERVICE] Unknown response format: ${decodedData.runtimeType}');
        }

        print('📊 [SPEAKER_SERVICE] Final result: ${speakers.length} speakers, total: $total');
        return {
          'data': speakers,
          'pagination': {
            'page': page,
            'limit': limit,
            'total': total,
            'totalPages': totalPages,
          },
        };
      } else {
        print('❌ [SPEAKER_SERVICE] Error response: ${response.statusCode}');
        print('❌ [SPEAKER_SERVICE] Response body: ${response.body}');
        try {
          final errorBody = json.decode(response.body);
          final errorMessage = errorBody['message'] ?? 'فشل جلب المتحدثين';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('فشل جلب المتحدثين: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('❌ [SPEAKER_SERVICE] Exception: $e');
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب المتحدثين: ${e.toString()}');
    }
  }

  /// Get speaker by ID
  Future<SpeakerModel> getSpeakerById(String speakerId) async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}/api/v1/speakers/$speakerId';

      print('🔍 [SPEAKER_SERVICE] Fetching speaker from: $url');

      final response = await http.get(Uri.parse(url), headers: headers);

      print('📊 [SPEAKER_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SpeakerModel.fromJson(data);
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'فشل جلب المتحدث';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب المتحدث: ${e.toString()}');
    }
  }

  /// Get speaker events
  Future<List<Map<String, dynamic>>> getSpeakerEvents(String speakerId) async {
    try {
      final headers = await _getHeaders();
      // Note: This endpoint might need to be implemented in the backend
      // For now, we'll use a workaround by fetching all events and filtering
      final url = '${ApiConstants.baseUrl}/api/v1/speakers/$speakerId/events';

      print('🔍 [SPEAKER_SERVICE] Fetching speaker events from: $url');

      final response = await http.get(Uri.parse(url), headers: headers);

      print('📊 [SPEAKER_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        // If endpoint doesn't exist, return empty list
        return [];
      }
    } catch (e) {
      // If endpoint doesn't exist, return empty list
      print('⚠️ [SPEAKER_SERVICE] Error fetching speaker events: $e');
      return [];
    }
  }
}

