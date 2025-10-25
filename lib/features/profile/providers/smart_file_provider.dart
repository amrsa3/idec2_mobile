import 'package:flutter_riverpod/flutter_riverpod.dart';

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
