import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/conference_model.dart';
import '../models/registration_status_model.dart';
import 'platform_storage_service.dart';

class ConferenceService {
  static final ConferenceService _instance = ConferenceService._internal();
  factory ConferenceService() => _instance;
  ConferenceService._internal();

  final PlatformStorageService _storageService =
      PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ConferenceModel?> getActiveConference() async {
    try {
      final url = '${ApiConstants.baseUrl}/api/v1/events/conferences/active';
      print('🔍 [CONFERENCE_SERVICE] Fetching active conference from: $url');
      
      final headers = await _getHeaders();
      print('🔍 [CONFERENCE_SERVICE] Headers: ${headers.keys.toList()}');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('❌ [CONFERENCE_SERVICE] Request timeout');
          throw Exception('Request timeout - لم يتم استلام رد من الخادم');
        },
      );

      print('📊 [CONFERENCE_SERVICE] Response status: ${response.statusCode}');
      print('📄 [CONFERENCE_SERVICE] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          print('⚠️ [CONFERENCE_SERVICE] Empty response body');
          return null;
        }
        
        final dynamic decodedData = json.decode(responseBody);
        print('📦 [CONFERENCE_SERVICE] Decoded data type: ${decodedData.runtimeType}');
        
        Map<String, dynamic> data;
        if (decodedData is Map<String, dynamic>) {
          data = decodedData;
        } else if (decodedData is List && decodedData.isNotEmpty) {
          // If it's a list, take the first item
          data = decodedData[0] as Map<String, dynamic>;
        } else {
          print('⚠️ [CONFERENCE_SERVICE] Unexpected response format');
          return null;
        }
        
        if (data.isEmpty || data['id'] == null) {
          print('⚠️ [CONFERENCE_SERVICE] Empty or null conference data');
          return null;
        }
        print('✅ [CONFERENCE_SERVICE] Conference found: ${data['nameAr'] ?? data['name']} (${data['status'] ?? 'N/A'})');
        return ConferenceModel.fromJson(data);
      } else if (response.statusCode == 404) {
        print('❌ [CONFERENCE_SERVICE] No active conference found (404)');
        return null;
      } else {
        print('❌ [CONFERENCE_SERVICE] Error response: ${response.statusCode}');
        print('❌ [CONFERENCE_SERVICE] Response body: ${response.body}');
        try {
          final errorBody = json.decode(response.body);
          final errorMessage = errorBody['message'] ?? 'فشل جلب المؤتمر النشط';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('فشل جلب المؤتمر النشط: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('❌ [CONFERENCE_SERVICE] Exception: $e');
      print('❌ [CONFERENCE_SERVICE] Exception type: ${e.runtimeType}');
      if (e is Exception) rethrow;
      throw Exception('خطأ في جلب المؤتمر النشط: ${e.toString()}');
    }
  }

  Future<RegistrationStatusModel?> getMyRegistration(
      String conferenceId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/conferences/$conferenceId/my-registration'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isEmpty) return null;
        
        // Debug: Log the raw response
        print('🔵 [CONFERENCE_SERVICE] Raw registration response: $data');
        print('🔵 [CONFERENCE_SERVICE] Status from response: ${data['status']}');
        
        final registration = RegistrationStatusModel.fromJson(data);
        print('🔵 [CONFERENCE_SERVICE] Parsed registration status: ${registration.status}');
        return registration;
      } else if (response.statusCode == 404) {
        print('🔵 [CONFERENCE_SERVICE] No registration found (404)');
        return null;
      } else {
        throw Exception('Failed to load registration: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching registration: $e');
    }
  }

  /// Register to conference
  Future<Map<String, dynamic>> registerToConference({
    required String conferenceId,
    String? notes,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/conferences/$conferenceId/register'),
        headers: headers,
        body: json.encode({
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        
        // Check for Smart Messages System error response
        // Structure: { success: false, error: {...}, messageAr: "...", messageEn: "..." }
        String errorMessage = 'فشل في التسجيل';
        
        if (errorData is Map<String, dynamic>) {
          // Check for messageAr/messageEn (from ApiResponse)
          if (errorData.containsKey('messageAr') || errorData.containsKey('messageEn')) {
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
            // Use Arabic by default, fallback to English
            errorMessage = messageAr.isNotEmpty ? messageAr : messageEn;
          }
          // Check for error.message (from HttpExceptionFilter)
          else if (errorData.containsKey('error') && errorData['error'] is Map) {
            final errorObj = errorData['error'] as Map<String, dynamic>;
            if (errorObj.containsKey('message')) {
              errorMessage = errorObj['message'] as String? ?? errorMessage;
            }
            // Also check for messageAr/messageEn in error object
            if (errorObj.containsKey('messageAr') || errorObj.containsKey('messageEn')) {
              final messageAr = errorObj['messageAr'] as String? ?? '';
              final messageEn = errorObj['messageEn'] as String? ?? '';
              errorMessage = messageAr.isNotEmpty ? messageAr : messageEn;
            }
          }
          // Fallback to top-level message
          else if (errorData.containsKey('message')) {
            errorMessage = errorData['message'] as String? ?? errorMessage;
          }
        }
        
        throw Exception(errorMessage);
      }
    } catch (e) {
      // If it's already an Exception with a message, rethrow it
      if (e is Exception && !e.toString().contains('Error registering to conference')) {
        rethrow;
      }
      throw Exception('خطأ في التسجيل: ${e.toString()}');
    }
  }
}
