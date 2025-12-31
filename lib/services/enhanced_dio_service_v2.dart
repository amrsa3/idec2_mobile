import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/api_constants.dart';
import '../core/errors/app_error.dart';
import 'unified_token_manager.dart';
import 'enhanced_session_manager.dart';
import 'silent_token_refresh_service.dart';
import 'enhanced_token_interceptor.dart';
import 'platform_storage_service.dart';
import 'retry_service.dart';

/// Enhanced Dio Service V2 with complete integration of new token and session management
/// Supports all platforms (Android, iOS, Web) with unified architecture
class EnhancedDioServiceV2 {
  static EnhancedDioServiceV2? _instance;
  static EnhancedDioServiceV2 get instance =>
      _instance ??= EnhancedDioServiceV2._internal();

  late Dio _dio;
  late EnhancedTokenInterceptor _tokenInterceptor;

  final UnifiedTokenManager _tokenManager = UnifiedTokenManager.instance;
  final EnhancedSessionManager _sessionManager =
      EnhancedSessionManager.instance;
  final SilentTokenRefreshService _silentRefresh =
      SilentTokenRefreshService.instance;
  final PlatformStorageService _storage = PlatformStorageService.instance;

  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitialized = false;

  // Service statistics
  int _totalRequests = 0;
  int _successfulRequests = 0;
  int _failedRequests = 0;
  DateTime? _lastRequestTime;

  EnhancedDioServiceV2._internal() {
    // Create Dio instance synchronously first (without interceptors)
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 300),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Then initialize async parts (interceptors, dependencies)
    _initializeDio();
  }

  /// Get the Dio instance
  Dio get dio {
    return _dio;
  }
  
  /// Ensure service is initialized before use
  Future<void> ensureInitialized() async {
    await _ensureInitialized();
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    await _initCompleter.future;
  }

  /// Get service statistics
  Map<String, dynamic> get statistics => {
        'totalRequests': _totalRequests,
        'successfulRequests': _successfulRequests,
        'failedRequests': _failedRequests,
        'successRate': _totalRequests > 0
            ? (_successfulRequests / _totalRequests * 100).toStringAsFixed(2)
            : '0.00',
        'lastRequestTime': _lastRequestTime?.toIso8601String(),
        'interceptorStats': _tokenInterceptor.getStatistics(),
      };

  /// Initialize Dio with enhanced configuration (interceptors and dependencies)
  Future<void> _initializeDio() async {
    try {
      debugPrint('🚀 [ENHANCED_DIO_V2] Initializing service...');

      // Initialize token interceptor
      _tokenInterceptor = EnhancedTokenInterceptor(
        tokenManager: _tokenManager,
        silentRefresh: _silentRefresh,
        sessionManager: _sessionManager,
      );

      // Add interceptors in order
      _setupInterceptors();

      // Initialize dependencies
      await _initializeDependencies();

      _isInitialized = true;
      _initCompleter.complete();

      debugPrint('✅ [ENHANCED_DIO_V2] Service initialized successfully');
      debugPrint('🔗 [ENHANCED_DIO_V2] Base URL: ${_dio.options.baseUrl}');

      // Validate HTTPS for production
      if (ApiConstants.baseUrl.contains('api.idec-ye.com') &&
          !ApiConstants.baseUrl.startsWith('https://')) {
        debugPrint(
            '⚠️ [ENHANCED_DIO_V2] WARNING: Production API should use HTTPS');
      }
    } catch (e) {
      debugPrint('❌ [ENHANCED_DIO_V2] Initialization failed: $e');
      _initCompleter.completeError(e);
      rethrow;
    }
  }

  /// Setup all interceptors
  void _setupInterceptors() {
    // 1. Request/Response logging interceptor (first)
    _dio.interceptors.add(_createLoggingInterceptor());

    // 2. Request statistics interceptor
    _dio.interceptors.add(_createStatisticsInterceptor());

    // 3. Language and headers interceptor
    _dio.interceptors.add(_createHeadersInterceptor());

    // 4. Enhanced token interceptor (handles auth)
    _dio.interceptors.add(_tokenInterceptor);

    // 5. Network error handling interceptor
    _dio.interceptors.add(_createNetworkInterceptor());

    // 6. Maintenance mode interceptor
    _dio.interceptors.add(_createMaintenanceInterceptor());
  }

  /// Create logging interceptor
  Interceptor _createLoggingInterceptor() {
    return LogInterceptor(
      requestBody: false, // Disabled to reduce noise and hide sensitive data (OTP)
      responseBody: false, // Disabled to reduce noise
      requestHeader: false,
      responseHeader: false,
      error: true, // Keep errors only
      logPrint: (object) {
        if (kDebugMode) {
          debugPrint('📡 [DIO_LOG] $object');
        }
      },
    );
  }

  /// Create statistics interceptor
  Interceptor _createStatisticsInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _totalRequests++;
        _lastRequestTime = DateTime.now();
        handler.next(options);
      },
      onResponse: (response, handler) {
        _successfulRequests++;
        handler.next(response);
      },
      onError: (error, handler) {
        _failedRequests++;
        handler.next(error);
      },
    );
  }

  /// Create headers interceptor
  Interceptor _createHeadersInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Add language header
          final language = await _storage.read('selected_language') ?? 'ar';
          options.headers['Accept-Language'] = language;

          // Add platform information
          options.headers['X-Platform'] =
              kIsWeb ? 'web' : Platform.operatingSystem;
          options.headers['X-App-Version'] = '2.4.0'; // Could be dynamic

          // Add session ID if available
          final sessionId = _sessionManager.currentSessionId;
          if (sessionId != null) {
            options.headers['X-Session-ID'] = sessionId;
          }

          debugPrint('📋 [ENHANCED_DIO_V2] Headers added for ${options.path}');
        } catch (e) {
          debugPrint('⚠️ [ENHANCED_DIO_V2] Error adding headers: $e');
        }

        handler.next(options);
      },
    );
  }

  /// Create network error interceptor
  Interceptor _createNetworkInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_isNetworkError(error)) {
          final connectivityResult = await Connectivity().checkConnectivity();

          if (connectivityResult == ConnectivityResult.none) {
            final networkError = DioException(
              requestOptions: error.requestOptions,
              error: const NetworkError(
                message: 'لا يوجد اتصال بالإنترنت',
                code: 'NO_CONNECTION',
                isConnectionError: true,
              ),
              type: DioExceptionType.connectionError,
            );

            debugPrint(
                '🌐 [ENHANCED_DIO_V2] Network error detected: No connection');
            handler.next(networkError);
            return;
          }

          // Handle timeout errors
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            final timeoutError = DioException(
              requestOptions: error.requestOptions,
              error: const NetworkError(
                message: 'انتهت مهلة الاتصال',
                code: 'TIMEOUT',
                isConnectionError: false,
              ),
              type: error.type,
            );

            debugPrint('⏱️ [ENHANCED_DIO_V2] Timeout error detected');
            handler.next(timeoutError);
            return;
          }
        }

        handler.next(error);
      },
    );
  }

  /// Create maintenance mode interceptor
  Interceptor _createMaintenanceInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 503) {
          final data = error.response?.data;

          if (data is Map<String, dynamic> && data['maintenance'] == true) {
            final maintenanceError = DioException(
              requestOptions: error.requestOptions,
              error: MaintenanceError.scheduled(
                message: data['message'] ?? 'الخادم تحت الصيانة',
                endTime: data['estimated_end'] != null
                    ? DateTime.tryParse(data['estimated_end'])
                    : null,
              ),
              response: error.response,
            );

            debugPrint('🚧 [ENHANCED_DIO_V2] Maintenance mode detected');
            handler.next(maintenanceError);
            return;
          }
        }

        handler.next(error);
      },
    );
  }

  /// Initialize service dependencies
  Future<void> _initializeDependencies() async {
    try {
      // Initialize token manager
      await _tokenManager.initialize();

      // Initialize session manager
      await _sessionManager.initialize();

      // Silent refresh service معطل - نستخدم فقط interceptor عند 401 error
      // await _silentRefresh.initialize();

      debugPrint('✅ [ENHANCED_DIO_V2] Dependencies initialized');
    } catch (e) {
      debugPrint('❌ [ENHANCED_DIO_V2] Dependencies initialization failed: $e');
      rethrow;
    }
  }

  /// Ensure service is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeDio();
    }
    await _initCompleter.future;
  }

  /// Make a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _ensureInitialized();

    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Make a POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _ensureInitialized();

    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Make a PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _ensureInitialized();

    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Make a DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _ensureInitialized();

    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Make a request with automatic retry logic
  Future<Response<T>> requestWithRetry<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    RetryConfig? retryConfig,
  }) async {
    await _ensureInitialized();

    final config = retryConfig ?? RetryConfig.api;

    return RetryService.instance.executeWithRetry(
      () async {
        switch (method.toUpperCase()) {
          case 'GET':
            return await get<T>(path,
                queryParameters: queryParameters, options: options);
          case 'POST':
            return await post<T>(path,
                data: data, queryParameters: queryParameters, options: options);
          case 'PUT':
            return await put<T>(path,
                data: data, queryParameters: queryParameters, options: options);
          case 'DELETE':
            return await delete<T>(path,
                data: data, queryParameters: queryParameters, options: options);
          default:
            throw ArgumentError('Unsupported HTTP method: $method');
        }
      },
      maxRetries: config.maxRetries,
      initialDelay: config.initialDelay,
      backoffMultiplier: config.backoffMultiplier,
      exponentialBackoff: config.exponentialBackoff,
      shouldRetry: config.shouldRetry,
    );
  }

  /// Update base URL (useful for server settings changes)
  Future<void> updateBaseUrl(String newBaseUrl) async {
    try {
      debugPrint(
          '🔄 [ENHANCED_DIO_V2] Updating base URL from ${_dio.options.baseUrl} to $newBaseUrl');

      // Validate new URL
      if (newBaseUrl.isEmpty || !newBaseUrl.contains('http')) {
        throw ArgumentError('Invalid base URL: $newBaseUrl');
      }

      // Warn about HTTPS for production
      if (newBaseUrl.contains('api.idec-ye.com') &&
          !newBaseUrl.startsWith('https://')) {
        debugPrint(
            '⚠️ [ENHANCED_DIO_V2] WARNING: Production API should use HTTPS');
      }

      _dio.options.baseUrl = newBaseUrl;

      debugPrint('✅ [ENHANCED_DIO_V2] Base URL updated successfully');
    } catch (e) {
      debugPrint('❌ [ENHANCED_DIO_V2] Failed to update base URL: $e');
      rethrow;
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _tokenManager.getValidAccessToken();
    } catch (e) {
      debugPrint('🔴 [ENHANCED_DIO_V2] Error getting access token: $e');
      return null;
    }
  }

  /// Get current refresh token
  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return await _tokenManager.getRefreshToken();
  }

  /// Set tokens
  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _ensureInitialized();
    await _tokenManager.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn:
          2592000, // 30 days (30 * 24 * 60 * 60 = 2592000 seconds) - تغيير من ساعة إلى 30 يوم
    );
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await _ensureInitialized();
    await _tokenManager.clearTokens();
  }

  /// Check if network error
  bool _isNetworkError(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.error is SocketException);
  }

  /// Reset service statistics
  void resetStatistics() {
    _totalRequests = 0;
    _successfulRequests = 0;
    _failedRequests = 0;
    _lastRequestTime = null;
    _tokenInterceptor.resetStatistics();

    debugPrint('📊 [ENHANCED_DIO_V2] Statistics reset');
  }

  /// Dispose service resources
  Future<void> dispose() async {
    try {
      debugPrint('🗑️ [ENHANCED_DIO_V2] Disposing service...');

      // Close Dio
      _dio.close();

      // Dispose dependencies
      _silentRefresh.dispose();
      _sessionManager.dispose();

      _isInitialized = false;

      debugPrint('✅ [ENHANCED_DIO_V2] Service disposed successfully');
    } catch (e) {
      debugPrint('❌ [ENHANCED_DIO_V2] Error disposing service: $e');
    }
  }
}

/// Extension for backward compatibility with existing DioService usage
extension EnhancedDioServiceV2Extension on EnhancedDioServiceV2 {
  /// Refresh after server settings change (backward compatibility)
  Future<void> refreshAfterServerChange() async {
    await updateBaseUrl(ApiConstants.baseUrl);
  }
}
