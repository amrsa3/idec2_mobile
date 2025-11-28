import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_settings_model.freezed.dart';
part 'registration_settings_model.g.dart';

/// Registration settings model
@freezed
class RegistrationSettingsModel with _$RegistrationSettingsModel {
  const factory RegistrationSettingsModel({
    required String id,
    required RegistrationStatus registrationStatus,
    required List<String> otpChannels,
    required int otpLength,
    required int otpExpiryMinutes,
    required int maxOtpAttempts,
    required int otpCooldownMinutes,
    required bool requireDocumentUpload,
    required bool allowEmailRegistration,
    required bool requirePhoneVerification,
    required bool autoApproveProfiles,
    String? maintenanceMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? updatedBy,
  }) = _RegistrationSettingsModel;

  factory RegistrationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationSettingsModelFromJson(json);
}

/// OTP Channel model
@freezed
class OtpChannelModel with _$OtpChannelModel {
  const factory OtpChannelModel({
    required String id,
    required String name,
    required String displayName,
    required bool enabled,
    required bool isDefault,
    required int priority,
    String? description,
  }) = _OtpChannelModel;

  const OtpChannelModel._();

  /// Get friendly name for display
  String get friendlyName => displayName.isNotEmpty ? displayName : name;

  factory OtpChannelModel.fromJson(Map<String, dynamic> json) =>
      _$OtpChannelModelFromJson(json);
}

/// OTP Channel Selection model
@freezed
class OtpChannelSelection with _$OtpChannelSelection {
  const factory OtpChannelSelection({
    required String selectedChannel,
    required String phoneNumber,
    required bool success,
    String? message,
  }) = _OtpChannelSelection;

  factory OtpChannelSelection.fromJson(Map<String, dynamic> json) =>
      _$OtpChannelSelectionFromJson(json);
}

/// Registration status enum
@JsonEnum()
enum RegistrationStatus {
  @JsonValue('OPEN')
  open,
  @JsonValue('CLOSED')
  closed,
  @JsonValue('MAINTENANCE')
  maintenance,
  @JsonValue('LIMITED')
  limited,
}

/// Registration status response model
@freezed
class RegistrationStatusResponse with _$RegistrationStatusResponse {
  const factory RegistrationStatusResponse({
    required bool canRegister,
    required RegistrationStatus status,
    String? message,
    String? reason,
    DateTime? nextAvailableTime,
    Map<String, dynamic>? additionalInfo,
  }) = _RegistrationStatusResponse;

  factory RegistrationStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationStatusResponseFromJson(json);
}

/// Registration settings cache model
@freezed
class RegistrationSettingsCache with _$RegistrationSettingsCache {
  const factory RegistrationSettingsCache({
    required RegistrationSettingsModel settings,
    required DateTime cachedAt,
    required Duration cacheExpiry,
  }) = _RegistrationSettingsCache;

  const RegistrationSettingsCache._();

  factory RegistrationSettingsCache.fromJson(Map<String, dynamic> json) =>
      _$RegistrationSettingsCacheFromJson(json);

  /// Check if cache is expired
  bool get isExpired {
    return DateTime.now().isAfter(cachedAt.add(cacheExpiry));
  }

  /// Check if cache is still valid
  bool get isValid => !isExpired;
}

/// Extension methods for RegistrationSettingsModel
extension RegistrationSettingsExtension on RegistrationSettingsModel {
  /// Check if registration is currently allowed
  bool get canRegister {
    if (registrationStatus == RegistrationStatus.closed) return false;
    if (registrationStatus == RegistrationStatus.maintenance) return false;
    
    return registrationStatus == RegistrationStatus.open;
  }

  /// Get enabled OTP channels as simple strings
  List<String> get enabledChannels {
    return otpChannels;
  }

  /// Get default OTP channel (first one in the list)
  String? get defaultChannel {
    if (otpChannels.isEmpty) return null;
    return otpChannels.first;
  }

  /// Get user-friendly status message
  String getStatusMessage() {
    switch (registrationStatus) {
      case RegistrationStatus.open:
        return 'Registration is open';
      case RegistrationStatus.closed:
        return 'Registration is currently closed';
      case RegistrationStatus.maintenance:
        return maintenanceMessage ?? 'Registration is under maintenance';
      case RegistrationStatus.limited:
        return 'Registration is limited';
    }
  }

  /// Check if maintenance mode is active
  bool get isMaintenanceMode => registrationStatus == RegistrationStatus.maintenance;

  /// Check if registration is closed
  bool get isRegistrationClosed => registrationStatus == RegistrationStatus.closed;

  /// Check if registration is enabled (open or limited)
  bool get registrationEnabled => registrationStatus == RegistrationStatus.open || registrationStatus == RegistrationStatus.limited;
}
