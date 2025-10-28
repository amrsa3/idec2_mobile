import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_constants.dart';
import '../../../models/file_model.dart';
import '../../../services/enhanced_dio_service_v2.dart';
import '../services/smart_file_service.dart';

/// Provider لخدمة الملفات الذكية
final smartFileServiceProvider = Provider<SmartFileService>((ref) {
  final dio = EnhancedDioServiceV2.instance.dio;
  return SmartFileService(dio);
});

/// Provider للحصول على الصور الشخصية
final profileImagesProvider =
    FutureProvider.family<List<FileModel>, String?>((ref, entityId) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  return await smartFileService.getProfileImages(entityId: entityId);
});

/// Provider للحصول على الوثائق
final documentsProvider =
    FutureProvider.family<List<FileModel>, Map<String, dynamic>>(
        (ref, params) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  return await smartFileService.getDocuments(
    entityId: params['entityId'],
    fileType: params['fileType'],
  );
});

/// Provider للحصول على المرفقات الإضافية
final attachmentsProvider =
    FutureProvider.family<List<FileModel>, String?>((ref, entityId) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  return await smartFileService.getAttachments(entityId: entityId);
});

/// Provider للحصول على الشهادات
final certificatesProvider =
    FutureProvider.family<List<FileModel>, String?>((ref, entityId) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  return await smartFileService.getCertificates(entityId: entityId);
});

/// Provider للحصول على الملفات حسب النوع
final filesByTypeProvider =
    FutureProvider.family<List<FileModel>, Map<String, dynamic>>(
        (ref, params) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  return await smartFileService.getFilesByType(
    fileType: params['fileType'],
    entityId: params['entityId'],
  );
});

/// Provider للحصول على جميع الملفات مصنفة
final categorizedFilesProvider =
    FutureProvider.family<Map<String, List<FileModel>>, String?>(
        (ref, entityId) async {
  final smartFileService = ref.watch(smartFileServiceProvider);
  return await smartFileService.getAllFilesCategorized(entityId: entityId);
});

/// Provider للحصول على جميع مستندات المستخدم الحالي
/// يتم إلغاء هذا الـ provider تلقائياً عند تسجيل الخروج
final userDocumentsProvider =
    FutureProvider.autoDispose<List<FileModel>>((ref) async {
  final dio = EnhancedDioServiceV2.instance.dio;

  try {
    debugPrint('🔍 جلب جميع مستندات المستخدم...');

    // جلب جميع الملفات من API
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/v1/files',
      queryParameters: {
        'page': 1,
        'limit': 100, // جلب حتى 100 ملف
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      final allFiles = (data['files'] as List?)
              ?.map((file) => FileModel.fromJson(file))
              .toList() ??
          [];

      debugPrint('📋 تم جلب ${allFiles.length} ملف من الـ API');

      // فلترة الملفات: استبعاد الصور الشخصية فقط
      final filteredFiles = allFiles.where((file) {
        // استبعاد الصور الشخصية - entityType = 'profile' و fileCategory = 'PROFILE_PHOTO'
        if (file.entityType == 'profile' &&
            (file.fileCategory == 'PROFILE_PHOTO' ||
                file.fileCategory == 'profile_photo' ||
                file.fileCategory == 'photo')) {
          return false;
        }
        return true;
      }).toList();

      debugPrint('✅ تم جلب ${filteredFiles.length} مستند للمستخدم');
      return filteredFiles;
    }

    debugPrint('⚠️ لا توجد مستندات للمستخدم');
    return [];
  } catch (e) {
    debugPrint('❌ خطأ في جلب مستندات المستخدم: $e');
    return [];
  }
});
