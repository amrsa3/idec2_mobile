// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsCategoryModel _$NewsCategoryModelFromJson(Map<String, dynamic> json) {
  return _NewsCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$NewsCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'nameAr')
  String? get nameAr => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'descriptionAr')
  String? get descriptionAr => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'sortOrder')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewsCategoryModelCopyWith<NewsCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsCategoryModelCopyWith<$Res> {
  factory $NewsCategoryModelCopyWith(
          NewsCategoryModel value, $Res Function(NewsCategoryModel) then) =
      _$NewsCategoryModelCopyWithImpl<$Res, NewsCategoryModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'nameAr') String? nameAr,
      String? description,
      @JsonKey(name: 'descriptionAr') String? descriptionAr,
      String color,
      String? icon,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'sortOrder') int sortOrder,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class _$NewsCategoryModelCopyWithImpl<$Res, $Val extends NewsCategoryModel>
    implements $NewsCategoryModelCopyWith<$Res> {
  _$NewsCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? description = freezed,
    Object? descriptionAr = freezed,
    Object? color = null,
    Object? icon = freezed,
    Object? parentId = freezed,
    Object? isActive = null,
    Object? sortOrder = null,
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
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionAr: freezed == descriptionAr
          ? _value.descriptionAr
          : descriptionAr // ignore: cast_nullable_to_non_nullable
              as String?,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$NewsCategoryModelImplCopyWith<$Res>
    implements $NewsCategoryModelCopyWith<$Res> {
  factory _$$NewsCategoryModelImplCopyWith(_$NewsCategoryModelImpl value,
          $Res Function(_$NewsCategoryModelImpl) then) =
      __$$NewsCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'nameAr') String? nameAr,
      String? description,
      @JsonKey(name: 'descriptionAr') String? descriptionAr,
      String color,
      String? icon,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'isActive') bool isActive,
      @JsonKey(name: 'sortOrder') int sortOrder,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class __$$NewsCategoryModelImplCopyWithImpl<$Res>
    extends _$NewsCategoryModelCopyWithImpl<$Res, _$NewsCategoryModelImpl>
    implements _$$NewsCategoryModelImplCopyWith<$Res> {
  __$$NewsCategoryModelImplCopyWithImpl(_$NewsCategoryModelImpl _value,
      $Res Function(_$NewsCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameAr = freezed,
    Object? description = freezed,
    Object? descriptionAr = freezed,
    Object? color = null,
    Object? icon = freezed,
    Object? parentId = freezed,
    Object? isActive = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NewsCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: freezed == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionAr: freezed == descriptionAr
          ? _value.descriptionAr
          : descriptionAr // ignore: cast_nullable_to_non_nullable
              as String?,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$NewsCategoryModelImpl implements _NewsCategoryModel {
  const _$NewsCategoryModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'nameAr') this.nameAr,
      this.description,
      @JsonKey(name: 'descriptionAr') this.descriptionAr,
      this.color = '#1890ff',
      this.icon,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'isActive') this.isActive = true,
      @JsonKey(name: 'sortOrder') this.sortOrder = 0,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt});

  factory _$NewsCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'nameAr')
  final String? nameAr;
  @override
  final String? description;
  @override
  @JsonKey(name: 'descriptionAr')
  final String? descriptionAr;
  @override
  @JsonKey()
  final String color;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;
  @override
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  @JsonKey(name: 'sortOrder')
  final int sortOrder;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NewsCategoryModel(id: $id, name: $name, nameAr: $nameAr, description: $description, descriptionAr: $descriptionAr, color: $color, icon: $icon, parentId: $parentId, isActive: $isActive, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.descriptionAr, descriptionAr) ||
                other.descriptionAr == descriptionAr) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      nameAr,
      description,
      descriptionAr,
      color,
      icon,
      parentId,
      isActive,
      sortOrder,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsCategoryModelImplCopyWith<_$NewsCategoryModelImpl> get copyWith =>
      __$$NewsCategoryModelImplCopyWithImpl<_$NewsCategoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _NewsCategoryModel implements NewsCategoryModel {
  const factory _NewsCategoryModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'nameAr') final String? nameAr,
          final String? description,
          @JsonKey(name: 'descriptionAr') final String? descriptionAr,
          final String color,
          final String? icon,
          @JsonKey(name: 'parentId') final String? parentId,
          @JsonKey(name: 'isActive') final bool isActive,
          @JsonKey(name: 'sortOrder') final int sortOrder,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt}) =
      _$NewsCategoryModelImpl;

  factory _NewsCategoryModel.fromJson(Map<String, dynamic> json) =
      _$NewsCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'nameAr')
  String? get nameAr;
  @override
  String? get description;
  @override
  @JsonKey(name: 'descriptionAr')
  String? get descriptionAr;
  @override
  String get color;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'parentId')
  String? get parentId;
  @override
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  @JsonKey(name: 'sortOrder')
  int get sortOrder;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NewsCategoryModelImplCopyWith<_$NewsCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
