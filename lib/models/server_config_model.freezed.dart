// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) {
  return _ServerConfig.fromJson(json);
}

/// @nodoc
mixin _$ServerConfig {
  String get baseUrl => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  bool get isSecure => throw _privateConstructorUsedError;
  DateTime? get lastTested => throw _privateConstructorUsedError;
  bool get isReachable => throw _privateConstructorUsedError;
  int? get responseTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServerConfigCopyWith<ServerConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerConfigCopyWith<$Res> {
  factory $ServerConfigCopyWith(
          ServerConfig value, $Res Function(ServerConfig) then) =
      _$ServerConfigCopyWithImpl<$Res, ServerConfig>;
  @useResult
  $Res call(
      {String baseUrl,
      int port,
      bool isDefault,
      bool isSecure,
      DateTime? lastTested,
      bool isReachable,
      int? responseTime});
}

/// @nodoc
class _$ServerConfigCopyWithImpl<$Res, $Val extends ServerConfig>
    implements $ServerConfigCopyWith<$Res> {
  _$ServerConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? port = null,
    Object? isDefault = null,
    Object? isSecure = null,
    Object? lastTested = freezed,
    Object? isReachable = null,
    Object? responseTime = freezed,
  }) {
    return _then(_value.copyWith(
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isSecure: null == isSecure
          ? _value.isSecure
          : isSecure // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isReachable: null == isReachable
          ? _value.isReachable
          : isReachable // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTime: freezed == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerConfigImplCopyWith<$Res>
    implements $ServerConfigCopyWith<$Res> {
  factory _$$ServerConfigImplCopyWith(
          _$ServerConfigImpl value, $Res Function(_$ServerConfigImpl) then) =
      __$$ServerConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String baseUrl,
      int port,
      bool isDefault,
      bool isSecure,
      DateTime? lastTested,
      bool isReachable,
      int? responseTime});
}

/// @nodoc
class __$$ServerConfigImplCopyWithImpl<$Res>
    extends _$ServerConfigCopyWithImpl<$Res, _$ServerConfigImpl>
    implements _$$ServerConfigImplCopyWith<$Res> {
  __$$ServerConfigImplCopyWithImpl(
      _$ServerConfigImpl _value, $Res Function(_$ServerConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? port = null,
    Object? isDefault = null,
    Object? isSecure = null,
    Object? lastTested = freezed,
    Object? isReachable = null,
    Object? responseTime = freezed,
  }) {
    return _then(_$ServerConfigImpl(
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      isSecure: null == isSecure
          ? _value.isSecure
          : isSecure // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isReachable: null == isReachable
          ? _value.isReachable
          : isReachable // ignore: cast_nullable_to_non_nullable
              as bool,
      responseTime: freezed == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerConfigImpl extends _ServerConfig {
  const _$ServerConfigImpl(
      {required this.baseUrl,
      required this.port,
      this.isDefault = false,
      this.isSecure = true,
      this.lastTested,
      this.isReachable = false,
      this.responseTime})
      : super._();

  factory _$ServerConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerConfigImplFromJson(json);

  @override
  final String baseUrl;
  @override
  final int port;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey()
  final bool isSecure;
  @override
  final DateTime? lastTested;
  @override
  @JsonKey()
  final bool isReachable;
  @override
  final int? responseTime;

  @override
  String toString() {
    return 'ServerConfig(baseUrl: $baseUrl, port: $port, isDefault: $isDefault, isSecure: $isSecure, lastTested: $lastTested, isReachable: $isReachable, responseTime: $responseTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerConfigImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.isSecure, isSecure) ||
                other.isSecure == isSecure) &&
            (identical(other.lastTested, lastTested) ||
                other.lastTested == lastTested) &&
            (identical(other.isReachable, isReachable) ||
                other.isReachable == isReachable) &&
            (identical(other.responseTime, responseTime) ||
                other.responseTime == responseTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, baseUrl, port, isDefault,
      isSecure, lastTested, isReachable, responseTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerConfigImplCopyWith<_$ServerConfigImpl> get copyWith =>
      __$$ServerConfigImplCopyWithImpl<_$ServerConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerConfigImplToJson(
      this,
    );
  }
}

abstract class _ServerConfig extends ServerConfig {
  const factory _ServerConfig(
      {required final String baseUrl,
      required final int port,
      final bool isDefault,
      final bool isSecure,
      final DateTime? lastTested,
      final bool isReachable,
      final int? responseTime}) = _$ServerConfigImpl;
  const _ServerConfig._() : super._();

  factory _ServerConfig.fromJson(Map<String, dynamic> json) =
      _$ServerConfigImpl.fromJson;

  @override
  String get baseUrl;
  @override
  int get port;
  @override
  bool get isDefault;
  @override
  bool get isSecure;
  @override
  DateTime? get lastTested;
  @override
  bool get isReachable;
  @override
  int? get responseTime;
  @override
  @JsonKey(ignore: true)
  _$$ServerConfigImplCopyWith<_$ServerConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ServerConfigValidation {
  String? get urlError => throw _privateConstructorUsedError;
  String? get portError => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServerConfigValidationCopyWith<ServerConfigValidation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerConfigValidationCopyWith<$Res> {
  factory $ServerConfigValidationCopyWith(ServerConfigValidation value,
          $Res Function(ServerConfigValidation) then) =
      _$ServerConfigValidationCopyWithImpl<$Res, ServerConfigValidation>;
  @useResult
  $Res call({String? urlError, String? portError, bool isValid});
}

/// @nodoc
class _$ServerConfigValidationCopyWithImpl<$Res,
        $Val extends ServerConfigValidation>
    implements $ServerConfigValidationCopyWith<$Res> {
  _$ServerConfigValidationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? urlError = freezed,
    Object? portError = freezed,
    Object? isValid = null,
  }) {
    return _then(_value.copyWith(
      urlError: freezed == urlError
          ? _value.urlError
          : urlError // ignore: cast_nullable_to_non_nullable
              as String?,
      portError: freezed == portError
          ? _value.portError
          : portError // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerConfigValidationImplCopyWith<$Res>
    implements $ServerConfigValidationCopyWith<$Res> {
  factory _$$ServerConfigValidationImplCopyWith(
          _$ServerConfigValidationImpl value,
          $Res Function(_$ServerConfigValidationImpl) then) =
      __$$ServerConfigValidationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? urlError, String? portError, bool isValid});
}

/// @nodoc
class __$$ServerConfigValidationImplCopyWithImpl<$Res>
    extends _$ServerConfigValidationCopyWithImpl<$Res,
        _$ServerConfigValidationImpl>
    implements _$$ServerConfigValidationImplCopyWith<$Res> {
  __$$ServerConfigValidationImplCopyWithImpl(
      _$ServerConfigValidationImpl _value,
      $Res Function(_$ServerConfigValidationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? urlError = freezed,
    Object? portError = freezed,
    Object? isValid = null,
  }) {
    return _then(_$ServerConfigValidationImpl(
      urlError: freezed == urlError
          ? _value.urlError
          : urlError // ignore: cast_nullable_to_non_nullable
              as String?,
      portError: freezed == portError
          ? _value.portError
          : portError // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ServerConfigValidationImpl implements _ServerConfigValidation {
  const _$ServerConfigValidationImpl(
      {this.urlError, this.portError, this.isValid = false});

  @override
  final String? urlError;
  @override
  final String? portError;
  @override
  @JsonKey()
  final bool isValid;

  @override
  String toString() {
    return 'ServerConfigValidation(urlError: $urlError, portError: $portError, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerConfigValidationImpl &&
            (identical(other.urlError, urlError) ||
                other.urlError == urlError) &&
            (identical(other.portError, portError) ||
                other.portError == portError) &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, urlError, portError, isValid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerConfigValidationImplCopyWith<_$ServerConfigValidationImpl>
      get copyWith => __$$ServerConfigValidationImplCopyWithImpl<
          _$ServerConfigValidationImpl>(this, _$identity);
}

abstract class _ServerConfigValidation implements ServerConfigValidation {
  const factory _ServerConfigValidation(
      {final String? urlError,
      final String? portError,
      final bool isValid}) = _$ServerConfigValidationImpl;

  @override
  String? get urlError;
  @override
  String? get portError;
  @override
  bool get isValid;
  @override
  @JsonKey(ignore: true)
  _$$ServerConfigValidationImplCopyWith<_$ServerConfigValidationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
