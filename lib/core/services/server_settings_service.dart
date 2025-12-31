import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/storage_service.dart';

// Provider for StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return DefaultStorageService();
});

class ServerSettings {
  final String host;
  final int port;

  const ServerSettings({
    required this.host,
    required this.port,
  });

  String get baseUrl {
<<<<<<< HEAD
    // For the new API domain, use HTTPS without port
    if (host.contains('api.idec-ye.com')) {
      final url = 'https://$host';
      debugPrint('🔗 [SERVER_SETTINGS] Generated baseUrl: $url (HTTPS domain)');
      return url;
    }
    
    // For other hosts, use HTTP with port
    final cleanHost = host.replaceAll(RegExp(r':\d+$'), ''); // Remove any existing port
=======
    final cleanHost =
        host.replaceAll(RegExp(r':\d+$'), ''); // Remove any existing port

    // Use HTTPS for production API server
    if (cleanHost.contains('api.idec-ye.com')) {
      final url = 'https://$cleanHost';
      debugPrint(
          '🔗 [SERVER_SETTINGS] Generated HTTPS baseUrl: $url (host: $cleanHost)');
      return url;
    }

    // Use HTTP with port for local/development servers
>>>>>>> working-version-fixed
    final url = 'http://$cleanHost:$port';
    debugPrint(
        '🔗 [SERVER_SETTINGS] Generated HTTP baseUrl: $url (host: $cleanHost, port: $port)');
    return url;
  }

  factory ServerSettings.fromJson(Map<String, dynamic> json) {
    final host = json['host'] ?? 'api.idec-ye.com';
    final port = json['port'] ?? 3000;

    // Clean host to remove any existing port
    final cleanHost = host.toString().replaceAll(RegExp(r':\d+$'), '');

    debugPrint(
        '🔧 [SERVER_SETTINGS] fromJson - host: $host -> cleanHost: $cleanHost, port: $port');

    return ServerSettings(
      host: cleanHost,
      port: port,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
    };
  }

  ServerSettings copyWith({
    String? host,
    int? port,
  }) {
    final newHost = host ?? this.host;
    final newPort = port ?? this.port;

    // Clean host to remove any existing port
    final cleanHost = newHost.replaceAll(RegExp(r':\d+$'), '');

    return ServerSettings(
      host: cleanHost,
      port: newPort,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServerSettings && other.host == host && other.port == port;
  }

  @override
  int get hashCode => host.hashCode ^ port.hashCode;
}

class ServerSettingsService {
  static const String _serverHostKey = 'server_host';
  static const String _serverPortKey = 'server_port';
  static const String _isInitializedKey = 'server_settings_initialized';

  // Default server configurations - تم تغيير الافتراضي للخادم المستضاف
  static const ServerSettings mainServer = ServerSettings(
<<<<<<< HEAD
    host: 'api.idec-ye.com', // New API domain with HTTPS
    port: 443, // HTTPS port (not used for api.idec-ye.com)
=======
    host: 'api.idec-ye.com', // Production server
    port: 443, // HTTPS port
>>>>>>> working-version-fixed
  );

  static const ServerSettings localServer = ServerSettings(
    host: 'localhost',
    port: 3000,
  );
<<<<<<< HEAD
  
  // Fallback domain server (legacy)
=======

  // Production server for later use
  static const ServerSettings productionServer = ServerSettings(
    host: 'api.idec-ye.com',
    port: 443, // HTTPS port
  );

>>>>>>> working-version-fixed
  static const ServerSettings domainServer = ServerSettings(
    host: 'api.idec-ye.com',
    port: 443, // HTTPS port
  );

  final StorageService _storageService;

  ServerSettingsService(this._storageService);

  /// Get current server settings with enhanced validation
  Future<ServerSettings> getCurrentSettings() async {
    try {
      final host = await _storageService.getString(_serverHostKey);
      final port = await _storageService.getInt(_serverPortKey);
      final isInitialized =
          await _storageService.getBool(_isInitializedKey) ?? false;

      debugPrint(
          '🔍 [SERVER_SETTINGS] getCurrentSettings - host: $host, port: $port, initialized: $isInitialized');

      // If not initialized or missing data, use defaults and initialize
      if (!isInitialized || host == null || port == null) {
        debugPrint(
            '⚠️ [SERVER_SETTINGS] Settings not properly initialized, using defaults');
        await _initializeWithDefaults();
        return mainServer;
      }

      // Clean host to remove any existing port
      final cleanHost = host.replaceAll(RegExp(r':\d+$'), '');
      // Use 443 for HTTPS (production API) or 3000 for local development
      final validPort = port > 0
          ? port
          : (cleanHost.contains('api.idec-ye.com') ? 443 : 3000);

      final settings = ServerSettings(
        host: cleanHost,
        port: validPort,
      );

      debugPrint('✅ [SERVER_SETTINGS] Returning settings: ${settings.baseUrl}');
      return settings;
    } catch (e) {
      debugPrint('❌ [SERVER_SETTINGS] Error getting settings: $e');
      await _initializeWithDefaults();
      return mainServer;
    }
  }

  /// Initialize with default settings
  Future<void> _initializeWithDefaults() async {
    debugPrint('🔧 [SERVER_SETTINGS] Initializing with defaults');
    await saveSettings(mainServer);
    await _storageService.setBool(_isInitializedKey, true);
  }

  /// Save server settings with validation
  Future<void> saveSettings(ServerSettings settings) async {
    try {
      // Clean host to remove any existing port
      final cleanHost = settings.host.replaceAll(RegExp(r':\d+$'), '');
      // Use 443 for HTTPS (production API) or 3000 for local development
      final validPort = settings.port > 0
          ? settings.port
          : (cleanHost.contains('api.idec-ye.com') ? 443 : 3000);

      debugPrint(
          '💾 [SERVER_SETTINGS] Saving settings - host: $cleanHost, port: $validPort');

      await _storageService.setString(_serverHostKey, cleanHost);
      await _storageService.setInt(_serverPortKey, validPort);
      await _storageService.setBool(_isInitializedKey, true);

      debugPrint('✅ [SERVER_SETTINGS] Settings saved successfully');
    } catch (e) {
      debugPrint('❌ [SERVER_SETTINGS] Error saving settings: $e');
      rethrow;
    }
  }

  /// Set main server configuration
  Future<void> setMainServer() async {
    debugPrint('🌐 [SERVER_SETTINGS] Setting main server');
    await saveSettings(mainServer);
  }

  /// Set local server configuration
  Future<void> setLocalServer() async {
    debugPrint('🏠 [SERVER_SETTINGS] Setting local server');
    await saveSettings(localServer);
  }

  /// Reset to default (main server)
  Future<void> resetToDefault() async {
    debugPrint('🔄 [SERVER_SETTINGS] Resetting to default');
    await setMainServer();
  }

  /// Check if settings exist and are properly initialized
  Future<bool> hasExistingSettings() async {
    final hasHost = await _storageService.containsKey(_serverHostKey);
    final hasPort = await _storageService.containsKey(_serverPortKey);
    final isInitialized =
        await _storageService.getBool(_isInitializedKey) ?? false;

    final exists = hasHost && hasPort && isInitialized;
    debugPrint(
        '🔍 [SERVER_SETTINGS] hasExistingSettings: $exists (host: $hasHost, port: $hasPort, init: $isInitialized)');

    return exists;
  }

  /// Get base URL for current settings
  Future<String> getBaseUrl() async {
    final settings = await getCurrentSettings();
    final url = settings.baseUrl;
    debugPrint('🔗 [SERVER_SETTINGS] getBaseUrl: $url');
    return url;
  }

  /// Validate and fix existing settings
  Future<void> validateAndFixSettings() async {
    try {
      debugPrint('🔧 [SERVER_SETTINGS] Validating and fixing settings');

      final hasSettings = await hasExistingSettings();
      if (!hasSettings) {
        debugPrint(
            '⚠️ [SERVER_SETTINGS] No valid settings found, initializing defaults');
        await _initializeWithDefaults();
        return;
      }

      final settings = await getCurrentSettings();

      // Validate the generated URL
      final url = settings.baseUrl;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        debugPrint('❌ [SERVER_SETTINGS] Invalid URL detected: $url, fixing...');
        await _initializeWithDefaults();
      } else {
        debugPrint('✅ [SERVER_SETTINGS] Settings are valid: $url');
      }
    } catch (e) {
      debugPrint('❌ [SERVER_SETTINGS] Error during validation: $e');
      await _initializeWithDefaults();
    }
  }
}

// Provider for ServerSettingsService
final serverSettingsServiceProvider = Provider<ServerSettingsService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ServerSettingsService(storageService);
});

// Provider for current server settings
final currentServerSettingsProvider =
    FutureProvider<ServerSettings>((ref) async {
  final service = ref.watch(serverSettingsServiceProvider);
  return await service.getCurrentSettings();
});

// Provider for base URL
final baseUrlProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(serverSettingsServiceProvider);
  return await service.getBaseUrl();
});
