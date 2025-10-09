// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_rule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileRuleModel _$ProfileRuleModelFromJson(Map<String, dynamic> json) {
  return _ProfileRuleModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileRuleModel {
  String get id => throw _privateConstructorUsedError;
  String get fieldName => throw _privateConstructorUsedError;
  String? get fieldDisplayName => throw _privateConstructorUsedError;
  String? get fieldDescription => throw _privateConstructorUsedError;
  ProfileStatus get targetStatus => throw _privateConstructorUsedError;
  bool get allowEdit => throw _privateConstructorUsedError;
  ApprovalPolicy get approvalPolicy => throw _privateConstructorUsedError;
  int? get changeLimit => throw _privateConstructorUsedError;
  bool get requiresDocument => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  RuleCategory get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get lastModifiedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileRuleModelCopyWith<ProfileRuleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileRuleModelCopyWith<$Res> {
  factory $ProfileRuleModelCopyWith(
          ProfileRuleModel value, $Res Function(ProfileRuleModel) then) =
      _$ProfileRuleModelCopyWithImpl<$Res, ProfileRuleModel>;
  @useResult
  $Res call(
      {String id,
      String fieldName,
      String? fieldDisplayName,
      String? fieldDescription,
      ProfileStatus targetStatus,
      bool allowEdit,
      ApprovalPolicy approvalPolicy,
      int? changeLimit,
      bool requiresDocument,
      bool isActive,
      int priority,
      RuleCategory category,
      List<String> tags,
      int version,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? lastModifiedBy});
}

/// @nodoc
class _$ProfileRuleModelCopyWithImpl<$Res, $Val extends ProfileRuleModel>
    implements $ProfileRuleModelCopyWith<$Res> {
  _$ProfileRuleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fieldName = null,
    Object? fieldDisplayName = freezed,
    Object? fieldDescription = freezed,
    Object? targetStatus = null,
    Object? allowEdit = null,
    Object? approvalPolicy = null,
    Object? changeLimit = freezed,
    Object? requiresDocument = null,
    Object? isActive = null,
    Object? priority = null,
    Object? category = null,
    Object? tags = null,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? lastModifiedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      fieldDisplayName: freezed == fieldDisplayName
          ? _value.fieldDisplayName
          : fieldDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldDescription: freezed == fieldDescription
          ? _value.fieldDescription
          : fieldDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      targetStatus: null == targetStatus
          ? _value.targetStatus
          : targetStatus // ignore: cast_nullable_to_non_nullable
              as ProfileStatus,
      allowEdit: null == allowEdit
          ? _value.allowEdit
          : allowEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      approvalPolicy: null == approvalPolicy
          ? _value.approvalPolicy
          : approvalPolicy // ignore: cast_nullable_to_non_nullable
              as ApprovalPolicy,
      changeLimit: freezed == changeLimit
          ? _value.changeLimit
          : changeLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresDocument: null == requiresDocument
          ? _value.requiresDocument
          : requiresDocument // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as RuleCategory,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileRuleModelImplCopyWith<$Res>
    implements $ProfileRuleModelCopyWith<$Res> {
  factory _$$ProfileRuleModelImplCopyWith(_$ProfileRuleModelImpl value,
          $Res Function(_$ProfileRuleModelImpl) then) =
      __$$ProfileRuleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fieldName,
      String? fieldDisplayName,
      String? fieldDescription,
      ProfileStatus targetStatus,
      bool allowEdit,
      ApprovalPolicy approvalPolicy,
      int? changeLimit,
      bool requiresDocument,
      bool isActive,
      int priority,
      RuleCategory category,
      List<String> tags,
      int version,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? lastModifiedBy});
}

/// @nodoc
class __$$ProfileRuleModelImplCopyWithImpl<$Res>
    extends _$ProfileRuleModelCopyWithImpl<$Res, _$ProfileRuleModelImpl>
    implements _$$ProfileRuleModelImplCopyWith<$Res> {
  __$$ProfileRuleModelImplCopyWithImpl(_$ProfileRuleModelImpl _value,
      $Res Function(_$ProfileRuleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fieldName = null,
    Object? fieldDisplayName = freezed,
    Object? fieldDescription = freezed,
    Object? targetStatus = null,
    Object? allowEdit = null,
    Object? approvalPolicy = null,
    Object? changeLimit = freezed,
    Object? requiresDocument = null,
    Object? isActive = null,
    Object? priority = null,
    Object? category = null,
    Object? tags = null,
    Object? version = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? lastModifiedBy = freezed,
  }) {
    return _then(_$ProfileRuleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fieldName: null == fieldName
          ? _value.fieldName
          : fieldName // ignore: cast_nullable_to_non_nullable
              as String,
      fieldDisplayName: freezed == fieldDisplayName
          ? _value.fieldDisplayName
          : fieldDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      fieldDescription: freezed == fieldDescription
          ? _value.fieldDescription
          : fieldDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      targetStatus: null == targetStatus
          ? _value.targetStatus
          : targetStatus // ignore: cast_nullable_to_non_nullable
              as ProfileStatus,
      allowEdit: null == allowEdit
          ? _value.allowEdit
          : allowEdit // ignore: cast_nullable_to_non_nullable
              as bool,
      approvalPolicy: null == approvalPolicy
          ? _value.approvalPolicy
          : approvalPolicy // ignore: cast_nullable_to_non_nullable
              as ApprovalPolicy,
      changeLimit: freezed == changeLimit
          ? _value.changeLimit
          : changeLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresDocument: null == requiresDocument
          ? _value.requiresDocument
          : requiresDocument // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as RuleCategory,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileRuleModelImpl implements _ProfileRuleModel {
  const _$ProfileRuleModelImpl(
      {required this.id,
      required this.fieldName,
      this.fieldDisplayName,
      this.fieldDescription,
      required this.targetStatus,
      this.allowEdit = true,
      required this.approvalPolicy,
      this.changeLimit,
      this.requiresDocument = false,
      this.isActive = true,
      this.priority = 5,
      this.category = RuleCategory.personal,
      final List<String> tags = const [],
      this.version = 1,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.lastModifiedBy})
      : _tags = tags;

  factory _$ProfileRuleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileRuleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fieldName;
  @override
  final String? fieldDisplayName;
  @override
  final String? fieldDescription;
  @override
  final ProfileStatus targetStatus;
  @override
  @JsonKey()
  final bool allowEdit;
  @override
  final ApprovalPolicy approvalPolicy;
  @override
  final int? changeLimit;
  @override
  @JsonKey()
  final bool requiresDocument;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey()
  final RuleCategory category;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int version;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? lastModifiedBy;

  @override
  String toString() {
    return 'ProfileRuleModel(id: $id, fieldName: $fieldName, fieldDisplayName: $fieldDisplayName, fieldDescription: $fieldDescription, targetStatus: $targetStatus, allowEdit: $allowEdit, approvalPolicy: $approvalPolicy, changeLimit: $changeLimit, requiresDocument: $requiresDocument, isActive: $isActive, priority: $priority, category: $category, tags: $tags, version: $version, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileRuleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fieldName, fieldName) ||
                other.fieldName == fieldName) &&
            (identical(other.fieldDisplayName, fieldDisplayName) ||
                other.fieldDisplayName == fieldDisplayName) &&
            (identical(other.fieldDescription, fieldDescription) ||
                other.fieldDescription == fieldDescription) &&
            (identical(other.targetStatus, targetStatus) ||
                other.targetStatus == targetStatus) &&
            (identical(other.allowEdit, allowEdit) ||
                other.allowEdit == allowEdit) &&
            (identical(other.approvalPolicy, approvalPolicy) ||
                other.approvalPolicy == approvalPolicy) &&
            (identical(other.changeLimit, changeLimit) ||
                other.changeLimit == changeLimit) &&
            (identical(other.requiresDocument, requiresDocument) ||
                other.requiresDocument == requiresDocument) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fieldName,
      fieldDisplayName,
      fieldDescription,
      targetStatus,
      allowEdit,
      approvalPolicy,
      changeLimit,
      requiresDocument,
      isActive,
      priority,
      category,
      const DeepCollectionEquality().hash(_tags),
      version,
      createdAt,
      updatedAt,
      createdBy,
      lastModifiedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileRuleModelImplCopyWith<_$ProfileRuleModelImpl> get copyWith =>
      __$$ProfileRuleModelImplCopyWithImpl<_$ProfileRuleModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileRuleModelImplToJson(
      this,
    );
  }
}

abstract class _ProfileRuleModel implements ProfileRuleModel {
  const factory _ProfileRuleModel(
      {required final String id,
      required final String fieldName,
      final String? fieldDisplayName,
      final String? fieldDescription,
      required final ProfileStatus targetStatus,
      final bool allowEdit,
      required final ApprovalPolicy approvalPolicy,
      final int? changeLimit,
      final bool requiresDocument,
      final bool isActive,
      final int priority,
      final RuleCategory category,
      final List<String> tags,
      final int version,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? lastModifiedBy}) = _$ProfileRuleModelImpl;

  factory _ProfileRuleModel.fromJson(Map<String, dynamic> json) =
      _$ProfileRuleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fieldName;
  @override
  String? get fieldDisplayName;
  @override
  String? get fieldDescription;
  @override
  ProfileStatus get targetStatus;
  @override
  bool get allowEdit;
  @override
  ApprovalPolicy get approvalPolicy;
  @override
  int? get changeLimit;
  @override
  bool get requiresDocument;
  @override
  bool get isActive;
  @override
  int get priority;
  @override
  RuleCategory get category;
  @override
  List<String> get tags;
  @override
  int get version;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get lastModifiedBy;
  @override
  @JsonKey(ignore: true)
  _$$ProfileRuleModelImplCopyWith<_$ProfileRuleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileValidationResult _$ProfileValidationResultFromJson(
    Map<String, dynamic> json) {
  return _ProfileValidationResult.fromJson(json);
}

/// @nodoc
mixin _$ProfileValidationResult {
  bool get isValid => throw _privateConstructorUsedError;
  bool get requiresApproval => throw _privateConstructorUsedError;
  bool get requiresDocument => throw _privateConstructorUsedError;
  List<ProfileRuleModel> get appliedRules => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;
  List<String> get fieldsRequiringApproval =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileValidationResultCopyWith<ProfileValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileValidationResultCopyWith<$Res> {
  factory $ProfileValidationResultCopyWith(ProfileValidationResult value,
          $Res Function(ProfileValidationResult) then) =
      _$ProfileValidationResultCopyWithImpl<$Res, ProfileValidationResult>;
  @useResult
  $Res call(
      {bool isValid,
      bool requiresApproval,
      bool requiresDocument,
      List<ProfileRuleModel> appliedRules,
      List<String> errors,
      List<String> warnings,
      List<String> fieldsRequiringApproval});
}

/// @nodoc
class _$ProfileValidationResultCopyWithImpl<$Res,
        $Val extends ProfileValidationResult>
    implements $ProfileValidationResultCopyWith<$Res> {
  _$ProfileValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? requiresApproval = null,
    Object? requiresDocument = null,
    Object? appliedRules = null,
    Object? errors = null,
    Object? warnings = null,
    Object? fieldsRequiringApproval = null,
  }) {
    return _then(_value.copyWith(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresDocument: null == requiresDocument
          ? _value.requiresDocument
          : requiresDocument // ignore: cast_nullable_to_non_nullable
              as bool,
      appliedRules: null == appliedRules
          ? _value.appliedRules
          : appliedRules // ignore: cast_nullable_to_non_nullable
              as List<ProfileRuleModel>,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fieldsRequiringApproval: null == fieldsRequiringApproval
          ? _value.fieldsRequiringApproval
          : fieldsRequiringApproval // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileValidationResultImplCopyWith<$Res>
    implements $ProfileValidationResultCopyWith<$Res> {
  factory _$$ProfileValidationResultImplCopyWith(
          _$ProfileValidationResultImpl value,
          $Res Function(_$ProfileValidationResultImpl) then) =
      __$$ProfileValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isValid,
      bool requiresApproval,
      bool requiresDocument,
      List<ProfileRuleModel> appliedRules,
      List<String> errors,
      List<String> warnings,
      List<String> fieldsRequiringApproval});
}

/// @nodoc
class __$$ProfileValidationResultImplCopyWithImpl<$Res>
    extends _$ProfileValidationResultCopyWithImpl<$Res,
        _$ProfileValidationResultImpl>
    implements _$$ProfileValidationResultImplCopyWith<$Res> {
  __$$ProfileValidationResultImplCopyWithImpl(
      _$ProfileValidationResultImpl _value,
      $Res Function(_$ProfileValidationResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? requiresApproval = null,
    Object? requiresDocument = null,
    Object? appliedRules = null,
    Object? errors = null,
    Object? warnings = null,
    Object? fieldsRequiringApproval = null,
  }) {
    return _then(_$ProfileValidationResultImpl(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresApproval: null == requiresApproval
          ? _value.requiresApproval
          : requiresApproval // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresDocument: null == requiresDocument
          ? _value.requiresDocument
          : requiresDocument // ignore: cast_nullable_to_non_nullable
              as bool,
      appliedRules: null == appliedRules
          ? _value._appliedRules
          : appliedRules // ignore: cast_nullable_to_non_nullable
              as List<ProfileRuleModel>,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      fieldsRequiringApproval: null == fieldsRequiringApproval
          ? _value._fieldsRequiringApproval
          : fieldsRequiringApproval // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileValidationResultImpl implements _ProfileValidationResult {
  const _$ProfileValidationResultImpl(
      {this.isValid = true,
      this.requiresApproval = false,
      this.requiresDocument = false,
      final List<ProfileRuleModel> appliedRules = const [],
      final List<String> errors = const [],
      final List<String> warnings = const [],
      final List<String> fieldsRequiringApproval = const []})
      : _appliedRules = appliedRules,
        _errors = errors,
        _warnings = warnings,
        _fieldsRequiringApproval = fieldsRequiringApproval;

  factory _$ProfileValidationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileValidationResultImplFromJson(json);

  @override
  @JsonKey()
  final bool isValid;
  @override
  @JsonKey()
  final bool requiresApproval;
  @override
  @JsonKey()
  final bool requiresDocument;
  final List<ProfileRuleModel> _appliedRules;
  @override
  @JsonKey()
  List<ProfileRuleModel> get appliedRules {
    if (_appliedRules is EqualUnmodifiableListView) return _appliedRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appliedRules);
  }

  final List<String> _errors;
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  final List<String> _warnings;
  @override
  @JsonKey()
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  final List<String> _fieldsRequiringApproval;
  @override
  @JsonKey()
  List<String> get fieldsRequiringApproval {
    if (_fieldsRequiringApproval is EqualUnmodifiableListView)
      return _fieldsRequiringApproval;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fieldsRequiringApproval);
  }

  @override
  String toString() {
    return 'ProfileValidationResult(isValid: $isValid, requiresApproval: $requiresApproval, requiresDocument: $requiresDocument, appliedRules: $appliedRules, errors: $errors, warnings: $warnings, fieldsRequiringApproval: $fieldsRequiringApproval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileValidationResultImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.requiresApproval, requiresApproval) ||
                other.requiresApproval == requiresApproval) &&
            (identical(other.requiresDocument, requiresDocument) ||
                other.requiresDocument == requiresDocument) &&
            const DeepCollectionEquality()
                .equals(other._appliedRules, _appliedRules) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality().equals(
                other._fieldsRequiringApproval, _fieldsRequiringApproval));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isValid,
      requiresApproval,
      requiresDocument,
      const DeepCollectionEquality().hash(_appliedRules),
      const DeepCollectionEquality().hash(_errors),
      const DeepCollectionEquality().hash(_warnings),
      const DeepCollectionEquality().hash(_fieldsRequiringApproval));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileValidationResultImplCopyWith<_$ProfileValidationResultImpl>
      get copyWith => __$$ProfileValidationResultImplCopyWithImpl<
          _$ProfileValidationResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileValidationResultImplToJson(
      this,
    );
  }
}

abstract class _ProfileValidationResult implements ProfileValidationResult {
  const factory _ProfileValidationResult(
          {final bool isValid,
          final bool requiresApproval,
          final bool requiresDocument,
          final List<ProfileRuleModel> appliedRules,
          final List<String> errors,
          final List<String> warnings,
          final List<String> fieldsRequiringApproval}) =
      _$ProfileValidationResultImpl;

  factory _ProfileValidationResult.fromJson(Map<String, dynamic> json) =
      _$ProfileValidationResultImpl.fromJson;

  @override
  bool get isValid;
  @override
  bool get requiresApproval;
  @override
  bool get requiresDocument;
  @override
  List<ProfileRuleModel> get appliedRules;
  @override
  List<String> get errors;
  @override
  List<String> get warnings;
  @override
  List<String> get fieldsRequiringApproval;
  @override
  @JsonKey(ignore: true)
  _$$ProfileValidationResultImplCopyWith<_$ProfileValidationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProfileChangeRequest _$ProfileChangeRequestFromJson(Map<String, dynamic> json) {
  return _ProfileChangeRequest.fromJson(json);
}

/// @nodoc
mixin _$ProfileChangeRequest {
  String get userId => throw _privateConstructorUsedError;
  Map<String, dynamic> get changes => throw _privateConstructorUsedError;
  String get requestedBy => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileChangeRequestCopyWith<ProfileChangeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileChangeRequestCopyWith<$Res> {
  factory $ProfileChangeRequestCopyWith(ProfileChangeRequest value,
          $Res Function(ProfileChangeRequest) then) =
      _$ProfileChangeRequestCopyWithImpl<$Res, ProfileChangeRequest>;
  @useResult
  $Res call(
      {String userId,
      Map<String, dynamic> changes,
      String requestedBy,
      String? reason});
}

/// @nodoc
class _$ProfileChangeRequestCopyWithImpl<$Res,
        $Val extends ProfileChangeRequest>
    implements $ProfileChangeRequestCopyWith<$Res> {
  _$ProfileChangeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? changes = null,
    Object? requestedBy = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      requestedBy: null == requestedBy
          ? _value.requestedBy
          : requestedBy // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileChangeRequestImplCopyWith<$Res>
    implements $ProfileChangeRequestCopyWith<$Res> {
  factory _$$ProfileChangeRequestImplCopyWith(_$ProfileChangeRequestImpl value,
          $Res Function(_$ProfileChangeRequestImpl) then) =
      __$$ProfileChangeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      Map<String, dynamic> changes,
      String requestedBy,
      String? reason});
}

/// @nodoc
class __$$ProfileChangeRequestImplCopyWithImpl<$Res>
    extends _$ProfileChangeRequestCopyWithImpl<$Res, _$ProfileChangeRequestImpl>
    implements _$$ProfileChangeRequestImplCopyWith<$Res> {
  __$$ProfileChangeRequestImplCopyWithImpl(_$ProfileChangeRequestImpl _value,
      $Res Function(_$ProfileChangeRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? changes = null,
    Object? requestedBy = null,
    Object? reason = freezed,
  }) {
    return _then(_$ProfileChangeRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      requestedBy: null == requestedBy
          ? _value.requestedBy
          : requestedBy // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileChangeRequestImpl implements _ProfileChangeRequest {
  const _$ProfileChangeRequestImpl(
      {required this.userId,
      required final Map<String, dynamic> changes,
      required this.requestedBy,
      this.reason})
      : _changes = changes;

  factory _$ProfileChangeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileChangeRequestImplFromJson(json);

  @override
  final String userId;
  final Map<String, dynamic> _changes;
  @override
  Map<String, dynamic> get changes {
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_changes);
  }

  @override
  final String requestedBy;
  @override
  final String? reason;

  @override
  String toString() {
    return 'ProfileChangeRequest(userId: $userId, changes: $changes, requestedBy: $requestedBy, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileChangeRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            (identical(other.requestedBy, requestedBy) ||
                other.requestedBy == requestedBy) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId,
      const DeepCollectionEquality().hash(_changes), requestedBy, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileChangeRequestImplCopyWith<_$ProfileChangeRequestImpl>
      get copyWith =>
          __$$ProfileChangeRequestImplCopyWithImpl<_$ProfileChangeRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileChangeRequestImplToJson(
      this,
    );
  }
}

abstract class _ProfileChangeRequest implements ProfileChangeRequest {
  const factory _ProfileChangeRequest(
      {required final String userId,
      required final Map<String, dynamic> changes,
      required final String requestedBy,
      final String? reason}) = _$ProfileChangeRequestImpl;

  factory _ProfileChangeRequest.fromJson(Map<String, dynamic> json) =
      _$ProfileChangeRequestImpl.fromJson;

  @override
  String get userId;
  @override
  Map<String, dynamic> get changes;
  @override
  String get requestedBy;
  @override
  String? get reason;
  @override
  @JsonKey(ignore: true)
  _$$ProfileChangeRequestImplCopyWith<_$ProfileChangeRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
