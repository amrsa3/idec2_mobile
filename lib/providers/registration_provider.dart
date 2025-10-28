import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/errors/app_error.dart';
import '../core/errors/error_handler.dart';
import '../models/registration_settings_model.dart';
import '../services/auth_service.dart';
import '../services/registration_settings_service.dart';

part 'registration_provider.freezed.dart';

@freezed
class RegistrationState with _$RegistrationState {
  const RegistrationState._();

  const factory RegistrationState({
    RegistrationSettingsModel? settings,
    RegistrationStatusResponse? status,
    @Default(false) bool isLoading,
    AppError? error,
    DateTime? lastUpdated,
    // إضافة الخصائص المفقودة
    List<OtpChannelModel>? availableChannels,
    OtpChannelModel? selectedChannel,
    OtpChannelModel? defaultChannel,
  }) = _RegistrationState;

  /// Check if registration is allowed
  bool get canRegister => status?.canRegister ?? false;

  /// Check if settings are loaded
  bool get hasSettings => settings != null;

  /// Check if there's an error
  bool get hasError => error != null;

  /// Copy with new values
  RegistrationState copyWithNew({
    RegistrationSettingsModel? settings,
    RegistrationStatusResponse? status,
    List<OtpChannelModel>? availableChannels,
    OtpChannelModel? selectedChannel,
    OtpChannelModel? defaultChannel,
    bool? isLoading,
    AppError? error,
    DateTime? lastUpdated,
    bool clearError = false,
    bool clearSelectedChannel = false,
  }) {
    return RegistrationState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      availableChannels: availableChannels ?? this.availableChannels,
      selectedChannel: clearSelectedChannel
          ? null
          : (selectedChannel ?? this.selectedChannel),
      defaultChannel: defaultChannel ?? this.defaultChannel,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Registration state notifier
class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier(this._registrationSettingsService, this._authService)
      : super(const RegistrationState());

  final RegistrationSettingsService _registrationSettingsService;
  final AuthService _authService;

  /// Initialize registration state
  Future<void> initialize() async {
    state = state.copyWithNew(isLoading: true, clearError: true);

    try {
      // Load settings first (this should always work with defaults)
      await _loadSettings();

      // Load status and channels asynchronously (non-blocking)
      _loadStatusAsync();
      _loadChannelsAsync();

      state = state.copyWithNew(
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      state = state.copyWithNew(
        isLoading: false,
        error: error,
      );
    }
  }

  /// Load status asynchronously (non-blocking)
  void _loadStatusAsync() {
    _loadStatus().then((_) {
      // Status loaded successfully
    }).catchError((e) {
      // Handle error silently - app should work without status
      debugPrint('⚠️ Could not load registration status: $e');
    });
  }

  /// Load channels asynchronously (non-blocking)
  void _loadChannelsAsync() {
    _loadChannels().then((_) {
      // Channels loaded successfully
    }).catchError((e) {
      // Handle error silently - app should work without channels
      debugPrint('⚠️ Could not load OTP channels: $e');
    });
  }

  /// Refresh all registration data
  Future<void> refresh() async {
    state = state.copyWithNew(isLoading: true, clearError: true);

    try {
      // Force refresh settings
      await _registrationSettingsService.refreshSettings();
      await _loadSettings();
      await _loadStatus();
      await _loadChannels();

      state = state.copyWithNew(
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      state = state.copyWithNew(
        isLoading: false,
        error: error,
      );
    }
  }

  /// Load registration settings
  Future<void> _loadSettings() async {
    try {
      final settings = await _registrationSettingsService.getCurrentSettings();
      state = state.copyWithNew(settings: settings);
    } catch (e) {
      debugPrint('⚠️ Could not load registration settings: $e');
      // Settings service should provide defaults, but just in case
    }
  }

  /// Load registration status
  Future<void> _loadStatus() async {
    try {
      final status =
          await _registrationSettingsService.checkRegistrationStatus();
      state = state.copyWithNew(status: status);
    } catch (e) {
      debugPrint('⚠️ Could not load registration status: $e');
      // App should work without status
    }
  }

  /// Load available channels
  Future<void> _loadChannels() async {
    try {
      final channels =
          await _registrationSettingsService.getAvailableOtpChannels();
      // تحويل List<String> إلى List<OtpChannelModel>
      final channelModels = channels
          .asMap()
          .entries
          .map((entry) => OtpChannelModel(
                id: entry.value.toLowerCase(),
                name: entry.value,
                displayName: entry.value.toUpperCase(),
                enabled: true,
                isDefault: entry.key == 0, // First channel is default
                priority: entry.key,
              ))
          .toList();

      state = state.copyWithNew(availableChannels: channelModels);
    } catch (e) {
      debugPrint('⚠️ Could not load OTP channels: $e');
      // App should work without channels
    }

    // Auto-select default channel if none selected
    if (state.selectedChannel == null &&
        state.availableChannels?.isNotEmpty == true) {
      final defaultChannel = state.defaultChannel;
      if (defaultChannel != null) {
        state = state.copyWithNew(selectedChannel: defaultChannel);
      }
    }
  }

  /// Select OTP channel
  void selectChannel(OtpChannelModel channel) {
    state = state.copyWithNew(selectedChannel: channel);
  }

  /// Clear selected channel
  void clearSelectedChannel() {
    state = state.copyWithNew(clearSelectedChannel: true);
  }

  /// Clear error
  void clearError() {
    state = state.copyWithNew(clearError: true);
  }

  /// Check if registration is allowed
  Future<bool> checkRegistrationAllowed() async {
    try {
      final allowed =
          await _registrationSettingsService.validateRegistrationAllowed();

      // Update status if needed
      if (!allowed) {
        await _loadStatus();
      }

      return allowed;
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      state = state.copyWithNew(error: error);
      return false;
    }
  }

  /// Request OTP with selected channel
  Future<bool> requestOtp(String phoneNumber) async {
    try {
      state = state.copyWithNew(clearError: true);

      // استخدام خدمة المصادقة المحسنة بدلاً من registration service
      final result = await _authService.requestOtp(phoneNumber);

      if (result.success) {
        return true;
      } else {
        final error = ErrorHandler.instance.handleError(
          Exception(result.message), 
          StackTrace.current
        );
        state = state.copyWithNew(error: error);
        return false;
      }
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      state = state.copyWithNew(error: error);
      return false;
    }
  }
}

/// Registration provider
final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  final registrationService = ref.watch(registrationSettingsServiceProvider);
  final authService = ref.watch(authServiceProvider);
  return RegistrationNotifier(registrationService, authService);
});

/// Provider for checking if registration is allowed
final registrationAllowedProvider = FutureProvider<bool>((ref) async {
  final notifier = ref.read(registrationProvider.notifier);
  return await notifier.checkRegistrationAllowed();
});

/// Provider for registration settings
final registrationSettingsProvider =
    Provider<RegistrationSettingsModel?>((ref) {
  return ref.watch(registrationProvider).settings;
});

/// Provider for registration status
final registrationStatusProvider = Provider<RegistrationStatusResponse?>((ref) {
  return ref.watch(registrationProvider).status;
});

/// Extension for easy registration management
extension RegistrationExtension on WidgetRef {
  /// Initialize registration
  Future<void> initializeRegistration() async {
    await read(registrationProvider.notifier).initialize();
  }

  /// Refresh registration data
  Future<void> refreshRegistration() async {
    await read(registrationProvider.notifier).refresh();
  }

  /// Check if registration is allowed
  Future<bool> isRegistrationAllowed() async {
    return await read(registrationProvider.notifier).checkRegistrationAllowed();
  }

  /// Request OTP
  Future<bool> requestOtp(String phoneNumber) async {
    return await read(registrationProvider.notifier).requestOtp(phoneNumber);
  }

  /// Clear registration error
  void clearRegistrationError() {
    read(registrationProvider.notifier).clearError();
  }
}
