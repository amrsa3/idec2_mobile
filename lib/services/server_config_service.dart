import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config_model.dart';

class ServerConfigService {
  static ServerConfigService? _instance;
  static const String _serverConfigKey = 'server_config';
  static const String _customConfigKey = 'custom_server_config';
  
  ServerConfigService._();
  
  factory ServerConfigService() {
    _instance ??= ServerConfigService._();
    return _instance!;
  }

  /// Get current server configuration
  Future<ServerConfig> getServerConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString(_serverConfigKey);
      
      if (configJson != null) {
        final configMap = json.decode(configJson) as Map<String, dynamic>;
        return ServerConfig.fromJson(configMap);
      }
    } catch (e) {
      // If there's an error reading saved config, fall back to default
    }
    
    // Return default configuration
    return DefaultServerConfigs.development;
  }

  /// Save server configuration
  Future<bool> saveServerConfig(ServerConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(config.toJson());
      return await prefs.setString(_serverConfigKey, configJson);
    } catch (e) {
      return false;
    }
  }

  /// Save custom server configuration
  Future<bool> saveCustomConfig(ServerConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = json.encode(config.toJson());
      return await prefs.setString(_customConfigKey, configJson);
    } catch (e) {
      return false;
    }
  }

  /// Get custom server configuration
  Future<ServerConfig?> getCustomConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString(_customConfigKey);
      
      if (configJson != null) {
        final configMap = json.decode(configJson) as Map<String, dynamic>;
        return ServerConfig.fromJson(configMap);
      }
    } catch (e) {
      // Return null if no custom config or error
    }
    
    return null;
  }

  /// Reset to default configuration
  Future<bool> resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_serverConfigKey);
      await prefs.remove(_customConfigKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Test server connectivity
  Future<ServerTestResult> testServerConnection(ServerConfig config) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 5);
      
      // Try primary health endpoint first
      try {
        final response = await dio.get('${config.fullUrl}/api/v1/health');
        stopwatch.stop();
        
        if (response.statusCode == 200) {
          return ServerTestResult(
            isReachable: true,
            responseTime: stopwatch.elapsedMilliseconds,
            statusCode: response.statusCode,
            message: 'Server is reachable via /api/v1/health',
            endpoint: '/api/v1/health',
          );
        }
      } catch (e) {
        // If primary health endpoint fails, try a simpler fallback
        try {
          final response = await dio.get('${config.fullUrl}/api/v1/health/ping');
          stopwatch.stop();
          
          if (response.statusCode == 200) {
            return ServerTestResult(
              isReachable: true,
              responseTime: stopwatch.elapsedMilliseconds,
              statusCode: response.statusCode,
              message: 'Server is reachable via ping endpoint',
              endpoint: '/api/v1/health/ping',
            );
          }
        } catch (fallbackError) {
          // Both endpoints failed, throw the original error
          throw e;
        }
      }
      
      stopwatch.stop();
      
      return ServerTestResult(
        isReachable: false,
        responseTime: stopwatch.elapsedMilliseconds,
        message: 'No successful response from any endpoint',
        endpoint: 'Multiple endpoints tested',
      );
    } on DioException catch (e) {
      stopwatch.stop();
      return ServerTestResult(
        isReachable: false,
        responseTime: stopwatch.elapsedMilliseconds,
        statusCode: e.response?.statusCode,
        message: _getDioErrorMessage(e),
        error: e.toString(),
        endpoint: 'Connection failed to all endpoints',
      );
    } catch (e) {
      stopwatch.stop();
      return ServerTestResult(
        isReachable: false,
        responseTime: stopwatch.elapsedMilliseconds,
        message: 'Connection failed: ${e.toString()}',
        error: e.toString(),
        endpoint: 'Connection failed to all endpoints',
      );
    }
  }

  /// Test internet connectivity
  Future<bool> testInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Validate server configuration
  ServerConfigValidation validateConfig(String baseUrl, int port) {
    String? urlError;
    String? portError;

    // Validate URL
    if (baseUrl.isEmpty) {
      urlError = 'Server URL is required';
    } else if (!_isValidUrl(baseUrl)) {
      urlError = 'Invalid URL format';
    }

    // Validate port
    if (port <= 0 || port > 65535) {
      portError = 'Port must be between 1 and 65535';
    }

    return ServerConfigValidation(
      urlError: urlError,
      portError: portError,
      isValid: urlError == null && portError == null,
    );
  }

  /// Get all available server presets
  List<ServerConfig> getServerPresets() {
    return DefaultServerConfigs.presets;
  }

  bool _isValidUrl(String url) {
    try {
      // Remove protocol if present for validation
      String cleanUrl = url.replaceAll(RegExp(r'^https?://'), '');
      
      // Check if it's a valid hostname or IP
      if (cleanUrl.isEmpty) return false;
      
      // Basic validation for hostname/IP format
      final hostnameRegex = RegExp(r'^[a-zA-Z0-9.-]+$');
      final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
      
      return hostnameRegex.hasMatch(cleanUrl) || ipRegex.hasMatch(cleanUrl);
    } catch (e) {
      return false;
    }
  }

  String _getDioErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.badResponse:
        return 'Bad response: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.unknown:
        return 'Unknown error';
      default:
        return 'Network error';
    }
  }
}

class ServerTestResult {
  final bool isReachable;
  final int responseTime;
  final int? statusCode;
  final String message;
  final String? error;
  final String? endpoint;

  ServerTestResult({
    required this.isReachable,
    required this.responseTime,
    this.statusCode,
    required this.message,
    this.error,
    this.endpoint,
  });
}
