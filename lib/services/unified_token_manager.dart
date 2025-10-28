import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'platform_storage_service.dart';

/// Unified Token Manager that supports all platforms (Android, iOS, Web)
/// Provides secure token storage, automatic refresh, and session management
class UnifiedTokenManager {
  static const String _accessTokenKey = 'unified_access_token';
  static const String _refreshTokenKey = 'unified_refresh_token';
  static const String _tokenExpiryKey = 'unified_token_expiry';
  static const String _refreshTokenExpiryKey = 'unified_refresh_token_expiry';
  static const String _sessionIdKey = 'unified_session_id';
  static const String _userDataKey = 'unified_user_data';
  static const String _deviceInfoKey = 'unified_device_info';
  static const String _lastActivityKey = 'unified_last_activity';

  static UnifiedTokenManager? _instance;
  static UnifiedTokenManager get instance =>
      _instance ??= UnifiedTokenManager._();

  UnifiedTokenManager._();

  final PlatformStorageService _storage = PlatformStorageService.instance;
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitialized = false;

  // Token refresh lock to prevent concurrent refresh attempts
  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshQueue = [];

  // Session management
  Timer? _sessionTimer;
  final StreamController<SessionEvent> _sessionController =
      StreamController<SessionEvent>.broadcast();

  /// Stream for session events (expiration, refresh, etc.)
  Stream<SessionEvent> get sessionEvents => _sessionController.stream;

  /// Initialize the token manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Update last activity
      await _updateLastActivity();

      // Start session monitoring
      _startSessionMonitoring();

      _isInitialized = true;
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }

      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Initialized successfully');
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Initialization error: $e');
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
    }
  }

  /// Ensure the manager is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
    await _initCompleter.future;
  }

  /// Save tokens and session data
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    String? sessionId,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? deviceInfo,
  }) async {
    await _ensureInitialized();

    try {
      final now = DateTime.now();
      final accessTokenExpiry = now.add(Duration(seconds: expiresIn));
      final refreshTokenExpiry =
          now.add(Duration(days: 30)); // 30 days for refresh token

      // Debug logging for token expiry calculation
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Token expiry calculation:');
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Current time: $now');
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] ExpiresIn from server: $expiresIn seconds (${expiresIn / 86400} days)');
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] Calculated access token expiry: $accessTokenExpiry');
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] Calculated refresh token expiry: $refreshTokenExpiry');
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] Time until access token expires: ${accessTokenExpiry.difference(now).inDays} days, ${accessTokenExpiry.difference(now).inHours % 24} hours');

      // Save tokens securely
      await _storage.writeSecure(_accessTokenKey, accessToken);
      await _storage.writeSecure(_refreshTokenKey, refreshToken);
      await _storage.writeSecure(
          _tokenExpiryKey, accessTokenExpiry.toIso8601String());
      await _storage.writeSecure(
          _refreshTokenExpiryKey, refreshTokenExpiry.toIso8601String());

      // Save session data
      if (sessionId != null) {
        await _storage.writeSecure(_sessionIdKey, sessionId);
      }

      if (userData != null) {
        await _storage.writeSecure(_userDataKey, jsonEncode(userData));
      }

      if (deviceInfo != null) {
        await _storage.writeSecure(_deviceInfoKey, jsonEncode(deviceInfo));
      }

      await _updateLastActivity();

      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Tokens saved successfully');

      // Notify session update
      _sessionController.add(SessionEvent(
        type: SessionEventType.tokenRefreshed,
        timestamp: now,
        data: {'expiresIn': expiresIn},
      ));
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error saving tokens: $e');
      rethrow;
    }
  }

  /// Get valid access token (with automatic refresh if needed)
  Future<String?> getValidAccessToken() async {
    await _ensureInitialized();

    try {
      // Check if we're already refreshing
      if (_isRefreshing) {
        final completer = Completer<String?>();
        _refreshQueue.add(completer);
        return await completer.future;
      }

      final accessToken = await _storage.readSecure(_accessTokenKey);
      if (accessToken == null) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] No access token found');
        return null;
      }

      // Check if token is still valid
      if (await isAccessTokenValid()) {
        await _updateLastActivity();
        return accessToken;
      }

      // Token expired, try to refresh
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] Access token expired, attempting refresh');
      final refreshed = await refreshAccessToken();

      if (refreshed) {
        return await _storage.readSecure(_accessTokenKey);
      }

      return null;
    } catch (e) {
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] Error getting valid access token: $e');
      return null;
    }
  }

  /// Check if access token is valid
  Future<bool> isAccessTokenValid() async {
    await _ensureInitialized();

    try {
      debugPrint('🔐 [TOKEN_DEBUG] Starting access token validity check...');

      // Check if access token exists
      final accessToken = await _storage.readSecure(_accessTokenKey);
      if (accessToken == null) {
        debugPrint('🔐 [TOKEN_DEBUG] ❌ No access token found in storage');
        debugPrint('🔐 [TOKEN_DEBUG] Storage key checked: $_accessTokenKey');
        return false;
      }

      final expiryString = await _storage.readSecure(_tokenExpiryKey);
      if (expiryString == null) {
        debugPrint('🔐 [TOKEN_DEBUG] ❌ No expiry date found in storage');
        debugPrint('🔐 [TOKEN_DEBUG] Storage key checked: $_tokenExpiryKey');
        debugPrint(
            '🔐 [TOKEN_DEBUG] Access token exists but no expiry - treating as invalid');
        return false;
      }

      final expiry = DateTime.parse(expiryString);
      final now = DateTime.now();

      // Add 5-minute buffer before expiration
      final bufferTime = Duration(minutes: 5);
      final effectiveExpiry = expiry.subtract(bufferTime);
      final isValid = now.isBefore(effectiveExpiry);
      final timeUntilExpiry = expiry.difference(now);
      final timeUntilEffectiveExpiry = effectiveExpiry.difference(now);

      // Enhanced debug logging for token validity check
      debugPrint('🔐 [TOKEN_DEBUG] ===== TOKEN VALIDITY CHECK =====');
      debugPrint('🔐 [TOKEN_DEBUG] Current time: $now');
      debugPrint('🔐 [TOKEN_DEBUG] Token expiry: $expiry');
      debugPrint(
          '🔐 [TOKEN_DEBUG] Buffer time: ${bufferTime.inMinutes} minutes');
      debugPrint(
          '🔐 [TOKEN_DEBUG] Effective expiry (with buffer): $effectiveExpiry');
      debugPrint(
          '🔐 [TOKEN_DEBUG] Time until actual expiry: ${timeUntilExpiry.inDays} days, ${timeUntilExpiry.inHours % 24} hours, ${timeUntilExpiry.inMinutes % 60} minutes');
      debugPrint(
          '🔐 [TOKEN_DEBUG] Time until effective expiry: ${timeUntilEffectiveExpiry.inDays} days, ${timeUntilEffectiveExpiry.inHours % 24} hours, ${timeUntilEffectiveExpiry.inMinutes % 60} minutes');
      debugPrint('🔐 [TOKEN_DEBUG] Is token valid (with buffer): $isValid');
      debugPrint(
          '🔐 [TOKEN_DEBUG] Access token length: ${accessToken.length} characters');
      debugPrint(
          '🔐 [TOKEN_DEBUG] Access token prefix: ${accessToken.substring(0, accessToken.length > 20 ? 20 : accessToken.length)}...');

      if (!isValid) {
        debugPrint('🔐 [TOKEN_DEBUG] ❌ Token is invalid or expired');
        if (timeUntilExpiry.isNegative) {
          debugPrint(
              '🔐 [TOKEN_DEBUG] Token has already expired ${timeUntilExpiry.abs().inMinutes} minutes ago');
        } else {
          debugPrint(
              '🔐 [TOKEN_DEBUG] Token expires in ${timeUntilExpiry.inMinutes} minutes but buffer makes it invalid');
        }
      } else {
        debugPrint('🔐 [TOKEN_DEBUG] ✅ Token is valid');
      }

      debugPrint('🔐 [TOKEN_DEBUG] ===== END TOKEN VALIDITY CHECK =====');

      return isValid;
    } catch (e) {
      debugPrint('🔐 [TOKEN_DEBUG] ❌ Error checking token validity: $e');
      debugPrint('🔐 [TOKEN_DEBUG] Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Check if refresh token is valid
  Future<bool> hasValidRefreshToken() async {
    await _ensureInitialized();

    try {
      final refreshToken = await _storage.readSecure(_refreshTokenKey);
      if (refreshToken == null) return false;

      final expiryString = await _storage.readSecure(_refreshTokenExpiryKey);
      if (expiryString == null) return false;

      final expiry = DateTime.parse(expiryString);
      final now = DateTime.now();

      return now.isBefore(expiry);
    } catch (e) {
      debugPrint(
          '🔐 [UNIFIED_TOKEN_MANAGER] Error checking refresh token validity: $e');
      return false;
    }
  }

  /// Refresh access token using refresh token
  Future<bool> refreshAccessToken() async {
    await _ensureInitialized();

    // Prevent concurrent refresh attempts
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshQueue.add(completer);
      final result = await completer.future;
      return result != null;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.readSecure(_refreshTokenKey);
      if (refreshToken == null) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] No refresh token found');
        await _handleSessionExpired('No refresh token');
        return false;
      }

      if (!await hasValidRefreshToken()) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Refresh token expired');
        await _handleSessionExpired('Refresh token expired');
        return false;
      }

      final sessionId = await _storage.readSecure(_sessionIdKey);

      final dio = Dio();
      final response = await dio.post(
        '${_getBaseUrl()}/api/v1/auth/refresh', // إصلاح endpoint ليطابق الخادم
        data: {
          'refreshToken': refreshToken,
          if (sessionId != null) 'sessionId': sessionId,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: Duration(minutes: 5), // زيادة timeout لتجديد التوكن
          receiveTimeout: Duration(minutes: 5), // زيادة timeout لتجديد التوكن
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        await saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'] ?? refreshToken,
          expiresIn: data['expiresIn'] ??
              2592000, // Default 30 days (30 * 24 * 60 * 60 = 2592000 seconds)
          sessionId: data['sessionId'] ?? sessionId,
          userData: data['user'],
        );

        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Token refreshed successfully');

        // Resolve all queued requests
        final newToken = data['accessToken'];
        for (final completer in _refreshQueue) {
          if (!completer.isCompleted) {
            completer.complete(newToken);
          }
        }
        _refreshQueue.clear();

        return true;
      } else {
        debugPrint(
            '🔐 [UNIFIED_TOKEN_MANAGER] Token refresh failed: ${response.statusCode}');
        await _handleSessionExpired('Token refresh failed');
        return false;
      }
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error refreshing token: $e');
      await _handleSessionExpired('Token refresh error: $e');
      return false;
    } finally {
      _isRefreshing = false;

      // Resolve any remaining queued requests with null
      for (final completer in _refreshQueue) {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
      _refreshQueue.clear();
    }
  }

  /// Handle session expiration
  Future<void> _handleSessionExpired(String reason) async {
    debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Session expired: $reason');

    await clearTokens();

    _sessionController.add(SessionEvent(
      type: SessionEventType.sessionExpired,
      timestamp: DateTime.now(),
      data: {'reason': reason},
    ));
  }

  /// Clear all tokens and session data
  Future<void> clearTokens() async {
    await _ensureInitialized();

    try {
      // Clear all secure storage keys
      await _storage.deleteSecure(_accessTokenKey);
      await _storage.deleteSecure(_refreshTokenKey);
      await _storage.deleteSecure(_tokenExpiryKey);
      await _storage.deleteSecure(_refreshTokenExpiryKey);
      await _storage.deleteSecure(_sessionIdKey);
      await _storage.deleteSecure(_userDataKey);
      await _storage.deleteSecure(_deviceInfoKey);
      await _storage.deleteSecure(_lastActivityKey);

      // Cancel session timer
      _sessionTimer?.cancel();

      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] All tokens and data cleared');

      _sessionController.add(SessionEvent(
        type: SessionEventType.sessionCleared,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error clearing tokens: $e');
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return await _storage.readSecure(_refreshTokenKey);
  }

  /// Get session ID
  Future<String?> getSessionId() async {
    await _ensureInitialized();
    return await _storage.readSecure(_sessionIdKey);
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    await _ensureInitialized();

    try {
      final userDataString = await _storage.readSecure(_userDataKey);
      if (userDataString == null) return null;

      return jsonDecode(userDataString);
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error getting user data: $e');
      return null;
    }
  }

  /// Check if there's a valid session
  Future<bool> hasValidSession() async {
    await _ensureInitialized();
    return await hasValidRefreshToken();
  }

  /// Get comprehensive token information
  Future<Map<String, dynamic>> getTokenInfo() async {
    await _ensureInitialized();

    final accessToken = await _storage.readSecure(_accessTokenKey);
    final refreshToken = await _storage.readSecure(_refreshTokenKey);
    final accessExpiry = await _storage.readSecure(_tokenExpiryKey);
    final refreshExpiry = await _storage.readSecure(_refreshTokenExpiryKey);
    final sessionId = await _storage.readSecure(_sessionIdKey);
    final lastActivity = await _storage.readSecure(_lastActivityKey);

    return {
      'hasAccessToken': accessToken != null,
      'hasRefreshToken': refreshToken != null,
      'accessTokenValid': await isAccessTokenValid(),
      'refreshTokenValid': await hasValidRefreshToken(),
      'accessExpiry': accessExpiry,
      'refreshExpiry': refreshExpiry,
      'sessionId': sessionId,
      'lastActivity': lastActivity,
      'platform': kIsWeb ? 'web' : 'mobile',
    };
  }

  /// Update last activity timestamp
  Future<void> _updateLastActivity() async {
    try {
      await _storage.writeSecure(
          _lastActivityKey, DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error updating last activity: $e');
    }
  }

  /// Start session monitoring - تقليل عدد الطلبات
  void _startSessionMonitoring() {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(Duration(minutes: 30), (timer) async {
      // تغيير من 5 دقائق إلى 30 دقيقة
      try {
        // Check if session is still valid
        if (!await hasValidSession()) {
          await _handleSessionExpired('Session monitoring detected expiration');
          timer.cancel();
          return;
        }

        // Update activity
        await _updateLastActivity();

        // Check if token needs refresh soon (within 6 hours instead of 10 minutes)
        final expiryString = await _storage.readSecure(_tokenExpiryKey);
        if (expiryString != null) {
          final expiry = DateTime.parse(expiryString);
          final now = DateTime.now();
          final timeUntilExpiry = expiry.difference(now);

          if (timeUntilExpiry.inHours <= 6 && timeUntilExpiry.inHours > 0) {
            // تغيير من 10 دقائق إلى 6 ساعات
            debugPrint(
                '🔐 [UNIFIED_TOKEN_MANAGER] Token expires soon, refreshing proactively');
            await refreshAccessToken();
          }
        }
      } catch (e) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Session monitoring error: $e');
      }
    });
  }

  /// Logout from current session
  Future<bool> logout() async {
    await _ensureInitialized();

    try {
      final refreshToken = await getRefreshToken();
      final sessionId = await getSessionId();

      if (refreshToken != null) {
        final dio = Dio();
        try {
          await dio.post(
            '${_getBaseUrl()}/auth/logout',
            data: {
              'refreshToken': refreshToken,
              if (sessionId != null) 'sessionId': sessionId,
            },
            options: Options(
              headers: {'Content-Type': 'application/json'},
              sendTimeout: Duration(minutes: 2), // زيادة timeout لتسجيل الخروج
              receiveTimeout: Duration(minutes: 2), // زيادة timeout لتسجيل الخروج
            ),
          );
        } catch (e) {
          debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Server logout failed: $e');
          // Continue with local logout even if server logout fails
        }
      }

      await clearTokens();

      _sessionController.add(SessionEvent(
        type: SessionEventType.loggedOut,
        timestamp: DateTime.now(),
      ));

      return true;
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Logout error: $e');
      // Clear tokens locally even if logout fails
      await clearTokens();
      return true;
    }
  }

  /// Get base URL for API calls
  String _getBaseUrl() {
    // This can be configured based on environment
    return 'https://api.idec-ye.com';
  }

  /// Dispose resources
  void dispose() {
    _sessionTimer?.cancel();
    _sessionController.close();
  }
}

/// Session event types
enum SessionEventType {
  tokenRefreshed,
  sessionExpired,
  sessionCleared,
  loggedOut,
  sessionWarning,
}

/// Session event data
class SessionEvent {
  final SessionEventType type;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  SessionEvent({
    required this.type,
    required this.timestamp,
    this.data,
  });

  @override
  String toString() {
    return 'SessionEvent(type: $type, timestamp: $timestamp, data: $data)';
  }
}
