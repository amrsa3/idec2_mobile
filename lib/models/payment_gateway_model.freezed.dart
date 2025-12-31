// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_gateway_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentGatewayModel _$PaymentGatewayModelFromJson(Map<String, dynamic> json) {
  return _PaymentGatewayModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentGatewayModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'adapterName')
  String get adapterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'mode')
  String get mode => throw _privateConstructorUsedError; // TEST or PRODUCTION
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentGatewayModelCopyWith<PaymentGatewayModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentGatewayModelCopyWith<$Res> {
  factory $PaymentGatewayModelCopyWith(
          PaymentGatewayModel value, $Res Function(PaymentGatewayModel) then) =
      _$PaymentGatewayModelCopyWithImpl<$Res, PaymentGatewayModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'adapterName') String adapterName,
      @JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'mode') String mode,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class _$PaymentGatewayModelCopyWithImpl<$Res, $Val extends PaymentGatewayModel>
    implements $PaymentGatewayModelCopyWith<$Res> {
  _$PaymentGatewayModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? adapterName = null,
    Object? isActive = null,
    Object? mode = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      adapterName: null == adapterName
          ? _value.adapterName
          : adapterName // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentGatewayModelImplCopyWith<$Res>
    implements $PaymentGatewayModelCopyWith<$Res> {
  factory _$$PaymentGatewayModelImplCopyWith(_$PaymentGatewayModelImpl value,
          $Res Function(_$PaymentGatewayModelImpl) then) =
      __$$PaymentGatewayModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'adapterName') String adapterName,
      @JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'mode') String mode,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class __$$PaymentGatewayModelImplCopyWithImpl<$Res>
    extends _$PaymentGatewayModelCopyWithImpl<$Res, _$PaymentGatewayModelImpl>
    implements _$$PaymentGatewayModelImplCopyWith<$Res> {
  __$$PaymentGatewayModelImplCopyWithImpl(_$PaymentGatewayModelImpl _value,
      $Res Function(_$PaymentGatewayModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? adapterName = null,
    Object? isActive = null,
    Object? mode = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PaymentGatewayModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      adapterName: null == adapterName
          ? _value.adapterName
          : adapterName // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentGatewayModelImpl implements _PaymentGatewayModel {
  const _$PaymentGatewayModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'adapterName') required this.adapterName,
      @JsonKey(name: 'isActive') required this.isActive,
      @JsonKey(name: 'mode') required this.mode,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt});

  factory _$PaymentGatewayModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentGatewayModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'adapterName')
  final String adapterName;
  @override
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  @JsonKey(name: 'mode')
  final String mode;
// TEST or PRODUCTION
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PaymentGatewayModel(id: $id, name: $name, adapterName: $adapterName, isActive: $isActive, mode: $mode, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentGatewayModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.adapterName, adapterName) ||
                other.adapterName == adapterName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, adapterName, isActive, mode, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentGatewayModelImplCopyWith<_$PaymentGatewayModelImpl> get copyWith =>
      __$$PaymentGatewayModelImplCopyWithImpl<_$PaymentGatewayModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentGatewayModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentGatewayModel implements PaymentGatewayModel {
  const factory _PaymentGatewayModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'adapterName') required final String adapterName,
          @JsonKey(name: 'isActive') required final bool isActive,
          @JsonKey(name: 'mode') required final String mode,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt}) =
      _$PaymentGatewayModelImpl;

  factory _PaymentGatewayModel.fromJson(Map<String, dynamic> json) =
      _$PaymentGatewayModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'adapterName')
  String get adapterName;
  @override
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  @JsonKey(name: 'mode')
  String get mode;
  @override // TEST or PRODUCTION
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PaymentGatewayModelImplCopyWith<_$PaymentGatewayModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
