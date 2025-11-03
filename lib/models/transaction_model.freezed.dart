// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoiceId')
  String get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentMethod')
  String get paymentMethod =>
      throw _privateConstructorUsedError; // ELECTRONIC, CASH
  @DecimalConverter()
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'currencyCode')
  String get currencyCode => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError; // PAYMENT, REFUND, FEE
  String get status =>
      throw _privateConstructorUsedError; // PENDING, SUCCESSFUL, FAILED, CANCELLED
  @JsonKey(name: 'gatewayId')
  String? get gatewayId => throw _privateConstructorUsedError;
  @JsonKey(name: 'gatewayRequestId')
  String? get gatewayRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'gatewayTransactionId')
  String? get gatewayTransactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'timestampInitiated')
  DateTime get timestampInitiated => throw _privateConstructorUsedError;
  @JsonKey(name: 'timestampCompleted')
  DateTime? get timestampCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'errorCode')
  String? get errorCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'errorMessage')
  String? get errorMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes')
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError; // Relations
  @JsonKey(name: 'gateway')
  Map<String, dynamic>? get gateway => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice')
  Map<String, dynamic>? get invoice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
          TransactionModel value, $Res Function(TransactionModel) then) =
      _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'userId') String userId,
      @JsonKey(name: 'invoiceId') String invoiceId,
      @JsonKey(name: 'paymentMethod') String paymentMethod,
      @DecimalConverter() double amount,
      @JsonKey(name: 'currencyCode') String currencyCode,
      String type,
      String status,
      @JsonKey(name: 'gatewayId') String? gatewayId,
      @JsonKey(name: 'gatewayRequestId') String? gatewayRequestId,
      @JsonKey(name: 'gatewayTransactionId') String? gatewayTransactionId,
      @JsonKey(name: 'timestampInitiated') DateTime timestampInitiated,
      @JsonKey(name: 'timestampCompleted') DateTime? timestampCompleted,
      @JsonKey(name: 'errorCode') String? errorCode,
      @JsonKey(name: 'errorMessage') String? errorMessage,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: 'gateway') Map<String, dynamic>? gateway,
      @JsonKey(name: 'invoice') Map<String, dynamic>? invoice});
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? invoiceId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? currencyCode = null,
    Object? type = null,
    Object? status = null,
    Object? gatewayId = freezed,
    Object? gatewayRequestId = freezed,
    Object? gatewayTransactionId = freezed,
    Object? timestampInitiated = null,
    Object? timestampCompleted = freezed,
    Object? errorCode = freezed,
    Object? errorMessage = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? gateway = freezed,
    Object? invoice = freezed,
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
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      gatewayId: freezed == gatewayId
          ? _value.gatewayId
          : gatewayId // ignore: cast_nullable_to_non_nullable
              as String?,
      gatewayRequestId: freezed == gatewayRequestId
          ? _value.gatewayRequestId
          : gatewayRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      gatewayTransactionId: freezed == gatewayTransactionId
          ? _value.gatewayTransactionId
          : gatewayTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestampInitiated: null == timestampInitiated
          ? _value.timestampInitiated
          : timestampInitiated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timestampCompleted: freezed == timestampCompleted
          ? _value.timestampCompleted
          : timestampCompleted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      invoice: freezed == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(_$TransactionModelImpl value,
          $Res Function(_$TransactionModelImpl) then) =
      __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'userId') String userId,
      @JsonKey(name: 'invoiceId') String invoiceId,
      @JsonKey(name: 'paymentMethod') String paymentMethod,
      @DecimalConverter() double amount,
      @JsonKey(name: 'currencyCode') String currencyCode,
      String type,
      String status,
      @JsonKey(name: 'gatewayId') String? gatewayId,
      @JsonKey(name: 'gatewayRequestId') String? gatewayRequestId,
      @JsonKey(name: 'gatewayTransactionId') String? gatewayTransactionId,
      @JsonKey(name: 'timestampInitiated') DateTime timestampInitiated,
      @JsonKey(name: 'timestampCompleted') DateTime? timestampCompleted,
      @JsonKey(name: 'errorCode') String? errorCode,
      @JsonKey(name: 'errorMessage') String? errorMessage,
      @JsonKey(name: 'notes') String? notes,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: 'gateway') Map<String, dynamic>? gateway,
      @JsonKey(name: 'invoice') Map<String, dynamic>? invoice});
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(_$TransactionModelImpl _value,
      $Res Function(_$TransactionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? invoiceId = null,
    Object? paymentMethod = null,
    Object? amount = null,
    Object? currencyCode = null,
    Object? type = null,
    Object? status = null,
    Object? gatewayId = freezed,
    Object? gatewayRequestId = freezed,
    Object? gatewayTransactionId = freezed,
    Object? timestampInitiated = null,
    Object? timestampCompleted = freezed,
    Object? errorCode = freezed,
    Object? errorMessage = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? gateway = freezed,
    Object? invoice = freezed,
  }) {
    return _then(_$TransactionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      gatewayId: freezed == gatewayId
          ? _value.gatewayId
          : gatewayId // ignore: cast_nullable_to_non_nullable
              as String?,
      gatewayRequestId: freezed == gatewayRequestId
          ? _value.gatewayRequestId
          : gatewayRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      gatewayTransactionId: freezed == gatewayTransactionId
          ? _value.gatewayTransactionId
          : gatewayTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestampInitiated: null == timestampInitiated
          ? _value.timestampInitiated
          : timestampInitiated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timestampCompleted: freezed == timestampCompleted
          ? _value.timestampCompleted
          : timestampCompleted // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gateway: freezed == gateway
          ? _value._gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      invoice: freezed == invoice
          ? _value._invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl(
      {required this.id,
      @JsonKey(name: 'userId') required this.userId,
      @JsonKey(name: 'invoiceId') required this.invoiceId,
      @JsonKey(name: 'paymentMethod') required this.paymentMethod,
      @DecimalConverter() required this.amount,
      @JsonKey(name: 'currencyCode') required this.currencyCode,
      required this.type,
      required this.status,
      @JsonKey(name: 'gatewayId') this.gatewayId,
      @JsonKey(name: 'gatewayRequestId') this.gatewayRequestId,
      @JsonKey(name: 'gatewayTransactionId') this.gatewayTransactionId,
      @JsonKey(name: 'timestampInitiated') required this.timestampInitiated,
      @JsonKey(name: 'timestampCompleted') this.timestampCompleted,
      @JsonKey(name: 'errorCode') this.errorCode,
      @JsonKey(name: 'errorMessage') this.errorMessage,
      @JsonKey(name: 'notes') this.notes,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      @JsonKey(name: 'gateway') final Map<String, dynamic>? gateway,
      @JsonKey(name: 'invoice') final Map<String, dynamic>? invoice})
      : _gateway = gateway,
        _invoice = invoice;

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'userId')
  final String userId;
  @override
  @JsonKey(name: 'invoiceId')
  final String invoiceId;
  @override
  @JsonKey(name: 'paymentMethod')
  final String paymentMethod;
// ELECTRONIC, CASH
  @override
  @DecimalConverter()
  final double amount;
  @override
  @JsonKey(name: 'currencyCode')
  final String currencyCode;
  @override
  final String type;
// PAYMENT, REFUND, FEE
  @override
  final String status;
// PENDING, SUCCESSFUL, FAILED, CANCELLED
  @override
  @JsonKey(name: 'gatewayId')
  final String? gatewayId;
  @override
  @JsonKey(name: 'gatewayRequestId')
  final String? gatewayRequestId;
  @override
  @JsonKey(name: 'gatewayTransactionId')
  final String? gatewayTransactionId;
  @override
  @JsonKey(name: 'timestampInitiated')
  final DateTime timestampInitiated;
  @override
  @JsonKey(name: 'timestampCompleted')
  final DateTime? timestampCompleted;
  @override
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @override
  @JsonKey(name: 'errorMessage')
  final String? errorMessage;
  @override
  @JsonKey(name: 'notes')
  final String? notes;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
// Relations
  final Map<String, dynamic>? _gateway;
// Relations
  @override
  @JsonKey(name: 'gateway')
  Map<String, dynamic>? get gateway {
    final value = _gateway;
    if (value == null) return null;
    if (_gateway is EqualUnmodifiableMapView) return _gateway;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _invoice;
  @override
  @JsonKey(name: 'invoice')
  Map<String, dynamic>? get invoice {
    final value = _invoice;
    if (value == null) return null;
    if (_invoice is EqualUnmodifiableMapView) return _invoice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, userId: $userId, invoiceId: $invoiceId, paymentMethod: $paymentMethod, amount: $amount, currencyCode: $currencyCode, type: $type, status: $status, gatewayId: $gatewayId, gatewayRequestId: $gatewayRequestId, gatewayTransactionId: $gatewayTransactionId, timestampInitiated: $timestampInitiated, timestampCompleted: $timestampCompleted, errorCode: $errorCode, errorMessage: $errorMessage, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, gateway: $gateway, invoice: $invoice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.gatewayId, gatewayId) ||
                other.gatewayId == gatewayId) &&
            (identical(other.gatewayRequestId, gatewayRequestId) ||
                other.gatewayRequestId == gatewayRequestId) &&
            (identical(other.gatewayTransactionId, gatewayTransactionId) ||
                other.gatewayTransactionId == gatewayTransactionId) &&
            (identical(other.timestampInitiated, timestampInitiated) ||
                other.timestampInitiated == timestampInitiated) &&
            (identical(other.timestampCompleted, timestampCompleted) ||
                other.timestampCompleted == timestampCompleted) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._gateway, _gateway) &&
            const DeepCollectionEquality().equals(other._invoice, _invoice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        invoiceId,
        paymentMethod,
        amount,
        currencyCode,
        type,
        status,
        gatewayId,
        gatewayRequestId,
        gatewayTransactionId,
        timestampInitiated,
        timestampCompleted,
        errorCode,
        errorMessage,
        notes,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_gateway),
        const DeepCollectionEquality().hash(_invoice)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel(
      {required final String id,
      @JsonKey(name: 'userId') required final String userId,
      @JsonKey(name: 'invoiceId') required final String invoiceId,
      @JsonKey(name: 'paymentMethod') required final String paymentMethod,
      @DecimalConverter() required final double amount,
      @JsonKey(name: 'currencyCode') required final String currencyCode,
      required final String type,
      required final String status,
      @JsonKey(name: 'gatewayId') final String? gatewayId,
      @JsonKey(name: 'gatewayRequestId') final String? gatewayRequestId,
      @JsonKey(name: 'gatewayTransactionId') final String? gatewayTransactionId,
      @JsonKey(name: 'timestampInitiated')
      required final DateTime timestampInitiated,
      @JsonKey(name: 'timestampCompleted') final DateTime? timestampCompleted,
      @JsonKey(name: 'errorCode') final String? errorCode,
      @JsonKey(name: 'errorMessage') final String? errorMessage,
      @JsonKey(name: 'notes') final String? notes,
      @JsonKey(name: 'createdAt') required final DateTime createdAt,
      @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
      @JsonKey(name: 'gateway') final Map<String, dynamic>? gateway,
      @JsonKey(name: 'invoice')
      final Map<String, dynamic>? invoice}) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'userId')
  String get userId;
  @override
  @JsonKey(name: 'invoiceId')
  String get invoiceId;
  @override
  @JsonKey(name: 'paymentMethod')
  String get paymentMethod;
  @override // ELECTRONIC, CASH
  @DecimalConverter()
  double get amount;
  @override
  @JsonKey(name: 'currencyCode')
  String get currencyCode;
  @override
  String get type;
  @override // PAYMENT, REFUND, FEE
  String get status;
  @override // PENDING, SUCCESSFUL, FAILED, CANCELLED
  @JsonKey(name: 'gatewayId')
  String? get gatewayId;
  @override
  @JsonKey(name: 'gatewayRequestId')
  String? get gatewayRequestId;
  @override
  @JsonKey(name: 'gatewayTransactionId')
  String? get gatewayTransactionId;
  @override
  @JsonKey(name: 'timestampInitiated')
  DateTime get timestampInitiated;
  @override
  @JsonKey(name: 'timestampCompleted')
  DateTime? get timestampCompleted;
  @override
  @JsonKey(name: 'errorCode')
  String? get errorCode;
  @override
  @JsonKey(name: 'errorMessage')
  String? get errorMessage;
  @override
  @JsonKey(name: 'notes')
  String? get notes;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override // Relations
  @JsonKey(name: 'gateway')
  Map<String, dynamic>? get gateway;
  @override
  @JsonKey(name: 'invoice')
  Map<String, dynamic>? get invoice;
  @override
  @JsonKey(ignore: true)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
