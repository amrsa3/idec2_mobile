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
        return RegistrationModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في التسجيل');
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
        return RegistrationModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'فشل في التسجيل');
      }
    } catch (e) {
      throw Exception('Error registering to event: $e');
    }
  }

  /// Get user's registrations
  Future<List<RegistrationModel>> getMyRegistrations() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/v1/events/registrations/my-registrations'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => RegistrationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load registrations: ${response.statusCode}');
      }
    } catch (e) {
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
        throw Exception(errorData['message'] ?? 'فشل في طلب إعادة التفعيل');
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
