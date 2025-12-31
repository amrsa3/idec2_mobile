// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      phone: json['phone'] as String,
      password: json['password'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'rememberMe': instance.rememberMe,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      phone: json['phone'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
    };

_$OtpRequestImpl _$$OtpRequestImplFromJson(Map<String, dynamic> json) =>
    _$OtpRequestImpl(
      phone: json['phone'] as String,
      purpose: json['purpose'] as String? ?? 'verification',
    );

Map<String, dynamic> _$$OtpRequestImplToJson(_$OtpRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'purpose': instance.purpose,
    };

_$OtpVerifyRequestImpl _$$OtpVerifyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpVerifyRequestImpl(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$$OtpVerifyRequestImplToJson(
        _$OtpVerifyRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
    };

_$PasswordResetRequestImpl _$$PasswordResetRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetRequestImpl(
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$$PasswordResetRequestImplToJson(
        _$PasswordResetRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestImpl(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
        _$ResetPasswordRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
      'newPassword': instance.newPassword,
    };

_$PasswordResetResponseImpl _$$PasswordResetResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      otpCode: json['otpCode'] as String?,
    );

Map<String, dynamic> _$$PasswordResetResponseImplToJson(
        _$PasswordResetResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'otpCode': instance.otpCode,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'token': instance.token,
    };

_$SessionInfoImpl _$$SessionInfoImplFromJson(Map<String, dynamic> json) =>
    _$SessionInfoImpl(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      isActive: json['isActive'] as bool,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      inactivityDuration:
          Duration(microseconds: (json['inactivityDuration'] as num).toInt()),
    );

Map<String, dynamic> _$$SessionInfoImplToJson(_$SessionInfoImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'userId': instance.userId,
      'startTime': instance.startTime.toIso8601String(),
      'lastActivity': instance.lastActivity.toIso8601String(),
      'isActive': instance.isActive,
      'duration': instance.duration.inMicroseconds,
      'inactivityDuration': instance.inactivityDuration.inMicroseconds,
    };

_$TokenInfoImpl _$$TokenInfoImplFromJson(Map<String, dynamic> json) =>
    _$TokenInfoImpl(
      hasAccessToken: json['hasAccessToken'] as bool,
      hasRefreshToken: json['hasRefreshToken'] as bool,
      isValid: json['isValid'] as bool,
      expiryTime: json['expiryTime'] as String?,
      lastRefresh: json['lastRefresh'] as String?,
      timeUntilExpiry: (json['timeUntilExpiry'] as num?)?.toInt(),
      integrityValid: json['integrityValid'] as bool,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$TokenInfoImplToJson(_$TokenInfoImpl instance) =>
    <String, dynamic>{
      'hasAccessToken': instance.hasAccessToken,
      'hasRefreshToken': instance.hasRefreshToken,
      'isValid': instance.isValid,
      'expiryTime': instance.expiryTime,
      'lastRefresh': instance.lastRefresh,
      'timeUntilExpiry': instance.timeUntilExpiry,
      'integrityValid': instance.integrityValid,
      'platform': instance.platform,
    };

_$StorageInfoImpl _$$StorageInfoImplFromJson(Map<String, dynamic> json) =>
    _$StorageInfoImpl(
      lastSyncTime: json['lastSyncTime'] as String?,
      pendingOperationsCount: (json['pendingOperationsCount'] as num).toInt(),
      hasUserData: json['hasUserData'] as bool,
      hasAuthData: json['hasAuthData'] as bool,
      totalOfflineData: (json['totalOfflineData'] as num).toInt(),
      dataRetentionPeriod: (json['dataRetentionPeriod'] as num).toInt(),
    );

Map<String, dynamic> _$$StorageInfoImplToJson(_$StorageInfoImpl instance) =>
    <String, dynamic>{
      'lastSyncTime': instance.lastSyncTime,
      'pendingOperationsCount': instance.pendingOperationsCount,
      'hasUserData': instance.hasUserData,
      'hasAuthData': instance.hasAuthData,
      'totalOfflineData': instance.totalOfflineData,
      'dataRetentionPeriod': instance.dataRetentionPeriod,
    };

_$ConnectivityInfoImpl _$$ConnectivityInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectivityInfoImpl(
      currentStatus: json['currentStatus'] as String,
      isConnected: json['isConnected'] as bool,
      connectionType: json['connectionType'] as String,
      lastCheck: json['lastCheck'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$$ConnectivityInfoImplToJson(
        _$ConnectivityInfoImpl instance) =>
    <String, dynamic>{
      'currentStatus': instance.currentStatus,
      'isConnected': instance.isConnected,
      'connectionType': instance.connectionType,
      'lastCheck': instance.lastCheck,
      'platform': instance.platform,
    };

_$SystemInfoImpl _$$SystemInfoImplFromJson(Map<String, dynamic> json) =>
    _$SystemInfoImpl(
      sessionInfo:
          SessionInfo.fromJson(json['sessionInfo'] as Map<String, dynamic>),
      tokenInfo: TokenInfo.fromJson(json['tokenInfo'] as Map<String, dynamic>),
      storageInfo:
          StorageInfo.fromJson(json['storageInfo'] as Map<String, dynamic>),
      connectivityInfo: ConnectivityInfo.fromJson(
          json['connectivityInfo'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$SystemInfoImplToJson(_$SystemInfoImpl instance) =>
    <String, dynamic>{
      'sessionInfo': instance.sessionInfo,
      'tokenInfo': instance.tokenInfo,
      'storageInfo': instance.storageInfo,
      'connectivityInfo': instance.connectivityInfo,
      'timestamp': instance.timestamp.toIso8601String(),
    };
