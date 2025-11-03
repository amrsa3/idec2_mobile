// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_instruction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentInstructionModelImpl _$$PaymentInstructionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentInstructionModelImpl(
      type: json['type'] as String,
      data: PaymentInstructionDataModel.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PaymentInstructionModelImplToJson(
        _$PaymentInstructionModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };

_$PaymentInstructionDataModelImpl _$$PaymentInstructionDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentInstructionDataModelImpl(
      url: json['url'] as String?,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => PaymentFieldModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PaymentInstructionDataModelImplToJson(
        _$PaymentInstructionDataModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'fields': instance.fields,
    };

_$PaymentFieldModelImpl _$$PaymentFieldModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentFieldModelImpl(
      name: json['name'] as String,
      label: json['label'] as String,
      type: json['type'] as String?,
      placeholder: json['placeholder'] as String?,
      required: json['required'] as bool? ?? false,
    );

Map<String, dynamic> _$$PaymentFieldModelImplToJson(
        _$PaymentFieldModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'type': instance.type,
      'placeholder': instance.placeholder,
      'required': instance.required,
    };
