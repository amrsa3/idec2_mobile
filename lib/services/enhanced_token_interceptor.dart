import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'unified_token_manager.dart';
import 'silent_token_refresh_service.dart';
import 'enhanced_session_manager.dart';

/// Enhanced Token Interceptor with silent refresh and advanced error handling
class EnhancedTokenInterceptor extends Interceptor {
  final UnifiedTokenManager _tokenManager;
  final SilentTokenRefreshService _silentRefresh;
  final EnhancedSessionManager _sessionManager;
  
  // Track ongoing refresh operations to prevent race conditions
  static final Map<String, Completer<bool>> _refreshCompleters = {};
  static bool _isRefreshing = false;
  
  // Request queue for failed requests during token refresh
  static final List<RequestOptions> _failedQueue = [];
  
  // Statistics tracking
  int _totalRequests = 0;
  int _tokenRefreshCount = 0;
  int _retryCount = 0;
  DateTime? _lastRefreshTime;

  EnhancedTokenInterceptor({
    UnifiedTokenManager? tokenManager,
    SilentTokenRefreshService? silentRefresh,
    EnhancedSessionManager? sessionManager,
  }) : _tokenManager = tokenManager ?? UnifiedTokenManager.instance,
       _silentRefresh = silentRefresh ?? SilentTokenRefreshService.instance,
       _sessionManager = sessionManager ?? EnhancedSessionManager.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _totalRequests++;
    
    try {
      debugPrint('🔐 [TOKEN_INTERCEPTOR] Processing request: ${options.method} ${options.path}');
      
      // Skip token injection for auth endpoints
      if (_isAuthEndpoint(options.path)) {
        debugPrint('🔐 [TOKEN_INTERCEPTOR] Skipping token for auth endpoint');
        handler.next(options);
        return;
      }

      // Get access token
      final accessToken = await _tokenManager.getValidAccessToken();
      
      if (accessToken != null && accessToken.isNotEmpty) {
        // Check if token is about to expire and refresh if needed
        await _checkAndRefreshToken();
        
        // Get the latest token after potential refresh
        final latestToken = await _tokenManager.getValidAccessToken();
        
        if (latestToken != null && latestToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $latestToken';
          debugPrint('🔐 [TOKEN_INTERCEPTOR] Token added to request');
        }
      } else {
        debugPrint('⚠️ [TOKEN_INTERCEPTOR] No access token available');
      }

      handler.next(options);
    } catch (e) {
      debugPrint('❌ [TOKEN_INTERCEPTOR] Error in onRequest: $e');
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [TOKEN_INTERCEPTOR] Response received: ${response.statusCode}');
    
    // Update session activity on successful requests
    if (response.statusCode == 200) {
      _sessionManager.updateActivity();
    }
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('❌ [TOKEN_INTERCEPTOR] Error intercepted: ${err.response?.statusCode} - ${err.message}');
    
    // Handle token-related errors
    if (_isTokenError(err)) {
      final handled = await _handleTokenError(err, handler);
      if (handled) {
        return; // Error was handled, don't propagate
      }
    }
    
    // Handle network errors
    if (_isNetworkError(err)) {
      _handleNetworkError(err, handler);
      return;
    }
    
    // Handle server errors
    if (_isServerError(err)) {
      _handleServerError(err, handler);
      return;
    }
    
    handler.next(err);
  }

  /// Check if token needs refresh and refresh if necessary
  Future<void> _checkAndRefreshToken() async {
    try {
      final tokenInfo = await _tokenManager.getTokenInfo();
      
      if (tokenInfo['accessExpiry'] != null) {
        final expiryString = tokenInfo['accessExpiry'] as String;
        final expiry = DateTime.parse(expiryString);
        final timeUntilExpiry = expiry.difference(DateTime.now());
        
        // Refresh if token expires in less than 5 minutes
        if (timeUntilExpiry.inMinutes < 5) {
          debugPrint('🔄 [TOKEN_INTERCEPTOR] Token expires soon, refreshing preemptively');
          await _performTokenRefresh();
        }
      }
    } catch (e) {
      debugPrint('⚠️ [TOKEN_INTERCEPTOR] Preemptive token check failed: $e');
    }
  }

  /// Handle token-related errors (401, 403)
  Future<bool> _handleTokenError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    
    if (statusCode == 401) {
      return await _handle401Error(err, handler);
    } else if (statusCode == 403) {
      return await _handle403Error(err, handler);
    }
    
    return false;
  }

  /// Handle 401 Unauthorized errors
  Future<bool> _handle401Error(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('🔄 [TOKEN_INTERCEPTOR] Handling 401 error - attempting token refresh');
    
    try {
      // Check if we have a refresh token
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❌ [TOKEN_INTERCEPTOR] No refresh token available, ending session');
        await _sessionManager.endSession();
        return false;
      }

      // Attempt token refresh
      final refreshSuccess = await _performTokenRefresh();
      
      if (refreshSuccess) {
        // Retry the original request with new token
        final retrySuccess = await _retryRequest(err.requestOptions, handler);
        return retrySuccess;
      } else {
        debugPrint('❌ [TOKEN_INTERCEPTOR] Token refresh failed, ending session');
        await _sessionManager.endSession();
        return false;
      }
    } catch (e) {
      debugPrint('❌ [TOKEN_INTERCEPTOR] Error handling 401: $e');
      await _sessionManager.endSession();
      return false;
    }
  }

  /// Handle 403 Forbidden errors
  Future<bool> _handle403Error(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('⚠️ [TOKEN_INTERCEPTOR] Handling 403 error');
    
    final errorData = err.response?.data;
    
    // Check if it's a token-related 403
    if (errorData is Map && errorData['code'] == 'TOKEN_EXPIRED') {
      debugPrint('🔄 [TOKEN_INTERCEPTOR] 403 with TOKEN_EXPIRED - treating as 401');
      return await _handle401Error(err, handler); // Treat as 401
    }
    
    // Check if it's insufficient permissions or access denied
    if (errorData is Map && 
        (errorData['code'] == 'INSUFFICIENT_PERMISSIONS' || 
         errorData['code'] == 'HTTP_403' ||
         errorData['message']?.toString().contains('الصلاحية') == true ||
         errorData['message']?.toString().contains('permission') == true)) {
      debugPrint('❌ [TOKEN_INTERCEPTOR] Permission denied - not a token issue, letting error propagate');
      // Don't retry, this is a permission issue not a token issue
      return false;
    }
    
    // For other ambiguous 403 errors, don't refresh token automatically
    // 403 typically means "forbidden" due to permissions, not expired tokens
    debugPrint('❌ [TOKEN_INTERCEPTOR] 403 Forbidden - likely permission issue, not refreshing token');
    return false;
  }

  /// Perform token refresh with race condition protection
  Future<bool> _performTokenRefresh() async {
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Check if refresh is already in progress
    if (_isRefreshing) {
      debugPrint('⏳ [TOKEN_INTERCEPTOR] Token refresh already in progress, waiting...');
      
      // Wait for ongoing refresh to complete
      final existingCompleter = _refreshCompleters.values.firstOrNull;
      if (existingCompleter != null) {
        return await existingCompleter.future;
      }
    }
    
    // Start new refresh operation
    _isRefreshing = true;
    final completer = Completer<bool>();
    _refreshCompleters[requestId] = completer;
    
    try {
      debugPrint('🔄 [TOKEN_INTERCEPTOR] Starting token refresh');
      _tokenRefreshCount++;
      _lastRefreshTime = DateTime.now();
      
      final success = await _tokenManager.refreshAccessToken();
      
      if (success) {
        debugPrint('✅ [TOKEN_INTERCEPTOR] Token refresh successful');
        
        // Process any queued failed requests
        await _processFailedQueue();
      } else {
        debugPrint('❌ [TOKEN_INTERCEPTOR] Token refresh failed');
      }
      
      completer.complete(success);
      return success;
    } catch (e) {
      debugPrint('❌ [TOKEN_INTERCEPTOR] Token refresh error: $e');
      completer.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleters.remove(requestId);
    }
  }

  /// Retry the original request with new token
  Future<bool> _retryRequest(RequestOptions originalOptions, ErrorInterceptorHandler handler) async {
    try {
      debugPrint('🔄 [TOKEN_INTERCEPTOR] Retrying original request');
      _retryCount++;
      
      // Get new access token
      final newToken = await _tokenManager.getValidAccessToken();
      if (newToken == null || newToken.isEmpty) {
        debugPrint('❌ [TOKEN_INTERCEPTOR] No new token available for retry');
        return false;
      }
      
      // Update authorization header
      originalOptions.headers['Authorization'] = 'Bearer $newToken';
      
      // Create new Dio instance to avoid interceptor loops
      final dio = Dio();
      dio.options.baseUrl = originalOptions.baseUrl;
      dio.options.connectTimeout = originalOptions.connectTimeout;
      dio.options.receiveTimeout = originalOptions.receiveTimeout;
      
      // Make the retry request
      final response = await dio.request(
        originalOptions.path,
        data: originalOptions.data,
        queryParameters: originalOptions.queryParameters,
        options: Options(
          method: originalOptions.method,
          headers: originalOptions.headers,
          responseType: originalOptions.responseType,
          contentType: originalOptions.contentType,
        ),
      );
      
      debugPrint('✅ [TOKEN_INTERCEPTOR] Retry request successful');
      handler.resolve(response);
      return true;
    } catch (e) {
      debugPrint('❌ [TOKEN_INTERCEPTOR] Retry request failed: $e');
      return false;
    }
  }

  /// Process failed requests queue
  Future<void> _processFailedQueue() async {
    if (_failedQueue.isEmpty) return;
    
    debugPrint('🔄 [TOKEN_INTERCEPTOR] Processing ${_failedQueue.length} queued requests');
    
    final queueCopy = List<RequestOptions>.from(_failedQueue);
    _failedQueue.clear();
    
    for (final request in queueCopy) {
      try {
        // Update token for queued request
        final newToken = await _tokenManager.getValidAccessToken();
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
        }
        
        // Note: In a real implementation, you'd need to store the handler
        // to properly resolve these queued requests
        debugPrint('🔄 [TOKEN_INTERCEPTOR] Would retry queued request: ${request.path}');
      } catch (e) {
        debugPrint('❌ [TOKEN_INTERCEPTOR] Failed to process queued request: $e');
      }
    }
  }

  /// Handle network errors
  void _handleNetworkError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('🌐 [TOKEN_INTERCEPTOR] Network error: ${err.message}');
    
    // Add request to failed queue for retry when network is restored
    if (!_isAuthEndpoint(err.requestOptions.path)) {
      _failedQueue.add(err.requestOptions);
      debugPrint('📝 [TOKEN_INTERCEPTOR] Request queued for retry when network is restored');
    }
    
    handler.next(err);
  }

  /// Handle server errors (5xx)
  void _handleServerError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    debugPrint('🔥 [TOKEN_INTERCEPTOR] Server error: $statusCode');
    
    // Handle maintenance mode
    if (statusCode == 503) {
      debugPrint('🚧 [TOKEN_INTERCEPTOR] Server in maintenance mode');
      // Could implement maintenance mode handling here
    }
    
    handler.next(err);
  }

  /// Check if the endpoint is an authentication endpoint
  bool _isAuthEndpoint(String path) {
    final authPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/logout',
      '/auth/verify-otp',
      '/auth/resend-otp',
      '/auth/forgot-password',
      '/auth/reset-password',
    ];
    
    return authPaths.any((authPath) => path.contains(authPath));
  }

  /// Check if error is token-related
  bool _isTokenError(DioException err) {
    final statusCode = err.response?.statusCode;
    return statusCode == 401 || statusCode == 403;
  }

  /// Check if error is network-related
  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.error is SocketException);
  }

  /// Check if error is server-related
  bool _isServerError(DioException err) {
    final statusCode = err.response?.statusCode;
    return statusCode != null && statusCode >= 500;
  }

  /// Get interceptor statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalRequests': _totalRequests,
      'tokenRefreshCount': _tokenRefreshCount,
      'retryCount': _retryCount,
      'lastRefreshTime': _lastRefreshTime?.toIso8601String(),
      'isRefreshing': _isRefreshing,
      'queuedRequests': _failedQueue.length,
    };
  }

  /// Reset statistics
  void resetStatistics() {
    _totalRequests = 0;
    _tokenRefreshCount = 0;
    _retryCount = 0;
    _lastRefreshTime = null;
  }
}

/// Extension for easy access to enhanced token interceptor
extension EnhancedTokenInterceptorExtension on Dio {
  /// Add enhanced token interceptor
  void addEnhancedTokenInterceptor({
    UnifiedTokenManager? tokenManager,
    SilentTokenRefreshService? silentRefresh,
    EnhancedSessionManager? sessionManager,
  }) {
    interceptors.add(EnhancedTokenInterceptor(
      tokenManager: tokenManager,
      silentRefresh: silentRefresh,
      sessionManager: sessionManager,
    ));
  }
}
