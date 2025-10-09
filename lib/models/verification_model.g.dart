// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationRequestModelImpl _$$VerificationRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      documentType: json['documentType'] as String,
      documentUrl: json['documentUrl'] as String,
      status: json['status'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VerificationRequestModelImplToJson(
        _$VerificationRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'documentType': instance.documentType,
      'documentUrl': instance.documentUrl,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'reviewedBy': instance.reviewedBy,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$VerificationRulesModelImpl _$$VerificationRulesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRulesModelImpl(
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      acceptedFormats: (json['acceptedFormats'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      maxFileSizeMB: (json['maxFileSizeMB'] as num).toInt(),
      instructions: json['instructions'] as String,
      additionalRules: json['additionalRules'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VerificationRulesModelImplToJson(
        _$VerificationRulesModelImpl instance) =>
    <String, dynamic>{
      'requiredDocuments': instance.requiredDocuments,
      'acceptedFormats': instance.acceptedFormats,
      'maxFileSizeMB': instance.maxFileSizeMB,
      'instructions': instance.instructions,
      'additionalRules': instance.additionalRules,
    };

_$DocumentUploadRequestImpl _$$DocumentUploadRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DocumentUploadRequestImpl(
      documentType: json['documentType'] as String,
      fileId: json['fileId'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$DocumentUploadRequestImplToJson(
        _$DocumentUploadRequestImpl instance) =>
    <String, dynamic>{
      'documentType': instance.documentType,
      'fileId': instance.fileId,
      'description': instance.description,
    };

_$VerificationRequestsResponseModelImpl
    _$$VerificationRequestsResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$VerificationRequestsResponseModelImpl(
          data: (json['data'] as List<dynamic>)
              .map((e) =>
                  VerificationRequestModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          pagination: PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$VerificationRequestsResponseModelImplToJson(
        _$VerificationRequestsResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
    };

_$PaginationModelImpl _$$PaginationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationModelImpl(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrev: json['hasPrev'] as bool,
    );

Map<String, dynamic> _$$PaginationModelImplToJson(
        _$PaginationModelImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
    };

_$SubmitVerificationRequestModelImpl
    _$$SubmitVerificationRequestModelImplFromJson(Map<String, dynamic> json) =>
        _$SubmitVerificationRequestModelImpl(
          documentType: json['documentType'] as String,
          documentUrl: json['documentUrl'] as String,
          description: json['description'] as String?,
        );

Map<String, dynamic> _$$SubmitVerificationRequestModelImplToJson(
        _$SubmitVerificationRequestModelImpl instance) =>
    <String, dynamic>{
      'documentType': instance.documentType,
      'documentUrl': instance.documentUrl,
      'description': instance.description,
    };

_$RejectVerificationRequestModelImpl
    _$$RejectVerificationRequestModelImplFromJson(Map<String, dynamic> json) =>
        _$RejectVerificationRequestModelImpl(
          reason: json['reason'] as String,
        );

Map<String, dynamic> _$$RejectVerificationRequestModelImplToJson(
        _$RejectVerificationRequestModelImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
    };
