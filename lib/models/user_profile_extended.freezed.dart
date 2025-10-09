// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_extended.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileExtended _$UserProfileExtendedFromJson(Map<String, dynamic> json) {
  return _UserProfileExtended.fromJson(json);
}

/// @nodoc
mixin _$UserProfileExtended {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError; // Personal Data
  String? get fullNameAr => throw _privateConstructorUsedError;
  String? get fullNameEn => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get governorateId =>
      throw _privateConstructorUsedError; // Academic Data
  String? get qualificationId => throw _privateConstructorUsedError;
  int? get graduationYear => throw _privateConstructorUsedError;
  String? get university => throw _privateConstructorUsedError;
  String? get workplace => throw _privateConstructorUsedError; // Profile Status
  ProfileStatus get status => throw _privateConstructorUsedError;
  String? get rejectionReason =>
      throw _privateConstructorUsedError; // Profile Picture
  String? get profilePictureUrl => throw _privateConstructorUsedError;
  String? get profilePictureFileId =>
      throw _privateConstructorUsedError; // Document URLs mapped by field name
  Map<String, String> get documentUrls =>
      throw _privateConstructorUsedError; // Document File IDs mapped by field name
  Map<String, String> get documentFileIds =>
      throw _privateConstructorUsedError; // Pending changes for approval tracking
  Map<String, dynamic> get pendingChanges =>
      throw _privateConstructorUsedError; // Timestamps
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileExtendedCopyWith<UserProfileExtended> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileExtendedCopyWith<$Res> {
  factory $UserProfileExtendedCopyWith(
          UserProfileExtended value, $Res Function(UserProfileExtended) then) =
      _$UserProfileExtendedCopyWithImpl<$Res, UserProfileExtended>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? fullNameAr,
      String? fullNameEn,
      String? email,
      DateTime? birthDate,
      String? governorateId,
      String? qualificationId,
      int? graduationYear,
      String? university,
      String? workplace,
      ProfileStatus status,
      String? rejectionReason,
      String? profilePictureUrl,
      String? profilePictureFileId,
      Map<String, String> documentUrls,
      Map<String, String> documentFileIds,
      Map<String, dynamic> pendingChanges,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? verifiedAt});
}

/// @nodoc
class _$UserProfileExtendedCopyWithImpl<$Res, $Val extends UserProfileExtended>
    implements $UserProfileExtendedCopyWith<$Res> {
  _$UserProfileExtendedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullNameAr = freezed,
    Object? fullNameEn = freezed,
    Object? email = freezed,
    Object? birthDate = freezed,
    Object? governorateId = freezed,
    Object? qualificationId = freezed,
    Object? graduationYear = freezed,
    Object? university = freezed,
    Object? workplace = freezed,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? profilePictureUrl = freezed,
    Object? profilePictureFileId = freezed,
    Object? documentUrls = null,
    Object? documentFileIds = null,
    Object? pendingChanges = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? verifiedAt = freezed,
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
      fullNameAr: freezed == fullNameAr
          ? _value.fullNameAr
          : fullNameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      fullNameEn: freezed == fullNameEn
          ? _value.fullNameEn
          : fullNameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      governorateId: freezed == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as String?,
      qualificationId: freezed == qualificationId
          ? _value.qualificationId
          : qualificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      graduationYear: freezed == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      university: freezed == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String?,
      workplace: freezed == workplace
          ? _value.workplace
          : workplace // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProfileStatus,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureFileId: freezed == profilePictureFileId
          ? _value.profilePictureFileId
          : profilePictureFileId // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrls: null == documentUrls
          ? _value.documentUrls
          : documentUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      documentFileIds: null == documentFileIds
          ? _value.documentFileIds
          : documentFileIds // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      pendingChanges: null == pendingChanges
          ? _value.pendingChanges
          : pendingChanges // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileExtendedImplCopyWith<$Res>
    implements $UserProfileExtendedCopyWith<$Res> {
  factory _$$UserProfileExtendedImplCopyWith(_$UserProfileExtendedImpl value,
          $Res Function(_$UserProfileExtendedImpl) then) =
      __$$UserProfileExtendedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? fullNameAr,
      String? fullNameEn,
      String? email,
      DateTime? birthDate,
      String? governorateId,
      String? qualificationId,
      int? graduationYear,
      String? university,
      String? workplace,
      ProfileStatus status,
      String? rejectionReason,
      String? profilePictureUrl,
      String? profilePictureFileId,
      Map<String, String> documentUrls,
      Map<String, String> documentFileIds,
      Map<String, dynamic> pendingChanges,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? verifiedAt});
}

/// @nodoc
class __$$UserProfileExtendedImplCopyWithImpl<$Res>
    extends _$UserProfileExtendedCopyWithImpl<$Res, _$UserProfileExtendedImpl>
    implements _$$UserProfileExtendedImplCopyWith<$Res> {
  __$$UserProfileExtendedImplCopyWithImpl(_$UserProfileExtendedImpl _value,
      $Res Function(_$UserProfileExtendedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullNameAr = freezed,
    Object? fullNameEn = freezed,
    Object? email = freezed,
    Object? birthDate = freezed,
    Object? governorateId = freezed,
    Object? qualificationId = freezed,
    Object? graduationYear = freezed,
    Object? university = freezed,
    Object? workplace = freezed,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? profilePictureUrl = freezed,
    Object? profilePictureFileId = freezed,
    Object? documentUrls = null,
    Object? documentFileIds = null,
    Object? pendingChanges = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_$UserProfileExtendedImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameAr: freezed == fullNameAr
          ? _value.fullNameAr
          : fullNameAr // ignore: cast_nullable_to_non_nullable
              as String?,
      fullNameEn: freezed == fullNameEn
          ? _value.fullNameEn
          : fullNameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      governorateId: freezed == governorateId
          ? _value.governorateId
          : governorateId // ignore: cast_nullable_to_non_nullable
              as String?,
      qualificationId: freezed == qualificationId
          ? _value.qualificationId
          : qualificationId // ignore: cast_nullable_to_non_nullable
              as String?,
      graduationYear: freezed == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int?,
      university: freezed == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String?,
      workplace: freezed == workplace
          ? _value.workplace
          : workplace // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProfileStatus,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureFileId: freezed == profilePictureFileId
          ? _value.profilePictureFileId
          : profilePictureFileId // ignore: cast_nullable_to_non_nullable
              as String?,
      documentUrls: null == documentUrls
          ? _value._documentUrls
          : documentUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      documentFileIds: null == documentFileIds
          ? _value._documentFileIds
          : documentFileIds // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      pendingChanges: null == pendingChanges
          ? _value._pendingChanges
          : pendingChanges // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileExtendedImpl implements _UserProfileExtended {
  const _$UserProfileExtendedImpl(
      {required this.id,
      required this.userId,
      this.fullNameAr,
      this.fullNameEn,
      this.email,
      this.birthDate,
      this.governorateId,
      this.qualificationId,
      this.graduationYear,
      this.university,
      this.workplace,
      this.status = ProfileStatus.unverified,
      this.rejectionReason,
      this.profilePictureUrl,
      this.profilePictureFileId,
      final Map<String, String> documentUrls = const {},
      final Map<String, String> documentFileIds = const {},
      final Map<String, dynamic> pendingChanges = const {},
      this.createdAt,
      this.updatedAt,
      this.verifiedAt})
      : _documentUrls = documentUrls,
        _documentFileIds = documentFileIds,
        _pendingChanges = pendingChanges;

  factory _$UserProfileExtendedImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileExtendedImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
// Personal Data
  @override
  final String? fullNameAr;
  @override
  final String? fullNameEn;
  @override
  final String? email;
  @override
  final DateTime? birthDate;
  @override
  final String? governorateId;
// Academic Data
  @override
  final String? qualificationId;
  @override
  final int? graduationYear;
  @override
  final String? university;
  @override
  final String? workplace;
// Profile Status
  @override
  @JsonKey()
  final ProfileStatus status;
  @override
  final String? rejectionReason;
// Profile Picture
  @override
  final String? profilePictureUrl;
  @override
  final String? profilePictureFileId;
// Document URLs mapped by field name
  final Map<String, String> _documentUrls;
// Document URLs mapped by field name
  @override
  @JsonKey()
  Map<String, String> get documentUrls {
    if (_documentUrls is EqualUnmodifiableMapView) return _documentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_documentUrls);
  }

// Document File IDs mapped by field name
  final Map<String, String> _documentFileIds;
// Document File IDs mapped by field name
  @override
  @JsonKey()
  Map<String, String> get documentFileIds {
    if (_documentFileIds is EqualUnmodifiableMapView) return _documentFileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_documentFileIds);
  }

// Pending changes for approval tracking
  final Map<String, dynamic> _pendingChanges;
// Pending changes for approval tracking
  @override
  @JsonKey()
  Map<String, dynamic> get pendingChanges {
    if (_pendingChanges is EqualUnmodifiableMapView) return _pendingChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pendingChanges);
  }

// Timestamps
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'UserProfileExtended(id: $id, userId: $userId, fullNameAr: $fullNameAr, fullNameEn: $fullNameEn, email: $email, birthDate: $birthDate, governorateId: $governorateId, qualificationId: $qualificationId, graduationYear: $graduationYear, university: $university, workplace: $workplace, status: $status, rejectionReason: $rejectionReason, profilePictureUrl: $profilePictureUrl, profilePictureFileId: $profilePictureFileId, documentUrls: $documentUrls, documentFileIds: $documentFileIds, pendingChanges: $pendingChanges, createdAt: $createdAt, updatedAt: $updatedAt, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileExtendedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullNameAr, fullNameAr) ||
                other.fullNameAr == fullNameAr) &&
            (identical(other.fullNameEn, fullNameEn) ||
                other.fullNameEn == fullNameEn) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.governorateId, governorateId) ||
                other.governorateId == governorateId) &&
            (identical(other.qualificationId, qualificationId) ||
                other.qualificationId == qualificationId) &&
            (identical(other.graduationYear, graduationYear) ||
                other.graduationYear == graduationYear) &&
            (identical(other.university, university) ||
                other.university == university) &&
            (identical(other.workplace, workplace) ||
                other.workplace == workplace) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.profilePictureFileId, profilePictureFileId) ||
                other.profilePictureFileId == profilePictureFileId) &&
            const DeepCollectionEquality()
                .equals(other._documentUrls, _documentUrls) &&
            const DeepCollectionEquality()
                .equals(other._documentFileIds, _documentFileIds) &&
            const DeepCollectionEquality()
                .equals(other._pendingChanges, _pendingChanges) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        fullNameAr,
        fullNameEn,
        email,
        birthDate,
        governorateId,
        qualificationId,
        graduationYear,
        university,
        workplace,
        status,
        rejectionReason,
        profilePictureUrl,
        profilePictureFileId,
        const DeepCollectionEquality().hash(_documentUrls),
        const DeepCollectionEquality().hash(_documentFileIds),
        const DeepCollectionEquality().hash(_pendingChanges),
        createdAt,
        updatedAt,
        verifiedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileExtendedImplCopyWith<_$UserProfileExtendedImpl> get copyWith =>
      __$$UserProfileExtendedImplCopyWithImpl<_$UserProfileExtendedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileExtendedImplToJson(
      this,
    );
  }
}

abstract class _UserProfileExtended implements UserProfileExtended {
  const factory _UserProfileExtended(
      {required final String id,
      required final String userId,
      final String? fullNameAr,
      final String? fullNameEn,
      final String? email,
      final DateTime? birthDate,
      final String? governorateId,
      final String? qualificationId,
      final int? graduationYear,
      final String? university,
      final String? workplace,
      final ProfileStatus status,
      final String? rejectionReason,
      final String? profilePictureUrl,
      final String? profilePictureFileId,
      final Map<String, String> documentUrls,
      final Map<String, String> documentFileIds,
      final Map<String, dynamic> pendingChanges,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? verifiedAt}) = _$UserProfileExtendedImpl;

  factory _UserProfileExtended.fromJson(Map<String, dynamic> json) =
      _$UserProfileExtendedImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override // Personal Data
  String? get fullNameAr;
  @override
  String? get fullNameEn;
  @override
  String? get email;
  @override
  DateTime? get birthDate;
  @override
  String? get governorateId;
  @override // Academic Data
  String? get qualificationId;
  @override
  int? get graduationYear;
  @override
  String? get university;
  @override
  String? get workplace;
  @override // Profile Status
  ProfileStatus get status;
  @override
  String? get rejectionReason;
  @override // Profile Picture
  String? get profilePictureUrl;
  @override
  String? get profilePictureFileId;
  @override // Document URLs mapped by field name
  Map<String, String> get documentUrls;
  @override // Document File IDs mapped by field name
  Map<String, String> get documentFileIds;
  @override // Pending changes for approval tracking
  Map<String, dynamic> get pendingChanges;
  @override // Timestamps
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get verifiedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileExtendedImplCopyWith<_$UserProfileExtendedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
