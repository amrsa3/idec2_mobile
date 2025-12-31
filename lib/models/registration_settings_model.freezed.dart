// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationSettingsModel _$RegistrationSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _RegistrationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$RegistrationSettingsModel {
  String get id => throw _privateConstructorUsedError;
  RegistrationStatus get registrationStatus =>
      throw _privateConstructorUsedError;
  List<String> get otpChannels => throw _privateConstructorUsedError;
  int get otpLength => throw _privateConstructorUsedError;
  int get otpExpiryMinutes => throw _privateConstructorUsedError;
  int get maxOtpAttempts => throw _privateConstructorUsedError;
  int get otpCooldownMinutes => throw _privateConstructorUsedError;
  bool get requireDocumentUpload => throw _privateConstructorUsedError;
  bool get allowEmailRegistration => throw _privateConstructorUsedError;
  bool get requirePhoneVerification => throw _privateConstructorUsedError;
  bool get autoApproveProfiles => throw _privateConstructorUsedError;
  String? get maintenanceMessage => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationSettingsModelCopyWith<RegistrationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationSettingsModelCopyWith<$Res> {
  factory $RegistrationSettingsModelCopyWith(RegistrationSettingsModel value,
          $Res Function(RegistrationSettingsModel) then) =
      _$RegistrationSettingsModelCopyWithImpl<$Res, RegistrationSettingsModel>;
  @useResult
  $Res call(
      {String id,
      RegistrationStatus registrationStatus,
      List<String> otpChannels,
      int otpLength,
      int otpExpiryMinutes,
      int maxOtpAttempts,
      int otpCooldownMinutes,
      bool requireDocumentUpload,
      bool allowEmailRegistration,
      bool requirePhoneVerification,
      bool autoApproveProfiles,
      String? maintenanceMessage,
      DateTime createdAt,
      DateTime updatedAt,
      String? updatedBy});
}

/// @nodoc
class _$RegistrationSettingsModelCopyWithImpl<$Res,
        $Val extends RegistrationSettingsModel>
    implements $RegistrationSettingsModelCopyWith<$Res> {
  _$RegistrationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? registrationStatus = null,
    Object? otpChannels = null,
    Object? otpLength = null,
    Object? otpExpiryMinutes = null,
    Object? maxOtpAttempts = null,
    Object? otpCooldownMinutes = null,
    Object? requireDocumentUpload = null,
    Object? allowEmailRegistration = null,
    Object? requirePhoneVerification = null,
    Object? autoApproveProfiles = null,
    Object? maintenanceMessage = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      registrationStatus: null == registrationStatus
          ? _value.registrationStatus
          : registrationStatus // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      otpChannels: null == otpChannels
          ? _value.otpChannels
          : otpChannels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      otpLength: null == otpLength
          ? _value.otpLength
          : otpLength // ignore: cast_nullable_to_non_nullable
              as int,
      otpExpiryMinutes: null == otpExpiryMinutes
          ? _value.otpExpiryMinutes
          : otpExpiryMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxOtpAttempts: null == maxOtpAttempts
          ? _value.maxOtpAttempts
          : maxOtpAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      otpCooldownMinutes: null == otpCooldownMinutes
          ? _value.otpCooldownMinutes
          : otpCooldownMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      requireDocumentUpload: null == requireDocumentUpload
          ? _value.requireDocumentUpload
          : requireDocumentUpload // ignore: cast_nullable_to_non_nullable
              as bool,
      allowEmailRegistration: null == allowEmailRegistration
          ? _value.allowEmailRegistration
          : allowEmailRegistration // ignore: cast_nullable_to_non_nullable
              as bool,
      requirePhoneVerification: null == requirePhoneVerification
          ? _value.requirePhoneVerification
          : requirePhoneVerification // ignore: cast_nullable_to_non_nullable
              as bool,
      autoApproveProfiles: null == autoApproveProfiles
          ? _value.autoApproveProfiles
          : autoApproveProfiles // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationSettingsModelImplCopyWith<$Res>
    implements $RegistrationSettingsModelCopyWith<$Res> {
  factory _$$RegistrationSettingsModelImplCopyWith(
          _$RegistrationSettingsModelImpl value,
          $Res Function(_$RegistrationSettingsModelImpl) then) =
      __$$RegistrationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      RegistrationStatus registrationStatus,
      List<String> otpChannels,
      int otpLength,
      int otpExpiryMinutes,
      int maxOtpAttempts,
      int otpCooldownMinutes,
      bool requireDocumentUpload,
      bool allowEmailRegistration,
      bool requirePhoneVerification,
      bool autoApproveProfiles,
      String? maintenanceMessage,
      DateTime createdAt,
      DateTime updatedAt,
      String? updatedBy});
}

/// @nodoc
class __$$RegistrationSettingsModelImplCopyWithImpl<$Res>
    extends _$RegistrationSettingsModelCopyWithImpl<$Res,
        _$RegistrationSettingsModelImpl>
    implements _$$RegistrationSettingsModelImplCopyWith<$Res> {
  __$$RegistrationSettingsModelImplCopyWithImpl(
      _$RegistrationSettingsModelImpl _value,
      $Res Function(_$RegistrationSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? registrationStatus = null,
    Object? otpChannels = null,
    Object? otpLength = null,
    Object? otpExpiryMinutes = null,
    Object? maxOtpAttempts = null,
    Object? otpCooldownMinutes = null,
    Object? requireDocumentUpload = null,
    Object? allowEmailRegistration = null,
    Object? requirePhoneVerification = null,
    Object? autoApproveProfiles = null,
    Object? maintenanceMessage = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? updatedBy = freezed,
  }) {
    return _then(_$RegistrationSettingsModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      registrationStatus: null == registrationStatus
          ? _value.registrationStatus
          : registrationStatus // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      otpChannels: null == otpChannels
          ? _value._otpChannels
          : otpChannels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      otpLength: null == otpLength
          ? _value.otpLength
          : otpLength // ignore: cast_nullable_to_non_nullable
              as int,
      otpExpiryMinutes: null == otpExpiryMinutes
          ? _value.otpExpiryMinutes
          : otpExpiryMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxOtpAttempts: null == maxOtpAttempts
          ? _value.maxOtpAttempts
          : maxOtpAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      otpCooldownMinutes: null == otpCooldownMinutes
          ? _value.otpCooldownMinutes
          : otpCooldownMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      requireDocumentUpload: null == requireDocumentUpload
          ? _value.requireDocumentUpload
          : requireDocumentUpload // ignore: cast_nullable_to_non_nullable
              as bool,
      allowEmailRegistration: null == allowEmailRegistration
          ? _value.allowEmailRegistration
          : allowEmailRegistration // ignore: cast_nullable_to_non_nullable
              as bool,
      requirePhoneVerification: null == requirePhoneVerification
          ? _value.requirePhoneVerification
          : requirePhoneVerification // ignore: cast_nullable_to_non_nullable
              as bool,
      autoApproveProfiles: null == autoApproveProfiles
          ? _value.autoApproveProfiles
          : autoApproveProfiles // ignore: cast_nullable_to_non_nullable
              as bool,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationSettingsModelImpl implements _RegistrationSettingsModel {
  const _$RegistrationSettingsModelImpl(
      {required this.id,
      required this.registrationStatus,
      required final List<String> otpChannels,
      required this.otpLength,
      required this.otpExpiryMinutes,
      required this.maxOtpAttempts,
      required this.otpCooldownMinutes,
      required this.requireDocumentUpload,
      required this.allowEmailRegistration,
      required this.requirePhoneVerification,
      required this.autoApproveProfiles,
      this.maintenanceMessage,
      required this.createdAt,
      required this.updatedAt,
      this.updatedBy})
      : _otpChannels = otpChannels;

  factory _$RegistrationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationSettingsModelImplFromJson(json);

  @override
  final String id;
  @override
  final RegistrationStatus registrationStatus;
  final List<String> _otpChannels;
  @override
  List<String> get otpChannels {
    if (_otpChannels is EqualUnmodifiableListView) return _otpChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_otpChannels);
  }

  @override
  final int otpLength;
  @override
  final int otpExpiryMinutes;
  @override
  final int maxOtpAttempts;
  @override
  final int otpCooldownMinutes;
  @override
  final bool requireDocumentUpload;
  @override
  final bool allowEmailRegistration;
  @override
  final bool requirePhoneVerification;
  @override
  final bool autoApproveProfiles;
  @override
  final String? maintenanceMessage;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'RegistrationSettingsModel(id: $id, registrationStatus: $registrationStatus, otpChannels: $otpChannels, otpLength: $otpLength, otpExpiryMinutes: $otpExpiryMinutes, maxOtpAttempts: $maxOtpAttempts, otpCooldownMinutes: $otpCooldownMinutes, requireDocumentUpload: $requireDocumentUpload, allowEmailRegistration: $allowEmailRegistration, requirePhoneVerification: $requirePhoneVerification, autoApproveProfiles: $autoApproveProfiles, maintenanceMessage: $maintenanceMessage, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationSettingsModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.registrationStatus, registrationStatus) ||
                other.registrationStatus == registrationStatus) &&
            const DeepCollectionEquality()
                .equals(other._otpChannels, _otpChannels) &&
            (identical(other.otpLength, otpLength) ||
                other.otpLength == otpLength) &&
            (identical(other.otpExpiryMinutes, otpExpiryMinutes) ||
                other.otpExpiryMinutes == otpExpiryMinutes) &&
            (identical(other.maxOtpAttempts, maxOtpAttempts) ||
                other.maxOtpAttempts == maxOtpAttempts) &&
            (identical(other.otpCooldownMinutes, otpCooldownMinutes) ||
                other.otpCooldownMinutes == otpCooldownMinutes) &&
            (identical(other.requireDocumentUpload, requireDocumentUpload) ||
                other.requireDocumentUpload == requireDocumentUpload) &&
            (identical(other.allowEmailRegistration, allowEmailRegistration) ||
                other.allowEmailRegistration == allowEmailRegistration) &&
            (identical(
                    other.requirePhoneVerification, requirePhoneVerification) ||
                other.requirePhoneVerification == requirePhoneVerification) &&
            (identical(other.autoApproveProfiles, autoApproveProfiles) ||
                other.autoApproveProfiles == autoApproveProfiles) &&
            (identical(other.maintenanceMessage, maintenanceMessage) ||
                other.maintenanceMessage == maintenanceMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      registrationStatus,
      const DeepCollectionEquality().hash(_otpChannels),
      otpLength,
      otpExpiryMinutes,
      maxOtpAttempts,
      otpCooldownMinutes,
      requireDocumentUpload,
      allowEmailRegistration,
      requirePhoneVerification,
      autoApproveProfiles,
      maintenanceMessage,
      createdAt,
      updatedAt,
      updatedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationSettingsModelImplCopyWith<_$RegistrationSettingsModelImpl>
      get copyWith => __$$RegistrationSettingsModelImplCopyWithImpl<
          _$RegistrationSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _RegistrationSettingsModel implements RegistrationSettingsModel {
  const factory _RegistrationSettingsModel(
      {required final String id,
      required final RegistrationStatus registrationStatus,
      required final List<String> otpChannels,
      required final int otpLength,
      required final int otpExpiryMinutes,
      required final int maxOtpAttempts,
      required final int otpCooldownMinutes,
      required final bool requireDocumentUpload,
      required final bool allowEmailRegistration,
      required final bool requirePhoneVerification,
      required final bool autoApproveProfiles,
      final String? maintenanceMessage,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? updatedBy}) = _$RegistrationSettingsModelImpl;

  factory _RegistrationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$RegistrationSettingsModelImpl.fromJson;

  @override
  String get id;
  @override
  RegistrationStatus get registrationStatus;
  @override
  List<String> get otpChannels;
  @override
  int get otpLength;
  @override
  int get otpExpiryMinutes;
  @override
  int get maxOtpAttempts;
  @override
  int get otpCooldownMinutes;
  @override
  bool get requireDocumentUpload;
  @override
  bool get allowEmailRegistration;
  @override
  bool get requirePhoneVerification;
  @override
  bool get autoApproveProfiles;
  @override
  String? get maintenanceMessage;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationSettingsModelImplCopyWith<_$RegistrationSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OtpChannelModel _$OtpChannelModelFromJson(Map<String, dynamic> json) {
  return _OtpChannelModel.fromJson(json);
}

/// @nodoc
mixin _$OtpChannelModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpChannelModelCopyWith<OtpChannelModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpChannelModelCopyWith<$Res> {
  factory $OtpChannelModelCopyWith(
          OtpChannelModel value, $Res Function(OtpChannelModel) then) =
      _$OtpChannelModelCopyWithImpl<$Res, OtpChannelModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      bool enabled,
      bool isDefault,
      int priority,
      String? description});
}

/// @nodoc
class _$OtpChannelModelCopyWithImpl<$Res, $Val extends OtpChannelModel>
    implements $OtpChannelModelCopyWith<$Res> {
  _$OtpChannelModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? enabled = null,
    Object? isDefault = null,
    Object? priority = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpChannelModelImplCopyWith<$Res>
    implements $OtpChannelModelCopyWith<$Res> {
  factory _$$OtpChannelModelImplCopyWith(_$OtpChannelModelImpl value,
          $Res Function(_$OtpChannelModelImpl) then) =
      __$$OtpChannelModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      bool enabled,
      bool isDefault,
      int priority,
      String? description});
}

/// @nodoc
class __$$OtpChannelModelImplCopyWithImpl<$Res>
    extends _$OtpChannelModelCopyWithImpl<$Res, _$OtpChannelModelImpl>
    implements _$$OtpChannelModelImplCopyWith<$Res> {
  __$$OtpChannelModelImplCopyWithImpl(
      _$OtpChannelModelImpl _value, $Res Function(_$OtpChannelModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? enabled = null,
    Object? isDefault = null,
    Object? priority = null,
    Object? description = freezed,
  }) {
    return _then(_$OtpChannelModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpChannelModelImpl extends _OtpChannelModel {
  const _$OtpChannelModelImpl(
      {required this.id,
      required this.name,
      required this.displayName,
      required this.enabled,
      required this.isDefault,
      required this.priority,
      this.description})
      : super._();

  factory _$OtpChannelModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpChannelModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String displayName;
  @override
  final bool enabled;
  @override
  final bool isDefault;
  @override
  final int priority;
  @override
  final String? description;

  @override
  String toString() {
    return 'OtpChannelModel(id: $id, name: $name, displayName: $displayName, enabled: $enabled, isDefault: $isDefault, priority: $priority, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpChannelModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, displayName, enabled,
      isDefault, priority, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpChannelModelImplCopyWith<_$OtpChannelModelImpl> get copyWith =>
      __$$OtpChannelModelImplCopyWithImpl<_$OtpChannelModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpChannelModelImplToJson(
      this,
    );
  }
}

abstract class _OtpChannelModel extends OtpChannelModel {
  const factory _OtpChannelModel(
      {required final String id,
      required final String name,
      required final String displayName,
      required final bool enabled,
      required final bool isDefault,
      required final int priority,
      final String? description}) = _$OtpChannelModelImpl;
  const _OtpChannelModel._() : super._();

  factory _OtpChannelModel.fromJson(Map<String, dynamic> json) =
      _$OtpChannelModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get displayName;
  @override
  bool get enabled;
  @override
  bool get isDefault;
  @override
  int get priority;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$OtpChannelModelImplCopyWith<_$OtpChannelModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpChannelSelection _$OtpChannelSelectionFromJson(Map<String, dynamic> json) {
  return _OtpChannelSelection.fromJson(json);
}

/// @nodoc
mixin _$OtpChannelSelection {
  String get selectedChannel => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpChannelSelectionCopyWith<OtpChannelSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpChannelSelectionCopyWith<$Res> {
  factory $OtpChannelSelectionCopyWith(
          OtpChannelSelection value, $Res Function(OtpChannelSelection) then) =
      _$OtpChannelSelectionCopyWithImpl<$Res, OtpChannelSelection>;
  @useResult
  $Res call(
      {String selectedChannel,
      String phoneNumber,
      bool success,
      String? message});
}

/// @nodoc
class _$OtpChannelSelectionCopyWithImpl<$Res, $Val extends OtpChannelSelection>
    implements $OtpChannelSelectionCopyWith<$Res> {
  _$OtpChannelSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedChannel = null,
    Object? phoneNumber = null,
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      selectedChannel: null == selectedChannel
          ? _value.selectedChannel
          : selectedChannel // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpChannelSelectionImplCopyWith<$Res>
    implements $OtpChannelSelectionCopyWith<$Res> {
  factory _$$OtpChannelSelectionImplCopyWith(_$OtpChannelSelectionImpl value,
          $Res Function(_$OtpChannelSelectionImpl) then) =
      __$$OtpChannelSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String selectedChannel,
      String phoneNumber,
      bool success,
      String? message});
}

/// @nodoc
class __$$OtpChannelSelectionImplCopyWithImpl<$Res>
    extends _$OtpChannelSelectionCopyWithImpl<$Res, _$OtpChannelSelectionImpl>
    implements _$$OtpChannelSelectionImplCopyWith<$Res> {
  __$$OtpChannelSelectionImplCopyWithImpl(_$OtpChannelSelectionImpl _value,
      $Res Function(_$OtpChannelSelectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedChannel = null,
    Object? phoneNumber = null,
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_$OtpChannelSelectionImpl(
      selectedChannel: null == selectedChannel
          ? _value.selectedChannel
          : selectedChannel // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpChannelSelectionImpl implements _OtpChannelSelection {
  const _$OtpChannelSelectionImpl(
      {required this.selectedChannel,
      required this.phoneNumber,
      required this.success,
      this.message});

  factory _$OtpChannelSelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpChannelSelectionImplFromJson(json);

  @override
  final String selectedChannel;
  @override
  final String phoneNumber;
  @override
  final bool success;
  @override
  final String? message;

  @override
  String toString() {
    return 'OtpChannelSelection(selectedChannel: $selectedChannel, phoneNumber: $phoneNumber, success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpChannelSelectionImpl &&
            (identical(other.selectedChannel, selectedChannel) ||
                other.selectedChannel == selectedChannel) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, selectedChannel, phoneNumber, success, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpChannelSelectionImplCopyWith<_$OtpChannelSelectionImpl> get copyWith =>
      __$$OtpChannelSelectionImplCopyWithImpl<_$OtpChannelSelectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpChannelSelectionImplToJson(
      this,
    );
  }
}

abstract class _OtpChannelSelection implements OtpChannelSelection {
  const factory _OtpChannelSelection(
      {required final String selectedChannel,
      required final String phoneNumber,
      required final bool success,
      final String? message}) = _$OtpChannelSelectionImpl;

  factory _OtpChannelSelection.fromJson(Map<String, dynamic> json) =
      _$OtpChannelSelectionImpl.fromJson;

  @override
  String get selectedChannel;
  @override
  String get phoneNumber;
  @override
  bool get success;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$OtpChannelSelectionImplCopyWith<_$OtpChannelSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegistrationStatusResponse _$RegistrationStatusResponseFromJson(
    Map<String, dynamic> json) {
  return _RegistrationStatusResponse.fromJson(json);
}

/// @nodoc
mixin _$RegistrationStatusResponse {
  bool get canRegister => throw _privateConstructorUsedError;
  RegistrationStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  DateTime? get nextAvailableTime => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalInfo =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationStatusResponseCopyWith<RegistrationStatusResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStatusResponseCopyWith<$Res> {
  factory $RegistrationStatusResponseCopyWith(RegistrationStatusResponse value,
          $Res Function(RegistrationStatusResponse) then) =
      _$RegistrationStatusResponseCopyWithImpl<$Res,
          RegistrationStatusResponse>;
  @useResult
  $Res call(
      {bool canRegister,
      RegistrationStatus status,
      String? message,
      String? reason,
      DateTime? nextAvailableTime,
      Map<String, dynamic>? additionalInfo});
}

/// @nodoc
class _$RegistrationStatusResponseCopyWithImpl<$Res,
        $Val extends RegistrationStatusResponse>
    implements $RegistrationStatusResponseCopyWith<$Res> {
  _$RegistrationStatusResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canRegister = null,
    Object? status = null,
    Object? message = freezed,
    Object? reason = freezed,
    Object? nextAvailableTime = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_value.copyWith(
      canRegister: null == canRegister
          ? _value.canRegister
          : canRegister // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      nextAvailableTime: freezed == nextAvailableTime
          ? _value.nextAvailableTime
          : nextAvailableTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationStatusResponseImplCopyWith<$Res>
    implements $RegistrationStatusResponseCopyWith<$Res> {
  factory _$$RegistrationStatusResponseImplCopyWith(
          _$RegistrationStatusResponseImpl value,
          $Res Function(_$RegistrationStatusResponseImpl) then) =
      __$$RegistrationStatusResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool canRegister,
      RegistrationStatus status,
      String? message,
      String? reason,
      DateTime? nextAvailableTime,
      Map<String, dynamic>? additionalInfo});
}

/// @nodoc
class __$$RegistrationStatusResponseImplCopyWithImpl<$Res>
    extends _$RegistrationStatusResponseCopyWithImpl<$Res,
        _$RegistrationStatusResponseImpl>
    implements _$$RegistrationStatusResponseImplCopyWith<$Res> {
  __$$RegistrationStatusResponseImplCopyWithImpl(
      _$RegistrationStatusResponseImpl _value,
      $Res Function(_$RegistrationStatusResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canRegister = null,
    Object? status = null,
    Object? message = freezed,
    Object? reason = freezed,
    Object? nextAvailableTime = freezed,
    Object? additionalInfo = freezed,
  }) {
    return _then(_$RegistrationStatusResponseImpl(
      canRegister: null == canRegister
          ? _value.canRegister
          : canRegister // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      nextAvailableTime: freezed == nextAvailableTime
          ? _value.nextAvailableTime
          : nextAvailableTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      additionalInfo: freezed == additionalInfo
          ? _value._additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationStatusResponseImpl implements _RegistrationStatusResponse {
  const _$RegistrationStatusResponseImpl(
      {required this.canRegister,
      required this.status,
      this.message,
      this.reason,
      this.nextAvailableTime,
      final Map<String, dynamic>? additionalInfo})
      : _additionalInfo = additionalInfo;

  factory _$RegistrationStatusResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RegistrationStatusResponseImplFromJson(json);

  @override
  final bool canRegister;
  @override
  final RegistrationStatus status;
  @override
  final String? message;
  @override
  final String? reason;
  @override
  final DateTime? nextAvailableTime;
  final Map<String, dynamic>? _additionalInfo;
  @override
  Map<String, dynamic>? get additionalInfo {
    final value = _additionalInfo;
    if (value == null) return null;
    if (_additionalInfo is EqualUnmodifiableMapView) return _additionalInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'RegistrationStatusResponse(canRegister: $canRegister, status: $status, message: $message, reason: $reason, nextAvailableTime: $nextAvailableTime, additionalInfo: $additionalInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationStatusResponseImpl &&
            (identical(other.canRegister, canRegister) ||
                other.canRegister == canRegister) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.nextAvailableTime, nextAvailableTime) ||
                other.nextAvailableTime == nextAvailableTime) &&
            const DeepCollectionEquality()
                .equals(other._additionalInfo, _additionalInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      canRegister,
      status,
      message,
      reason,
      nextAvailableTime,
      const DeepCollectionEquality().hash(_additionalInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationStatusResponseImplCopyWith<_$RegistrationStatusResponseImpl>
      get copyWith => __$$RegistrationStatusResponseImplCopyWithImpl<
          _$RegistrationStatusResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationStatusResponseImplToJson(
      this,
    );
  }
}

abstract class _RegistrationStatusResponse
    implements RegistrationStatusResponse {
  const factory _RegistrationStatusResponse(
          {required final bool canRegister,
          required final RegistrationStatus status,
          final String? message,
          final String? reason,
          final DateTime? nextAvailableTime,
          final Map<String, dynamic>? additionalInfo}) =
      _$RegistrationStatusResponseImpl;

  factory _RegistrationStatusResponse.fromJson(Map<String, dynamic> json) =
      _$RegistrationStatusResponseImpl.fromJson;

  @override
  bool get canRegister;
  @override
  RegistrationStatus get status;
  @override
  String? get message;
  @override
  String? get reason;
  @override
  DateTime? get nextAvailableTime;
  @override
  Map<String, dynamic>? get additionalInfo;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationStatusResponseImplCopyWith<_$RegistrationStatusResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RegistrationSettingsCache _$RegistrationSettingsCacheFromJson(
    Map<String, dynamic> json) {
  return _RegistrationSettingsCache.fromJson(json);
}

/// @nodoc
mixin _$RegistrationSettingsCache {
  RegistrationSettingsModel get settings => throw _privateConstructorUsedError;
  DateTime get cachedAt => throw _privateConstructorUsedError;
  Duration get cacheExpiry => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationSettingsCacheCopyWith<RegistrationSettingsCache> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationSettingsCacheCopyWith<$Res> {
  factory $RegistrationSettingsCacheCopyWith(RegistrationSettingsCache value,
          $Res Function(RegistrationSettingsCache) then) =
      _$RegistrationSettingsCacheCopyWithImpl<$Res, RegistrationSettingsCache>;
  @useResult
  $Res call(
      {RegistrationSettingsModel settings,
      DateTime cachedAt,
      Duration cacheExpiry});

  $RegistrationSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class _$RegistrationSettingsCacheCopyWithImpl<$Res,
        $Val extends RegistrationSettingsCache>
    implements $RegistrationSettingsCacheCopyWith<$Res> {
  _$RegistrationSettingsCacheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = null,
    Object? cachedAt = null,
    Object? cacheExpiry = null,
  }) {
    return _then(_value.copyWith(
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as RegistrationSettingsModel,
      cachedAt: null == cachedAt
          ? _value.cachedAt
          : cachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cacheExpiry: null == cacheExpiry
          ? _value.cacheExpiry
          : cacheExpiry // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RegistrationSettingsModelCopyWith<$Res> get settings {
    return $RegistrationSettingsModelCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RegistrationSettingsCacheImplCopyWith<$Res>
    implements $RegistrationSettingsCacheCopyWith<$Res> {
  factory _$$RegistrationSettingsCacheImplCopyWith(
          _$RegistrationSettingsCacheImpl value,
          $Res Function(_$RegistrationSettingsCacheImpl) then) =
      __$$RegistrationSettingsCacheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RegistrationSettingsModel settings,
      DateTime cachedAt,
      Duration cacheExpiry});

  @override
  $RegistrationSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class __$$RegistrationSettingsCacheImplCopyWithImpl<$Res>
    extends _$RegistrationSettingsCacheCopyWithImpl<$Res,
        _$RegistrationSettingsCacheImpl>
    implements _$$RegistrationSettingsCacheImplCopyWith<$Res> {
  __$$RegistrationSettingsCacheImplCopyWithImpl(
      _$RegistrationSettingsCacheImpl _value,
      $Res Function(_$RegistrationSettingsCacheImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = null,
    Object? cachedAt = null,
    Object? cacheExpiry = null,
  }) {
    return _then(_$RegistrationSettingsCacheImpl(
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as RegistrationSettingsModel,
      cachedAt: null == cachedAt
          ? _value.cachedAt
          : cachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cacheExpiry: null == cacheExpiry
          ? _value.cacheExpiry
          : cacheExpiry // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationSettingsCacheImpl extends _RegistrationSettingsCache {
  const _$RegistrationSettingsCacheImpl(
      {required this.settings,
      required this.cachedAt,
      required this.cacheExpiry})
      : super._();

  factory _$RegistrationSettingsCacheImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationSettingsCacheImplFromJson(json);

  @override
  final RegistrationSettingsModel settings;
  @override
  final DateTime cachedAt;
  @override
  final Duration cacheExpiry;

  @override
  String toString() {
    return 'RegistrationSettingsCache(settings: $settings, cachedAt: $cachedAt, cacheExpiry: $cacheExpiry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationSettingsCacheImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.cachedAt, cachedAt) ||
                other.cachedAt == cachedAt) &&
            (identical(other.cacheExpiry, cacheExpiry) ||
                other.cacheExpiry == cacheExpiry));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, settings, cachedAt, cacheExpiry);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationSettingsCacheImplCopyWith<_$RegistrationSettingsCacheImpl>
      get copyWith => __$$RegistrationSettingsCacheImplCopyWithImpl<
          _$RegistrationSettingsCacheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationSettingsCacheImplToJson(
      this,
    );
  }
}

abstract class _RegistrationSettingsCache extends RegistrationSettingsCache {
  const factory _RegistrationSettingsCache(
      {required final RegistrationSettingsModel settings,
      required final DateTime cachedAt,
      required final Duration cacheExpiry}) = _$RegistrationSettingsCacheImpl;
  const _RegistrationSettingsCache._() : super._();

  factory _RegistrationSettingsCache.fromJson(Map<String, dynamic> json) =
      _$RegistrationSettingsCacheImpl.fromJson;

  @override
  RegistrationSettingsModel get settings;
  @override
  DateTime get cachedAt;
  @override
  Duration get cacheExpiry;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationSettingsCacheImplCopyWith<_$RegistrationSettingsCacheImpl>
      get copyWith => throw _privateConstructorUsedError;
}
