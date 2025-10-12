// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return _ProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError; // البيانات الشخصية
  @JsonKey(name: 'full_name_ar')
  String get fullNameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name_en')
  String get fullNameEn => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'governorate_id')
  String? get governorateId =>
      throw _privateConstructorUsedError; // البيانات الأكاديمية
  @JsonKey(name: 'qualification_id')
  String? get qualificationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'graduation_year')
  int get graduationYear => throw _privateConstructorUsedError;
  String get university => throw _privateConstructorUsedError;
  String get workplace => throw _privateConstructorUsedError; // حالة التوثيق
  @JsonKey(name: 'status')
  VerificationStatus get verificationStatus =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percentage')
  double get completionPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason =>
      throw _privateConstructorUsedError; // صورة الملف الشخصي
  @JsonKey(name: 'profile_picture_url')
  String? get profilePictureUrl =>
      throw _privateConstructorUsedError; // الوثائق المرفوعة
  List<DocumentModel> get documents =>
      throw _privateConstructorUsedError; // قواعد التوثيق المطلوبة
  @JsonKey(name: 'required_documents')
  List<RequiredDocumentModel> get requiredDocuments =>
      throw _privateConstructorUsedError; // تواريخ
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
          ProfileModel value, $Res Function(ProfileModel) then) =
      _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      @JsonKey(name: 'full_name_ar') String fullNameAr,
      @JsonKey(name: 'full_name_en') String fullNameEn,
      String email,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'governorate_id') String? governorateId,
      @JsonKey(name: 'qualification_id') String? qualificationId,
      @JsonKey(name: 'graduation_year') int graduationYear,
      String university,
      String workplace,
      @JsonKey(name: 'status') VerificationStatus verificationStatus,
      @JsonKey(name: 'completion_percentage') double completionPercentage,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
      List<DocumentModel> documents,
      @JsonKey(name: 'required_documents')
      List<RequiredDocumentModel> requiredDocuments,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'verified_at') DateTime? verifiedAt});
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullNameAr = null,
    Object? fullNameEn = null,
    Object? email = null,
    Object? birthDate = freezed,
    Object? governorateId = freezed,
    Object? qualificationId = freezed,
    Object? graduationYear = null,
    Object? university = null,
    Object? workplace = null,
    Object? verificationStatus = null,
    Object? completionPercentage = null,
    Object? rejectionReason = freezed,
    Object? profilePictureUrl = freezed,
    Object? documents = null,
    Object? requiredDocuments = null,
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
      fullNameAr: null == fullNameAr
          ? _value.fullNameAr
          : fullNameAr // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameEn: null == fullNameEn
          ? _value.fullNameEn
          : fullNameEn // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
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
      graduationYear: null == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int,
      university: null == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String,
      workplace: null == workplace
          ? _value.workplace
          : workplace // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<DocumentModel>,
      requiredDocuments: null == requiredDocuments
          ? _value.requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<RequiredDocumentModel>,
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
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
          _$ProfileModelImpl value, $Res Function(_$ProfileModelImpl) then) =
      __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      @JsonKey(name: 'full_name_ar') String fullNameAr,
      @JsonKey(name: 'full_name_en') String fullNameEn,
      String email,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'governorate_id') String? governorateId,
      @JsonKey(name: 'qualification_id') String? qualificationId,
      @JsonKey(name: 'graduation_year') int graduationYear,
      String university,
      String workplace,
      @JsonKey(name: 'status') VerificationStatus verificationStatus,
      @JsonKey(name: 'completion_percentage') double completionPercentage,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'profile_picture_url') String? profilePictureUrl,
      List<DocumentModel> documents,
      @JsonKey(name: 'required_documents')
      List<RequiredDocumentModel> requiredDocuments,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'verified_at') DateTime? verifiedAt});
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
      _$ProfileModelImpl _value, $Res Function(_$ProfileModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fullNameAr = null,
    Object? fullNameEn = null,
    Object? email = null,
    Object? birthDate = freezed,
    Object? governorateId = freezed,
    Object? qualificationId = freezed,
    Object? graduationYear = null,
    Object? university = null,
    Object? workplace = null,
    Object? verificationStatus = null,
    Object? completionPercentage = null,
    Object? rejectionReason = freezed,
    Object? profilePictureUrl = freezed,
    Object? documents = null,
    Object? requiredDocuments = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? verifiedAt = freezed,
  }) {
    return _then(_$ProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameAr: null == fullNameAr
          ? _value.fullNameAr
          : fullNameAr // ignore: cast_nullable_to_non_nullable
              as String,
      fullNameEn: null == fullNameEn
          ? _value.fullNameEn
          : fullNameEn // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
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
      graduationYear: null == graduationYear
          ? _value.graduationYear
          : graduationYear // ignore: cast_nullable_to_non_nullable
              as int,
      university: null == university
          ? _value.university
          : university // ignore: cast_nullable_to_non_nullable
              as String,
      workplace: null == workplace
          ? _value.workplace
          : workplace // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: null == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _value.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<DocumentModel>,
      requiredDocuments: null == requiredDocuments
          ? _value._requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<RequiredDocumentModel>,
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
class _$ProfileModelImpl with DiagnosticableTreeMixin implements _ProfileModel {
  const _$ProfileModelImpl(
      {required this.id,
      required this.userId,
      @JsonKey(name: 'full_name_ar') this.fullNameAr = '',
      @JsonKey(name: 'full_name_en') this.fullNameEn = '',
      this.email = '',
      @JsonKey(name: 'birth_date') this.birthDate,
      @JsonKey(name: 'governorate_id') this.governorateId,
      @JsonKey(name: 'qualification_id') this.qualificationId,
      @JsonKey(name: 'graduation_year') this.graduationYear = 0,
      this.university = '',
      this.workplace = '',
      @JsonKey(name: 'status')
      this.verificationStatus = VerificationStatus.unverified,
      @JsonKey(name: 'completion_percentage') this.completionPercentage = 0.0,
      @JsonKey(name: 'rejection_reason') this.rejectionReason,
      @JsonKey(name: 'profile_picture_url') this.profilePictureUrl,
      final List<DocumentModel> documents = const [],
      @JsonKey(name: 'required_documents')
      final List<RequiredDocumentModel> requiredDocuments = const [],
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'verified_at') this.verifiedAt})
      : _documents = documents,
        _requiredDocuments = requiredDocuments;

  factory _$ProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
// البيانات الشخصية
  @override
  @JsonKey(name: 'full_name_ar')
  final String fullNameAr;
  @override
  @JsonKey(name: 'full_name_en')
  final String fullNameEn;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'governorate_id')
  final String? governorateId;
// البيانات الأكاديمية
  @override
  @JsonKey(name: 'qualification_id')
  final String? qualificationId;
  @override
  @JsonKey(name: 'graduation_year')
  final int graduationYear;
  @override
  @JsonKey()
  final String university;
  @override
  @JsonKey()
  final String workplace;
// حالة التوثيق
  @override
  @JsonKey(name: 'status')
  final VerificationStatus verificationStatus;
  @override
  @JsonKey(name: 'completion_percentage')
  final double completionPercentage;
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
// صورة الملف الشخصي
  @override
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;
// الوثائق المرفوعة
  final List<DocumentModel> _documents;
// الوثائق المرفوعة
  @override
  @JsonKey()
  List<DocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

// قواعد التوثيق المطلوبة
  final List<RequiredDocumentModel> _requiredDocuments;
// قواعد التوثيق المطلوبة
  @override
  @JsonKey(name: 'required_documents')
  List<RequiredDocumentModel> get requiredDocuments {
    if (_requiredDocuments is EqualUnmodifiableListView)
      return _requiredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredDocuments);
  }

// تواريخ
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'verified_at')
  final DateTime? verifiedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProfileModel(id: $id, userId: $userId, fullNameAr: $fullNameAr, fullNameEn: $fullNameEn, email: $email, birthDate: $birthDate, governorateId: $governorateId, qualificationId: $qualificationId, graduationYear: $graduationYear, university: $university, workplace: $workplace, verificationStatus: $verificationStatus, completionPercentage: $completionPercentage, rejectionReason: $rejectionReason, profilePictureUrl: $profilePictureUrl, documents: $documents, requiredDocuments: $requiredDocuments, createdAt: $createdAt, updatedAt: $updatedAt, verifiedAt: $verifiedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProfileModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('fullNameAr', fullNameAr))
      ..add(DiagnosticsProperty('fullNameEn', fullNameEn))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('birthDate', birthDate))
      ..add(DiagnosticsProperty('governorateId', governorateId))
      ..add(DiagnosticsProperty('qualificationId', qualificationId))
      ..add(DiagnosticsProperty('graduationYear', graduationYear))
      ..add(DiagnosticsProperty('university', university))
      ..add(DiagnosticsProperty('workplace', workplace))
      ..add(DiagnosticsProperty('verificationStatus', verificationStatus))
      ..add(DiagnosticsProperty('completionPercentage', completionPercentage))
      ..add(DiagnosticsProperty('rejectionReason', rejectionReason))
      ..add(DiagnosticsProperty('profilePictureUrl', profilePictureUrl))
      ..add(DiagnosticsProperty('documents', documents))
      ..add(DiagnosticsProperty('requiredDocuments', requiredDocuments))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('verifiedAt', verifiedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
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
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            const DeepCollectionEquality()
                .equals(other._requiredDocuments, _requiredDocuments) &&
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
        verificationStatus,
        completionPercentage,
        rejectionReason,
        profilePictureUrl,
        const DeepCollectionEquality().hash(_documents),
        const DeepCollectionEquality().hash(_requiredDocuments),
        createdAt,
        updatedAt,
        verifiedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileModelImplToJson(
      this,
    );
  }
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel(
      {required final String id,
      required final String userId,
      @JsonKey(name: 'full_name_ar') final String fullNameAr,
      @JsonKey(name: 'full_name_en') final String fullNameEn,
      final String email,
      @JsonKey(name: 'birth_date') final DateTime? birthDate,
      @JsonKey(name: 'governorate_id') final String? governorateId,
      @JsonKey(name: 'qualification_id') final String? qualificationId,
      @JsonKey(name: 'graduation_year') final int graduationYear,
      final String university,
      final String workplace,
      @JsonKey(name: 'status') final VerificationStatus verificationStatus,
      @JsonKey(name: 'completion_percentage') final double completionPercentage,
      @JsonKey(name: 'rejection_reason') final String? rejectionReason,
      @JsonKey(name: 'profile_picture_url') final String? profilePictureUrl,
      final List<DocumentModel> documents,
      @JsonKey(name: 'required_documents')
      final List<RequiredDocumentModel> requiredDocuments,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'verified_at')
      final DateTime? verifiedAt}) = _$ProfileModelImpl;

  factory _ProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override // البيانات الشخصية
  @JsonKey(name: 'full_name_ar')
  String get fullNameAr;
  @override
  @JsonKey(name: 'full_name_en')
  String get fullNameEn;
  @override
  String get email;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'governorate_id')
  String? get governorateId;
  @override // البيانات الأكاديمية
  @JsonKey(name: 'qualification_id')
  String? get qualificationId;
  @override
  @JsonKey(name: 'graduation_year')
  int get graduationYear;
  @override
  String get university;
  @override
  String get workplace;
  @override // حالة التوثيق
  @JsonKey(name: 'status')
  VerificationStatus get verificationStatus;
  @override
  @JsonKey(name: 'completion_percentage')
  double get completionPercentage;
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @override // صورة الملف الشخصي
  @JsonKey(name: 'profile_picture_url')
  String? get profilePictureUrl;
  @override // الوثائق المرفوعة
  List<DocumentModel> get documents;
  @override // قواعد التوثيق المطلوبة
  @JsonKey(name: 'required_documents')
  List<RequiredDocumentModel> get requiredDocuments;
  @override // تواريخ
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'verified_at')
  DateTime? get verifiedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) {
  return _DocumentModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_id')
  String get fileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_type')
  DocumentType get documentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_name')
  String get originalName => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_url')
  String get fileUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'mime_type')
  String get mimeType => throw _privateConstructorUsedError;
  DocumentStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_notes')
  String? get adminNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_at')
  DateTime get uploadedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'file_id') String fileId,
      @JsonKey(name: 'document_type') DocumentType documentType,
      @JsonKey(name: 'original_name') String originalName,
      @JsonKey(name: 'file_url') String fileUrl,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String mimeType,
      DocumentStatus status,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'uploaded_at') DateTime uploadedAt,
      @JsonKey(name: 'reviewed_at') DateTime? reviewedAt});
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
    Object? fileId = null,
    Object? documentType = null,
    Object? originalName = null,
    Object? fileUrl = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? uploadedAt = null,
    Object? reviewedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      originalName: null == originalName
          ? _value.originalName
          : originalName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DocumentStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'file_id') String fileId,
      @JsonKey(name: 'document_type') DocumentType documentType,
      @JsonKey(name: 'original_name') String originalName,
      @JsonKey(name: 'file_url') String fileUrl,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String mimeType,
      DocumentStatus status,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'uploaded_at') DateTime uploadedAt,
      @JsonKey(name: 'reviewed_at') DateTime? reviewedAt});
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
    Object? fileId = null,
    Object? documentType = null,
    Object? originalName = null,
    Object? fileUrl = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? uploadedAt = null,
    Object? reviewedAt = freezed,
  }) {
    return _then(_$DocumentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      originalName: null == originalName
          ? _value.originalName
          : originalName // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as DocumentStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedAt: null == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'file_id') required this.fileId,
      @JsonKey(name: 'document_type') required this.documentType,
      @JsonKey(name: 'original_name') required this.originalName,
      @JsonKey(name: 'file_url') required this.fileUrl,
      @JsonKey(name: 'file_size') required this.fileSize,
      @JsonKey(name: 'mime_type') required this.mimeType,
      this.status = DocumentStatus.pending,
      @JsonKey(name: 'admin_notes') this.adminNotes,
      @JsonKey(name: 'uploaded_at') required this.uploadedAt,
      @JsonKey(name: 'reviewed_at') this.reviewedAt});

  factory _$DocumentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'file_id')
  final String fileId;
  @override
  @JsonKey(name: 'document_type')
  final DocumentType documentType;
  @override
  @JsonKey(name: 'original_name')
  final String originalName;
  @override
  @JsonKey(name: 'file_url')
  final String fileUrl;
  @override
  @JsonKey(name: 'file_size')
  final int fileSize;
  @override
  @JsonKey(name: 'mime_type')
  final String mimeType;
  @override
  @JsonKey()
  final DocumentStatus status;
  @override
  @JsonKey(name: 'admin_notes')
  final String? adminNotes;
  @override
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;
  @override
  @JsonKey(name: 'reviewed_at')
  final DateTime? reviewedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DocumentModel(id: $id, fileId: $fileId, documentType: $documentType, originalName: $originalName, fileUrl: $fileUrl, fileSize: $fileSize, mimeType: $mimeType, status: $status, adminNotes: $adminNotes, uploadedAt: $uploadedAt, reviewedAt: $reviewedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DocumentModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('fileId', fileId))
      ..add(DiagnosticsProperty('documentType', documentType))
      ..add(DiagnosticsProperty('originalName', originalName))
      ..add(DiagnosticsProperty('fileUrl', fileUrl))
      ..add(DiagnosticsProperty('fileSize', fileSize))
      ..add(DiagnosticsProperty('mimeType', mimeType))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('adminNotes', adminNotes))
      ..add(DiagnosticsProperty('uploadedAt', uploadedAt))
      ..add(DiagnosticsProperty('reviewedAt', reviewedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.originalName, originalName) ||
                other.originalName == originalName) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      fileId,
      documentType,
      originalName,
      fileUrl,
      fileSize,
      mimeType,
      status,
      adminNotes,
      uploadedAt,
      reviewedAt);

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
      @JsonKey(name: 'file_id') required final String fileId,
      @JsonKey(name: 'document_type') required final DocumentType documentType,
      @JsonKey(name: 'original_name') required final String originalName,
      @JsonKey(name: 'file_url') required final String fileUrl,
      @JsonKey(name: 'file_size') required final int fileSize,
      @JsonKey(name: 'mime_type') required final String mimeType,
      final DocumentStatus status,
      @JsonKey(name: 'admin_notes') final String? adminNotes,
      @JsonKey(name: 'uploaded_at') required final DateTime uploadedAt,
      @JsonKey(name: 'reviewed_at')
      final DateTime? reviewedAt}) = _$DocumentModelImpl;

  factory _DocumentModel.fromJson(Map<String, dynamic> json) =
      _$DocumentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'file_id')
  String get fileId;
  @override
  @JsonKey(name: 'document_type')
  DocumentType get documentType;
  @override
  @JsonKey(name: 'original_name')
  String get originalName;
  @override
  @JsonKey(name: 'file_url')
  String get fileUrl;
  @override
  @JsonKey(name: 'file_size')
  int get fileSize;
  @override
  @JsonKey(name: 'mime_type')
  String get mimeType;
  @override
  DocumentStatus get status;
  @override
  @JsonKey(name: 'admin_notes')
  String? get adminNotes;
  @override
  @JsonKey(name: 'uploaded_at')
  DateTime get uploadedAt;
  @override
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt;
  @override
  @JsonKey(ignore: true)
  _$$DocumentModelImplCopyWith<_$DocumentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RequiredDocumentModel _$RequiredDocumentModelFromJson(
    Map<String, dynamic> json) {
  return _RequiredDocumentModel.fromJson(json);
}

/// @nodoc
mixin _$RequiredDocumentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_type')
  DocumentType get documentType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_required')
  bool get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_file_size')
  int get maxFileSize => throw _privateConstructorUsedError; // 5MB
  @JsonKey(name: 'allowed_formats')
  List<String> get allowedFormats => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequiredDocumentModelCopyWith<RequiredDocumentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequiredDocumentModelCopyWith<$Res> {
  factory $RequiredDocumentModelCopyWith(RequiredDocumentModel value,
          $Res Function(RequiredDocumentModel) then) =
      _$RequiredDocumentModelCopyWithImpl<$Res, RequiredDocumentModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'document_type') DocumentType documentType,
      String title,
      String description,
      @JsonKey(name: 'is_required') bool isRequired,
      @JsonKey(name: 'max_file_size') int maxFileSize,
      @JsonKey(name: 'allowed_formats') List<String> allowedFormats});
}

/// @nodoc
class _$RequiredDocumentModelCopyWithImpl<$Res,
        $Val extends RequiredDocumentModel>
    implements $RequiredDocumentModelCopyWith<$Res> {
  _$RequiredDocumentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentType = null,
    Object? title = null,
    Object? description = null,
    Object? isRequired = null,
    Object? maxFileSize = null,
    Object? allowedFormats = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      maxFileSize: null == maxFileSize
          ? _value.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      allowedFormats: null == allowedFormats
          ? _value.allowedFormats
          : allowedFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequiredDocumentModelImplCopyWith<$Res>
    implements $RequiredDocumentModelCopyWith<$Res> {
  factory _$$RequiredDocumentModelImplCopyWith(
          _$RequiredDocumentModelImpl value,
          $Res Function(_$RequiredDocumentModelImpl) then) =
      __$$RequiredDocumentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'document_type') DocumentType documentType,
      String title,
      String description,
      @JsonKey(name: 'is_required') bool isRequired,
      @JsonKey(name: 'max_file_size') int maxFileSize,
      @JsonKey(name: 'allowed_formats') List<String> allowedFormats});
}

/// @nodoc
class __$$RequiredDocumentModelImplCopyWithImpl<$Res>
    extends _$RequiredDocumentModelCopyWithImpl<$Res,
        _$RequiredDocumentModelImpl>
    implements _$$RequiredDocumentModelImplCopyWith<$Res> {
  __$$RequiredDocumentModelImplCopyWithImpl(_$RequiredDocumentModelImpl _value,
      $Res Function(_$RequiredDocumentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentType = null,
    Object? title = null,
    Object? description = null,
    Object? isRequired = null,
    Object? maxFileSize = null,
    Object? allowedFormats = null,
  }) {
    return _then(_$RequiredDocumentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as DocumentType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      maxFileSize: null == maxFileSize
          ? _value.maxFileSize
          : maxFileSize // ignore: cast_nullable_to_non_nullable
              as int,
      allowedFormats: null == allowedFormats
          ? _value._allowedFormats
          : allowedFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequiredDocumentModelImpl
    with DiagnosticableTreeMixin
    implements _RequiredDocumentModel {
  const _$RequiredDocumentModelImpl(
      {required this.id,
      @JsonKey(name: 'document_type') required this.documentType,
      required this.title,
      required this.description,
      @JsonKey(name: 'is_required') this.isRequired = true,
      @JsonKey(name: 'max_file_size') this.maxFileSize = 5242880,
      @JsonKey(name: 'allowed_formats')
      final List<String> allowedFormats = const ['pdf', 'jpg', 'jpeg', 'png']})
      : _allowedFormats = allowedFormats;

  factory _$RequiredDocumentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequiredDocumentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'document_type')
  final DocumentType documentType;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'is_required')
  final bool isRequired;
  @override
  @JsonKey(name: 'max_file_size')
  final int maxFileSize;
// 5MB
  final List<String> _allowedFormats;
// 5MB
  @override
  @JsonKey(name: 'allowed_formats')
  List<String> get allowedFormats {
    if (_allowedFormats is EqualUnmodifiableListView) return _allowedFormats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedFormats);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RequiredDocumentModel(id: $id, documentType: $documentType, title: $title, description: $description, isRequired: $isRequired, maxFileSize: $maxFileSize, allowedFormats: $allowedFormats)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RequiredDocumentModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('documentType', documentType))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('isRequired', isRequired))
      ..add(DiagnosticsProperty('maxFileSize', maxFileSize))
      ..add(DiagnosticsProperty('allowedFormats', allowedFormats));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequiredDocumentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.maxFileSize, maxFileSize) ||
                other.maxFileSize == maxFileSize) &&
            const DeepCollectionEquality()
                .equals(other._allowedFormats, _allowedFormats));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      documentType,
      title,
      description,
      isRequired,
      maxFileSize,
      const DeepCollectionEquality().hash(_allowedFormats));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequiredDocumentModelImplCopyWith<_$RequiredDocumentModelImpl>
      get copyWith => __$$RequiredDocumentModelImplCopyWithImpl<
          _$RequiredDocumentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequiredDocumentModelImplToJson(
      this,
    );
  }
}

abstract class _RequiredDocumentModel implements RequiredDocumentModel {
  const factory _RequiredDocumentModel(
      {required final String id,
      @JsonKey(name: 'document_type') required final DocumentType documentType,
      required final String title,
      required final String description,
      @JsonKey(name: 'is_required') final bool isRequired,
      @JsonKey(name: 'max_file_size') final int maxFileSize,
      @JsonKey(name: 'allowed_formats')
      final List<String> allowedFormats}) = _$RequiredDocumentModelImpl;

  factory _RequiredDocumentModel.fromJson(Map<String, dynamic> json) =
      _$RequiredDocumentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'document_type')
  DocumentType get documentType;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'is_required')
  bool get isRequired;
  @override
  @JsonKey(name: 'max_file_size')
  int get maxFileSize;
  @override // 5MB
  @JsonKey(name: 'allowed_formats')
  List<String> get allowedFormats;
  @override
  @JsonKey(ignore: true)
  _$$RequiredDocumentModelImplCopyWith<_$RequiredDocumentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProfileUpdateRequest _$ProfileUpdateRequestFromJson(Map<String, dynamic> json) {
  return _ProfileUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$ProfileUpdateRequest {
  @JsonKey(name: 'full_name_ar')
  String? get fullNameAr => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name_en')
  String? get fullNameEn => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'governorate_id')
  String? get governorateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qualification_id')
  String? get qualificationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'graduation_year')
  int? get graduationYear => throw _privateConstructorUsedError;
  String? get university => throw _privateConstructorUsedError;
  String? get workplace => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileUpdateRequestCopyWith<ProfileUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileUpdateRequestCopyWith<$Res> {
  factory $ProfileUpdateRequestCopyWith(ProfileUpdateRequest value,
          $Res Function(ProfileUpdateRequest) then) =
      _$ProfileUpdateRequestCopyWithImpl<$Res, ProfileUpdateRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name_ar') String? fullNameAr,
      @JsonKey(name: 'full_name_en') String? fullNameEn,
      String? email,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'governorate_id') String? governorateId,
      @JsonKey(name: 'qualification_id') String? qualificationId,
      @JsonKey(name: 'graduation_year') int? graduationYear,
      String? university,
      String? workplace});
}

/// @nodoc
class _$ProfileUpdateRequestCopyWithImpl<$Res,
        $Val extends ProfileUpdateRequest>
    implements $ProfileUpdateRequestCopyWith<$Res> {
  _$ProfileUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullNameAr = freezed,
    Object? fullNameEn = freezed,
    Object? email = freezed,
    Object? birthDate = freezed,
    Object? governorateId = freezed,
    Object? qualificationId = freezed,
    Object? graduationYear = freezed,
    Object? university = freezed,
    Object? workplace = freezed,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileUpdateRequestImplCopyWith<$Res>
    implements $ProfileUpdateRequestCopyWith<$Res> {
  factory _$$ProfileUpdateRequestImplCopyWith(_$ProfileUpdateRequestImpl value,
          $Res Function(_$ProfileUpdateRequestImpl) then) =
      __$$ProfileUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'full_name_ar') String? fullNameAr,
      @JsonKey(name: 'full_name_en') String? fullNameEn,
      String? email,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      @JsonKey(name: 'governorate_id') String? governorateId,
      @JsonKey(name: 'qualification_id') String? qualificationId,
      @JsonKey(name: 'graduation_year') int? graduationYear,
      String? university,
      String? workplace});
}

/// @nodoc
class __$$ProfileUpdateRequestImplCopyWithImpl<$Res>
    extends _$ProfileUpdateRequestCopyWithImpl<$Res, _$ProfileUpdateRequestImpl>
    implements _$$ProfileUpdateRequestImplCopyWith<$Res> {
  __$$ProfileUpdateRequestImplCopyWithImpl(_$ProfileUpdateRequestImpl _value,
      $Res Function(_$ProfileUpdateRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullNameAr = freezed,
    Object? fullNameEn = freezed,
    Object? email = freezed,
    Object? birthDate = freezed,
    Object? governorateId = freezed,
    Object? qualificationId = freezed,
    Object? graduationYear = freezed,
    Object? university = freezed,
    Object? workplace = freezed,
  }) {
    return _then(_$ProfileUpdateRequestImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileUpdateRequestImpl
    with DiagnosticableTreeMixin
    implements _ProfileUpdateRequest {
  const _$ProfileUpdateRequestImpl(
      {@JsonKey(name: 'full_name_ar') this.fullNameAr,
      @JsonKey(name: 'full_name_en') this.fullNameEn,
      this.email,
      @JsonKey(name: 'birth_date') this.birthDate,
      @JsonKey(name: 'governorate_id') this.governorateId,
      @JsonKey(name: 'qualification_id') this.qualificationId,
      @JsonKey(name: 'graduation_year') this.graduationYear,
      this.university,
      this.workplace});

  factory _$ProfileUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileUpdateRequestImplFromJson(json);

  @override
  @JsonKey(name: 'full_name_ar')
  final String? fullNameAr;
  @override
  @JsonKey(name: 'full_name_en')
  final String? fullNameEn;
  @override
  final String? email;
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  @JsonKey(name: 'governorate_id')
  final String? governorateId;
  @override
  @JsonKey(name: 'qualification_id')
  final String? qualificationId;
  @override
  @JsonKey(name: 'graduation_year')
  final int? graduationYear;
  @override
  final String? university;
  @override
  final String? workplace;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProfileUpdateRequest(fullNameAr: $fullNameAr, fullNameEn: $fullNameEn, email: $email, birthDate: $birthDate, governorateId: $governorateId, qualificationId: $qualificationId, graduationYear: $graduationYear, university: $university, workplace: $workplace)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProfileUpdateRequest'))
      ..add(DiagnosticsProperty('fullNameAr', fullNameAr))
      ..add(DiagnosticsProperty('fullNameEn', fullNameEn))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('birthDate', birthDate))
      ..add(DiagnosticsProperty('governorateId', governorateId))
      ..add(DiagnosticsProperty('qualificationId', qualificationId))
      ..add(DiagnosticsProperty('graduationYear', graduationYear))
      ..add(DiagnosticsProperty('university', university))
      ..add(DiagnosticsProperty('workplace', workplace));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileUpdateRequestImpl &&
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
                other.workplace == workplace));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fullNameAr,
      fullNameEn,
      email,
      birthDate,
      governorateId,
      qualificationId,
      graduationYear,
      university,
      workplace);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileUpdateRequestImplCopyWith<_$ProfileUpdateRequestImpl>
      get copyWith =>
          __$$ProfileUpdateRequestImplCopyWithImpl<_$ProfileUpdateRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileUpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _ProfileUpdateRequest implements ProfileUpdateRequest {
  const factory _ProfileUpdateRequest(
      {@JsonKey(name: 'full_name_ar') final String? fullNameAr,
      @JsonKey(name: 'full_name_en') final String? fullNameEn,
      final String? email,
      @JsonKey(name: 'birth_date') final DateTime? birthDate,
      @JsonKey(name: 'governorate_id') final String? governorateId,
      @JsonKey(name: 'qualification_id') final String? qualificationId,
      @JsonKey(name: 'graduation_year') final int? graduationYear,
      final String? university,
      final String? workplace}) = _$ProfileUpdateRequestImpl;

  factory _ProfileUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$ProfileUpdateRequestImpl.fromJson;

  @override
  @JsonKey(name: 'full_name_ar')
  String? get fullNameAr;
  @override
  @JsonKey(name: 'full_name_en')
  String? get fullNameEn;
  @override
  String? get email;
  @override
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  @JsonKey(name: 'governorate_id')
  String? get governorateId;
  @override
  @JsonKey(name: 'qualification_id')
  String? get qualificationId;
  @override
  @JsonKey(name: 'graduation_year')
  int? get graduationYear;
  @override
  String? get university;
  @override
  String? get workplace;
  @override
  @JsonKey(ignore: true)
  _$$ProfileUpdateRequestImplCopyWith<_$ProfileUpdateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationRulesResponse _$VerificationRulesResponseFromJson(
    Map<String, dynamic> json) {
  return _VerificationRulesResponse.fromJson(json);
}

/// @nodoc
mixin _$VerificationRulesResponse {
  List<RequiredDocumentModel> get requiredDocuments =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'required_fields')
  List<String> get requiredFields => throw _privateConstructorUsedError;
  List<String> get rules => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRulesResponseCopyWith<VerificationRulesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRulesResponseCopyWith<$Res> {
  factory $VerificationRulesResponseCopyWith(VerificationRulesResponse value,
          $Res Function(VerificationRulesResponse) then) =
      _$VerificationRulesResponseCopyWithImpl<$Res, VerificationRulesResponse>;
  @useResult
  $Res call(
      {List<RequiredDocumentModel> requiredDocuments,
      @JsonKey(name: 'required_fields') List<String> requiredFields,
      List<String> rules});
}

/// @nodoc
class _$VerificationRulesResponseCopyWithImpl<$Res,
        $Val extends VerificationRulesResponse>
    implements $VerificationRulesResponseCopyWith<$Res> {
  _$VerificationRulesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredDocuments = null,
    Object? requiredFields = null,
    Object? rules = null,
  }) {
    return _then(_value.copyWith(
      requiredDocuments: null == requiredDocuments
          ? _value.requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<RequiredDocumentModel>,
      requiredFields: null == requiredFields
          ? _value.requiredFields
          : requiredFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationRulesResponseImplCopyWith<$Res>
    implements $VerificationRulesResponseCopyWith<$Res> {
  factory _$$VerificationRulesResponseImplCopyWith(
          _$VerificationRulesResponseImpl value,
          $Res Function(_$VerificationRulesResponseImpl) then) =
      __$$VerificationRulesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RequiredDocumentModel> requiredDocuments,
      @JsonKey(name: 'required_fields') List<String> requiredFields,
      List<String> rules});
}

/// @nodoc
class __$$VerificationRulesResponseImplCopyWithImpl<$Res>
    extends _$VerificationRulesResponseCopyWithImpl<$Res,
        _$VerificationRulesResponseImpl>
    implements _$$VerificationRulesResponseImplCopyWith<$Res> {
  __$$VerificationRulesResponseImplCopyWithImpl(
      _$VerificationRulesResponseImpl _value,
      $Res Function(_$VerificationRulesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredDocuments = null,
    Object? requiredFields = null,
    Object? rules = null,
  }) {
    return _then(_$VerificationRulesResponseImpl(
      requiredDocuments: null == requiredDocuments
          ? _value._requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<RequiredDocumentModel>,
      requiredFields: null == requiredFields
          ? _value._requiredFields
          : requiredFields // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rules: null == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRulesResponseImpl
    with DiagnosticableTreeMixin
    implements _VerificationRulesResponse {
  const _$VerificationRulesResponseImpl(
      {final List<RequiredDocumentModel> requiredDocuments = const [],
      @JsonKey(name: 'required_fields')
      final List<String> requiredFields = const [],
      final List<String> rules = const []})
      : _requiredDocuments = requiredDocuments,
        _requiredFields = requiredFields,
        _rules = rules;

  factory _$VerificationRulesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRulesResponseImplFromJson(json);

  final List<RequiredDocumentModel> _requiredDocuments;
  @override
  @JsonKey()
  List<RequiredDocumentModel> get requiredDocuments {
    if (_requiredDocuments is EqualUnmodifiableListView)
      return _requiredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredDocuments);
  }

  final List<String> _requiredFields;
  @override
  @JsonKey(name: 'required_fields')
  List<String> get requiredFields {
    if (_requiredFields is EqualUnmodifiableListView) return _requiredFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredFields);
  }

  final List<String> _rules;
  @override
  @JsonKey()
  List<String> get rules {
    if (_rules is EqualUnmodifiableListView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rules);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VerificationRulesResponse(requiredDocuments: $requiredDocuments, requiredFields: $requiredFields, rules: $rules)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VerificationRulesResponse'))
      ..add(DiagnosticsProperty('requiredDocuments', requiredDocuments))
      ..add(DiagnosticsProperty('requiredFields', requiredFields))
      ..add(DiagnosticsProperty('rules', rules));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRulesResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._requiredDocuments, _requiredDocuments) &&
            const DeepCollectionEquality()
                .equals(other._requiredFields, _requiredFields) &&
            const DeepCollectionEquality().equals(other._rules, _rules));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_requiredDocuments),
      const DeepCollectionEquality().hash(_requiredFields),
      const DeepCollectionEquality().hash(_rules));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRulesResponseImplCopyWith<_$VerificationRulesResponseImpl>
      get copyWith => __$$VerificationRulesResponseImplCopyWithImpl<
          _$VerificationRulesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRulesResponseImplToJson(
      this,
    );
  }
}

abstract class _VerificationRulesResponse implements VerificationRulesResponse {
  const factory _VerificationRulesResponse(
      {final List<RequiredDocumentModel> requiredDocuments,
      @JsonKey(name: 'required_fields') final List<String> requiredFields,
      final List<String> rules}) = _$VerificationRulesResponseImpl;

  factory _VerificationRulesResponse.fromJson(Map<String, dynamic> json) =
      _$VerificationRulesResponseImpl.fromJson;

  @override
  List<RequiredDocumentModel> get requiredDocuments;
  @override
  @JsonKey(name: 'required_fields')
  List<String> get requiredFields;
  @override
  List<String> get rules;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRulesResponseImplCopyWith<_$VerificationRulesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
