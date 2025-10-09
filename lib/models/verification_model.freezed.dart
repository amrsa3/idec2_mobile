// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerificationRequestModel _$VerificationRequestModelFromJson(
    Map<String, dynamic> json) {
  return _VerificationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get documentType =>
      throw _privateConstructorUsedError; // 'license', 'certificate', 'id_card', 'passport'
  String get documentUrl => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'approved', 'rejected', 'under_review'
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRequestModelCopyWith<VerificationRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRequestModelCopyWith<$Res> {
  factory $VerificationRequestModelCopyWith(VerificationRequestModel value,
          $Res Function(VerificationRequestModel) then) =
      _$VerificationRequestModelCopyWithImpl<$Res, VerificationRequestModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String documentType,
      String documentUrl,
      String status,
      String? rejectionReason,
      String? reviewedBy,
      DateTime? reviewedAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$VerificationRequestModelCopyWithImpl<$Res,
        $Val extends VerificationRequestModel>
    implements $VerificationRequestModelCopyWith<$Res> {
  _$VerificationRequestModelCopyWithImpl(this._value, this._then);

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
    Object? documentUrl = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
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
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$VerificationRequestModelImplCopyWith<$Res>
    implements $VerificationRequestModelCopyWith<$Res> {
  factory _$$VerificationRequestModelImplCopyWith(
          _$VerificationRequestModelImpl value,
          $Res Function(_$VerificationRequestModelImpl) then) =
      __$$VerificationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String documentType,
      String documentUrl,
      String status,
      String? rejectionReason,
      String? reviewedBy,
      DateTime? reviewedAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$VerificationRequestModelImplCopyWithImpl<$Res>
    extends _$VerificationRequestModelCopyWithImpl<$Res,
        _$VerificationRequestModelImpl>
    implements _$$VerificationRequestModelImplCopyWith<$Res> {
  __$$VerificationRequestModelImplCopyWithImpl(
      _$VerificationRequestModelImpl _value,
      $Res Function(_$VerificationRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? documentType = null,
    Object? documentUrl = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VerificationRequestModelImpl(
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
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$VerificationRequestModelImpl implements _VerificationRequestModel {
  const _$VerificationRequestModelImpl(
      {required this.id,
      required this.userId,
      required this.documentType,
      required this.documentUrl,
      required this.status,
      this.rejectionReason,
      this.reviewedBy,
      this.reviewedAt,
      required this.createdAt,
      this.updatedAt});

  factory _$VerificationRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String documentType;
// 'license', 'certificate', 'id_card', 'passport'
  @override
  final String documentUrl;
  @override
  final String status;
// 'pending', 'approved', 'rejected', 'under_review'
  @override
  final String? rejectionReason;
  @override
  final String? reviewedBy;
  @override
  final DateTime? reviewedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VerificationRequestModel(id: $id, userId: $userId, documentType: $documentType, documentUrl: $documentUrl, status: $status, rejectionReason: $rejectionReason, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
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
      userId,
      documentType,
      documentUrl,
      status,
      rejectionReason,
      reviewedBy,
      reviewedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRequestModelImplCopyWith<_$VerificationRequestModelImpl>
      get copyWith => __$$VerificationRequestModelImplCopyWithImpl<
          _$VerificationRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRequestModelImplToJson(
      this,
    );
  }
}

abstract class _VerificationRequestModel implements VerificationRequestModel {
  const factory _VerificationRequestModel(
      {required final String id,
      required final String userId,
      required final String documentType,
      required final String documentUrl,
      required final String status,
      final String? rejectionReason,
      final String? reviewedBy,
      final DateTime? reviewedAt,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$VerificationRequestModelImpl;

  factory _VerificationRequestModel.fromJson(Map<String, dynamic> json) =
      _$VerificationRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get documentType;
  @override // 'license', 'certificate', 'id_card', 'passport'
  String get documentUrl;
  @override
  String get status;
  @override // 'pending', 'approved', 'rejected', 'under_review'
  String? get rejectionReason;
  @override
  String? get reviewedBy;
  @override
  DateTime? get reviewedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestModelImplCopyWith<_$VerificationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationRulesModel _$VerificationRulesModelFromJson(
    Map<String, dynamic> json) {
  return _VerificationRulesModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationRulesModel {
  List<String> get requiredDocuments => throw _privateConstructorUsedError;
  List<String> get acceptedFormats => throw _privateConstructorUsedError;
  int get maxFileSizeMB => throw _privateConstructorUsedError;
  String get instructions => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalRules =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRulesModelCopyWith<VerificationRulesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRulesModelCopyWith<$Res> {
  factory $VerificationRulesModelCopyWith(VerificationRulesModel value,
          $Res Function(VerificationRulesModel) then) =
      _$VerificationRulesModelCopyWithImpl<$Res, VerificationRulesModel>;
  @useResult
  $Res call(
      {List<String> requiredDocuments,
      List<String> acceptedFormats,
      int maxFileSizeMB,
      String instructions,
      Map<String, dynamic>? additionalRules});
}

/// @nodoc
class _$VerificationRulesModelCopyWithImpl<$Res,
        $Val extends VerificationRulesModel>
    implements $VerificationRulesModelCopyWith<$Res> {
  _$VerificationRulesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredDocuments = null,
    Object? acceptedFormats = null,
    Object? maxFileSizeMB = null,
    Object? instructions = null,
    Object? additionalRules = freezed,
  }) {
    return _then(_value.copyWith(
      requiredDocuments: null == requiredDocuments
          ? _value.requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      acceptedFormats: null == acceptedFormats
          ? _value.acceptedFormats
          : acceptedFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxFileSizeMB: null == maxFileSizeMB
          ? _value.maxFileSizeMB
          : maxFileSizeMB // ignore: cast_nullable_to_non_nullable
              as int,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      additionalRules: freezed == additionalRules
          ? _value.additionalRules
          : additionalRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerificationRulesModelImplCopyWith<$Res>
    implements $VerificationRulesModelCopyWith<$Res> {
  factory _$$VerificationRulesModelImplCopyWith(
          _$VerificationRulesModelImpl value,
          $Res Function(_$VerificationRulesModelImpl) then) =
      __$$VerificationRulesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> requiredDocuments,
      List<String> acceptedFormats,
      int maxFileSizeMB,
      String instructions,
      Map<String, dynamic>? additionalRules});
}

/// @nodoc
class __$$VerificationRulesModelImplCopyWithImpl<$Res>
    extends _$VerificationRulesModelCopyWithImpl<$Res,
        _$VerificationRulesModelImpl>
    implements _$$VerificationRulesModelImplCopyWith<$Res> {
  __$$VerificationRulesModelImplCopyWithImpl(
      _$VerificationRulesModelImpl _value,
      $Res Function(_$VerificationRulesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requiredDocuments = null,
    Object? acceptedFormats = null,
    Object? maxFileSizeMB = null,
    Object? instructions = null,
    Object? additionalRules = freezed,
  }) {
    return _then(_$VerificationRulesModelImpl(
      requiredDocuments: null == requiredDocuments
          ? _value._requiredDocuments
          : requiredDocuments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      acceptedFormats: null == acceptedFormats
          ? _value._acceptedFormats
          : acceptedFormats // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxFileSizeMB: null == maxFileSizeMB
          ? _value.maxFileSizeMB
          : maxFileSizeMB // ignore: cast_nullable_to_non_nullable
              as int,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
      additionalRules: freezed == additionalRules
          ? _value._additionalRules
          : additionalRules // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRulesModelImpl implements _VerificationRulesModel {
  const _$VerificationRulesModelImpl(
      {required final List<String> requiredDocuments,
      required final List<String> acceptedFormats,
      required this.maxFileSizeMB,
      required this.instructions,
      final Map<String, dynamic>? additionalRules})
      : _requiredDocuments = requiredDocuments,
        _acceptedFormats = acceptedFormats,
        _additionalRules = additionalRules;

  factory _$VerificationRulesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRulesModelImplFromJson(json);

  final List<String> _requiredDocuments;
  @override
  List<String> get requiredDocuments {
    if (_requiredDocuments is EqualUnmodifiableListView)
      return _requiredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredDocuments);
  }

  final List<String> _acceptedFormats;
  @override
  List<String> get acceptedFormats {
    if (_acceptedFormats is EqualUnmodifiableListView) return _acceptedFormats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_acceptedFormats);
  }

  @override
  final int maxFileSizeMB;
  @override
  final String instructions;
  final Map<String, dynamic>? _additionalRules;
  @override
  Map<String, dynamic>? get additionalRules {
    final value = _additionalRules;
    if (value == null) return null;
    if (_additionalRules is EqualUnmodifiableMapView) return _additionalRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'VerificationRulesModel(requiredDocuments: $requiredDocuments, acceptedFormats: $acceptedFormats, maxFileSizeMB: $maxFileSizeMB, instructions: $instructions, additionalRules: $additionalRules)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRulesModelImpl &&
            const DeepCollectionEquality()
                .equals(other._requiredDocuments, _requiredDocuments) &&
            const DeepCollectionEquality()
                .equals(other._acceptedFormats, _acceptedFormats) &&
            (identical(other.maxFileSizeMB, maxFileSizeMB) ||
                other.maxFileSizeMB == maxFileSizeMB) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            const DeepCollectionEquality()
                .equals(other._additionalRules, _additionalRules));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_requiredDocuments),
      const DeepCollectionEquality().hash(_acceptedFormats),
      maxFileSizeMB,
      instructions,
      const DeepCollectionEquality().hash(_additionalRules));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRulesModelImplCopyWith<_$VerificationRulesModelImpl>
      get copyWith => __$$VerificationRulesModelImplCopyWithImpl<
          _$VerificationRulesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRulesModelImplToJson(
      this,
    );
  }
}

abstract class _VerificationRulesModel implements VerificationRulesModel {
  const factory _VerificationRulesModel(
          {required final List<String> requiredDocuments,
          required final List<String> acceptedFormats,
          required final int maxFileSizeMB,
          required final String instructions,
          final Map<String, dynamic>? additionalRules}) =
      _$VerificationRulesModelImpl;

  factory _VerificationRulesModel.fromJson(Map<String, dynamic> json) =
      _$VerificationRulesModelImpl.fromJson;

  @override
  List<String> get requiredDocuments;
  @override
  List<String> get acceptedFormats;
  @override
  int get maxFileSizeMB;
  @override
  String get instructions;
  @override
  Map<String, dynamic>? get additionalRules;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRulesModelImplCopyWith<_$VerificationRulesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DocumentUploadRequest _$DocumentUploadRequestFromJson(
    Map<String, dynamic> json) {
  return _DocumentUploadRequest.fromJson(json);
}

/// @nodoc
mixin _$DocumentUploadRequest {
  String get documentType => throw _privateConstructorUsedError;
  String get fileId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DocumentUploadRequestCopyWith<DocumentUploadRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentUploadRequestCopyWith<$Res> {
  factory $DocumentUploadRequestCopyWith(DocumentUploadRequest value,
          $Res Function(DocumentUploadRequest) then) =
      _$DocumentUploadRequestCopyWithImpl<$Res, DocumentUploadRequest>;
  @useResult
  $Res call({String documentType, String fileId, String? description});
}

/// @nodoc
class _$DocumentUploadRequestCopyWithImpl<$Res,
        $Val extends DocumentUploadRequest>
    implements $DocumentUploadRequestCopyWith<$Res> {
  _$DocumentUploadRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? fileId = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DocumentUploadRequestImplCopyWith<$Res>
    implements $DocumentUploadRequestCopyWith<$Res> {
  factory _$$DocumentUploadRequestImplCopyWith(
          _$DocumentUploadRequestImpl value,
          $Res Function(_$DocumentUploadRequestImpl) then) =
      __$$DocumentUploadRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String documentType, String fileId, String? description});
}

/// @nodoc
class __$$DocumentUploadRequestImplCopyWithImpl<$Res>
    extends _$DocumentUploadRequestCopyWithImpl<$Res,
        _$DocumentUploadRequestImpl>
    implements _$$DocumentUploadRequestImplCopyWith<$Res> {
  __$$DocumentUploadRequestImplCopyWithImpl(_$DocumentUploadRequestImpl _value,
      $Res Function(_$DocumentUploadRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? fileId = null,
    Object? description = freezed,
  }) {
    return _then(_$DocumentUploadRequestImpl(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DocumentUploadRequestImpl implements _DocumentUploadRequest {
  const _$DocumentUploadRequestImpl(
      {required this.documentType, required this.fileId, this.description});

  factory _$DocumentUploadRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentUploadRequestImplFromJson(json);

  @override
  final String documentType;
  @override
  final String fileId;
  @override
  final String? description;

  @override
  String toString() {
    return 'DocumentUploadRequest(documentType: $documentType, fileId: $fileId, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentUploadRequestImpl &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentType, fileId, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentUploadRequestImplCopyWith<_$DocumentUploadRequestImpl>
      get copyWith => __$$DocumentUploadRequestImplCopyWithImpl<
          _$DocumentUploadRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentUploadRequestImplToJson(
      this,
    );
  }
}

abstract class _DocumentUploadRequest implements DocumentUploadRequest {
  const factory _DocumentUploadRequest(
      {required final String documentType,
      required final String fileId,
      final String? description}) = _$DocumentUploadRequestImpl;

  factory _DocumentUploadRequest.fromJson(Map<String, dynamic> json) =
      _$DocumentUploadRequestImpl.fromJson;

  @override
  String get documentType;
  @override
  String get fileId;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$DocumentUploadRequestImplCopyWith<_$DocumentUploadRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationRequestsResponseModel _$VerificationRequestsResponseModelFromJson(
    Map<String, dynamic> json) {
  return _VerificationRequestsResponseModel.fromJson(json);
}

/// @nodoc
mixin _$VerificationRequestsResponseModel {
  List<VerificationRequestModel> get data => throw _privateConstructorUsedError;
  PaginationModel get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRequestsResponseModelCopyWith<VerificationRequestsResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRequestsResponseModelCopyWith<$Res> {
  factory $VerificationRequestsResponseModelCopyWith(
          VerificationRequestsResponseModel value,
          $Res Function(VerificationRequestsResponseModel) then) =
      _$VerificationRequestsResponseModelCopyWithImpl<$Res,
          VerificationRequestsResponseModel>;
  @useResult
  $Res call({List<VerificationRequestModel> data, PaginationModel pagination});

  $PaginationModelCopyWith<$Res> get pagination;
}

/// @nodoc
class _$VerificationRequestsResponseModelCopyWithImpl<$Res,
        $Val extends VerificationRequestsResponseModel>
    implements $VerificationRequestsResponseModelCopyWith<$Res> {
  _$VerificationRequestsResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<VerificationRequestModel>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationModelCopyWith<$Res> get pagination {
    return $PaginationModelCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationRequestsResponseModelImplCopyWith<$Res>
    implements $VerificationRequestsResponseModelCopyWith<$Res> {
  factory _$$VerificationRequestsResponseModelImplCopyWith(
          _$VerificationRequestsResponseModelImpl value,
          $Res Function(_$VerificationRequestsResponseModelImpl) then) =
      __$$VerificationRequestsResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<VerificationRequestModel> data, PaginationModel pagination});

  @override
  $PaginationModelCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$VerificationRequestsResponseModelImplCopyWithImpl<$Res>
    extends _$VerificationRequestsResponseModelCopyWithImpl<$Res,
        _$VerificationRequestsResponseModelImpl>
    implements _$$VerificationRequestsResponseModelImplCopyWith<$Res> {
  __$$VerificationRequestsResponseModelImplCopyWithImpl(
      _$VerificationRequestsResponseModelImpl _value,
      $Res Function(_$VerificationRequestsResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pagination = null,
  }) {
    return _then(_$VerificationRequestsResponseModelImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<VerificationRequestModel>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRequestsResponseModelImpl
    implements _VerificationRequestsResponseModel {
  const _$VerificationRequestsResponseModelImpl(
      {required final List<VerificationRequestModel> data,
      required this.pagination})
      : _data = data;

  factory _$VerificationRequestsResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$VerificationRequestsResponseModelImplFromJson(json);

  final List<VerificationRequestModel> _data;
  @override
  List<VerificationRequestModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PaginationModel pagination;

  @override
  String toString() {
    return 'VerificationRequestsResponseModel(data: $data, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestsResponseModelImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRequestsResponseModelImplCopyWith<
          _$VerificationRequestsResponseModelImpl>
      get copyWith => __$$VerificationRequestsResponseModelImplCopyWithImpl<
          _$VerificationRequestsResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRequestsResponseModelImplToJson(
      this,
    );
  }
}

abstract class _VerificationRequestsResponseModel
    implements VerificationRequestsResponseModel {
  const factory _VerificationRequestsResponseModel(
          {required final List<VerificationRequestModel> data,
          required final PaginationModel pagination}) =
      _$VerificationRequestsResponseModelImpl;

  factory _VerificationRequestsResponseModel.fromJson(
          Map<String, dynamic> json) =
      _$VerificationRequestsResponseModelImpl.fromJson;

  @override
  List<VerificationRequestModel> get data;
  @override
  PaginationModel get pagination;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestsResponseModelImplCopyWith<
          _$VerificationRequestsResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) {
  return _PaginationModel.fromJson(json);
}

/// @nodoc
mixin _$PaginationModel {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;
  bool get hasPrev => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationModelCopyWith<PaginationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationModelCopyWith<$Res> {
  factory $PaginationModelCopyWith(
          PaginationModel value, $Res Function(PaginationModel) then) =
      _$PaginationModelCopyWithImpl<$Res, PaginationModel>;
  @useResult
  $Res call(
      {int page,
      int limit,
      int total,
      int totalPages,
      bool hasNext,
      bool hasPrev});
}

/// @nodoc
class _$PaginationModelCopyWithImpl<$Res, $Val extends PaginationModel>
    implements $PaginationModelCopyWith<$Res> {
  _$PaginationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationModelImplCopyWith<$Res>
    implements $PaginationModelCopyWith<$Res> {
  factory _$$PaginationModelImplCopyWith(_$PaginationModelImpl value,
          $Res Function(_$PaginationModelImpl) then) =
      __$$PaginationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int limit,
      int total,
      int totalPages,
      bool hasNext,
      bool hasPrev});
}

/// @nodoc
class __$$PaginationModelImplCopyWithImpl<$Res>
    extends _$PaginationModelCopyWithImpl<$Res, _$PaginationModelImpl>
    implements _$$PaginationModelImplCopyWith<$Res> {
  __$$PaginationModelImplCopyWithImpl(
      _$PaginationModelImpl _value, $Res Function(_$PaginationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_$PaginationModelImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationModelImpl implements _PaginationModel {
  const _$PaginationModelImpl(
      {required this.page,
      required this.limit,
      required this.total,
      required this.totalPages,
      required this.hasNext,
      required this.hasPrev});

  factory _$PaginationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationModelImplFromJson(json);

  @override
  final int page;
  @override
  final int limit;
  @override
  final int total;
  @override
  final int totalPages;
  @override
  final bool hasNext;
  @override
  final bool hasPrev;

  @override
  String toString() {
    return 'PaginationModel(page: $page, limit: $limit, total: $total, totalPages: $totalPages, hasNext: $hasNext, hasPrev: $hasPrev)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationModelImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrev, hasPrev) || other.hasPrev == hasPrev));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, page, limit, total, totalPages, hasNext, hasPrev);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationModelImplCopyWith<_$PaginationModelImpl> get copyWith =>
      __$$PaginationModelImplCopyWithImpl<_$PaginationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationModelImplToJson(
      this,
    );
  }
}

abstract class _PaginationModel implements PaginationModel {
  const factory _PaginationModel(
      {required final int page,
      required final int limit,
      required final int total,
      required final int totalPages,
      required final bool hasNext,
      required final bool hasPrev}) = _$PaginationModelImpl;

  factory _PaginationModel.fromJson(Map<String, dynamic> json) =
      _$PaginationModelImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  int get totalPages;
  @override
  bool get hasNext;
  @override
  bool get hasPrev;
  @override
  @JsonKey(ignore: true)
  _$$PaginationModelImplCopyWith<_$PaginationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitVerificationRequestModel _$SubmitVerificationRequestModelFromJson(
    Map<String, dynamic> json) {
  return _SubmitVerificationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$SubmitVerificationRequestModel {
  String get documentType => throw _privateConstructorUsedError;
  String get documentUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitVerificationRequestModelCopyWith<SubmitVerificationRequestModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitVerificationRequestModelCopyWith<$Res> {
  factory $SubmitVerificationRequestModelCopyWith(
          SubmitVerificationRequestModel value,
          $Res Function(SubmitVerificationRequestModel) then) =
      _$SubmitVerificationRequestModelCopyWithImpl<$Res,
          SubmitVerificationRequestModel>;
  @useResult
  $Res call({String documentType, String documentUrl, String? description});
}

/// @nodoc
class _$SubmitVerificationRequestModelCopyWithImpl<$Res,
        $Val extends SubmitVerificationRequestModel>
    implements $SubmitVerificationRequestModelCopyWith<$Res> {
  _$SubmitVerificationRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? documentUrl = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmitVerificationRequestModelImplCopyWith<$Res>
    implements $SubmitVerificationRequestModelCopyWith<$Res> {
  factory _$$SubmitVerificationRequestModelImplCopyWith(
          _$SubmitVerificationRequestModelImpl value,
          $Res Function(_$SubmitVerificationRequestModelImpl) then) =
      __$$SubmitVerificationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String documentType, String documentUrl, String? description});
}

/// @nodoc
class __$$SubmitVerificationRequestModelImplCopyWithImpl<$Res>
    extends _$SubmitVerificationRequestModelCopyWithImpl<$Res,
        _$SubmitVerificationRequestModelImpl>
    implements _$$SubmitVerificationRequestModelImplCopyWith<$Res> {
  __$$SubmitVerificationRequestModelImplCopyWithImpl(
      _$SubmitVerificationRequestModelImpl _value,
      $Res Function(_$SubmitVerificationRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentType = null,
    Object? documentUrl = null,
    Object? description = freezed,
  }) {
    return _then(_$SubmitVerificationRequestModelImpl(
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      documentUrl: null == documentUrl
          ? _value.documentUrl
          : documentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitVerificationRequestModelImpl
    implements _SubmitVerificationRequestModel {
  const _$SubmitVerificationRequestModelImpl(
      {required this.documentType,
      required this.documentUrl,
      this.description});

  factory _$SubmitVerificationRequestModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SubmitVerificationRequestModelImplFromJson(json);

  @override
  final String documentType;
  @override
  final String documentUrl;
  @override
  final String? description;

  @override
  String toString() {
    return 'SubmitVerificationRequestModel(documentType: $documentType, documentUrl: $documentUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitVerificationRequestModelImpl &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.documentUrl, documentUrl) ||
                other.documentUrl == documentUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentType, documentUrl, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitVerificationRequestModelImplCopyWith<
          _$SubmitVerificationRequestModelImpl>
      get copyWith => __$$SubmitVerificationRequestModelImplCopyWithImpl<
          _$SubmitVerificationRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitVerificationRequestModelImplToJson(
      this,
    );
  }
}

abstract class _SubmitVerificationRequestModel
    implements SubmitVerificationRequestModel {
  const factory _SubmitVerificationRequestModel(
      {required final String documentType,
      required final String documentUrl,
      final String? description}) = _$SubmitVerificationRequestModelImpl;

  factory _SubmitVerificationRequestModel.fromJson(Map<String, dynamic> json) =
      _$SubmitVerificationRequestModelImpl.fromJson;

  @override
  String get documentType;
  @override
  String get documentUrl;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$SubmitVerificationRequestModelImplCopyWith<
          _$SubmitVerificationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RejectVerificationRequestModel _$RejectVerificationRequestModelFromJson(
    Map<String, dynamic> json) {
  return _RejectVerificationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RejectVerificationRequestModel {
  String get reason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RejectVerificationRequestModelCopyWith<RejectVerificationRequestModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectVerificationRequestModelCopyWith<$Res> {
  factory $RejectVerificationRequestModelCopyWith(
          RejectVerificationRequestModel value,
          $Res Function(RejectVerificationRequestModel) then) =
      _$RejectVerificationRequestModelCopyWithImpl<$Res,
          RejectVerificationRequestModel>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class _$RejectVerificationRequestModelCopyWithImpl<$Res,
        $Val extends RejectVerificationRequestModel>
    implements $RejectVerificationRequestModelCopyWith<$Res> {
  _$RejectVerificationRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_value.copyWith(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectVerificationRequestModelImplCopyWith<$Res>
    implements $RejectVerificationRequestModelCopyWith<$Res> {
  factory _$$RejectVerificationRequestModelImplCopyWith(
          _$RejectVerificationRequestModelImpl value,
          $Res Function(_$RejectVerificationRequestModelImpl) then) =
      __$$RejectVerificationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$RejectVerificationRequestModelImplCopyWithImpl<$Res>
    extends _$RejectVerificationRequestModelCopyWithImpl<$Res,
        _$RejectVerificationRequestModelImpl>
    implements _$$RejectVerificationRequestModelImplCopyWith<$Res> {
  __$$RejectVerificationRequestModelImplCopyWithImpl(
      _$RejectVerificationRequestModelImpl _value,
      $Res Function(_$RejectVerificationRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$RejectVerificationRequestModelImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectVerificationRequestModelImpl
    implements _RejectVerificationRequestModel {
  const _$RejectVerificationRequestModelImpl({required this.reason});

  factory _$RejectVerificationRequestModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RejectVerificationRequestModelImplFromJson(json);

  @override
  final String reason;

  @override
  String toString() {
    return 'RejectVerificationRequestModel(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectVerificationRequestModelImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectVerificationRequestModelImplCopyWith<
          _$RejectVerificationRequestModelImpl>
      get copyWith => __$$RejectVerificationRequestModelImplCopyWithImpl<
          _$RejectVerificationRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectVerificationRequestModelImplToJson(
      this,
    );
  }
}

abstract class _RejectVerificationRequestModel
    implements RejectVerificationRequestModel {
  const factory _RejectVerificationRequestModel(
      {required final String reason}) = _$RejectVerificationRequestModelImpl;

  factory _RejectVerificationRequestModel.fromJson(Map<String, dynamic> json) =
      _$RejectVerificationRequestModelImpl.fromJson;

  @override
  String get reason;
  @override
  @JsonKey(ignore: true)
  _$$RejectVerificationRequestModelImplCopyWith<
          _$RejectVerificationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
