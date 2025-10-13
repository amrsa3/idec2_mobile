import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/storage_service.dart';

// Provider for StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

class ServerSettings {
  final String host;
  final int port;

  const ServerSettings({
    required this.host,
    required this.port,
  });

  String get baseUrl => 'http://$host:$port';

  factory ServerSettings.fromJson(Map<String, dynamic> json) {
    return ServerSettings(
      host: json['host'] ?? 'idec-ye.com',
      port: json['port'] ?? 3000,
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
    return ServerSettings(
      host: host ?? this.host,
      port: port ?? this.port,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServerSettings &&
        other.host == host &&
        other.port == port;
  }

  @override
  int get hashCode => host.hashCode ^ port.hashCode;
}

class ServerSettingsService {
  static const String _serverHostKey = 'server_host';
  static const String _serverPortKey = 'server_port';
  
  // Default server configurations
  static const ServerSettings mainServer = ServerSettings(
    host: 'localhost',
    port: 3000,
  );
  
  static const ServerSettings localServer = ServerSettings(
    host: 'localhost',
    port: 3000,
  );

  final StorageService _storageService;

  ServerSettingsService(this._storageService);

  /// Get current server settings
  Future<ServerSettings> getCurrentSettings() async {
    final host = await _storageService.getString(_serverHostKey);
    final port = await _storageService.getInt(_serverPortKey);
    
    return ServerSettings(
      host: host ?? mainServer.host,
      port: port ?? mainServer.port,
    );
  }

  /// Save server settings
  Future<void> saveSettings(ServerSettings settings) async {
    await _storageService.setString(_serverHostKey, settings.host);
    await _storageService.setInt(_serverPortKey, settings.port);
  }

  /// Set main server configuration
  Future<void> setMainServer() async {
    await saveSettings(mainServer);
  }

  /// Set local server configuration
  Future<void> setLocalServer() async {
    await saveSettings(localServer);
  }

  /// Reset to default (main server)
  Future<void> resetToDefault() async {
    await setMainServer();
  }

  /// Check if settings exist
  Future<bool> hasExistingSettings() async {
    return _storageService.containsKey(_serverHostKey) &&
           _storageService.containsKey(_serverPortKey);
  }

  /// Get base URL for current settings
  Future<String> getBaseUrl() async {
    final settings = await getCurrentSettings();
    return settings.baseUrl;
  }
}

// Provider for ServerSettingsService
final serverSettingsServiceProvider = Provider<ServerSettingsService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ServerSettingsService(storageService);
});

// Provider for current server settings
final currentServerSettingsProvider = FutureProvider<ServerSettings>((ref) async {
  final service = ref.watch(serverSettingsServiceProvider);
  return await service.getCurrentSettings();
});

// Provider for base URL
final baseUrlProvider = FutureProvider<String>((ref) async {
  final service = ref.watch(serverSettingsServiceProvider);
  return await service.getBaseUrl();
});