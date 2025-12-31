// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaker_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpeakerModel _$SpeakerModelFromJson(Map<String, dynamic> json) {
  return _SpeakerModel.fromJson(json);
}

/// @nodoc
mixin _$SpeakerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'photoUrl')
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get organization => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'eventsCount')
  int? get eventsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sessionsCount')
  int? get sessionsCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpeakerModelCopyWith<SpeakerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeakerModelCopyWith<$Res> {
  factory $SpeakerModelCopyWith(
          SpeakerModel value, $Res Function(SpeakerModel) then) =
      _$SpeakerModelCopyWithImpl<$Res, SpeakerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? title,
      String? bio,
      @JsonKey(name: 'photoUrl') String? photoUrl,
      String? email,
      String? phone,
      String? organization,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: '_count') Map<String, dynamic>? count,
      @JsonKey(name: 'eventsCount') int? eventsCount,
      @JsonKey(name: 'sessionsCount') int? sessionsCount});
}

/// @nodoc
class _$SpeakerModelCopyWithImpl<$Res, $Val extends SpeakerModel>
    implements $SpeakerModelCopyWith<$Res> {
  _$SpeakerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? title = freezed,
    Object? bio = freezed,
    Object? photoUrl = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? organization = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? count = freezed,
    Object? eventsCount = freezed,
    Object? sessionsCount = freezed,
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
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      eventsCount: freezed == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionsCount: freezed == sessionsCount
          ? _value.sessionsCount
          : sessionsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpeakerModelImplCopyWith<$Res>
    implements $SpeakerModelCopyWith<$Res> {
  factory _$$SpeakerModelImplCopyWith(
          _$SpeakerModelImpl value, $Res Function(_$SpeakerModelImpl) then) =
      __$$SpeakerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? title,
      String? bio,
      @JsonKey(name: 'photoUrl') String? photoUrl,
      String? email,
      String? phone,
      String? organization,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: '_count') Map<String, dynamic>? count,
      @JsonKey(name: 'eventsCount') int? eventsCount,
      @JsonKey(name: 'sessionsCount') int? sessionsCount});
}

/// @nodoc
class __$$SpeakerModelImplCopyWithImpl<$Res>
    extends _$SpeakerModelCopyWithImpl<$Res, _$SpeakerModelImpl>
    implements _$$SpeakerModelImplCopyWith<$Res> {
  __$$SpeakerModelImplCopyWithImpl(
      _$SpeakerModelImpl _value, $Res Function(_$SpeakerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? title = freezed,
    Object? bio = freezed,
    Object? photoUrl = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? organization = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? count = freezed,
    Object? eventsCount = freezed,
    Object? sessionsCount = freezed,
  }) {
    return _then(_$SpeakerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: freezed == count
          ? _value._count
          : count // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      eventsCount: freezed == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int?,
      sessionsCount: freezed == sessionsCount
          ? _value.sessionsCount
          : sessionsCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeakerModelImpl implements _SpeakerModel {
  const _$SpeakerModelImpl(
      {required this.id,
      required this.name,
      this.title,
      this.bio,
      @JsonKey(name: 'photoUrl') this.photoUrl,
      this.email,
      this.phone,
      this.organization,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      @JsonKey(name: '_count') final Map<String, dynamic>? count,
      @JsonKey(name: 'eventsCount') this.eventsCount,
      @JsonKey(name: 'sessionsCount') this.sessionsCount})
      : _count = count;

  factory _$SpeakerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeakerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? title;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? organization;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  final Map<String, dynamic>? _count;
  @override
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count {
    final value = _count;
    if (value == null) return null;
    if (_count is EqualUnmodifiableMapView) return _count;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'eventsCount')
  final int? eventsCount;
  @override
  @JsonKey(name: 'sessionsCount')
  final int? sessionsCount;

  @override
  String toString() {
    return 'SpeakerModel(id: $id, name: $name, title: $title, bio: $bio, photoUrl: $photoUrl, email: $email, phone: $phone, organization: $organization, createdAt: $createdAt, updatedAt: $updatedAt, count: $count, eventsCount: $eventsCount, sessionsCount: $sessionsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeakerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._count, _count) &&
            (identical(other.eventsCount, eventsCount) ||
                other.eventsCount == eventsCount) &&
            (identical(other.sessionsCount, sessionsCount) ||
                other.sessionsCount == sessionsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      title,
      bio,
      photoUrl,
      email,
      phone,
      organization,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_count),
      eventsCount,
      sessionsCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeakerModelImplCopyWith<_$SpeakerModelImpl> get copyWith =>
      __$$SpeakerModelImplCopyWithImpl<_$SpeakerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeakerModelImplToJson(
      this,
    );
  }
}

abstract class _SpeakerModel implements SpeakerModel {
  const factory _SpeakerModel(
          {required final String id,
          required final String name,
          final String? title,
          final String? bio,
          @JsonKey(name: 'photoUrl') final String? photoUrl,
          final String? email,
          final String? phone,
          final String? organization,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
          @JsonKey(name: '_count') final Map<String, dynamic>? count,
          @JsonKey(name: 'eventsCount') final int? eventsCount,
          @JsonKey(name: 'sessionsCount') final int? sessionsCount}) =
      _$SpeakerModelImpl;

  factory _SpeakerModel.fromJson(Map<String, dynamic> json) =
      _$SpeakerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get title;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'photoUrl')
  String? get photoUrl;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get organization;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override
  @JsonKey(name: '_count')
  Map<String, dynamic>? get count;
  @override
  @JsonKey(name: 'eventsCount')
  int? get eventsCount;
  @override
  @JsonKey(name: 'sessionsCount')
  int? get sessionsCount;
  @override
  @JsonKey(ignore: true)
  _$$SpeakerModelImplCopyWith<_$SpeakerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
