import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import 'platform_storage_service.dart';

class CourseCategoryModel {
  final String id;
  final String nameAr;
  final String? nameEn;
  final String? description;
  final bool isActive;

  CourseCategoryModel({
    required this.id,
    required this.nameAr,
    this.nameEn,
    this.description,
    required this.isActive,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String? ?? json['name'] as String? ?? '',
      nameEn: json['nameEn'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class CourseCategoryService {
  static final CourseCategoryService _instance = CourseCategoryService._internal();
  factory CourseCategoryService() => _instance;
  CourseCategoryService._internal();

  final PlatformStorageService _storageService = PlatformStorageService.instance;

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get all course categories
  Future<List<CourseCategoryModel>> getCategories({
    bool activeOnly = true,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        if (activeOnly) 'isActive': 'true',
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/v1/course-categories')
          .replace(queryParameters: queryParams);

      print('🔍 [COURSE_CATEGORY_SERVICE] Fetching categories from: $uri');

      final response = await http.get(uri, headers: headers);

      print('📊 [COURSE_CATEGORY_SERVICE] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<CourseCategoryModel> categories = [];

        if (decodedData is Map<String, dynamic>) {
          if (decodedData['data'] != null && decodedData['data'] is List) {
            categories = (decodedData['data'] as List)
                .map((json) => CourseCategoryModel.fromJson(json as Map<String, dynamic>))
                .toList();
          }
        } else if (decodedData is List) {
          categories = decodedData
              .map((json) => CourseCategoryModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        print('✅ [COURSE_CATEGORY_SERVICE] Successfully parsed ${categories.length} categories');
        return categories;
      } else {
        print('❌ [COURSE_CATEGORY_SERVICE] Error response: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ [COURSE_CATEGORY_SERVICE] Exception: $e');
      return [];
    }
  }
}



