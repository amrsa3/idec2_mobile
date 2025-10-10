import 'dart:async';
import 'package:flutter/foundation.dart';

/// Session Manager to handle session expiration events
/// This allows communication between DioService and AuthProvider
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  static SessionManager get instance => _instance;

  // Stream controller for session expiration events
  final StreamController<SessionExpiredEvent> _sessionExpiredController = 
      StreamController<SessionExpiredEvent>.broadcast();

  // Stream for listening to session expiration events
  Stream<SessionExpiredEvent> get sessionExpiredStream => 
      _sessionExpiredController.stream;

  /// Notify that the session has expired
  void notifySessionExpired({
    required String reason,
    bool shouldRedirectToLogin = true,
  }) {
    debugPrint('🚨 SessionManager: Session expired - $reason');
    
    final event = SessionExpiredEvent(
      reason: reason,
      timestamp: DateTime.now(),
      shouldRedirectToLogin: shouldRedirectToLogin,
    );
    
    _sessionExpiredController.add(event);
  }

  /// Dispose the session manager
  void dispose() {
    _sessionExpiredController.close();
  }
}

/// Event class for session expiration
class SessionExpiredEvent {
  final String reason;
  final DateTime timestamp;
  final bool shouldRedirectToLogin;

  const SessionExpiredEvent({
    required this.reason,
    required this.timestamp,
    this.shouldRedirectToLogin = true,
  });

  @override
  String toString() {
    return 'SessionExpiredEvent(reason: $reason, timestamp: $timestamp, shouldRedirectToLogin: $shouldRedirectToLogin)';
  }
}