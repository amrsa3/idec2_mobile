import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_request_model.freezed.dart';
part 'verification_request_model.g.dart';

// أنواع طلبات التوثيق
enum VerificationRequestType {
  @JsonValue('PROFILE_UPDATE')
  profileUpdate,
  @JsonValue('DOCUMENT_VERIFICATION')
  documentVerification,
  @JsonValue('STATUS_CHANGE')
  statusChange,
}

// حالة طلب التوثيق
enum VerificationRequestStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
}

@freezed
class VerificationRequestModel with _$VerificationRequestModel {
  const factory VerificationRequestModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'request_type') required VerificationRequestType requestType,
    @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
    @JsonKey(name: 'new_data') required Map<String, dynamic> newData,
    @Default(VerificationRequestStatus.pending) VerificationRequestStatus status,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    @JsonKey(name: 'reviewed_by') String? reviewedBy,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VerificationRequestModel;

  factory VerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestModelFromJson(json);
}

@freezed
class SubmitVerificationRequest with _$SubmitVerificationRequest {
  const factory SubmitVerificationRequest({
    @JsonKey(name: 'request_type') required VerificationRequestType requestType,
    @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
    @JsonKey(name: 'new_data') required Map<String, dynamic> newData,
    @JsonKey(name: 'document_ids') @Default([]) List<String> documentIds,
  }) = _SubmitVerificationRequest;

  factory SubmitVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitVerificationRequestFromJson(json);
}

@freezed
class VerificationRequestResponse with _$VerificationRequestResponse {
  const factory VerificationRequestResponse({
    required bool success,
    required String message,
    @JsonKey(name: 'request_id') String? requestId,
    VerificationRequestModel? request,
  }) = _VerificationRequestResponse;

  factory VerificationRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestResponseFromJson(json);
}

@freezed
class RejectVerificationRequestModel with _$RejectVerificationRequestModel {
  const factory RejectVerificationRequestModel({
    required String reason,
  }) = _RejectVerificationRequestModel;

  factory RejectVerificationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RejectVerificationRequestModelFromJson(json);
}

// Extensions لتسهيل الاستخدام
extension VerificationRequestTypeExtension on VerificationRequestType {
  String get displayName {
    switch (this) {
      case VerificationRequestType.profileUpdate:
        return 'تحديث الملف الشخصي';
      case VerificationRequestType.documentVerification:
        return 'توثيق الوثائق';
      case VerificationRequestType.statusChange:
        return 'تغيير الحالة';
    }
  }
}

extension VerificationRequestStatusExtension on VerificationRequestStatus {
  String get displayName {
    switch (this) {
      case VerificationRequestStatus.pending:
        return 'في الانتظار';
      case VerificationRequestStatus.approved:
        return 'مقبول';
      case VerificationRequestStatus.rejected:
        return 'مرفوض';
    }
  }

  String get color {
    switch (this) {
      case VerificationRequestStatus.pending:
        return '#F59E0B'; // أصفر
      case VerificationRequestStatus.approved:
        return '#10B981'; // أخضر
      case VerificationRequestStatus.rejected:
        return '#EF4444'; // أحمر
    }
  }
}