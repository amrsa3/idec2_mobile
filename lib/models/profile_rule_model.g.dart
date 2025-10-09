// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileRuleModelImpl _$$ProfileRuleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileRuleModelImpl(
      id: json['id'] as String,
      fieldName: json['fieldName'] as String,
      fieldDisplayName: json['fieldDisplayName'] as String?,
      fieldDescription: json['fieldDescription'] as String?,
      targetStatus: $enumDecode(_$ProfileStatusEnumMap, json['targetStatus']),
      allowEdit: json['allowEdit'] as bool? ?? true,
      approvalPolicy:
          $enumDecode(_$ApprovalPolicyEnumMap, json['approvalPolicy']),
      changeLimit: (json['changeLimit'] as num?)?.toInt(),
      requiresDocument: json['requiresDocument'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      priority: (json['priority'] as num?)?.toInt() ?? 5,
      category: $enumDecodeNullable(_$RuleCategoryEnumMap, json['category']) ??
          RuleCategory.personal,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      version: (json['version'] as num?)?.toInt() ?? 1,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      lastModifiedBy: json['lastModifiedBy'] as String?,
    );

Map<String, dynamic> _$$ProfileRuleModelImplToJson(
        _$ProfileRuleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fieldName': instance.fieldName,
      'fieldDisplayName': instance.fieldDisplayName,
      'fieldDescription': instance.fieldDescription,
      'targetStatus': _$ProfileStatusEnumMap[instance.targetStatus]!,
      'allowEdit': instance.allowEdit,
      'approvalPolicy': _$ApprovalPolicyEnumMap[instance.approvalPolicy]!,
      'changeLimit': instance.changeLimit,
      'requiresDocument': instance.requiresDocument,
      'isActive': instance.isActive,
      'priority': instance.priority,
      'category': _$RuleCategoryEnumMap[instance.category]!,
      'tags': instance.tags,
      'version': instance.version,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'lastModifiedBy': instance.lastModifiedBy,
    };

const _$ProfileStatusEnumMap = {
  ProfileStatus.unverified: 'UNVERIFIED',
  ProfileStatus.pendingVerification: 'PENDING_VERIFICATION',
  ProfileStatus.verified: 'VERIFIED',
  ProfileStatus.rejected: 'REJECTED',
};

const _$ApprovalPolicyEnumMap = {
  ApprovalPolicy.noApprovalRequired: 'NO_APPROVAL_REQUIRED',
  ApprovalPolicy.alwaysRequired: 'ALWAYS_REQUIRED',
  ApprovalPolicy.conditionalByChangeLimit: 'CONDITIONAL_BY_CHANGE_LIMIT',
};

const _$RuleCategoryEnumMap = {
  RuleCategory.personal: 'PERSONAL',
  RuleCategory.academic: 'ACADEMIC',
  RuleCategory.professional: 'PROFESSIONAL',
  RuleCategory.contact: 'CONTACT',
};

_$ProfileValidationResultImpl _$$ProfileValidationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileValidationResultImpl(
      isValid: json['isValid'] as bool? ?? true,
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      requiresDocument: json['requiresDocument'] as bool? ?? false,
      appliedRules: (json['appliedRules'] as List<dynamic>?)
              ?.map((e) => ProfileRuleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fieldsRequiringApproval:
          (json['fieldsRequiringApproval'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
    );

Map<String, dynamic> _$$ProfileValidationResultImplToJson(
        _$ProfileValidationResultImpl instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'requiresApproval': instance.requiresApproval,
      'requiresDocument': instance.requiresDocument,
      'appliedRules': instance.appliedRules,
      'errors': instance.errors,
      'warnings': instance.warnings,
      'fieldsRequiringApproval': instance.fieldsRequiringApproval,
    };

_$ProfileChangeRequestImpl _$$ProfileChangeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileChangeRequestImpl(
      userId: json['userId'] as String,
      changes: json['changes'] as Map<String, dynamic>,
      requestedBy: json['requestedBy'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$ProfileChangeRequestImplToJson(
        _$ProfileChangeRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'changes': instance.changes,
      'requestedBy': instance.requestedBy,
      'reason': instance.reason,
    };
