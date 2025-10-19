import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Enhanced connectivity service for checking internet and server connectivity
class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance => _instance ??= ConnectivityService._();

  ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final Dio _dio = Dio();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  
  bool _isOnline = true;
  bool _isServerReachable = false;
  DateTime? _lastServerCheck;
  
  final List<Function(bool)> _connectivityListeners = [];
  final List<Function(bool)> _serverListeners = [];

  /// Initialize the connectivity service
  Future<void> initialize() async {
    _setupDio();
    await _checkInitialConnectivity();
    _setupConnectivityListener();
  }

  /// Setup Dio configuration
  void _setupDio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
    );
  }

  /// Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    
    if (_isOnline) {
      await _checkServerConnectivity();
    }
  }

  /// Setup connectivity listener
  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) async {
      final wasOnline = _isOnline;
      _isOnline = result != ConnectivityResult.none;

      if (_isOnline != wasOnline) {
        _notifyConnectivityListeners(_isOnline);
        
        if (_isOnline) {
          await _checkServerConnectivity();
        } else {
          _isServerReachable = false;
          _notifyServerListeners(false);
        }
      }
    });
  }

  /// Check server connectivity
  Future<bool> _checkServerConnectivity() async {
    try {
      // Skip if checked recently (within 30 seconds)
      if (_lastServerCheck != null && 
          DateTime.now().difference(_lastServerCheck!).inSeconds < 30) {
        return _isServerReachable;
      }

      final response = await _dio.get(
        'https://api.idec-ye.com/health',
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      _isServerReachable = response.statusCode == 200;
      _lastServerCheck = DateTime.now();
      
      _notifyServerListeners(_isServerReachable);
      
      debugPrint('🌐 [CONNECTIVITY] Server reachable: $_isServerReachable');
      return _isServerReachable;
    } catch (e) {
      _isServerReachable = false;
      _lastServerCheck = DateTime.now();
      _notifyServerListeners(false);
      
      debugPrint('❌ [CONNECTIVITY] Server check failed: $e');
      return false;
    }
  }

  /// Check if internet is available
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if server is reachable
  Future<bool> isServerReachable({bool forceCheck = false}) async {
    if (forceCheck || _lastServerCheck == null || 
        DateTime.now().difference(_lastServerCheck!).inMinutes > 5) {
      return await _checkServerConnectivity();
    }
    return _isServerReachable;
  }

  /// Check if operation requires internet connection
  bool requiresInternetConnection(String operation) {
    const internetRequiredOperations = [
      'login',
      'register',
      'verify_otp',
      'forgot_password',
      'reset_password',
      'update_profile',
      'upload_file',
      'submit_form',
      'payment',
      'sync_data',
    ];
    
    return internetRequiredOperations.contains(operation.toLowerCase());
  }

  /// Validate connectivity before operation
  Future<ConnectivityResult> validateConnectivity(String operation) async {
    if (!requiresInternetConnection(operation)) {
      return ConnectivityResult.success;
    }

    if (!_isOnline) {
      return ConnectivityResult.noInternet;
    }

    final serverReachable = await isServerReachable();
    if (!serverReachable) {
      return ConnectivityResult.serverUnreachable;
    }

    return ConnectivityResult.success;
  }

  /// Add connectivity listener
  void addConnectivityListener(Function(bool) listener) {
    _connectivityListeners.add(listener);
  }

  /// Remove connectivity listener
  void removeConnectivityListener(Function(bool) listener) {
    _connectivityListeners.remove(listener);
  }

  /// Add server connectivity listener
  void addServerListener(Function(bool) listener) {
    _serverListeners.add(listener);
  }

  /// Remove server connectivity listener
  void removeServerListener(Function(bool) listener) {
    _serverListeners.remove(listener);
  }

  /// Notify connectivity listeners
  void _notifyConnectivityListeners(bool isOnline) {
    for (final listener in _connectivityListeners) {
      try {
        listener(isOnline);
      } catch (e) {
        debugPrint('❌ [CONNECTIVITY] Error in connectivity listener: $e');
      }
    }
  }

  /// Notify server listeners
  void _notifyServerListeners(bool isReachable) {
    for (final listener in _serverListeners) {
      try {
        listener(isReachable);
      } catch (e) {
        debugPrint('❌ [CONNECTIVITY] Error in server listener: $e');
      }
    }
  }

  /// Get current connectivity status
  ConnectivityStatus get currentStatus => ConnectivityStatus(
    isOnline: _isOnline,
    isServerReachable: _isServerReachable,
    lastServerCheck: _lastServerCheck,
  );

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityListeners.clear();
    _serverListeners.clear();
  }

  // Getters
  bool get isOnline => _isOnline;
  bool get isServerConnected => _isServerReachable;
}

/// Connectivity validation result
enum ConnectivityResult {
  success,
  noInternet,
  serverUnreachable,
}

/// Connectivity status model
class ConnectivityStatus {
  final bool isOnline;
  final bool isServerReachable;
  final DateTime? lastServerCheck;

  ConnectivityStatus({
    required this.isOnline,
    required this.isServerReachable,
    this.lastServerCheck,
  });

  bool get isFullyConnected => isOnline && isServerReachable;

  String get statusMessage {
    if (!isOnline) return 'لا يوجد اتصال بالإنترنت';
    if (!isServerReachable) return 'الخادم غير متاح';
    return 'متصل';
  }

  Map<String, dynamic> toJson() => {
    'isOnline': isOnline,
    'isServerReachable': isServerReachable,
    'lastServerCheck': lastServerCheck?.toIso8601String(),
    'isFullyConnected': isFullyConnected,
    'statusMessage': statusMessage,
  };
}