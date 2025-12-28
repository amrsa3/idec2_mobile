import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'platform_storage_service.dart';
import '../core/constants/api_constants.dart';

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
  
  // Flag to prevent multiple refresh scheduling attempts
  bool _isSchedulingRefresh = false;

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
    int? refreshExpiresIn,
    String? sessionId,
    Map<String, dynamic>? userData,
    Map<String, dynamic>? deviceInfo,
  }) async {
    await _ensureInitialized();

    try {
      final now = DateTime.now();
      final accessTokenExpiry = now.add(Duration(seconds: expiresIn));
      // استخدام مدة صلاحية refresh token من الخادم دائماً (يجب أن يكون موجوداً في الاستجابة)
      // إذا لم يكن موجوداً، نستخدم قيمة احتياطية كبيرة (30 يوم) لتجنب إنهاء الجلسة بالخطأ
      // لكن هذا يجب ألا يحدث في الوضع الطبيعي لأن الخادم يرسل refreshExpiresIn دائماً
      final refreshTokenExpiry = refreshExpiresIn != null
          ? now.add(Duration(seconds: refreshExpiresIn))
          : now.add(const Duration(days: 30));

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

      // بعد حفظ التوكن الجديد، جدول تجديد التالي
      _scheduleNextTokenRefresh();
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
      
      // إضافة buffer time (60 ثانية) لتجنب مشاكل اختلاف التوقيت بين التطبيق والخادم
      // هذا يضمن أن التوكن لا يُعتبر صالحاً إذا كان على وشك الانتهاء
      // تم زيادة Buffer من 30 إلى 60 ثانية لضمان تجديد التوكن قبل انتهائه بوقت كاف
      const bufferTime = Duration(seconds: 60);
      final effectiveExpiry = expiry.subtract(bufferTime);
      final isValid = now.isBefore(effectiveExpiry);
      final timeUntilExpiry = expiry.difference(now);
      final timeUntilEffectiveExpiry = effectiveExpiry.difference(now);

      // Debug logging for token validity check
      if (timeUntilExpiry.isNegative) {
        debugPrint('🔐 [TOKEN_DEBUG] ❌ Token expired ${timeUntilExpiry.abs().inMinutes} minutes ago');
      } else if (timeUntilEffectiveExpiry.isNegative || timeUntilEffectiveExpiry.inSeconds < 60) {
        debugPrint('🔐 [TOKEN_DEBUG] ⚠️ Token expires soon (${timeUntilExpiry.inSeconds} seconds) - considered invalid due to 60s buffer');
      } else {
        debugPrint('🔐 [TOKEN_DEBUG] ✅ Token valid, expires in ${timeUntilExpiry.inMinutes} minutes (effective: ${timeUntilEffectiveExpiry.inMinutes} minutes with buffer)');
      }

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

    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    final requestTime = DateTime.now();

    // Prevent concurrent refresh attempts
    if (_isRefreshing) {
      debugPrint('⏳ [REFRESH_TOKEN_LOG] Request $requestId: Refresh already in progress, queuing...');
      final completer = Completer<String?>();
      _refreshQueue.add(completer);
      final result = await completer.future;
      return result != null;
    }

    _isRefreshing = true;

    try {
      debugPrint('🔄 [REFRESH_TOKEN_LOG] ========== REFRESH TOKEN REQUEST START ==========');
      debugPrint('🔄 [REFRESH_TOKEN_LOG] Request ID: $requestId');
      debugPrint('🔄 [REFRESH_TOKEN_LOG] Request Time: ${requestTime.toIso8601String()}');
      
      // Get current token states
      final currentAccessToken = await _storage.readSecure(_accessTokenKey);
      final currentRefreshToken = await _storage.readSecure(_refreshTokenKey);
      final accessExpiry = await _storage.readSecure(_tokenExpiryKey);
      final refreshExpiry = await _storage.readSecure(_refreshTokenExpiryKey);
      
      debugPrint('🔄 [REFRESH_TOKEN_LOG] Current State:');
      debugPrint('   - Has Access Token: ${currentAccessToken != null}');
      debugPrint('   - Access Token Length: ${currentAccessToken?.length ?? 0}');
      debugPrint('   - Access Token Expiry: ${accessExpiry ?? "N/A"}');
      if (accessExpiry != null) {
        try {
          final expiry = DateTime.parse(accessExpiry);
          final now = DateTime.now();
          final timeUntilExpiry = expiry.difference(now);
          debugPrint('   - Time Until Access Expiry: ${timeUntilExpiry.inMinutes} minutes');
        } catch (e) {
          debugPrint('   - Error parsing access expiry: $e');
        }
      }
      debugPrint('   - Has Refresh Token: ${currentRefreshToken != null}');
      debugPrint('   - Refresh Token Length: ${currentRefreshToken?.length ?? 0}');
      debugPrint('   - Refresh Token Expiry: ${refreshExpiry ?? "N/A"}');
      if (refreshExpiry != null) {
        try {
          final expiry = DateTime.parse(refreshExpiry);
          final now = DateTime.now();
          final timeUntilExpiry = expiry.difference(now);
          debugPrint('   - Time Until Refresh Expiry: ${timeUntilExpiry.inDays} days');
        } catch (e) {
          debugPrint('   - Error parsing refresh expiry: $e');
        }
      }

      if (currentRefreshToken == null) {
        debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: No refresh token found');
        await _handleSessionExpired('No refresh token');
        return false;
      }

      final isValidRefresh = await hasValidRefreshToken();
      debugPrint('🔄 [REFRESH_TOKEN_LOG] Refresh Token Valid: $isValidRefresh');
      
      if (!isValidRefresh) {
        debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Refresh token expired');
        await _handleSessionExpired('Refresh token expired');
        return false;
      }

      final sessionId = await _storage.readSecure(_sessionIdKey);
      final baseUrl = _getBaseUrl();
      final endpoint = '$baseUrl/api/v1/auth/refresh';
      
      debugPrint('🔄 [REFRESH_TOKEN_LOG] Request Details:');
      debugPrint('   - Endpoint: $endpoint');
      debugPrint('   - Method: POST');
      debugPrint('   - Has Session ID: ${sessionId != null}');
      debugPrint('   - Session ID: ${sessionId ?? "N/A"}');
      debugPrint('   - Refresh Token (first 20 chars): ${currentRefreshToken.substring(0, currentRefreshToken.length > 20 ? 20 : currentRefreshToken.length)}...');
      debugPrint('   - Refresh Token (last 10 chars): ...${currentRefreshToken.substring(currentRefreshToken.length > 10 ? currentRefreshToken.length - 10 : 0)}');

      final requestData = {
        'refreshToken': currentRefreshToken,
        if (sessionId != null) 'sessionId': sessionId,
      };
      
      debugPrint('🔄 [REFRESH_TOKEN_LOG] Sending request to server...');
      final requestStartTime = DateTime.now();

      final dio = Dio();
      final response = await dio.post(
        endpoint,
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final requestDuration = DateTime.now().difference(requestStartTime);
      debugPrint('✅ [REFRESH_TOKEN_LOG] Response received:');
      debugPrint('   - Status Code: ${response.statusCode}');
      debugPrint('   - Request Duration: ${requestDuration.inMilliseconds}ms');
      debugPrint('   - Response Time: ${DateTime.now().toIso8601String()}');

      if (response.statusCode == 200) {
        debugPrint('✅ [REFRESH_TOKEN_LOG] Request $requestId: Success (200)');
        
        // استخراج البيانات من الاستجابة - قد تكون في data أو مباشرة
        final responseData = response.data;
        Map<String, dynamic> data;
        
        debugPrint('🔄 [REFRESH_TOKEN_LOG] Parsing response data...');
        debugPrint('   - Response Type: ${responseData.runtimeType}');
        
        // إذا كانت الاستجابة تحتوي على data object (Smart Messages System)
        if (responseData is Map && responseData.containsKey('data')) {
          data = responseData['data'] as Map<String, dynamic>;
          debugPrint('✅ [REFRESH_TOKEN_LOG] Response has data wrapper, extracting...');
        } else if (responseData is Map) {
          data = responseData as Map<String, dynamic>;
          debugPrint('✅ [REFRESH_TOKEN_LOG] Response is direct map');
        } else {
          debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Unexpected response format: ${responseData.runtimeType}');
          debugPrint('   - Response Data: $responseData');
          return false;
        }
        
        debugPrint('🔄 [REFRESH_TOKEN_LOG] Response Data Keys: ${data.keys.toList()}');

        // استخراج مدة صلاحية refresh token من الاستجابة
        // يجب أن يكون refreshExpiresIn موجوداً دائماً في الاستجابة من الخادم
        int? refreshExpiresIn;
        
        // محاولة استخراج refreshExpiresIn مباشرة من الاستجابة
        if (data.containsKey('refreshExpiresIn')) {
          try {
            refreshExpiresIn = data['refreshExpiresIn'] as int?;
            if (refreshExpiresIn != null) {
              debugPrint('✅ [UNIFIED_TOKEN_MANAGER] Got refreshExpiresIn from response: $refreshExpiresIn seconds (${refreshExpiresIn / 86400} days)');
            }
          } catch (e) {
            debugPrint('⚠️ [UNIFIED_TOKEN_MANAGER] Error parsing refreshExpiresIn: $e');
          }
        }
        
        // إذا لم يكن موجوداً في المستوى العلوي، حاول البحث في tokens object
        if (refreshExpiresIn == null && data.containsKey('tokens')) {
          try {
            final tokens = data['tokens'] as Map<String, dynamic>?;
            if (tokens != null && tokens.containsKey('refreshExpiresIn')) {
              refreshExpiresIn = tokens['refreshExpiresIn'] as int?;
              if (refreshExpiresIn != null) {
                debugPrint('✅ [UNIFIED_TOKEN_MANAGER] Got refreshExpiresIn from tokens object: $refreshExpiresIn seconds (${refreshExpiresIn / 86400} days)');
              }
            }
          } catch (e) {
            debugPrint('⚠️ [UNIFIED_TOKEN_MANAGER] Error parsing refreshExpiresIn from tokens: $e');
          }
        }
        
        // إذا لم يكن موجوداً، حاول استخراجه من refreshTokenExpiresAt (للتوافق مع الإصدارات القديمة)
        if (refreshExpiresIn == null && data.containsKey('refreshTokenExpiresAt')) {
          try {
            final refreshExpiresAtString = data['refreshTokenExpiresAt'] as String;
            final refreshExpiresAt = DateTime.parse(refreshExpiresAtString);
            final now = DateTime.now();
            refreshExpiresIn = refreshExpiresAt.difference(now).inSeconds;
            debugPrint('✅ [UNIFIED_TOKEN_MANAGER] Calculated refreshExpiresIn from refreshTokenExpiresAt: $refreshExpiresIn seconds (${refreshExpiresIn / 86400} days)');
          } catch (e) {
            debugPrint('⚠️ [UNIFIED_TOKEN_MANAGER] Error parsing refreshTokenExpiresAt: $e');
          }
        }
        
        // إذا لم يكن موجوداً بعد كل المحاولات، استخدم قيمة احتياطية كبيرة (30 يوم)
        // هذا يجب ألا يحدث في الوضع الطبيعي لأن الخادم يرسل refreshExpiresIn دائماً
        if (refreshExpiresIn == null) {
          refreshExpiresIn = 30 * 24 * 60 * 60; // 30 days in seconds as fallback
          debugPrint('⚠️ [UNIFIED_TOKEN_MANAGER] WARNING: refreshExpiresIn not found in response, using fallback: $refreshExpiresIn seconds (30 days)');
          debugPrint('⚠️ [UNIFIED_TOKEN_MANAGER] This should not happen - server should always send refreshExpiresIn');
        }
        
        // استخراج التوكنات - قد تكون في tokens object أو مباشرة
        String? newAccessToken = data['accessToken'];
        String? newRefreshToken = data['refreshToken'] ?? data['refresh_token'];
        int? expiresIn = data['expiresIn'] ?? data['expires_in'];
        
        // إذا لم تكن موجودة مباشرة، حاول البحث في tokens object
        if (newAccessToken == null && data.containsKey('tokens')) {
          final tokens = data['tokens'] as Map<String, dynamic>?;
          if (tokens != null) {
            newAccessToken = tokens['accessToken'] ?? tokens['access_token'];
            newRefreshToken = tokens['refreshToken'] ?? tokens['refresh_token'] ?? newRefreshToken;
            expiresIn = tokens['expiresIn'] ?? tokens['expires_in'] ?? expiresIn;
            refreshExpiresIn = tokens['refreshExpiresIn'] ?? tokens['refresh_expires_in'] ?? refreshExpiresIn;
          }
        }
        
        if (newAccessToken == null) {
          debugPrint('❌ [UNIFIED_TOKEN_MANAGER] No access token in refresh response');
          return false;
        }
        
        debugPrint('🔄 [REFRESH_TOKEN_LOG] Saving new tokens...');
        debugPrint('   - New Access Token Length: ${newAccessToken.length}');
        debugPrint('   - New Access Token (first 20 chars): ${newAccessToken.substring(0, newAccessToken.length > 20 ? 20 : newAccessToken.length)}...');
        debugPrint('   - New Refresh Token Length: ${newRefreshToken?.length ?? 0}');
        debugPrint('   - Expires In: ${expiresIn ?? 900} seconds');
        debugPrint('   - Refresh Expires In: ${refreshExpiresIn ?? 0} seconds (${(refreshExpiresIn ?? 0) / 86400} days)');
        
        await saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken ?? currentRefreshToken,
          expiresIn: expiresIn ?? 900, // Default 15 minutes (900 seconds)
          refreshExpiresIn: refreshExpiresIn,
          sessionId: data['sessionId'] ?? sessionId,
          userData: data['user'],
        );

        final totalDuration = DateTime.now().difference(requestTime);
        debugPrint('✅ [REFRESH_TOKEN_LOG] Request $requestId: Token refreshed successfully');
        debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
        debugPrint('🔄 [REFRESH_TOKEN_LOG] ========== REFRESH TOKEN REQUEST END (SUCCESS) ==========');

        // Resolve all queued requests
        final newToken = newAccessToken;
        for (final completer in _refreshQueue) {
          if (!completer.isCompleted) {
            completer.complete(newToken);
          }
        }
        _refreshQueue.clear();

        return true;
      } else {
        final errorMessage = response.data is Map 
            ? response.data['message'] ?? 'Token refresh failed'
            : 'Token refresh failed';
        final totalDuration = DateTime.now().difference(requestTime);
        
        debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Token refresh failed');
        debugPrint('   - Status Code: ${response.statusCode}');
        debugPrint('   - Error Message: $errorMessage');
        debugPrint('   - Response Data: ${response.data}');
        debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
        
        // إذا كان refresh token منتهي الصلاحية (401)، قم بإنهاء الجلسة
        if (response.statusCode == 401) {
          debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Refresh token expired or invalid (401), ending session');
          await _handleSessionExpired('Refresh token expired or invalid');
        } else {
          // لأخطاء أخرى، حاول مرة أخرى لاحقاً
          debugPrint('⚠️ [REFRESH_TOKEN_LOG] Request $requestId: Token refresh failed with non-401 error, will retry later');
        }
        debugPrint('🔄 [REFRESH_TOKEN_LOG] ========== REFRESH TOKEN REQUEST END (FAILED) ==========');
        return false;
      }
    } on DioException catch (e) {
      final totalDuration = DateTime.now().difference(requestTime);
      
      debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: DioException occurred');
      debugPrint('   - Exception Type: ${e.type}');
      debugPrint('   - Status Code: ${e.response?.statusCode ?? "N/A"}');
      debugPrint('   - Message: ${e.message}');
      debugPrint('   - Error: ${e.error}');
      debugPrint('   - Response Data: ${e.response?.data}');
      debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
      
      // معالجة أخطاء Dio بشكل أفضل
      if (e.response?.statusCode == 401) {
        debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Refresh token expired or invalid (401), ending session');
        await _handleSessionExpired('Refresh token expired or invalid');
      } else if (e.type == DioExceptionType.connectionTimeout || 
                 e.type == DioExceptionType.receiveTimeout) {
        debugPrint('⏱️ [REFRESH_TOKEN_LOG] Request $requestId: Network timeout during token refresh');
        debugPrint('   - Timeout Type: ${e.type}');
        // لا ننهي الجلسة في حالة timeout، قد تكون مشكلة شبكة مؤقتة
      } else {
        debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Dio error refreshing token');
        await _handleSessionExpired('Token refresh error: $e');
      }
      debugPrint('🔄 [REFRESH_TOKEN_LOG] ========== REFRESH TOKEN REQUEST END (DIO_ERROR) ==========');
      return false;
    } catch (e, stackTrace) {
      final totalDuration = DateTime.now().difference(requestTime);
      
      debugPrint('❌ [REFRESH_TOKEN_LOG] Request $requestId: Unexpected error refreshing token');
      debugPrint('   - Error Type: ${e.runtimeType}');
      debugPrint('   - Error: $e');
      debugPrint('   - Stack Trace: $stackTrace');
      debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
      await _handleSessionExpired('Token refresh error: $e');
      debugPrint('🔄 [REFRESH_TOKEN_LOG] ========== REFRESH TOKEN REQUEST END (UNEXPECTED_ERROR) ==========');
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

  /// Start session monitoring
  /// يتم استخدام timer محسوب بناءً على وقت انتهاء التوكن لتقليل الحمل على الخادم
  void _startSessionMonitoring() {
    _sessionTimer?.cancel();
    _scheduleNextTokenRefresh();
    debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Session monitoring initialized with calculated timer');
  }

  /// جدولة تجديد التوكن التالي بناءً على وقت انتهاء الصلاحية
  /// هذا يقلل الحمل على الخادم بدلاً من فحص دوري لكل المستخدمين
  Future<void> _scheduleNextTokenRefresh() async {
    // منع جدولة متعددة متزامنة
    if (_isSchedulingRefresh) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Refresh scheduling already in progress, skipping');
      return;
    }
    
    _isSchedulingRefresh = true;
    try {
      final expiryString = await _storage.readSecure(_tokenExpiryKey);
      if (expiryString == null) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] No token expiry found, skipping refresh scheduling');
        return;
      }

      final expiry = DateTime.parse(expiryString);
      final now = DateTime.now();
      final timeUntilExpiry = expiry.difference(now);

      // إذا كان التوكن منتهي بالفعل، قم بتجديده فوراً
      if (timeUntilExpiry.isNegative || timeUntilExpiry.inSeconds <= 0) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Token already expired, refreshing immediately');
        final hasRefresh = await hasValidRefreshToken();
        if (hasRefresh) {
          await refreshAccessToken();
        } else {
          await _handleSessionExpired('Token expired and no valid refresh token');
        }
        return;
      }

      // احسب الوقت المتبقي قبل 10 دقائق من انتهاء الصلاحية
      // نريد تجديد التوكن قبل 10 دقائق من انتهائه
      const refreshBuffer = Duration(minutes: 10);
      final refreshTime = timeUntilExpiry - refreshBuffer;

      // إذا كان الوقت المتبقي أقل من 10 دقائق، قم بتجديده فوراً
      if (refreshTime.isNegative || refreshTime.inSeconds <= 0) {
        debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Token expires soon (${timeUntilExpiry.inMinutes} minutes), refreshing immediately');
        final hasRefresh = await hasValidRefreshToken();
        if (hasRefresh) {
          await refreshAccessToken();
        }
        return;
      }

      // جدولة تجديد واحد فقط عند الوقت المحدد
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Scheduling token refresh in ${refreshTime.inMinutes} minutes (${refreshTime.inSeconds} seconds)');
      _sessionTimer = Timer(refreshTime, () async {
        try {
          debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Scheduled refresh time reached, refreshing token...');
          final hasRefresh = await hasValidRefreshToken();
          if (hasRefresh) {
            final success = await refreshAccessToken();
            if (success) {
              // بعد نجاح التجديد، جدول التالي
              _scheduleNextTokenRefresh();
            } else {
              await _handleSessionExpired('Scheduled refresh failed');
            }
          } else {
            await _handleSessionExpired('No valid refresh token for scheduled refresh');
          }
        } catch (e) {
          debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error in scheduled refresh: $e');
          // في حالة الخطأ، حاول مرة أخرى بعد 5 دقائق
          _sessionTimer = Timer(const Duration(minutes: 5), () {
            _scheduleNextTokenRefresh();
          });
        }
      });
    } catch (e) {
      debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error scheduling token refresh: $e');
      // في حالة الخطأ، استخدم fallback: فحص كل 10 دقائق
      _sessionTimer = Timer.periodic(const Duration(minutes: 10), (timer) async {
        try {
          final isValid = await isAccessTokenValid();
          if (!isValid) {
            final hasRefresh = await hasValidRefreshToken();
            if (hasRefresh) {
              await refreshAccessToken();
              timer.cancel();
              _scheduleNextTokenRefresh();
            } else {
              timer.cancel();
              await _handleSessionExpired('Token expired');
            }
          }
        } catch (e) {
          debugPrint('🔐 [UNIFIED_TOKEN_MANAGER] Error in fallback monitoring: $e');
        }
      });
    } finally {
      _isSchedulingRefresh = false;
    }
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
              sendTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
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
    // Use ApiConstants.baseUrl to ensure consistency
    return ApiConstants.baseUrl;
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
