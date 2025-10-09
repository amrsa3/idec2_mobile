// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationSettingsModelImpl _$$RegistrationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationSettingsModelImpl(
      registrationEnabled: json['registrationEnabled'] as bool,
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      availableOtpChannels: (json['availableOtpChannels'] as List<dynamic>)
          .map((e) => OtpChannelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      defaultLanguage: json['defaultLanguage'] as String,
      maintenanceMessage: json['maintenanceMessage'] as String?,
      maintenanceStartTime: json['maintenanceStartTime'] == null
          ? null
          : DateTime.parse(json['maintenanceStartTime'] as String),
      maintenanceEndTime: json['maintenanceEndTime'] == null
          ? null
          : DateTime.parse(json['maintenanceEndTime'] as String),
      registrationClosedMessage: json['registrationClosedMessage'] as String?,
      registrationOpenTime: json['registrationOpenTime'] == null
          ? null
          : DateTime.parse(json['registrationOpenTime'] as String),
      registrationCloseTime: json['registrationCloseTime'] == null
          ? null
          : DateTime.parse(json['registrationCloseTime'] as String),
      additionalSettings: json['additionalSettings'] as Map<String, dynamic>?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$RegistrationSettingsModelImplToJson(
        _$RegistrationSettingsModelImpl instance) =>
    <String, dynamic>{
      'registrationEnabled': instance.registrationEnabled,
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'availableOtpChannels': instance.availableOtpChannels,
      'supportedLanguages': instance.supportedLanguages,
      'defaultLanguage': instance.defaultLanguage,
      'maintenanceMessage': instance.maintenanceMessage,
      'maintenanceStartTime': instance.maintenanceStartTime?.toIso8601String(),
      'maintenanceEndTime': instance.maintenanceEndTime?.toIso8601String(),
      'registrationClosedMessage': instance.registrationClosedMessage,
      'registrationOpenTime': instance.registrationOpenTime?.toIso8601String(),
      'registrationCloseTime':
          instance.registrationCloseTime?.toIso8601String(),
      'additionalSettings': instance.additionalSettings,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.open: 'open',
  RegistrationStatus.closed: 'closed',
  RegistrationStatus.maintenance: 'maintenance',
  RegistrationStatus.limited: 'limited',
};

_$OtpChannelModelImpl _$$OtpChannelModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpChannelModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      enabled: json['enabled'] as bool,
      isDefault: json['isDefault'] as bool,
      priority: (json['priority'] as num?)?.toInt(),
      settings: json['settings'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$OtpChannelModelImplToJson(
        _$OtpChannelModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'enabled': instance.enabled,
      'isDefault': instance.isDefault,
      'priority': instance.priority,
      'settings': instance.settings,
      'description': instance.description,
      'icon': instance.icon,
    };

_$OtpChannelRequestImpl _$$OtpChannelRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpChannelRequestImpl(
      phoneNumber: json['phoneNumber'] as String,
      channelId: json['channelId'] as String,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$OtpChannelRequestImplToJson(
        _$OtpChannelRequestImpl instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'channelId': instance.channelId,
      'additionalData': instance.additionalData,
    };

_$RegistrationStatusResponseImpl _$$RegistrationStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationStatusResponseImpl(
      canRegister: json['canRegister'] as bool,
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      message: json['message'] as String?,
      reason: json['reason'] as String?,
      nextAvailableTime: json['nextAvailableTime'] == null
          ? null
          : DateTime.parse(json['nextAvailableTime'] as String),
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$RegistrationStatusResponseImplToJson(
        _$RegistrationStatusResponseImpl instance) =>
    <String, dynamic>{
      'canRegister': instance.canRegister,
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'message': instance.message,
      'reason': instance.reason,
      'nextAvailableTime': instance.nextAvailableTime?.toIso8601String(),
      'additionalInfo': instance.additionalInfo,
    };

_$OtpChannelSelectionImpl _$$OtpChannelSelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpChannelSelectionImpl(
      channelId: json['channelId'] as String,
      displayName: json['displayName'] as String,
      isSelected: json['isSelected'] as bool,
      isAvailable: json['isAvailable'] as bool,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$OtpChannelSelectionImplToJson(
        _$OtpChannelSelectionImpl instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'displayName': instance.displayName,
      'isSelected': instance.isSelected,
      'isAvailable': instance.isAvailable,
      'description': instance.description,
      'icon': instance.icon,
      'metadata': instance.metadata,
    };

_$RegistrationSettingsCacheImpl _$$RegistrationSettingsCacheImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationSettingsCacheImpl(
      settings: RegistrationSettingsModel.fromJson(
          json['settings'] as Map<String, dynamic>),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      cacheExpiry: Duration(microseconds: (json['cacheExpiry'] as num).toInt()),
    );

Map<String, dynamic> _$$RegistrationSettingsCacheImplToJson(
        _$RegistrationSettingsCacheImpl instance) =>
    <String, dynamic>{
      'settings': instance.settings,
      'cachedAt': instance.cachedAt.toIso8601String(),
      'cacheExpiry': instance.cacheExpiry.inMicroseconds,
    };
