// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServerConfigImpl _$$ServerConfigImplFromJson(Map<String, dynamic> json) =>
    _$ServerConfigImpl(
      baseUrl: json['baseUrl'] as String,
      port: (json['port'] as num).toInt(),
      isDefault: json['isDefault'] as bool? ?? false,
      isSecure: json['isSecure'] as bool? ?? true,
      lastTested: json['lastTested'] == null
          ? null
          : DateTime.parse(json['lastTested'] as String),
      isReachable: json['isReachable'] as bool? ?? false,
      responseTime: (json['responseTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ServerConfigImplToJson(_$ServerConfigImpl instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'port': instance.port,
      'isDefault': instance.isDefault,
      'isSecure': instance.isSecure,
      'lastTested': instance.lastTested?.toIso8601String(),
      'isReachable': instance.isReachable,
      'responseTime': instance.responseTime,
    };
