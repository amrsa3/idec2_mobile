import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../core/constants/app_constants.dart';
import '../../core/constants/api_constants.dart';
import '../../services/platform_storage_service.dart';

/// Upload file types
enum FileType {
  image,
  document,
  profilePicture,
  verificationDocument,
}

/// File upload result
class FileUploadResult {
    final bool success;
    final String? fileUrl;
    final String? fileName;
    final String? error;
    final Map<String, dynamic>? metadata;

    const FileUploadResult({
      required this.success,
      this.fileUrl,
      this.fileName,
      this.error,
      this.metadata,
    });

    factory FileUploadResult.success({
      required String fileUrl,
      required String fileName,
      Map<String, dynamic>? metadata,
    }) {
      return FileUploadResult(
        success: true,
        fileUrl: fileUrl,
        fileName: fileName,
        metadata: metadata,
      );
    }

    factory FileUploadResult.error(String error) {
      return FileUploadResult(
        success: false,
        error: error,
      );
    }
  }

class FileUploadService {
  static final Dio _dio = Dio();
  static final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from gallery or camera
  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    int? imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      debugPrint('📸 FileUploadService: Picking image from $source');
      
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image != null) {
        debugPrint('📸 FileUploadService: Image picked successfully: ${image.name}');
        debugPrint('📸 File size: ${await image.length()} bytes');
      } else {
        debugPrint('📸 FileUploadService: No image selected');
      }

      return image;
    } catch (e) {
      debugPrint('❌ FileUploadService: Error picking image: $e');
      return null;
    }
  }

  /// Pick document file
  static Future<PlatformFile?> pickDocument({
    List<String>? allowedExtensions,
    int? fileSizeLimit, // in bytes
  }) async {
    try {
      debugPrint('📄 FileUploadService: Picking document');
      
      file_picker.FilePickerResult? result = await file_picker.FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? file_picker.FileType.custom : file_picker.FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        debugPrint('📄 FileUploadService: Document picked successfully: ${file.name}');
        debugPrint('📄 File size: ${file.size} bytes');

        // Check file size limit
        if (fileSizeLimit != null && file.size > fileSizeLimit) {
          debugPrint('❌ FileUploadService: File size exceeds limit');
          return null;
        }

        return file;
      } else {
        debugPrint('📄 FileUploadService: No document selected');
        return null;
      }
    } catch (e) {
      debugPrint('❌ FileUploadService: Error picking document: $e');
      return null;
    }
  }

  /// Upload file to server
  static Future<FileUploadResult> uploadFile({
    required dynamic file, // XFile, PlatformFile, or File
    required FileType fileType,
    String? customPath,
    Map<String, dynamic>? additionalData,
    Function(int, int)? onProgress,
  }) async {
    try {
      debugPrint('📤 FileUploadService: Starting file upload');
      debugPrint('📤 File type: $fileType');

      // Get authentication token
      final token = await PlatformStorageService.instance.getAccessToken();
      if (token == null) {
        return FileUploadResult.error('Authentication token not found');
      }

      // Prepare file data
      MultipartFile multipartFile;
      String fileName;

      if (file is XFile) {
        fileName = file.name;
        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          multipartFile = MultipartFile.fromBytes(
            bytes,
            filename: fileName,
          );
        } else {
          multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          );
        }
      } else if (file is PlatformFile) {
        fileName = file.name;
        if (file.bytes != null) {
          multipartFile = MultipartFile.fromBytes(
            file.bytes!,
            filename: fileName,
          );
        } else if (file.path != null) {
          multipartFile = await MultipartFile.fromFile(
            file.path!,
            filename: fileName,
          );
        } else {
          return FileUploadResult.error('Invalid file data');
        }
      } else if (file is File) {
        fileName = path.basename(file.path);
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        );
      } else {
        return FileUploadResult.error('Unsupported file type');
      }

      // Prepare form data
      final formData = FormData.fromMap({
        'file': multipartFile,
        'fileType': fileType.name,
        if (customPath != null) 'path': customPath,
        if (additionalData != null) ...additionalData,
      });

      // Set up dio options
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      );

      debugPrint('📤 FileUploadService: Uploading to ${ApiConstants.baseUrl}/upload');

      // Upload file
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/upload',
        data: formData,
        options: options,
        onSendProgress: onProgress,
      );

      debugPrint('📤 FileUploadService: Upload response status: ${response.statusCode}');
      debugPrint('📤 FileUploadService: Upload response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        if (data['success'] == true) {
          return FileUploadResult.success(
            fileUrl: data['fileUrl'] ?? data['url'],
            fileName: data['fileName'] ?? fileName,
            metadata: data['metadata'],
          );
        } else {
          return FileUploadResult.error(
            data['message'] ?? 'Upload failed',
          );
        }
      } else {
        return FileUploadResult.error(
          'Upload failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ FileUploadService: Upload error: $e');
      
      if (e is DioException) {
        if (e.response?.data != null) {
          final errorData = e.response!.data;
          return FileUploadResult.error(
            errorData['message'] ?? 'Upload failed',
          );
        } else {
          return FileUploadResult.error(
            'Network error: ${e.message}',
          );
        }
      }
      
      return FileUploadResult.error('Upload failed: $e');
    }
  }

  /// Upload profile picture
  static Future<FileUploadResult> uploadProfilePicture(XFile imageFile) async {
    return uploadFile(
      file: imageFile,
      fileType: FileType.profilePicture,
      customPath: 'profiles',
    );
  }

  /// Upload verification document
  static Future<FileUploadResult> uploadVerificationDocument({
    required dynamic file,
    required String documentType,
    String? userId,
  }) async {
    return uploadFile(
      file: file,
      fileType: FileType.verificationDocument,
      customPath: 'verification',
      additionalData: {
        'documentType': documentType,
        if (userId != null) 'userId': userId,
      },
    );
  }

  /// Delete file from server
  static Future<bool> deleteFile(String fileUrl) async {
    try {
      debugPrint('🗑️ FileUploadService: Deleting file: $fileUrl');

      final token = await PlatformStorageService.instance.getAccessToken();
      if (token == null) {
        debugPrint('❌ FileUploadService: Authentication token not found');
        return false;
      }

      final response = await _dio.delete(
        '${ApiConstants.baseUrl}/upload',
        data: {'fileUrl': fileUrl},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      debugPrint('🗑️ FileUploadService: Delete response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ FileUploadService: Delete error: $e');
      return false;
    }
  }

  /// Get file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if file type is supported
  static bool isFileTypeSupported(String fileName, List<String> allowedExtensions) {
    final extension = path.extension(fileName).toLowerCase();
    return allowedExtensions.contains(extension);
  }

  /// Get file extension
  static String getFileExtension(String fileName) {
    return path.extension(fileName).toLowerCase();
  }

  /// Validate image file
  static bool isValidImageFile(String fileName) {
    const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return isFileTypeSupported(fileName, allowedExtensions);
  }

  /// Validate document file
  static bool isValidDocumentFile(String fileName) {
    const allowedExtensions = ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png'];
    return isFileTypeSupported(fileName, allowedExtensions);
  }

  /// Compress image if needed
  static Future<Uint8List?> compressImage(
    Uint8List imageBytes, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      // For web, we'll use the original bytes for now
      // In a real app, you might want to use a package like image for compression
      if (kIsWeb) {
        return imageBytes;
      }
      
      // For mobile, you can implement image compression here
      return imageBytes;
    } catch (e) {
      debugPrint('❌ FileUploadService: Image compression error: $e');
      return null;
    }
  }
}


