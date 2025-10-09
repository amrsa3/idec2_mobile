// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return _ApiResponse.fromJson(json);
}

/// @nodoc
mixin _$ApiResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'data')
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  List<String>? get errors => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiResponseCopyWith<ApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseCopyWith<$Res> {
  factory $ApiResponseCopyWith(
          ApiResponse value, $Res Function(ApiResponse) then) =
      _$ApiResponseCopyWithImpl<$Res, ApiResponse>;
  @useResult
  $Res call(
      {bool success,
      String message,
      @JsonKey(name: 'data') Map<String, dynamic>? data,
      List<String>? errors,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$ApiResponseCopyWithImpl<$Res, $Val extends ApiResponse>
    implements $ApiResponseCopyWith<$Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = freezed,
    Object? errors = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseImplCopyWith<$Res>
    implements $ApiResponseCopyWith<$Res> {
  factory _$$ApiResponseImplCopyWith(
          _$ApiResponseImpl value, $Res Function(_$ApiResponseImpl) then) =
      __$$ApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      @JsonKey(name: 'data') Map<String, dynamic>? data,
      List<String>? errors,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ApiResponseImplCopyWithImpl<$Res>
    extends _$ApiResponseCopyWithImpl<$Res, _$ApiResponseImpl>
    implements _$$ApiResponseImplCopyWith<$Res> {
  __$$ApiResponseImplCopyWithImpl(
      _$ApiResponseImpl _value, $Res Function(_$ApiResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? data = freezed,
    Object? errors = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ApiResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiResponseImpl implements _ApiResponse {
  const _$ApiResponseImpl(
      {required this.success,
      required this.message,
      @JsonKey(name: 'data') final Map<String, dynamic>? data,
      final List<String>? errors,
      final Map<String, dynamic>? metadata})
      : _data = data,
        _errors = errors,
        _metadata = metadata;

  factory _$ApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  final Map<String, dynamic>? _data;
  @override
  @JsonKey(name: 'data')
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _errors;
  @override
  List<String>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'ApiResponse(success: $success, message: $message, data: $data, errors: $errors, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_errors),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      __$$ApiResponseImplCopyWithImpl<_$ApiResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiResponseImplToJson(
      this,
    );
  }
}

abstract class _ApiResponse implements ApiResponse {
  const factory _ApiResponse(
      {required final bool success,
      required final String message,
      @JsonKey(name: 'data') final Map<String, dynamic>? data,
      final List<String>? errors,
      final Map<String, dynamic>? metadata}) = _$ApiResponseImpl;

  factory _ApiResponse.fromJson(Map<String, dynamic> json) =
      _$ApiResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  @JsonKey(name: 'data')
  Map<String, dynamic>? get data;
  @override
  List<String>? get errors;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ApiResponseImplCopyWith<_$ApiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServerSettingsModel _$ServerSettingsModelFromJson(Map<String, dynamic> json) {
  return _ServerSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$ServerSettingsModel {
  bool get registrationEnabled => throw _privateConstructorUsedError;
  List<String> get availableOtpChannels => throw _privateConstructorUsedError;
  List<String> get supportedLanguages => throw _privateConstructorUsedError;
  String get defaultLanguage => throw _privateConstructorUsedError;
  Map<String, dynamic> get appConfig => throw _privateConstructorUsedError;
  String? get maintenanceMessage => throw _privateConstructorUsedError;
  bool? get isMaintenanceMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServerSettingsModelCopyWith<ServerSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerSettingsModelCopyWith<$Res> {
  factory $ServerSettingsModelCopyWith(
          ServerSettingsModel value, $Res Function(ServerSettingsModel) then) =
      _$ServerSettingsModelCopyWithImpl<$Res, ServerSettingsModel>;
  @useResult
  $Res call(
      {bool registrationEnabled,
      List<String> availableOtpChannels,
      List<String> supportedLanguages,
      String defaultLanguage,
      Map<String, dynamic> appConfig,
      String? maintenanceMessage,
      bool? isMaintenanceMode});
}

/// @nodoc
class _$ServerSettingsModelCopyWithImpl<$Res, $Val extends ServerSettingsModel>
    implements $ServerSettingsModelCopyWith<$Res> {
  _$ServerSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registrationEnabled = null,
    Object? availableOtpChannels = null,
    Object? supportedLanguages = null,
    Object? defaultLanguage = null,
    Object? appConfig = null,
    Object? maintenanceMessage = freezed,
    Object? isMaintenanceMode = freezed,
  }) {
    return _then(_value.copyWith(
      registrationEnabled: null == registrationEnabled
          ? _value.registrationEnabled
          : registrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      availableOtpChannels: null == availableOtpChannels
          ? _value.availableOtpChannels
          : availableOtpChannels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      supportedLanguages: null == supportedLanguages
          ? _value.supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      appConfig: null == appConfig
          ? _value.appConfig
          : appConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isMaintenanceMode: freezed == isMaintenanceMode
          ? _value.isMaintenanceMode
          : isMaintenanceMode // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerSettingsModelImplCopyWith<$Res>
    implements $ServerSettingsModelCopyWith<$Res> {
  factory _$$ServerSettingsModelImplCopyWith(_$ServerSettingsModelImpl value,
          $Res Function(_$ServerSettingsModelImpl) then) =
      __$$ServerSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool registrationEnabled,
      List<String> availableOtpChannels,
      List<String> supportedLanguages,
      String defaultLanguage,
      Map<String, dynamic> appConfig,
      String? maintenanceMessage,
      bool? isMaintenanceMode});
}

/// @nodoc
class __$$ServerSettingsModelImplCopyWithImpl<$Res>
    extends _$ServerSettingsModelCopyWithImpl<$Res, _$ServerSettingsModelImpl>
    implements _$$ServerSettingsModelImplCopyWith<$Res> {
  __$$ServerSettingsModelImplCopyWithImpl(_$ServerSettingsModelImpl _value,
      $Res Function(_$ServerSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? registrationEnabled = null,
    Object? availableOtpChannels = null,
    Object? supportedLanguages = null,
    Object? defaultLanguage = null,
    Object? appConfig = null,
    Object? maintenanceMessage = freezed,
    Object? isMaintenanceMode = freezed,
  }) {
    return _then(_$ServerSettingsModelImpl(
      registrationEnabled: null == registrationEnabled
          ? _value.registrationEnabled
          : registrationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      availableOtpChannels: null == availableOtpChannels
          ? _value._availableOtpChannels
          : availableOtpChannels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      supportedLanguages: null == supportedLanguages
          ? _value._supportedLanguages
          : supportedLanguages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defaultLanguage: null == defaultLanguage
          ? _value.defaultLanguage
          : defaultLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      appConfig: null == appConfig
          ? _value._appConfig
          : appConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      maintenanceMessage: freezed == maintenanceMessage
          ? _value.maintenanceMessage
          : maintenanceMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isMaintenanceMode: freezed == isMaintenanceMode
          ? _value.isMaintenanceMode
          : isMaintenanceMode // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerSettingsModelImpl implements _ServerSettingsModel {
  const _$ServerSettingsModelImpl(
      {required this.registrationEnabled,
      required final List<String> availableOtpChannels,
      required final List<String> supportedLanguages,
      required this.defaultLanguage,
      required final Map<String, dynamic> appConfig,
      this.maintenanceMessage,
      this.isMaintenanceMode})
      : _availableOtpChannels = availableOtpChannels,
        _supportedLanguages = supportedLanguages,
        _appConfig = appConfig;

  factory _$ServerSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerSettingsModelImplFromJson(json);

  @override
  final bool registrationEnabled;
  final List<String> _availableOtpChannels;
  @override
  List<String> get availableOtpChannels {
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
  final Map<String, dynamic> _appConfig;
  @override
  Map<String, dynamic> get appConfig {
    if (_appConfig is EqualUnmodifiableMapView) return _appConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_appConfig);
  }

  @override
  final String? maintenanceMessage;
  @override
  final bool? isMaintenanceMode;

  @override
  String toString() {
    return 'ServerSettingsModel(registrationEnabled: $registrationEnabled, availableOtpChannels: $availableOtpChannels, supportedLanguages: $supportedLanguages, defaultLanguage: $defaultLanguage, appConfig: $appConfig, maintenanceMessage: $maintenanceMessage, isMaintenanceMode: $isMaintenanceMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerSettingsModelImpl &&
            (identical(other.registrationEnabled, registrationEnabled) ||
                other.registrationEnabled == registrationEnabled) &&
            const DeepCollectionEquality()
                .equals(other._availableOtpChannels, _availableOtpChannels) &&
            const DeepCollectionEquality()
                .equals(other._supportedLanguages, _supportedLanguages) &&
            (identical(other.defaultLanguage, defaultLanguage) ||
                other.defaultLanguage == defaultLanguage) &&
            const DeepCollectionEquality()
                .equals(other._appConfig, _appConfig) &&
            (identical(other.maintenanceMessage, maintenanceMessage) ||
                other.maintenanceMessage == maintenanceMessage) &&
            (identical(other.isMaintenanceMode, isMaintenanceMode) ||
                other.isMaintenanceMode == isMaintenanceMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      registrationEnabled,
      const DeepCollectionEquality().hash(_availableOtpChannels),
      const DeepCollectionEquality().hash(_supportedLanguages),
      defaultLanguage,
      const DeepCollectionEquality().hash(_appConfig),
      maintenanceMessage,
      isMaintenanceMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerSettingsModelImplCopyWith<_$ServerSettingsModelImpl> get copyWith =>
      __$$ServerSettingsModelImplCopyWithImpl<_$ServerSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _ServerSettingsModel implements ServerSettingsModel {
  const factory _ServerSettingsModel(
      {required final bool registrationEnabled,
      required final List<String> availableOtpChannels,
      required final List<String> supportedLanguages,
      required final String defaultLanguage,
      required final Map<String, dynamic> appConfig,
      final String? maintenanceMessage,
      final bool? isMaintenanceMode}) = _$ServerSettingsModelImpl;

  factory _ServerSettingsModel.fromJson(Map<String, dynamic> json) =
      _$ServerSettingsModelImpl.fromJson;

  @override
  bool get registrationEnabled;
  @override
  List<String> get availableOtpChannels;
  @override
  List<String> get supportedLanguages;
  @override
  String get defaultLanguage;
  @override
  Map<String, dynamic> get appConfig;
  @override
  String? get maintenanceMessage;
  @override
  bool? get isMaintenanceMode;
  @override
  @JsonKey(ignore: true)
  _$$ServerSettingsModelImplCopyWith<_$ServerSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HealthCheckModel _$HealthCheckModelFromJson(Map<String, dynamic> json) {
  return _HealthCheckModel.fromJson(json);
}

/// @nodoc
mixin _$HealthCheckModel {
  String get status => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get services => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HealthCheckModelCopyWith<HealthCheckModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthCheckModelCopyWith<$Res> {
  factory $HealthCheckModelCopyWith(
          HealthCheckModel value, $Res Function(HealthCheckModel) then) =
      _$HealthCheckModelCopyWithImpl<$Res, HealthCheckModel>;
  @useResult
  $Res call(
      {String status,
      String version,
      DateTime timestamp,
      Map<String, dynamic>? services});
}

/// @nodoc
class _$HealthCheckModelCopyWithImpl<$Res, $Val extends HealthCheckModel>
    implements $HealthCheckModelCopyWith<$Res> {
  _$HealthCheckModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? version = null,
    Object? timestamp = null,
    Object? services = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HealthCheckModelImplCopyWith<$Res>
    implements $HealthCheckModelCopyWith<$Res> {
  factory _$$HealthCheckModelImplCopyWith(_$HealthCheckModelImpl value,
          $Res Function(_$HealthCheckModelImpl) then) =
      __$$HealthCheckModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      String version,
      DateTime timestamp,
      Map<String, dynamic>? services});
}

/// @nodoc
class __$$HealthCheckModelImplCopyWithImpl<$Res>
    extends _$HealthCheckModelCopyWithImpl<$Res, _$HealthCheckModelImpl>
    implements _$$HealthCheckModelImplCopyWith<$Res> {
  __$$HealthCheckModelImplCopyWithImpl(_$HealthCheckModelImpl _value,
      $Res Function(_$HealthCheckModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? version = null,
    Object? timestamp = null,
    Object? services = freezed,
  }) {
    return _then(_$HealthCheckModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      services: freezed == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HealthCheckModelImpl implements _HealthCheckModel {
  const _$HealthCheckModelImpl(
      {required this.status,
      required this.version,
      required this.timestamp,
      final Map<String, dynamic>? services})
      : _services = services;

  factory _$HealthCheckModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthCheckModelImplFromJson(json);

  @override
  final String status;
  @override
  final String version;
  @override
  final DateTime timestamp;
  final Map<String, dynamic>? _services;
  @override
  Map<String, dynamic>? get services {
    final value = _services;
    if (value == null) return null;
    if (_services is EqualUnmodifiableMapView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'HealthCheckModel(status: $status, version: $version, timestamp: $timestamp, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthCheckModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._services, _services));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, status, version, timestamp,
      const DeepCollectionEquality().hash(_services));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthCheckModelImplCopyWith<_$HealthCheckModelImpl> get copyWith =>
      __$$HealthCheckModelImplCopyWithImpl<_$HealthCheckModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthCheckModelImplToJson(
      this,
    );
  }
}

abstract class _HealthCheckModel implements HealthCheckModel {
  const factory _HealthCheckModel(
      {required final String status,
      required final String version,
      required final DateTime timestamp,
      final Map<String, dynamic>? services}) = _$HealthCheckModelImpl;

  factory _HealthCheckModel.fromJson(Map<String, dynamic> json) =
      _$HealthCheckModelImpl.fromJson;

  @override
  String get status;
  @override
  String get version;
  @override
  DateTime get timestamp;
  @override
  Map<String, dynamic>? get services;
  @override
  @JsonKey(ignore: true)
  _$$HealthCheckModelImplCopyWith<_$HealthCheckModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) {
  return _ErrorModel.fromJson(json);
}

/// @nodoc
mixin _$ErrorModel {
  String get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  Map<String, dynamic>? get context => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ErrorModelCopyWith<ErrorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorModelCopyWith<$Res> {
  factory $ErrorModelCopyWith(
          ErrorModel value, $Res Function(ErrorModel) then) =
      _$ErrorModelCopyWithImpl<$Res, ErrorModel>;
  @useResult
  $Res call(
      {String code,
      String message,
      String? details,
      Map<String, dynamic>? context});
}

/// @nodoc
class _$ErrorModelCopyWithImpl<$Res, $Val extends ErrorModel>
    implements $ErrorModelCopyWith<$Res> {
  _$ErrorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = freezed,
    Object? context = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      context: freezed == context
          ? _value.context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ErrorModelImplCopyWith<$Res>
    implements $ErrorModelCopyWith<$Res> {
  factory _$$ErrorModelImplCopyWith(
          _$ErrorModelImpl value, $Res Function(_$ErrorModelImpl) then) =
      __$$ErrorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String message,
      String? details,
      Map<String, dynamic>? context});
}

/// @nodoc
class __$$ErrorModelImplCopyWithImpl<$Res>
    extends _$ErrorModelCopyWithImpl<$Res, _$ErrorModelImpl>
    implements _$$ErrorModelImplCopyWith<$Res> {
  __$$ErrorModelImplCopyWithImpl(
      _$ErrorModelImpl _value, $Res Function(_$ErrorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? details = freezed,
    Object? context = freezed,
  }) {
    return _then(_$ErrorModelImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      context: freezed == context
          ? _value._context
          : context // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorModelImpl implements _ErrorModel {
  const _$ErrorModelImpl(
      {required this.code,
      required this.message,
      this.details,
      final Map<String, dynamic>? context})
      : _context = context;

  factory _$ErrorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorModelImplFromJson(json);

  @override
  final String code;
  @override
  final String message;
  @override
  final String? details;
  final Map<String, dynamic>? _context;
  @override
  Map<String, dynamic>? get context {
    final value = _context;
    if (value == null) return null;
    if (_context is EqualUnmodifiableMapView) return _context;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ErrorModel(code: $code, message: $message, details: $details, context: $context)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorModelImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details) &&
            const DeepCollectionEquality().equals(other._context, _context));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, message, details,
      const DeepCollectionEquality().hash(_context));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorModelImplCopyWith<_$ErrorModelImpl> get copyWith =>
      __$$ErrorModelImplCopyWithImpl<_$ErrorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorModelImplToJson(
      this,
    );
  }
}

abstract class _ErrorModel implements ErrorModel {
  const factory _ErrorModel(
      {required final String code,
      required final String message,
      final String? details,
      final Map<String, dynamic>? context}) = _$ErrorModelImpl;

  factory _ErrorModel.fromJson(Map<String, dynamic> json) =
      _$ErrorModelImpl.fromJson;

  @override
  String get code;
  @override
  String get message;
  @override
  String? get details;
  @override
  Map<String, dynamic>? get context;
  @override
  @JsonKey(ignore: true)
  _$$ErrorModelImplCopyWith<_$ErrorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
