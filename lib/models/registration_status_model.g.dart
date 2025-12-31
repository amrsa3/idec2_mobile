// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationStatusModelImpl _$$RegistrationStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationStatusModelImpl(
      id: json['id'] as String,
      status: json['status'] as String,
      calculatedPrice: json['calculatedPrice'] as String,
      currency: json['currency'] as String?,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      paymentDeadline: json['paymentDeadline'] == null
          ? null
          : DateTime.parse(json['paymentDeadline'] as String),
    );

Map<String, dynamic> _$$RegistrationStatusModelImplToJson(
        _$RegistrationStatusModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'calculatedPrice': instance.calculatedPrice,
      'currency': instance.currency,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'paymentDeadline': instance.paymentDeadline?.toIso8601String(),
    };
