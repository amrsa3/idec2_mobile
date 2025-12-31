import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// خدمة إدارة الاتصال المحسنة
/// تدعم مراقبة حالة الاتصال وإدارة التبديل بين الوضعين
class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._internal();

  late Connectivity _connectivity;
  late Completer<void> _initCompleter;
  bool _isInitialized = false;

  // Stream controllers
  final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();
  final StreamController<bool> _isConnectedController =
      StreamController<bool>.broadcast();

  // Current state
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;
  bool _isConnected = false;

  // Configuration
  static const Duration _connectionCheckInterval = Duration(seconds: 30);
  static const Duration _connectionTimeout = Duration(seconds: 10);

  // Monitoring
  Timer? _monitoringTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  ConnectivityService._internal() {
    _initCompleter = Completer<void>();
  }

  /// Stream لحالة الاتصال
  Stream<ConnectivityStatus> get connectivityStream => _statusController.stream;

  /// Stream لحالة الاتصال (boolean)
  Stream<bool> get isConnectedStream => _isConnectedController.stream;

  /// الحالة الحالية للاتصال
  ConnectivityStatus get currentStatus => _currentStatus;

  /// هل متصل حالياً
  bool get isConnected => _isConnected;

  /// تهيئة الخدمة
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint(
          '🌐 [CONNECTIVITY_SERVICE] Initializing connectivity service...');

      _connectivity = Connectivity();

      // Get initial connectivity status
      await _checkConnectivity();

      // Start monitoring
      _startMonitoring();

      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      debugPrint(
          '✅ [CONNECTIVITY_SERVICE] Connectivity service initialized successfully');
    } catch (e) {
      debugPrint('❌ [CONNECTIVITY_SERVICE] Initialization error: $e');
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
      rethrow;
    }
  }

  /// التأكد من التهيئة
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
    await _initCompleter.future;
  }

  /// التحقق من حالة الاتصال
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _updateConnectivityStatus(result);
    } catch (e) {
      debugPrint('❌ [CONNECTIVITY_SERVICE] Error checking connectivity: $e');
      _updateStatus(ConnectivityStatus.unknown, false);
    }
  }

  /// تحديث حالة الاتصال
  Future<void> _updateConnectivityStatus(ConnectivityResult result) async {
    try {
      ConnectivityStatus newStatus;
      bool newIsConnected;

      switch (result) {
        case ConnectivityResult.wifi:
          newStatus = ConnectivityStatus.wifi;
          newIsConnected = await _testInternetConnection();
          break;
        case ConnectivityResult.mobile:
          newStatus = ConnectivityStatus.mobile;
          newIsConnected = await _testInternetConnection();
          break;
        case ConnectivityResult.ethernet:
          newStatus = ConnectivityStatus.ethernet;
          newIsConnected = await _testInternetConnection();
          break;
        case ConnectivityResult.vpn:
          newStatus = ConnectivityStatus.vpn;
          newIsConnected = await _testInternetConnection();
          break;
        case ConnectivityResult.bluetooth:
          newStatus = ConnectivityStatus.bluetooth;
          newIsConnected = await _testInternetConnection();
          break;
        case ConnectivityResult.other:
          newStatus = ConnectivityStatus.other;
          newIsConnected = await _testInternetConnection();
          break;
        case ConnectivityResult.none:
          newStatus = ConnectivityStatus.disconnected;
          newIsConnected = false;
          break;
      }

      _updateStatus(newStatus, newIsConnected);
    } catch (e) {
      debugPrint(
          '❌ [CONNECTIVITY_SERVICE] Error updating connectivity status: $e');
      _updateStatus(ConnectivityStatus.unknown, false);
    }
  }

  /// اختبار الاتصال بالإنترنت
  Future<bool> _testInternetConnection() async {
    try {
      // On web platform, use HTTP request instead of InternetAddress.lookup
      if (kIsWeb) {
        try {
          final response = await http.get(
            Uri.parse('https://www.google.com'),
          ).timeout(_connectionTimeout);
          return response.statusCode == 200;
        } catch (e) {
          debugPrint('❌ [CONNECTIVITY_SERVICE] Web internet test failed: $e');
          return false;
        }
      }

      // On mobile platforms, use InternetAddress.lookup
      final result = await InternetAddress.lookup('google.com')
          .timeout(_connectionTimeout);

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      debugPrint(
          '❌ [CONNECTIVITY_SERVICE] Internet connection test failed: $e');
      return false;
    }
  }

  /// تحديث الحالة
  void _updateStatus(ConnectivityStatus status, bool isConnected) {
    final statusChanged = _currentStatus != status;
    final connectionChanged = _isConnected != isConnected;

    _currentStatus = status;
    _isConnected = isConnected;

    if (statusChanged) {
      debugPrint(
          '🌐 [CONNECTIVITY_SERVICE] Connectivity status changed: $status');
      _statusController.add(status);
    }

    if (connectionChanged) {
      debugPrint(
          '🌐 [CONNECTIVITY_SERVICE] Connection status changed: $isConnected');
      _isConnectedController.add(isConnected);
    }
  }

  /// بدء المراقبة
  void _startMonitoring() {
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectivityStatus,
      onError: (error) {
        debugPrint(
            '❌ [CONNECTIVITY_SERVICE] Connectivity monitoring error: $error');
      },
    );

    // Periodic connectivity check
    _monitoringTimer = Timer.periodic(_connectionCheckInterval, (timer) async {
      try {
        await _checkConnectivity();
      } catch (e) {
        debugPrint('❌ [CONNECTIVITY_SERVICE] Periodic check error: $e');
      }
    });
  }

  /// إيقاف المراقبة
  void _stopMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }

  /// التحقق من الاتصال (public method)
  Future<bool> checkConnection() async {
    await _ensureInitialized();
    await _checkConnectivity();
    return _isConnected;
  }

  /// الحصول على نوع الاتصال الحالي
  Future<ConnectivityStatus> getCurrentConnectivityType() async {
    await _ensureInitialized();
    return _currentStatus;
  }

  /// انتظار الاتصال
  Future<void> waitForConnection({Duration? timeout}) async {
    await _ensureInitialized();

    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = isConnectedStream.listen((connected) {
      if (connected) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    // Check if already connected
    if (_isConnected) {
      subscription.cancel();
      completer.complete();
    }

    // Set timeout if provided
    if (timeout != null) {
      Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer
              .completeError(TimeoutException('Connection timeout', timeout));
        }
      });
    }

    return completer.future;
  }

  /// الحصول على معلومات الاتصال
  Future<Map<String, dynamic>> getConnectivityInfo() async {
    await _ensureInitialized();

    return {
      'currentStatus': _currentStatus.name,
      'isConnected': _isConnected,
      'connectionType': _currentStatus.name,
      'lastCheck': DateTime.now().toIso8601String(),
      'platform': kIsWeb ? 'web' : Platform.operatingSystem,
    };
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    try {
      debugPrint('🌐 [CONNECTIVITY_SERVICE] Disposing...');

      _stopMonitoring();

      await _statusController.close();
      await _isConnectedController.close();
      } catch (e) {
      debugPrint('❌ [CONNECTIVITY_SERVICE] Disposal error: $e');
    }
  }
}

/// أنواع حالة الاتصال
enum ConnectivityStatus {
  wifi,
  mobile,
  ethernet,
  vpn,
  bluetooth,
  other,
  disconnected,
  unknown,
}

/// Provider للخدمة
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService.instance;
});

/// Provider لحالة الاتصال
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

/// Provider لحالة الاتصال (boolean)
final isConnectedProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.isConnectedStream;
});
