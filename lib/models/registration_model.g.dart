// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationModelImpl _$$RegistrationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      registrationType: json['registrationType'] as String,
      eventId: json['eventId'] as String?,
      conferenceId: json['conferenceId'] as String?,
      status: json['status'] as String,
      calculatedPrice: (json['calculatedPrice'] as num).toDouble(),
      currency: json['currency'] as String?,
      appliedRuleSet: json['appliedRuleSet'] as String?,
      paymentDeadline: json['paymentDeadline'] == null
          ? null
          : DateTime.parse(json['paymentDeadline'] as String),
      onHoldReason: json['onHoldReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      event: json['event'] as Map<String, dynamic>?,
      conference: json['conference'] as Map<String, dynamic>?,
      user: json['user'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$RegistrationModelImplToJson(
        _$RegistrationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'registrationType': instance.registrationType,
      'eventId': instance.eventId,
      'conferenceId': instance.conferenceId,
      'status': instance.status,
      'calculatedPrice': instance.calculatedPrice,
      'currency': instance.currency,
      'appliedRuleSet': instance.appliedRuleSet,
      'paymentDeadline': instance.paymentDeadline?.toIso8601String(),
      'onHoldReason': instance.onHoldReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'event': instance.event,
      'conference': instance.conference,
      'user': instance.user,
    };
