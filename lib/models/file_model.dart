import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed
class FileModel with _$FileModel {
  const factory FileModel({
    required String id,
    required String originalName,
    String? displayName,
    required String filename,
    required String filePath,
    required String mimeType,
    required int fileSize,
    String? fileHash,
    String? storageProvider,
    String? storagePath,
    @Default(false) bool isEncrypted,
    String? entityType,
    String? entityId,
    String? fileCategory,
    String? folderId,
    @Default([]) List<String> tags,
    String? description,
    @Default(false) bool isPublic,
    @Default('private') String accessLevel,
    @Default('completed') String processingStatus,
    String? thumbnailPath,
    String? previewPath,
    Map<String, dynamic>? metadata,
    int? backupCount,
    DateTime? lastBackupAt,
    required String uploadedBy,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? url,
    String? thumbnailUrl,
    String? previewUrl,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}

@freezed
class FileUploadRequest with _$FileUploadRequest {
  const factory FileUploadRequest({
    required String entityType,
    required String entityId,
    required String fileCategory,
    String? folderId,
    @Default([]) List<String> tags,
    String? description,
    @Default(false) bool isPublic,
    @Default('private') String accessLevel,
  }) = _FileUploadRequest;

  factory FileUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$FileUploadRequestFromJson(json);
}

@freezed
class FileUploadResponse with _$FileUploadResponse {
  const factory FileUploadResponse({
    required String id,
    required String originalName,
    String? displayName,
    required String filename,
    required String filePath,
    required String mimeType,
    required int fileSize,
    String? fileHash,
    String? storageProvider,
    String? storagePath,
    @Default(false) bool isEncrypted,
    String? entityType,
    String? entityId,
    String? fileCategory,
    String? folderId,
    @Default([]) List<String> tags,
    String? description,
    @Default(false) bool isPublic,
    @Default('private') String accessLevel,
    @Default('pending') String processingStatus,
    String? thumbnailPath,
    String? previewPath,
    Map<String, dynamic>? metadata,
    int? backupCount,
    DateTime? lastBackupAt,
    required String uploadedBy,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? url,
    String? thumbnailUrl,
    String? previewUrl,
  }) = _FileUploadResponse;

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);
}
