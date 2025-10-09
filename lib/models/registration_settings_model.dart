import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_settings_model.freezed.dart';
part 'registration_settings_model.g.dart';

/// Registration settings model
@freezed
class RegistrationSettingsModel with _$RegistrationSettingsModel {
  const factory RegistrationSettingsModel({
    required bool registrationEnabled,
    required RegistrationStatus status,
    required List<OtpChannelModel> availableOtpChannels,
    required List<String> supportedLanguages,
    required String defaultLanguage,
    String? maintenanceMessage,
    DateTime? maintenanceStartTime,
    DateTime? maintenanceEndTime,
    String? registrationClosedMessage,
    DateTime? registrationOpenTime,
    DateTime? registrationCloseTime,
    Map<String, dynamic>? additionalSettings,
    DateTime? lastUpdated,
  }) = _RegistrationSettingsModel;

  factory RegistrationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationSettingsModelFromJson(json);
}

/// Registration status enum
@JsonEnum()
enum RegistrationStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('limited')
  limited,
}

/// OTP channel model
@freezed
class OtpChannelModel with _$OtpChannelModel {
  const factory OtpChannelModel({
    required String id,
    required String name,
    required String displayName,
    required bool enabled,
    required bool isDefault,
    int? priority,
    Map<String, dynamic>? settings,
    String? description,
    String? icon,
  }) = _OtpChannelModel;

  factory OtpChannelModel.fromJson(Map<String, dynamic> json) =>
      _$OtpChannelModelFromJson(json);
}

/// OTP channel request model
@freezed
class OtpChannelRequest with _$OtpChannelRequest {
  const factory OtpChannelRequest({
    required String phoneNumber,
    required String channelId,
    Map<String, dynamic>? additionalData,
  }) = _OtpChannelRequest;

  factory OtpChannelRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpChannelRequestFromJson(json);
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

/// OTP channel selection model
@freezed
class OtpChannelSelection with _$OtpChannelSelection {
  const factory OtpChannelSelection({
    required String channelId,
    required String displayName,
    required bool isSelected,
    required bool isAvailable,
    String? description,
    String? icon,
    Map<String, dynamic>? metadata,
  }) = _OtpChannelSelection;

  factory OtpChannelSelection.fromJson(Map<String, dynamic> json) =>
      _$OtpChannelSelectionFromJson(json);
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
    if (!registrationEnabled) return false;
    if (status == RegistrationStatus.closed) return false;
    if (status == RegistrationStatus.maintenance) return false;
    
    // Check time-based restrictions
    final now = DateTime.now();
    if (registrationOpenTime != null && now.isBefore(registrationOpenTime!)) {
      return false;
    }
    if (registrationCloseTime != null && now.isAfter(registrationCloseTime!)) {
      return false;
    }
    
    return true;
  }

  /// Get enabled OTP channels
  List<OtpChannelModel> get enabledChannels {
    return availableOtpChannels.where((channel) => channel.enabled).toList();
  }

  /// Get default OTP channel
  OtpChannelModel? get defaultChannel {
    final enabledChannels = this.enabledChannels;
    if (enabledChannels.isEmpty) return null;
    
    // Find the channel marked as default
    final defaultChannel = enabledChannels.firstWhere(
      (channel) => channel.isDefault,
      orElse: () => enabledChannels.first,
    );
    
    return defaultChannel;
  }

  /// Get sorted channels by priority
  List<OtpChannelModel> get sortedChannels {
    final channels = List<OtpChannelModel>.from(enabledChannels);
    channels.sort((a, b) {
      // Sort by priority (lower number = higher priority)
      final aPriority = a.priority ?? 999;
      final bPriority = b.priority ?? 999;
      return aPriority.compareTo(bPriority);
    });
    return channels;
  }

  /// Get user-friendly status message
  String getStatusMessage() {
    switch (status) {
      case RegistrationStatus.open:
        return 'Registration is open';
      case RegistrationStatus.closed:
        return registrationClosedMessage ?? 'Registration is currently closed';
      case RegistrationStatus.maintenance:
        return maintenanceMessage ?? 'Registration is under maintenance';
      case RegistrationStatus.limited:
        return 'Registration is limited';
    }
  }

  /// Check if maintenance mode is active
  bool get isMaintenanceMode => status == RegistrationStatus.maintenance;

  /// Check if registration is closed
  bool get isRegistrationClosed => status == RegistrationStatus.closed;
}

/// Extension methods for OtpChannelModel
extension OtpChannelExtension on OtpChannelModel {
  /// Get channel icon or default
  String get iconOrDefault => icon ?? 'sms';

  /// Check if channel is SMS
  bool get isSms => id.toLowerCase() == 'sms';

  /// Check if channel is WhatsApp
  bool get isWhatsApp => id.toLowerCase() == 'whatsapp';

  /// Check if channel is email
  bool get isEmail => id.toLowerCase() == 'email';

  /// Get user-friendly display name
  String get friendlyName {
    switch (id.toLowerCase()) {
      case 'sms':
        return 'SMS';
      case 'whatsapp':
        return 'WhatsApp';
      case 'email':
        return 'Email';
      default:
        return displayName;
    }
  }
}
