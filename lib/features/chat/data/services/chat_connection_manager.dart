import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Chat Connection Manager
/// Manages network connectivity state for chat features
class ChatConnectionManager {
  static final ChatConnectionManager _instance = ChatConnectionManager._internal();
  static ChatConnectionManager get instance => _instance;
  ChatConnectionManager._internal();

  // State
  bool _isOnline = true;
  bool _wasOffline = false;
  DateTime? _lastDisconnectedAt;
  DateTime? _lastConnectedAt;
  
  // Streams
  final _connectionStateController = StreamController<ConnectionState>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  // Callbacks
  VoidCallback? onConnectionRestored;
  VoidCallback? onConnectionLost;

  /// Stream of connection state changes
  Stream<ConnectionState> get connectionStateStream => _connectionStateController.stream;

  /// Current online status
  bool get isOnline => _isOnline;

  /// Was offline before current state
  bool get wasOffline => _wasOffline;

  /// Initialize the manager
  Future<void> initialize() async {
    try {
      // Check initial connectivity
      final result = await Connectivity().checkConnectivity();
      _updateConnectionState(result);
      
      // Listen for changes
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
        _updateConnectionState,
        onError: (error) {
          debugPrint('❌ [ChatConnection] Connectivity error: $error');
        },
      );
      
      debugPrint('✅ [ChatConnection] Initialized - Online: $_isOnline');
    } catch (e) {
      debugPrint('❌ [ChatConnection] Initialize error: $e');
      _isOnline = true; // Assume online on error
    }
  }

  void _updateConnectionState(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    
    if (_isOnline != wasOnline) {
      if (_isOnline) {
        // Came back online
        _wasOffline = true;
        _lastConnectedAt = DateTime.now();
        
        debugPrint('✅ [ChatConnection] Connected');
        _connectionStateController.add(ConnectionState.connected);
        
        // Trigger callback
        onConnectionRestored?.call();
      } else {
        // Went offline
        _lastDisconnectedAt = DateTime.now();
        
        debugPrint('❌ [ChatConnection] Disconnected');
        _connectionStateController.add(ConnectionState.disconnected);
        
        // Trigger callback
        onConnectionLost?.call();
      }
    }
  }

  /// Get offline duration
  Duration? getOfflineDuration() {
    if (_lastDisconnectedAt == null || _lastConnectedAt == null) return null;
    if (_lastConnectedAt!.isBefore(_lastDisconnectedAt!)) return null;
    return _lastConnectedAt!.difference(_lastDisconnectedAt!);
  }

  /// Force check connectivity
  Future<bool> checkConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectionState(result);
      return _isOnline;
    } catch (e) {
      debugPrint('❌ [ChatConnection] Check connectivity error: $e');
      return _isOnline;
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStateController.close();
  }
}

/// Connection states
enum ConnectionState {
  connected,
  disconnected,
  connecting,
}

// Global instance
final chatConnection = ChatConnectionManager.instance;
