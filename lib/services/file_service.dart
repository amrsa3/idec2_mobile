import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';
import '../core/constants/api_constants.dart';
import 'api_service.dart';
import 'dio_service.dart';

class FileService {
  static FileService? _instance;
  static FileService get instance => _instance ??= FileService._internal();

  late ApiService _apiService;
  final ImagePicker _imagePicker = ImagePicker();

  FileService._internal() {
    _apiService = ApiService(EnhancedDioServiceV2.instance.dio);
  }

  // Pick image from gallery or camera
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  // Crop image
  Future<File?> cropImage(File imageFile) async {
    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
    return null;
  }

  // Pick file
  Future<File?> pickFile({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
    return null;
  }

  // Upload single file
  Future<FileUploadResponse?> uploadFile({
    required File file,
    required String entityType,
    required String entityId,
    required String fileCategory,
    String? folderId,
    List<String> tags = const [],
    String? description,
    bool isPublic = false,
    String accessLevel = 'private',
    Function(int, int)? onProgress,
  }) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        'entityType': entityType,
        'entityId': entityId,
        'fileCategory': fileCategory,
        if (folderId != null) 'folderId': folderId,
        if (tags.isNotEmpty) 'tags': tags.join(','),
        if (description != null) 'description': description,
        'isPublic': isPublic.toString(),
        'accessLevel': accessLevel,
      });

      final response = await _apiService.uploadFile(
        file,
        entityType,
        entityId,
        fileCategory ?? 'general',
        description ?? '',
        isPublic,
        accessLevel,
      );

      return response;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  // Upload multiple files
  Future<List<FileUploadResponse>> uploadMultipleFiles({
    required List<File> files,
    required String entityType,
    required String entityId,
    required String fileCategory,
    String? folderId,
    List<String> tags = const [],
    String? description,
    bool isPublic = false,
    String accessLevel = 'private',
    Function(int, int)? onProgress,
  }) async {
    try {
      // Upload files one by one since uploadMultipleFiles doesn't exist in ApiService
      List<FileUploadResponse> responses = [];
      for (var file in files) {
        final response = await _apiService.uploadFile(
          file,
          entityType,
          entityId,
          fileCategory ?? 'general',
          description ?? '',
          isPublic,
          accessLevel,
        );
        responses.add(response);
      }
      return responses;
    } catch (e) {
      print('Error uploading multiple files: $e');
      rethrow;
    }
  }

  // Get file by ID
  Future<FileModel?> getFile(String fileId) async {
    try {
      return await _apiService.getFile(fileId);
    } catch (e) {
      print('Error getting file: $e');
      return null;
    }
  }

  // Delete file
  Future<bool> deleteFile(String fileId) async {
    try {
      await _apiService.deleteFile(fileId);
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Download file
  Future<File?> downloadFile({
    required String fileId,
    required String fileName,
    Function(int, int)? onProgress,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      await EnhancedDioServiceV2.instance.dio.download(
        '${ApiConstants.baseUrl}/api/v1/files/$fileId/download',
        filePath,
        onReceiveProgress: onProgress,
      );

      return File(filePath);
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  // Get file thumbnail
  Future<Uint8List?> getFileThumbnail(String fileId) async {
    try {
      final response = await EnhancedDioServiceV2.instance.dio.get(
        '${ApiConstants.baseUrl}/api/v1/files/$fileId/thumbnail',
        options: Options(responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(response.data);
    } catch (e) {
      print('Error getting file thumbnail: $e');
      return null;
    }
  }

  // Get file preview
  Future<Uint8List?> getFilePreview(String fileId) async {
    try {
      final response = await EnhancedDioServiceV2.instance.dio.get(
        '${ApiConstants.baseUrl}/api/v1/files/$fileId/preview',
        options: Options(responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(response.data);
    } catch (e) {
      print('Error getting file preview: $e');
      return null;
    }
  }

  // Search files
  Future<List<FileModel>> searchFiles({
    String? query,
    String? entityType,
    String? entityId,
    String? fileCategory,
    String? folderId,
    List<String>? tags,
    String? mimeType,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Since searchFiles doesn't exist in ApiService, we'll use getFiles with available filters
      return await _apiService.getFiles(
        page,
        limit,
        entityType ?? '',
        entityId ?? '',
      );
    } catch (e) {
      print('Error searching files: $e');
      return [];
    }
  }

  // Get files with filters
  Future<List<FileModel>> getFiles({
    String? entityType,
    String? entityId,
    String? fileCategory,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _apiService.getFiles(
        page,
        limit,
        entityType ?? '',
        entityId ?? '',
      );
    } catch (e) {
      print('Error getting files: $e');
      return [];
    }
  }

  // Validate file
  bool validateFile(File file, {
    int? maxSizeInBytes,
    List<String>? allowedExtensions,
  }) {
    // Check file size
    if (maxSizeInBytes != null && file.lengthSync() > maxSizeInBytes) {
      return false;
    }

    // Check file extension
    if (allowedExtensions != null) {
      final extension = file.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        return false;
      }
    }

    return true;
  }

  // Get file size in human readable format
  String getFileSizeString(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }

  // Get file icon based on mime type
  IconData getFileIcon(String mimeType) {
    if (mimeType.startsWith('image/')) {
      return Icons.image;
    } else if (mimeType.startsWith('video/')) {
      return Icons.video_file;
    } else if (mimeType.startsWith('audio/')) {
      return Icons.audio_file;
    } else if (mimeType.contains('pdf')) {
      return Icons.picture_as_pdf;
    } else if (mimeType.contains('word') || mimeType.contains('document')) {
      return Icons.description;
    } else if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) {
      return Icons.table_chart;
    } else if (mimeType.contains('powerpoint') || mimeType.contains('presentation')) {
      return Icons.slideshow;
    } else if (mimeType.contains('zip') || mimeType.contains('archive')) {
      return Icons.archive;
    } else {
      return Icons.insert_drive_file;
    }
  }
}
