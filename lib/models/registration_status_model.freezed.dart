// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegistrationStatusModel _$RegistrationStatusModelFromJson(
    Map<String, dynamic> json) {
  return _RegistrationStatusModel.fromJson(json);
}

/// @nodoc
mixin _$RegistrationStatusModel {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get calculatedPrice => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  DateTime get registrationDate => throw _privateConstructorUsedError;
  DateTime? get paymentDeadline => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegistrationStatusModelCopyWith<RegistrationStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegistrationStatusModelCopyWith<$Res> {
  factory $RegistrationStatusModelCopyWith(RegistrationStatusModel value,
          $Res Function(RegistrationStatusModel) then) =
      _$RegistrationStatusModelCopyWithImpl<$Res, RegistrationStatusModel>;
  @useResult
  $Res call(
      {String id,
      String status,
      String calculatedPrice,
      String? currency,
      DateTime registrationDate,
      DateTime? paymentDeadline});
}

/// @nodoc
class _$RegistrationStatusModelCopyWithImpl<$Res,
        $Val extends RegistrationStatusModel>
    implements $RegistrationStatusModelCopyWith<$Res> {
  _$RegistrationStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? calculatedPrice = null,
    Object? currency = freezed,
    Object? registrationDate = null,
    Object? paymentDeadline = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      calculatedPrice: null == calculatedPrice
          ? _value.calculatedPrice
          : calculatedPrice // ignore: cast_nullable_to_non_nullable
              as String,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentDeadline: freezed == paymentDeadline
          ? _value.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegistrationStatusModelImplCopyWith<$Res>
    implements $RegistrationStatusModelCopyWith<$Res> {
  factory _$$RegistrationStatusModelImplCopyWith(
          _$RegistrationStatusModelImpl value,
          $Res Function(_$RegistrationStatusModelImpl) then) =
      __$$RegistrationStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String status,
      String calculatedPrice,
      String? currency,
      DateTime registrationDate,
      DateTime? paymentDeadline});
}

/// @nodoc
class __$$RegistrationStatusModelImplCopyWithImpl<$Res>
    extends _$RegistrationStatusModelCopyWithImpl<$Res,
        _$RegistrationStatusModelImpl>
    implements _$$RegistrationStatusModelImplCopyWith<$Res> {
  __$$RegistrationStatusModelImplCopyWithImpl(
      _$RegistrationStatusModelImpl _value,
      $Res Function(_$RegistrationStatusModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? calculatedPrice = null,
    Object? currency = freezed,
    Object? registrationDate = null,
    Object? paymentDeadline = freezed,
  }) {
    return _then(_$RegistrationStatusModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      calculatedPrice: null == calculatedPrice
          ? _value.calculatedPrice
          : calculatedPrice // ignore: cast_nullable_to_non_nullable
              as String,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentDeadline: freezed == paymentDeadline
          ? _value.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegistrationStatusModelImpl implements _RegistrationStatusModel {
  const _$RegistrationStatusModelImpl(
      {required this.id,
      required this.status,
      required this.calculatedPrice,
      this.currency,
      required this.registrationDate,
      this.paymentDeadline});

  factory _$RegistrationStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegistrationStatusModelImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final String calculatedPrice;
  @override
  final String? currency;
  @override
  final DateTime registrationDate;
  @override
  final DateTime? paymentDeadline;

  @override
  String toString() {
    return 'RegistrationStatusModel(id: $id, status: $status, calculatedPrice: $calculatedPrice, currency: $currency, registrationDate: $registrationDate, paymentDeadline: $paymentDeadline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegistrationStatusModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.calculatedPrice, calculatedPrice) ||
                other.calculatedPrice == calculatedPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.paymentDeadline, paymentDeadline) ||
                other.paymentDeadline == paymentDeadline));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, calculatedPrice,
      currency, registrationDate, paymentDeadline);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegistrationStatusModelImplCopyWith<_$RegistrationStatusModelImpl>
      get copyWith => __$$RegistrationStatusModelImplCopyWithImpl<
          _$RegistrationStatusModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegistrationStatusModelImplToJson(
      this,
    );
  }
}

abstract class _RegistrationStatusModel implements RegistrationStatusModel {
  const factory _RegistrationStatusModel(
      {required final String id,
      required final String status,
      required final String calculatedPrice,
      final String? currency,
      required final DateTime registrationDate,
      final DateTime? paymentDeadline}) = _$RegistrationStatusModelImpl;

  factory _RegistrationStatusModel.fromJson(Map<String, dynamic> json) =
      _$RegistrationStatusModelImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  String get calculatedPrice;
  @override
  String? get currency;
  @override
  DateTime get registrationDate;
  @override
  DateTime? get paymentDeadline;
  @override
  @JsonKey(ignore: true)
  _$$RegistrationStatusModelImplCopyWith<_$RegistrationStatusModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
