import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionQuality {
  excellent,
  good,
  fair,
  poor,
  none,
}

enum TestStatus {
  pending,
  running,
  success,
  failed,
  timeout,
}

class ConnectionTestResult {
  final String testName;
  final TestStatus status;
  final String? result;
  final String? error;
  final Duration? duration;
  final DateTime timestamp;

  const ConnectionTestResult({
    required this.testName,
    required this.status,
    this.result,
    this.error,
    this.duration,
    required this.timestamp,
  });

  ConnectionTestResult copyWith({
    String? testName,
    TestStatus? status,
    String? result,
    String? error,
    Duration? duration,
    DateTime? timestamp,
  }) {
    return ConnectionTestResult(
      testName: testName ?? this.testName,
      status: status ?? this.status,
      result: result ?? this.result,
      error: error ?? this.error,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'status': status.toString(),
      'result': result,
      'error': error,
      'duration': duration?.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class NetworkInfo {
  final ConnectivityResult connectionType;
  final String? networkName;
  final String? ipAddress;
  final String? gateway;
  final String? dns;
  final int? signalStrength;

  const NetworkInfo({
    required this.connectionType,
    this.networkName,
    this.ipAddress,
    this.gateway,
    this.dns,
    this.signalStrength,
  });

  Map<String, dynamic> toJson() {
    return {
      'connectionType': connectionType.toString(),
      'networkName': networkName,
      'ipAddress': ipAddress,
      'gateway': gateway,
      'dns': dns,
      'signalStrength': signalStrength,
    };
  }
}

class ServerInfo {
  final String serverUrl;
  final int port;
  final bool isReachable;
  final Duration? responseTime;
  final String? serverVersion;
  final String? lastError;

  const ServerInfo({
    required this.serverUrl,
    required this.port,
    required this.isReachable,
    this.responseTime,
    this.serverVersion,
    this.lastError,
  });

  Map<String, dynamic> toJson() {
    return {
      'serverUrl': serverUrl,
      'port': port,
      'isReachable': isReachable,
      'responseTime': responseTime?.inMilliseconds,
      'serverVersion': serverVersion,
      'lastError': lastError,
    };
  }

  ServerInfo copyWith({
    String? serverUrl,
    int? port,
    bool? isReachable,
    Duration? responseTime,
    String? serverVersion,
    String? lastError,
  }) {
    return ServerInfo(
      serverUrl: serverUrl ?? this.serverUrl,
      port: port ?? this.port,
      isReachable: isReachable ?? this.isReachable,
      responseTime: responseTime ?? this.responseTime,
      serverVersion: serverVersion ?? this.serverVersion,
      lastError: lastError ?? this.lastError,
    );
  }
}

class SpeedTestResult {
  final double downloadSpeed; // Mbps
  final double uploadSpeed; // Mbps
  final int ping; // ms
  final int jitter; // ms
  final DateTime timestamp;

  const SpeedTestResult({
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ping,
    required this.jitter,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'downloadSpeed': downloadSpeed,
      'uploadSpeed': uploadSpeed,
      'ping': ping,
      'jitter': jitter,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ConnectionStatus {
  final bool isConnected;
  final ConnectionQuality quality;
  final NetworkInfo networkInfo;
  final ServerInfo serverInfo;
  final SpeedTestResult? speedTest;
  final List<ConnectionTestResult> testResults;
  final DateTime lastUpdated;
  final bool isLoading;
  final String? error;

  const ConnectionStatus({
    required this.isConnected,
    required this.quality,
    required this.networkInfo,
    required this.serverInfo,
    this.speedTest,
    required this.testResults,
    required this.lastUpdated,
    this.isLoading = false,
    this.error,
  });

  ConnectionStatus copyWith({
    bool? isConnected,
    ConnectionQuality? quality,
    NetworkInfo? networkInfo,
    ServerInfo? serverInfo,
    SpeedTestResult? speedTest,
    List<ConnectionTestResult>? testResults,
    DateTime? lastUpdated,
    bool? isLoading,
    String? error,
  }) {
    return ConnectionStatus(
      isConnected: isConnected ?? this.isConnected,
      quality: quality ?? this.quality,
      networkInfo: networkInfo ?? this.networkInfo,
      serverInfo: serverInfo ?? this.serverInfo,
      speedTest: speedTest ?? this.speedTest,
      testResults: testResults ?? this.testResults,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isConnected': isConnected,
      'quality': quality.toString(),
      'networkInfo': networkInfo.toJson(),
      'serverInfo': serverInfo.toJson(),
      'speedTest': speedTest?.toJson(),
      'testResults': testResults.map((test) => test.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isLoading': isLoading,
      'error': error,
    };
  }

  static ConnectionStatus initial() {
    return ConnectionStatus(
      isConnected: false,
      quality: ConnectionQuality.none,
      networkInfo: const NetworkInfo(connectionType: ConnectivityResult.none),
      serverInfo: const ServerInfo(
        serverUrl: '',
        port: 0,
        isReachable: false,
      ),
      testResults: [],
      lastUpdated: DateTime.now(),
      isLoading: false,
    );
  }
}
