import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/api_constants.dart';
import '../models/connection_status.dart';

/// خدمة اتصال محسنة خاصة بـ Flutter Web - SILENT MODE
/// تم إيقاف رسائل السجلات لتحسين تجربة المطور
class WebConnectivityService {
  static final WebConnectivityService _instance = WebConnectivityService._internal();
  factory WebConnectivityService() => _instance;
  WebConnectivityService._internal() {
    if (kIsWeb) {
      configureDioForWeb();
    }
  }

  final Dio _dio = Dio();
  
  // Cache settings
  ConnectionStatus? _cachedStatus;
  DateTime? _lastStatusUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 2);
  
  // Timeout settings
  static const Duration _timeout = Duration(seconds: 30);
  static const Duration _shortTimeout = Duration(seconds: 10);

  /// فحص الاتصال المحسن للويب (silent mode)
  Future<bool> checkWebConnectivity() async {
    if (!kIsWeb) return true; // للمنصات الأخرى، استخدم الخدمة العادية
    
    // Check cache first
    if (_cachedStatus != null && 
        _lastStatusUpdate != null &&
        DateTime.now().difference(_lastStatusUpdate!) < _cacheValidDuration) {
      return _cachedStatus!.isConnected;
    }

    try {
      // اختبار الاتصال بالخادم أولاً (أسرع)
      final serverConnected = await _testServerConnection();
      if (serverConnected) {
        _updateCache(true);
        return true;
      }

      // إذا فشل الخادم، اختبر الإنترنت
      final internetConnected = await _testInternetConnection();
      _updateCache(internetConnected);
      return internetConnected;
      
    } catch (e) {
      // تم إيقاف رسائل الخطأ لتحسين تجربة المطور
      // debugPrint('🔴 Web connectivity check failed: $e');
      _updateCache(false);
      return false;
    }
  }

  /// اختبار الاتصال بالخادم مع retry logic (silent mode)
  Future<bool> _testServerConnection() async {
    const maxRetries = 3;
    
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // تم إيقاف رسائل التشخيص لتحسين تجربة المطور
        // debugPrint('🔄 Testing server connection (attempt $attempt/$maxRetries)');
        
        final response = await _dio.get(
          '${ApiConstants.baseUrl}/health',
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
          // تم إيقاف رسائل النجاح لتحسين تجربة المطور
          // debugPrint('✅ Server connection successful');
          return true;
        }
        
        // تم إيقاف رسائل التحذير لتحسين تجربة المطور
        // debugPrint('⚠️ Server returned status: ${response.statusCode}');
        
      } catch (e) {
        // تم إيقاف رسائل الخطأ لتحسين تجربة المطور
        // debugPrint('🔴 Server connection attempt $attempt failed: $e');
        
        if (attempt < maxRetries) {
          // انتظار قبل المحاولة التالية
          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }
      }
    }
    
    return false;
  }

  /// اختبار الاتصال بالإنترنت باستخدام خوادم موثوقة (silent mode)
  Future<bool> _testInternetConnection() async {
    final testUrls = [
      'https://www.google.com/generate_204',
      'https://httpbin.org/status/200',
      'https://www.microsoft.com/favicon.ico',
      'https://api.github.com/zen', // إضافة خادم آخر
    ];

    // تم إيقاف رسائل التشخيص لتحسين تجربة المطور
    // debugPrint('🔄 Testing internet connectivity...');

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
          // تم إيقاف رسائل النجاح لتحسين تجربة المطور
          // debugPrint('✅ Internet connection confirmed via $url');
          return true;
        }
      } catch (e) {
        // تم إيقاف رسائل الخطأ لتحسين تجربة المطور
        // debugPrint('🔴 Failed to connect to $url: $e');
        continue; // جرب الخادم التالي
      }
    }
    
    // تم إيقاف رسائل الفشل لتحسين تجربة المطور
    // debugPrint('🔴 All internet connectivity tests failed');
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

  /// إعداد Dio للويب (silent mode)
  void configureDioForWeb() {
    if (!kIsWeb) return;

    _dio.options = BaseOptions(
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      sendTimeout: _timeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        // إزالة User-Agent للويب لتجنب خطأ "Refused to set unsafe header"
        // 'User-Agent': 'IDEC-Flutter-Web/1.0',
      },
      validateStatus: (status) => status != null && status < 500,
    );

    // إضافة interceptor للتعامل مع أخطاء الويب (silent mode)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // تم إيقاف جميع رسائل الخطأ لتحسين تجربة المطور
          // debugPrint('🔴 Dio Web Error: ${error.message}');
          // debugPrint('🔴 Error Type: ${error.type}');
          // debugPrint('🔴 Response: ${error.response?.statusCode} - ${error.response?.data}');
          
          // معالجة خاصة لأخطاء CORS (silent)
          if (error.message?.contains('CORS') == true || 
              error.message?.contains('Cross-Origin') == true) {
            // debugPrint('🔴 CORS Error detected - server configuration issue');
          }
          
          // معالجة خاصة لأخطاء الشبكة (silent)
          if (error.type == DioErrorType.connectionTimeout ||
              error.type == DioErrorType.receiveTimeout ||
              error.type == DioErrorType.sendTimeout) {
            // debugPrint('🔴 Network timeout error in web environment');
          }
          
          // معالجة خاصة لأخطاء الاتصال (silent)
          if (error.type == DioErrorType.connectionError) {
            // debugPrint('🔴 Connection error - check network and server availability');
          }
          
          handler.next(error);
        },
        onRequest: (options, handler) {
          // تم إيقاف رسائل الطلبات لتحسين تجربة المطور
          // debugPrint('🔄 Web Request: ${options.method} ${options.uri}');
          
          // إضافة headers إضافية للويب
          options.headers['Cache-Control'] = 'no-cache';
          options.headers['Pragma'] = 'no-cache';
          options.headers['X-Requested-With'] = 'XMLHttpRequest';
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          // تم إيقاف رسائل الاستجابة لتحسين تجربة المطور
          // debugPrint('✅ Web Response: ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
      ),
    );
  }

  /// فحص حالة الخادم مع تفاصيل إضافية (silent mode)
  Future<Map<String, dynamic>> getDetailedServerStatus() async {
    if (!kIsWeb) {
      return {'status': 'not_web', 'message': 'This method is for web platform only'};
    }

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/health',
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
