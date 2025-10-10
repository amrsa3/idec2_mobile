// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name_ar')
  String get fullNameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name_en')
  String? get fullNameEn => throw _privateConstructorUsedError;
  bool get phoneVerified => throw _privateConstructorUsedError;
  List<String> get roles => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get profilePictureUrl => throw _privateConstructorUsedError;
  String? get profilePicture => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  UserProfileModel? get profile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String id,
      String phone,
      String? email,
      String firstName,
      String lastName,
      @JsonKey(name: 'full_name_ar') String fullNameAr,
      @JsonKey(name: 'full_name_en') String? fullNameEn,
      bool phoneVerified,
      List<String> roles,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? profilePictureUrl,
      String? profilePicture,
      bool isVerified,
      bool isActive,
      bool isEmailVerified,
      UserProfileModel? profile});

  $UserProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? email = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? fullNameAr = null,
    Object? fullNameEn = freezed,
    Object? phoneVerified = null,
    Object? roles = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? profilePictureUrl = freezed,
    Object? profilePicture = freezed,
    Object? isVerified = null,
    Object? isActive = null,
    Object? isEmailVerified = null,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameAr: null == fullNameAr
          ? _value.fullNameAr
          : fullNameAr // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameEn: freezed == fullNameEn
          ? _value.fullNameEn
          : fullNameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String phone,
      String? email,
      String firstName,
      String lastName,
      @JsonKey(name: 'full_name_ar') String fullNameAr,
      @JsonKey(name: 'full_name_en') String? fullNameEn,
      bool phoneVerified,
      List<String> roles,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? profilePictureUrl,
      String? profilePicture,
      bool isVerified,
      bool isActive,
      bool isEmailVerified,
      UserProfileModel? profile});

  @override
  $UserProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? email = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? fullNameAr = null,
    Object? fullNameEn = freezed,
    Object? phoneVerified = null,
    Object? roles = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? profilePictureUrl = freezed,
    Object? profilePicture = freezed,
    Object? isVerified = null,
    Object? isActive = null,
    Object? isEmailVerified = null,
    Object? profile = freezed,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameAr: null == fullNameAr
          ? _value.fullNameAr
          : fullNameAr // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameEn: freezed == fullNameEn
          ? _value.fullNameEn
          : fullNameEn // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl with DiagnosticableTreeMixin implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.phone,
      this.email,
      this.firstName = '',
      this.lastName = '',
      @JsonKey(name: 'full_name_ar') this.fullNameAr = '',
      @JsonKey(name: 'full_name_en') this.fullNameEn,
      this.phoneVerified = false,
      final List<String> roles = const [],
      this.createdAt,
      this.updatedAt,
      this.profilePictureUrl,
      this.profilePicture,
      this.isVerified = true,
      this.isActive = true,
      this.isEmailVerified = false,
      this.profile})
      : _roles = roles;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String phone;
  @override
  final String? email;
  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;
  @override
  @JsonKey(name: 'full_name_ar')
  final String fullNameAr;
  @override
  @JsonKey(name: 'full_name_en')
  final String? fullNameEn;
  @override
  @JsonKey()
  final bool phoneVerified;
  final List<String> _roles;
  @override
  @JsonKey()
  List<String> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? profilePictureUrl;
  @override
  final String? profilePicture;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  final UserProfileModel? profile;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserModel(id: $id, phone: $phone, email: $email, firstName: $firstName, lastName: $lastName, fullNameAr: $fullNameAr, fullNameEn: $fullNameEn, phoneVerified: $phoneVerified, roles: $roles, createdAt: $createdAt, updatedAt: $updatedAt, profilePictureUrl: $profilePictureUrl, profilePicture: $profilePicture, isVerified: $isVerified, isActive: $isActive, isEmailVerified: $isEmailVerified, profile: $profile)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('firstName', firstName))
      ..add(DiagnosticsProperty('lastName', lastName))
      ..add(DiagnosticsProperty('fullNameAr', fullNameAr))
      ..add(DiagnosticsProperty('fullNameEn', fullNameEn))
      ..add(DiagnosticsProperty('phoneVerified', phoneVerified))
      ..add(DiagnosticsProperty('roles', roles))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('profilePictureUrl', profilePictureUrl))
      ..add(DiagnosticsProperty('profilePicture', profilePicture))
      ..add(DiagnosticsProperty('isVerified', isVerified))
      ..add(DiagnosticsProperty('isActive', isActive))
      ..add(DiagnosticsProperty('isEmailVerified', isEmailVerified))
      ..add(DiagnosticsProperty('profile', profile));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.fullNameAr, fullNameAr) ||
                other.fullNameAr == fullNameAr) &&
            (identical(other.fullNameEn, fullNameEn) ||
                other.fullNameEn == fullNameEn) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      phone,
      email,
      firstName,
      lastName,
      fullNameAr,
      fullNameEn,
      phoneVerified,
      const DeepCollectionEquality().hash(_roles),
      createdAt,
      updatedAt,
      profilePictureUrl,
      profilePicture,
      isVerified,
      isActive,
      isEmailVerified,
      profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String id,
      required final String phone,
      final String? email,
      final String firstName,
      final String lastName,
      @JsonKey(name: 'full_name_ar') final String fullNameAr,
      @JsonKey(name: 'full_name_en') final String? fullNameEn,
      final bool phoneVerified,
      final List<String> roles,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? profilePictureUrl,
      final String? profilePicture,
      final bool isVerified,
      final bool isActive,
      final bool isEmailVerified,
      final UserProfileModel? profile}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get phone;
  @override
  String? get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  @JsonKey(name: 'full_name_ar')
  String get fullNameAr;
  @override
  @JsonKey(name: 'full_name_en')
  String? get fullNameEn;
  @override
  bool get phoneVerified;
  @override
  List<String> get roles;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get profilePictureUrl;
  @override
  String? get profilePicture;
  @override
  bool get isVerified;
  @override
  bool get isActive;
  @override
  bool get isEmailVerified;
  @override
  UserProfileModel? get profile;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  String? get workPlace => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get whatsappNumber => throw _privateConstructorUsedError;
  String? get telegramNumber => throw _privateConstructorUsedError;
  String? get linkedinProfile => throw _privateConstructorUsedError;
  String? get facebookProfile => throw _privateConstructorUsedError;
  String? get instagramProfile => throw _privateConstructorUsedError;
  String? get twitterProfile => throw _privateConstructorUsedError;
  String? get websiteUrl => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get nationality => throw _privateConstructorUsedError;
  String? get passportNumber => throw _privateConstructorUsedError;
  String? get emergencyContactName => throw _privateConstructorUsedError;
  String? get emergencyContactPhone => throw _privateConstructorUsedError;
  String? get emergencyContactRelation => throw _privateConstructorUsedError;
  String? get dietaryRestrictions => throw _privateConstructorUsedError;
  String? get medicalConditions => throw _privateConstructorUsedError;
  String? get accommodationPreferences => throw _privateConstructorUsedError;
  String? get transportationNeeds => throw _privateConstructorUsedError;
  String? get languagePreference => throw _privateConstructorUsedError;
  bool? get marketingConsent => throw _privateConstructorUsedError;
  bool? get dataProcessingConsent => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
          UserProfileModel value, $Res Function(UserProfileModel) then) =
      _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? title,
      String? specialization,
      String? workPlace,
      String? country,
      String? city,
      String? address,
      String? phoneNumber,
      String? whatsappNumber,
      String? telegramNumber,
      String? linkedinProfile,
      String? facebookProfile,
      String? instagramProfile,
      String? twitterProfile,
      String? websiteUrl,
      String? bio,
      DateTime? dateOfBirth,
      String? gender,
      String? nationality,
      String? passportNumber,
      String? emergencyContactName,
      String? emergencyContactPhone,
      String? emergencyContactRelation,
      String? dietaryRestrictions,
      String? medicalConditions,
      String? accommodationPreferences,
      String? transportationNeeds,
      String? languagePreference,
      bool? marketingConsent,
      bool? dataProcessingConsent,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = freezed,
    Object? specialization = freezed,
    Object? workPlace = freezed,
    Object? country = freezed,
    Object? city = freezed,
    Object? address = freezed,
    Object? phoneNumber = freezed,
    Object? whatsappNumber = freezed,
    Object? telegramNumber = freezed,
    Object? linkedinProfile = freezed,
    Object? facebookProfile = freezed,
    Object? instagramProfile = freezed,
    Object? twitterProfile = freezed,
    Object? websiteUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? nationality = freezed,
    Object? passportNumber = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? emergencyContactRelation = freezed,
    Object? dietaryRestrictions = freezed,
    Object? medicalConditions = freezed,
    Object? accommodationPreferences = freezed,
    Object? transportationNeeds = freezed,
    Object? languagePreference = freezed,
    Object? marketingConsent = freezed,
    Object? dataProcessingConsent = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      workPlace: freezed == workPlace
          ? _value.workPlace
          : workPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNumber: freezed == whatsappNumber
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      telegramNumber: freezed == telegramNumber
          ? _value.telegramNumber
          : telegramNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinProfile: freezed == linkedinProfile
          ? _value.linkedinProfile
          : linkedinProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookProfile: freezed == facebookProfile
          ? _value.facebookProfile
          : facebookProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramProfile: freezed == instagramProfile
          ? _value.instagramProfile
          : instagramProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      twitterProfile: freezed == twitterProfile
          ? _value.twitterProfile
          : twitterProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      passportNumber: freezed == passportNumber
          ? _value.passportNumber
          : passportNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactRelation: freezed == emergencyContactRelation
          ? _value.emergencyContactRelation
          : emergencyContactRelation // ignore: cast_nullable_to_non_nullable
              as String?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as String?,
      medicalConditions: freezed == medicalConditions
          ? _value.medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      accommodationPreferences: freezed == accommodationPreferences
          ? _value.accommodationPreferences
          : accommodationPreferences // ignore: cast_nullable_to_non_nullable
              as String?,
      transportationNeeds: freezed == transportationNeeds
          ? _value.transportationNeeds
          : transportationNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
      languagePreference: freezed == languagePreference
          ? _value.languagePreference
          : languagePreference // ignore: cast_nullable_to_non_nullable
              as String?,
      marketingConsent: freezed == marketingConsent
          ? _value.marketingConsent
          : marketingConsent // ignore: cast_nullable_to_non_nullable
              as bool?,
      dataProcessingConsent: freezed == dataProcessingConsent
          ? _value.dataProcessingConsent
          : dataProcessingConsent // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(_$UserProfileModelImpl value,
          $Res Function(_$UserProfileModelImpl) then) =
      __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? title,
      String? specialization,
      String? workPlace,
      String? country,
      String? city,
      String? address,
      String? phoneNumber,
      String? whatsappNumber,
      String? telegramNumber,
      String? linkedinProfile,
      String? facebookProfile,
      String? instagramProfile,
      String? twitterProfile,
      String? websiteUrl,
      String? bio,
      DateTime? dateOfBirth,
      String? gender,
      String? nationality,
      String? passportNumber,
      String? emergencyContactName,
      String? emergencyContactPhone,
      String? emergencyContactRelation,
      String? dietaryRestrictions,
      String? medicalConditions,
      String? accommodationPreferences,
      String? transportationNeeds,
      String? languagePreference,
      bool? marketingConsent,
      bool? dataProcessingConsent,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(_$UserProfileModelImpl _value,
      $Res Function(_$UserProfileModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = freezed,
    Object? specialization = freezed,
    Object? workPlace = freezed,
    Object? country = freezed,
    Object? city = freezed,
    Object? address = freezed,
    Object? phoneNumber = freezed,
    Object? whatsappNumber = freezed,
    Object? telegramNumber = freezed,
    Object? linkedinProfile = freezed,
    Object? facebookProfile = freezed,
    Object? instagramProfile = freezed,
    Object? twitterProfile = freezed,
    Object? websiteUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? nationality = freezed,
    Object? passportNumber = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? emergencyContactRelation = freezed,
    Object? dietaryRestrictions = freezed,
    Object? medicalConditions = freezed,
    Object? accommodationPreferences = freezed,
    Object? transportationNeeds = freezed,
    Object? languagePreference = freezed,
    Object? marketingConsent = freezed,
    Object? dataProcessingConsent = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      workPlace: freezed == workPlace
          ? _value.workPlace
          : workPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNumber: freezed == whatsappNumber
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      telegramNumber: freezed == telegramNumber
          ? _value.telegramNumber
          : telegramNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinProfile: freezed == linkedinProfile
          ? _value.linkedinProfile
          : linkedinProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookProfile: freezed == facebookProfile
          ? _value.facebookProfile
          : facebookProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramProfile: freezed == instagramProfile
          ? _value.instagramProfile
          : instagramProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      twitterProfile: freezed == twitterProfile
          ? _value.twitterProfile
          : twitterProfile // ignore: cast_nullable_to_non_nullable
              as String?,
      websiteUrl: freezed == websiteUrl
          ? _value.websiteUrl
          : websiteUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      nationality: freezed == nationality
          ? _value.nationality
          : nationality // ignore: cast_nullable_to_non_nullable
              as String?,
      passportNumber: freezed == passportNumber
          ? _value.passportNumber
          : passportNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactRelation: freezed == emergencyContactRelation
          ? _value.emergencyContactRelation
          : emergencyContactRelation // ignore: cast_nullable_to_non_nullable
              as String?,
      dietaryRestrictions: freezed == dietaryRestrictions
          ? _value.dietaryRestrictions
          : dietaryRestrictions // ignore: cast_nullable_to_non_nullable
              as String?,
      medicalConditions: freezed == medicalConditions
          ? _value.medicalConditions
          : medicalConditions // ignore: cast_nullable_to_non_nullable
              as String?,
      accommodationPreferences: freezed == accommodationPreferences
          ? _value.accommodationPreferences
          : accommodationPreferences // ignore: cast_nullable_to_non_nullable
              as String?,
      transportationNeeds: freezed == transportationNeeds
          ? _value.transportationNeeds
          : transportationNeeds // ignore: cast_nullable_to_non_nullable
              as String?,
      languagePreference: freezed == languagePreference
          ? _value.languagePreference
          : languagePreference // ignore: cast_nullable_to_non_nullable
              as String?,
      marketingConsent: freezed == marketingConsent
          ? _value.marketingConsent
          : marketingConsent // ignore: cast_nullable_to_non_nullable
              as bool?,
      dataProcessingConsent: freezed == dataProcessingConsent
          ? _value.dataProcessingConsent
          : dataProcessingConsent // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl
    with DiagnosticableTreeMixin
    implements _UserProfileModel {
  const _$UserProfileModelImpl(
      {required this.id,
      required this.userId,
      this.title,
      this.specialization,
      this.workPlace,
      this.country,
      this.city,
      this.address,
      this.phoneNumber,
      this.whatsappNumber,
      this.telegramNumber,
      this.linkedinProfile,
      this.facebookProfile,
      this.instagramProfile,
      this.twitterProfile,
      this.websiteUrl,
      this.bio,
      this.dateOfBirth,
      this.gender,
      this.nationality,
      this.passportNumber,
      this.emergencyContactName,
      this.emergencyContactPhone,
      this.emergencyContactRelation,
      this.dietaryRestrictions,
      this.medicalConditions,
      this.accommodationPreferences,
      this.transportationNeeds,
      this.languagePreference,
      this.marketingConsent,
      this.dataProcessingConsent,
      required this.createdAt,
      this.updatedAt});

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? title;
  @override
  final String? specialization;
  @override
  final String? workPlace;
  @override
  final String? country;
  @override
  final String? city;
  @override
  final String? address;
  @override
  final String? phoneNumber;
  @override
  final String? whatsappNumber;
  @override
  final String? telegramNumber;
  @override
  final String? linkedinProfile;
  @override
  final String? facebookProfile;
  @override
  final String? instagramProfile;
  @override
  final String? twitterProfile;
  @override
  final String? websiteUrl;
  @override
  final String? bio;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  @override
  final String? nationality;
  @override
  final String? passportNumber;
  @override
  final String? emergencyContactName;
  @override
  final String? emergencyContactPhone;
  @override
  final String? emergencyContactRelation;
  @override
  final String? dietaryRestrictions;
  @override
  final String? medicalConditions;
  @override
  final String? accommodationPreferences;
  @override
  final String? transportationNeeds;
  @override
  final String? languagePreference;
  @override
  final bool? marketingConsent;
  @override
  final bool? dataProcessingConsent;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserProfileModel(id: $id, userId: $userId, title: $title, specialization: $specialization, workPlace: $workPlace, country: $country, city: $city, address: $address, phoneNumber: $phoneNumber, whatsappNumber: $whatsappNumber, telegramNumber: $telegramNumber, linkedinProfile: $linkedinProfile, facebookProfile: $facebookProfile, instagramProfile: $instagramProfile, twitterProfile: $twitterProfile, websiteUrl: $websiteUrl, bio: $bio, dateOfBirth: $dateOfBirth, gender: $gender, nationality: $nationality, passportNumber: $passportNumber, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, emergencyContactRelation: $emergencyContactRelation, dietaryRestrictions: $dietaryRestrictions, medicalConditions: $medicalConditions, accommodationPreferences: $accommodationPreferences, transportationNeeds: $transportationNeeds, languagePreference: $languagePreference, marketingConsent: $marketingConsent, dataProcessingConsent: $dataProcessingConsent, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserProfileModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('specialization', specialization))
      ..add(DiagnosticsProperty('workPlace', workPlace))
      ..add(DiagnosticsProperty('country', country))
      ..add(DiagnosticsProperty('city', city))
      ..add(DiagnosticsProperty('address', address))
      ..add(DiagnosticsProperty('phoneNumber', phoneNumber))
      ..add(DiagnosticsProperty('whatsappNumber', whatsappNumber))
      ..add(DiagnosticsProperty('telegramNumber', telegramNumber))
      ..add(DiagnosticsProperty('linkedinProfile', linkedinProfile))
      ..add(DiagnosticsProperty('facebookProfile', facebookProfile))
      ..add(DiagnosticsProperty('instagramProfile', instagramProfile))
      ..add(DiagnosticsProperty('twitterProfile', twitterProfile))
      ..add(DiagnosticsProperty('websiteUrl', websiteUrl))
      ..add(DiagnosticsProperty('bio', bio))
      ..add(DiagnosticsProperty('dateOfBirth', dateOfBirth))
      ..add(DiagnosticsProperty('gender', gender))
      ..add(DiagnosticsProperty('nationality', nationality))
      ..add(DiagnosticsProperty('passportNumber', passportNumber))
      ..add(DiagnosticsProperty('emergencyContactName', emergencyContactName))
      ..add(DiagnosticsProperty('emergencyContactPhone', emergencyContactPhone))
      ..add(DiagnosticsProperty(
          'emergencyContactRelation', emergencyContactRelation))
      ..add(DiagnosticsProperty('dietaryRestrictions', dietaryRestrictions))
      ..add(DiagnosticsProperty('medicalConditions', medicalConditions))
      ..add(DiagnosticsProperty(
          'accommodationPreferences', accommodationPreferences))
      ..add(DiagnosticsProperty('transportationNeeds', transportationNeeds))
      ..add(DiagnosticsProperty('languagePreference', languagePreference))
      ..add(DiagnosticsProperty('marketingConsent', marketingConsent))
      ..add(DiagnosticsProperty('dataProcessingConsent', dataProcessingConsent))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.workPlace, workPlace) ||
                other.workPlace == workPlace) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber) &&
            (identical(other.telegramNumber, telegramNumber) ||
                other.telegramNumber == telegramNumber) &&
            (identical(other.linkedinProfile, linkedinProfile) ||
                other.linkedinProfile == linkedinProfile) &&
            (identical(other.facebookProfile, facebookProfile) ||
                other.facebookProfile == facebookProfile) &&
            (identical(other.instagramProfile, instagramProfile) ||
                other.instagramProfile == instagramProfile) &&
            (identical(other.twitterProfile, twitterProfile) ||
                other.twitterProfile == twitterProfile) &&
            (identical(other.websiteUrl, websiteUrl) ||
                other.websiteUrl == websiteUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.nationality, nationality) ||
                other.nationality == nationality) &&
            (identical(other.passportNumber, passportNumber) ||
                other.passportNumber == passportNumber) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone) &&
            (identical(
                    other.emergencyContactRelation, emergencyContactRelation) ||
                other.emergencyContactRelation == emergencyContactRelation) &&
            (identical(other.dietaryRestrictions, dietaryRestrictions) ||
                other.dietaryRestrictions == dietaryRestrictions) &&
            (identical(other.medicalConditions, medicalConditions) ||
                other.medicalConditions == medicalConditions) &&
            (identical(
                    other.accommodationPreferences, accommodationPreferences) ||
                other.accommodationPreferences == accommodationPreferences) &&
            (identical(other.transportationNeeds, transportationNeeds) ||
                other.transportationNeeds == transportationNeeds) &&
            (identical(other.languagePreference, languagePreference) ||
                other.languagePreference == languagePreference) &&
            (identical(other.marketingConsent, marketingConsent) ||
                other.marketingConsent == marketingConsent) &&
            (identical(other.dataProcessingConsent, dataProcessingConsent) ||
                other.dataProcessingConsent == dataProcessingConsent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        title,
        specialization,
        workPlace,
        country,
        city,
        address,
        phoneNumber,
        whatsappNumber,
        telegramNumber,
        linkedinProfile,
        facebookProfile,
        instagramProfile,
        twitterProfile,
        websiteUrl,
        bio,
        dateOfBirth,
        gender,
        nationality,
        passportNumber,
        emergencyContactName,
        emergencyContactPhone,
        emergencyContactRelation,
        dietaryRestrictions,
        medicalConditions,
        accommodationPreferences,
        transportationNeeds,
        languagePreference,
        marketingConsent,
        dataProcessingConsent,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(
      this,
    );
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel(
      {required final String id,
      required final String userId,
      final String? title,
      final String? specialization,
      final String? workPlace,
      final String? country,
      final String? city,
      final String? address,
      final String? phoneNumber,
      final String? whatsappNumber,
      final String? telegramNumber,
      final String? linkedinProfile,
      final String? facebookProfile,
      final String? instagramProfile,
      final String? twitterProfile,
      final String? websiteUrl,
      final String? bio,
      final DateTime? dateOfBirth,
      final String? gender,
      final String? nationality,
      final String? passportNumber,
      final String? emergencyContactName,
      final String? emergencyContactPhone,
      final String? emergencyContactRelation,
      final String? dietaryRestrictions,
      final String? medicalConditions,
      final String? accommodationPreferences,
      final String? transportationNeeds,
      final String? languagePreference,
      final bool? marketingConsent,
      final bool? dataProcessingConsent,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get title;
  @override
  String? get specialization;
  @override
  String? get workPlace;
  @override
  String? get country;
  @override
  String? get city;
  @override
  String? get address;
  @override
  String? get phoneNumber;
  @override
  String? get whatsappNumber;
  @override
  String? get telegramNumber;
  @override
  String? get linkedinProfile;
  @override
  String? get facebookProfile;
  @override
  String? get instagramProfile;
  @override
  String? get twitterProfile;
  @override
  String? get websiteUrl;
  @override
  String? get bio;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override
  String? get nationality;
  @override
  String? get passportNumber;
  @override
  String? get emergencyContactName;
  @override
  String? get emergencyContactPhone;
  @override
  String? get emergencyContactRelation;
  @override
  String? get dietaryRestrictions;
  @override
  String? get medicalConditions;
  @override
  String? get accommodationPreferences;
  @override
  String? get transportationNeeds;
  @override
  String? get languagePreference;
  @override
  bool? get marketingConsent;
  @override
  bool? get dataProcessingConsent;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String phone, String password});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
  }) {
    return _then(_$LoginRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl with DiagnosticableTreeMixin implements _LoginRequest {
  const _$LoginRequestImpl({required this.phone, required this.password});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String password;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginRequest(phone: $phone, password: $password)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginRequest'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest(
      {required final String phone,
      required final String password}) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  String get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
          RegisterRequest value, $Res Function(RegisterRequest) then) =
      _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call(
      {String phone,
      String password,
      String confirmPassword,
      String name,
      String? email});
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? name = null,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(_$RegisterRequestImpl value,
          $Res Function(_$RegisterRequestImpl) then) =
      __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String phone,
      String password,
      String confirmPassword,
      String name,
      String? email});
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
      _$RegisterRequestImpl _value, $Res Function(_$RegisterRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? name = null,
    Object? email = freezed,
  }) {
    return _then(_$RegisterRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestImpl
    with DiagnosticableTreeMixin
    implements _RegisterRequest {
  const _$RegisterRequestImpl(
      {required this.phone,
      required this.password,
      required this.confirmPassword,
      required this.name,
      this.email});

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String password;
  @override
  final String confirmPassword;
  @override
  final String name;
  @override
  final String? email;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RegisterRequest(phone: $phone, password: $password, confirmPassword: $confirmPassword, name: $name, email: $email)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RegisterRequest'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('confirmPassword', confirmPassword))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('email', email));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phone, password, confirmPassword, name, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest(
      {required final String phone,
      required final String password,
      required final String confirmPassword,
      required final String name,
      final String? email}) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get password;
  @override
  String get confirmPassword;
  @override
  String get name;
  @override
  String? get email;
  @override
  @JsonKey(ignore: true)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  String? get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call(
      {String? accessToken,
      String? refreshToken,
      UserModel? user,
      bool success,
      String? message,
      String? token});

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? success = null,
    Object? message = freezed,
    Object? token = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
          _$AuthResponseImpl value, $Res Function(_$AuthResponseImpl) then) =
      __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? accessToken,
      String? refreshToken,
      UserModel? user,
      bool success,
      String? message,
      String? token});

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
      _$AuthResponseImpl _value, $Res Function(_$AuthResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? success = null,
    Object? message = freezed,
    Object? token = freezed,
  }) {
    return _then(_$AuthResponseImpl(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl with DiagnosticableTreeMixin implements _AuthResponse {
  const _$AuthResponseImpl(
      {this.accessToken,
      this.refreshToken,
      this.user,
      this.success = true,
      this.message,
      this.token});

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final UserModel? user;
  @override
  @JsonKey()
  final bool success;
  @override
  final String? message;
  @override
  final String? token;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthResponse(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, success: $success, message: $message, token: $token)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthResponse'))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('refreshToken', refreshToken))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('success', success))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('token', token));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, accessToken, refreshToken, user, success, message, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse(
      {final String? accessToken,
      final String? refreshToken,
      final UserModel? user,
      final bool success,
      final String? message,
      final String? token}) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  String? get accessToken;
  @override
  String? get refreshToken;
  @override
  UserModel? get user;
  @override
  bool get success;
  @override
  String? get message;
  @override
  String? get token;
  @override
  @JsonKey(ignore: true)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpRequest _$OtpRequestFromJson(Map<String, dynamic> json) {
  return _OtpRequest.fromJson(json);
}

/// @nodoc
mixin _$OtpRequest {
  String get phone => throw _privateConstructorUsedError;
  String get channel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpRequestCopyWith<OtpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpRequestCopyWith<$Res> {
  factory $OtpRequestCopyWith(
          OtpRequest value, $Res Function(OtpRequest) then) =
      _$OtpRequestCopyWithImpl<$Res, OtpRequest>;
  @useResult
  $Res call({String phone, String channel});
}

/// @nodoc
class _$OtpRequestCopyWithImpl<$Res, $Val extends OtpRequest>
    implements $OtpRequestCopyWith<$Res> {
  _$OtpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? channel = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpRequestImplCopyWith<$Res>
    implements $OtpRequestCopyWith<$Res> {
  factory _$$OtpRequestImplCopyWith(
          _$OtpRequestImpl value, $Res Function(_$OtpRequestImpl) then) =
      __$$OtpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String channel});
}

/// @nodoc
class __$$OtpRequestImplCopyWithImpl<$Res>
    extends _$OtpRequestCopyWithImpl<$Res, _$OtpRequestImpl>
    implements _$$OtpRequestImplCopyWith<$Res> {
  __$$OtpRequestImplCopyWithImpl(
      _$OtpRequestImpl _value, $Res Function(_$OtpRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? channel = null,
  }) {
    return _then(_$OtpRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpRequestImpl with DiagnosticableTreeMixin implements _OtpRequest {
  const _$OtpRequestImpl({required this.phone, required this.channel});

  factory _$OtpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String channel;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OtpRequest(phone: $phone, channel: $channel)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OtpRequest'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('channel', channel));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.channel, channel) || other.channel == channel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, channel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpRequestImplCopyWith<_$OtpRequestImpl> get copyWith =>
      __$$OtpRequestImplCopyWithImpl<_$OtpRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpRequestImplToJson(
      this,
    );
  }
}

abstract class _OtpRequest implements OtpRequest {
  const factory _OtpRequest(
      {required final String phone,
      required final String channel}) = _$OtpRequestImpl;

  factory _OtpRequest.fromJson(Map<String, dynamic> json) =
      _$OtpRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get channel;
  @override
  @JsonKey(ignore: true)
  _$$OtpRequestImplCopyWith<_$OtpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpVerifyRequest _$OtpVerifyRequestFromJson(Map<String, dynamic> json) {
  return _OtpVerifyRequest.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyRequest {
  String get phone => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyRequestCopyWith<OtpVerifyRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyRequestCopyWith<$Res> {
  factory $OtpVerifyRequestCopyWith(
          OtpVerifyRequest value, $Res Function(OtpVerifyRequest) then) =
      _$OtpVerifyRequestCopyWithImpl<$Res, OtpVerifyRequest>;
  @useResult
  $Res call({String phone, String otp});
}

/// @nodoc
class _$OtpVerifyRequestCopyWithImpl<$Res, $Val extends OtpVerifyRequest>
    implements $OtpVerifyRequestCopyWith<$Res> {
  _$OtpVerifyRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyRequestImplCopyWith<$Res>
    implements $OtpVerifyRequestCopyWith<$Res> {
  factory _$$OtpVerifyRequestImplCopyWith(_$OtpVerifyRequestImpl value,
          $Res Function(_$OtpVerifyRequestImpl) then) =
      __$$OtpVerifyRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String otp});
}

/// @nodoc
class __$$OtpVerifyRequestImplCopyWithImpl<$Res>
    extends _$OtpVerifyRequestCopyWithImpl<$Res, _$OtpVerifyRequestImpl>
    implements _$$OtpVerifyRequestImplCopyWith<$Res> {
  __$$OtpVerifyRequestImplCopyWithImpl(_$OtpVerifyRequestImpl _value,
      $Res Function(_$OtpVerifyRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
  }) {
    return _then(_$OtpVerifyRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpVerifyRequestImpl
    with DiagnosticableTreeMixin
    implements _OtpVerifyRequest {
  const _$OtpVerifyRequestImpl({required this.phone, required this.otp});

  factory _$OtpVerifyRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String otp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OtpVerifyRequest(phone: $phone, otp: $otp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OtpVerifyRequest'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('otp', otp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, otp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyRequestImplCopyWith<_$OtpVerifyRequestImpl> get copyWith =>
      __$$OtpVerifyRequestImplCopyWithImpl<_$OtpVerifyRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyRequestImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyRequest implements OtpVerifyRequest {
  const factory _OtpVerifyRequest(
      {required final String phone,
      required final String otp}) = _$OtpVerifyRequestImpl;

  factory _OtpVerifyRequest.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get otp;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyRequestImplCopyWith<_$OtpVerifyRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileStatusModel _$ProfileStatusModelFromJson(Map<String, dynamic> json) {
  return _ProfileStatusModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileStatusModel {
  String get status => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  UserModel get user => throw _privateConstructorUsedError;
  List<VerificationRequestModel> get pendingRequests =>
      throw _privateConstructorUsedError;
  List<DocumentModel> get documents => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileStatusModelCopyWith<ProfileStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStatusModelCopyWith<$Res> {
  factory $ProfileStatusModelCopyWith(
          ProfileStatusModel value, $Res Function(ProfileStatusModel) then) =
      _$ProfileStatusModelCopyWithImpl<$Res, ProfileStatusModel>;
  @useResult
  $Res call(
      {String status,
      double completionPercentage,
      UserModel user,
      List<VerificationRequestModel> pendingRequests,
      List<DocumentModel> documents});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$ProfileStatusModelCopyWithImpl<$Res, $Val extends ProfileStatusModel>
    implements $ProfileStatusModelCopyWith<$Res> {
  _$ProfileStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? completionPercentage = null,
    Object? user = null,
    Object? pendingRequests = null,
    Object? documents = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      pendingRequests: null == pendingRequests
          ? _value.pendingRequests
          : pendingRequests // ignore: cast_nullable_to_non_nullable
              as List<VerificationRequestModel>,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<DocumentModel>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileStatusModelImplCopyWith<$Res>
    implements $ProfileStatusModelCopyWith<$Res> {
  factory _$$ProfileStatusModelImplCopyWith(_$ProfileStatusModelImpl value,
          $Res Function(_$ProfileStatusModelImpl) then) =
      __$$ProfileStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String status,
      double completionPercentage,
      UserModel user,
      List<VerificationRequestModel> pendingRequests,
      List<DocumentModel> documents});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$ProfileStatusModelImplCopyWithImpl<$Res>
    extends _$ProfileStatusModelCopyWithImpl<$Res, _$ProfileStatusModelImpl>
    implements _$$ProfileStatusModelImplCopyWith<$Res> {
  __$$ProfileStatusModelImplCopyWithImpl(_$ProfileStatusModelImpl _value,
      $Res Function(_$ProfileStatusModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? completionPercentage = null,
    Object? user = null,
    Object? pendingRequests = null,
    Object? documents = null,
  }) {
    return _then(_$ProfileStatusModelImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      pendingRequests: null == pendingRequests
          ? _value._pendingRequests
          : pendingRequests // ignore: cast_nullable_to_non_nullable
              as List<VerificationRequestModel>,
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<DocumentModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileStatusModelImpl
    with DiagnosticableTreeMixin
    implements _ProfileStatusModel {
  const _$ProfileStatusModelImpl(
      {required this.status,
      required this.completionPercentage,
      required this.user,
      required final List<VerificationRequestModel> pendingRequests,
      required final List<DocumentModel> documents})
      : _pendingRequests = pendingRequests,
        _documents = documents;

  factory _$ProfileStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileStatusModelImplFromJson(json);

  @override
  final String status;
  @override
  final double completionPercentage;
  @override
  final UserModel user;
  final List<VerificationRequestModel> _pendingRequests;
  @override
  List<VerificationRequestModel> get pendingRequests {
    if (_pendingRequests is EqualUnmodifiableListView) return _pendingRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingRequests);
  }

  final List<DocumentModel> _documents;
  @override
  List<DocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProfileStatusModel(status: $status, completionPercentage: $completionPercentage, user: $user, pendingRequests: $pendingRequests, documents: $documents)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProfileStatusModel'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('completionPercentage', completionPercentage))
      ..add(DiagnosticsProperty('user', user))
      ..add(DiagnosticsProperty('pendingRequests', pendingRequests))
      ..add(DiagnosticsProperty('documents', documents));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStatusModelImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality()
                .equals(other._pendingRequests, _pendingRequests) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      completionPercentage,
      user,
      const DeepCollectionEquality().hash(_pendingRequests),
      const DeepCollectionEquality().hash(_documents));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStatusModelImplCopyWith<_$ProfileStatusModelImpl> get copyWith =>
      __$$ProfileStatusModelImplCopyWithImpl<_$ProfileStatusModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileStatusModelImplToJson(
      this,
    );
  }
}

abstract class _ProfileStatusModel implements ProfileStatusModel {
  const factory _ProfileStatusModel(
      {required final String status,
      required final double completionPercentage,
      required final UserModel user,
      required final List<VerificationRequestModel> pendingRequests,
      required final List<DocumentModel> documents}) = _$ProfileStatusModelImpl;

  factory _ProfileStatusModel.fromJson(Map<String, dynamic> json) =
      _$ProfileStatusModelImpl.fromJson;

  @override
  String get status;
  @override
  double get completionPercentage;
  @override
  UserModel get user;
  @override
  List<VerificationRequestModel> get pendingRequests;
  @override
  List<DocumentModel> get documents;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStatusModelImplCopyWith<_$ProfileStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) {
  return _DocumentModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentModel {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime? get uploadedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentModelCopyWith<DocumentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentModelCopyWith<$Res> {
  factory $DocumentModelCopyWith(
          DocumentModel value, $Res Function(DocumentModel) then) =
      _$DocumentModelCopyWithImpl<$Res, DocumentModel>;
  @useResult
  $Res call(
      {String id,
      String type,
      String url,
      String status,
      DateTime? uploadedAt});
}

/// @nodoc
class _$DocumentModelCopyWithImpl<$Res, $Val extends DocumentModel>
    implements $DocumentModelCopyWith<$Res> {
  _$DocumentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? status = null,
    Object? uploadedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentModelImplCopyWith<$Res>
    implements $DocumentModelCopyWith<$Res> {
  factory _$$DocumentModelImplCopyWith(
          _$DocumentModelImpl value, $Res Function(_$DocumentModelImpl) then) =
      __$$DocumentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String url,
      String status,
      DateTime? uploadedAt});
}

/// @nodoc
class __$$DocumentModelImplCopyWithImpl<$Res>
    extends _$DocumentModelCopyWithImpl<$Res, _$DocumentModelImpl>
    implements _$$DocumentModelImplCopyWith<$Res> {
  __$$DocumentModelImplCopyWithImpl(
      _$DocumentModelImpl _value, $Res Function(_$DocumentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? url = null,
    Object? status = null,
    Object? uploadedAt = freezed,
  }) {
    return _then(_$DocumentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentModelImpl
    with DiagnosticableTreeMixin
    implements _DocumentModel {
  const _$DocumentModelImpl(
      {required this.id,
      required this.type,
      required this.url,
      required this.status,
      this.uploadedAt});

  factory _$DocumentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String url;
  @override
  final String status;
  @override
  final DateTime? uploadedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DocumentModel(id: $id, type: $type, url: $url, status: $status, uploadedAt: $uploadedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DocumentModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('uploadedAt', uploadedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, url, status, uploadedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentModelImplCopyWith<_$DocumentModelImpl> get copyWith =>
      __$$DocumentModelImplCopyWithImpl<_$DocumentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentModelImplToJson(
      this,
    );
  }
}

abstract class _DocumentModel implements DocumentModel {
  const factory _DocumentModel(
      {required final String id,
      required final String type,
      required final String url,
      required final String status,
      final DateTime? uploadedAt}) = _$DocumentModelImpl;

  factory _DocumentModel.fromJson(Map<String, dynamic> json) =
      _$DocumentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get url;
  @override
  String get status;
  @override
  DateTime? get uploadedAt;
  @override
  @JsonKey(ignore: true)
  _$$DocumentModelImplCopyWith<_$DocumentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RequestPasswordResetRequest _$RequestPasswordResetRequestFromJson(
    Map<String, dynamic> json) {
  return _RequestPasswordResetRequest.fromJson(json);
}

/// @nodoc
mixin _$RequestPasswordResetRequest {
  String get phone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequestPasswordResetRequestCopyWith<RequestPasswordResetRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestPasswordResetRequestCopyWith<$Res> {
  factory $RequestPasswordResetRequestCopyWith(
          RequestPasswordResetRequest value,
          $Res Function(RequestPasswordResetRequest) then) =
      _$RequestPasswordResetRequestCopyWithImpl<$Res,
          RequestPasswordResetRequest>;
  @useResult
  $Res call({String phone});
}

/// @nodoc
class _$RequestPasswordResetRequestCopyWithImpl<$Res,
        $Val extends RequestPasswordResetRequest>
    implements $RequestPasswordResetRequestCopyWith<$Res> {
  _$RequestPasswordResetRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestPasswordResetRequestImplCopyWith<$Res>
    implements $RequestPasswordResetRequestCopyWith<$Res> {
  factory _$$RequestPasswordResetRequestImplCopyWith(
          _$RequestPasswordResetRequestImpl value,
          $Res Function(_$RequestPasswordResetRequestImpl) then) =
      __$$RequestPasswordResetRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone});
}

/// @nodoc
class __$$RequestPasswordResetRequestImplCopyWithImpl<$Res>
    extends _$RequestPasswordResetRequestCopyWithImpl<$Res,
        _$RequestPasswordResetRequestImpl>
    implements _$$RequestPasswordResetRequestImplCopyWith<$Res> {
  __$$RequestPasswordResetRequestImplCopyWithImpl(
      _$RequestPasswordResetRequestImpl _value,
      $Res Function(_$RequestPasswordResetRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
  }) {
    return _then(_$RequestPasswordResetRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestPasswordResetRequestImpl
    with DiagnosticableTreeMixin
    implements _RequestPasswordResetRequest {
  const _$RequestPasswordResetRequestImpl({required this.phone});

  factory _$RequestPasswordResetRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RequestPasswordResetRequestImplFromJson(json);

  @override
  final String phone;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RequestPasswordResetRequest(phone: $phone)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RequestPasswordResetRequest'))
      ..add(DiagnosticsProperty('phone', phone));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestPasswordResetRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestPasswordResetRequestImplCopyWith<_$RequestPasswordResetRequestImpl>
      get copyWith => __$$RequestPasswordResetRequestImplCopyWithImpl<
          _$RequestPasswordResetRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestPasswordResetRequestImplToJson(
      this,
    );
  }
}

abstract class _RequestPasswordResetRequest
    implements RequestPasswordResetRequest {
  const factory _RequestPasswordResetRequest({required final String phone}) =
      _$RequestPasswordResetRequestImpl;

  factory _RequestPasswordResetRequest.fromJson(Map<String, dynamic> json) =
      _$RequestPasswordResetRequestImpl.fromJson;

  @override
  String get phone;
  @override
  @JsonKey(ignore: true)
  _$$RequestPasswordResetRequestImplCopyWith<_$RequestPasswordResetRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ResetPasswordRequest _$ResetPasswordRequestFromJson(Map<String, dynamic> json) {
  return _ResetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordRequest {
  String get phone => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPasswordRequestCopyWith<ResetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordRequestCopyWith<$Res> {
  factory $ResetPasswordRequestCopyWith(ResetPasswordRequest value,
          $Res Function(ResetPasswordRequest) then) =
      _$ResetPasswordRequestCopyWithImpl<$Res, ResetPasswordRequest>;
  @useResult
  $Res call({String phone, String otp, String newPassword});
}

/// @nodoc
class _$ResetPasswordRequestCopyWithImpl<$Res,
        $Val extends ResetPasswordRequest>
    implements $ResetPasswordRequestCopyWith<$Res> {
  _$ResetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPasswordRequestImplCopyWith<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  factory _$$ResetPasswordRequestImplCopyWith(_$ResetPasswordRequestImpl value,
          $Res Function(_$ResetPasswordRequestImpl) then) =
      __$$ResetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String otp, String newPassword});
}

/// @nodoc
class __$$ResetPasswordRequestImplCopyWithImpl<$Res>
    extends _$ResetPasswordRequestCopyWithImpl<$Res, _$ResetPasswordRequestImpl>
    implements _$$ResetPasswordRequestImplCopyWith<$Res> {
  __$$ResetPasswordRequestImplCopyWithImpl(_$ResetPasswordRequestImpl _value,
      $Res Function(_$ResetPasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? otp = null,
    Object? newPassword = null,
  }) {
    return _then(_$ResetPasswordRequestImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPasswordRequestImpl
    with DiagnosticableTreeMixin
    implements _ResetPasswordRequest {
  const _$ResetPasswordRequestImpl(
      {required this.phone, required this.otp, required this.newPassword});

  factory _$ResetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordRequestImplFromJson(json);

  @override
  final String phone;
  @override
  final String otp;
  @override
  final String newPassword;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResetPasswordRequest(phone: $phone, otp: $otp, newPassword: $newPassword)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ResetPasswordRequest'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('otp', otp))
      ..add(DiagnosticsProperty('newPassword', newPassword));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordRequestImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, otp, newPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith =>
          __$$ResetPasswordRequestImplCopyWithImpl<_$ResetPasswordRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ResetPasswordRequest implements ResetPasswordRequest {
  const factory _ResetPasswordRequest(
      {required final String phone,
      required final String otp,
      required final String newPassword}) = _$ResetPasswordRequestImpl;

  factory _ResetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordRequestImpl.fromJson;

  @override
  String get phone;
  @override
  String get otp;
  @override
  String get newPassword;
  @override
  @JsonKey(ignore: true)
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PasswordResetResponse _$PasswordResetResponseFromJson(
    Map<String, dynamic> json) {
  return _PasswordResetResponse.fromJson(json);
}

/// @nodoc
mixin _$PasswordResetResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PasswordResetResponseCopyWith<PasswordResetResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordResetResponseCopyWith<$Res> {
  factory $PasswordResetResponseCopyWith(PasswordResetResponse value,
          $Res Function(PasswordResetResponse) then) =
      _$PasswordResetResponseCopyWithImpl<$Res, PasswordResetResponse>;
  @useResult
  $Res call({bool success, String? message});
}

/// @nodoc
class _$PasswordResetResponseCopyWithImpl<$Res,
        $Val extends PasswordResetResponse>
    implements $PasswordResetResponseCopyWith<$Res> {
  _$PasswordResetResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$PasswordResetResponseImplCopyWith<$Res>
    implements $PasswordResetResponseCopyWith<$Res> {
  factory _$$PasswordResetResponseImplCopyWith(
          _$PasswordResetResponseImpl value,
          $Res Function(_$PasswordResetResponseImpl) then) =
      __$$PasswordResetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? message});
}

/// @nodoc
class __$$PasswordResetResponseImplCopyWithImpl<$Res>
    extends _$PasswordResetResponseCopyWithImpl<$Res,
        _$PasswordResetResponseImpl>
    implements _$$PasswordResetResponseImplCopyWith<$Res> {
  __$$PasswordResetResponseImplCopyWithImpl(_$PasswordResetResponseImpl _value,
      $Res Function(_$PasswordResetResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
  }) {
    return _then(_$PasswordResetResponseImpl(
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
class _$PasswordResetResponseImpl
    with DiagnosticableTreeMixin
    implements _PasswordResetResponse {
  const _$PasswordResetResponseImpl({this.success = true, this.message});

  factory _$PasswordResetResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PasswordResetResponseImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PasswordResetResponse(success: $success, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PasswordResetResponse'))
      ..add(DiagnosticsProperty('success', success))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetResponseImplCopyWith<_$PasswordResetResponseImpl>
      get copyWith => __$$PasswordResetResponseImplCopyWithImpl<
          _$PasswordResetResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PasswordResetResponseImplToJson(
      this,
    );
  }
}

abstract class _PasswordResetResponse implements PasswordResetResponse {
  const factory _PasswordResetResponse(
      {final bool success,
      final String? message}) = _$PasswordResetResponseImpl;

  factory _PasswordResetResponse.fromJson(Map<String, dynamic> json) =
      _$PasswordResetResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$PasswordResetResponseImplCopyWith<_$PasswordResetResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
