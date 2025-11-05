// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_data_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QualificationModel _$QualificationModelFromJson(Map<String, dynamic> json) {
  return _QualificationModel.fromJson(json);
}

/// @nodoc
mixin _$QualificationModel {
  String get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get categoryId =>
      throw _privateConstructorUsedError; // الفئة الرئيسية التي ينتمي إليها المؤهل
  bool? get requiresDocument => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QualificationModelCopyWith<QualificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QualificationModelCopyWith<$Res> {
  factory $QualificationModelCopyWith(
          QualificationModel value, $Res Function(QualificationModel) then) =
      _$QualificationModelCopyWithImpl<$Res, QualificationModel>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String categoryId,
      bool? requiresDocument,
      bool? isActive,
      String? description,
      int? sortOrder});
}

/// @nodoc
class _$QualificationModelCopyWithImpl<$Res, $Val extends QualificationModel>
    implements $QualificationModelCopyWith<$Res> {
  _$QualificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? categoryId = null,
    Object? requiresDocument = freezed,
    Object? isActive = freezed,
    Object? description = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      requiresDocument: freezed == requiresDocument
          ? _value.requiresDocument
          : requiresDocument // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QualificationModelImplCopyWith<$Res>
    implements $QualificationModelCopyWith<$Res> {
  factory _$$QualificationModelImplCopyWith(_$QualificationModelImpl value,
          $Res Function(_$QualificationModelImpl) then) =
      __$$QualificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String categoryId,
      bool? requiresDocument,
      bool? isActive,
      String? description,
      int? sortOrder});
}

/// @nodoc
class __$$QualificationModelImplCopyWithImpl<$Res>
    extends _$QualificationModelCopyWithImpl<$Res, _$QualificationModelImpl>
    implements _$$QualificationModelImplCopyWith<$Res> {
  __$$QualificationModelImplCopyWithImpl(_$QualificationModelImpl _value,
      $Res Function(_$QualificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? categoryId = null,
    Object? requiresDocument = freezed,
    Object? isActive = freezed,
    Object? description = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$QualificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      requiresDocument: freezed == requiresDocument
          ? _value.requiresDocument
          : requiresDocument // ignore: cast_nullable_to_non_nullable
              as bool?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QualificationModelImpl implements _QualificationModel {
  const _$QualificationModelImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.categoryId,
      this.requiresDocument = false,
      this.isActive = true,
      this.description,
      this.sortOrder});

  factory _$QualificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QualificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String categoryId;
// الفئة الرئيسية التي ينتمي إليها المؤهل
  @override
  @JsonKey()
  final bool? requiresDocument;
  @override
  @JsonKey()
  final bool? isActive;
  @override
  final String? description;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'QualificationModel(id: $id, nameAr: $nameAr, nameEn: $nameEn, categoryId: $categoryId, requiresDocument: $requiresDocument, isActive: $isActive, description: $description, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QualificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.requiresDocument, requiresDocument) ||
                other.requiresDocument == requiresDocument) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn, categoryId,
      requiresDocument, isActive, description, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QualificationModelImplCopyWith<_$QualificationModelImpl> get copyWith =>
      __$$QualificationModelImplCopyWithImpl<_$QualificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QualificationModelImplToJson(
      this,
    );
  }
}

abstract class _QualificationModel implements QualificationModel {
  const factory _QualificationModel(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final String categoryId,
      final bool? requiresDocument,
      final bool? isActive,
      final String? description,
      final int? sortOrder}) = _$QualificationModelImpl;

  factory _QualificationModel.fromJson(Map<String, dynamic> json) =
      _$QualificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  String get categoryId;
  @override // الفئة الرئيسية التي ينتمي إليها المؤهل
  bool? get requiresDocument;
  @override
  bool? get isActive;
  @override
  String? get description;
  @override
  int? get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$QualificationModelImplCopyWith<_$QualificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UniversityModel _$UniversityModelFromJson(Map<String, dynamic> json) {
  return _UniversityModel.fromJson(json);
}

/// @nodoc
mixin _$UniversityModel {
  String get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get logo => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UniversityModelCopyWith<UniversityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UniversityModelCopyWith<$Res> {
  factory $UniversityModelCopyWith(
          UniversityModel value, $Res Function(UniversityModel) then) =
      _$UniversityModelCopyWithImpl<$Res, UniversityModel>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String country,
      bool? isActive,
      String? website,
      String? logo,
      int? sortOrder});
}

/// @nodoc
class _$UniversityModelCopyWithImpl<$Res, $Val extends UniversityModel>
    implements $UniversityModelCopyWith<$Res> {
  _$UniversityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? country = null,
    Object? isActive = freezed,
    Object? website = freezed,
    Object? logo = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UniversityModelImplCopyWith<$Res>
    implements $UniversityModelCopyWith<$Res> {
  factory _$$UniversityModelImplCopyWith(_$UniversityModelImpl value,
          $Res Function(_$UniversityModelImpl) then) =
      __$$UniversityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String country,
      bool? isActive,
      String? website,
      String? logo,
      int? sortOrder});
}

/// @nodoc
class __$$UniversityModelImplCopyWithImpl<$Res>
    extends _$UniversityModelCopyWithImpl<$Res, _$UniversityModelImpl>
    implements _$$UniversityModelImplCopyWith<$Res> {
  __$$UniversityModelImplCopyWithImpl(
      _$UniversityModelImpl _value, $Res Function(_$UniversityModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? country = null,
    Object? isActive = freezed,
    Object? website = freezed,
    Object? logo = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$UniversityModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UniversityModelImpl implements _UniversityModel {
  const _$UniversityModelImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.country,
      this.isActive = true,
      this.website,
      this.logo,
      this.sortOrder});

  factory _$UniversityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UniversityModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String country;
  @override
  @JsonKey()
  final bool? isActive;
  @override
  final String? website;
  @override
  final String? logo;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'UniversityModel(id: $id, nameAr: $nameAr, nameEn: $nameEn, country: $country, isActive: $isActive, website: $website, logo: $logo, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UniversityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn, country,
      isActive, website, logo, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UniversityModelImplCopyWith<_$UniversityModelImpl> get copyWith =>
      __$$UniversityModelImplCopyWithImpl<_$UniversityModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UniversityModelImplToJson(
      this,
    );
  }
}

abstract class _UniversityModel implements UniversityModel {
  const factory _UniversityModel(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final String country,
      final bool? isActive,
      final String? website,
      final String? logo,
      final int? sortOrder}) = _$UniversityModelImpl;

  factory _UniversityModel.fromJson(Map<String, dynamic> json) =
      _$UniversityModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  String get country;
  @override
  bool? get isActive;
  @override
  String? get website;
  @override
  String? get logo;
  @override
  int? get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$UniversityModelImplCopyWith<_$UniversityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProvinceModel _$ProvinceModelFromJson(Map<String, dynamic> json) {
  return _ProvinceModel.fromJson(json);
}

/// @nodoc
mixin _$ProvinceModel {
  String get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProvinceModelCopyWith<ProvinceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProvinceModelCopyWith<$Res> {
  factory $ProvinceModelCopyWith(
          ProvinceModel value, $Res Function(ProvinceModel) then) =
      _$ProvinceModelCopyWithImpl<$Res, ProvinceModel>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String country,
      bool? isActive,
      int? sortOrder});
}

/// @nodoc
class _$ProvinceModelCopyWithImpl<$Res, $Val extends ProvinceModel>
    implements $ProvinceModelCopyWith<$Res> {
  _$ProvinceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? country = null,
    Object? isActive = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProvinceModelImplCopyWith<$Res>
    implements $ProvinceModelCopyWith<$Res> {
  factory _$$ProvinceModelImplCopyWith(
          _$ProvinceModelImpl value, $Res Function(_$ProvinceModelImpl) then) =
      __$$ProvinceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String country,
      bool? isActive,
      int? sortOrder});
}

/// @nodoc
class __$$ProvinceModelImplCopyWithImpl<$Res>
    extends _$ProvinceModelCopyWithImpl<$Res, _$ProvinceModelImpl>
    implements _$$ProvinceModelImplCopyWith<$Res> {
  __$$ProvinceModelImplCopyWithImpl(
      _$ProvinceModelImpl _value, $Res Function(_$ProvinceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? country = null,
    Object? isActive = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$ProvinceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProvinceModelImpl implements _ProvinceModel {
  const _$ProvinceModelImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.country,
      this.isActive = true,
      this.sortOrder});

  factory _$ProvinceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProvinceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String country;
  @override
  @JsonKey()
  final bool? isActive;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'ProvinceModel(id: $id, nameAr: $nameAr, nameEn: $nameEn, country: $country, isActive: $isActive, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProvinceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nameAr, nameEn, country, isActive, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProvinceModelImplCopyWith<_$ProvinceModelImpl> get copyWith =>
      __$$ProvinceModelImplCopyWithImpl<_$ProvinceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProvinceModelImplToJson(
      this,
    );
  }
}

abstract class _ProvinceModel implements ProvinceModel {
  const factory _ProvinceModel(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final String country,
      final bool? isActive,
      final int? sortOrder}) = _$ProvinceModelImpl;

  factory _ProvinceModel.fromJson(Map<String, dynamic> json) =
      _$ProvinceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  String get country;
  @override
  bool? get isActive;
  @override
  int? get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$ProvinceModelImplCopyWith<_$ProvinceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkplaceModel _$WorkplaceModelFromJson(Map<String, dynamic> json) {
  return _WorkplaceModel.fromJson(json);
}

/// @nodoc
mixin _$WorkplaceModel {
  String get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // hospital, clinic, university, etc.
  bool? get isActive => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkplaceModelCopyWith<WorkplaceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkplaceModelCopyWith<$Res> {
  factory $WorkplaceModelCopyWith(
          WorkplaceModel value, $Res Function(WorkplaceModel) then) =
      _$WorkplaceModelCopyWithImpl<$Res, WorkplaceModel>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String type,
      bool? isActive,
      String? address,
      String? website,
      int? sortOrder});
}

/// @nodoc
class _$WorkplaceModelCopyWithImpl<$Res, $Val extends WorkplaceModel>
    implements $WorkplaceModelCopyWith<$Res> {
  _$WorkplaceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? type = null,
    Object? isActive = freezed,
    Object? address = freezed,
    Object? website = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkplaceModelImplCopyWith<$Res>
    implements $WorkplaceModelCopyWith<$Res> {
  factory _$$WorkplaceModelImplCopyWith(_$WorkplaceModelImpl value,
          $Res Function(_$WorkplaceModelImpl) then) =
      __$$WorkplaceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      String type,
      bool? isActive,
      String? address,
      String? website,
      int? sortOrder});
}

/// @nodoc
class __$$WorkplaceModelImplCopyWithImpl<$Res>
    extends _$WorkplaceModelCopyWithImpl<$Res, _$WorkplaceModelImpl>
    implements _$$WorkplaceModelImplCopyWith<$Res> {
  __$$WorkplaceModelImplCopyWithImpl(
      _$WorkplaceModelImpl _value, $Res Function(_$WorkplaceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? type = null,
    Object? isActive = freezed,
    Object? address = freezed,
    Object? website = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$WorkplaceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkplaceModelImpl implements _WorkplaceModel {
  const _$WorkplaceModelImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.type,
      this.isActive = true,
      this.address,
      this.website,
      this.sortOrder});

  factory _$WorkplaceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkplaceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String type;
// hospital, clinic, university, etc.
  @override
  @JsonKey()
  final bool? isActive;
  @override
  final String? address;
  @override
  final String? website;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'WorkplaceModel(id: $id, nameAr: $nameAr, nameEn: $nameEn, type: $type, isActive: $isActive, address: $address, website: $website, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkplaceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameAr, nameEn, type,
      isActive, address, website, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkplaceModelImplCopyWith<_$WorkplaceModelImpl> get copyWith =>
      __$$WorkplaceModelImplCopyWithImpl<_$WorkplaceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkplaceModelImplToJson(
      this,
    );
  }
}

abstract class _WorkplaceModel implements WorkplaceModel {
  const factory _WorkplaceModel(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      required final String type,
      final bool? isActive,
      final String? address,
      final String? website,
      final int? sortOrder}) = _$WorkplaceModelImpl;

  factory _WorkplaceModel.fromJson(Map<String, dynamic> json) =
      _$WorkplaceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  String get type;
  @override // hospital, clinic, university, etc.
  bool? get isActive;
  @override
  String? get address;
  @override
  String? get website;
  @override
  int? get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$WorkplaceModelImplCopyWith<_$WorkplaceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpecializationModel _$SpecializationModelFromJson(Map<String, dynamic> json) {
  return _SpecializationModel.fromJson(json);
}

/// @nodoc
mixin _$SpecializationModel {
  String get id => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpecializationModelCopyWith<SpecializationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecializationModelCopyWith<$Res> {
  factory $SpecializationModelCopyWith(
          SpecializationModel value, $Res Function(SpecializationModel) then) =
      _$SpecializationModelCopyWithImpl<$Res, SpecializationModel>;
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      bool? isActive,
      String? description,
      int? sortOrder});
}

/// @nodoc
class _$SpecializationModelCopyWithImpl<$Res, $Val extends SpecializationModel>
    implements $SpecializationModelCopyWith<$Res> {
  _$SpecializationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? isActive = freezed,
    Object? description = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpecializationModelImplCopyWith<$Res>
    implements $SpecializationModelCopyWith<$Res> {
  factory _$$SpecializationModelImplCopyWith(_$SpecializationModelImpl value,
          $Res Function(_$SpecializationModelImpl) then) =
      __$$SpecializationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameAr,
      String nameEn,
      bool? isActive,
      String? description,
      int? sortOrder});
}

/// @nodoc
class __$$SpecializationModelImplCopyWithImpl<$Res>
    extends _$SpecializationModelCopyWithImpl<$Res, _$SpecializationModelImpl>
    implements _$$SpecializationModelImplCopyWith<$Res> {
  __$$SpecializationModelImplCopyWithImpl(_$SpecializationModelImpl _value,
      $Res Function(_$SpecializationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? isActive = freezed,
    Object? description = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$SpecializationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecializationModelImpl implements _SpecializationModel {
  const _$SpecializationModelImpl(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      this.isActive = true,
      this.description,
      this.sortOrder});

  factory _$SpecializationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpecializationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  @JsonKey()
  final bool? isActive;
  @override
  final String? description;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'SpecializationModel(id: $id, nameAr: $nameAr, nameEn: $nameEn, isActive: $isActive, description: $description, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecializationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, nameAr, nameEn, isActive, description, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecializationModelImplCopyWith<_$SpecializationModelImpl> get copyWith =>
      __$$SpecializationModelImplCopyWithImpl<_$SpecializationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecializationModelImplToJson(
      this,
    );
  }
}

abstract class _SpecializationModel implements SpecializationModel {
  const factory _SpecializationModel(
      {required final String id,
      required final String nameAr,
      required final String nameEn,
      final bool? isActive,
      final String? description,
      final int? sortOrder}) = _$SpecializationModelImpl;

  factory _SpecializationModel.fromJson(Map<String, dynamic> json) =
      _$SpecializationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  bool? get isActive;
  @override
  String? get description;
  @override
  int? get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$SpecializationModelImplCopyWith<_$SpecializationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileVerificationRules _$ProfileVerificationRulesFromJson(
    Map<String, dynamic> json) {
  return _ProfileVerificationRules.fromJson(json);
}

/// @nodoc
mixin _$ProfileVerificationRules {
  List<String> get requiredFields => throw _privateConstructorUsedError;
  Map<String, bool> get documentsRequired => throw _privateConstructorUsedError;
  Map<String, String> get fieldValidationRules =>
      throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  int? get maxFileSize => throw _privateConstructorUsedError; // in bytes
  List<String>? get allowedFileTypes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileVerificationRulesCopyWith<ProfileVerificationRules> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileVerificationRulesCopyWith<$Res> {
  factory $ProfileVerificationRulesCopyWith(ProfileVerificationRules value,
          $Res Function(ProfileVerificationRules) then) =
      _$ProfileVerificationRulesCopyWithImpl<$Res, ProfileVerificationRules>;
  @useResult
  $Res call(
      {List<String> requiredFields,
      Map<String, bool> documentsRequired,
      Map<String, String> fieldValidationRules,
      String? instructions,
      int? maxFileSize,
      List<String>? allowedFileTypes});
}

/// @nodoc
class _$ProfileVerificationRulesCopyWithImpl<$Res,
        $Val extends ProfileVerificationRules>
    implements $ProfileVerificationRulesCopyWith<$Res> {
  _$ProfileVerificationRulesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredFields = null,
    Object? documentsRequired = null,
    Object? fieldValidationRules = null,
    Object? instructions = freezed,
    Object? maxFileSize = freezed,
    Object? allowedFileTypes = freezed,
  }) {
    return _then(_value.copyWith(
      requiredFields: null == requiredFields
          ? _value.requiredFields
          : requiredFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      documentsRequired: null == documentsRequired
          ? _value.documentsRequired
          : documentsRequired // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      fieldValidationRules: null == fieldValidationRules
          ? _value.fieldValidationRules
          : fieldValidationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      maxFileSize: freezed == maxFileSize
          ? _value.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedFileTypes: freezed == allowedFileTypes
          ? _value.allowedFileTypes
          : allowedFileTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileVerificationRulesImplCopyWith<$Res>
    implements $ProfileVerificationRulesCopyWith<$Res> {
  factory _$$ProfileVerificationRulesImplCopyWith(
          _$ProfileVerificationRulesImpl value,
          $Res Function(_$ProfileVerificationRulesImpl) then) =
      __$$ProfileVerificationRulesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> requiredFields,
      Map<String, bool> documentsRequired,
      Map<String, String> fieldValidationRules,
      String? instructions,
      int? maxFileSize,
      List<String>? allowedFileTypes});
}

/// @nodoc
class __$$ProfileVerificationRulesImplCopyWithImpl<$Res>
    extends _$ProfileVerificationRulesCopyWithImpl<$Res,
        _$ProfileVerificationRulesImpl>
    implements _$$ProfileVerificationRulesImplCopyWith<$Res> {
  __$$ProfileVerificationRulesImplCopyWithImpl(
      _$ProfileVerificationRulesImpl _value,
      $Res Function(_$ProfileVerificationRulesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredFields = null,
    Object? documentsRequired = null,
    Object? fieldValidationRules = null,
    Object? instructions = freezed,
    Object? maxFileSize = freezed,
    Object? allowedFileTypes = freezed,
  }) {
    return _then(_$ProfileVerificationRulesImpl(
      requiredFields: null == requiredFields
          ? _value._requiredFields
          : requiredFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      documentsRequired: null == documentsRequired
          ? _value._documentsRequired
          : documentsRequired // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      fieldValidationRules: null == fieldValidationRules
          ? _value._fieldValidationRules
          : fieldValidationRules // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      maxFileSize: freezed == maxFileSize
          ? _value.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      allowedFileTypes: freezed == allowedFileTypes
          ? _value._allowedFileTypes
          : allowedFileTypes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileVerificationRulesImpl implements _ProfileVerificationRules {
  const _$ProfileVerificationRulesImpl(
      {required final List<String> requiredFields,
      required final Map<String, bool> documentsRequired,
      required final Map<String, String> fieldValidationRules,
      this.instructions,
      this.maxFileSize,
      final List<String>? allowedFileTypes})
      : _requiredFields = requiredFields,
        _documentsRequired = documentsRequired,
        _fieldValidationRules = fieldValidationRules,
        _allowedFileTypes = allowedFileTypes;

  factory _$ProfileVerificationRulesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileVerificationRulesImplFromJson(json);

  final List<String> _requiredFields;
  @override
  List<String> get requiredFields {
    if (_requiredFields is EqualUnmodifiableListView) return _requiredFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredFields);
  }

  final Map<String, bool> _documentsRequired;
  @override
  Map<String, bool> get documentsRequired {
    if (_documentsRequired is EqualUnmodifiableMapView)
      return _documentsRequired;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_documentsRequired);
  }

  final Map<String, String> _fieldValidationRules;
  @override
  Map<String, String> get fieldValidationRules {
    if (_fieldValidationRules is EqualUnmodifiableMapView)
      return _fieldValidationRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldValidationRules);
  }

  @override
  final String? instructions;
  @override
  final int? maxFileSize;
// in bytes
  final List<String>? _allowedFileTypes;
// in bytes
  @override
  List<String>? get allowedFileTypes {
    final value = _allowedFileTypes;
    if (value == null) return null;
    if (_allowedFileTypes is EqualUnmodifiableListView)
      return _allowedFileTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProfileVerificationRules(requiredFields: $requiredFields, documentsRequired: $documentsRequired, fieldValidationRules: $fieldValidationRules, instructions: $instructions, maxFileSize: $maxFileSize, allowedFileTypes: $allowedFileTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileVerificationRulesImpl &&
            const DeepCollectionEquality()
                .equals(other._requiredFields, _requiredFields) &&
            const DeepCollectionEquality()
                .equals(other._documentsRequired, _documentsRequired) &&
            const DeepCollectionEquality()
                .equals(other._fieldValidationRules, _fieldValidationRules) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.maxFileSize, maxFileSize) ||
                other.maxFileSize == maxFileSize) &&
            const DeepCollectionEquality()
                .equals(other._allowedFileTypes, _allowedFileTypes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_requiredFields),
      const DeepCollectionEquality().hash(_documentsRequired),
      const DeepCollectionEquality().hash(_fieldValidationRules),
      instructions,
      maxFileSize,
      const DeepCollectionEquality().hash(_allowedFileTypes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileVerificationRulesImplCopyWith<_$ProfileVerificationRulesImpl>
      get copyWith => __$$ProfileVerificationRulesImplCopyWithImpl<
          _$ProfileVerificationRulesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileVerificationRulesImplToJson(
      this,
    );
  }
}

abstract class _ProfileVerificationRules implements ProfileVerificationRules {
  const factory _ProfileVerificationRules(
      {required final List<String> requiredFields,
      required final Map<String, bool> documentsRequired,
      required final Map<String, String> fieldValidationRules,
      final String? instructions,
      final int? maxFileSize,
      final List<String>? allowedFileTypes}) = _$ProfileVerificationRulesImpl;

  factory _ProfileVerificationRules.fromJson(Map<String, dynamic> json) =
      _$ProfileVerificationRulesImpl.fromJson;

  @override
  List<String> get requiredFields;
  @override
  Map<String, bool> get documentsRequired;
  @override
  Map<String, String> get fieldValidationRules;
  @override
  String? get instructions;
  @override
  int? get maxFileSize;
  @override // in bytes
  List<String>? get allowedFileTypes;
  @override
  @JsonKey(ignore: true)
  _$$ProfileVerificationRulesImplCopyWith<_$ProfileVerificationRulesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DocumentUploadModel _$DocumentUploadModelFromJson(Map<String, dynamic> json) {
  return _DocumentUploadModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentUploadModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get documentType => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, approved, rejected
  DateTime get uploadedAt => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentUploadModelCopyWith<DocumentUploadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentUploadModelCopyWith<$Res> {
  factory $DocumentUploadModelCopyWith(
          DocumentUploadModel value, $Res Function(DocumentUploadModel) then) =
      _$DocumentUploadModelCopyWithImpl<$Res, DocumentUploadModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String documentType,
      String fileName,
      String fileUrl,
      String status,
      DateTime uploadedAt,
      String? rejectionReason,
      DateTime? reviewedAt,
      String? reviewedBy,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$DocumentUploadModelCopyWithImpl<$Res, $Val extends DocumentUploadModel>
    implements $DocumentUploadModelCopyWith<$Res> {
  _$DocumentUploadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? documentType = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? status = null,
    Object? uploadedAt = null,
    Object? rejectionReason = freezed,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentUploadModelImplCopyWith<$Res>
    implements $DocumentUploadModelCopyWith<$Res> {
  factory _$$DocumentUploadModelImplCopyWith(_$DocumentUploadModelImpl value,
          $Res Function(_$DocumentUploadModelImpl) then) =
      __$$DocumentUploadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String documentType,
      String fileName,
      String fileUrl,
      String status,
      DateTime uploadedAt,
      String? rejectionReason,
      DateTime? reviewedAt,
      String? reviewedBy,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$DocumentUploadModelImplCopyWithImpl<$Res>
    extends _$DocumentUploadModelCopyWithImpl<$Res, _$DocumentUploadModelImpl>
    implements _$$DocumentUploadModelImplCopyWith<$Res> {
  __$$DocumentUploadModelImplCopyWithImpl(_$DocumentUploadModelImpl _value,
      $Res Function(_$DocumentUploadModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? documentType = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? status = null,
    Object? uploadedAt = null,
    Object? rejectionReason = freezed,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$DocumentUploadModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
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
class _$DocumentUploadModelImpl implements _DocumentUploadModel {
  const _$DocumentUploadModelImpl(
      {required this.id,
      required this.userId,
      required this.documentType,
      required this.fileName,
      required this.fileUrl,
      required this.status,
      required this.uploadedAt,
      this.rejectionReason,
      this.reviewedAt,
      this.reviewedBy,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$DocumentUploadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentUploadModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String documentType;
  @override
  final String fileName;
  @override
  final String fileUrl;
  @override
  final String status;
// pending, approved, rejected
  @override
  final DateTime uploadedAt;
  @override
  final String? rejectionReason;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewedBy;
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
    return 'DocumentUploadModel(id: $id, userId: $userId, documentType: $documentType, fileName: $fileName, fileUrl: $fileUrl, status: $status, uploadedAt: $uploadedAt, rejectionReason: $rejectionReason, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentUploadModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      documentType,
      fileName,
      fileUrl,
      status,
      uploadedAt,
      rejectionReason,
      reviewedAt,
      reviewedBy,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentUploadModelImplCopyWith<_$DocumentUploadModelImpl> get copyWith =>
      __$$DocumentUploadModelImplCopyWithImpl<_$DocumentUploadModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentUploadModelImplToJson(
      this,
    );
  }
}

abstract class _DocumentUploadModel implements DocumentUploadModel {
  const factory _DocumentUploadModel(
      {required final String id,
      required final String userId,
      required final String documentType,
      required final String fileName,
      required final String fileUrl,
      required final String status,
      required final DateTime uploadedAt,
      final String? rejectionReason,
      final DateTime? reviewedAt,
      final String? reviewedBy,
      final Map<String, dynamic>? metadata}) = _$DocumentUploadModelImpl;

  factory _DocumentUploadModel.fromJson(Map<String, dynamic> json) =
      _$DocumentUploadModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get documentType;
  @override
  String get fileName;
  @override
  String get fileUrl;
  @override
  String get status;
  @override // pending, approved, rejected
  DateTime get uploadedAt;
  @override
  String? get rejectionReason;
  @override
  DateTime? get reviewedAt;
  @override
  String? get reviewedBy;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$DocumentUploadModelImplCopyWith<_$DocumentUploadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileCompletionStatus _$ProfileCompletionStatusFromJson(
    Map<String, dynamic> json) {
  return _ProfileCompletionStatus.fromJson(json);
}

/// @nodoc
mixin _$ProfileCompletionStatus {
  int get completionPercentage => throw _privateConstructorUsedError;
  List<String> get missingFields => throw _privateConstructorUsedError;
  List<String> get missingDocuments => throw _privateConstructorUsedError;
  VerificationStatus get verificationStatus =>
      throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCompletionStatusCopyWith<ProfileCompletionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCompletionStatusCopyWith<$Res> {
  factory $ProfileCompletionStatusCopyWith(ProfileCompletionStatus value,
          $Res Function(ProfileCompletionStatus) then) =
      _$ProfileCompletionStatusCopyWithImpl<$Res, ProfileCompletionStatus>;
  @useResult
  $Res call(
      {int completionPercentage,
      List<String> missingFields,
      List<String> missingDocuments,
      VerificationStatus verificationStatus,
      String? rejectionReason,
      DateTime? lastUpdated});
}

/// @nodoc
class _$ProfileCompletionStatusCopyWithImpl<$Res,
        $Val extends ProfileCompletionStatus>
    implements $ProfileCompletionStatusCopyWith<$Res> {
  _$ProfileCompletionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionPercentage = null,
    Object? missingFields = null,
    Object? missingDocuments = null,
    Object? verificationStatus = null,
    Object? rejectionReason = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      missingFields: null == missingFields
          ? _value.missingFields
          : missingFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      missingDocuments: null == missingDocuments
          ? _value.missingDocuments
          : missingDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileCompletionStatusImplCopyWith<$Res>
    implements $ProfileCompletionStatusCopyWith<$Res> {
  factory _$$ProfileCompletionStatusImplCopyWith(
          _$ProfileCompletionStatusImpl value,
          $Res Function(_$ProfileCompletionStatusImpl) then) =
      __$$ProfileCompletionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int completionPercentage,
      List<String> missingFields,
      List<String> missingDocuments,
      VerificationStatus verificationStatus,
      String? rejectionReason,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$ProfileCompletionStatusImplCopyWithImpl<$Res>
    extends _$ProfileCompletionStatusCopyWithImpl<$Res,
        _$ProfileCompletionStatusImpl>
    implements _$$ProfileCompletionStatusImplCopyWith<$Res> {
  __$$ProfileCompletionStatusImplCopyWithImpl(
      _$ProfileCompletionStatusImpl _value,
      $Res Function(_$ProfileCompletionStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completionPercentage = null,
    Object? missingFields = null,
    Object? missingDocuments = null,
    Object? verificationStatus = null,
    Object? rejectionReason = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$ProfileCompletionStatusImpl(
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as int,
      missingFields: null == missingFields
          ? _value._missingFields
          : missingFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      missingDocuments: null == missingDocuments
          ? _value._missingDocuments
          : missingDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileCompletionStatusImpl implements _ProfileCompletionStatus {
  const _$ProfileCompletionStatusImpl(
      {required this.completionPercentage,
      required final List<String> missingFields,
      required final List<String> missingDocuments,
      required this.verificationStatus,
      this.rejectionReason,
      this.lastUpdated})
      : _missingFields = missingFields,
        _missingDocuments = missingDocuments;

  factory _$ProfileCompletionStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileCompletionStatusImplFromJson(json);

  @override
  final int completionPercentage;
  final List<String> _missingFields;
  @override
  List<String> get missingFields {
    if (_missingFields is EqualUnmodifiableListView) return _missingFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingFields);
  }

  final List<String> _missingDocuments;
  @override
  List<String> get missingDocuments {
    if (_missingDocuments is EqualUnmodifiableListView)
      return _missingDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingDocuments);
  }

  @override
  final VerificationStatus verificationStatus;
  @override
  final String? rejectionReason;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'ProfileCompletionStatus(completionPercentage: $completionPercentage, missingFields: $missingFields, missingDocuments: $missingDocuments, verificationStatus: $verificationStatus, rejectionReason: $rejectionReason, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileCompletionStatusImpl &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            const DeepCollectionEquality()
                .equals(other._missingFields, _missingFields) &&
            const DeepCollectionEquality()
                .equals(other._missingDocuments, _missingDocuments) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      completionPercentage,
      const DeepCollectionEquality().hash(_missingFields),
      const DeepCollectionEquality().hash(_missingDocuments),
      verificationStatus,
      rejectionReason,
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileCompletionStatusImplCopyWith<_$ProfileCompletionStatusImpl>
      get copyWith => __$$ProfileCompletionStatusImplCopyWithImpl<
          _$ProfileCompletionStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileCompletionStatusImplToJson(
      this,
    );
  }
}

abstract class _ProfileCompletionStatus implements ProfileCompletionStatus {
  const factory _ProfileCompletionStatus(
      {required final int completionPercentage,
      required final List<String> missingFields,
      required final List<String> missingDocuments,
      required final VerificationStatus verificationStatus,
      final String? rejectionReason,
      final DateTime? lastUpdated}) = _$ProfileCompletionStatusImpl;

  factory _ProfileCompletionStatus.fromJson(Map<String, dynamic> json) =
      _$ProfileCompletionStatusImpl.fromJson;

  @override
  int get completionPercentage;
  @override
  List<String> get missingFields;
  @override
  List<String> get missingDocuments;
  @override
  VerificationStatus get verificationStatus;
  @override
  String? get rejectionReason;
  @override
  DateTime? get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$ProfileCompletionStatusImplCopyWith<_$ProfileCompletionStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProfileDataResponse _$ProfileDataResponseFromJson(Map<String, dynamic> json) {
  return _ProfileDataResponse.fromJson(json);
}

/// @nodoc
mixin _$ProfileDataResponse {
  List<QualificationModel> get qualifications =>
      throw _privateConstructorUsedError;
  List<UniversityModel> get universities => throw _privateConstructorUsedError;
  List<ProvinceModel> get provinces => throw _privateConstructorUsedError;
  List<WorkplaceModel> get workplaces => throw _privateConstructorUsedError;
  List<SpecializationModel> get specializations =>
      throw _privateConstructorUsedError;
  ProfileVerificationRules get verificationRules =>
      throw _privateConstructorUsedError;
  ProfileCompletionStatus? get completionStatus =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileDataResponseCopyWith<ProfileDataResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileDataResponseCopyWith<$Res> {
  factory $ProfileDataResponseCopyWith(
          ProfileDataResponse value, $Res Function(ProfileDataResponse) then) =
      _$ProfileDataResponseCopyWithImpl<$Res, ProfileDataResponse>;
  @useResult
  $Res call(
      {List<QualificationModel> qualifications,
      List<UniversityModel> universities,
      List<ProvinceModel> provinces,
      List<WorkplaceModel> workplaces,
      List<SpecializationModel> specializations,
      ProfileVerificationRules verificationRules,
      ProfileCompletionStatus? completionStatus});

  $ProfileVerificationRulesCopyWith<$Res> get verificationRules;
  $ProfileCompletionStatusCopyWith<$Res>? get completionStatus;
}

/// @nodoc
class _$ProfileDataResponseCopyWithImpl<$Res, $Val extends ProfileDataResponse>
    implements $ProfileDataResponseCopyWith<$Res> {
  _$ProfileDataResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qualifications = null,
    Object? universities = null,
    Object? provinces = null,
    Object? workplaces = null,
    Object? specializations = null,
    Object? verificationRules = null,
    Object? completionStatus = freezed,
  }) {
    return _then(_value.copyWith(
      qualifications: null == qualifications
          ? _value.qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<QualificationModel>,
      universities: null == universities
          ? _value.universities
          : universities // ignore: cast_nullable_to_non_nullable
              as List<UniversityModel>,
      provinces: null == provinces
          ? _value.provinces
          : provinces // ignore: cast_nullable_to_non_nullable
              as List<ProvinceModel>,
      workplaces: null == workplaces
          ? _value.workplaces
          : workplaces // ignore: cast_nullable_to_non_nullable
              as List<WorkplaceModel>,
      specializations: null == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<SpecializationModel>,
      verificationRules: null == verificationRules
          ? _value.verificationRules
          : verificationRules // ignore: cast_nullable_to_non_nullable
              as ProfileVerificationRules,
      completionStatus: freezed == completionStatus
          ? _value.completionStatus
          : completionStatus // ignore: cast_nullable_to_non_nullable
              as ProfileCompletionStatus?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileVerificationRulesCopyWith<$Res> get verificationRules {
    return $ProfileVerificationRulesCopyWith<$Res>(_value.verificationRules,
        (value) {
      return _then(_value.copyWith(verificationRules: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCompletionStatusCopyWith<$Res>? get completionStatus {
    if (_value.completionStatus == null) {
      return null;
    }

    return $ProfileCompletionStatusCopyWith<$Res>(_value.completionStatus!,
        (value) {
      return _then(_value.copyWith(completionStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileDataResponseImplCopyWith<$Res>
    implements $ProfileDataResponseCopyWith<$Res> {
  factory _$$ProfileDataResponseImplCopyWith(_$ProfileDataResponseImpl value,
          $Res Function(_$ProfileDataResponseImpl) then) =
      __$$ProfileDataResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<QualificationModel> qualifications,
      List<UniversityModel> universities,
      List<ProvinceModel> provinces,
      List<WorkplaceModel> workplaces,
      List<SpecializationModel> specializations,
      ProfileVerificationRules verificationRules,
      ProfileCompletionStatus? completionStatus});

  @override
  $ProfileVerificationRulesCopyWith<$Res> get verificationRules;
  @override
  $ProfileCompletionStatusCopyWith<$Res>? get completionStatus;
}

/// @nodoc
class __$$ProfileDataResponseImplCopyWithImpl<$Res>
    extends _$ProfileDataResponseCopyWithImpl<$Res, _$ProfileDataResponseImpl>
    implements _$$ProfileDataResponseImplCopyWith<$Res> {
  __$$ProfileDataResponseImplCopyWithImpl(_$ProfileDataResponseImpl _value,
      $Res Function(_$ProfileDataResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? qualifications = null,
    Object? universities = null,
    Object? provinces = null,
    Object? workplaces = null,
    Object? specializations = null,
    Object? verificationRules = null,
    Object? completionStatus = freezed,
  }) {
    return _then(_$ProfileDataResponseImpl(
      qualifications: null == qualifications
          ? _value._qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<QualificationModel>,
      universities: null == universities
          ? _value._universities
          : universities // ignore: cast_nullable_to_non_nullable
              as List<UniversityModel>,
      provinces: null == provinces
          ? _value._provinces
          : provinces // ignore: cast_nullable_to_non_nullable
              as List<ProvinceModel>,
      workplaces: null == workplaces
          ? _value._workplaces
          : workplaces // ignore: cast_nullable_to_non_nullable
              as List<WorkplaceModel>,
      specializations: null == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<SpecializationModel>,
      verificationRules: null == verificationRules
          ? _value.verificationRules
          : verificationRules // ignore: cast_nullable_to_non_nullable
              as ProfileVerificationRules,
      completionStatus: freezed == completionStatus
          ? _value.completionStatus
          : completionStatus // ignore: cast_nullable_to_non_nullable
              as ProfileCompletionStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileDataResponseImpl implements _ProfileDataResponse {
  const _$ProfileDataResponseImpl(
      {required final List<QualificationModel> qualifications,
      required final List<UniversityModel> universities,
      required final List<ProvinceModel> provinces,
      required final List<WorkplaceModel> workplaces,
      required final List<SpecializationModel> specializations,
      required this.verificationRules,
      this.completionStatus})
      : _qualifications = qualifications,
        _universities = universities,
        _provinces = provinces,
        _workplaces = workplaces,
        _specializations = specializations;

  factory _$ProfileDataResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileDataResponseImplFromJson(json);

  final List<QualificationModel> _qualifications;
  @override
  List<QualificationModel> get qualifications {
    if (_qualifications is EqualUnmodifiableListView) return _qualifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_qualifications);
  }

  final List<UniversityModel> _universities;
  @override
  List<UniversityModel> get universities {
    if (_universities is EqualUnmodifiableListView) return _universities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_universities);
  }

  final List<ProvinceModel> _provinces;
  @override
  List<ProvinceModel> get provinces {
    if (_provinces is EqualUnmodifiableListView) return _provinces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_provinces);
  }

  final List<WorkplaceModel> _workplaces;
  @override
  List<WorkplaceModel> get workplaces {
    if (_workplaces is EqualUnmodifiableListView) return _workplaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workplaces);
  }

  final List<SpecializationModel> _specializations;
  @override
  List<SpecializationModel> get specializations {
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specializations);
  }

  @override
  final ProfileVerificationRules verificationRules;
  @override
  final ProfileCompletionStatus? completionStatus;

  @override
  String toString() {
    return 'ProfileDataResponse(qualifications: $qualifications, universities: $universities, provinces: $provinces, workplaces: $workplaces, specializations: $specializations, verificationRules: $verificationRules, completionStatus: $completionStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileDataResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._qualifications, _qualifications) &&
            const DeepCollectionEquality()
                .equals(other._universities, _universities) &&
            const DeepCollectionEquality()
                .equals(other._provinces, _provinces) &&
            const DeepCollectionEquality()
                .equals(other._workplaces, _workplaces) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            (identical(other.verificationRules, verificationRules) ||
                other.verificationRules == verificationRules) &&
            (identical(other.completionStatus, completionStatus) ||
                other.completionStatus == completionStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_qualifications),
      const DeepCollectionEquality().hash(_universities),
      const DeepCollectionEquality().hash(_provinces),
      const DeepCollectionEquality().hash(_workplaces),
      const DeepCollectionEquality().hash(_specializations),
      verificationRules,
      completionStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileDataResponseImplCopyWith<_$ProfileDataResponseImpl> get copyWith =>
      __$$ProfileDataResponseImplCopyWithImpl<_$ProfileDataResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileDataResponseImplToJson(
      this,
    );
  }
}

abstract class _ProfileDataResponse implements ProfileDataResponse {
  const factory _ProfileDataResponse(
          {required final List<QualificationModel> qualifications,
          required final List<UniversityModel> universities,
          required final List<ProvinceModel> provinces,
          required final List<WorkplaceModel> workplaces,
          required final List<SpecializationModel> specializations,
          required final ProfileVerificationRules verificationRules,
          final ProfileCompletionStatus? completionStatus}) =
      _$ProfileDataResponseImpl;

  factory _ProfileDataResponse.fromJson(Map<String, dynamic> json) =
      _$ProfileDataResponseImpl.fromJson;

  @override
  List<QualificationModel> get qualifications;
  @override
  List<UniversityModel> get universities;
  @override
  List<ProvinceModel> get provinces;
  @override
  List<WorkplaceModel> get workplaces;
  @override
  List<SpecializationModel> get specializations;
  @override
  ProfileVerificationRules get verificationRules;
  @override
  ProfileCompletionStatus? get completionStatus;
  @override
  @JsonKey(ignore: true)
  _$$ProfileDataResponseImplCopyWith<_$ProfileDataResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileUpdateResponse _$ProfileUpdateResponseFromJson(
    Map<String, dynamic> json) {
  return _ProfileUpdateResponse.fromJson(json);
}

/// @nodoc
mixin _$ProfileUpdateResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  ProfileCompletionStatus? get completionStatus =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get errors => throw _privateConstructorUsedError;
  String? get reviewRequestId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileUpdateResponseCopyWith<ProfileUpdateResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUpdateResponseCopyWith<$Res> {
  factory $ProfileUpdateResponseCopyWith(ProfileUpdateResponse value,
          $Res Function(ProfileUpdateResponse) then) =
      _$ProfileUpdateResponseCopyWithImpl<$Res, ProfileUpdateResponse>;
  @useResult
  $Res call(
      {bool success,
      String message,
      ProfileCompletionStatus? completionStatus,
      Map<String, dynamic>? errors,
      String? reviewRequestId});

  $ProfileCompletionStatusCopyWith<$Res>? get completionStatus;
}

/// @nodoc
class _$ProfileUpdateResponseCopyWithImpl<$Res,
        $Val extends ProfileUpdateResponse>
    implements $ProfileUpdateResponseCopyWith<$Res> {
  _$ProfileUpdateResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? completionStatus = freezed,
    Object? errors = freezed,
    Object? reviewRequestId = freezed,
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
      completionStatus: freezed == completionStatus
          ? _value.completionStatus
          : completionStatus // ignore: cast_nullable_to_non_nullable
              as ProfileCompletionStatus?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      reviewRequestId: freezed == reviewRequestId
          ? _value.reviewRequestId
          : reviewRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCompletionStatusCopyWith<$Res>? get completionStatus {
    if (_value.completionStatus == null) {
      return null;
    }

    return $ProfileCompletionStatusCopyWith<$Res>(_value.completionStatus!,
        (value) {
      return _then(_value.copyWith(completionStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileUpdateResponseImplCopyWith<$Res>
    implements $ProfileUpdateResponseCopyWith<$Res> {
  factory _$$ProfileUpdateResponseImplCopyWith(
          _$ProfileUpdateResponseImpl value,
          $Res Function(_$ProfileUpdateResponseImpl) then) =
      __$$ProfileUpdateResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      ProfileCompletionStatus? completionStatus,
      Map<String, dynamic>? errors,
      String? reviewRequestId});

  @override
  $ProfileCompletionStatusCopyWith<$Res>? get completionStatus;
}

/// @nodoc
class __$$ProfileUpdateResponseImplCopyWithImpl<$Res>
    extends _$ProfileUpdateResponseCopyWithImpl<$Res,
        _$ProfileUpdateResponseImpl>
    implements _$$ProfileUpdateResponseImplCopyWith<$Res> {
  __$$ProfileUpdateResponseImplCopyWithImpl(_$ProfileUpdateResponseImpl _value,
      $Res Function(_$ProfileUpdateResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? completionStatus = freezed,
    Object? errors = freezed,
    Object? reviewRequestId = freezed,
  }) {
    return _then(_$ProfileUpdateResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      completionStatus: freezed == completionStatus
          ? _value.completionStatus
          : completionStatus // ignore: cast_nullable_to_non_nullable
              as ProfileCompletionStatus?,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      reviewRequestId: freezed == reviewRequestId
          ? _value.reviewRequestId
          : reviewRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileUpdateResponseImpl implements _ProfileUpdateResponse {
  const _$ProfileUpdateResponseImpl(
      {required this.success,
      required this.message,
      this.completionStatus,
      final Map<String, dynamic>? errors,
      this.reviewRequestId})
      : _errors = errors;

  factory _$ProfileUpdateResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileUpdateResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final ProfileCompletionStatus? completionStatus;
  final Map<String, dynamic>? _errors;
  @override
  Map<String, dynamic>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? reviewRequestId;

  @override
  String toString() {
    return 'ProfileUpdateResponse(success: $success, message: $message, completionStatus: $completionStatus, errors: $errors, reviewRequestId: $reviewRequestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileUpdateResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.completionStatus, completionStatus) ||
                other.completionStatus == completionStatus) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.reviewRequestId, reviewRequestId) ||
                other.reviewRequestId == reviewRequestId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      completionStatus,
      const DeepCollectionEquality().hash(_errors),
      reviewRequestId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileUpdateResponseImplCopyWith<_$ProfileUpdateResponseImpl>
      get copyWith => __$$ProfileUpdateResponseImplCopyWithImpl<
          _$ProfileUpdateResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileUpdateResponseImplToJson(
      this,
    );
  }
}

abstract class _ProfileUpdateResponse implements ProfileUpdateResponse {
  const factory _ProfileUpdateResponse(
      {required final bool success,
      required final String message,
      final ProfileCompletionStatus? completionStatus,
      final Map<String, dynamic>? errors,
      final String? reviewRequestId}) = _$ProfileUpdateResponseImpl;

  factory _ProfileUpdateResponse.fromJson(Map<String, dynamic> json) =
      _$ProfileUpdateResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  ProfileCompletionStatus? get completionStatus;
  @override
  Map<String, dynamic>? get errors;
  @override
  String? get reviewRequestId;
  @override
  @JsonKey(ignore: true)
  _$$ProfileUpdateResponseImplCopyWith<_$ProfileUpdateResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
