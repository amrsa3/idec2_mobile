import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/server_config_model.dart';
import 'server_config_service.dart';

class ErrorReportingService {
  static ErrorReportingService? _instance;
  
  ErrorReportingService._();
  
  factory ErrorReportingService() {
    _instance ??= ErrorReportingService._();
    return _instance!;
  }

  /// Generate comprehensive error report
  Future<ErrorReport> generateErrorReport({
    String? errorMessage,
    String? stackTrace,
    Map<String, dynamic>? additionalData,
  }) async {
    final deviceInfo = await _getDeviceInfo();
    final appInfo = await _getAppInfo();
    final serverConfig = await _getServerConfig();
    final networkInfo = await _getNetworkInfo();

    return ErrorReport(
      timestamp: DateTime.now(),
      errorMessage: errorMessage,
      stackTrace: stackTrace,
      deviceInfo: deviceInfo,
      appInfo: appInfo,
      serverConfig: serverConfig,
      networkInfo: networkInfo,
      additionalData: additionalData,
    );
  }

  /// Export error report to file
  Future<String> exportErrorReport(ErrorReport report) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'error_report_${report.timestamp.millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      
      final jsonString = const JsonEncoder.withIndent('  ').convert(report.toJson());
      await file.writeAsString(jsonString);
      
      return file.path;
    } catch (e) {
      throw Exception('Failed to export error report: $e');
    }
  }

  /// Share error report
  Future<void> shareErrorReport(ErrorReport report) async {
    try {
      final filePath = await exportErrorReport(report);
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'IDEC App Error Report - ${report.timestamp}',
        text: 'Error report generated on ${report.timestamp}\n\n'
              'Error: ${report.errorMessage ?? 'Unknown error'}\n'
              'Server: ${report.serverConfig?.fullUrl ?? 'Unknown'}\n'
              'Device: ${report.deviceInfo?.model ?? 'Unknown'}',
      );
    } catch (e) {
      throw Exception('Failed to share error report: $e');
    }
  }

  /// Get formatted error report as text
  String getFormattedReport(ErrorReport report) {
    final buffer = StringBuffer();
    
    buffer.writeln('IDEC App Error Report');
    buffer.writeln('=' * 50);
    buffer.writeln('Generated: ${report.timestamp}');
    buffer.writeln();
    
    if (report.errorMessage != null) {
      buffer.writeln('Error Message:');
      buffer.writeln(report.errorMessage);
      buffer.writeln();
    }
    
    if (report.stackTrace != null) {
      buffer.writeln('Stack Trace:');
      buffer.writeln(report.stackTrace);
      buffer.writeln();
    }
    
    buffer.writeln('App Information:');
    buffer.writeln('- Version: ${report.appInfo?.version ?? 'Unknown'}');
    buffer.writeln('- Build: ${report.appInfo?.buildNumber ?? 'Unknown'}');
    buffer.writeln('- Package: ${report.appInfo?.packageName ?? 'Unknown'}');
    buffer.writeln();
    
    buffer.writeln('Device Information:');
    buffer.writeln('- Model: ${report.deviceInfo?.model ?? 'Unknown'}');
    buffer.writeln('- OS: ${report.deviceInfo?.operatingSystem ?? 'Unknown'}');
    buffer.writeln('- OS Version: ${report.deviceInfo?.osVersion ?? 'Unknown'}');
    buffer.writeln();
    
    buffer.writeln('Server Configuration:');
    buffer.writeln('- URL: ${report.serverConfig?.fullUrl ?? 'Unknown'}');
    buffer.writeln('- Secure: ${report.serverConfig?.isSecure ?? false}');
    buffer.writeln('- Last Tested: ${report.serverConfig?.lastTested ?? 'Never'}');
    buffer.writeln('- Reachable: ${report.serverConfig?.isReachable ?? false}');
    if (report.serverConfig?.responseTime != null) {
      buffer.writeln('- Response Time: ${report.serverConfig!.responseTime}ms');
    }
    buffer.writeln();
    
    buffer.writeln('Network Information:');
    buffer.writeln('- Internet Connected: ${report.networkInfo?.isConnected ?? false}');
    buffer.writeln('- Connection Type: ${report.networkInfo?.connectionType ?? 'Unknown'}');
    buffer.writeln();
    
    if (report.additionalData != null && report.additionalData!.isNotEmpty) {
      buffer.writeln('Additional Data:');
      report.additionalData!.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  Future<DeviceInfo> _getDeviceInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return DeviceInfo(
          model: androidInfo.model,
          manufacturer: androidInfo.manufacturer,
          operatingSystem: 'Android',
          osVersion: androidInfo.version.release,
          isPhysicalDevice: androidInfo.isPhysicalDevice,
        );
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return DeviceInfo(
          model: iosInfo.model,
          manufacturer: 'Apple',
          operatingSystem: 'iOS',
          osVersion: iosInfo.systemVersion,
          isPhysicalDevice: iosInfo.isPhysicalDevice,
        );
      }
    } catch (e) {
      // Fallback device info
    }
    
    return DeviceInfo(
      model: 'Unknown',
      manufacturer: 'Unknown',
      operatingSystem: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      isPhysicalDevice: true,
    );
  }

  Future<AppInfo> _getAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return AppInfo(
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
      );
    } catch (e) {
      return AppInfo(
        appName: 'IDEC Conference App',
        packageName: 'com.idec.conference',
        version: 'Unknown',
        buildNumber: 'Unknown',
      );
    }
  }

  Future<ServerConfig?> _getServerConfig() async {
    try {
      final serverConfigService = ServerConfigService();
      return await serverConfigService.getServerConfig();
    } catch (e) {
      return null;
    }
  }

  Future<NetworkInfo> _getNetworkInfo() async {
    try {
      final serverConfigService = ServerConfigService();
      final isConnected = await serverConfigService.testInternetConnection();
      
      return NetworkInfo(
        isConnected: isConnected,
        connectionType: 'Unknown', // Could be enhanced with connectivity_plus
      );
    } catch (e) {
      return NetworkInfo(
        isConnected: false,
        connectionType: 'Unknown',
      );
    }
  }
}

class ErrorReport {
  final DateTime timestamp;
  final String? errorMessage;
  final String? stackTrace;
  final DeviceInfo? deviceInfo;
  final AppInfo? appInfo;
  final ServerConfig? serverConfig;
  final NetworkInfo? networkInfo;
  final Map<String, dynamic>? additionalData;

  ErrorReport({
    required this.timestamp,
    this.errorMessage,
    this.stackTrace,
    this.deviceInfo,
    this.appInfo,
    this.serverConfig,
    this.networkInfo,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'errorMessage': errorMessage,
      'stackTrace': stackTrace,
      'deviceInfo': deviceInfo?.toJson(),
      'appInfo': appInfo?.toJson(),
      'serverConfig': serverConfig?.toJson(),
      'networkInfo': networkInfo?.toJson(),
      'additionalData': additionalData,
    };
  }

  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    return ErrorReport(
      timestamp: DateTime.parse(json['timestamp']),
      errorMessage: json['errorMessage'],
      stackTrace: json['stackTrace'],
      deviceInfo: json['deviceInfo'] != null 
          ? DeviceInfo.fromJson(json['deviceInfo']) 
          : null,
      appInfo: json['appInfo'] != null 
          ? AppInfo.fromJson(json['appInfo']) 
          : null,
      serverConfig: json['serverConfig'] != null 
          ? ServerConfig.fromJson(json['serverConfig']) 
          : null,
      networkInfo: json['networkInfo'] != null 
          ? NetworkInfo.fromJson(json['networkInfo']) 
          : null,
      additionalData: json['additionalData'],
    );
  }
}

class DeviceInfo {
  final String model;
  final String manufacturer;
  final String operatingSystem;
  final String osVersion;
  final bool isPhysicalDevice;

  DeviceInfo({
    required this.model,
    required this.manufacturer,
    required this.operatingSystem,
    required this.osVersion,
    required this.isPhysicalDevice,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'manufacturer': manufacturer,
      'operatingSystem': operatingSystem,
      'osVersion': osVersion,
      'isPhysicalDevice': isPhysicalDevice,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      model: json['model'],
      manufacturer: json['manufacturer'],
      operatingSystem: json['operatingSystem'],
      osVersion: json['osVersion'],
      isPhysicalDevice: json['isPhysicalDevice'],
    );
  }
}

class AppInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appName: json['appName'],
      packageName: json['packageName'],
      version: json['version'],
      buildNumber: json['buildNumber'],
    );
  }
}

class NetworkInfo {
  final bool isConnected;
  final String connectionType;

  NetworkInfo({
    required this.isConnected,
    required this.connectionType,
  });

  Map<String, dynamic> toJson() {
    return {
      'isConnected': isConnected,
      'connectionType': connectionType,
    };
  }

  factory NetworkInfo.fromJson(Map<String, dynamic> json) {
    return NetworkInfo(
      isConnected: json['isConnected'],
      connectionType: json['connectionType'],
    );
  }
}
