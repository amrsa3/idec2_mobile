// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationRequestModelImpl _$$VerificationRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      requestType:
          $enumDecode(_$VerificationRequestTypeEnumMap, json['request_type']),
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>,
      status: $enumDecodeNullable(
              _$VerificationRequestStatusEnumMap, json['status']) ??
          VerificationRequestStatus.pending,
      adminNotes: json['admin_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      reviewedBy: json['reviewed_by'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$VerificationRequestModelImplToJson(
        _$VerificationRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'request_type': _$VerificationRequestTypeEnumMap[instance.requestType]!,
      'old_data': instance.oldData,
      'new_data': instance.newData,
      'status': _$VerificationRequestStatusEnumMap[instance.status]!,
      'admin_notes': instance.adminNotes,
      'created_at': instance.createdAt.toIso8601String(),
      'reviewed_at': instance.reviewedAt?.toIso8601String(),
      'reviewed_by': instance.reviewedBy,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$VerificationRequestTypeEnumMap = {
  VerificationRequestType.profileUpdate: 'PROFILE_UPDATE',
  VerificationRequestType.documentVerification: 'DOCUMENT_VERIFICATION',
  VerificationRequestType.statusChange: 'STATUS_CHANGE',
};

const _$VerificationRequestStatusEnumMap = {
  VerificationRequestStatus.pending: 'PENDING',
  VerificationRequestStatus.approved: 'APPROVED',
  VerificationRequestStatus.rejected: 'REJECTED',
};

_$SubmitVerificationRequestImpl _$$SubmitVerificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SubmitVerificationRequestImpl(
      requestType:
          $enumDecode(_$VerificationRequestTypeEnumMap, json['request_type']),
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>,
      documentIds: (json['document_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SubmitVerificationRequestImplToJson(
        _$SubmitVerificationRequestImpl instance) =>
    <String, dynamic>{
      'request_type': _$VerificationRequestTypeEnumMap[instance.requestType]!,
      'old_data': instance.oldData,
      'new_data': instance.newData,
      'document_ids': instance.documentIds,
    };

_$VerificationRequestResponseImpl _$$VerificationRequestResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      requestId: json['request_id'] as String?,
      request: json['request'] == null
          ? null
          : VerificationRequestModel.fromJson(
              json['request'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VerificationRequestResponseImplToJson(
        _$VerificationRequestResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'request_id': instance.requestId,
      'request': instance.request,
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
