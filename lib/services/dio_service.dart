import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/constants/api_constants.dart';
import '../core/errors/app_error.dart';
import '../core/errors/error_handler.dart';
import 'retry_service.dart';

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

    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization header
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Add content type
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';

          // Add language header
          final language = await _storage.read(key: 'selected_language') ?? 'ar';
          options.headers['Accept-Language'] = language;

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          // Handle token refresh
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                final newTokens = await _refreshToken(refreshToken);
                if (newTokens != null) {
                  // Retry the original request
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer ${newTokens['access_token']}';
                  final response = await _dio.fetch(options);
                  handler.resolve(response);
                  return;
                }
              } catch (e) {
                // Refresh failed, logout user
                await _clearTokens();
              }
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
        await _storage.write(key: 'access_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
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
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_data');
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _clearTokens();
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'access_token');
    debugPrint('🔑 DioService.getAccessToken: Token ${token != null && token.isNotEmpty ? "found" : "not found"}');
    return token;
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
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
