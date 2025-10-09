// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_request_model.dart';

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
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_type')
  VerificationRequestType get requestType => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_data')
  Map<String, dynamic> get newData => throw _privateConstructorUsedError;
  VerificationRequestStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_notes')
  String? get adminNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
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
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'request_type') VerificationRequestType requestType,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') Map<String, dynamic> newData,
      VerificationRequestStatus status,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
      @JsonKey(name: 'reviewed_by') String? reviewedBy,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
    Object? requestType = null,
    Object? oldData = freezed,
    Object? newData = null,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? createdAt = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
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
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as VerificationRequestType,
      oldData: freezed == oldData
          ? _value.oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: null == newData
          ? _value.newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VerificationRequestStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'request_type') VerificationRequestType requestType,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') Map<String, dynamic> newData,
      VerificationRequestStatus status,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
      @JsonKey(name: 'reviewed_by') String? reviewedBy,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
    Object? requestType = null,
    Object? oldData = freezed,
    Object? newData = null,
    Object? status = null,
    Object? adminNotes = freezed,
    Object? createdAt = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
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
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as VerificationRequestType,
      oldData: freezed == oldData
          ? _value._oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: null == newData
          ? _value._newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VerificationRequestStatus,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'request_type') required this.requestType,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') required final Map<String, dynamic> newData,
      this.status = VerificationRequestStatus.pending,
      @JsonKey(name: 'admin_notes') this.adminNotes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'reviewed_at') this.reviewedAt,
      @JsonKey(name: 'reviewed_by') this.reviewedBy,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _oldData = oldData,
        _newData = newData;

  factory _$VerificationRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerificationRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'request_type')
  final VerificationRequestType requestType;
  final Map<String, dynamic>? _oldData;
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData {
    final value = _oldData;
    if (value == null) return null;
    if (_oldData is EqualUnmodifiableMapView) return _oldData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic> _newData;
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic> get newData {
    if (_newData is EqualUnmodifiableMapView) return _newData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_newData);
  }

  @override
  @JsonKey()
  final VerificationRequestStatus status;
  @override
  @JsonKey(name: 'admin_notes')
  final String? adminNotes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'reviewed_at')
  final DateTime? reviewedAt;
  @override
  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VerificationRequestModel(id: $id, userId: $userId, requestType: $requestType, oldData: $oldData, newData: $newData, status: $status, adminNotes: $adminNotes, createdAt: $createdAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            const DeepCollectionEquality().equals(other._oldData, _oldData) &&
            const DeepCollectionEquality().equals(other._newData, _newData) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      requestType,
      const DeepCollectionEquality().hash(_oldData),
      const DeepCollectionEquality().hash(_newData),
      status,
      adminNotes,
      createdAt,
      reviewedAt,
      reviewedBy,
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
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'request_type')
      required final VerificationRequestType requestType,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') required final Map<String, dynamic> newData,
      final VerificationRequestStatus status,
      @JsonKey(name: 'admin_notes') final String? adminNotes,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'reviewed_at') final DateTime? reviewedAt,
      @JsonKey(name: 'reviewed_by') final String? reviewedBy,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$VerificationRequestModelImpl;

  factory _VerificationRequestModel.fromJson(Map<String, dynamic> json) =
      _$VerificationRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'request_type')
  VerificationRequestType get requestType;
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData;
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic> get newData;
  @override
  VerificationRequestStatus get status;
  @override
  @JsonKey(name: 'admin_notes')
  String? get adminNotes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt;
  @override
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestModelImplCopyWith<_$VerificationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SubmitVerificationRequest _$SubmitVerificationRequestFromJson(
    Map<String, dynamic> json) {
  return _SubmitVerificationRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitVerificationRequest {
  @JsonKey(name: 'request_type')
  VerificationRequestType get requestType => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_data')
  Map<String, dynamic> get newData => throw _privateConstructorUsedError;
  @JsonKey(name: 'document_ids')
  List<String> get documentIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubmitVerificationRequestCopyWith<SubmitVerificationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitVerificationRequestCopyWith<$Res> {
  factory $SubmitVerificationRequestCopyWith(SubmitVerificationRequest value,
          $Res Function(SubmitVerificationRequest) then) =
      _$SubmitVerificationRequestCopyWithImpl<$Res, SubmitVerificationRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'request_type') VerificationRequestType requestType,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') Map<String, dynamic> newData,
      @JsonKey(name: 'document_ids') List<String> documentIds});
}

/// @nodoc
class _$SubmitVerificationRequestCopyWithImpl<$Res,
        $Val extends SubmitVerificationRequest>
    implements $SubmitVerificationRequestCopyWith<$Res> {
  _$SubmitVerificationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestType = null,
    Object? oldData = freezed,
    Object? newData = null,
    Object? documentIds = null,
  }) {
    return _then(_value.copyWith(
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as VerificationRequestType,
      oldData: freezed == oldData
          ? _value.oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: null == newData
          ? _value.newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      documentIds: null == documentIds
          ? _value.documentIds
          : documentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmitVerificationRequestImplCopyWith<$Res>
    implements $SubmitVerificationRequestCopyWith<$Res> {
  factory _$$SubmitVerificationRequestImplCopyWith(
          _$SubmitVerificationRequestImpl value,
          $Res Function(_$SubmitVerificationRequestImpl) then) =
      __$$SubmitVerificationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'request_type') VerificationRequestType requestType,
      @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') Map<String, dynamic> newData,
      @JsonKey(name: 'document_ids') List<String> documentIds});
}

/// @nodoc
class __$$SubmitVerificationRequestImplCopyWithImpl<$Res>
    extends _$SubmitVerificationRequestCopyWithImpl<$Res,
        _$SubmitVerificationRequestImpl>
    implements _$$SubmitVerificationRequestImplCopyWith<$Res> {
  __$$SubmitVerificationRequestImplCopyWithImpl(
      _$SubmitVerificationRequestImpl _value,
      $Res Function(_$SubmitVerificationRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestType = null,
    Object? oldData = freezed,
    Object? newData = null,
    Object? documentIds = null,
  }) {
    return _then(_$SubmitVerificationRequestImpl(
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as VerificationRequestType,
      oldData: freezed == oldData
          ? _value._oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: null == newData
          ? _value._newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      documentIds: null == documentIds
          ? _value._documentIds
          : documentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitVerificationRequestImpl implements _SubmitVerificationRequest {
  const _$SubmitVerificationRequestImpl(
      {@JsonKey(name: 'request_type') required this.requestType,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') required final Map<String, dynamic> newData,
      @JsonKey(name: 'document_ids') final List<String> documentIds = const []})
      : _oldData = oldData,
        _newData = newData,
        _documentIds = documentIds;

  factory _$SubmitVerificationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitVerificationRequestImplFromJson(json);

  @override
  @JsonKey(name: 'request_type')
  final VerificationRequestType requestType;
  final Map<String, dynamic>? _oldData;
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData {
    final value = _oldData;
    if (value == null) return null;
    if (_oldData is EqualUnmodifiableMapView) return _oldData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic> _newData;
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic> get newData {
    if (_newData is EqualUnmodifiableMapView) return _newData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_newData);
  }

  final List<String> _documentIds;
  @override
  @JsonKey(name: 'document_ids')
  List<String> get documentIds {
    if (_documentIds is EqualUnmodifiableListView) return _documentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentIds);
  }

  @override
  String toString() {
    return 'SubmitVerificationRequest(requestType: $requestType, oldData: $oldData, newData: $newData, documentIds: $documentIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitVerificationRequestImpl &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            const DeepCollectionEquality().equals(other._oldData, _oldData) &&
            const DeepCollectionEquality().equals(other._newData, _newData) &&
            const DeepCollectionEquality()
                .equals(other._documentIds, _documentIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestType,
      const DeepCollectionEquality().hash(_oldData),
      const DeepCollectionEquality().hash(_newData),
      const DeepCollectionEquality().hash(_documentIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitVerificationRequestImplCopyWith<_$SubmitVerificationRequestImpl>
      get copyWith => __$$SubmitVerificationRequestImplCopyWithImpl<
          _$SubmitVerificationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitVerificationRequestImplToJson(
      this,
    );
  }
}

abstract class _SubmitVerificationRequest implements SubmitVerificationRequest {
  const factory _SubmitVerificationRequest(
      {@JsonKey(name: 'request_type')
      required final VerificationRequestType requestType,
      @JsonKey(name: 'old_data') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_data') required final Map<String, dynamic> newData,
      @JsonKey(name: 'document_ids')
      final List<String> documentIds}) = _$SubmitVerificationRequestImpl;

  factory _SubmitVerificationRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitVerificationRequestImpl.fromJson;

  @override
  @JsonKey(name: 'request_type')
  VerificationRequestType get requestType;
  @override
  @JsonKey(name: 'old_data')
  Map<String, dynamic>? get oldData;
  @override
  @JsonKey(name: 'new_data')
  Map<String, dynamic> get newData;
  @override
  @JsonKey(name: 'document_ids')
  List<String> get documentIds;
  @override
  @JsonKey(ignore: true)
  _$$SubmitVerificationRequestImplCopyWith<_$SubmitVerificationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerificationRequestResponse _$VerificationRequestResponseFromJson(
    Map<String, dynamic> json) {
  return _VerificationRequestResponse.fromJson(json);
}

/// @nodoc
mixin _$VerificationRequestResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_id')
  String? get requestId => throw _privateConstructorUsedError;
  VerificationRequestModel? get request => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerificationRequestResponseCopyWith<VerificationRequestResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationRequestResponseCopyWith<$Res> {
  factory $VerificationRequestResponseCopyWith(
          VerificationRequestResponse value,
          $Res Function(VerificationRequestResponse) then) =
      _$VerificationRequestResponseCopyWithImpl<$Res,
          VerificationRequestResponse>;
  @useResult
  $Res call(
      {bool success,
      String message,
      @JsonKey(name: 'request_id') String? requestId,
      VerificationRequestModel? request});

  $VerificationRequestModelCopyWith<$Res>? get request;
}

/// @nodoc
class _$VerificationRequestResponseCopyWithImpl<$Res,
        $Val extends VerificationRequestResponse>
    implements $VerificationRequestResponseCopyWith<$Res> {
  _$VerificationRequestResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? requestId = freezed,
    Object? request = freezed,
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
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as VerificationRequestModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $VerificationRequestModelCopyWith<$Res>? get request {
    if (_value.request == null) {
      return null;
    }

    return $VerificationRequestModelCopyWith<$Res>(_value.request!, (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationRequestResponseImplCopyWith<$Res>
    implements $VerificationRequestResponseCopyWith<$Res> {
  factory _$$VerificationRequestResponseImplCopyWith(
          _$VerificationRequestResponseImpl value,
          $Res Function(_$VerificationRequestResponseImpl) then) =
      __$$VerificationRequestResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      @JsonKey(name: 'request_id') String? requestId,
      VerificationRequestModel? request});

  @override
  $VerificationRequestModelCopyWith<$Res>? get request;
}

/// @nodoc
class __$$VerificationRequestResponseImplCopyWithImpl<$Res>
    extends _$VerificationRequestResponseCopyWithImpl<$Res,
        _$VerificationRequestResponseImpl>
    implements _$$VerificationRequestResponseImplCopyWith<$Res> {
  __$$VerificationRequestResponseImplCopyWithImpl(
      _$VerificationRequestResponseImpl _value,
      $Res Function(_$VerificationRequestResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? requestId = freezed,
    Object? request = freezed,
  }) {
    return _then(_$VerificationRequestResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as VerificationRequestModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerificationRequestResponseImpl
    implements _VerificationRequestResponse {
  const _$VerificationRequestResponseImpl(
      {required this.success,
      required this.message,
      @JsonKey(name: 'request_id') this.requestId,
      this.request});

  factory _$VerificationRequestResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$VerificationRequestResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  @JsonKey(name: 'request_id')
  final String? requestId;
  @override
  final VerificationRequestModel? request;

  @override
  String toString() {
    return 'VerificationRequestResponse(success: $success, message: $message, requestId: $requestId, request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationRequestResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.request, request) || other.request == request));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, message, requestId, request);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationRequestResponseImplCopyWith<_$VerificationRequestResponseImpl>
      get copyWith => __$$VerificationRequestResponseImplCopyWithImpl<
          _$VerificationRequestResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerificationRequestResponseImplToJson(
      this,
    );
  }
}

abstract class _VerificationRequestResponse
    implements VerificationRequestResponse {
  const factory _VerificationRequestResponse(
          {required final bool success,
          required final String message,
          @JsonKey(name: 'request_id') final String? requestId,
          final VerificationRequestModel? request}) =
      _$VerificationRequestResponseImpl;

  factory _VerificationRequestResponse.fromJson(Map<String, dynamic> json) =
      _$VerificationRequestResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  @JsonKey(name: 'request_id')
  String? get requestId;
  @override
  VerificationRequestModel? get request;
  @override
  @JsonKey(ignore: true)
  _$$VerificationRequestResponseImplCopyWith<_$VerificationRequestResponseImpl>
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
