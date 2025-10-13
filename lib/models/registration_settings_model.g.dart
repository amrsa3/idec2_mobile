// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationSettingsModelImpl _$$RegistrationSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationSettingsModelImpl(
      id: json['id'] as String,
      registrationStatus:
          $enumDecode(_$RegistrationStatusEnumMap, json['registrationStatus']),
      otpChannels: (json['otpChannels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      otpLength: (json['otpLength'] as num).toInt(),
      otpExpiryMinutes: (json['otpExpiryMinutes'] as num).toInt(),
      maxOtpAttempts: (json['maxOtpAttempts'] as num).toInt(),
      otpCooldownMinutes: (json['otpCooldownMinutes'] as num).toInt(),
      requireDocumentUpload: json['requireDocumentUpload'] as bool,
      allowEmailRegistration: json['allowEmailRegistration'] as bool,
      requirePhoneVerification: json['requirePhoneVerification'] as bool,
      autoApproveProfiles: json['autoApproveProfiles'] as bool,
      maintenanceMessage: json['maintenanceMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$RegistrationSettingsModelImplToJson(
        _$RegistrationSettingsModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registrationStatus':
          _$RegistrationStatusEnumMap[instance.registrationStatus]!,
      'otpChannels': instance.otpChannels,
      'otpLength': instance.otpLength,
      'otpExpiryMinutes': instance.otpExpiryMinutes,
      'maxOtpAttempts': instance.maxOtpAttempts,
      'otpCooldownMinutes': instance.otpCooldownMinutes,
      'requireDocumentUpload': instance.requireDocumentUpload,
      'allowEmailRegistration': instance.allowEmailRegistration,
      'requirePhoneVerification': instance.requirePhoneVerification,
      'autoApproveProfiles': instance.autoApproveProfiles,
      'maintenanceMessage': instance.maintenanceMessage,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.open: 'OPEN',
  RegistrationStatus.closed: 'CLOSED',
  RegistrationStatus.maintenance: 'MAINTENANCE',
  RegistrationStatus.limited: 'LIMITED',
};

_$OtpChannelModelImpl _$$OtpChannelModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpChannelModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      enabled: json['enabled'] as bool,
      isDefault: json['isDefault'] as bool,
      priority: (json['priority'] as num).toInt(),
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
    };

_$OtpChannelSelectionImpl _$$OtpChannelSelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpChannelSelectionImpl(
      selectedChannel: json['selectedChannel'] as String,
      phoneNumber: json['phoneNumber'] as String,
      success: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$OtpChannelSelectionImplToJson(
        _$OtpChannelSelectionImpl instance) =>
    <String, dynamic>{
      'selectedChannel': instance.selectedChannel,
      'phoneNumber': instance.phoneNumber,
      'success': instance.success,
      'message': instance.message,
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
