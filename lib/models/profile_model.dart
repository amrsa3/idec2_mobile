import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

// حالات التوثيق
enum VerificationStatus {
  @JsonValue('UNVERIFIED')
  unverified, // غير موثق
  @JsonValue('PENDING_VERIFICATION')
  underReview, // قيد المراجعة
  @JsonValue('VERIFIED')
  verified, // موثق
  @JsonValue('REJECTED')
  rejected, // مرفوض
}

// أنواع الوثائق
enum DocumentType {
  @JsonValue('identity')
  identity, // الهوية الشخصية
  @JsonValue('qualification')
  qualification, // المؤهل العلمي
  @JsonValue('certificate')
  certificate, // الشهادات
  @JsonValue('license')
  license, // رخصة المزاولة
  @JsonValue('other')
  other, // أخرى
}

// حالة الوثيقة
enum DocumentStatus {
  @JsonValue('pending')
  pending, // في الانتظار
  @JsonValue('approved')
  approved, // مقبولة
  @JsonValue('rejected')
  rejected, // مرفوضة
}

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String userId,

    // البيانات الشخصية
    @JsonKey(name: 'full_name_ar') @Default('') String fullNameAr,
    @JsonKey(name: 'full_name_en') @Default('') String fullNameEn,
    @Default('') String email,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    @JsonKey(name: 'governorate_id') String? governorateId,

    // البيانات الأكاديمية
    @JsonKey(name: 'qualification_id') String? qualificationId,
    @JsonKey(name: 'graduation_year') int? graduationYear,
    @Default('') String university,
    @Default('') String workplace,

    // حالة التوثيق
    @JsonKey(name: 'status')
    @Default(VerificationStatus.unverified)
    VerificationStatus verificationStatus,
    @JsonKey(name: 'completion_percentage')
    @Default(0.0)
    double completionPercentage,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,

    // صورة الملف الشخصي
    @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,

    // الوثائق المرفوعة
    @Default([]) List<DocumentModel> documents,

    // قواعد التوثيق المطلوبة
    @JsonKey(name: 'required_documents')
    @Default([])
    List<RequiredDocumentModel> requiredDocuments,

    // تواريخ
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'verified_at') DateTime? verifiedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

// Extension to provide backward compatibility with old property names
extension ProfileModelExtension on ProfileModel {
  // Getter for name (combines Arabic and English names)
  String get name => fullNameAr.isNotEmpty ? fullNameAr : fullNameEn;

  // Getter for governorate (returns governorate ID)
  String? get governorate => governorateId;

  // Getter for qualification (returns qualification ID)
  String? get qualification => qualificationId;

  // Getter for profilePicture (returns profile picture URL)
  String? get profilePicture => profilePictureUrl;

  // Getter for isVerified (checks if verification status is verified)
  bool get isVerified => verificationStatus == VerificationStatus.verified;

  // Getter for verificationPercentage (returns completion percentage)
  double get verificationPercentage => completionPercentage;
}

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required String id,
    @JsonKey(name: 'file_id') required String fileId,
    @JsonKey(name: 'document_type') required DocumentType documentType,
    @JsonKey(name: 'original_name') required String originalName,
    @JsonKey(name: 'file_url') required String fileUrl,
    @JsonKey(name: 'file_size') required int fileSize,
    @JsonKey(name: 'mime_type') required String mimeType,
    @Default(DocumentStatus.pending) DocumentStatus status,
    @JsonKey(name: 'admin_notes') String? adminNotes,
    @JsonKey(name: 'uploaded_at') required DateTime uploadedAt,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);
}

@freezed
class RequiredDocumentModel with _$RequiredDocumentModel {
  const factory RequiredDocumentModel({
    required String id,
    @JsonKey(name: 'document_type') required DocumentType documentType,
    required String title,
    required String description,
    @JsonKey(name: 'is_required') @Default(true) bool isRequired,
    @JsonKey(name: 'max_file_size') @Default(5242880) int maxFileSize, // 5MB
    @JsonKey(name: 'allowed_formats')
    @Default(['pdf', 'jpg', 'jpeg', 'png'])
    List<String> allowedFormats,
  }) = _RequiredDocumentModel;

  factory RequiredDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$RequiredDocumentModelFromJson(json);
}

@freezed
class ProfileUpdateRequest with _$ProfileUpdateRequest {
  const factory ProfileUpdateRequest({
    @JsonKey(name: 'full_name_ar') String? fullNameAr,
    @JsonKey(name: 'full_name_en') String? fullNameEn,
    String? email,
    @JsonKey(name: 'birth_date', toJson: _dateToJson, fromJson: _dateFromJson) DateTime? birthDate,
    @JsonKey(name: 'governorate_id') String? governorateId,
    @JsonKey(name: 'qualification_id') String? qualificationId,
    @JsonKey(name: 'graduation_year') int? graduationYear,
    String? university,
    String? workplace,
  }) = _ProfileUpdateRequest;

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdateRequestFromJson(json);
}

// Custom date serialization to send only date without time/timezone
String? _dateToJson(DateTime? date) {
  if (date == null) return null;
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

DateTime? _dateFromJson(String? dateStr) {
  if (dateStr == null) return null;
  return DateTime.parse(dateStr);
}

@freezed
class VerificationRulesResponse with _$VerificationRulesResponse {
  const factory VerificationRulesResponse({
    @Default([]) List<RequiredDocumentModel> requiredDocuments,
    @JsonKey(name: 'required_fields') @Default([]) List<String> requiredFields,
    @Default([]) List<String> rules,
  }) = _VerificationRulesResponse;

  factory VerificationRulesResponse.fromJson(Map<String, dynamic> json) =>
      _$VerificationRulesResponseFromJson(json);
}

// Extensions لتسهيل الاستخدام
extension VerificationStatusExtension on VerificationStatus {
  String get displayName {
    switch (this) {
      case VerificationStatus.unverified:
        return 'غير موثق';
      case VerificationStatus.underReview:
        return 'قيد المراجعة';
      case VerificationStatus.verified:
        return 'موثق';
      case VerificationStatus.rejected:
        return 'مرفوض';
    }
  }

  Color get color {
    switch (this) {
      case VerificationStatus.unverified:
        return const Color(0xFFDC2626); // أحمر
      case VerificationStatus.underReview:
        return const Color(0xFFF59E0B); // أصفر
      case VerificationStatus.verified:
        return const Color(0xFF10B981); // أخضر
      case VerificationStatus.rejected:
        return const Color(0xFFEF4444); // أحمر داكن
    }
  }
}

extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.identity:
        return 'الهوية الشخصية';
      case DocumentType.qualification:
        return 'المؤهل العلمي';
      case DocumentType.certificate:
        return 'الشهادات';
      case DocumentType.license:
        return 'رخصة المزاولة';
      case DocumentType.other:
        return 'أخرى';
    }
  }
}

extension DocumentStatusExtension on DocumentStatus {
  String get displayName {
    switch (this) {
      case DocumentStatus.pending:
        return 'في الانتظار';
      case DocumentStatus.approved:
        return 'مقبولة';
      case DocumentStatus.rejected:
        return 'مرفوضة';
    }
  }

  String get color {
    switch (this) {
      case DocumentStatus.pending:
        return '#F59E0B'; // أصفر
      case DocumentStatus.approved:
        return '#10B981'; // أخضر
      case DocumentStatus.rejected:
        return '#EF4444'; // أحمر
    }
  }
}
