// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileModelImpl _$$ProfileModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfileModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullNameAr: json['full_name_ar'] as String? ?? '',
      fullNameEn: json['full_name_en'] as String? ?? '',
      email: json['email'] as String? ?? '',
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      governorateId: json['governorate_id'] as String?,
      qualificationId: json['qualification_id'] as String?,
      graduationYear: (json['graduation_year'] as num?)?.toInt() ?? 0,
      university: json['university'] as String? ?? '',
      workplace: json['workplace'] as String? ?? '',
      verificationStatus: $enumDecodeNullable(
              _$VerificationStatusEnumMap, json['verificationStatus']) ??
          VerificationStatus.unverified,
      completionPercentage:
          (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
      rejectionReason: json['rejection_reason'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      requiredDocuments: (json['required_documents'] as List<dynamic>?)
              ?.map((e) =>
                  RequiredDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
    );

Map<String, dynamic> _$$ProfileModelImplToJson(_$ProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'full_name_ar': instance.fullNameAr,
      'full_name_en': instance.fullNameEn,
      'email': instance.email,
      'birth_date': instance.birthDate?.toIso8601String(),
      'governorate_id': instance.governorateId,
      'qualification_id': instance.qualificationId,
      'graduation_year': instance.graduationYear,
      'university': instance.university,
      'workplace': instance.workplace,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'completion_percentage': instance.completionPercentage,
      'rejection_reason': instance.rejectionReason,
      'profile_picture_url': instance.profilePictureUrl,
      'documents': instance.documents,
      'required_documents': instance.requiredDocuments,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'verified_at': instance.verifiedAt?.toIso8601String(),
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.unverified: 'unverified',
  VerificationStatus.underReview: 'under_review',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
};

_$DocumentModelImpl _$$DocumentModelImplFromJson(Map<String, dynamic> json) =>
    _$DocumentModelImpl(
      id: json['id'] as String,
      fileId: json['file_id'] as String,
      documentType: $enumDecode(_$DocumentTypeEnumMap, json['document_type']),
      originalName: json['original_name'] as String,
      fileUrl: json['file_url'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String,
      status: $enumDecodeNullable(_$DocumentStatusEnumMap, json['status']) ??
          DocumentStatus.pending,
      adminNotes: json['admin_notes'] as String?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
    );

Map<String, dynamic> _$$DocumentModelImplToJson(_$DocumentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file_id': instance.fileId,
      'document_type': _$DocumentTypeEnumMap[instance.documentType]!,
      'original_name': instance.originalName,
      'file_url': instance.fileUrl,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'status': _$DocumentStatusEnumMap[instance.status]!,
      'admin_notes': instance.adminNotes,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'reviewed_at': instance.reviewedAt?.toIso8601String(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.identity: 'identity',
  DocumentType.qualification: 'qualification',
  DocumentType.certificate: 'certificate',
  DocumentType.license: 'license',
  DocumentType.other: 'other',
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.pending: 'pending',
  DocumentStatus.approved: 'approved',
  DocumentStatus.rejected: 'rejected',
};

_$RequiredDocumentModelImpl _$$RequiredDocumentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RequiredDocumentModelImpl(
      id: json['id'] as String,
      documentType: $enumDecode(_$DocumentTypeEnumMap, json['document_type']),
      title: json['title'] as String,
      description: json['description'] as String,
      isRequired: json['is_required'] as bool? ?? true,
      maxFileSize: (json['max_file_size'] as num?)?.toInt() ?? 5242880,
      allowedFormats: (json['allowed_formats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['pdf', 'jpg', 'jpeg', 'png'],
    );

Map<String, dynamic> _$$RequiredDocumentModelImplToJson(
        _$RequiredDocumentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'document_type': _$DocumentTypeEnumMap[instance.documentType]!,
      'title': instance.title,
      'description': instance.description,
      'is_required': instance.isRequired,
      'max_file_size': instance.maxFileSize,
      'allowed_formats': instance.allowedFormats,
    };

_$ProfileUpdateRequestImpl _$$ProfileUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileUpdateRequestImpl(
      fullNameAr: json['full_name_ar'] as String?,
      fullNameEn: json['full_name_en'] as String?,
      email: json['email'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      governorateId: json['governorate_id'] as String?,
      qualificationId: json['qualification_id'] as String?,
      graduationYear: (json['graduation_year'] as num?)?.toInt(),
      university: json['university'] as String?,
      workplace: json['workplace'] as String?,
    );

Map<String, dynamic> _$$ProfileUpdateRequestImplToJson(
        _$ProfileUpdateRequestImpl instance) =>
    <String, dynamic>{
      'full_name_ar': instance.fullNameAr,
      'full_name_en': instance.fullNameEn,
      'email': instance.email,
      'birth_date': instance.birthDate?.toIso8601String(),
      'governorate_id': instance.governorateId,
      'qualification_id': instance.qualificationId,
      'graduation_year': instance.graduationYear,
      'university': instance.university,
      'workplace': instance.workplace,
    };

_$VerificationRulesResponseImpl _$$VerificationRulesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRulesResponseImpl(
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>?)
              ?.map((e) =>
                  RequiredDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      requiredFields: (json['required_fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rules:
          (json['rules'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$VerificationRulesResponseImplToJson(
        _$VerificationRulesResponseImpl instance) =>
    <String, dynamic>{
      'requiredDocuments': instance.requiredDocuments,
      'required_fields': instance.requiredFields,
      'rules': instance.rules,
    };
