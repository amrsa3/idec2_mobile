// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'governorate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GovernorateModel _$GovernorateModelFromJson(Map<String, dynamic> json) {
  return _GovernorateModel.fromJson(json);
}

/// @nodoc
mixin _$GovernorateModel {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GovernorateModelCopyWith<GovernorateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GovernorateModelCopyWith<$Res> {
  factory $GovernorateModelCopyWith(
          GovernorateModel value, $Res Function(GovernorateModel) then) =
      _$GovernorateModelCopyWithImpl<$Res, GovernorateModel>;
  @useResult
  $Res call({String id, String? name, String nameAr});
}

/// @nodoc
class _$GovernorateModelCopyWithImpl<$Res, $Val extends GovernorateModel>
    implements $GovernorateModelCopyWith<$Res> {
  _$GovernorateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? nameAr = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GovernorateModelImplCopyWith<$Res>
    implements $GovernorateModelCopyWith<$Res> {
  factory _$$GovernorateModelImplCopyWith(_$GovernorateModelImpl value,
          $Res Function(_$GovernorateModelImpl) then) =
      __$$GovernorateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? name, String nameAr});
}

/// @nodoc
class __$$GovernorateModelImplCopyWithImpl<$Res>
    extends _$GovernorateModelCopyWithImpl<$Res, _$GovernorateModelImpl>
    implements _$$GovernorateModelImplCopyWith<$Res> {
  __$$GovernorateModelImplCopyWithImpl(_$GovernorateModelImpl _value,
      $Res Function(_$GovernorateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? nameAr = null,
  }) {
    return _then(_$GovernorateModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GovernorateModelImpl implements _GovernorateModel {
  const _$GovernorateModelImpl(
      {required this.id, this.name, required this.nameAr});

  factory _$GovernorateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GovernorateModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String nameAr;

  @override
  String toString() {
    return 'GovernorateModel(id: $id, name: $name, nameAr: $nameAr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GovernorateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, nameAr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GovernorateModelImplCopyWith<_$GovernorateModelImpl> get copyWith =>
      __$$GovernorateModelImplCopyWithImpl<_$GovernorateModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GovernorateModelImplToJson(
      this,
    );
  }
}

abstract class _GovernorateModel implements GovernorateModel {
  const factory _GovernorateModel(
      {required final String id,
      final String? name,
      required final String nameAr}) = _$GovernorateModelImpl;

  factory _GovernorateModel.fromJson(Map<String, dynamic> json) =
      _$GovernorateModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String get nameAr;
  @override
  @JsonKey(ignore: true)
  _$$GovernorateModelImplCopyWith<_$GovernorateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
