import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/auth/auth.dart';
import '../../../models/file_model.dart';
import '../../../services/enhanced_dio_service_v2.dart';
import '../../../services/compatible_auth_service.dart';
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
    // الحصول على userId الحالي من authProvider
    final authState = ref.watch(authProvider);
    
    if (!authState.isAuthenticated || authState.user == null) {
      debugPrint('❌ [USER_DOCUMENTS] No authenticated user found');
      return [];
    }
    
    final currentUserId = authState.user!.id;
    debugPrint('🔍 [USER_DOCUMENTS] جلب جميع مستندات المستخدم (userId: $currentUserId)...');

    // إضافة timestamp لإجبار إعادة التحميل ومنع استخدام الكاش القديم
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    // جلب جميع الملفات من API مع userId validation
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/v1/files',
      queryParameters: {
        'page': 1,
        'limit': 100, // جلب حتى 100 ملف
        't': timestamp, // timestamp لإجبار إعادة التحميل
      },
      options: Options(
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      final allFiles = (data['files'] as List?)
              ?.map((file) => FileModel.fromJson(file))
              .toList() ??
          [];

      debugPrint('📋 [USER_DOCUMENTS] تم جلب ${allFiles.length} ملف من الـ API');
      
      // 🔍 DEBUG: طباعة تفاصيل جميع الملفات
      debugPrint('📋 [USER_DOCUMENTS] === تفاصيل جميع الملفات من API ===');
      for (var file in allFiles.take(10)) {
        debugPrint('📄 [USER_DOCUMENTS] File ${file.id}:');
        debugPrint('   - originalName: ${file.originalName}');
        debugPrint('   - uploadedBy: ${file.uploadedBy}');
        debugPrint('   - entityId: ${file.entityId}');
        debugPrint('   - entityType: ${file.entityType} (type: ${file.entityType.runtimeType})');
        debugPrint('   - fileCategory: ${file.fileCategory}');
        debugPrint('   - mimeType: ${file.mimeType}');
      }
      debugPrint('📋 [USER_DOCUMENTS] === نهاية تفاصيل الملفات ===');

      // 🔥 IMPORTANT: فلترة الملفات حسب الشروط التالية:
      // 1. entityType == 'USER_DOCUMENT' (كما في قاعدة البيانات)
      // 2. uploadedBy أو entityId يتطابق مع userId الحالي
      // 3. التحقق case-insensitive و null-safe
      final userFiles = allFiles.where((file) {
        // التحقق من أن entityType موجود وليس null
        if (file.entityType == null || file.entityType!.isEmpty) {
          debugPrint('⚠️ [USER_DOCUMENTS] Skipping file ${file.id} - entityType is null or empty');
          return false;
        }
        
        // التحقق من أن entityType = USER_DOCUMENT (case-insensitive)
        final entityTypeUpper = file.entityType!.toUpperCase().trim();
        if (entityTypeUpper != 'USER_DOCUMENT') {
          debugPrint('⚠️ [USER_DOCUMENTS] Skipping file ${file.id} - entityType is not USER_DOCUMENT: "${file.entityType}"');
          return false;
        }
        
        // التحقق من أن الملف يعود للمستخدم الحالي
        // يمكن أن يكون uploadedBy أو entityId متطابق مع userId
        final belongsToUser = (file.uploadedBy.isNotEmpty && file.uploadedBy == currentUserId) || 
                             (file.entityId != null && file.entityId!.isNotEmpty && file.entityId == currentUserId);
        
        if (!belongsToUser) {
          debugPrint('⚠️ [USER_DOCUMENTS] Skipping file ${file.id} - does not belong to user');
          debugPrint('   - uploadedBy: "${file.uploadedBy}" vs currentUserId: "$currentUserId"');
          debugPrint('   - entityId: "${file.entityId}" vs currentUserId: "$currentUserId"');
        } else {
          debugPrint('✅ [USER_DOCUMENTS] Including file ${file.id}');
          debugPrint('   - originalName: ${file.originalName}');
          debugPrint('   - entityType: ${file.entityType}');
        }
        
        return belongsToUser;
      }).toList();

      debugPrint('✅ [USER_DOCUMENTS] تم جلب ${userFiles.length} مستند للمستخدم (userId: $currentUserId)');
      
      // 🔍 DEBUG: طباعة تفاصيل الملفات المفلترة
      debugPrint('📋 [USER_DOCUMENTS] === ملخص الفلترة ===');
      debugPrint('   - إجمالي الملفات من API: ${allFiles.length}');
      debugPrint('   - الملفات المطابقة للشروط: ${userFiles.length}');
      debugPrint('   - currentUserId: $currentUserId');
      
      if (userFiles.isEmpty && allFiles.isNotEmpty) {
        debugPrint('⚠️ [USER_DOCUMENTS] WARNING: No files matched current user!');
        debugPrint('⚠️ [USER_DOCUMENTS] تحليل الملفات المستبعدة:');
        
        // إحصائيات entityType
        final entityTypeCounts = <String, int>{};
        for (var file in allFiles) {
          final entityType = file.entityType ?? 'null';
          entityTypeCounts[entityType] = (entityTypeCounts[entityType] ?? 0) + 1;
        }
        debugPrint('   - توزيع entityType:');
        entityTypeCounts.forEach((key, value) {
          debugPrint('     * "$key": $value ملف');
        });
        
        // إحصائيات userId matching
        int matchingUploadedBy = 0;
        int matchingEntityId = 0;
        int matchingBoth = 0;
        for (var file in allFiles) {
          final matchUploadedBy = file.uploadedBy == currentUserId;
          final matchEntityId = file.entityId == currentUserId;
          if (matchUploadedBy) matchingUploadedBy++;
          if (matchEntityId) matchingEntityId++;
          if (matchUploadedBy && matchEntityId) matchingBoth++;
        }
        debugPrint('   - تطابق userId:');
        debugPrint('     * matching uploadedBy: $matchingUploadedBy');
        debugPrint('     * matching entityId: $matchingEntityId');
        debugPrint('     * matching both: $matchingBoth');
        
        // عرض أول 3 ملفات كأمثلة
        debugPrint('   - أمثلة على الملفات المستبعدة:');
        for (var file in allFiles.take(3)) {
          final entityTypeMatch = (file.entityType?.toUpperCase().trim() == 'USER_DOCUMENT');
          final userIdMatch = (file.uploadedBy == currentUserId || file.entityId == currentUserId);
          debugPrint('     * File ${file.id}:');
          debugPrint('       - entityType: "${file.entityType}" (matches USER_DOCUMENT: $entityTypeMatch)');
          debugPrint('       - uploadedBy: "${file.uploadedBy}" (matches: ${file.uploadedBy == currentUserId})');
          debugPrint('       - entityId: "${file.entityId}" (matches: ${file.entityId == currentUserId})');
          debugPrint('       - will show: ${entityTypeMatch && userIdMatch}');
        }
      }
      debugPrint('📋 [USER_DOCUMENTS] === نهاية ملخص الفلترة ===');
      
      return userFiles;
    }

    debugPrint('⚠️ [USER_DOCUMENTS] لا توجد مستندات للمستخدم');
    return [];
  } catch (e) {
    debugPrint('❌ [USER_DOCUMENTS] خطأ في جلب مستندات المستخدم: $e');
    return [];
  }
});
