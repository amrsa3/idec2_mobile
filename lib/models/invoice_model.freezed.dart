// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) {
  return _InvoiceModel.fromJson(json);
}

/// @nodoc
mixin _$InvoiceModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoiceNumber')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'registrationId')
  String? get registrationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'eventId')
  String? get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conferenceId')
  String? get conferenceId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // UNPAID, PAID, CANCELLED
  String get description => throw _privateConstructorUsedError;
  @DecimalConverter()
  @JsonKey(name: 'amountDue')
  double get amountDue => throw _privateConstructorUsedError;
  @JsonKey(name: 'currencyCode')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'issueDate')
  DateTime get issueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'dueDate')
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'revenueType')
  String get revenueType => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'event')
  Map<String, dynamic>? get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'conference')
  Map<String, dynamic>? get conference => throw _privateConstructorUsedError;
  @JsonKey(name: 'registration')
  Map<String, dynamic>? get registration => throw _privateConstructorUsedError;
  @JsonKey(name: 'transactions')
  List<Map<String, dynamic>>? get transactions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceModelCopyWith<InvoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceModelCopyWith<$Res> {
  factory $InvoiceModelCopyWith(
          InvoiceModel value, $Res Function(InvoiceModel) then) =
      _$InvoiceModelCopyWithImpl<$Res, InvoiceModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'invoiceNumber') String invoiceNumber,
      @JsonKey(name: 'userId') String userId,
      @JsonKey(name: 'registrationId') String? registrationId,
      @JsonKey(name: 'eventId') String? eventId,
      @JsonKey(name: 'conferenceId') String? conferenceId,
      String status,
      String description,
      @DecimalConverter() @JsonKey(name: 'amountDue') double amountDue,
      @JsonKey(name: 'currencyCode') String currencyCode,
      @JsonKey(name: 'issueDate') DateTime issueDate,
      @JsonKey(name: 'dueDate') DateTime? dueDate,
      @JsonKey(name: 'revenueType') String revenueType,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: 'user') Map<String, dynamic>? user,
      @JsonKey(name: 'event') Map<String, dynamic>? event,
      @JsonKey(name: 'conference') Map<String, dynamic>? conference,
      @JsonKey(name: 'registration') Map<String, dynamic>? registration,
      @JsonKey(name: 'transactions') List<Map<String, dynamic>>? transactions});
}

/// @nodoc
class _$InvoiceModelCopyWithImpl<$Res, $Val extends InvoiceModel>
    implements $InvoiceModelCopyWith<$Res> {
  _$InvoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? userId = null,
    Object? registrationId = freezed,
    Object? eventId = freezed,
    Object? conferenceId = freezed,
    Object? status = null,
    Object? description = null,
    Object? amountDue = null,
    Object? currencyCode = null,
    Object? issueDate = null,
    Object? dueDate = freezed,
    Object? revenueType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? event = freezed,
    Object? conference = freezed,
    Object? registration = freezed,
    Object? transactions = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      registrationId: freezed == registrationId
          ? _value.registrationId
          : registrationId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      conferenceId: freezed == conferenceId
          ? _value.conferenceId
          : conferenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountDue: null == amountDue
          ? _value.amountDue
          : amountDue // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: null == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revenueType: null == revenueType
          ? _value.revenueType
          : revenueType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      conference: freezed == conference
          ? _value.conference
          : conference // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      registration: freezed == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      transactions: freezed == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceModelImplCopyWith<$Res>
    implements $InvoiceModelCopyWith<$Res> {
  factory _$$InvoiceModelImplCopyWith(
          _$InvoiceModelImpl value, $Res Function(_$InvoiceModelImpl) then) =
      __$$InvoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'invoiceNumber') String invoiceNumber,
      @JsonKey(name: 'userId') String userId,
      @JsonKey(name: 'registrationId') String? registrationId,
      @JsonKey(name: 'eventId') String? eventId,
      @JsonKey(name: 'conferenceId') String? conferenceId,
      String status,
      String description,
      @DecimalConverter() @JsonKey(name: 'amountDue') double amountDue,
      @JsonKey(name: 'currencyCode') String currencyCode,
      @JsonKey(name: 'issueDate') DateTime issueDate,
      @JsonKey(name: 'dueDate') DateTime? dueDate,
      @JsonKey(name: 'revenueType') String revenueType,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: 'user') Map<String, dynamic>? user,
      @JsonKey(name: 'event') Map<String, dynamic>? event,
      @JsonKey(name: 'conference') Map<String, dynamic>? conference,
      @JsonKey(name: 'registration') Map<String, dynamic>? registration,
      @JsonKey(name: 'transactions') List<Map<String, dynamic>>? transactions});
}

/// @nodoc
class __$$InvoiceModelImplCopyWithImpl<$Res>
    extends _$InvoiceModelCopyWithImpl<$Res, _$InvoiceModelImpl>
    implements _$$InvoiceModelImplCopyWith<$Res> {
  __$$InvoiceModelImplCopyWithImpl(
      _$InvoiceModelImpl _value, $Res Function(_$InvoiceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? userId = null,
    Object? registrationId = freezed,
    Object? eventId = freezed,
    Object? conferenceId = freezed,
    Object? status = null,
    Object? description = null,
    Object? amountDue = null,
    Object? currencyCode = null,
    Object? issueDate = null,
    Object? dueDate = freezed,
    Object? revenueType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? event = freezed,
    Object? conference = freezed,
    Object? registration = freezed,
    Object? transactions = freezed,
  }) {
    return _then(_$InvoiceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      registrationId: freezed == registrationId
          ? _value.registrationId
          : registrationId // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      conferenceId: freezed == conferenceId
          ? _value.conferenceId
          : conferenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amountDue: null == amountDue
          ? _value.amountDue
          : amountDue // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: null == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      revenueType: null == revenueType
          ? _value.revenueType
          : revenueType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _value._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      event: freezed == event
          ? _value._event
          : event // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      conference: freezed == conference
          ? _value._conference
          : conference // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      registration: freezed == registration
          ? _value._registration
          : registration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      transactions: freezed == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceModelImpl implements _InvoiceModel {
  const _$InvoiceModelImpl(
      {required this.id,
      @JsonKey(name: 'invoiceNumber') required this.invoiceNumber,
      @JsonKey(name: 'userId') required this.userId,
      @JsonKey(name: 'registrationId') this.registrationId,
      @JsonKey(name: 'eventId') this.eventId,
      @JsonKey(name: 'conferenceId') this.conferenceId,
      required this.status,
      required this.description,
      @DecimalConverter() @JsonKey(name: 'amountDue') required this.amountDue,
      @JsonKey(name: 'currencyCode') required this.currencyCode,
      @JsonKey(name: 'issueDate') required this.issueDate,
      @JsonKey(name: 'dueDate') this.dueDate,
      @JsonKey(name: 'revenueType') required this.revenueType,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      @JsonKey(name: 'user') final Map<String, dynamic>? user,
      @JsonKey(name: 'event') final Map<String, dynamic>? event,
      @JsonKey(name: 'conference') final Map<String, dynamic>? conference,
      @JsonKey(name: 'registration') final Map<String, dynamic>? registration,
      @JsonKey(name: 'transactions')
      final List<Map<String, dynamic>>? transactions})
      : _user = user,
        _event = event,
        _conference = conference,
        _registration = registration,
        _transactions = transactions;

  factory _$InvoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'invoiceNumber')
  final String invoiceNumber;
  @override
  @JsonKey(name: 'userId')
  final String userId;
  @override
  @JsonKey(name: 'registrationId')
  final String? registrationId;
  @override
  @JsonKey(name: 'eventId')
  final String? eventId;
  @override
  @JsonKey(name: 'conferenceId')
  final String? conferenceId;
  @override
  final String status;
// UNPAID, PAID, CANCELLED
  @override
  final String description;
  @override
  @DecimalConverter()
  @JsonKey(name: 'amountDue')
  final double amountDue;
  @override
  @JsonKey(name: 'currencyCode')
  final String currencyCode;
  @override
  @JsonKey(name: 'issueDate')
  final DateTime issueDate;
  @override
  @JsonKey(name: 'dueDate')
  final DateTime? dueDate;
  @override
  @JsonKey(name: 'revenueType')
  final String revenueType;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
// Relations
  final Map<String, dynamic>? _user;
// Relations
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user {
    final value = _user;
    if (value == null) return null;
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _event;
  @override
  @JsonKey(name: 'event')
  Map<String, dynamic>? get event {
    final value = _event;
    if (value == null) return null;
    if (_event is EqualUnmodifiableMapView) return _event;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _conference;
  @override
  @JsonKey(name: 'conference')
  Map<String, dynamic>? get conference {
    final value = _conference;
    if (value == null) return null;
    if (_conference is EqualUnmodifiableMapView) return _conference;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _registration;
  @override
  @JsonKey(name: 'registration')
  Map<String, dynamic>? get registration {
    final value = _registration;
    if (value == null) return null;
    if (_registration is EqualUnmodifiableMapView) return _registration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Map<String, dynamic>>? _transactions;
  @override
  @JsonKey(name: 'transactions')
  List<Map<String, dynamic>>? get transactions {
    final value = _transactions;
    if (value == null) return null;
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'InvoiceModel(id: $id, invoiceNumber: $invoiceNumber, userId: $userId, registrationId: $registrationId, eventId: $eventId, conferenceId: $conferenceId, status: $status, description: $description, amountDue: $amountDue, currencyCode: $currencyCode, issueDate: $issueDate, dueDate: $dueDate, revenueType: $revenueType, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, event: $event, conference: $conference, registration: $registration, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.registrationId, registrationId) ||
                other.registrationId == registrationId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.conferenceId, conferenceId) ||
                other.conferenceId == conferenceId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amountDue, amountDue) ||
                other.amountDue == amountDue) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.revenueType, revenueType) ||
                other.revenueType == revenueType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._user, _user) &&
            const DeepCollectionEquality().equals(other._event, _event) &&
            const DeepCollectionEquality()
                .equals(other._conference, _conference) &&
            const DeepCollectionEquality()
                .equals(other._registration, _registration) &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        invoiceNumber,
        userId,
        registrationId,
        eventId,
        conferenceId,
        status,
        description,
        amountDue,
        currencyCode,
        issueDate,
        dueDate,
        revenueType,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_user),
        const DeepCollectionEquality().hash(_event),
        const DeepCollectionEquality().hash(_conference),
        const DeepCollectionEquality().hash(_registration),
        const DeepCollectionEquality().hash(_transactions)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceModelImplCopyWith<_$InvoiceModelImpl> get copyWith =>
      __$$InvoiceModelImplCopyWithImpl<_$InvoiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceModelImplToJson(
      this,
    );
  }
}

abstract class _InvoiceModel implements InvoiceModel {
  const factory _InvoiceModel(
      {required final String id,
      @JsonKey(name: 'invoiceNumber') required final String invoiceNumber,
      @JsonKey(name: 'userId') required final String userId,
      @JsonKey(name: 'registrationId') final String? registrationId,
      @JsonKey(name: 'eventId') final String? eventId,
      @JsonKey(name: 'conferenceId') final String? conferenceId,
      required final String status,
      required final String description,
      @DecimalConverter()
      @JsonKey(name: 'amountDue')
      required final double amountDue,
      @JsonKey(name: 'currencyCode') required final String currencyCode,
      @JsonKey(name: 'issueDate') required final DateTime issueDate,
      @JsonKey(name: 'dueDate') final DateTime? dueDate,
      @JsonKey(name: 'revenueType') required final String revenueType,
      @JsonKey(name: 'createdAt') required final DateTime createdAt,
      @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
      @JsonKey(name: 'user') final Map<String, dynamic>? user,
      @JsonKey(name: 'event') final Map<String, dynamic>? event,
      @JsonKey(name: 'conference') final Map<String, dynamic>? conference,
      @JsonKey(name: 'registration') final Map<String, dynamic>? registration,
      @JsonKey(name: 'transactions')
      final List<Map<String, dynamic>>? transactions}) = _$InvoiceModelImpl;

  factory _InvoiceModel.fromJson(Map<String, dynamic> json) =
      _$InvoiceModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'invoiceNumber')
  String get invoiceNumber;
  @override
  @JsonKey(name: 'userId')
  String get userId;
  @override
  @JsonKey(name: 'registrationId')
  String? get registrationId;
  @override
  @JsonKey(name: 'eventId')
  String? get eventId;
  @override
  @JsonKey(name: 'conferenceId')
  String? get conferenceId;
  @override
  String get status;
  @override // UNPAID, PAID, CANCELLED
  String get description;
  @override
  @DecimalConverter()
  @JsonKey(name: 'amountDue')
  double get amountDue;
  @override
  @JsonKey(name: 'currencyCode')
  String get currencyCode;
  @override
  @JsonKey(name: 'issueDate')
  DateTime get issueDate;
  @override
  @JsonKey(name: 'dueDate')
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'revenueType')
  String get revenueType;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override // Relations
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user;
  @override
  @JsonKey(name: 'event')
  Map<String, dynamic>? get event;
  @override
  @JsonKey(name: 'conference')
  Map<String, dynamic>? get conference;
  @override
  @JsonKey(name: 'registration')
  Map<String, dynamic>? get registration;
  @override
  @JsonKey(name: 'transactions')
  List<Map<String, dynamic>>? get transactions;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceModelImplCopyWith<_$InvoiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
