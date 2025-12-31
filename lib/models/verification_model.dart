import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_model.freezed.dart';
part 'verification_model.g.dart';

@freezed
class VerificationRequestModel with _$VerificationRequestModel {
  const factory VerificationRequestModel({
    required String id,
    required String userId,
    required String documentType, // 'license', 'certificate', 'id_card', 'passport'
    required String documentUrl,
    required String status, // 'pending', 'approved', 'rejected', 'under_review'
    String? rejectionReason,
    String? reviewedBy,
    DateTime? reviewedAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _VerificationRequestModel;

  factory VerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestModelFromJson(json);
}

@freezed
class VerificationRulesModel with _$VerificationRulesModel {
  const factory VerificationRulesModel({
    required List<String> requiredDocuments,
    required List<String> acceptedFormats,
    required int maxFileSizeMB,
    required String instructions,
    Map<String, dynamic>? additionalRules,
  }) = _VerificationRulesModel;

  factory VerificationRulesModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationRulesModelFromJson(json);
}

@freezed
class DocumentUploadRequest with _$DocumentUploadRequest {
  const factory DocumentUploadRequest({
    required String documentType,
    required String fileId,
    String? description,
  }) = _DocumentUploadRequest;

  factory DocumentUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentUploadRequestFromJson(json);
}

@freezed
class VerificationRequestsResponseModel with _$VerificationRequestsResponseModel {
  const factory VerificationRequestsResponseModel({
    required List<VerificationRequestModel> data,
    required PaginationModel pagination,
  }) = _VerificationRequestsResponseModel;

  factory VerificationRequestsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestsResponseModelFromJson(json);
}

@freezed
class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    required int page,
    required int limit,
    required int total,
    required int totalPages,
    required bool hasNext,
    required bool hasPrev,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}

@freezed
class SubmitVerificationRequestModel with _$SubmitVerificationRequestModel {
  const factory SubmitVerificationRequestModel({
    required String documentType,
    required String documentUrl,
    String? description,
  }) = _SubmitVerificationRequestModel;

  factory SubmitVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitVerificationRequestModelFromJson(json);
}

@freezed
class RejectVerificationRequestModel with _$RejectVerificationRequestModel {
  const factory RejectVerificationRequestModel({
    required String reason,
  }) = _RejectVerificationRequestModel;

  factory RejectVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RejectVerificationRequestModelFromJson(json);
}
