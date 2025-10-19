import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/registration_settings_model.dart';
import '../models/api_response_model.dart';
import '../core/errors/app_error.dart';
import '../core/errors/error_handler.dart';
import 'enhanced_dio_service_v2.dart';
import 'storage_service.dart';
import 'platform_storage_service.dart';
import 'retry_service.dart';

/// Service for managing registration settings
class RegistrationSettingsService {
  static RegistrationSettingsService? _instance;
  static RegistrationSettingsService get instance => 
      _instance ??= RegistrationSettingsService._();

  RegistrationSettingsService._();

  final EnhancedDioServiceV2 _dioService = EnhancedDioServiceV2.instance;
  final PlatformStorageService _storageService = PlatformStorageService.instance;
  final RetryService _retryService = RetryService.instance;

  // Cache settings
  static const String _cacheKey = 'registration_settings_cache';
  static const Duration _defaultCacheExpiry = Duration(minutes: 15);
  
  RegistrationSettingsCache? _cache;
  StreamController<RegistrationSettingsModel>? _settingsController;
  Timer? _refreshTimer;

  /// Get settings stream for real-time updates
  Stream<RegistrationSettingsModel> get settingsStream {
    _settingsController ??= StreamController<RegistrationSettingsModel>.broadcast();
    return _settingsController!.stream;
  }

  /// Initialize the service
  Future<void> initialize() async {
    try {
      // Load cached settings first (this should always work)
      try {
        await _loadCachedSettings();
        debugPrint('✅ Cached settings loaded');
      } catch (e) {
        debugPrint('⚠️ Could not load cached settings: $e');
        // Initialize with default settings
         _cache = RegistrationSettingsCache(
           settings: _getDefaultSettings(),
           cachedAt: DateTime.now(),
           cacheExpiry: _defaultCacheExpiry,
         );
        debugPrint('🔧 Initialized with default settings');
      }
      
      // Try to fetch public status with short timeout (non-blocking)
      _fetchPublicStatusAsync();
      
      // Try to fetch public OTP channels with short timeout (non-blocking)
      _fetchPublicOtpChannelsAsync();
      
      // Set up periodic refresh (but don't fail if it doesn't work)
      try {
        _setupPeriodicRefresh();
        debugPrint('✅ Periodic refresh setup');
      } catch (e) {
        debugPrint('⚠️ Could not setup periodic refresh: $e');
      }
      
      debugPrint('✅ Registration settings service initialized (offline-ready)');
    } catch (e) {
      debugPrint('❌ Failed to initialize registration settings service: $e');
      // Ensure we have default settings even if everything fails
       _cache = RegistrationSettingsCache(
         settings: _getDefaultSettings(),
         cachedAt: DateTime.now(),
         cacheExpiry: _defaultCacheExpiry,
       );
      debugPrint('🔧 Fallback to default settings completed');
    }
  }

  /// Fetch public status asynchronously (non-blocking)
  void _fetchPublicStatusAsync() {
    fetchPublicStatus().then((_) {
      debugPrint('✅ Public registration status fetched successfully');
    }).catchError((e) {
      debugPrint('⚠️ Could not fetch public status: $e');
    });
  }

  /// Fetch public OTP channels asynchronously (non-blocking)
  void _fetchPublicOtpChannelsAsync() {
    fetchPublicOtpChannels().then((_) {
      debugPrint('✅ Public OTP channels fetched successfully');
    }).catchError((e) {
      debugPrint('⚠️ Could not fetch public OTP channels: $e');
    });
  }

  /// Dispose the service
  void dispose() {
    _settingsController?.close();
    _refreshTimer?.cancel();
  }

  /// Fetch registration settings from server
  Future<RegistrationSettingsModel> fetchSettings({
    bool useCache = true,
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first if allowed
      if (useCache && !forceRefresh && _cache != null && _cache!.isValid) {
        debugPrint('📦 Using cached registration settings');
        return _cache!.settings;
      }

      debugPrint('🔄 Fetching registration settings from server...');

      // Make API call with retry logic - use public endpoint to avoid permission issues
      final response = await _retryService.executeWithRetry(
        () => _dioService.requestWithRetry(
          '/api/v1/registration-settings/public',
          method: 'GET',
          retryConfig: RetryConfig.api,
        ),
        maxRetries: 3,
        shouldRetry: (error) => _shouldRetrySettingsFetch(error),
      );

      if (response.data == null) {
        throw NetworkError(
          message: 'No data received from server',
          code: 'NO_DATA',
        );
      }

      final data = response.data as Map<String, dynamic>;
      
      // Handle different response formats
      Map<String, dynamic> settingsData;
      if (data.containsKey('data')) {
        settingsData = data['data'] as Map<String, dynamic>;
      } else if (data.containsKey('settings')) {
        settingsData = data['settings'] as Map<String, dynamic>;
      } else {
        settingsData = data;
      }

      final settings = RegistrationSettingsModel.fromJson(settingsData);
      
      // Cache the settings
      await _cacheSettings(settings);
      
      // Notify listeners
      _settingsController?.add(settings);
      
      debugPrint('✅ Registration settings fetched successfully');
      debugPrint('📊 Registration enabled: ${settings.registrationEnabled}');
      debugPrint('📊 Status: ${settings.registrationStatus}');
      debugPrint('📊 Available channels: ${settings.otpChannels.length}');
      
      return settings;
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      debugPrint('❌ Failed to fetch registration settings: $error');
      
      // Try to return cached settings as fallback
      if (_cache != null) {
        debugPrint('📦 Falling back to cached settings');
        return _cache!.settings;
      }
      
      // Return default settings as last resort
      debugPrint('🔧 Using default registration settings');
      return _getDefaultSettings();
    }
  }

  /// Fetch registration status from public endpoint (no auth required)
  Future<RegistrationStatusResponse> fetchPublicStatus() async {
    try {
      debugPrint('🔄 Fetching public registration status...');

      final response = await _retryService.executeWithRetry(
        () => _dioService.requestWithRetry(
          '/api/v1/registration-settings/status',
          method: 'GET',
          retryConfig: RetryConfig.api,
        ),
        maxRetries: 3,
        shouldRetry: (error) => _shouldRetrySettingsFetch(error),
      );

      if (response.data == null) {
        throw NetworkError(
          message: 'No data received from server',
          code: 'NO_DATA',
        );
      }

      final data = response.data as Map<String, dynamic>;
      
      // Parse the public status response
      final isOpen = data['isOpen'] as bool? ?? false;
      final statusString = data['status'] as String? ?? 'CLOSED';
      final message = data['message'] as String? ?? 'Registration status unknown';
      
      // Convert string status to enum
      RegistrationStatus status;
      switch (statusString.toUpperCase()) {
        case 'OPEN':
          status = RegistrationStatus.open;
          break;
        case 'CLOSED':
          status = RegistrationStatus.closed;
          break;
        case 'MAINTENANCE':
          status = RegistrationStatus.maintenance;
          break;
        case 'LIMITED':
          status = RegistrationStatus.limited;
          break;
        default:
          status = RegistrationStatus.closed;
      }

      debugPrint('✅ Public registration status fetched: $statusString (canRegister: $isOpen)');
      
      return RegistrationStatusResponse(
        canRegister: isOpen,
        status: status,
        message: message,
        reason: isOpen ? null : 'Registration is currently $statusString',
      );
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      debugPrint('❌ Failed to fetch public registration status: $error');
      
      // Return safe default
      return const RegistrationStatusResponse(
        canRegister: false,
        status: RegistrationStatus.maintenance,
        message: 'Unable to check registration status',
        reason: 'Service temporarily unavailable',
      );
    }
  }

  /// Get current settings (cached or fetch)
  Future<RegistrationSettingsModel> getCurrentSettings() async {
    if (_cache != null && _cache!.isValid) {
      return _cache!.settings;
    }
    
    // Try to fetch settings, but fall back to defaults if it fails
    try {
      return await fetchSettings();
    } catch (e) {
      debugPrint('⚠️ Could not fetch settings, using defaults: $e');
      return _getDefaultSettings();
    }
  }

  /// Check registration status
  Future<RegistrationStatusResponse> checkRegistrationStatus() async {
    try {
      // Try public endpoint first (no auth required)
      return await fetchPublicStatus();
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      debugPrint('❌ Failed to check registration status: $error');
      
      // Return safe default
      return const RegistrationStatusResponse(
        canRegister: false,
        status: RegistrationStatus.maintenance,
        message: 'Unable to check registration status',
        reason: 'Service temporarily unavailable',
      );
    }
  }

  /// Get available OTP channels from public endpoint
  Future<List<OtpChannelModel>> fetchPublicOtpChannels() async {
    try {
      debugPrint('🔄 Fetching public OTP channels...');

      final response = await _retryService.executeWithRetry(
        () => _dioService.requestWithRetry(
          '/api/v1/registration-settings/otp-channels',
          method: 'GET',
          retryConfig: RetryConfig.api,
        ),
        maxRetries: 3,
        shouldRetry: (error) => _shouldRetrySettingsFetch(error),
      );

      if (response.data == null) {
        throw NetworkError(
          message: 'No data received from server',
          code: 'NO_DATA',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final channelsData = data['channels'] as List<dynamic>? ?? [];
      
      final channels = channelsData.map((channelData) {
        // Handle both string and object formats
        if (channelData is String) {
          // Convert string channel to OtpChannelModel
          return OtpChannelModel(
            id: channelData.toLowerCase(),
            name: channelData.toLowerCase(),
            displayName: channelData,
            enabled: true,
            isDefault: channelData.toLowerCase() == 'sms',
            priority: channelData.toLowerCase() == 'sms' ? 1 : 2,
          );
        } else if (channelData is Map<String, dynamic>) {
          return OtpChannelModel.fromJson(channelData);
        } else {
          // Fallback for unknown format
          return const OtpChannelModel(
            id: 'sms',
            name: 'sms',
            displayName: 'SMS',
            enabled: true,
            isDefault: true,
            priority: 1,
          );
        }
      }).toList();

      debugPrint('✅ Public OTP channels fetched: ${channels.length} channels');
      
      return channels;
    } catch (e, stackTrace) {
      final error = ErrorHandler.instance.handleError(e, stackTrace);
      debugPrint('❌ Failed to fetch public OTP channels: $error');
      
      // Return default SMS channel
      return [
        const OtpChannelModel(
          id: 'sms',
          name: 'sms',
          displayName: 'SMS',
          enabled: true,
          isDefault: true,
          priority: 1,
        ),
      ];
    }
  }

  /// Get available OTP channels (simplified)
  Future<List<String>> getAvailableOtpChannels() async {
    try {
      final settings = await getCurrentSettings();
      return settings.otpChannels;
    } catch (e) {
      debugPrint('❌ Failed to get OTP channels: $e');
      // Return default SMS channel
      return ['SMS'];
    }
  }

  /// Get default OTP channel (simplified)
  Future<String?> getDefaultOtpChannel() async {
    try {
      final settings = await getCurrentSettings();
      return settings.defaultChannel;
    } catch (e) {
      debugPrint('❌ Failed to get default OTP channel: $e');
      return 'SMS';
    }
  }

  /// Select OTP channel for user
  Future<OtpChannelSelection> selectOtpChannel(
    String phoneNumber,
    List<OtpChannelModel> availableChannels,
  ) async {
    try {
      // If only one channel available, select it automatically
      if (availableChannels.length == 1) {
        final selectedChannel = availableChannels.first;
        return OtpChannelSelection(
          selectedChannel: selectedChannel.name,
          phoneNumber: phoneNumber,
          success: true,
          message: 'Channel selected automatically: ${selectedChannel.displayName}',
        );
      }

      // If multiple channels, select the default one (highest priority)
      final defaultChannel = availableChannels
          .where((channel) => channel.isDefault)
          .firstOrNull;
      
      if (defaultChannel != null) {
        return OtpChannelSelection(
          selectedChannel: defaultChannel.name,
          phoneNumber: phoneNumber,
          success: true,
          message: 'Default channel selected: ${defaultChannel.displayName}',
        );
      }

      // Fallback to first enabled channel
      final enabledChannel = availableChannels
          .where((channel) => channel.enabled)
          .firstOrNull;
      
      if (enabledChannel != null) {
        return OtpChannelSelection(
          selectedChannel: enabledChannel.name,
          phoneNumber: phoneNumber,
          success: true,
          message: 'Channel selected: ${enabledChannel.displayName}',
        );
      }

      // No suitable channel found
      return const OtpChannelSelection(
        selectedChannel: 'sms',
        phoneNumber: '',
        success: false,
        message: 'No suitable OTP channel found',
      );
    } catch (e) {
      debugPrint('❌ Failed to select OTP channel: $e');
      return const OtpChannelSelection(
        selectedChannel: 'sms',
        phoneNumber: '',
        success: false,
        message: 'Error selecting OTP channel',
      );
    }
  }



  /// Validate registration before allowing registration flow
  Future<bool> validateRegistrationAllowed() async {
    try {
      final status = await checkRegistrationStatus();
      return status.canRegister;
    } catch (e) {
      debugPrint('❌ Failed to validate registration: $e');
      return false;
    }
  }

  /// Force refresh settings
  Future<RegistrationSettingsModel> refreshSettings() async {
    return await fetchSettings(useCache: false, forceRefresh: true);
  }

  /// Clear cached settings
  Future<void> clearCache() async {
    try {
      await _storageService.delete(_cacheKey);
      _cache = null;
      debugPrint('🗑️ Registration settings cache cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear settings cache: $e');
    }
  }

  // Private methods

  /// Load cached settings from storage
  Future<void> _loadCachedSettings() async {
    try {
      final cachedData = await _storageService.read(_cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        final cacheJson = jsonDecode(cachedData) as Map<String, dynamic>;
        _cache = RegistrationSettingsCache.fromJson(cacheJson);
        
        if (_cache!.isValid) {
          debugPrint('📦 Loaded valid cached registration settings');
          _settingsController?.add(_cache!.settings);
        } else {
          debugPrint('⏰ Cached registration settings expired');
          _cache = null;
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to load cached settings: $e');
      _cache = null;
    }
  }

  /// Cache settings to storage
  Future<void> _cacheSettings(RegistrationSettingsModel settings) async {
    try {
      final cache = RegistrationSettingsCache(
        settings: settings,
        cachedAt: DateTime.now(),
        cacheExpiry: _defaultCacheExpiry,
      );
      
      final cacheJson = jsonEncode(cache.toJson());
      await _storageService.write(_cacheKey, cacheJson);
      
      _cache = cache;
      debugPrint('💾 Registration settings cached successfully');
    } catch (e) {
      debugPrint('❌ Failed to cache settings: $e');
    }
  }

  /// Setup periodic refresh timer
  void _setupPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => fetchSettings(useCache: false),
    );
  }

  /// Get default settings as fallback
  RegistrationSettingsModel _getDefaultSettings() {
    return RegistrationSettingsModel(
      id: 'default',
      registrationStatus: RegistrationStatus.open,
      otpChannels: ['SMS'],
      otpLength: 6,
      otpExpiryMinutes: 10,
      maxOtpAttempts: 3,
      otpCooldownMinutes: 5,
      requireDocumentUpload: true,
      allowEmailRegistration: true,
      requirePhoneVerification: true,
      autoApproveProfiles: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if should retry settings fetch
  bool _shouldRetrySettingsFetch(dynamic error) {
    if (error is NetworkError) {
      return error.isRetryable;
    }
    return false;
  }

  /// Check if should retry OTP request
  bool _shouldRetryOtpRequest(dynamic error) {
    if (error is NetworkError) {
      // Don't retry on client errors (4xx)
      if (error.statusCode != null && error.statusCode! >= 400 && error.statusCode! < 500) {
        return false;
      }
      return error.isRetryable;
    }
    return false;
  }

  /// Get status reason for user display
  String? _getStatusReason(RegistrationSettingsModel settings) {
    if (!settings.registrationEnabled) {
      return 'Registration is disabled';
    }
    
    switch (settings.registrationStatus) {
      case RegistrationStatus.closed:
        return 'Registration period has ended';
      case RegistrationStatus.maintenance:
        return 'System is under maintenance';
      case RegistrationStatus.limited:
        return 'Registration is limited';
      case RegistrationStatus.open:
        return null;
    }
  }

  /// Get next available time for registration
  DateTime? _getNextAvailableTime(RegistrationSettingsModel settings) {
    if (settings.registrationStatus == RegistrationStatus.maintenance && 
        settings.maintenanceMessage != null) {
      // Return null since we don't have maintenance end time in new model
      return null;
    }
    
    return null;
  }

  /// Get user-friendly OTP error message
  String _getOtpErrorMessage(AppError error) {
    if (error is NetworkError) {
      if (error.statusCode == 429) {
        return 'Too many requests. Please wait before trying again.';
      }
      if (error.statusCode == 400) {
        return 'Invalid phone number or channel not available.';
      }
      if (error.isConnectionError) {
        return 'No internet connection. Please check your network.';
      }
      if (error.isTimeout) {
        return 'Request timeout. Please try again.';
      }
    }
    
    return error.message;
  }
}

/// Provider for registration settings service
final registrationSettingsServiceProvider = Provider<RegistrationSettingsService>((ref) {
  return RegistrationSettingsService.instance;
});

/// Provider for registration settings stream
final registrationSettingsStreamProvider = StreamProvider<RegistrationSettingsModel>((ref) {
  final service = ref.watch(registrationSettingsServiceProvider);
  return service.settingsStream;
});

/// Provider for current registration settings
final currentRegistrationSettingsProvider = FutureProvider<RegistrationSettingsModel>((ref) {
  final service = ref.watch(registrationSettingsServiceProvider);
  return service.getCurrentSettings();
});

/// Provider for registration status
final registrationStatusProvider = FutureProvider<RegistrationStatusResponse>((ref) {
  final service = ref.watch(registrationSettingsServiceProvider);
  return service.checkRegistrationStatus();
});

/// Provider for available OTP channels
final availableOtpChannelsProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(registrationSettingsServiceProvider);
  final settings = await service.getCurrentSettings();
  return settings.otpChannels;
});

/// Provider for default OTP channel
final defaultOtpChannelProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(registrationSettingsServiceProvider);
  final settings = await service.getCurrentSettings();
  return settings.defaultChannel;
});
