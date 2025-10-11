import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile_model.dart';

part 'profile_data_models.freezed.dart';
part 'profile_data_models.g.dart';

/// Qualification model
@freezed
class QualificationModel with _$QualificationModel {
  const factory QualificationModel({
    required String id,
    required String nameAr,
    required String nameEn,
    @Default(false) bool? requiresDocument,
    @Default(true) bool? isActive,
    String? description,
    int? sortOrder,
  }) = _QualificationModel;

  factory QualificationModel.fromJson(Map<String, dynamic> json) =>
      _$QualificationModelFromJson(json);
}

/// University model
@freezed
class UniversityModel with _$UniversityModel {
  const factory UniversityModel({
    required String id,
    required String nameAr,
    required String nameEn,
    required String country,
    @Default(true) bool? isActive,
    String? website,
    String? logo,
    int? sortOrder,
  }) = _UniversityModel;

  factory UniversityModel.fromJson(Map<String, dynamic> json) =>
      _$UniversityModelFromJson(json);
}

/// Province/Governorate model
@freezed
class ProvinceModel with _$ProvinceModel {
  const factory ProvinceModel({
    required String id,
    required String nameAr,
    required String nameEn,
    required String country,
    @Default(true) bool? isActive,
    int? sortOrder,
  }) = _ProvinceModel;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$ProvinceModelFromJson(json);
}

/// Workplace model
@freezed
class WorkplaceModel with _$WorkplaceModel {
  const factory WorkplaceModel({
    required String id,
    required String nameAr,
    required String nameEn,
    required String type, // hospital, clinic, university, etc.
    @Default(true) bool? isActive,
    String? address,
    String? website,
    int? sortOrder,
  }) = _WorkplaceModel;

  factory WorkplaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkplaceModelFromJson(json);
}

/// Specialization model
@freezed
class SpecializationModel with _$SpecializationModel {
  const factory SpecializationModel({
    required String id,
    required String nameAr,
    required String nameEn,
    @Default(true) bool? isActive,
    String? description,
    int? sortOrder,
  }) = _SpecializationModel;

  factory SpecializationModel.fromJson(Map<String, dynamic> json) =>
      _$SpecializationModelFromJson(json);
}

/// Profile verification rules
@freezed
class ProfileVerificationRules with _$ProfileVerificationRules {
  const factory ProfileVerificationRules({
    required List<String> requiredFields,
    required Map<String, bool> documentsRequired,
    required Map<String, String> fieldValidationRules,
    String? instructions,
    int? maxFileSize, // in bytes
    List<String>? allowedFileTypes,
  }) = _ProfileVerificationRules;

  factory ProfileVerificationRules.fromJson(Map<String, dynamic> json) =>
      _$ProfileVerificationRulesFromJson(json);
}

/// Document upload model
@freezed
class DocumentUploadModel with _$DocumentUploadModel {
  const factory DocumentUploadModel({
    required String id,
    required String userId,
    required String documentType,
    required String fileName,
    required String fileUrl,
    required String status, // pending, approved, rejected
    required DateTime uploadedAt,
    String? rejectionReason,
    DateTime? reviewedAt,
    String? reviewedBy,
    Map<String, dynamic>? metadata,
  }) = _DocumentUploadModel;

  factory DocumentUploadModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentUploadModelFromJson(json);
}

// VerificationStatus moved to profile_model.dart to avoid conflicts

/// Profile completion status
@freezed
class ProfileCompletionStatus with _$ProfileCompletionStatus {
  const factory ProfileCompletionStatus({
    required int completionPercentage,
    required List<String> missingFields,
    required List<String> missingDocuments,
    required VerificationStatus verificationStatus,
    String? rejectionReason,
    DateTime? lastUpdated,
  }) = _ProfileCompletionStatus;

  factory ProfileCompletionStatus.fromJson(Map<String, dynamic> json) =>
      _$ProfileCompletionStatusFromJson(json);
}

/// Profile data response model
@freezed
class ProfileDataResponse with _$ProfileDataResponse {
  const factory ProfileDataResponse({
    required List<QualificationModel> qualifications,
    required List<UniversityModel> universities,
    required List<ProvinceModel> provinces,
    required List<WorkplaceModel> workplaces,
    required List<SpecializationModel> specializations,
    required ProfileVerificationRules verificationRules,
    ProfileCompletionStatus? completionStatus,
  }) = _ProfileDataResponse;

  factory ProfileDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataResponseFromJson(json);
}



/// Profile update response
@freezed
class ProfileUpdateResponse with _$ProfileUpdateResponse {
  const factory ProfileUpdateResponse({
    required bool success,
    required String message,
    ProfileCompletionStatus? completionStatus,
    Map<String, dynamic>? errors,
    String? reviewRequestId,
  }) = _ProfileUpdateResponse;

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateResponseFromJson(json);
}
