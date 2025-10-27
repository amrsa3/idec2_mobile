import 'dart:async';

import 'package:flutter/foundation.dart';

import 'platform_storage_service.dart';

/// خدمة إدارة الجلسات المحسنة
/// تدعم تتبع النشاط وإدارة انتهاء الجلسة
class SessionManager {
  static SessionManager? _instance;
  static SessionManager get instance =>
      _instance ??= SessionManager._internal();

  late PlatformStorageService _storage;
  late Completer<void> _initCompleter;
  bool _isInitialized = false;

  // Stream controllers
  final StreamController<SessionEvent> _sessionController =
      StreamController<SessionEvent>.broadcast();
  final StreamController<SessionStatus> _statusController =
      StreamController<SessionStatus>.broadcast();

  // Storage keys
  static const String _sessionIdKey = 'session_id';
  static const String _sessionStartKey = 'session_start';
  static const String _lastActivityKey = 'last_activity';
  // static const String _sessionDataKey = 'session_data';
  static const String _userIdKey = 'session_user_id';

  // Configuration
  static const Duration _sessionTimeout = Duration(hours: 24);
  static const Duration _inactivityTimeout = Duration(minutes: 30);
  static const Duration _activityCheckInterval = Duration(minutes: 5);

  // Current state
  String? _currentSessionId;
  String? _currentUserId;
  DateTime? _sessionStartTime;
  DateTime? _lastActivityTime;
  Timer? _activityTimer;
  Timer? _sessionTimer;

  SessionManager._internal() {
    _initCompleter = Completer<void>();
  }

  /// Stream للأحداث
  Stream<SessionEvent> get sessionEvents => _sessionController.stream;

  /// Stream للحالة
  Stream<SessionStatus> get statusStream => _statusController.stream;

  /// معرف الجلسة الحالية
  String? get currentSessionId => _currentSessionId;

  /// معرف المستخدم الحالي
  String? get currentUserId => _currentUserId;

  /// تهيئة المدير
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('🔐 [SESSION_MANAGER] Initializing session manager...');

      _storage = PlatformStorageService.instance;
      await _storage.init();

      // Restore previous session if available
      await _restoreSession();

      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      debugPrint(
          '✅ [SESSION_MANAGER] Session manager initialized successfully');
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Initialization error: $e');
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

  /// بدء جلسة جديدة
  Future<void> startSession(String userId) async {
    await _ensureInitialized();

    try {
      debugPrint('🔐 [SESSION_MANAGER] Starting new session for user: $userId');

      // End previous session if exists
      if (_currentSessionId != null) {
        await endSession();
      }

      // Generate new session ID
      _currentSessionId = _generateSessionId();
      _currentUserId = userId;
      _sessionStartTime = DateTime.now();
      _lastActivityTime = DateTime.now();

      // Save session data
      await _saveSessionData();

      // Start monitoring
      _startActivityMonitoring();
      _startSessionMonitoring();

      // Emit events
      _sessionController.add(SessionEvent(
        type: SessionEventType.sessionStarted,
        sessionId: _currentSessionId!,
        userId: userId,
        timestamp: _sessionStartTime!,
      ));

      _statusController.add(SessionStatus.active);

      debugPrint('✅ [SESSION_MANAGER] Session started: $_currentSessionId');
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error starting session: $e');
      rethrow;
    }
  }

  /// إنهاء الجلسة الحالية
  Future<void> endSession() async {
    await _ensureInitialized();

    try {
      if (_currentSessionId == null) {
        debugPrint('ℹ️ [SESSION_MANAGER] No active session to end');
        return;
      }

      debugPrint('🔐 [SESSION_MANAGER] Ending session: $_currentSessionId');

      // Stop monitoring
      _stopActivityMonitoring();
      _stopSessionMonitoring();

      // Calculate session duration
      final duration = _sessionStartTime != null
          ? DateTime.now().difference(_sessionStartTime!)
          : Duration.zero;

      // Emit events
      _sessionController.add(SessionEvent(
        type: SessionEventType.sessionEnded,
        sessionId: _currentSessionId!,
        userId: _currentUserId,
        timestamp: DateTime.now(),
        data: {'duration': duration.inSeconds},
      ));

      _statusController.add(SessionStatus.inactive);

      // Clear session data
      await _clearSessionData();

      // Reset state
      _currentSessionId = null;
      _currentUserId = null;
      _sessionStartTime = null;
      _lastActivityTime = null;

      debugPrint('✅ [SESSION_MANAGER] Session ended successfully');
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error ending session: $e');
    }
  }

  /// تحديث النشاط الأخير
  Future<void> updateActivity() async {
    await _ensureInitialized();

    try {
      if (_currentSessionId == null) return;

      final now = DateTime.now();
      _lastActivityTime = now;

      // Save updated activity time
      await _storage.writeSecure(_lastActivityKey, now.toIso8601String());

      // Emit activity event
      _sessionController.add(SessionEvent(
        type: SessionEventType.activityUpdated,
        sessionId: _currentSessionId!,
        userId: _currentUserId,
        timestamp: now,
      ));

      debugPrint('🔐 [SESSION_MANAGER] Activity updated');
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error updating activity: $e');
    }
  }

  /// التحقق من نشاط الجلسة
  Future<bool> isSessionActive() async {
    await _ensureInitialized();

    try {
      if (_currentSessionId == null) {
        debugPrint('🔐 [SESSION_MANAGER] No active session');
        return false;
      }

      // Check if session has timed out
      if (_sessionStartTime != null) {
        final sessionAge = DateTime.now().difference(_sessionStartTime!);
        if (sessionAge > _sessionTimeout) {
          debugPrint('🔐 [SESSION_MANAGER] Session timed out');
          await endSession();
          return false;
        }
      }

      // Check if user has been inactive too long
      if (_lastActivityTime != null) {
        final inactivityDuration =
            DateTime.now().difference(_lastActivityTime!);
        if (inactivityDuration > _inactivityTimeout) {
          debugPrint('🔐 [SESSION_MANAGER] User inactive too long');
          await endSession();
          return false;
        }
      }

      return true;
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error checking session activity: $e');
      return false;
    }
  }

  /// الحصول على معلومات الجلسة
  Future<Map<String, dynamic>> getSessionInfo() async {
    await _ensureInitialized();

    try {
      return {
        'sessionId': _currentSessionId,
        'userId': _currentUserId,
        'sessionStartTime': _sessionStartTime?.toIso8601String(),
        'lastActivityTime': _lastActivityTime?.toIso8601String(),
        'isActive': await isSessionActive(),
        'sessionDuration': _sessionStartTime != null
            ? DateTime.now().difference(_sessionStartTime!).inSeconds
            : 0,
        'inactivityDuration': _lastActivityTime != null
            ? DateTime.now().difference(_lastActivityTime!).inSeconds
            : 0,
        'sessionTimeout': _sessionTimeout.inSeconds,
        'inactivityTimeout': _inactivityTimeout.inSeconds,
      };
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error getting session info: $e');
      return {};
    }
  }

  /// استعادة الجلسة السابقة
  Future<void> _restoreSession() async {
    try {
      debugPrint('🔐 [SESSION_MANAGER] Restoring previous session...');

      final sessionId = await _storage.readSecure(_sessionIdKey);
      final userId = await _storage.readSecure(_userIdKey);
      final sessionStartString = await _storage.readSecure(_sessionStartKey);
      final lastActivityString = await _storage.readSecure(_lastActivityKey);

      if (sessionId != null && userId != null && sessionStartString != null) {
        _currentSessionId = sessionId;
        _currentUserId = userId;
        _sessionStartTime = DateTime.parse(sessionStartString);
        _lastActivityTime = lastActivityString != null
            ? DateTime.parse(lastActivityString)
            : _sessionStartTime;

        // Check if session is still valid
        final isActive = await isSessionActive();
        if (isActive) {
          debugPrint('✅ [SESSION_MANAGER] Session restored successfully');
          _startActivityMonitoring();
          _startSessionMonitoring();
          _statusController.add(SessionStatus.active);
        } else {
          debugPrint('ℹ️ [SESSION_MANAGER] Previous session expired');
          await _clearSessionData();
        }
      } else {
        debugPrint('ℹ️ [SESSION_MANAGER] No previous session to restore');
      }
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error restoring session: $e');
      await _clearSessionData();
    }
  }

  /// حفظ بيانات الجلسة
  Future<void> _saveSessionData() async {
    try {
      await _storage.writeSecure(_sessionIdKey, _currentSessionId!);
      await _storage.writeSecure(_userIdKey, _currentUserId!);
      await _storage.writeSecure(
          _sessionStartKey, _sessionStartTime!.toIso8601String());
      await _storage.writeSecure(
          _lastActivityKey, _lastActivityTime!.toIso8601String());
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error saving session data: $e');
    }
  }

  /// مسح بيانات الجلسة
  Future<void> _clearSessionData() async {
    try {
      await _storage.deleteSecure(_sessionIdKey);
      await _storage.deleteSecure(_userIdKey);
      await _storage.deleteSecure(_sessionStartKey);
      await _storage.deleteSecure(_lastActivityKey);
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error clearing session data: $e');
    }
  }

  /// Clear all session data and reset state
  Future<void> clearAll() async {
    await _ensureInitialized();

    try {
      debugPrint('🔐 [SESSION_MANAGER] Clearing all session data');

      // Clear all session keys
      await _storage.deleteSecure(_sessionIdKey);
      await _storage.deleteSecure(_userIdKey);
      await _storage.deleteSecure(_sessionStartKey);
      await _storage.deleteSecure(_lastActivityKey);

      // Reset state
      _currentSessionId = null;
      _currentUserId = null;
      _sessionStartTime = null;
      _lastActivityTime = null;

      // Update status
      _statusController.add(SessionStatus.inactive);

      debugPrint('✅ [SESSION_MANAGER] All session data cleared');
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Error clearing all data: $e');
    }
  }

  /// بدء مراقبة النشاط
  void _startActivityMonitoring() {
    _stopActivityMonitoring();

    _activityTimer = Timer.periodic(_activityCheckInterval, (timer) async {
      try {
        final isActive = await isSessionActive();
        if (!isActive) {
          timer.cancel();
        }
      } catch (e) {
        debugPrint('❌ [SESSION_MANAGER] Activity monitoring error: $e');
      }
    });
  }

  /// إيقاف مراقبة النشاط
  void _stopActivityMonitoring() {
    _activityTimer?.cancel();
    _activityTimer = null;
  }

  /// بدء مراقبة الجلسة
  void _startSessionMonitoring() {
    _stopSessionMonitoring();

    _sessionTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      try {
        final isActive = await isSessionActive();
        if (!isActive) {
          timer.cancel();
        }
      } catch (e) {
        debugPrint('❌ [SESSION_MANAGER] Session monitoring error: $e');
      }
    });
  }

  /// إيقاف مراقبة الجلسة
  void _stopSessionMonitoring() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// توليد معرف جلسة فريد
  String _generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch % 10000;
    return 'session_${timestamp}_$random';
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    try {
      debugPrint('🔐 [SESSION_MANAGER] Disposing...');

      _stopActivityMonitoring();
      _stopSessionMonitoring();

      await _sessionController.close();
      await _statusController.close();
    } catch (e) {
      debugPrint('❌ [SESSION_MANAGER] Disposal error: $e');
    }
  }
}

/// أنواع أحداث الجلسة
enum SessionEventType {
  sessionStarted,
  sessionEnded,
  activityUpdated,
  sessionTimeout,
  inactivityTimeout,
}

/// حالة الجلسة
enum SessionStatus {
  active,
  inactive,
  expired,
}

/// نموذج حدث الجلسة
class SessionEvent {
  final SessionEventType type;
  final String sessionId;
  final String? userId;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  SessionEvent({
    required this.type,
    required this.sessionId,
    this.userId,
    required this.timestamp,
    this.data,
  });

  @override
  String toString() {
    return 'SessionEvent(type: $type, sessionId: $sessionId, userId: $userId, timestamp: $timestamp, data: $data)';
  }
}
