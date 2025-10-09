import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum ConnectionStatus {
  online,
  offline,
  checking,
}

class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker =
      InternetConnectionChecker();

  StreamController<ConnectionStatus>? _connectionStatusController;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StreamSubscription<InternetConnectionStatus>? _internetSubscription;

  ConnectionStatus _currentStatus = ConnectionStatus.checking;

  ConnectivityService._internal() {
    _initializeConnectivity();
  }

  Stream<ConnectionStatus> get connectionStatusStream {
    _connectionStatusController ??=
        StreamController<ConnectionStatus>.broadcast();
    return _connectionStatusController!.stream;
  }

  ConnectionStatus get currentStatus => _currentStatus;

  void _initializeConnectivity() {
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _updateConnectionStatus([result]);
      },
    );

    // Listen to internet connection changes
    _internetSubscription = _internetChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        _updateInternetStatus(status);
      },
    );

    // Check initial status
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus([connectivityResult]);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      _setConnectionStatus(ConnectionStatus.offline);
    } else {
      // Has connectivity, but check if internet is actually available
      _checkInternetConnection();
    }
  }

  void _updateInternetStatus(InternetConnectionStatus status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        _setConnectionStatus(ConnectionStatus.online);
        break;
      case InternetConnectionStatus.disconnected:
        _setConnectionStatus(ConnectionStatus.offline);
        break;
    }
  }

  Future<void> _checkInternetConnection() async {
    _setConnectionStatus(ConnectionStatus.checking);

    try {
      final hasInternet = await _internetChecker.hasConnection;
      _setConnectionStatus(
        hasInternet ? ConnectionStatus.online : ConnectionStatus.offline,
      );
    } catch (e) {
      _setConnectionStatus(ConnectionStatus.offline);
    }
  }

  void _setConnectionStatus(ConnectionStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _connectionStatusController?.add(status);
    }
  }

  // Check if device is online
  Future<bool> isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return await _internetChecker.hasConnection;
    } catch (e) {
      return false;
    }
  }

  // Check if device has connectivity (but not necessarily internet)
  Future<bool> hasConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  // Get current connectivity type
  Future<List<ConnectivityResult>> getConnectivityType() async {
    final result = await _connectivity.checkConnectivity();
    return [result];
  }

  // Get connection type as string
  Future<String> getConnectionTypeString() async {
    final result = await _connectivity.checkConnectivity();

    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'بيانات الجوال';
      case ConnectivityResult.ethernet:
        return 'إيثرنت';
      case ConnectivityResult.none:
        return 'غير متصل';
      default:
        return 'غير معروف';
    }
  }

  // Test connection to specific host
  Future<bool> testConnection({
    String host = 'google.com',
    int port = 443,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final result = await InternetConnectionChecker.createInstance(
        checkTimeout: timeout,
        checkInterval: const Duration(seconds: 1),
      ).hasConnection;
      return result;
    } catch (e) {
      return false;
    }
  }

  // Get connection quality (rough estimate based on response time)
  Future<ConnectionQuality> getConnectionQuality() async {
    if (!await isOnline()) {
      return ConnectionQuality.offline;
    }

    try {
      final stopwatch = Stopwatch()..start();
      final hasConnection = await _internetChecker.hasConnection;
      stopwatch.stop();

      if (!hasConnection) {
        return ConnectionQuality.offline;
      }

      final responseTime = stopwatch.elapsedMilliseconds;

      if (responseTime < 500) {
        return ConnectionQuality.excellent;
      } else if (responseTime < 1000) {
        return ConnectionQuality.good;
      } else if (responseTime < 2000) {
        return ConnectionQuality.fair;
      } else {
        return ConnectionQuality.poor;
      }
    } catch (e) {
      return ConnectionQuality.offline;
    }
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _internetSubscription?.cancel();
    _connectionStatusController?.close();
  }
}

enum ConnectionQuality {
  excellent,
  good,
  fair,
  poor,
  offline,
}

extension ConnectionQualityExtension on ConnectionQuality {
  String get displayName {
    switch (this) {
      case ConnectionQuality.excellent:
        return 'ممتاز';
      case ConnectionQuality.good:
        return 'جيد';
      case ConnectionQuality.fair:
        return 'متوسط';
      case ConnectionQuality.poor:
        return 'ضعيف';
      case ConnectionQuality.offline:
        return 'غير متصل';
    }
  }

  String get description {
    switch (this) {
      case ConnectionQuality.excellent:
        return 'اتصال سريع وموثوق';
      case ConnectionQuality.good:
        return 'اتصال جيد';
      case ConnectionQuality.fair:
        return 'اتصال متوسط السرعة';
      case ConnectionQuality.poor:
        return 'اتصال بطيء';
      case ConnectionQuality.offline:
        return 'لا يوجد اتصال بالإنترنت';
    }
  }
}

// Riverpod providers
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService.instance;
});

final connectionStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionStatusStream;
});

final connectionQualityProvider = FutureProvider<ConnectionQuality>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.getConnectionQuality();
});
