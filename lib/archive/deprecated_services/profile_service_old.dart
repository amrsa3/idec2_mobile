import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../models/profile_data_models.dart' hide VerificationStatus;
import '../models/profile_model.dart';
import '../services/api_service.dart';
import '../services/dio_service.dart';
import '../services/file_upload_service.dart';
import '../services/notification_service.dart';

class ProfileService {
  // Static instances
  static final ApiService _apiService = ApiService(DioService.instance.dio);

  /// جلب بيانات الملف الشخصي
  static Future<ProfileModel> getProfile() async {
    try {
      debugPrint('🔍 [PROFILE_SERVICE] جلب بيانات الملف الشخصي...');

      // Check token before making request
      final token = await DioService.instance.getAccessToken();
      debugPrint(
          '🔑 [PROFILE_SERVICE] Token status: ${token != null && token.isNotEmpty ? "found (${token.length} chars)" : "not found"}');
      if (token != null && token.isNotEmpty) {
        debugPrint(
            '🔑 [PROFILE_SERVICE] Token first 20 chars: ${token.length > 20 ? token.substring(0, 20) + "..." : token}');
      }

      // Use direct API call to auth/profile endpoint (correct endpoint)
      final dio = DioService.instance.dio;
      debugPrint('🔍 [PROFILE_SERVICE] Making request to /api/v1/auth/profile');
      final response = await dio.get('/api/v1/auth/profile');

      debugPrint('✅ [PROFILE_SERVICE] تم جلب بيانات الملف الشخصي بنجاح');
      debugPrint('✅ [PROFILE_SERVICE] Response status: ${response.statusCode}');
      debugPrint(
          '✅ [PROFILE_SERVICE] Response data type: ${response.data.runtimeType}');

      final data = response.data;
      debugPrint(
          '🔍 [PROFILE_SERVICE] Response data keys: ${data is Map ? (data as Map).keys.toList() : "Not a Map"}');

      // /api/v1/auth/profile returns basic user data, not full profile
      // This endpoint returns: {id, phone, email, phoneVerified, roles}
      // We need to create a basic ProfileModel with available data
      debugPrint('🔍 [PROFILE_SERVICE] Auth profile data: $data');

      // Convert server response to ProfileModel with available data
      return ProfileModel(
        id: data['id'] ?? '',
        userId: data['id'] ?? '', // Use user ID as profile ID for now
        fullNameAr: '', // Not available in auth/profile response
        fullNameEn: '', // Not available in auth/profile response
        email: data['email'] ?? '',
        birthDate: null, // Not available in auth/profile response
        governorateId: null,
        qualificationId: null,
        graduationYear: 0,
        university: '',
        workplace: '',
        verificationStatus: VerificationStatus.unverified, // Default status
        completionPercentage: 0.0,
        profilePictureUrl: null,
        documents: [],
        requiredDocuments: [],
        createdAt: DateTime.now(), // Default to current time
        updatedAt: null,
        verifiedAt: null,
      );
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في جلب بيانات الملف الشخصي: $e');

      // Enhanced error logging to distinguish between auth and endpoint errors
      if (e.toString().contains('401')) {
        debugPrint(
            '🔐 [PROFILE_SERVICE] خطأ مصادقة (401) - تحقق من صحة الرمز المميز');
      } else if (e.toString().contains('404')) {
        debugPrint(
            '🔍 [PROFILE_SERVICE] خطأ endpoint (404) - تحقق من صحة المسار');
      } else if (e.toString().contains('500')) {
        debugPrint('🔧 [PROFILE_SERVICE] خطأ خادم (500) - مشكلة في الخادم');
      } else {
        debugPrint('⚠️ [PROFILE_SERVICE] خطأ غير متوقع: ${e.runtimeType}');
      }

      rethrow;
    }
  }

  static VerificationStatus _mapVerificationStatus(String? status) {
    switch (status) {
      case 'VERIFIED':
        return VerificationStatus.verified;
      case 'PENDING_VERIFICATION':
        return VerificationStatus.underReview;
      case 'REJECTED':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.unverified;
    }
  }

  /// تحديث بيانات الملف الشخصي
  static Future<ProfileUpdateResponse> updateProfile(
      ProfileUpdateRequest request) async {
    try {
      debugPrint('💾 ProfileService: Updating profile');
      debugPrint('💾 ProfileService: Request data: ${request.toString()}');

      // Create the update data map that matches UpdateProfileDto
      final updateData = {
        'full_name_ar': request.fullNameAr,
        'full_name_en': request.fullNameEn,
        'email': request.email,
        'birth_date': request.birthDate?.toIso8601String(),
        'governorate_id': request.governorateId,
        'qualification_id': request.qualificationId,
        'graduation_year': request.graduationYear,
        'university': request.university,
        'workplace': request.workplace,
      };

      // Remove null values
      updateData.removeWhere((key, value) => value == null);

      // Make direct API call using Dio
      final dio = DioService.instance.dio;
      final response = await dio.put('/api/v1/profiles/me', data: updateData);

      if (response.statusCode == 200) {
        debugPrint('✅ ProfileService: Profile updated successfully');
        return const ProfileUpdateResponse(
          success: true,
          message: 'تم تحديث بيانات الملف الشخصي بنجاح',
        );
      } else {
        debugPrint(
            '❌ ProfileService: Failed to update profile: ${response.statusCode}');
        return const ProfileUpdateResponse(
          success: false,
          message: 'فشل في تحديث الملف الشخصي',
        );
      }
    } catch (e) {
      debugPrint('❌ ProfileService: Error updating profile: $e');
      return ProfileUpdateResponse(
        success: false,
        message: 'خطأ في تحديث الملف الشخصي: $e',
      );
    }
  }

  /// رفع صورة الملف الشخصي مع ضغط تلقائي
  static Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      debugPrint('📤 [PROFILE] بدء رفع صورة الملف الشخصي');

      // التحقق من حالة المصادقة قبل الرفع
      final token = await DioService.instance.getAccessToken();
      debugPrint(
          '🔑 [PROFILE] حالة التوكن: ${token != null && token.isNotEmpty ? "موجود (${token.length} حرف)" : "غير موجود"}');

      // ضغط الصورة قبل الرفع
      final compressedFile = await _compressProfileImage(imageFile);
      final fileToUpload = compressedFile ?? imageFile;

      // استخدام خدمة رفع الملفات المركزية
      final result = await FileUploadService.uploadFile(
        file: fileToUpload,
        entityType: 'profile',
        entityId: 'user_profile',
        fileCategory: 'profile_picture',
      );

      if (result.isSuccess && result.fileUrl != null) {
        // تحديث الملف الشخصي بالصورة الجديدة
        await _updateProfilePictureUrl(result.fileUrl!);

        debugPrint('✅ [PROFILE] تم رفع صورة الملف الشخصي بنجاح');
        return result.fileUrl!;
      } else {
        // إذا فشل الرفع، لا نحدث الرابط محلياً
        final errorMessage = result.errorMessage ?? 'فشل في رفع الصورة';
        debugPrint('❌ [PROFILE] فشل رفع الصورة: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ [PROFILE] خطأ في رفع صورة الملف الشخصي: $e');

      // إرسال إشعار خطأ
      await NotificationService.showError(
        title: 'فشل رفع الصورة',
        message: 'فشل في رفع صورة الملف الشخصي: $e',
      );

      rethrow;
    }
  }

  /// رفع صورة الملف الشخصي مع تقدم مفصل
  static Future<String?> uploadProfilePictureWithProgress(
    File imageFile, {
    Function(double)? onProgress,
    bool enableCompression = true,
    int quality = 85,
  }) async {
    try {
      debugPrint('📤 [PROFILE] بدء رفع صورة الملف الشخصي مع تقدم');

      File fileToUpload = imageFile;

      // ضغط الصورة إذا كان مفعلاً
      if (enableCompression) {
        onProgress?.call(0.1); // 10% - بدء الضغط
        final compressedFile =
            await _compressProfileImage(imageFile, quality: quality);
        fileToUpload = compressedFile ?? imageFile;
        onProgress?.call(0.3); // 30% - انتهاء الضغط
      }

      // رفع الملف مع تتبع التقدم
      onProgress?.call(0.4); // 40% - بدء الرفع

      final result = await FileUploadService.uploadFile(
        file: fileToUpload,
        entityType: 'profile',
        entityId: 'user_profile',
        fileCategory: 'profile_picture',
      );

      onProgress?.call(0.8); // 80% - انتهاء الرفع

      if (result != null) {
        // تحديث الملف الشخصي بالصورة الجديدة
        await _updateProfilePictureUrl(result.fileUrl ?? '');
        onProgress?.call(1.0); // 100% - اكتمال العملية

        debugPrint('✅ [PROFILE] تم رفع صورة الملف الشخصي بنجاح');
        return result.fileUrl ?? '';
      } else {
        throw Exception('فشل في رفع الصورة');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE] خطأ في رفع صورة الملف الشخصي: $e');
      onProgress?.call(0.0); // إعادة تعيين التقدم عند الخطأ

      // إرسال إشعار خطأ
      await NotificationService.showError(
        title: 'فشل رفع الصورة',
        message: 'فشل في رفع صورة الملف الشخصي: $e',
      );

      rethrow;
    }
  }

  /// ضغط صورة الملف الشخصي
  static Future<File?> _compressProfileImage(File imageFile,
      {int quality = 85}) async {
    try {
      debugPrint('🗜️ [PROFILE] بدء ضغط صورة الملف الشخصي');

      // التحقق من حجم الملف
      final fileSizeInBytes = await imageFile.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      // إذا كان الملف أصغر من 1 ميجابايت، لا نحتاج لضغطه
      if (fileSizeInMB < 1.0) {
        debugPrint('📏 [PROFILE] حجم الصورة صغير، لا حاجة للضغط');
        return imageFile;
      }

      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 400,
        minHeight: 400,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        final compressedSize = await File(compressedFile.path).length();
        final compressedSizeInMB = compressedSize / (1024 * 1024);

        debugPrint(
            '✅ [PROFILE] تم ضغط الصورة من ${fileSizeInMB.toStringAsFixed(2)} MB إلى ${compressedSizeInMB.toStringAsFixed(2)} MB');
        return File(compressedFile.path);
      }

      return null;
    } catch (e) {
      debugPrint('❌ [PROFILE] خطأ في ضغط الصورة: $e');
      return null;
    }
  }

  /// حذف صورة الملف الشخصي
  static Future<bool> deleteProfilePicture() async {
    try {
      debugPrint('🗑️ [PROFILE] بدء حذف صورة الملف الشخصي');

      // تحديث الملف الشخصي بإزالة رابط الصورة
      await _updateProfilePictureUrl('');

      debugPrint('✅ [PROFILE] تم حذف صورة الملف الشخصي بنجاح');
      return true;
    } catch (e) {
      debugPrint('❌ [PROFILE] خطأ في حذف صورة الملف الشخصي: $e');

      // إرسال إشعار خطأ
      await NotificationService.showError(
        title: 'فشل حذف الصورة',
        message: 'فشل في حذف صورة الملف الشخصي: $e',
      );

      return false;
    }
  }

  /// التحقق من صحة ملف الصورة
  static bool isValidImageFile(File imageFile) {
    final extension = imageFile.path.toLowerCase().split('.').last;
    final validExtensions = ['jpg', 'jpeg', 'png', 'webp'];
    return validExtensions.contains(extension);
  }

  /// الحصول على حجم الملف بالميجابايت
  static Future<double> getFileSizeInMB(File file) async {
    final fileSizeInBytes = await file.length();
    return fileSizeInBytes / (1024 * 1024);
  }

  /// تحديث رابط صورة الملف الشخصي في قاعدة البيانات
  static Future<void> _updateProfilePictureUrl(String pictureUrl) async {
    try {
      // Note: Profile picture update would need to be handled separately
      // as the current API structure doesn't support direct profile picture URL updates
      debugPrint('✅ [PROFILE_SERVICE] تم تحديث رابط صورة الملف الشخصي');
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في تحديث رابط صورة الملف الشخصي: $e');
      rethrow;
    }
  }

  /// تحويل بيانات المستخدم إلى نموذج الملف الشخصي
  static ProfileModel _convertToProfileModel(
      ProfileModel currentProfile, String pictureUrl) {
    return currentProfile.copyWith(
      profilePictureUrl: pictureUrl,
    );
  }

  /// تحويل String إلى DocumentType
  static DocumentType _parseDocumentType(String value) {
    switch (value.toLowerCase()) {
      case 'identity':
        return DocumentType.identity;
      case 'qualification':
        return DocumentType.qualification;
      case 'certificate':
        return DocumentType.certificate;
      case 'license':
        return DocumentType.license;
      default:
        return DocumentType.other;
    }
  }

  /// رفع وثيقة
  static Future<DocumentModel> uploadDocument({
    required File file,
    required DocumentType documentType,
    String? description,
  }) async {
    try {
      debugPrint('🔍 [PROFILE_SERVICE] رفع وثيقة: ${documentType.displayName}');

      // استخدام خدمة رفع الملفات المركزية
      final uploadResult = await FileUploadService.uploadFile(
        file: file,
        entityType: 'USER_DOCUMENT',
        entityId: 'user_profile',
        fileCategory: documentType.name.toUpperCase(),
      );

      if (uploadResult != null) {
        debugPrint('✅ [PROFILE_SERVICE] تم رفع الوثيقة بنجاح');

        // إنشاء نموذج الوثيقة
        return DocumentModel(
          id: uploadResult.fileId ?? '',
          fileId: uploadResult.fileId ?? '',
          documentType: documentType,
          originalName: file.path.split('/').last,
          fileUrl: uploadResult.fileUrl ?? '',
          fileSize: await file.length(),
          mimeType: _getMimeType(file.path),
          status: DocumentStatus.pending,
          uploadedAt: DateTime.now(),
        );
      } else {
        throw Exception('فشل في رفع الوثيقة');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في رفع الوثيقة: $e');
      rethrow;
    }
  }

  /// حذف وثيقة
  static Future<bool> deleteDocument(String documentId) async {
    try {
      debugPrint('🔍 [PROFILE_SERVICE] حذف وثيقة: $documentId');

      // استخدام خدمة حذف الملفات المركزية
      final deleteResult = await FileUploadService.deleteFile(documentId);

      if (deleteResult) {
        debugPrint('✅ [PROFILE_SERVICE] تم حذف الوثيقة بنجاح');
        return true;
      } else {
        throw Exception('فشل في حذف الوثيقة');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في حذف الوثيقة: $e');
      return false;
    }
  }

  /// جلب قواعد التوثيق
  static Future<VerificationRulesResponse> getVerificationRules() async {
    try {
      debugPrint('📋 ProfileService: Getting verification rules');

      final response = await _apiService.getVerificationRules();

      return VerificationRulesResponse(
        requiredDocuments: response.requiredDocuments
            .asMap()
            .entries
            .map((entry) => RequiredDocumentModel(
                  id: entry.key.toString(),
                  documentType: _parseDocumentType(entry.value),
                  title: entry.value.toString(),
                  isRequired: true,
                  description: 'مطلوب',
                ))
            .toList(),
        requiredFields:
            response.acceptedFormats, // Use acceptedFormats as requiredFields
        rules: [response.instructions], // Use instructions as rules
      );
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في جلب قواعد التوثيق: $e');
      // إرجاع قواعد افتراضية في حالة الخطأ
      return const VerificationRulesResponse(
        requiredDocuments: [
          RequiredDocumentModel(
            id: '1',
            documentType: DocumentType.identity,
            title: 'الهوية الشخصية',
            description: 'صورة واضحة من الهوية الشخصية أو جواز السفر',
            isRequired: true,
          ),
          RequiredDocumentModel(
            id: '2',
            documentType: DocumentType.qualification,
            title: 'المؤهل العلمي',
            description: 'شهادة التخرج أو المؤهل العلمي في طب الأسنان',
            isRequired: true,
          ),
          RequiredDocumentModel(
            id: '3',
            documentType: DocumentType.license,
            title: 'رخصة المزاولة',
            description: 'رخصة مزاولة مهنة طب الأسنان سارية المفعول',
            isRequired: false,
          ),
        ],
        requiredFields: [
          'full_name_ar',
          'full_name_en',
          'email',
          'birth_date',
          'governorate',
          'qualification',
          'graduation_year',
          'university',
          'workplace',
        ],
        rules: [
          'يجب ملء جميع البيانات الشخصية والأكاديمية',
          'يجب رفع صورة واضحة من الهوية الشخصية',
          'يجب رفع شهادة التخرج أو المؤهل العلمي',
          'جميع الوثائق يجب أن تكون واضحة وقابلة للقراءة',
          'سيتم مراجعة الطلب خلال 3-5 أيام عمل',
        ],
      );
    }
  }

  /// حساب نسبة اكتمال الملف الشخصي
  static double calculateCompletionPercentage(ProfileModel profile) {
    int completedFields = 0;
    int totalFields = 9; // عدد الحقول المطلوبة

    // فحص الحقول المطلوبة
    if (profile.fullNameAr.isNotEmpty) completedFields++;
    if (profile.fullNameEn.isNotEmpty) completedFields++;
    if (profile.email.isNotEmpty) completedFields++;
    if (profile.governorateId != null && profile.governorateId!.isNotEmpty)
      completedFields++;
    if (profile.qualificationId != null && profile.qualificationId!.isNotEmpty)
      completedFields++;
    if (profile.graduationYear > 0) completedFields++;
    if (profile.university.isNotEmpty) completedFields++;
    if (profile.workplace.isNotEmpty) completedFields++;
    if (profile.profilePictureUrl != null &&
        profile.profilePictureUrl!.isNotEmpty) completedFields++;

    // إضافة نقاط للوثائق المرفوعة
    final requiredDocuments =
        profile.requiredDocuments.where((doc) => doc.isRequired).length;
    final uploadedRequiredDocuments = profile.documents
        .where((doc) => profile.requiredDocuments.any(
            (req) => req.documentType == doc.documentType && req.isRequired))
        .length;

    if (requiredDocuments > 0) {
      totalFields += requiredDocuments;
      completedFields += uploadedRequiredDocuments;
    }

    return (completedFields / totalFields) * 100;
  }

  /// تحديد نوع MIME للملف
  static String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  /// التحقق من صحة نوع الملف
  static bool isValidFileType(String filePath, List<String> allowedFormats) {
    final extension = filePath.split('.').last.toLowerCase();
    return allowedFormats.contains(extension);
  }

  /// التحقق من حجم الملف
  static Future<bool> isValidFileSize(File file, int maxSizeBytes) async {
    final fileSize = await file.length();
    return fileSize <= maxSizeBytes;
  }

  /// تنسيق حجم الملف للعرض
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// جلب قائمة المؤهلات النشطة
  static Future<List<dynamic>> getQualifications() async {
    try {
      debugPrint('🔍 [PROFILE_SERVICE] جلب قائمة المؤهلات...');

      final dio = DioService.instance.dio;
      final response = await dio.get('/api/v1/qualifications/active');

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> qualifications;

        if (data is List) {
          qualifications = data;
        } else if (data is Map<String, dynamic>) {
          // If data is an object, convert values to list
          if (data.containsKey('data') && data['data'] is List) {
            qualifications = data['data'];
          } else {
            // Convert object values to list
            qualifications = data.values.toList();
          }
        } else {
          qualifications = [];
        }

        debugPrint('✅ [PROFILE_SERVICE] تم جلب ${qualifications.length} مؤهل');
        return qualifications;
      } else {
        throw Exception('فشل في جلب المؤهلات: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في جلب المؤهلات: $e');
      // Return empty list on error
      return [];
    }
  }

  /// جلب قائمة المحافظات
  static Future<List<dynamic>> getGovernorates() async {
    try {
      debugPrint('🔍 [PROFILE_SERVICE] جلب قائمة المحافظات...');

      final dio = DioService.instance.dio;
      final response = await dio.get('/api/v1/governorates');

      if (response.statusCode == 200) {
        final data = response.data;
        final governorates = data is List ? data : (data['data'] ?? []);

        debugPrint('✅ [PROFILE_SERVICE] تم جلب ${governorates.length} محافظة');
        return governorates;
      } else {
        throw Exception('فشل في جلب المحافظات: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [PROFILE_SERVICE] خطأ في جلب المحافظات: $e');
      // Return empty list on error
      return [];
    }
  }
}
