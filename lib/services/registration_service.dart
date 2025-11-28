import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/registration_model.dart';
import 'platform_storage_service.dart';

class RegistrationService {
  static final RegistrationService _instance = RegistrationService._internal();
  factory RegistrationService() => _instance;
  RegistrationService._internal();

  final PlatformStorageService _storageService =
      PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Register to a conference
  Future<RegistrationModel> registerToConference({
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
        final Map<String, dynamic> data = json.decode(response.body);
        // Handle ApiResponse structure: { success, messageAr, messageEn, code, data: { registration: {...} } }
        if (data.containsKey('data') && data['data'] is Map) {
          final dataMap = data['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('registration')) {
            return RegistrationModel.fromJson(dataMap['registration']);
          }
        }
        return RegistrationModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        
        // Check for Smart Messages System error response
        String errorMessage = 'فشل في التسجيل';
        
        if (errorData is Map<String, dynamic>) {
          // Check for messageAr/messageEn (from ApiResponse)
          if (errorData.containsKey('messageAr') || errorData.containsKey('messageEn')) {
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
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
      throw Exception('Error registering to conference: $e');
    }
  }

  /// Register to an event
  Future<RegistrationModel> registerToEvent({
    required String eventId,
    String? notes,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/events/registrations'),
        headers: headers,
        body: json.encode({
          'eventId': eventId,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Handle ApiResponse structure: { success, messageAr, messageEn, code, data: { registration: {...} } }
        if (data.containsKey('data') && data['data'] is Map) {
          final dataMap = data['data'] as Map<String, dynamic>;
          if (dataMap.containsKey('registration')) {
            return RegistrationModel.fromJson(dataMap['registration']);
          }
        }
        return RegistrationModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        
        // Check for Smart Messages System error response
        String errorMessage = 'فشل في التسجيل';
        
        if (errorData is Map<String, dynamic>) {
          // Check for messageAr/messageEn (from ApiResponse)
          if (errorData.containsKey('messageAr') || errorData.containsKey('messageEn')) {
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
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
      if (e is Exception && !e.toString().contains('Error registering to event')) {
        rethrow;
      }
      throw Exception('خطأ في التسجيل: ${e.toString()}');
    }
  }

  /// Get user's registrations
  Future<List<RegistrationModel>> getMyRegistrations() async {
    try {
      final headers = await _getHeaders();
      final url = '${ApiConstants.baseUrl}/api/v1/events/registrations/my-registrations';
      print('📋 [REGISTRATION_SERVICE] Fetching registrations from: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📋 [REGISTRATION_SERVICE] Response status: ${response.statusCode}');
      print('📋 [REGISTRATION_SERVICE] Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        print('📋 [REGISTRATION_SERVICE] Decoded type: ${decoded.runtimeType}');
        
        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data') && decoded['data'] is List) {
          data = decoded['data'] as List;
        } else {
          print('❌ [REGISTRATION_SERVICE] Unexpected response format: $decoded');
          throw Exception('Unexpected response format from server');
        }
        
        print('📋 [REGISTRATION_SERVICE] Parsing ${data.length} registrations');
        final registrations = data.map((json) {
          try {
            return RegistrationModel.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('❌ [REGISTRATION_SERVICE] Error parsing registration: $e');
            print('❌ [REGISTRATION_SERVICE] Registration JSON: $json');
            rethrow;
          }
        }).toList();
        
        print('✅ [REGISTRATION_SERVICE] Successfully loaded ${registrations.length} registrations');
        return registrations;
      } else {
        print('❌ [REGISTRATION_SERVICE] Failed with status ${response.statusCode}');
        print('❌ [REGISTRATION_SERVICE] Response body: ${response.body}');
        throw Exception('Failed to load registrations: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ [REGISTRATION_SERVICE] Exception: $e');
      throw Exception('Error fetching registrations: $e');
    }
  }

  /// Get registration details by ID
  Future<RegistrationModel> getRegistrationDetails(
      String registrationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/registrations/$registrationId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return RegistrationModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to load registration');
      }
    } catch (e) {
      throw Exception('Error fetching registration details: $e');
    }
  }

  /// Get user registration status for an event
  Future<Map<String, dynamic>?> getEventRegistrationStatus(String eventId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/events/registrations/my-status/$eventId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        // User not registered
        return null;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get registration status');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('404')) {
        return null; // Not registered
      }
      throw Exception('Error fetching registration status: $e');
    }
  }

  /// Get registration timeline
  Future<Map<String, dynamic>> getRegistrationTimeline(
      String registrationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/registrations/$registrationId/timeline'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load timeline: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching timeline: $e');
    }
  }

  /// Request reactivation for ON_HOLD registration
  Future<void> requestReactivation({
    required String registrationId,
    String? reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/registrations/$registrationId/request-reactivation'),
        headers: headers,
        body: json.encode({
          if (reason != null && reason.isNotEmpty) 'reason': reason,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = json.decode(response.body);
        // Try to get Arabic message first, then English, then default
        final message = errorData['messageAr'] ?? 
                       errorData['message'] ?? 
                       'فشل في طلب إعادة التفعيل';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Error requesting reactivation: $e');
    }
  }

  /// Complete payment (mark as paid)
  Future<void> completePayment({
    required String registrationId,
    String? paymentId,
    String? transactionId,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/registrations/$registrationId/payment-completed'),
        headers: headers,
        body: json.encode({
          if (paymentId != null) 'paymentId': paymentId,
          if (transactionId != null) 'transactionId': transactionId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في تسجيل الدفع');
      }
    } catch (e) {
      throw Exception('Error completing payment: $e');
    }
  }
}
