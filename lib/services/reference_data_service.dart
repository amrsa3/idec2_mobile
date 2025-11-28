import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/governorate_model.dart';
import '../models/qualification_model.dart';
import './services/platform_storage_service.dart';

class ReferenceDataService {
  static final ReferenceDataService _instance =
      ReferenceDataService._internal();
  factory ReferenceDataService() => _instance;
  ReferenceDataService._internal();

  final StorageService _storageService = PlatformStorageService.instance;

  // Cache for reference data
  List<GovernorateModel>? _governorates;
  List<Qualification>? _qualifications;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<GovernorateModel>> getGovernorates() async {
    if (_governorates != null) {
      return _governorates!;
    }

    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/rule-data/governorates'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _governorates =
            data.map((json) => GovernorateModel.fromJson(json)).toList();
        return _governorates!;
      } else {
        throw Exception('Failed to load governorates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching governorates: $e');
    }
  }

  Future<List<Qualification>> getQualifications() async {
    if (_qualifications != null) {
      return _qualifications!;
    }

    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/v1/qualifications'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        _qualifications =
            data.map((json) => Qualification.fromJson(json)).toList();
        return _qualifications!;
      } else {
        throw Exception(
            'Failed to load qualifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching qualifications: $e');
    }
  }

  String? getGovernorateName(String? governorateId) {
    if (governorateId == null || _governorates == null) return null;

    try {
      final governorate = _governorates!.firstWhere(
        (g) => g.id == governorateId,
      );
      return governorate.nameAr;
    } catch (e) {
      return null;
    }
  }

  String? getQualificationName(String? qualificationId) {
    if (qualificationId == null || _qualifications == null) return null;

    try {
      final qualification = _qualifications!.firstWhere(
        (q) => q.id == qualificationId,
      );
      return qualification.nameAr;
    } catch (e) {
      return null;
    }
  }

  // Clear cache when needed
  void clearCache() {
    _governorates = null;
    _qualifications = null;
  }
}


