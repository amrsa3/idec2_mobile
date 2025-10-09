// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileModelImpl _$$FileModelImplFromJson(Map<String, dynamic> json) =>
    _$FileModelImpl(
      id: json['id'] as String,
      originalName: json['originalName'] as String,
      displayName: json['displayName'] as String?,
      filename: json['filename'] as String,
      filePath: json['filePath'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      fileHash: json['fileHash'] as String?,
      storageProvider: json['storageProvider'] as String?,
      storagePath: json['storagePath'] as String?,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      fileCategory: json['fileCategory'] as String?,
      folderId: json['folderId'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      accessLevel: json['accessLevel'] as String? ?? 'private',
      processingStatus: json['processingStatus'] as String? ?? 'completed',
      thumbnailPath: json['thumbnailPath'] as String?,
      previewPath: json['previewPath'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      backupCount: (json['backupCount'] as num?)?.toInt(),
      lastBackupAt: json['lastBackupAt'] == null
          ? null
          : DateTime.parse(json['lastBackupAt'] as String),
      uploadedBy: json['uploadedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      url: json['url'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      previewUrl: json['previewUrl'] as String?,
    );

Map<String, dynamic> _$$FileModelImplToJson(_$FileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originalName': instance.originalName,
      'displayName': instance.displayName,
      'filename': instance.filename,
      'filePath': instance.filePath,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'fileHash': instance.fileHash,
      'storageProvider': instance.storageProvider,
      'storagePath': instance.storagePath,
      'isEncrypted': instance.isEncrypted,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'fileCategory': instance.fileCategory,
      'folderId': instance.folderId,
      'tags': instance.tags,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'accessLevel': instance.accessLevel,
      'processingStatus': instance.processingStatus,
      'thumbnailPath': instance.thumbnailPath,
      'previewPath': instance.previewPath,
      'metadata': instance.metadata,
      'backupCount': instance.backupCount,
      'lastBackupAt': instance.lastBackupAt?.toIso8601String(),
      'uploadedBy': instance.uploadedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'previewUrl': instance.previewUrl,
    };

_$FileUploadRequestImpl _$$FileUploadRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$FileUploadRequestImpl(
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      fileCategory: json['fileCategory'] as String,
      folderId: json['folderId'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      accessLevel: json['accessLevel'] as String? ?? 'private',
    );

Map<String, dynamic> _$$FileUploadRequestImplToJson(
        _$FileUploadRequestImpl instance) =>
    <String, dynamic>{
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'fileCategory': instance.fileCategory,
      'folderId': instance.folderId,
      'tags': instance.tags,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'accessLevel': instance.accessLevel,
    };

_$FileUploadResponseImpl _$$FileUploadResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FileUploadResponseImpl(
      id: json['id'] as String,
      originalName: json['originalName'] as String,
      displayName: json['displayName'] as String?,
      filename: json['filename'] as String,
      filePath: json['filePath'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      fileHash: json['fileHash'] as String?,
      storageProvider: json['storageProvider'] as String?,
      storagePath: json['storagePath'] as String?,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      entityType: json['entityType'] as String?,
      entityId: json['entityId'] as String?,
      fileCategory: json['fileCategory'] as String?,
      folderId: json['folderId'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      accessLevel: json['accessLevel'] as String? ?? 'private',
      processingStatus: json['processingStatus'] as String? ?? 'pending',
      thumbnailPath: json['thumbnailPath'] as String?,
      previewPath: json['previewPath'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      backupCount: (json['backupCount'] as num?)?.toInt(),
      lastBackupAt: json['lastBackupAt'] == null
          ? null
          : DateTime.parse(json['lastBackupAt'] as String),
      uploadedBy: json['uploadedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      url: json['url'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      previewUrl: json['previewUrl'] as String?,
    );

Map<String, dynamic> _$$FileUploadResponseImplToJson(
        _$FileUploadResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originalName': instance.originalName,
      'displayName': instance.displayName,
      'filename': instance.filename,
      'filePath': instance.filePath,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'fileHash': instance.fileHash,
      'storageProvider': instance.storageProvider,
      'storagePath': instance.storagePath,
      'isEncrypted': instance.isEncrypted,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'fileCategory': instance.fileCategory,
      'folderId': instance.folderId,
      'tags': instance.tags,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'accessLevel': instance.accessLevel,
      'processingStatus': instance.processingStatus,
      'thumbnailPath': instance.thumbnailPath,
      'previewPath': instance.previewPath,
      'metadata': instance.metadata,
      'backupCount': instance.backupCount,
      'lastBackupAt': instance.lastBackupAt?.toIso8601String(),
      'uploadedBy': instance.uploadedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'previewUrl': instance.previewUrl,
    };
