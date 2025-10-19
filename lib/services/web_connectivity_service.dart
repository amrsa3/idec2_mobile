import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/api_constants.dart';
import '../models/connection_status.dart';

/// خدمة اتصال محسنة خاصة بـ Flutter Web
class WebConnectivityService {
  static final WebConnectivityService _instance = WebConnectivityService._internal();
  factory WebConnectivityService() => _instance;
  WebConnectivityService._internal() {
    if (kIsWeb) {
      configureDioForWeb();
    }
  }

  final Dio _dio = Dio();
  
  static const Duration _timeout = Duration(seconds: 15);
  static const Duration _shortTimeout = Duration(seconds: 5);
  
  // Cache for connection status
  ConnectionStatus? _cachedStatus;
  DateTime? _lastStatusUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 1);

  /// فحص الاتصال المحسن للويب
  Future<bool> checkWebConnectivity() async {
    if (!kIsWeb) return true; // للمنصات الأخرى، استخدم الخدمة العادية
    
    // Check cache first
    if (_cachedStatus != null && 
        _lastStatusUpdate != null && 
        DateTime.now().difference(_lastStatusUpdate!) < _cacheValidDuration) {
      return _cachedStatus!.isConnected;
    }

    try {
      // اختبار الاتصال بالخادم مباشرة
      final serverConnected = await _testServerConnection();
      if (serverConnected) {
        _updateCache(true);
        return true;
      }

      // اختبار الاتصال بالإنترنت
      final internetConnected = await _testInternetConnection();
      _updateCache(internetConnected);
      return internetConnected;
      
    } catch (e) {
      print('🔴 Web connectivity check failed: $e');
      _updateCache(false);
      return false;
    }
  }

  /// اختبار الاتصال بالخادم مع retry logic
  Future<bool> _testServerConnection() async {
    const maxRetries = 3;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('🔄 Testing server connection (attempt $attempt/$maxRetries)');
        
        final response = await _dio.get(
          '${ApiConstants.baseUrl}/api/v1/health',
          options: Options(
            sendTimeout: _shortTimeout,
            receiveTimeout: _shortTimeout,
            validateStatus: (status) => status != null && status < 500,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
            },
          ),
        );
        
        if (response.statusCode == 200) {
          print('✅ Server connection successful');
          return true;
        }
        
        print('⚠️ Server returned status: ${response.statusCode}');
        
      } catch (e) {
        print('🔴 Server connection attempt $attempt failed: $e');
        
        if (attempt < maxRetries) {
          // انتظار قبل المحاولة التالية
          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }
      }
    }
    
    return false;
  }

  /// اختبار الاتصال بالإنترنت باستخدام خوادم موثوقة
  Future<bool> _testInternetConnection() async {
    final testUrls = [
      'https://www.google.com/generate_204',
      'https://httpbin.org/status/200',
      'https://www.microsoft.com/favicon.ico',
      'https://api.github.com/zen', // إضافة خادم آخر
    ];

    print('🔄 Testing internet connectivity...');

    for (final url in testUrls) {
      try {
        final response = await _dio.get(
          url,
          options: Options(
            sendTimeout: _shortTimeout,
            receiveTimeout: _shortTimeout,
            validateStatus: (status) => status != null && status >= 200 && status < 400,
            headers: {
              'Cache-Control': 'no-cache',
              'Pragma': 'no-cache',
            },
          ),
        );
        
        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 400) {
          print('✅ Internet connection confirmed via $url');
          return true;
        }
      } catch (e) {
        print('🔴 Failed to connect to $url: $e');
        continue; // جرب الخادم التالي
      }
    }
    
    print('🔴 All internet connectivity tests failed');
    return false;
  }

  /// تحديث الكاش
  void _updateCache(bool isConnected) {
    _cachedStatus = ConnectionStatus.initial().copyWith(
      isConnected: isConnected,
      lastUpdated: DateTime.now(),
    );
    _lastStatusUpdate = DateTime.now();
  }

  /// مسح الكاش
  void clearCache() {
    _cachedStatus = null;
    _lastStatusUpdate = null;
  }

  /// إعداد Dio للويب
  void configureDioForWeb() {
    if (!kIsWeb) return;

    _dio.options = BaseOptions(
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      sendTimeout: _timeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'User-Agent': 'IDEC-Flutter-Web/1.0',
      },
      validateStatus: (status) => status != null && status < 500,
    );

    // إضافة interceptor للتعامل مع أخطاء الويب
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          print('🔴 Dio Web Error: ${error.message}');
          print('🔴 Error Type: ${error.type}');
          print('🔴 Response: ${error.response?.statusCode} - ${error.response?.data}');
          
          // معالجة خاصة لأخطاء CORS
          if (error.message?.contains('CORS') == true || 
              error.message?.contains('Cross-Origin') == true) {
            print('🔴 CORS Error detected - server configuration issue');
          }
          
          // معالجة خاصة لأخطاء الشبكة
          if (error.type == DioErrorType.connectionTimeout ||
              error.type == DioErrorType.receiveTimeout ||
              error.type == DioErrorType.sendTimeout) {
            print('🔴 Network timeout error in web environment');
          }
          
          // معالجة خاصة لأخطاء الاتصال
          if (error.type == DioErrorType.connectionError) {
            print('🔴 Connection error - check network and server availability');
          }
          
          handler.next(error);
        },
        onRequest: (options, handler) {
          print('🔄 Web Request: ${options.method} ${options.uri}');
          
          // إضافة headers إضافية للويب
          options.headers['Cache-Control'] = 'no-cache';
          options.headers['Pragma'] = 'no-cache';
          options.headers['X-Requested-With'] = 'XMLHttpRequest';
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Web Response: ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
      ),
    );
  }

  /// فحص حالة الخادم مع تفاصيل إضافية
  Future<Map<String, dynamic>> getDetailedServerStatus() async {
    if (!kIsWeb) {
      return {'status': 'not_web', 'message': 'This method is for web platform only'};
    }

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/api/v1/health',
        options: Options(
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
          validateStatus: (status) => true, // قبول جميع الحالات
        ),
      );

      return {
        'status': 'success',
        'statusCode': response.statusCode,
        'data': response.data,
        'headers': response.headers.map,
        'message': 'Server is reachable'
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
        'message': 'Failed to reach server'
      };
    }
  }
}
