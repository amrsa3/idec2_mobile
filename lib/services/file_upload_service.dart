import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../core/constants/api_constants.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/storage_helper.dart';
import 'dio_service.dart';
import 'notification_service.dart';

/// خدمة رفع الملفات المركزية
/// تدير جميع عمليات رفع الملفات والصور في التطبيق
class FileUploadService {
  static String get _baseUrl => ApiConstants.baseUrl;

  /// رفع ملف إلى الخادم
  static Future<FileUploadResult> uploadFile({
    required File file,
    required String entityType,
    required String entityId,
    required String fileCategory,
    String accessLevel = 'private',
    Function(double)? onProgress,
  }) async {
    try {
      final token = await DioService.instance.getAccessToken();
      debugPrint('🔑 [FILE_UPLOAD] Token retrieved: ${token != null ? "موجود (${token.length} حرف)" : "غير موجود"}');

      if (token == null || token.isEmpty) {
        debugPrint('❌ [FILE_UPLOAD] لا يوجد توكن مصادقة');
        await NotificationService.showError(
          title: 'خطأ في المصادقة',
          message: 'يرجى تسجيل الدخول أولاً',
        );
        return FileUploadResult.error('غير مصرح بالوصول');
      }

      // التحقق من حجم الملف (الحد الأقصى 10 ميجابايت)
      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        await NotificationService.showError(
          title: 'حجم الملف كبير',
          message: 'حجم الملف يجب أن يكون أقل من 10 ميجابايت',
        );
        return FileUploadResult.error('حجم الملف كبير جداً');
      }

      // إنشاء طلب multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl${ApiConstants.uploadFile}'),
      );

      // إضافة الهيدرز
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // إضافة الملف
      final fileName = path.basename(file.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
      );
      request.files.add(multipartFile);

      // إضافة البيانات الإضافية
      request.fields.addAll({
        'entityType': entityType,
        'entityId': entityId,
        'fileCategory': fileCategory,
        'accessLevel': accessLevel,
      });

      debugPrint('🔄 [FILE_UPLOAD] بدء رفع الملف: $fileName');
      debugPrint('🔄 [FILE_UPLOAD] النوع: $entityType, التصنيف: $fileCategory');

      // إرسال الطلب
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        await NotificationService.showSuccess(
          title: 'تم رفع الملف',
          message: 'تم رفع الملف بنجاح',
        );

        debugPrint('✅ [FILE_UPLOAD] تم رفع الملف بنجاح: ${data['fileId']}');

        return FileUploadResult.success(
          fileId: data['fileId'] ?? '',
          fileUrl: data['fileUrl'] ?? '',
          fileName: fileName,
        );
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'فشل في رفع الملف';

        await NotificationService.showError(
          title: 'فشل رفع الملف',
          message: errorMessage,
        );

        debugPrint('❌ [FILE_UPLOAD] فشل رفع الملف: ${response.statusCode}');
        return FileUploadResult.error(errorMessage);
      }
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ في رفع الملف',
        message: 'حدث خطأ غير متوقع أثناء رفع الملف',
      );

      debugPrint('❌ [FILE_UPLOAD] خطأ في رفع الملف: $e');
      return FileUploadResult.error('خطأ في رفع الملف: $e');
    }
  }

  /// رفع صورة الملف الشخصي
  static Future<FileUploadResult> uploadProfilePicture({
    required File imageFile,
    required String userId,
    Function(double)? onProgress,
  }) async {
    return await uploadFile(
      file: imageFile,
      entityType: 'USER_PROFILE_PICTURE',
      entityId: userId,
      fileCategory: 'PROFILE_PICTURE',
      accessLevel: 'public',
      onProgress: onProgress,
    );
  }

  /// رفع وثيقة مستخدم
  static Future<FileUploadResult> uploadUserDocument({
    required File documentFile,
    required String userId,
    required String documentType, // IDENTITY, QUALIFICATION, CERTIFICATE, OTHER
    Function(double)? onProgress,
  }) async {
    return await uploadFile(
      file: documentFile,
      entityType: 'USER_DOCUMENT',
      entityId: userId,
      fileCategory: documentType,
      accessLevel: 'private',
      onProgress: onProgress,
    );
  }

  /// رفع وثيقة للملف الشخصي (لحقل معين)
  static Future<FileUploadResult> uploadProfileDocument({
    required File documentFile,
    required String profileId,
    required String fieldName,
    String? displayName,
    Function(double)? onProgress,
  }) async {
    return await uploadFile(
      file: documentFile,
      entityType: 'profile',
      entityId: profileId,
      fileCategory: fieldName,
      accessLevel: 'private',
      onProgress: onProgress,
    );
  }

  /// جلب وثائق الملف الشخصي
  static Future<List<UserFileModel>> getProfileDocuments({
    required String profileId,
    String? fieldName,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null) {
        return [];
      }

      final queryParams = <String, String>{
        'entityType': 'profile',
        'entityId': profileId,
        if (fieldName != null) 'fileCategory': fieldName,
      };

      final uri = Uri.parse('$_baseUrl/api/files')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = (data['files'] as List? ?? data as List)
            .map((json) => UserFileModel.fromJson(json))
            .toList();

        debugPrint('✅ [FILE_UPLOAD] تم جلب ${files.length} وثيقة للملف الشخصي');
        return files;
      } else {
        debugPrint(
            '❌ [FILE_UPLOAD] فشل جلب وثائق الملف الشخصي: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [FILE_UPLOAD] خطأ في جلب وثائق الملف الشخصي: $e');
      return [];
    }
  }

  /// التحقق من صحة الملف قبل الرفع
  static Future<FileValidationResult> validateFile(File file) async {
    try {
      // التحقق من وجود الملف
      if (!await file.exists()) {
        return FileValidationResult.error('الملف غير موجود');
      }

      // التحقق من حجم الملف (الحد الأقصى 5 ميجابايت)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        return FileValidationResult.error(
            'حجم الملف يجب أن يكون أقل من 5 ميجابايت');
      }

      // التحقق من نوع الملف
      final fileName = path.basename(file.path);
      final extension = path.extension(fileName).toLowerCase();

      final allowedExtensions = ['.pdf', '.jpg', '.jpeg', '.png'];
      if (!allowedExtensions.contains(extension)) {
        return FileValidationResult.error(
            'نوع الملف غير مسموح. الأنواع المسموحة: PDF, JPG, PNG');
      }

      return FileValidationResult.success();
    } catch (e) {
      return FileValidationResult.error('خطأ في التحقق من الملف: $e');
    }
  }

  /// اختيار صورة من المعرض أو الكاميرا
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 80,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ في اختيار الصورة',
        message: 'فشل في اختيار الصورة',
      );
      debugPrint('❌ [FILE_UPLOAD] خطأ في اختيار الصورة: $e');
      return null;
    }
  }

  /// اختيار ملف من النظام
  static Future<File?> pickDocument({
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;
        
        // في بيئة الويب، path غير متاح ويجب استخدام bytes
        if (kIsWeb) {
          if (platformFile.bytes != null) {
            // إنشاء ملف مؤقت من البايتات للويب
            // ملاحظة: هذا لن يعمل بشكل مثالي في الويب، يجب استخدام PlatformFile مباشرة
            await NotificationService.showError(
              title: 'غير مدعوم',
              message: 'رفع الملفات غير مدعوم في بيئة الويب حالياً',
            );
            return null;
          }
        } else {
          // في البيئات الأخرى (Android/iOS)، استخدم path
          if (platformFile.path != null) {
            return File(platformFile.path!);
          }
        }
      }
      return null;
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ في اختيار الملف',
        message: 'فشل في اختيار الملف: ${e.toString()}',
      );
      debugPrint('❌ [FILE_UPLOAD] خطأ في اختيار الملف: $e');
      return null;
    }
  }

  /// حذف ملف من الخادم
  static Future<bool> deleteFile(String fileId) async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null) {
        await NotificationService.showError(
          title: 'خطأ في المصادقة',
          message: 'يرجى تسجيل الدخول أولاً',
        );
        return false;
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/api/files/$fileId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await NotificationService.showSuccess(
          title: 'تم حذف الملف',
          message: 'تم حذف الملف بنجاح',
        );

        debugPrint('✅ [FILE_UPLOAD] تم حذف الملف: $fileId');
        return true;
      } else {
        await NotificationService.showError(
          title: 'فشل حذف الملف',
          message: 'لم يتم حذف الملف',
        );

        debugPrint('❌ [FILE_UPLOAD] فشل حذف الملف: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ في حذف الملف',
        message: 'حدث خطأ أثناء حذف الملف',
      );

      debugPrint('❌ [FILE_UPLOAD] خطأ في حذف الملف: $e');
      return false;
    }
  }

  /// جلب قائمة ملفات المستخدم
  static Future<List<UserFileModel>> getUserFiles({
    required String userId,
    String? fileCategory,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null) {
        return [];
      }

      final queryParams = <String, String>{
        'entityType': 'USER_DOCUMENT',
        'entityId': userId,
        if (fileCategory != null) 'fileCategory': fileCategory,
      };

      final uri = Uri.parse('$_baseUrl/api/files')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = (data['files'] as List)
            .map((json) => UserFileModel.fromJson(json))
            .toList();

        debugPrint('✅ [FILE_UPLOAD] تم جلب ${files.length} ملف للمستخدم');
        return files;
      } else {
        debugPrint(
            '❌ [FILE_UPLOAD] فشل جلب ملفات المستخدم: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [FILE_UPLOAD] خطأ في جلب ملفات المستخدم: $e');
      return [];
    }
  }
}

/// نتيجة رفع الملف
class FileUploadResult {
  final bool isSuccess;
  final String? fileId;
  final String? fileUrl;
  final String? fileName;
  final String? errorMessage;

  FileUploadResult._({
    required this.isSuccess,
    this.fileId,
    this.fileUrl,
    this.fileName,
    this.errorMessage,
  });

  factory FileUploadResult.success({
    required String fileId,
    required String fileUrl,
    required String fileName,
  }) {
    return FileUploadResult._(
      isSuccess: true,
      fileId: fileId,
      fileUrl: fileUrl,
      fileName: fileName,
    );
  }

  factory FileUploadResult.error(String message) {
    return FileUploadResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}

/// نموذج ملف المستخدم
class UserFileModel {
  final String id;
  final String originalName;
  final String fileName;
  final String filePath;
  final String mimeType;
  final int fileSize;
  final String entityType;
  final String entityId;
  final String fileCategory;
  final String accessLevel;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserFileModel({
    required this.id,
    required this.originalName,
    required this.fileName,
    required this.filePath,
    required this.mimeType,
    required this.fileSize,
    required this.entityType,
    required this.entityId,
    required this.fileCategory,
    required this.accessLevel,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserFileModel.fromJson(Map<String, dynamic> json) {
    return UserFileModel(
      id: json['id'] ?? '',
      originalName: json['originalName'] ?? '',
      fileName: json['fileName'] ?? '',
      filePath: json['filePath'] ?? '',
      mimeType: json['mimeType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      entityType: json['entityType'] ?? '',
      entityId: json['entityId'] ?? '',
      fileCategory: json['fileCategory'] ?? '',
      accessLevel: json['accessLevel'] ?? 'private',
      isPublic: json['isPublic'] ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalName': originalName,
      'fileName': fileName,
      'filePath': filePath,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'entityType': entityType,
      'entityId': entityId,
      'fileCategory': fileCategory,
      'accessLevel': accessLevel,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// الحصول على رابط الملف الكامل
  String get fullUrl {
    if (filePath.startsWith('http')) {
      return filePath;
    }
    return '${ApiConstants.baseUrl}$filePath';
  }

  /// تحديد ما إذا كان الملف صورة
  bool get isImage {
    return mimeType.startsWith('image/');
  }

  /// تحديد ما إذا كان الملف PDF
  bool get isPdf {
    return mimeType == 'application/pdf';
  }

  /// الحصول على حجم الملف بصيغة قابلة للقراءة
  String get readableFileSize {
    if (fileSize < 1024) {
      return '$fileSize بايت';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} كيلوبايت';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} ميجابايت';
    }
  }
}

/// نتيجة التحقق من صحة الملف
class FileValidationResult {
  final bool isValid;
  final String? errorMessage;

  FileValidationResult._({
    required this.isValid,
    this.errorMessage,
  });

  factory FileValidationResult.success() {
    return FileValidationResult._(isValid: true);
  }

  factory FileValidationResult.error(String message) {
    return FileValidationResult._(
      isValid: false,
      errorMessage: message,
    );
  }
}
