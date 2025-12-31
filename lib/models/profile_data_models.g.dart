// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QualificationModelImpl _$$QualificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QualificationModelImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      categoryId: json['categoryId'] as String,
      requiresDocument: json['requiresDocument'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QualificationModelImplToJson(
        _$QualificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'categoryId': instance.categoryId,
      'requiresDocument': instance.requiresDocument,
      'isActive': instance.isActive,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
    };

_$UniversityModelImpl _$$UniversityModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UniversityModelImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      country: json['country'] as String,
      isActive: json['isActive'] as bool? ?? true,
      website: json['website'] as String?,
      logo: json['logo'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UniversityModelImplToJson(
        _$UniversityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'country': instance.country,
      'isActive': instance.isActive,
      'website': instance.website,
      'logo': instance.logo,
      'sortOrder': instance.sortOrder,
    };

_$ProvinceModelImpl _$$ProvinceModelImplFromJson(Map<String, dynamic> json) =>
    _$ProvinceModelImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      country: json['country'] as String,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ProvinceModelImplToJson(_$ProvinceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'country': instance.country,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
    };

_$WorkplaceModelImpl _$$WorkplaceModelImplFromJson(Map<String, dynamic> json) =>
    _$WorkplaceModelImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      type: json['type'] as String,
      isActive: json['isActive'] as bool? ?? true,
      address: json['address'] as String?,
      website: json['website'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WorkplaceModelImplToJson(
        _$WorkplaceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'type': instance.type,
      'isActive': instance.isActive,
      'address': instance.address,
      'website': instance.website,
      'sortOrder': instance.sortOrder,
    };

_$SpecializationModelImpl _$$SpecializationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SpecializationModelImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpecializationModelImplToJson(
        _$SpecializationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'isActive': instance.isActive,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
    };

_$ProfileVerificationRulesImpl _$$ProfileVerificationRulesImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileVerificationRulesImpl(
      requiredFields: (json['requiredFields'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      documentsRequired:
          Map<String, bool>.from(json['documentsRequired'] as Map),
      fieldValidationRules:
          Map<String, String>.from(json['fieldValidationRules'] as Map),
      instructions: json['instructions'] as String?,
      maxFileSize: (json['maxFileSize'] as num?)?.toInt(),
      allowedFileTypes: (json['allowedFileTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ProfileVerificationRulesImplToJson(
        _$ProfileVerificationRulesImpl instance) =>
    <String, dynamic>{
      'requiredFields': instance.requiredFields,
      'documentsRequired': instance.documentsRequired,
      'fieldValidationRules': instance.fieldValidationRules,
      'instructions': instance.instructions,
      'maxFileSize': instance.maxFileSize,
      'allowedFileTypes': instance.allowedFileTypes,
    };

_$DocumentUploadModelImpl _$$DocumentUploadModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DocumentUploadModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      documentType: json['documentType'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      status: json['status'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      reviewedBy: json['reviewedBy'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DocumentUploadModelImplToJson(
        _$DocumentUploadModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'documentType': instance.documentType,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'status': instance.status,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'rejectionReason': instance.rejectionReason,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewedBy': instance.reviewedBy,
      'metadata': instance.metadata,
    };

_$ProfileCompletionStatusImpl _$$ProfileCompletionStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileCompletionStatusImpl(
      completionPercentage: (json['completionPercentage'] as num).toInt(),
      missingFields: (json['missingFields'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      missingDocuments: (json['missingDocuments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      verificationStatus:
          $enumDecode(_$VerificationStatusEnumMap, json['verificationStatus']),
      rejectionReason: json['rejectionReason'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$ProfileCompletionStatusImplToJson(
        _$ProfileCompletionStatusImpl instance) =>
    <String, dynamic>{
      'completionPercentage': instance.completionPercentage,
      'missingFields': instance.missingFields,
      'missingDocuments': instance.missingDocuments,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'rejectionReason': instance.rejectionReason,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.unverified: 'UNVERIFIED',
  VerificationStatus.underReview: 'PENDING_VERIFICATION',
  VerificationStatus.verified: 'VERIFIED',
  VerificationStatus.rejected: 'REJECTED',
};

_$ProfileDataResponseImpl _$$ProfileDataResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileDataResponseImpl(
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => QualificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      universities: (json['universities'] as List<dynamic>)
          .map((e) => UniversityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      provinces: (json['provinces'] as List<dynamic>)
          .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      workplaces: (json['workplaces'] as List<dynamic>)
          .map((e) => WorkplaceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => SpecializationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      verificationRules: ProfileVerificationRules.fromJson(
          json['verificationRules'] as Map<String, dynamic>),
      completionStatus: json['completionStatus'] == null
          ? null
          : ProfileCompletionStatus.fromJson(
              json['completionStatus'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProfileDataResponseImplToJson(
        _$ProfileDataResponseImpl instance) =>
    <String, dynamic>{
      'qualifications': instance.qualifications,
      'universities': instance.universities,
      'provinces': instance.provinces,
      'workplaces': instance.workplaces,
      'specializations': instance.specializations,
      'verificationRules': instance.verificationRules,
      'completionStatus': instance.completionStatus,
    };

_$ProfileUpdateResponseImpl _$$ProfileUpdateResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileUpdateResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      completionStatus: json['completionStatus'] == null
          ? null
          : ProfileCompletionStatus.fromJson(
              json['completionStatus'] as Map<String, dynamic>),
      errors: json['errors'] as Map<String, dynamic>?,
      reviewRequestId: json['reviewRequestId'] as String?,
    );

Map<String, dynamic> _$$ProfileUpdateResponseImplToJson(
        _$ProfileUpdateResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'completionStatus': instance.completionStatus,
      'errors': instance.errors,
      'reviewRequestId': instance.reviewRequestId,
    };
