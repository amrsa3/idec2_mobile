import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../models/file_model.dart';

/// خدمة الملفات المخصصة للنظام الهرمي الجديد
class SmartFileService {
  final Dio _dio;

  SmartFileService(this._dio);

  /// الحصول على الصور الشخصية فقط
  Future<List<FileModel>> getProfileImages({
    String? entityId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('🖼️ SmartFileService: جلب الصور الشخصية...');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/files/profile-images',
        queryParameters: {
          if (entityId != null) 'entityId': entityId,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final files = (data['files'] as List?)
                ?.map((file) => FileModel.fromJson(file))
                .toList() ??
            [];

        debugPrint('✅ SmartFileService: تم جلب ${files.length} صورة شخصية');
        return files;
      }

      debugPrint('❌ SmartFileService: فشل في جلب الصور الشخصية');
      return [];
    } catch (e) {
      debugPrint('❌ SmartFileService: خطأ في جلب الصور الشخصية: $e');
      return [];
    }
  }

  /// الحصول على الوثائق والمستندات فقط
  Future<List<FileModel>> getDocuments({
    String? entityId,
    String? fileType, // pdf, word, excel, text
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('📄 SmartFileService: جلب الوثائق...');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/files/documents',
        queryParameters: {
          if (entityId != null) 'entityId': entityId,
          if (fileType != null) 'fileType': fileType,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final files = (data['files'] as List?)
                ?.map((file) => FileModel.fromJson(file))
                .toList() ??
            [];

        debugPrint('✅ SmartFileService: تم جلب ${files.length} وثيقة');
        return files;
      }

      debugPrint('❌ SmartFileService: فشل في جلب الوثائق');
      return [];
    } catch (e) {
      debugPrint('❌ SmartFileService: خطأ في جلب الوثائق: $e');
      return [];
    }
  }

  /// الحصول على المرفقات الإضافية
  Future<List<FileModel>> getAttachments({
    String? entityId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('📎 SmartFileService: جلب المرفقات الإضافية...');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/files/attachments',
        queryParameters: {
          if (entityId != null) 'entityId': entityId,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final files = (data['files'] as List?)
                ?.map((file) => FileModel.fromJson(file))
                .toList() ??
            [];

        debugPrint('✅ SmartFileService: تم جلب ${files.length} مرفق إضافي');
        return files;
      }

      debugPrint('❌ SmartFileService: فشل في جلب المرفقات الإضافية');
      return [];
    } catch (e) {
      debugPrint('❌ SmartFileService: خطأ في جلب المرفقات الإضافية: $e');
      return [];
    }
  }

  /// الحصول على الشهادات فقط
  Future<List<FileModel>> getCertificates({
    String? entityId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('🏆 SmartFileService: جلب الشهادات...');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/files/certificates',
        queryParameters: {
          if (entityId != null) 'entityId': entityId,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final files = (data['files'] as List?)
                ?.map((file) => FileModel.fromJson(file))
                .toList() ??
            [];

        debugPrint('✅ SmartFileService: تم جلب ${files.length} شهادة');
        return files;
      }

      debugPrint('❌ SmartFileService: فشل في جلب الشهادات');
      return [];
    } catch (e) {
      debugPrint('❌ SmartFileService: خطأ في جلب الشهادات: $e');
      return [];
    }
  }

  /// البحث عن الملفات حسب النوع
  Future<List<FileModel>> getFilesByType({
    required String fileType, // image, pdf, word, excel, text
    String? entityId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('🔍 SmartFileService: البحث عن ملفات من نوع $fileType...');

      final response = await _dio.get(
        '${ApiConstants.baseUrl}/files/by-type/$fileType',
        queryParameters: {
          if (entityId != null) 'entityId': entityId,
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final files = (data['files'] as List?)
                ?.map((file) => FileModel.fromJson(file))
                .toList() ??
            [];

        debugPrint(
            '✅ SmartFileService: تم العثور على ${files.length} ملف من نوع $fileType');
        return files;
      }

      debugPrint('❌ SmartFileService: فشل في البحث عن ملفات من نوع $fileType');
      return [];
    } catch (e) {
      debugPrint(
          '❌ SmartFileService: خطأ في البحث عن ملفات من نوع $fileType: $e');
      return [];
    }
  }

  /// جلب جميع الملفات مصنفة حسب الفئات
  Future<Map<String, List<FileModel>>> getAllFilesCategorized({
    String? entityId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('📁 SmartFileService: جلب جميع الملفات مصنفة...');

      // جلب الملفات من جميع الفئات بشكل متوازي
      final results = await Future.wait([
        getProfileImages(entityId: entityId, page: page, limit: limit),
        getDocuments(entityId: entityId, page: page, limit: limit),
        getAttachments(entityId: entityId, page: page, limit: limit),
        getCertificates(entityId: entityId, page: page, limit: limit),
      ]);

      final categorizedFiles = {
        'profile_images': results[0],
        'documents': results[1],
        'attachments': results[2],
        'certificates': results[3],
      };

      debugPrint('✅ SmartFileService: تم جلب الملفات مصنفة بنجاح');
      debugPrint('📊 SmartFileService: الصور الشخصية: ${results[0].length}');
      debugPrint('📊 SmartFileService: الوثائق: ${results[1].length}');
      debugPrint(
          '📊 SmartFileService: المرفقات الإضافية: ${results[2].length}');
      debugPrint('📊 SmartFileService: الشهادات: ${results[3].length}');

      return categorizedFiles;
    } catch (e) {
      debugPrint('❌ SmartFileService: خطأ في جلب الملفات مصنفة: $e');
      return {
        'profile_images': [],
        'documents': [],
        'attachments': [],
        'certificates': [],
      };
    }
  }
}
