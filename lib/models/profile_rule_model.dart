import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_rule_model.freezed.dart';
part 'profile_rule_model.g.dart';

/// سياسات الموافقة على التعديلات
enum ApprovalPolicy {
  @JsonValue('NOT_REQUIRED')
  noApprovalRequired, // لا تحتاج موافقة

  @JsonValue('REQUIRED')
  alwaysRequired, // تحتاج موافقة دائماً

  @JsonValue('CONDITIONAL')
  conditionalByChangeLimit, // تحتاج موافقة حسب حجم التغيير
}

/// حالات الملف الشخصي
enum ProfileStatus {
  @JsonValue('UNVERIFIED')
  unverified,

  @JsonValue('PENDING_VERIFICATION')
  pendingVerification,

  @JsonValue('VERIFIED')
  verified,

  @JsonValue('REJECTED')
  rejected,
}

/// فئات القواعد
enum RuleCategory {
  @JsonValue('PERSONAL')
  personal,

  @JsonValue('ACADEMIC')
  academic,

  @JsonValue('PROFESSIONAL')
  professional,

  @JsonValue('CONTACT')
  contact,
}

/// قاعدة تعديل الملف الشخصي
@freezed
class ProfileRuleModel with _$ProfileRuleModel {
  const factory ProfileRuleModel({
    required String id,
    required String fieldName,
    String? fieldDisplayName,
    String? fieldDescription,
    required ProfileStatus targetStatus,
    @Default(true) bool allowEdit,
    required ApprovalPolicy approvalPolicy,
    int? changeLimit,
    @Default(false) bool requiresDocument,
    @Default(true) bool isActive,
    @Default(5) int priority,
    @Default(RuleCategory.personal) RuleCategory category,
    @Default([]) List<String> tags,
    @Default(1) int version,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? lastModifiedBy,
  }) = _ProfileRuleModel;

  factory ProfileRuleModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileRuleModelFromJson(json);
}

/// نتيجة التحقق من التعديلات
@freezed
class ProfileValidationResult with _$ProfileValidationResult {
  const factory ProfileValidationResult({
    @Default(true) bool isValid,
    @Default(false) bool requiresApproval,
    @Default(false) bool requiresDocument,
    @Default([]) List<ProfileRuleModel> appliedRules,
    @Default([]) List<String> errors,
    @Default([]) List<String> warnings,
    @Default([]) List<String> fieldsRequiringApproval,
  }) = _ProfileValidationResult;

  factory ProfileValidationResult.fromJson(Map<String, dynamic> json) =>
      _$ProfileValidationResultFromJson(json);
}

/// طلب تغيير الملف الشخصي
@freezed
class ProfileChangeRequest with _$ProfileChangeRequest {
  const factory ProfileChangeRequest({
    required String userId,
    required Map<String, dynamic> changes,
    required String requestedBy,
    String? reason,
  }) = _ProfileChangeRequest;

  factory ProfileChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileChangeRequestFromJson(json);
}

/// Extensions للاستخدام السهل
extension ApprovalPolicyExtension on ApprovalPolicy {
  String get displayName {
    switch (this) {
      case ApprovalPolicy.noApprovalRequired:
        return 'لا تحتاج موافقة';
      case ApprovalPolicy.alwaysRequired:
        return 'تحتاج موافقة دائماً';
      case ApprovalPolicy.conditionalByChangeLimit:
        return 'موافقة مشروطة';
    }
  }

  String get description {
    switch (this) {
      case ApprovalPolicy.noApprovalRequired:
        return 'يتم حفظ التعديل مباشرة بدون مراجعة';
      case ApprovalPolicy.alwaysRequired:
        return 'أي تعديل يتطلب موافقة من الإدارة';
      case ApprovalPolicy.conditionalByChangeLimit:
        return 'التعديلات الكبيرة تتطلب موافقة';
    }
  }
}

extension ProfileStatusExtension on ProfileStatus {
  String get displayName {
    switch (this) {
      case ProfileStatus.unverified:
        return 'غير موثق';
      case ProfileStatus.pendingVerification:
        return 'قيد المراجعة';
      case ProfileStatus.verified:
        return 'موثق';
      case ProfileStatus.rejected:
        return 'مرفوض';
    }
  }

  /// تحويل ProfileStatus إلى القيمة الصحيحة للـ API
  String get apiValue {
    switch (this) {
      case ProfileStatus.unverified:
        return 'UNVERIFIED';
      case ProfileStatus.pendingVerification:
        return 'PENDING_VERIFICATION';
      case ProfileStatus.verified:
        return 'VERIFIED';
      case ProfileStatus.rejected:
        return 'REJECTED';
    }
  }
}
