// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
      'metadata': instance.metadata,
    };

_$ServerSettingsModelImpl _$$ServerSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServerSettingsModelImpl(
      registrationEnabled: json['registrationEnabled'] as bool,
      availableOtpChannels: (json['availableOtpChannels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      defaultLanguage: json['defaultLanguage'] as String,
      appConfig: json['appConfig'] as Map<String, dynamic>,
      maintenanceMessage: json['maintenanceMessage'] as String?,
      isMaintenanceMode: json['isMaintenanceMode'] as bool?,
    );

Map<String, dynamic> _$$ServerSettingsModelImplToJson(
        _$ServerSettingsModelImpl instance) =>
    <String, dynamic>{
      'registrationEnabled': instance.registrationEnabled,
      'availableOtpChannels': instance.availableOtpChannels,
      'supportedLanguages': instance.supportedLanguages,
      'defaultLanguage': instance.defaultLanguage,
      'appConfig': instance.appConfig,
      'maintenanceMessage': instance.maintenanceMessage,
      'isMaintenanceMode': instance.isMaintenanceMode,
    };

_$HealthCheckModelImpl _$$HealthCheckModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthCheckModelImpl(
      status: json['status'] as String,
      version: json['version'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      services: json['services'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$HealthCheckModelImplToJson(
        _$HealthCheckModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'timestamp': instance.timestamp.toIso8601String(),
      'services': instance.services,
    };

_$ErrorModelImpl _$$ErrorModelImplFromJson(Map<String, dynamic> json) =>
    _$ErrorModelImpl(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as String?,
      context: json['context'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ErrorModelImplToJson(_$ErrorModelImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'context': instance.context,
    };
