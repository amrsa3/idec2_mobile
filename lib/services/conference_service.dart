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
      print('🔍 Fetching active conference from: ${ApiConstants.baseUrl}/api/v1/events/conferences/active');
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/events/conferences/active'),
        headers: headers,
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.isEmpty || data['id'] == null) {
          print('⚠️ Empty or null conference data');
          return null;
        }
        print('✅ Conference found: ${data['nameAr']} (${data['status']})');
        return ConferenceModel.fromJson(data);
      } else if (response.statusCode == 404) {
        print('❌ No active conference found (404)');
        return null;
      } else {
        print('❌ Error loading conference: ${response.statusCode}');
        throw Exception(
            'Failed to load active conference: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception fetching active conference: $e');
      throw Exception('Error fetching active conference: $e');
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
        return RegistrationStatusModel.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load registration: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching registration: $e');
    }
  }
}
