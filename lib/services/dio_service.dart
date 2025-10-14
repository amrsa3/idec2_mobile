import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/api_constants.dart';
import '../core/errors/app_error.dart';
import 'retry_service.dart';
import 'session_manager.dart';
import 'web_compatible_storage.dart';

class DioService {
  static DioService? _instance;
  static DioService get instance => _instance ??= DioService._internal();

  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioService._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);

    // Production-specific baseURL logging
    if (!kDebugMode) {
      debugPrint(
          '🏭 [DIO_PRODUCTION] Setting up interceptors with baseUrl: ${_dio.options.baseUrl}');
      debugPrint(
          '🏭 [DIO_PRODUCTION] Port check: ${_dio.options.baseUrl.contains(":3000")}');
    }

    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Production-specific request logging
          if (!kDebugMode) {
            debugPrint('🏭 [DIO_PRODUCTION] Making request to: ${options.uri}');
            debugPrint(
                '🏭 [DIO_PRODUCTION] Full URL: ${options.uri.toString()}');
            debugPrint('🏭 [DIO_PRODUCTION] Host: ${options.uri.host}');
            debugPrint('🏭 [DIO_PRODUCTION] Port: ${options.uri.port}');
            debugPrint('🏭 [DIO_PRODUCTION] Path: ${options.path}');
          }

          // Add authorization header
          final token = await getAccessToken();
          debugPrint('🔑 [DIO_DEBUG] Request to: ${options.path}');
          debugPrint(
              '🔑 [DIO_DEBUG] Token status: ${token != null && token.isNotEmpty ? "found (${token.length} chars)" : "not found"}');
          if (token != null && token.isNotEmpty) {
            debugPrint(
                '🔑 [DIO_DEBUG] Token first 20 chars: ${token.length > 20 ? token.substring(0, 20) + "..." : token}');
            options.headers['Authorization'] = 'Bearer $token';
            debugPrint(
                '🔑 [DIO_DEBUG] Authorization header set: Bearer ${token.length > 20 ? token.substring(0, 20) + "..." : token}');
          } else {
            debugPrint('🔑 [DIO_DEBUG] No token available for request');
          }

          // Add content type
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';

          // Add language header
          final language =
              await WebCompatibleStorage.instance.read('selected_language') ??
                  'ar';
          options.headers['Accept-Language'] = language;

          // debugPrint('🔑 [DIO_DEBUG] Request headers: ${options.headers}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // debugPrint('✅ [DIO_DEBUG] Response ${response.statusCode} for: ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) async {
          // debugPrint('❌ [DIO_DEBUG] Error ${error.response?.statusCode} for: ${error.requestOptions.path}');
          // debugPrint('❌ [DIO_DEBUG] Error message: ${error.message}');
          // debugPrint('❌ [DIO_DEBUG] Error response data: ${error.response?.data}');

          // Handle token refresh
          if (error.response?.statusCode == 401) {
            debugPrint(
                '🔑 DioService: Received 401 Unauthorized, attempting token refresh');
            final refreshToken = await getRefreshToken();
            if (refreshToken != null) {
              try {
                final newTokens = await _refreshToken(refreshToken);
                if (newTokens != null) {
                  debugPrint(
                      '✅ DioService: Token refresh successful, retrying request');
                  // Retry the original request
                  final options = error.requestOptions;
                  options.headers['Authorization'] =
                      'Bearer ${newTokens['access_token']}';
                  final response = await _dio.fetch(options);
                  handler.resolve(response);
                  return;
                } else {
                  debugPrint(
                      '❌ DioService: Token refresh failed, clearing tokens');
                  await _clearTokens();
                  // Add small delay before notifying session expiration
                  await Future.delayed(const Duration(milliseconds: 50));
                  // Notify session manager about session expiration
                  SessionManager.instance.notifySessionExpired(
                    reason: 'فشل في تحديث رمز المصادقة',
                    shouldRedirectToLogin: true,
                  );
                }
              } catch (e) {
                debugPrint('❌ DioService: Token refresh exception: $e');
                // Refresh failed, logout user
                await _clearTokens();
                // Add small delay before notifying session expiration
                await Future.delayed(const Duration(milliseconds: 50));
                // Notify session manager about session expiration
                SessionManager.instance.notifySessionExpired(
                  reason: 'انتهت صلاحية جلسة العمل',
                  shouldRedirectToLogin: true,
                );
              }
            } else {
              debugPrint('❌ DioService: No refresh token available');
              await _clearTokens();
              // Add small delay before notifying session expiration
              await Future.delayed(const Duration(milliseconds: 50));
              // Notify session manager about session expiration
              SessionManager.instance.notifySessionExpired(
                reason: 'لا يوجد رمز تحديث صالح',
                shouldRedirectToLogin: true,
              );
            }
          }

          // Handle network errors with enhanced error information
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            final connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.none) {
              error = DioException(
                requestOptions: error.requestOptions,
                error: NetworkError(
                  message: 'No internet connection',
                  code: 'NO_CONNECTION',
                  isConnectionError: true,
                ),
                type: DioExceptionType.connectionError,
              );
            }
          }

          // Handle maintenance mode
          if (error.response?.statusCode == 503) {
            final data = error.response?.data;
            if (data is Map<String, dynamic> && data['maintenance'] == true) {
              error = DioException(
                requestOptions: error.requestOptions,
                error: MaintenanceError.scheduled(
                  message: data['message'] ?? 'Server is under maintenance',
                  endTime: data['estimated_end'] != null
                      ? DateTime.tryParse(data['estimated_end'])
                      : null,
                ),
                response: error.response,
              );
            }
          }

          handler.next(error);
        },
      ),
    );

    // Logging interceptor (only in debug mode)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (object) {
          // Only log in debug mode
          assert(() {
            print(object);
            return true;
          }());
        },
      ),
    );
  }

  Future<Map<String, String>?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // Remove auth header for refresh
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Use WebCompatibleStorage for both web and mobile
        if (kIsWeb) {
          await WebCompatibleStorage.instance
              .write('access_token', data['access_token']);
          await WebCompatibleStorage.instance
              .write('refresh_token', data['refresh_token']);
        } else {
          await _storage.write(
              key: 'access_token', value: data['access_token']);
          await _storage.write(
              key: 'refresh_token', value: data['refresh_token']);
        }

        return {
          'access_token': data['access_token'],
          'refresh_token': data['refresh_token'],
        };
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return null;
  }

  Future<void> _clearTokens() async {
    try {
      debugPrint('🔍 [DIO_DEBUG] _clearTokens - starting clear');

      if (kIsWeb) {
        debugPrint(
            '🔍 [DIO_DEBUG] _clearTokens - using WebCompatibleStorage for web');
        await WebCompatibleStorage.instance.delete('access_token');
        await WebCompatibleStorage.instance.delete('refresh_token');
        await WebCompatibleStorage.instance.delete('user_data');
      } else {
        debugPrint(
            '🔍 [DIO_DEBUG] _clearTokens - using FlutterSecureStorage for mobile');
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        await _storage.delete(key: 'user_data');
      }

      debugPrint('🔍 [DIO_DEBUG] _clearTokens - tokens cleared successfully');
    } catch (e) {
      debugPrint('🔍 [DIO_DEBUG] _clearTokens - error: $e');
      // Don't rethrow to avoid breaking the flow
    }
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    try {
      debugPrint('🔍 [DIO_DEBUG] setTokens - starting save');

      if (kIsWeb) {
        debugPrint(
            '🔍 [DIO_DEBUG] setTokens - using WebCompatibleStorage for web');
        await WebCompatibleStorage.instance.write('access_token', accessToken);
        await WebCompatibleStorage.instance
            .write('refresh_token', refreshToken);
      } else {
        debugPrint(
            '🔍 [DIO_DEBUG] setTokens - using FlutterSecureStorage for mobile');
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
      }

      debugPrint('🔍 [DIO_DEBUG] setTokens - tokens saved successfully');
    } catch (e) {
      debugPrint('🔍 [DIO_DEBUG] setTokens - error: $e');
      // Don't rethrow to avoid breaking the flow
    }
  }

  Future<void> clearTokens() async {
    await _clearTokens();
  }

  Future<String?> getAccessToken() async {
    try {
      debugPrint('🔍 [DIO_DEBUG] getAccessToken - starting retrieval');

      String? token;
      if (kIsWeb) {
        debugPrint(
            '🔍 [DIO_DEBUG] getAccessToken - using WebCompatibleStorage for web');
        token = await WebCompatibleStorage.instance.read('access_token');
      } else {
        debugPrint(
            '🔍 [DIO_DEBUG] getAccessToken - using FlutterSecureStorage for mobile');
        token = await _storage.read(key: 'access_token');
      }

      debugPrint(
          '🔍 [DIO_DEBUG] getAccessToken - token ${token != null && token.isNotEmpty ? "found" : "not found"}');
      return token;
    } catch (e) {
      debugPrint('🔍 [DIO_DEBUG] getAccessToken - error: $e');
      return null;
    }
  }

  /// Refresh DioService after server settings change
  void refreshAfterServerChange() {
    try {
      final oldBaseUrl = _dio.options.baseUrl;
      final newBaseUrl = ApiConstants.baseUrl;

      debugPrint('🔄 [DIO_SERVICE] Refreshing after server change');
      debugPrint('🔄 [DIO_SERVICE] Old base URL: $oldBaseUrl');
      debugPrint('🔄 [DIO_SERVICE] New base URL: $newBaseUrl');

      // Validate new URL
      if (newBaseUrl.isEmpty || !newBaseUrl.contains('http')) {
        debugPrint('❌ [DIO_SERVICE] Invalid new base URL: $newBaseUrl');
        return;
      }

      // Ensure port is included
      if (!newBaseUrl.contains(':3000')) {
        debugPrint('⚠️ [DIO_SERVICE] Port missing in new URL: $newBaseUrl');
      }

      // Update base URL
      _dio.options.baseUrl = newBaseUrl;

      debugPrint('✅ [DIO_SERVICE] Base URL updated successfully');
      debugPrint(
          '🔗 [DIO_SERVICE] Current Dio base URL: ${_dio.options.baseUrl}');

      // Validate the update
      if (_dio.options.baseUrl == newBaseUrl) {
        debugPrint('✅ [DIO_SERVICE] Base URL validation passed');
      } else {
        debugPrint('❌ [DIO_SERVICE] Base URL validation failed');
        debugPrint('❌ [DIO_SERVICE] Expected: $newBaseUrl');
        debugPrint('❌ [DIO_SERVICE] Actual: ${_dio.options.baseUrl}');
      }
    } catch (e) {
      debugPrint('❌ [DIO_SERVICE] Error refreshing after server change: $e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      debugPrint('🔍 [DIO_DEBUG] getRefreshToken - starting retrieval');

      String? token;
      if (kIsWeb) {
        debugPrint(
            '🔍 [DIO_DEBUG] getRefreshToken - using WebCompatibleStorage for web');
        token = await WebCompatibleStorage.instance.read('refresh_token');
      } else {
        debugPrint(
            '🔍 [DIO_DEBUG] getRefreshToken - using FlutterSecureStorage for mobile');
        token = await _storage.read(key: 'refresh_token');
      }

      debugPrint(
          '🔍 [DIO_DEBUG] getRefreshToken - token ${token != null && token.isNotEmpty ? "found" : "not found"}');
      return token;
    } catch (e) {
      debugPrint('🔍 [DIO_DEBUG] getRefreshToken - error: $e');
      return null;
    }
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
    return RetryService.instance.executeWithRetry(
      () async {
        switch (method.toUpperCase()) {
          case 'GET':
            return await _dio.get<T>(
              path,
              queryParameters: queryParameters,
              options: options,
            );
          case 'POST':
            return await _dio.post<T>(
              path,
              data: data,
              queryParameters: queryParameters,
              options: options,
            );
          case 'PUT':
            return await _dio.put<T>(
              path,
              data: data,
              queryParameters: queryParameters,
              options: options,
            );
          case 'DELETE':
            return await _dio.delete<T>(
              path,
              data: data,
              queryParameters: queryParameters,
              options: options,
            );
          case 'PATCH':
            return await _dio.patch<T>(
              path,
              data: data,
              queryParameters: queryParameters,
              options: options,
            );
          default:
            throw ArgumentError('Unsupported HTTP method: $method');
        }
      },
      maxRetries: retryConfig?.maxRetries ?? 3,
      initialDelay: retryConfig?.initialDelay ?? const Duration(seconds: 1),
      backoffMultiplier: retryConfig?.backoffMultiplier ?? 2.0,
      exponentialBackoff: retryConfig?.exponentialBackoff ?? true,
      shouldRetry: retryConfig?.shouldRetry,
    );
  }

  /// Queue request for offline execution
  void queueOfflineRequest(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    VoidCallback? onSuccess,
    void Function(dynamic error)? onError,
  }) {
    final operation = QueuedOperation(
      id: QueuedOperation.generateId(),
      operation: () => requestWithRetry(
        path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
      onSuccess: onSuccess,
      onError: onError,
    );

    RetryService.instance.queueOfflineOperation(operation);
  }
}
