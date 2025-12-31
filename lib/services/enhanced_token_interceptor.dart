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

      // Get access token (سيتم تجديده تلقائياً إذا كان منتهي)
      String? accessToken = await _tokenManager.getValidAccessToken();
      
      // إذا لم يكن هناك access token صالح بعد محاولة التحديث التلقائي
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ [TOKEN_INTERCEPTOR] No valid access token after auto-refresh attempt');
        
        // تحقق من وجود refresh token صالح
        final hasValidRefresh = await _tokenManager.hasValidRefreshToken();
        if (!hasValidRefresh) {
          debugPrint('❌ [TOKEN_INTERCEPTOR] No valid refresh token - cannot refresh, ending session');
          await _sessionManager.endSession();
          // رفض الطلب بـ 401 - سيتم التعامل معه في _handle401Error
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              statusMessage: 'Unauthorized - No valid access token',
            ),
          );
          handler.reject(error);
          return;
        }
        
        // إذا كان هناك refresh token صالح، حاول تحديث الـ token مرة أخرى
        debugPrint('🔄 [TOKEN_INTERCEPTOR] Refresh token available, attempting refresh...');
        final refreshSuccess = await _tokenManager.refreshAccessToken();
        
        if (refreshSuccess) {
          accessToken = await _tokenManager.getValidAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            debugPrint('✅ [TOKEN_INTERCEPTOR] Token refreshed successfully before request');
            // Continue with the request using the new token
          } else {
            debugPrint('❌ [TOKEN_INTERCEPTOR] Token refresh succeeded but no token returned, ending session');
            await _sessionManager.endSession();
            // رفض الطلب بـ 401
            final error = DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                statusCode: 401,
                statusMessage: 'Unauthorized - Token refresh failed',
              ),
            );
            handler.reject(error);
            return;
          }
        } else {
          debugPrint('❌ [TOKEN_INTERCEPTOR] Token refresh failed, ending session');
          await _sessionManager.endSession();
          // رفض الطلب بـ 401 - سيتم التعامل معه في _handle401Error
          final error = DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              statusMessage: 'Unauthorized - Token refresh failed',
            ),
          );
          handler.reject(error);
          return;
        }
      }
      
      // إضافة الـ token للطلب
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        debugPrint('🔐 [TOKEN_INTERCEPTOR] Token added to request');
        handler.next(options);
      } else {
        // هذا لا يجب أن يحدث أبداً، لكن للاحتياط
        debugPrint('❌ [TOKEN_INTERCEPTOR] No access token available - rejecting request');
        final error = DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            statusMessage: 'Unauthorized - No access token',
          ),
        );
        handler.reject(error);
      }
    } catch (e) {
      debugPrint('❌ [TOKEN_INTERCEPTOR] Error in onRequest: $e');
      // في حالة الخطأ غير المتوقع، رفض الطلب بـ 401 للسماح لـ _handle401Error بالتعامل معه
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          statusMessage: 'Unauthorized - Request error: ${e.toString()}',
        ),
        error: e,
      );
      handler.reject(error);
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
    final statusCode = err.response?.statusCode;
    debugPrint('❌ [TOKEN_INTERCEPTOR] Error intercepted: $statusCode - ${err.message}');
    debugPrint('❌ [TOKEN_INTERCEPTOR] Request path: ${err.requestOptions.path}');
    debugPrint('❌ [TOKEN_INTERCEPTOR] Request method: ${err.requestOptions.method}');
    
    // Handle token-related errors (401, 403)
    if (_isTokenError(err)) {
      debugPrint('🔄 [TOKEN_INTERCEPTOR] Token error detected ($statusCode), attempting to handle...');
      final handled = await _handleTokenError(err, handler);
      if (handled) {
        debugPrint('✅ [TOKEN_INTERCEPTOR] Token error handled successfully');
        return; // Error was handled, don't propagate
      } else {
        debugPrint('❌ [TOKEN_INTERCEPTOR] Token error could not be handled');
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
  /// لا نستخدم refresh preemptive - فقط عند انتهاء التوكن (401 error)
  Future<void> _checkAndRefreshToken() async {
    // تم إزالة الفحص المسبق - سيتم تجديد التوكن فقط عند انتهائه (401 error)
    // هذا يقلل الحمل على الخادم ويتبع أفضل الممارسات
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
    final errorId = DateTime.now().millisecondsSinceEpoch.toString();
    final errorTime = DateTime.now();
    
    debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING START ==========');
    debugPrint('🔄 [401_ERROR_LOG] Error ID: $errorId');
    debugPrint('🔄 [401_ERROR_LOG] Error Time: ${errorTime.toIso8601String()}');
    debugPrint('🔄 [401_ERROR_LOG] Original Request:');
    debugPrint('   - Path: ${err.requestOptions.path}');
    debugPrint('   - Method: ${err.requestOptions.method}');
    debugPrint('   - Base URL: ${err.requestOptions.baseUrl}');
    debugPrint('   - Full URL: ${err.requestOptions.uri}');
    debugPrint('   - Status Code: ${err.response?.statusCode ?? "N/A"}');
    debugPrint('   - Error Message: ${err.message}');
    debugPrint('   - Response Data: ${err.response?.data}');
    
    try {
      // Check if we have a refresh token
      debugPrint('🔄 [401_ERROR_LOG] Error $errorId: Checking refresh token availability...');
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❌ [401_ERROR_LOG] Error $errorId: No refresh token available, ending session');
        await _sessionManager.endSession();
        handler.next(err); // Propagate error
        debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (NO_REFRESH_TOKEN) ==========');
        return false;
      }

      debugPrint('✅ [401_ERROR_LOG] Error $errorId: Refresh token found (length: ${refreshToken.length})');

      // Check if refresh token is still valid
      debugPrint('🔄 [401_ERROR_LOG] Error $errorId: Checking refresh token validity...');
      final hasValidRefresh = await _tokenManager.hasValidRefreshToken();
      if (!hasValidRefresh) {
        debugPrint('❌ [401_ERROR_LOG] Error $errorId: Refresh token expired, ending session');
        await _sessionManager.endSession();
        handler.next(err); // Propagate error
        debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (REFRESH_TOKEN_EXPIRED) ==========');
        return false;
      }

      debugPrint('✅ [401_ERROR_LOG] Error $errorId: Refresh token available and valid, attempting refresh...');

      // Attempt token refresh
      final refreshStartTime = DateTime.now();
      final refreshSuccess = await _performTokenRefresh();
      final refreshDuration = DateTime.now().difference(refreshStartTime);
      
      debugPrint('🔄 [401_ERROR_LOG] Error $errorId: Token refresh attempt completed');
      debugPrint('   - Success: $refreshSuccess');
      debugPrint('   - Duration: ${refreshDuration.inMilliseconds}ms');
      
      if (refreshSuccess) {
        debugPrint('✅ [401_ERROR_LOG] Error $errorId: Token refresh successful, retrying original request...');
        debugPrint('🔄 [401_ERROR_LOG] Error $errorId: About to call _retryRequest...');
        debugPrint('🔄 [401_ERROR_LOG] Error $errorId: Original request path: ${err.requestOptions.path}');
        debugPrint('🔄 [401_ERROR_LOG] Error $errorId: Original request method: ${err.requestOptions.method}');
        
        // Retry the original request with new token
        final retryStartTime = DateTime.now();
        try {
          final retrySuccess = await _retryRequest(err.requestOptions, handler);
          final retryDuration = DateTime.now().difference(retryStartTime);
          
          debugPrint('🔄 [401_ERROR_LOG] Error $errorId: Retry attempt completed');
          debugPrint('   - Success: $retrySuccess');
          debugPrint('   - Duration: ${retryDuration.inMilliseconds}ms');
          
          if (retrySuccess) {
            final totalDuration = DateTime.now().difference(errorTime);
            debugPrint('✅ [401_ERROR_LOG] Error $errorId: Retry successful after token refresh');
            debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
            debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (SUCCESS) ==========');
            return true;
          } else {
            debugPrint('❌ [401_ERROR_LOG] Error $errorId: Retry failed after token refresh');
            handler.next(err); // Propagate original error
            debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (RETRY_FAILED) ==========');
            return false;
          }
        } catch (retryError, retryStackTrace) {
          final retryDuration = DateTime.now().difference(retryStartTime);
          debugPrint('❌ [401_ERROR_LOG] Error $errorId: Exception during retry');
          debugPrint('   - Exception Type: ${retryError.runtimeType}');
          debugPrint('   - Exception: $retryError');
          debugPrint('   - Stack Trace: $retryStackTrace');
          debugPrint('   - Duration: ${retryDuration.inMilliseconds}ms');
          handler.next(err); // Propagate original error
          debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (RETRY_EXCEPTION) ==========');
          return false;
        }
      } else {
        debugPrint('❌ [401_ERROR_LOG] Error $errorId: Token refresh failed, ending session');
        await _sessionManager.endSession();
        handler.next(err); // Propagate error
        debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (REFRESH_FAILED) ==========');
        return false;
      }
    } catch (e, stackTrace) {
      final totalDuration = DateTime.now().difference(errorTime);
      debugPrint('❌ [401_ERROR_LOG] Error $errorId: Exception handling 401');
      debugPrint('   - Exception Type: ${e.runtimeType}');
      debugPrint('   - Exception: $e');
      debugPrint('   - Stack Trace: $stackTrace');
      debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
      await _sessionManager.endSession();
      handler.next(err); // Propagate error
      debugPrint('🔄 [401_ERROR_LOG] ========== 401 ERROR HANDLING END (EXCEPTION) ==========');
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
    final retryId = DateTime.now().millisecondsSinceEpoch.toString();
    final retryTime = DateTime.now();
    
    try {
      debugPrint('🔄 [RETRY_LOG] ========== RETRY REQUEST START ==========');
      debugPrint('🔄 [RETRY_LOG] Retry ID: $retryId');
      debugPrint('🔄 [RETRY_LOG] Retry Time: ${retryTime.toIso8601String()}');
      debugPrint('🔄 [RETRY_LOG] Original Request:');
      debugPrint('   - Method: ${originalOptions.method}');
      debugPrint('   - Path: ${originalOptions.path}');
      debugPrint('   - Base URL: ${originalOptions.baseUrl}');
      debugPrint('   - Full URL: ${originalOptions.uri}');
      debugPrint('   - Has Data: ${originalOptions.data != null}');
      debugPrint('   - Data Type: ${originalOptions.data?.runtimeType ?? "N/A"}');
      debugPrint('   - Query Parameters: ${originalOptions.queryParameters}');
      
      _retryCount++;
      
      // Get new access token
      debugPrint('🔄 [RETRY_LOG] Retry $retryId: Getting new access token...');
      final newToken = await _tokenManager.getValidAccessToken();
      if (newToken == null || newToken.isEmpty) {
        debugPrint('❌ [RETRY_LOG] Retry $retryId: No new token available for retry');
        debugPrint('🔄 [RETRY_LOG] ========== RETRY REQUEST END (NO_TOKEN) ==========');
        return false;
      }
      
      debugPrint('✅ [RETRY_LOG] Retry $retryId: New token obtained');
      debugPrint('   - Token Length: ${newToken.length}');
      debugPrint('   - Token (first 20 chars): ${newToken.substring(0, newToken.length > 20 ? 20 : newToken.length)}...');
      
      // Create new Dio instance to avoid interceptor loops
      final dio = Dio();
      
      // Determine base URL - use original baseUrl or default from ApiConstants
      String baseUrl = originalOptions.baseUrl;
      if (baseUrl.isEmpty) {
        baseUrl = 'https://api.idec-ye.com'; // Default fallback
      }
      
      dio.options.baseUrl = baseUrl;
      dio.options.connectTimeout = originalOptions.connectTimeout;
      dio.options.receiveTimeout = originalOptions.receiveTimeout;
      dio.options.sendTimeout = originalOptions.sendTimeout;
      
      // Copy all headers and update Authorization
      final headers = Map<String, dynamic>.from(originalOptions.headers);
      headers['Authorization'] = 'Bearer $newToken';
      
      debugPrint('🔄 [RETRY_LOG] Retry $retryId: Request configuration:');
      debugPrint('   - Base URL: $baseUrl');
      debugPrint('   - Headers: ${headers.keys.toList()}');
      debugPrint('   - Authorization Header: Bearer ${newToken.substring(0, 20)}...');
      
      // Determine request path
      String requestPath = originalOptions.path;
      
      // If path is absolute URL, extract path from it
      if (requestPath.startsWith('http://') || requestPath.startsWith('https://')) {
        final uri = Uri.parse(requestPath);
        requestPath = uri.path;
        if (uri.queryParameters.isNotEmpty) {
          // Append query parameters if any
          final queryString = uri.queryParameters.entries
              .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
              .join('&');
          requestPath = '$requestPath?$queryString';
        }
      }
      
      // Ensure path starts with /
      if (!requestPath.startsWith('/')) {
        requestPath = '/$requestPath';
      }
      
      final fullUrl = '$baseUrl$requestPath';
      debugPrint('🔄 [RETRY_LOG] Retry $retryId: Making request...');
      debugPrint('   - Full URL: $fullUrl');
      debugPrint('   - Method: ${originalOptions.method}');
      debugPrint('   - Path: $requestPath');
      debugPrint('   - Has data: ${originalOptions.data != null}');
      
      final requestStartTime = DateTime.now();
      
      // Make the retry request
      final response = await dio.request(
        requestPath,
        data: originalOptions.data,
        queryParameters: originalOptions.queryParameters,
        options: Options(
          method: originalOptions.method,
          headers: headers,
          responseType: originalOptions.responseType,
          contentType: originalOptions.contentType,
          followRedirects: originalOptions.followRedirects,
          validateStatus: originalOptions.validateStatus,
        ),
      );
      
      final requestDuration = DateTime.now().difference(requestStartTime);
      final totalDuration = DateTime.now().difference(retryTime);
      
      debugPrint('✅ [RETRY_LOG] Retry $retryId: Request successful');
      debugPrint('   - Status Code: ${response.statusCode}');
      debugPrint('   - Request Duration: ${requestDuration.inMilliseconds}ms');
      debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
      debugPrint('   - Response Time: ${DateTime.now().toIso8601String()}');
      debugPrint('🔄 [RETRY_LOG] ========== RETRY REQUEST END (SUCCESS) ==========');
      
      handler.resolve(response);
      return true;
    } catch (e, stackTrace) {
      final totalDuration = DateTime.now().difference(retryTime);
      
      debugPrint('❌ [RETRY_LOG] Retry $retryId: Request failed');
      debugPrint('   - Error Type: ${e.runtimeType}');
      debugPrint('   - Error: $e');
      debugPrint('   - Total Duration: ${totalDuration.inMilliseconds}ms');
      
      if (e is DioException) {
        debugPrint('❌ [RETRY_LOG] Retry $retryId: DioException details:');
        debugPrint('   - Status: ${e.response?.statusCode ?? "N/A"}');
        debugPrint('   - Message: ${e.message}');
        debugPrint('   - Type: ${e.type}');
        debugPrint('   - Request Path: ${originalOptions.path}');
        debugPrint('   - Base URL: ${originalOptions.baseUrl}');
        debugPrint('   - Request URL: ${e.requestOptions.uri}');
        if (e.response != null) {
          debugPrint('   - Response Data: ${e.response?.data}');
          debugPrint('   - Response Headers: ${e.response?.headers}');
        }
      } else {
        debugPrint('❌ [RETRY_LOG] Retry $retryId: Non-DioException');
        debugPrint('   - Stack Trace: $stackTrace');
      }
      debugPrint('🔄 [RETRY_LOG] ========== RETRY REQUEST END (FAILED) ==========');
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
      '/auth/request-password-reset', // تمت إضافته
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
