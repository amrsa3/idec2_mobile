// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationModel _$RegistrationModelFromJson(Map<String, dynamic> json) {
  return _RegistrationModel.fromJson(json);
}

/// @nodoc
mixin _$RegistrationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'registrationType')
  String get registrationType =>
      throw _privateConstructorUsedError; // 'CONFERENCE' or 'EVENT'
  @JsonKey(name: 'eventId')
  String? get eventId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conferenceId')
  String? get conferenceId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // UNDER_REVIEW, ACCEPTED, PAYMENT_PENDING, etc.
  @DecimalConverter()
  @JsonKey(name: 'calculatedPrice')
  double get calculatedPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency')
  String? get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'appliedRuleSet')
  String? get appliedRuleSet => throw _privateConstructorUsedError;
  @JsonKey(name: 'paymentDeadline')
  DateTime? get paymentDeadline => throw _privateConstructorUsedError;
  @JsonKey(name: 'onHoldReason')
  String? get onHoldReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Relations
  @JsonKey(name: 'event')
  Map<String, dynamic>? get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'conference')
  Map<String, dynamic>? get conference => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationModelCopyWith<RegistrationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationModelCopyWith<$Res> {
  factory $RegistrationModelCopyWith(
          RegistrationModel value, $Res Function(RegistrationModel) then) =
      _$RegistrationModelCopyWithImpl<$Res, RegistrationModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      @JsonKey(name: 'registrationType') String registrationType,
      @JsonKey(name: 'eventId') String? eventId,
      @JsonKey(name: 'conferenceId') String? conferenceId,
      String status,
      @DecimalConverter()
      @JsonKey(name: 'calculatedPrice')
      double calculatedPrice,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'appliedRuleSet') String? appliedRuleSet,
      @JsonKey(name: 'paymentDeadline') DateTime? paymentDeadline,
      @JsonKey(name: 'onHoldReason') String? onHoldReason,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      @JsonKey(name: 'event') Map<String, dynamic>? event,
      @JsonKey(name: 'conference') Map<String, dynamic>? conference,
      @JsonKey(name: 'user') Map<String, dynamic>? user});
}

/// @nodoc
class _$RegistrationModelCopyWithImpl<$Res, $Val extends RegistrationModel>
    implements $RegistrationModelCopyWith<$Res> {
  _$RegistrationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? registrationType = null,
    Object? eventId = freezed,
    Object? conferenceId = freezed,
    Object? status = null,
    Object? calculatedPrice = null,
    Object? currency = freezed,
    Object? appliedRuleSet = freezed,
    Object? paymentDeadline = freezed,
    Object? onHoldReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? event = freezed,
    Object? conference = freezed,
    Object? user = freezed,
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
      registrationType: null == registrationType
          ? _value.registrationType
          : registrationType // ignore: cast_nullable_to_non_nullable
              as String,
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
      calculatedPrice: null == calculatedPrice
          ? _value.calculatedPrice
          : calculatedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedRuleSet: freezed == appliedRuleSet
          ? _value.appliedRuleSet
          : appliedRuleSet // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDeadline: freezed == paymentDeadline
          ? _value.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      onHoldReason: freezed == onHoldReason
          ? _value.onHoldReason
          : onHoldReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      conference: freezed == conference
          ? _value.conference
          : conference // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationModelImplCopyWith<$Res>
    implements $RegistrationModelCopyWith<$Res> {
  factory _$$RegistrationModelImplCopyWith(_$RegistrationModelImpl value,
          $Res Function(_$RegistrationModelImpl) then) =
      __$$RegistrationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      @JsonKey(name: 'registrationType') String registrationType,
      @JsonKey(name: 'eventId') String? eventId,
      @JsonKey(name: 'conferenceId') String? conferenceId,
      String status,
      @DecimalConverter()
      @JsonKey(name: 'calculatedPrice')
      double calculatedPrice,
      @JsonKey(name: 'currency') String? currency,
      @JsonKey(name: 'appliedRuleSet') String? appliedRuleSet,
      @JsonKey(name: 'paymentDeadline') DateTime? paymentDeadline,
      @JsonKey(name: 'onHoldReason') String? onHoldReason,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      @JsonKey(name: 'event') Map<String, dynamic>? event,
      @JsonKey(name: 'conference') Map<String, dynamic>? conference,
      @JsonKey(name: 'user') Map<String, dynamic>? user});
}

/// @nodoc
class __$$RegistrationModelImplCopyWithImpl<$Res>
    extends _$RegistrationModelCopyWithImpl<$Res, _$RegistrationModelImpl>
    implements _$$RegistrationModelImplCopyWith<$Res> {
  __$$RegistrationModelImplCopyWithImpl(_$RegistrationModelImpl _value,
      $Res Function(_$RegistrationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? registrationType = null,
    Object? eventId = freezed,
    Object? conferenceId = freezed,
    Object? status = null,
    Object? calculatedPrice = null,
    Object? currency = freezed,
    Object? appliedRuleSet = freezed,
    Object? paymentDeadline = freezed,
    Object? onHoldReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? event = freezed,
    Object? conference = freezed,
    Object? user = freezed,
  }) {
    return _then(_$RegistrationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      registrationType: null == registrationType
          ? _value.registrationType
          : registrationType // ignore: cast_nullable_to_non_nullable
              as String,
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
      calculatedPrice: null == calculatedPrice
          ? _value.calculatedPrice
          : calculatedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedRuleSet: freezed == appliedRuleSet
          ? _value.appliedRuleSet
          : appliedRuleSet // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentDeadline: freezed == paymentDeadline
          ? _value.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      onHoldReason: freezed == onHoldReason
          ? _value.onHoldReason
          : onHoldReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      event: freezed == event
          ? _value._event
          : event // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      conference: freezed == conference
          ? _value._conference
          : conference // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      user: freezed == user
          ? _value._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationModelImpl implements _RegistrationModel {
  const _$RegistrationModelImpl(
      {required this.id,
      required this.userId,
      @JsonKey(name: 'registrationType') required this.registrationType,
      @JsonKey(name: 'eventId') this.eventId,
      @JsonKey(name: 'conferenceId') this.conferenceId,
      required this.status,
      @DecimalConverter()
      @JsonKey(name: 'calculatedPrice')
      required this.calculatedPrice,
      @JsonKey(name: 'currency') this.currency,
      @JsonKey(name: 'appliedRuleSet') this.appliedRuleSet,
      @JsonKey(name: 'paymentDeadline') this.paymentDeadline,
      @JsonKey(name: 'onHoldReason') this.onHoldReason,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') this.updatedAt,
      @JsonKey(name: 'event') final Map<String, dynamic>? event,
      @JsonKey(name: 'conference') final Map<String, dynamic>? conference,
      @JsonKey(name: 'user') final Map<String, dynamic>? user})
      : _event = event,
        _conference = conference,
        _user = user;

  factory _$RegistrationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @JsonKey(name: 'registrationType')
  final String registrationType;
// 'CONFERENCE' or 'EVENT'
  @override
  @JsonKey(name: 'eventId')
  final String? eventId;
  @override
  @JsonKey(name: 'conferenceId')
  final String? conferenceId;
  @override
  final String status;
// UNDER_REVIEW, ACCEPTED, PAYMENT_PENDING, etc.
  @override
  @DecimalConverter()
  @JsonKey(name: 'calculatedPrice')
  final double calculatedPrice;
  @override
  @JsonKey(name: 'currency')
  final String? currency;
  @override
  @JsonKey(name: 'appliedRuleSet')
  final String? appliedRuleSet;
  @override
  @JsonKey(name: 'paymentDeadline')
  final DateTime? paymentDeadline;
  @override
  @JsonKey(name: 'onHoldReason')
  final String? onHoldReason;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
// Relations
  final Map<String, dynamic>? _event;
// Relations
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

  final Map<String, dynamic>? _user;
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user {
    final value = _user;
    if (value == null) return null;
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'RegistrationModel(id: $id, userId: $userId, registrationType: $registrationType, eventId: $eventId, conferenceId: $conferenceId, status: $status, calculatedPrice: $calculatedPrice, currency: $currency, appliedRuleSet: $appliedRuleSet, paymentDeadline: $paymentDeadline, onHoldReason: $onHoldReason, createdAt: $createdAt, updatedAt: $updatedAt, event: $event, conference: $conference, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.registrationType, registrationType) ||
                other.registrationType == registrationType) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.conferenceId, conferenceId) ||
                other.conferenceId == conferenceId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.calculatedPrice, calculatedPrice) ||
                other.calculatedPrice == calculatedPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.appliedRuleSet, appliedRuleSet) ||
                other.appliedRuleSet == appliedRuleSet) &&
            (identical(other.paymentDeadline, paymentDeadline) ||
                other.paymentDeadline == paymentDeadline) &&
            (identical(other.onHoldReason, onHoldReason) ||
                other.onHoldReason == onHoldReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._event, _event) &&
            const DeepCollectionEquality()
                .equals(other._conference, _conference) &&
            const DeepCollectionEquality().equals(other._user, _user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      registrationType,
      eventId,
      conferenceId,
      status,
      calculatedPrice,
      currency,
      appliedRuleSet,
      paymentDeadline,
      onHoldReason,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_event),
      const DeepCollectionEquality().hash(_conference),
      const DeepCollectionEquality().hash(_user));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationModelImplCopyWith<_$RegistrationModelImpl> get copyWith =>
      __$$RegistrationModelImplCopyWithImpl<_$RegistrationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationModelImplToJson(
      this,
    );
  }
}

abstract class _RegistrationModel implements RegistrationModel {
  const factory _RegistrationModel(
      {required final String id,
      required final String userId,
      @JsonKey(name: 'registrationType') required final String registrationType,
      @JsonKey(name: 'eventId') final String? eventId,
      @JsonKey(name: 'conferenceId') final String? conferenceId,
      required final String status,
      @DecimalConverter()
      @JsonKey(name: 'calculatedPrice')
      required final double calculatedPrice,
      @JsonKey(name: 'currency') final String? currency,
      @JsonKey(name: 'appliedRuleSet') final String? appliedRuleSet,
      @JsonKey(name: 'paymentDeadline') final DateTime? paymentDeadline,
      @JsonKey(name: 'onHoldReason') final String? onHoldReason,
      @JsonKey(name: 'createdAt') required final DateTime createdAt,
      @JsonKey(name: 'updatedAt') final DateTime? updatedAt,
      @JsonKey(name: 'event') final Map<String, dynamic>? event,
      @JsonKey(name: 'conference') final Map<String, dynamic>? conference,
      @JsonKey(name: 'user')
      final Map<String, dynamic>? user}) = _$RegistrationModelImpl;

  factory _RegistrationModel.fromJson(Map<String, dynamic> json) =
      _$RegistrationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  @JsonKey(name: 'registrationType')
  String get registrationType;
  @override // 'CONFERENCE' or 'EVENT'
  @JsonKey(name: 'eventId')
  String? get eventId;
  @override
  @JsonKey(name: 'conferenceId')
  String? get conferenceId;
  @override
  String get status;
  @override // UNDER_REVIEW, ACCEPTED, PAYMENT_PENDING, etc.
  @DecimalConverter()
  @JsonKey(name: 'calculatedPrice')
  double get calculatedPrice;
  @override
  @JsonKey(name: 'currency')
  String? get currency;
  @override
  @JsonKey(name: 'appliedRuleSet')
  String? get appliedRuleSet;
  @override
  @JsonKey(name: 'paymentDeadline')
  DateTime? get paymentDeadline;
  @override
  @JsonKey(name: 'onHoldReason')
  String? get onHoldReason;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @override // Relations
  @JsonKey(name: 'event')
  Map<String, dynamic>? get event;
  @override
  @JsonKey(name: 'conference')
  Map<String, dynamic>? get conference;
  @override
  @JsonKey(name: 'user')
  Map<String, dynamic>? get user;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationModelImplCopyWith<_$RegistrationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
