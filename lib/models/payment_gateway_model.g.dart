// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_gateway_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentGatewayModelImpl _$$PaymentGatewayModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentGatewayModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      adapterName: json['adapterName'] as String,
      isActive: json['isActive'] as bool,
      mode: json['mode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PaymentGatewayModelImplToJson(
        _$PaymentGatewayModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'adapterName': instance.adapterName,
      'isActive': instance.isActive,
      'mode': instance.mode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
