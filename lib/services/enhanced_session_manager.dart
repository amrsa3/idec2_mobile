import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'platform_storage_service.dart';
import 'unified_token_manager.dart';
import 'retry_service.dart';

/// Enhanced Session Manager with offline support and 30-day session management
class EnhancedSessionManager {
  static EnhancedSessionManager? _instance;
  static EnhancedSessionManager get instance => _instance ??= EnhancedSessionManager._();

  EnhancedSessionManager._();

  // Storage service for session data
  late PlatformStorageService _storage;
  
  // Token manager for authentication
  late UnifiedTokenManager _tokenManager;
  
  // Connectivity monitoring
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isOnline = true;
  
  // Session state
  SessionState _currentState = SessionState.unknown;
  DateTime? _lastActivity;
  Timer? _sessionCheckTimer;
  Timer? _heartbeatTimer;
  
  // Stream controllers for session events
  final StreamController<SessionStateEvent> _sessionStateController = 
      StreamController<SessionStateEvent>.broadcast();
  final StreamController<SessionExpiredEvent> _sessionExpiredController = 
      StreamController<SessionExpiredEvent>.broadcast();
  final StreamController<OfflineSessionEvent> _offlineSessionController = 
      StreamController<OfflineSessionEvent>.broadcast();
  
  // Configuration - إعدادات الجلسة المحسنة لمدة 30 يوم
  static const Duration _sessionTimeout = Duration(days: 30); // تغيير من 30 دقيقة إلى 30 يوم
  static const Duration _maxSessionDuration = Duration(days: 30);
  static const Duration _heartbeatInterval = Duration(minutes: 10); // تقليل عدد الطلبات - كل 10 دقائق
  static const Duration _sessionCheckInterval = Duration(minutes: 15); // تقليل عدد الفحوصات - كل 15 دقيقة
  
  // Storage keys
  static const String _sessionDataKey = 'session_data';
  static const String _lastActivityKey = 'last_activity';
  static const String _sessionStartKey = 'session_start';
  static const String _offlineActivitiesKey = 'offline_activities';
  static const String _sessionConfigKey = 'session_config';

  /// Initialize the session manager
  Future<void> initialize({
    PlatformStorageService? storage,
    UnifiedTokenManager? tokenManager,
  }) async {
    _storage = storage ?? PlatformStorageService.instance;
    _tokenManager = tokenManager ?? UnifiedTokenManager.instance;
    
    // PlatformStorageService doesn't need explicit initialization
    await _tokenManager.initialize();
    
    // Setup connectivity monitoring
    _setupConnectivityMonitoring();
    
    // Restore session state
    await _restoreSessionState();
    
    // Start session monitoring
    _startSessionMonitoring();
    
    // Listen to token manager events
    _tokenManager.sessionEvents.listen(_handleTokenManagerEvent);
    
    // Only log initialization in debug mode
    if (kDebugMode) {
      debugPrint('EnhancedSessionManager: Initialized');
    }
  }

  /// Dispose the session manager
  void dispose() {
    _sessionCheckTimer?.cancel();
    _heartbeatTimer?.cancel();
    _connectivitySubscription?.cancel();
    _sessionStateController.close();
    _sessionExpiredController.close();
    _offlineSessionController.close();
  }

  // Streams for listening to session events
  Stream<SessionStateEvent> get sessionStateStream => _sessionStateController.stream;
  Stream<SessionExpiredEvent> get sessionExpiredStream => _sessionExpiredController.stream;
  Stream<OfflineSessionEvent> get offlineSessionStream => _offlineSessionController.stream;

  /// Start a new session
  Future<void> startSession({
    required String userId,
    required String deviceId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final sessionData = SessionData(
        userId: userId,
        deviceId: deviceId,
        startTime: DateTime.now(),
        lastActivity: DateTime.now(),
        metadata: metadata ?? {},
        isOffline: !_isOnline,
      );

      await _saveSessionData(sessionData);
      await _updateLastActivity();
      
      _currentState = SessionState.active;
      _lastActivity = DateTime.now();
      _cachedSessionId = deviceId; // Cache the session ID
      
      _notifySessionStateChange(SessionStateEvent(
        state: SessionState.active,
        timestamp: DateTime.now(),
        reason: 'Session started',
      ));

      if (_isOnline) {
        await _sendSessionStartToServer(sessionData);
      } else {
        await _queueOfflineActivity(OfflineActivity(
          type: OfflineActivityType.sessionStart,
          timestamp: DateTime.now(),
          data: sessionData.toJson(),
        ));
      }

      // Only log session start in debug mode
      if (kDebugMode) {
        debugPrint('Session started for user: $userId');
      }
    } catch (e) {
      // Only log errors - these are important
      debugPrint('ERROR: Failed to start session - $e');
      rethrow;
    }
  }

  /// Update session activity
  Future<void> updateActivity({Map<String, dynamic>? metadata}) async {
    try {
      _lastActivity = DateTime.now();
      await _updateLastActivity();
      
      final sessionData = await _getSessionData();
      if (sessionData != null) {
        sessionData.lastActivity = DateTime.now();
        if (metadata != null) {
          sessionData.metadata.addAll(metadata);
        }
        await _saveSessionData(sessionData);
      }

      if (_currentState != SessionState.active) {
        _currentState = SessionState.active;
        _notifySessionStateChange(SessionStateEvent(
          state: SessionState.active,
          timestamp: DateTime.now(),
          reason: 'Activity updated',
        ));
      }

      if (_isOnline) {
        await _sendHeartbeatToServer();
      } else {
        await _queueOfflineActivity(OfflineActivity(
          type: OfflineActivityType.heartbeat,
          timestamp: DateTime.now(),
          data: metadata ?? {},
        ));
      }
    } catch (e) {
      // Only log errors - these are important
      debugPrint('ERROR: Failed to update activity - $e');
    }
  }

  /// End the current session
  Future<void> endSession({String? reason}) async {
    try {
      final sessionData = await _getSessionData();
      if (sessionData != null) {
        sessionData.endTime = DateTime.now();
        await _saveSessionData(sessionData);
      }

      _currentState = SessionState.ended;
      
      _notifySessionStateChange(SessionStateEvent(
        state: SessionState.ended,
        timestamp: DateTime.now(),
        reason: reason ?? 'Session ended',
      ));

      if (_isOnline && sessionData != null) {
        await _sendSessionEndToServer(sessionData, reason);
      } else if (sessionData != null) {
        await _queueOfflineActivity(OfflineActivity(
          type: OfflineActivityType.sessionEnd,
          timestamp: DateTime.now(),
          data: {
            'sessionId': sessionData.deviceId,
            'reason': reason,
          },
        ));
      }

      await _clearSessionData();

      // Only log session end in debug mode
      if (kDebugMode) {
        debugPrint('Session ended: ${reason ?? 'Unknown'}');
      }
    } catch (e) {
      // Only log errors - these are important
      debugPrint('ERROR: Failed to end session - $e');
    }
  }

  /// Check if session is valid
  Future<bool> isSessionValid() async {
    try {
      final sessionData = await _getSessionData();
      if (sessionData == null) {
        return false;
      }

      final now = DateTime.now();
      final sessionDuration = now.difference(sessionData.startTime);
      final timeSinceActivity = now.difference(sessionData.lastActivity);
      
      // Check if session has exceeded maximum duration (30 days)
      if (sessionDuration > _maxSessionDuration) {
        if (kDebugMode) {
          debugPrint('Session expired: Maximum duration exceeded');
        }
        await _expireSession('Maximum session duration exceeded');
        return false;
      }

      // Check if session has timed out due to inactivity
      if (timeSinceActivity > _sessionTimeout) {
        if (kDebugMode) {
          debugPrint('Session expired: Timeout due to inactivity');
        }
        await _expireSession('Session timeout due to inactivity');
        return false;
      }

      // Check token validity
      final hasValidToken = await _tokenManager.isAccessTokenValid();
      if (!hasValidToken) {
        if (kDebugMode) {
          debugPrint('Session expired: Invalid or expired token');
        }
        await _expireSession('Invalid or expired token');
        return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Failed to validate session - $e');
      }
      return false;
    }
  }

  /// Get current session data
  Future<SessionData?> getCurrentSession() async {
    return await _getSessionData();
  }

  /// Get session state
  SessionState get currentState => _currentState;

  /// Check if device is online
  bool get isOnline => _isOnline;

  /// Get current session ID (deviceId from session data)
  String? get currentSessionId {
    // This is a synchronous getter, so we'll need to cache the session ID
    return _cachedSessionId;
  }
  
  /// Check if session is currently active
  bool get isSessionActive => _currentState == SessionState.active;
  
  /// Get last activity time
  DateTime? get lastActivity => _lastActivity;
  
  /// Get session state (alias for currentState for compatibility)
  SessionState get sessionState => _currentState;
  
  // Cache for session ID to provide synchronous access
  String? _cachedSessionId;

  /// Get offline activities count
  Future<int> getOfflineActivitiesCount() async {
    try {
      final activitiesJson = await _storage.read(_offlineActivitiesKey);
      if (activitiesJson == null) return 0;
      
      final activities = jsonDecode(activitiesJson) as List;
      return activities.length;
    } catch (e) {
      return 0;
    }
  }

  /// Sync offline activities when back online
  Future<void> syncOfflineActivities() async {
    if (!_isOnline) return;

    try {
      final activitiesJson = await _storage.read(_offlineActivitiesKey);
      if (activitiesJson == null) return;

      final activitiesList = jsonDecode(activitiesJson) as List;
      final activities = activitiesList
          .map((json) => OfflineActivity.fromJson(json))
          .toList();

      for (final activity in activities) {
        await _syncOfflineActivity(activity);
      }

      // Clear synced activities
      await _storage.delete(_offlineActivitiesKey);

      _notifyOfflineSessionEvent(OfflineSessionEvent(
        type: OfflineSessionEventType.activitiesSynced,
        timestamp: DateTime.now(),
        activitiesCount: activities.length,
      ));

      // Only log sync completion in debug mode
      if (kDebugMode) {
        debugPrint('Synced ${activities.length} offline activities');
      }
    } catch (e) {
      // Only log errors - these are important
      debugPrint('ERROR: Failed to sync offline activities - $e');
    }
  }

  /// Setup connectivity monitoring
  void _setupConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;

        if (!wasOnline && _isOnline) {
          // Device came back online
          _handleBackOnline();
        } else if (wasOnline && !_isOnline) {
          // Device went offline
          _handleGoOffline();
        }
      },
    );
  }

  /// Handle device coming back online
  void _handleBackOnline() {
    _notifyOfflineSessionEvent(OfflineSessionEvent(
      type: OfflineSessionEventType.backOnline,
      timestamp: DateTime.now(),
    ));

    // Restart heartbeat if session is active
    if (_currentState == SessionState.active) {
      _startHeartbeat();
    }

    // Sync offline activities
    syncOfflineActivities();

    // Only log connectivity changes in debug mode
    if (kDebugMode) {
      debugPrint('Device back online');
    }
  }

  /// Handle device going offline
  void _handleGoOffline() {
    _notifyOfflineSessionEvent(OfflineSessionEvent(
      type: OfflineSessionEventType.wentOffline,
      timestamp: DateTime.now(),
    ));

    // Stop heartbeat
    _heartbeatTimer?.cancel();

    // Only log connectivity changes in debug mode
    if (kDebugMode) {
      debugPrint('Device went offline');
    }
  }

  /// Restore session state from storage
  Future<void> _restoreSessionState() async {
    try {
      final sessionData = await _getSessionData();
      if (sessionData == null) {
        _currentState = SessionState.none;
        return;
      }

      final lastActivityStr = await _storage.read(_lastActivityKey);
      if (lastActivityStr != null) {
        _lastActivity = DateTime.parse(lastActivityStr);
      }

      // Check if session is still valid
      if (await isSessionValid()) {
        _currentState = SessionState.active;
        _cachedSessionId = sessionData.deviceId; // Cache the session ID
        // Only log session restoration in debug mode
        if (kDebugMode) {
          debugPrint('Session restored for user: ${sessionData.userId}');
        }
      } else {
        _currentState = SessionState.expired;
        await _clearSessionData();
      }
    } catch (e) {
      _currentState = SessionState.unknown;
      // Only log errors - these are important
      debugPrint('ERROR: Failed to restore session state - $e');
    }
  }

  /// Start session monitoring
  void _startSessionMonitoring() {
    // Session validity check timer
    _sessionCheckTimer = Timer.periodic(_sessionCheckInterval, (timer) async {
      if (_currentState == SessionState.active) {
        final isValid = await isSessionValid();
        if (!isValid && _currentState == SessionState.active) {
          _currentState = SessionState.expired;
          _notifySessionStateChange(SessionStateEvent(
            state: SessionState.expired,
            timestamp: DateTime.now(),
            reason: 'Session validation failed',
          ));
        }
      }
    });

    // Start heartbeat if online and session is active
    if (_isOnline && _currentState == SessionState.active) {
      _startHeartbeat();
    }
  }

  /// Start heartbeat timer
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) async {
      if (_currentState == SessionState.active && _isOnline) {
        await _sendHeartbeatToServer();
      }
    });
  }

  /// Handle token manager events
  void _handleTokenManagerEvent(SessionEvent event) {
    switch (event.type) {
      case SessionEventType.tokenRefreshed:
        // Token refreshed successfully, update activity
        updateActivity();
        break;
      case SessionEventType.sessionExpired:
        // Session expired, expire session
        _expireSession('Session expired');
        break;
      case SessionEventType.sessionCleared:
        // Session cleared, end session
        endSession(reason: 'Session cleared');
        break;
      case SessionEventType.loggedOut:
        // User logged out, end session
        endSession(reason: 'User logged out');
        break;
      case SessionEventType.sessionWarning:
        // Session warning, could be handled differently
        // Only log warnings in debug mode
        if (kDebugMode) {
          debugPrint('Session warning received');
        }
        break;
    }
  }

  /// Expire the current session
  Future<void> _expireSession(String reason) async {
    final timestamp = DateTime.now();
    
    // Only log session expiration in debug mode
    if (kDebugMode) {
      debugPrint('Session expired: $reason');
    }
    
    _currentState = SessionState.expired;
    
    _notifySessionExpired(SessionExpiredEvent(
      reason: reason,
      timestamp: timestamp,
      shouldRedirectToLogin: true,
    ));

    await _clearSessionData();
  }

  /// Save session data to storage
  Future<void> _saveSessionData(SessionData sessionData) async {
    await _storage.write(_sessionDataKey, jsonEncode(sessionData.toJson()));
    _cachedSessionId = sessionData.deviceId; // Cache the session ID
  }

  /// Get session data from storage
  Future<SessionData?> _getSessionData() async {
    try {
      final sessionDataJson = await _storage.read(_sessionDataKey);
      if (sessionDataJson == null) return null;
      
      final sessionDataMap = jsonDecode(sessionDataJson) as Map<String, dynamic>;
      return SessionData.fromJson(sessionDataMap);
    } catch (e) {
      return null;
    }
  }

  /// Update last activity timestamp
  Future<void> _updateLastActivity() async {
    await _storage.write(_lastActivityKey, DateTime.now().toIso8601String());
  }

  /// Clear session data from storage
  Future<void> _clearSessionData() async {
    await _storage.delete(_sessionDataKey);
    await _storage.delete(_lastActivityKey);
    await _storage.delete(_sessionStartKey);
  }

  /// Queue offline activity
  Future<void> _queueOfflineActivity(OfflineActivity activity) async {
    try {
      final activitiesJson = await _storage.read(_offlineActivitiesKey);
      List<Map<String, dynamic>> activities = [];
      
      if (activitiesJson != null) {
        activities = List<Map<String, dynamic>>.from(jsonDecode(activitiesJson));
      }
      
      activities.add(activity.toJson());
      await _storage.write(_offlineActivitiesKey, jsonEncode(activities));
    } catch (e) {
      // Only log errors - these are important
      debugPrint('ERROR: Failed to queue offline activity - $e');
    }
  }

  /// Send session start to server
  Future<void> _sendSessionStartToServer(SessionData sessionData) async {
    // Implementation would depend on your API
    // This is a placeholder for the actual API call
    // Removed excessive logging
  }

  /// Send heartbeat to server
  Future<void> _sendHeartbeatToServer() async {
    // Implementation would depend on your API
    // This is a placeholder for the actual API call
    // Removed excessive logging
  }

  /// Send session end to server
  Future<void> _sendSessionEndToServer(SessionData sessionData, String? reason) async {
    // Implementation would depend on your API
    // This is a placeholder for the actual API call
    // Removed excessive logging
  }

  /// Sync offline activity to server
  Future<void> _syncOfflineActivity(OfflineActivity activity) async {
    // Implementation would depend on your API and activity type
    // This is a placeholder for the actual API call
    // Removed excessive logging
  }

  /// Notify session state change
  void _notifySessionStateChange(SessionStateEvent event) {
    _sessionStateController.add(event);
  }

  /// Notify session expired
  void _notifySessionExpired(SessionExpiredEvent event) {
    _sessionExpiredController.add(event);
  }

  /// Notify offline session event
  void _notifyOfflineSessionEvent(OfflineSessionEvent event) {
    _offlineSessionController.add(event);
  }

  /// Public method to notify session expired (for external services like DioService)
  void notifySessionExpired({
    required String reason,
    bool shouldRedirectToLogin = true,
  }) {
    _notifySessionExpired(SessionExpiredEvent(
      reason: reason,
      timestamp: DateTime.now(),
      shouldRedirectToLogin: shouldRedirectToLogin,
    ));
  }
}

/// Session states
enum SessionState {
  none,
  active,
  expired,
  ended,
  unknown,
}

/// Session data model
class SessionData {
  final String userId;
  final String deviceId;
  final DateTime startTime;
  DateTime lastActivity;
  DateTime? endTime;
  final Map<String, dynamic> metadata;
  final bool isOffline;

  SessionData({
    required this.userId,
    required this.deviceId,
    required this.startTime,
    required this.lastActivity,
    this.endTime,
    required this.metadata,
    this.isOffline = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceId': deviceId,
      'startTime': startTime.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'metadata': metadata,
      'isOffline': isOffline,
    };
  }

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      userId: json['userId'],
      deviceId: json['deviceId'],
      startTime: DateTime.parse(json['startTime']),
      lastActivity: DateTime.parse(json['lastActivity']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isOffline: json['isOffline'] ?? false,
    );
  }
}

/// Session state event
class SessionStateEvent {
  final SessionState state;
  final DateTime timestamp;
  final String reason;

  const SessionStateEvent({
    required this.state,
    required this.timestamp,
    required this.reason,
  });

  @override
  String toString() {
    return 'SessionStateEvent(state: $state, timestamp: $timestamp, reason: $reason)';
  }
}

/// Session expired event (compatible with existing SessionManager)
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

/// Offline session events
enum OfflineSessionEventType {
  wentOffline,
  backOnline,
  activitiesSynced,
  syncFailed,
}

class OfflineSessionEvent {
  final OfflineSessionEventType type;
  final DateTime timestamp;
  final int? activitiesCount;
  final String? error;

  const OfflineSessionEvent({
    required this.type,
    required this.timestamp,
    this.activitiesCount,
    this.error,
  });

  @override
  String toString() {
    return 'OfflineSessionEvent(type: $type, timestamp: $timestamp, activitiesCount: $activitiesCount, error: $error)';
  }
}

/// Offline activity types
enum OfflineActivityType {
  sessionStart,
  sessionEnd,
  heartbeat,
  userAction,
}

/// Offline activity model
class OfflineActivity {
  final OfflineActivityType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  const OfflineActivity({
    required this.type,
    required this.timestamp,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  factory OfflineActivity.fromJson(Map<String, dynamic> json) {
    return OfflineActivity(
      type: OfflineActivityType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
      data: Map<String, dynamic>.from(json['data']),
    );
  }
}
