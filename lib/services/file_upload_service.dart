import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../core/constants/api_constants.dart';
import '../core/utils/storage_helper.dart';
import 'dio_service.dart';
import 'notification_service.dart';
import 'retry_service.dart';

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
      final token = await EnhancedDioServiceV2.instance.getAccessToken();

      if (token == null || token.isEmpty) {
        await NotificationService.showError(
          title: 'خطأ في المصادقة',
          message: 'يرجى تسجيل الدخول أولاً',
        );
        return FileUploadResult.error('غير مصرح بالوصول');
      }

      // التحقق من حجم الملف (الحد الأقصى 200 ميجابايت)
      final fileSize = await file.length();
      if (fileSize > 200 * 1024 * 1024) {
        await NotificationService.showError(
          title: 'حجم الملف كبير',
          message: 'حجم الملف يجب أن يكون أقل من 200 ميجابايت',
        );
        return FileUploadResult.error('حجم الملف كبير جداً');
      }

      // الحصول على خدمة Dio المحسنة
      final dioService = DioService.instance;
      await dioService.initialize();

      // إعداد الملف للرفع
      final fileName = path.basename(file.path);
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        'entityType': entityType,
        'entityId': entityId,
        'fileCategory': fileCategory,
        'accessLevel': accessLevel,
      });

      // إرسال الطلب مع retry mechanism محسن للملفات الكبيرة
      final response = await RetryService.instance.executeWithRetry(
        () async {
          return await dioService.dio.post(
            '/api/v1/files/upload',
            data: formData,
            options: dioService.createFileUploadOptions(
              token: token,
              sendTimeout:
                  const Duration(minutes: 30), // زيادة timeout للملفات الكبيرة
              receiveTimeout: const Duration(minutes: 30),
            ),
            onSendProgress: (sent, total) {
              if (total != -1 && onProgress != null) {
                final progress = sent / total;
                onProgress(progress);
              }
            },
          );
        },
        maxRetries: 5, // زيادة عدد المحاولات للملفات الكبيرة
        initialDelay: const Duration(seconds: 3),
        backoffMultiplier: 1.5, // تقليل معامل التأخير
        isFileUpload: true, // تفعيل معالجة خاصة للملفات
        shouldRetry: (error) {
          // إعادة المحاولة للأخطاء المؤقتة والملفات الكبيرة
          if (error is DioException) {
            return error.type == DioExceptionType.connectionTimeout ||
                error.type == DioExceptionType.sendTimeout ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.connectionError ||
                (error.response?.statusCode != null &&
                    [408, 413, 429, 500, 502, 503, 504]
                        .contains(error.response!.statusCode));
          }
          return false;
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        return FileUploadResult.success(
          fileId: data['fileId'] ?? '',
          fileUrl: data['fileUrl'] ?? '',
          fileName: fileName,
        );
      } else {
        final errorMessage = response.data['message'] ?? 'فشل في رفع الملف';

        await NotificationService.showError(
          title: 'فشل رفع الملف',
          message: errorMessage,
        );

        return FileUploadResult.error(errorMessage);
      }
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ أثناء رفع الملف';
      String errorCode = 'UNKNOWN_ERROR';

      // تحليل الأخطاء المهمة فقط
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال. تأكد من اتصالك بالإنترنت';
        errorCode = 'CONNECTION_TIMEOUT';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage =
            'انتهت مهلة إرسال الملف. قد يكون الملف كبيراً جداً أو الاتصال بطيئاً';
        errorCode = 'SEND_TIMEOUT';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة استقبال الاستجابة من الخادم';
        errorCode = 'RECEIVE_TIMEOUT';
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        switch (statusCode) {
          case 413:
            errorMessage = 'حجم الملف كبير جداً. الحد الأقصى 200 ميجابايت';
            errorCode = 'FILE_TOO_LARGE';
            break;
          case 400:
            errorMessage =
                responseData is Map && responseData['message'] != null
                    ? responseData['message']
                    : 'بيانات الملف غير صحيحة';
            errorCode = 'BAD_REQUEST';
            break;
          case 401:
            errorMessage = 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى';
            errorCode = 'UNAUTHORIZED';
            break;
          case 403:
            errorMessage = 'غير مصرح لك برفع هذا النوع من الملفات';
            errorCode = 'FORBIDDEN';
            break;
          case 422:
            errorMessage =
                responseData is Map && responseData['message'] != null
                    ? responseData['message']
                    : 'نوع الملف غير مدعوم';
            errorCode = 'UNSUPPORTED_FILE_TYPE';
            break;
          case 429:
            errorMessage =
                'تم تجاوز الحد المسموح لرفع الملفات. يرجى المحاولة لاحقاً';
            errorCode = 'RATE_LIMITED';
            break;
          case 500:
            errorMessage = 'خطأ في الخادم. يرجى المحاولة لاحقاً';
            errorCode = 'SERVER_ERROR';
            break;
          case 502:
          case 503:
          case 504:
            errorMessage = 'الخادم غير متاح حالياً. يرجى المحاولة لاحقاً';
            errorCode = 'SERVER_UNAVAILABLE';
            break;
          default:
            errorMessage = 'خطأ غير متوقع من الخادم (${statusCode})';
            errorCode = 'HTTP_ERROR_$statusCode';
        }
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'فشل الاتصال بالخادم. تحقق من اتصالك بالإنترنت';
        errorCode = 'CONNECTION_ERROR';
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'تم إلغاء رفع الملف';
        errorCode = 'CANCELLED';
      }

      // تسجيل الأخطاء المهمة فقط
      if (kDebugMode) {
        debugPrint('ERROR: File upload failed - $errorCode: $errorMessage');
        if (e.response?.statusCode != null) {
          debugPrint(
              'ERROR: HTTP ${e.response!.statusCode} - Response: ${e.response!.data}');
        }
      }

      await NotificationService.showError(
        title: 'فشل رفع الملف',
        message: errorMessage,
      );

      return FileUploadResult.error(errorMessage, errorCode: errorCode);
    } catch (e, stackTrace) {
      // تسجيل الأخطاء الحرجة فقط
      if (kDebugMode) {
        debugPrint('ERROR: Unexpected file upload error: $e');
        debugPrint('ERROR: Stack trace: $stackTrace');
      }

      await NotificationService.showError(
        title: 'خطأ غير متوقع',
        message: 'حدث خطأ غير متوقع أثناء رفع الملف',
      );

      return FileUploadResult.error('خطأ غير متوقع: $e',
          errorCode: 'UNEXPECTED_ERROR');
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
      fileCategory: 'PROFILE_PHOTO',
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

        return files;
      } else {
        if (kDebugMode) {
          debugPrint(
              'ERROR: Failed to fetch profile documents: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Failed to fetch profile documents: $e');
      }
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

      // التحقق من حجم الملف (الحد الأقصى 100 ميجابايت)
      final fileSize = await file.length();
      if (fileSize > 100 * 1024 * 1024) {
        return FileValidationResult.error(
            'حجم الملف يجب أن يكون أقل من 100 ميجابايت');
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
      if (kDebugMode) {
        debugPrint('ERROR: Failed to pick image: $e');
      }
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

        // في بيئة الويب، استخدم البيانات المرسلة مباشرة
        if (kIsWeb) {
          if (platformFile.bytes != null) {
            // في الويب، يمكن استخدام PlatformFile مباشرة
            return File('web_file_${platformFile.name}');
          } else {
            if (kDebugMode) {
              debugPrint('ERROR: No bytes available for web file upload');
            }
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
      if (kDebugMode) {
        debugPrint('ERROR: Failed to pick document: $e');
      }
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

        return true;
      } else {
        await NotificationService.showError(
          title: 'فشل حذف الملف',
          message: 'لم يتم حذف الملف',
        );

        if (kDebugMode) {
          debugPrint('ERROR: Failed to delete file: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      await NotificationService.showError(
        title: 'خطأ في حذف الملف',
        message: 'حدث خطأ أثناء حذف الملف',
      );

      if (kDebugMode) {
        debugPrint('ERROR: Failed to delete file: $e');
      }
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
        final files = (data['files'] as List? ?? data as List)
            .map((json) => UserFileModel.fromJson(json))
            .toList();

        return files;
      } else {
        if (kDebugMode) {
          debugPrint(
              'ERROR: Failed to fetch profile documents: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Failed to fetch profile documents: $e');
      }
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
  final String? errorCode;

  FileUploadResult._({
    required this.isSuccess,
    this.fileId,
    this.fileUrl,
    this.fileName,
    this.errorMessage,
    this.errorCode,
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

  factory FileUploadResult.error(String message, {String? errorCode}) {
    return FileUploadResult._(
      isSuccess: false,
      errorMessage: message,
      errorCode: errorCode,
    );
  }

  /// Check if error is retryable
  bool get isRetryableError {
    if (errorCode == null) return false;

    const retryableCodes = [
      'CONNECTION_TIMEOUT',
      'SEND_TIMEOUT',
      'RECEIVE_TIMEOUT',
      'CONNECTION_ERROR',
      'SERVER_ERROR',
      'SERVER_UNAVAILABLE',
    ];

    return retryableCodes.contains(errorCode) ||
        errorCode!.startsWith('HTTP_ERROR_5');
  }

  /// Check if error is due to file size
  bool get isFileSizeError {
    return errorCode == 'FILE_TOO_LARGE';
  }

  /// Check if error is due to authentication
  bool get isAuthError {
    return errorCode == 'UNAUTHORIZED';
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
