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
  bool get registrationEnabled => throw _privateConstructorUsedError;
  RegistrationStatus get status => throw _privateConstructorUsedError;
  List<OtpChannelModel> get availableOtpChannels =>
      throw _privateConstructorUsedError;
  List<String> get supportedLanguages => throw _privateConstructorUsedError;
  String get defaultLanguage => throw _privateConstructorUsedError;
  String? get maintenanceMessage => throw _privateConstructorUsedError;
  DateTime? get maintenanceStartTime => throw _privateConstructorUsedError;
  DateTime? get maintenanceEndTime => throw _privateConstructorUsedError;
  String? get registrationClosedMessage => throw _privateConstructorUsedError;
  DateTime? get registrationOpenTime => throw _privateConstructorUsedError;
  DateTime? get registrationCloseTime => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalSettings =>
      throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

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
      {bool registrationEnabled,
      RegistrationStatus status,
      List<OtpChannelModel> availableOtpChannels,
      List<String> supportedLanguages,
      String defaultLanguage,
      String? maintenanceMessage,
      DateTime? maintenanceStartTime,
      DateTime? maintenanceEndTime,
      String? registrationClosedMessage,
      DateTime? registrationOpenTime,
      DateTime? registrationCloseTime,
      Map<String, dynamic>? additionalSettings,
      DateTime? lastUpdated});
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
    Object? registrationEnabled = null,
    Object? status = null,
    Object? availableOtpChannels = null,
    Object? supportedLanguages = null,
    Object? defaultLanguage = null,
    Object? maintenanceMessage = freezed,
    Object? maintenanceStartTime = freezed,
    Object? maintenanceEndTime = freezed,
    Object? registrationClosedMessage = freezed,
    Object? registrationOpenTime = freezed,
    Object? registrationCloseTime = freezed,
    Object? additionalSettings = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      registrationEnabled: null == registrationEnabled
          ? _value.registrationEnabled
          : registrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      availableOtpChannels: null == availableOtpChannels
          ? _value.availableOtpChannels
          : availableOtpChannels // ignore: cast_nullable_to_non_nullable
              as List<OtpChannelModel>,
      supportedLanguages: null == supportedLanguages
          ? _value.supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      maintenanceStartTime: freezed == maintenanceStartTime
          ? _value.maintenanceStartTime
          : maintenanceStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maintenanceEndTime: freezed == maintenanceEndTime
          ? _value.maintenanceEndTime
          : maintenanceEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      registrationClosedMessage: freezed == registrationClosedMessage
          ? _value.registrationClosedMessage
          : registrationClosedMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationOpenTime: freezed == registrationOpenTime
          ? _value.registrationOpenTime
          : registrationOpenTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      registrationCloseTime: freezed == registrationCloseTime
          ? _value.registrationCloseTime
          : registrationCloseTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      additionalSettings: freezed == additionalSettings
          ? _value.additionalSettings
          : additionalSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {bool registrationEnabled,
      RegistrationStatus status,
      List<OtpChannelModel> availableOtpChannels,
      List<String> supportedLanguages,
      String defaultLanguage,
      String? maintenanceMessage,
      DateTime? maintenanceStartTime,
      DateTime? maintenanceEndTime,
      String? registrationClosedMessage,
      DateTime? registrationOpenTime,
      DateTime? registrationCloseTime,
      Map<String, dynamic>? additionalSettings,
      DateTime? lastUpdated});
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
    Object? registrationEnabled = null,
    Object? status = null,
    Object? availableOtpChannels = null,
    Object? supportedLanguages = null,
    Object? defaultLanguage = null,
    Object? maintenanceMessage = freezed,
    Object? maintenanceStartTime = freezed,
    Object? maintenanceEndTime = freezed,
    Object? registrationClosedMessage = freezed,
    Object? registrationOpenTime = freezed,
    Object? registrationCloseTime = freezed,
    Object? additionalSettings = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$RegistrationSettingsModelImpl(
      registrationEnabled: null == registrationEnabled
          ? _value.registrationEnabled
          : registrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RegistrationStatus,
      availableOtpChannels: null == availableOtpChannels
          ? _value._availableOtpChannels
          : availableOtpChannels // ignore: cast_nullable_to_non_nullable
              as List<OtpChannelModel>,
      supportedLanguages: null == supportedLanguages
          ? _value._supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      maintenanceStartTime: freezed == maintenanceStartTime
          ? _value.maintenanceStartTime
          : maintenanceStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maintenanceEndTime: freezed == maintenanceEndTime
          ? _value.maintenanceEndTime
          : maintenanceEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      registrationClosedMessage: freezed == registrationClosedMessage
          ? _value.registrationClosedMessage
          : registrationClosedMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationOpenTime: freezed == registrationOpenTime
          ? _value.registrationOpenTime
          : registrationOpenTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      registrationCloseTime: freezed == registrationCloseTime
          ? _value.registrationCloseTime
          : registrationCloseTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      additionalSettings: freezed == additionalSettings
          ? _value._additionalSettings
          : additionalSettings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationSettingsModelImpl implements _RegistrationSettingsModel {
  const _$RegistrationSettingsModelImpl(
      {required this.registrationEnabled,
      required this.status,
      required final List<OtpChannelModel> availableOtpChannels,
      required final List<String> supportedLanguages,
      required this.defaultLanguage,
      this.maintenanceMessage,
      this.maintenanceStartTime,
      this.maintenanceEndTime,
      this.registrationClosedMessage,
      this.registrationOpenTime,
      this.registrationCloseTime,
      final Map<String, dynamic>? additionalSettings,
      this.lastUpdated})
      : _availableOtpChannels = availableOtpChannels,
        _supportedLanguages = supportedLanguages,
        _additionalSettings = additionalSettings;

  factory _$RegistrationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationSettingsModelImplFromJson(json);

  @override
  final bool registrationEnabled;
  @override
  final RegistrationStatus status;
  final List<OtpChannelModel> _availableOtpChannels;
  @override
  List<OtpChannelModel> get availableOtpChannels {
    if (_availableOtpChannels is EqualUnmodifiableListView)
      return _availableOtpChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableOtpChannels);
  }

  final List<String> _supportedLanguages;
  @override
  List<String> get supportedLanguages {
    if (_supportedLanguages is EqualUnmodifiableListView)
      return _supportedLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supportedLanguages);
  }

  @override
  final String defaultLanguage;
  @override
  final String? maintenanceMessage;
  @override
  final DateTime? maintenanceStartTime;
  @override
  final DateTime? maintenanceEndTime;
  @override
  final String? registrationClosedMessage;
  @override
  final DateTime? registrationOpenTime;
  @override
  final DateTime? registrationCloseTime;
  final Map<String, dynamic>? _additionalSettings;
  @override
  Map<String, dynamic>? get additionalSettings {
    final value = _additionalSettings;
    if (value == null) return null;
    if (_additionalSettings is EqualUnmodifiableMapView)
      return _additionalSettings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'RegistrationSettingsModel(registrationEnabled: $registrationEnabled, status: $status, availableOtpChannels: $availableOtpChannels, supportedLanguages: $supportedLanguages, defaultLanguage: $defaultLanguage, maintenanceMessage: $maintenanceMessage, maintenanceStartTime: $maintenanceStartTime, maintenanceEndTime: $maintenanceEndTime, registrationClosedMessage: $registrationClosedMessage, registrationOpenTime: $registrationOpenTime, registrationCloseTime: $registrationCloseTime, additionalSettings: $additionalSettings, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationSettingsModelImpl &&
            (identical(other.registrationEnabled, registrationEnabled) ||
                other.registrationEnabled == registrationEnabled) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._availableOtpChannels, _availableOtpChannels) &&
            const DeepCollectionEquality()
                .equals(other._supportedLanguages, _supportedLanguages) &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            (identical(other.maintenanceMessage, maintenanceMessage) ||
                other.maintenanceMessage == maintenanceMessage) &&
            (identical(other.maintenanceStartTime, maintenanceStartTime) ||
                other.maintenanceStartTime == maintenanceStartTime) &&
            (identical(other.maintenanceEndTime, maintenanceEndTime) ||
                other.maintenanceEndTime == maintenanceEndTime) &&
            (identical(other.registrationClosedMessage,
                    registrationClosedMessage) ||
                other.registrationClosedMessage == registrationClosedMessage) &&
            (identical(other.registrationOpenTime, registrationOpenTime) ||
                other.registrationOpenTime == registrationOpenTime) &&
            (identical(other.registrationCloseTime, registrationCloseTime) ||
                other.registrationCloseTime == registrationCloseTime) &&
            const DeepCollectionEquality()
                .equals(other._additionalSettings, _additionalSettings) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      registrationEnabled,
      status,
      const DeepCollectionEquality().hash(_availableOtpChannels),
      const DeepCollectionEquality().hash(_supportedLanguages),
      defaultLanguage,
      maintenanceMessage,
      maintenanceStartTime,
      maintenanceEndTime,
      registrationClosedMessage,
      registrationOpenTime,
      registrationCloseTime,
      const DeepCollectionEquality().hash(_additionalSettings),
      lastUpdated);

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
      {required final bool registrationEnabled,
      required final RegistrationStatus status,
      required final List<OtpChannelModel> availableOtpChannels,
      required final List<String> supportedLanguages,
      required final String defaultLanguage,
      final String? maintenanceMessage,
      final DateTime? maintenanceStartTime,
      final DateTime? maintenanceEndTime,
      final String? registrationClosedMessage,
      final DateTime? registrationOpenTime,
      final DateTime? registrationCloseTime,
      final Map<String, dynamic>? additionalSettings,
      final DateTime? lastUpdated}) = _$RegistrationSettingsModelImpl;

  factory _RegistrationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$RegistrationSettingsModelImpl.fromJson;

  @override
  bool get registrationEnabled;
  @override
  RegistrationStatus get status;
  @override
  List<OtpChannelModel> get availableOtpChannels;
  @override
  List<String> get supportedLanguages;
  @override
  String get defaultLanguage;
  @override
  String? get maintenanceMessage;
  @override
  DateTime? get maintenanceStartTime;
  @override
  DateTime? get maintenanceEndTime;
  @override
  String? get registrationClosedMessage;
  @override
  DateTime? get registrationOpenTime;
  @override
  DateTime? get registrationCloseTime;
  @override
  Map<String, dynamic>? get additionalSettings;
  @override
  DateTime? get lastUpdated;
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
  int? get priority => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

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
      int? priority,
      Map<String, dynamic>? settings,
      String? description,
      String? icon});
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
    Object? priority = freezed,
    Object? settings = freezed,
    Object? description = freezed,
    Object? icon = freezed,
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
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
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
      int? priority,
      Map<String, dynamic>? settings,
      String? description,
      String? icon});
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
    Object? priority = freezed,
    Object? settings = freezed,
    Object? description = freezed,
    Object? icon = freezed,
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
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpChannelModelImpl implements _OtpChannelModel {
  const _$OtpChannelModelImpl(
      {required this.id,
      required this.name,
      required this.displayName,
      required this.enabled,
      required this.isDefault,
      this.priority,
      final Map<String, dynamic>? settings,
      this.description,
      this.icon})
      : _settings = settings;

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
  final int? priority;
  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? description;
  @override
  final String? icon;

  @override
  String toString() {
    return 'OtpChannelModel(id: $id, name: $name, displayName: $displayName, enabled: $enabled, isDefault: $isDefault, priority: $priority, settings: $settings, description: $description, icon: $icon)';
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
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      displayName,
      enabled,
      isDefault,
      priority,
      const DeepCollectionEquality().hash(_settings),
      description,
      icon);

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

abstract class _OtpChannelModel implements OtpChannelModel {
  const factory _OtpChannelModel(
      {required final String id,
      required final String name,
      required final String displayName,
      required final bool enabled,
      required final bool isDefault,
      final int? priority,
      final Map<String, dynamic>? settings,
      final String? description,
      final String? icon}) = _$OtpChannelModelImpl;

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
  int? get priority;
  @override
  Map<String, dynamic>? get settings;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  @JsonKey(ignore: true)
  _$$OtpChannelModelImplCopyWith<_$OtpChannelModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpChannelRequest _$OtpChannelRequestFromJson(Map<String, dynamic> json) {
  return _OtpChannelRequest.fromJson(json);
}

/// @nodoc
mixin _$OtpChannelRequest {
  String get phoneNumber => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpChannelRequestCopyWith<OtpChannelRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpChannelRequestCopyWith<$Res> {
  factory $OtpChannelRequestCopyWith(
          OtpChannelRequest value, $Res Function(OtpChannelRequest) then) =
      _$OtpChannelRequestCopyWithImpl<$Res, OtpChannelRequest>;
  @useResult
  $Res call(
      {String phoneNumber,
      String channelId,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$OtpChannelRequestCopyWithImpl<$Res, $Val extends OtpChannelRequest>
    implements $OtpChannelRequestCopyWith<$Res> {
  _$OtpChannelRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? channelId = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpChannelRequestImplCopyWith<$Res>
    implements $OtpChannelRequestCopyWith<$Res> {
  factory _$$OtpChannelRequestImplCopyWith(_$OtpChannelRequestImpl value,
          $Res Function(_$OtpChannelRequestImpl) then) =
      __$$OtpChannelRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String phoneNumber,
      String channelId,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$OtpChannelRequestImplCopyWithImpl<$Res>
    extends _$OtpChannelRequestCopyWithImpl<$Res, _$OtpChannelRequestImpl>
    implements _$$OtpChannelRequestImplCopyWith<$Res> {
  __$$OtpChannelRequestImplCopyWithImpl(_$OtpChannelRequestImpl _value,
      $Res Function(_$OtpChannelRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? channelId = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$OtpChannelRequestImpl(
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpChannelRequestImpl implements _OtpChannelRequest {
  const _$OtpChannelRequestImpl(
      {required this.phoneNumber,
      required this.channelId,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData;

  factory _$OtpChannelRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpChannelRequestImplFromJson(json);

  @override
  final String phoneNumber;
  @override
  final String channelId;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'OtpChannelRequest(phoneNumber: $phoneNumber, channelId: $channelId, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpChannelRequestImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, channelId,
      const DeepCollectionEquality().hash(_additionalData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpChannelRequestImplCopyWith<_$OtpChannelRequestImpl> get copyWith =>
      __$$OtpChannelRequestImplCopyWithImpl<_$OtpChannelRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpChannelRequestImplToJson(
      this,
    );
  }
}

abstract class _OtpChannelRequest implements OtpChannelRequest {
  const factory _OtpChannelRequest(
      {required final String phoneNumber,
      required final String channelId,
      final Map<String, dynamic>? additionalData}) = _$OtpChannelRequestImpl;

  factory _OtpChannelRequest.fromJson(Map<String, dynamic> json) =
      _$OtpChannelRequestImpl.fromJson;

  @override
  String get phoneNumber;
  @override
  String get channelId;
  @override
  Map<String, dynamic>? get additionalData;
  @override
  @JsonKey(ignore: true)
  _$$OtpChannelRequestImplCopyWith<_$OtpChannelRequestImpl> get copyWith =>
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

OtpChannelSelection _$OtpChannelSelectionFromJson(Map<String, dynamic> json) {
  return _OtpChannelSelection.fromJson(json);
}

/// @nodoc
mixin _$OtpChannelSelection {
  String get channelId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

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
      {String channelId,
      String displayName,
      bool isSelected,
      bool isAvailable,
      String? description,
      String? icon,
      Map<String, dynamic>? metadata});
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
    Object? channelId = null,
    Object? displayName = null,
    Object? isSelected = null,
    Object? isAvailable = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      {String channelId,
      String displayName,
      bool isSelected,
      bool isAvailable,
      String? description,
      String? icon,
      Map<String, dynamic>? metadata});
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
    Object? channelId = null,
    Object? displayName = null,
    Object? isSelected = null,
    Object? isAvailable = null,
    Object? description = freezed,
    Object? icon = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$OtpChannelSelectionImpl(
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpChannelSelectionImpl implements _OtpChannelSelection {
  const _$OtpChannelSelectionImpl(
      {required this.channelId,
      required this.displayName,
      required this.isSelected,
      required this.isAvailable,
      this.description,
      this.icon,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$OtpChannelSelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpChannelSelectionImplFromJson(json);

  @override
  final String channelId;
  @override
  final String displayName;
  @override
  final bool isSelected;
  @override
  final bool isAvailable;
  @override
  final String? description;
  @override
  final String? icon;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'OtpChannelSelection(channelId: $channelId, displayName: $displayName, isSelected: $isSelected, isAvailable: $isAvailable, description: $description, icon: $icon, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpChannelSelectionImpl &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      channelId,
      displayName,
      isSelected,
      isAvailable,
      description,
      icon,
      const DeepCollectionEquality().hash(_metadata));

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
      {required final String channelId,
      required final String displayName,
      required final bool isSelected,
      required final bool isAvailable,
      final String? description,
      final String? icon,
      final Map<String, dynamic>? metadata}) = _$OtpChannelSelectionImpl;

  factory _OtpChannelSelection.fromJson(Map<String, dynamic> json) =
      _$OtpChannelSelectionImpl.fromJson;

  @override
  String get channelId;
  @override
  String get displayName;
  @override
  bool get isSelected;
  @override
  bool get isAvailable;
  @override
  String? get description;
  @override
  String? get icon;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$OtpChannelSelectionImplCopyWith<_$OtpChannelSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
