import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../services/enhanced_dio_service_v2.dart';
import '../constants/api_constants.dart';
import 'auth_exceptions.dart';

/// مستودع المصادقة - يتعامل مع API فقط
/// 
/// هذه الطبقة مسؤولة عن:
/// - إجراء طلبات HTTP للخادم
/// - تحويل استجابات الخادم إلى بيانات قابلة للاستخدام
/// - رمي استثناءات مناسبة عند حدوث أخطاء
/// 
/// ملاحظة: هذه الطبقة لا تُدير التوكنات أو الجلسات
class AuthRepository {
  static AuthRepository? _instance;
  static AuthRepository get instance => _instance ??= AuthRepository._();
  
  AuthRepository._();
  
  /// الحصول على Dio instance
  Dio get _dio => EnhancedDioServiceV2.instance.dio;
  
  // ============================================================
  // عمليات تسجيل الدخول
  // ============================================================
  
  /// تسجيل الدخول بالهاتف وكلمة المرور
  /// 
  /// يُرجع response من الخادم يحتوي على:
  /// - `success`: bool
  /// - `data.user`: بيانات المستخدم
  /// - `data.tokens`: التوكنات
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      debugPrint('📤 [AuthRepository] Login request for: $phone');
      
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'phone': phone,
          'password': password,
        },
      );
      
      debugPrint('📥 [AuthRepository] Login response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Login error: $e');
      throw UnknownAuthException(
        message: 'فشل تسجيل الدخول: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  // ============================================================
  // عمليات التسجيل
  // ============================================================
  
  /// تسجيل مستخدم جديد
  Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    required String fullName,
    required String email,
    String? gender,
  }) async {
    try {
      debugPrint('📤 [AuthRepository] Register request for: $phone');
      
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: {
          'phone': phone,
          'password': password,
          'password_confirmation': password,
          'confirmPassword': password,
          'full_name': fullName,
          'name': fullName, // بعض APIs تستخدم 'name' بدلاً من 'full_name'
          'email': email,
          if (gender != null) 'gender': gender,
        },
      );
      
      debugPrint('📥 [AuthRepository] Register response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Register error: $e');
      throw UnknownAuthException(
        message: 'فشل التسجيل: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  // ============================================================
  // عمليات OTP
  // ============================================================
  
  /// التحقق من رمز OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
    bool isLogin = false,
  }) async {
    try {
      debugPrint('📤 [AuthRepository] Verify OTP for: $phone');
      
      final response = await _dio.post(
        ApiConstants.verifyPhoneEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
          if (isLogin) 'is_login': true,
        },
      );
      
      debugPrint('📥 [AuthRepository] Verify OTP response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Verify OTP error: $e');
      throw UnknownAuthException(
        message: 'فشل التحقق: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// إعادة إرسال رمز OTP
  Future<Map<String, dynamic>> resendOtp(String phone) async {
    try {
      debugPrint('📤 [AuthRepository] Resend OTP for: $phone');
      
      final response = await _dio.post(
        ApiConstants.resendOtpEndpoint,
        data: {'phone': phone},
      );
      
      debugPrint('📥 [AuthRepository] Resend OTP response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Resend OTP error: $e');
      throw UnknownAuthException(
        message: 'فشل إعادة إرسال OTP: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  // ============================================================
  // عمليات إعادة تعيين كلمة المرور
  // ============================================================
  
  /// طلب إعادة تعيين كلمة المرور
  Future<Map<String, dynamic>> requestPasswordReset(String phone) async {
    try {
      debugPrint('📤 [AuthRepository] Request password reset for: $phone');
      
      final response = await _dio.post(
        ApiConstants.forgotPasswordEndpoint,
        data: {'phone': phone},
      );
      
      debugPrint('📥 [AuthRepository] Password reset request response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Password reset request error: $e');
      throw UnknownAuthException(
        message: 'فشل طلب إعادة تعيين كلمة المرور: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// إعادة تعيين كلمة المرور
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      debugPrint('📤 [AuthRepository] Reset password for: $phone');
      
      final response = await _dio.post(
        ApiConstants.resetPasswordEndpoint,
        data: {
          'phone': phone,
          'otp': otp,
          'newPassword': newPassword,
          'password': newPassword,
          'password_confirmation': newPassword,
          'confirmPassword': newPassword,
        },
      );
      
      debugPrint('📥 [AuthRepository] Reset password response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Reset password error: $e');
      throw UnknownAuthException(
        message: 'فشل إعادة تعيين كلمة المرور: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  // ============================================================
  // تغيير كلمة المرور (للمستخدم المسجل)
  // ============================================================
  
  /// تغيير كلمة المرور للمستخدم المسجل
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      debugPrint('📤 [AuthRepository] Change password request');
      
      final response = await _dio.post(
        ApiConstants.changePasswordEndpoint,
        data: {
          'currentPassword': currentPassword,
          'oldPassword': currentPassword,
          'newPassword': newPassword,
          'password': newPassword,
          'password_confirmation': newPassword,
          'confirmPassword': newPassword,
        },
      );
      
      debugPrint('📥 [AuthRepository] Change password response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Change password error: $e');
      throw UnknownAuthException(
        message: 'فشل تغيير كلمة المرور: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  // ============================================================
  // عمليات تسجيل الخروج
  // ============================================================
  
  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      debugPrint('📤 [AuthRepository] Logout request');
      
      await _dio.post(ApiConstants.logoutEndpoint);
      
      debugPrint('📥 [AuthRepository] Logout successful');
    } on DioException catch (e) {
      // تجاهل أخطاء 401 عند تسجيل الخروج
      if (e.response?.statusCode == 401) {
        debugPrint('⚠️ [AuthRepository] Logout: Already logged out (401)');
        return;
      }
      debugPrint('⚠️ [AuthRepository] Logout error (ignored): $e');
      // لا نرمي exception لأن تسجيل الخروج يجب أن ينجح محلياً
    } catch (e) {
      debugPrint('⚠️ [AuthRepository] Logout error (ignored): $e');
    }
  }
  
  /// تسجيل الخروج من جميع الأجهزة
  Future<void> logoutFromAllDevices() async {
    try {
      debugPrint('📤 [AuthRepository] Logout from all devices request');
      
      await _dio.post('${ApiConstants.logoutEndpoint}/all');
      
      debugPrint('📥 [AuthRepository] Logout from all devices successful');
    } on DioException catch (e) {
      debugPrint('⚠️ [AuthRepository] Logout from all devices error: $e');
    } catch (e) {
      debugPrint('⚠️ [AuthRepository] Logout from all devices error: $e');
    }
  }
  
  // ============================================================
  // عمليات التوكن
  // ============================================================
  
  /// تجديد التوكن
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      debugPrint('📤 [AuthRepository] Refresh token request');
      
      final response = await _dio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );
      
      debugPrint('📥 [AuthRepository] Refresh token response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const TokenRefreshException(
          message: 'انتهت صلاحية التوكن ويجب إعادة تسجيل الدخول',
        );
      }
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Refresh token error: $e');
      throw TokenRefreshException(
        message: 'فشل تجديد التوكن: $e',
        originalError: e,
      );
    }
  }
  
  // ============================================================
  // عمليات الملف الشخصي
  // ============================================================
  
  /// جلب بيانات المستخدم الحالي
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      debugPrint('📤 [AuthRepository] Get current user request');
      
      final response = await _dio.get(ApiConstants.profileEndpoint);
      
      debugPrint('📥 [AuthRepository] Get current user response: ${response.statusCode}');
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthRepository] Get current user error: $e');
      throw UnknownAuthException(
        message: 'فشل جلب بيانات المستخدم: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  // ============================================================
  // الدوال المساعدة
  // ============================================================
  
  /// معالجة استجابة الخادم
  Map<String, dynamic> _handleResponse(Response response) {
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      return data;
    }
    
    return {'data': data, 'success': response.statusCode == 200};
  }
  
  /// معالجة أخطاء Dio
  AuthException _handleDioException(DioException e) {
    debugPrint('❌ [AuthRepository] DioException: ${e.type} - ${e.message}');
    
    // معالجة أخطاء الشبكة
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkException(message: 'انتهت مهلة الاتصال');
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException(message: 'لا يوجد اتصال بالإنترنت');
    }
    
    // معالجة أخطاء HTTP
    final response = e.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data as Map<String, dynamic>?;
      
      // استخراج الرسالة بشكل آمن بغض النظر عن نوعها (String or List)
      String message = 'خطأ غير متوقع';
      if (data != null && data['message'] != null) {
        final msgData = data['message'];
        if (msgData is List) {
          // إذا كانت الرسالة قائمة، ندمج العناصر
          message = msgData.map((e) => e.toString()).join('\n');
        } else {
          // وإلا نستخدمها كنص
          message = msgData.toString();
        }
      }
      final code = data?['code'] as String?;
      
      switch (statusCode) {
        case 400:
          return ValidationException(message: message, code: code);
        
        case 401:
          // التحقق من نوع الخطأ
          if (message.toLowerCase().contains('credential') ||
              message.contains('كلمة المرور') ||
              message.contains('password')) {
            return InvalidCredentialsException(message: message, code: code);
          }
          if (message.toLowerCase().contains('token') ||
              message.toLowerCase().contains('session')) {
            return const TokenExpiredException();
          }
          return InvalidCredentialsException(message: message, code: code);
        
        case 403:
          if (message.toLowerCase().contains('blocked') ||
              message.contains('محظور')) {
            return AccountBlockedException(message: message, code: code);
          }
          if (message.toLowerCase().contains('disabled') ||
              message.contains('معطل')) {
            return AccountDisabledException(message: message, code: code);
          }
          return ServerException(message: message, statusCode: statusCode);
        
        case 404:
          if (message.toLowerCase().contains('phone') ||
              message.contains('الهاتف')) {
            return PhoneNotFoundException(phone: '', message: message, code: code);
          }
          return ServerException(message: message, statusCode: statusCode);
        
        case 409:
          if (message.toLowerCase().contains('phone') ||
              message.contains('الهاتف')) {
            return PhoneAlreadyExistsException(phone: '', message: message, code: code);
          }
          return ServerException(message: message, statusCode: statusCode);
        
        case 422:
          // أخطاء التحقق من الصحة
          final errors = data?['errors'] as Map<String, dynamic>?;
          final fieldErrors = errors?.map(
            (key, value) => MapEntry(key, value.toString()),
          );
          return ValidationException(
            message: message,
            fieldErrors: fieldErrors,
            code: code,
          );
        
        case 429:
          return OtpRateLimitException(message: message, code: code);
        
        case 500:
        case 502:
        case 503:
          if (statusCode == 503) {
            return const MaintenanceException();
          }
          return ServerException(
            message: 'خطأ في الخادم',
            statusCode: statusCode,
          );
        
        default:
          return ServerException(
            message: message,
            statusCode: statusCode,
          );
      }
    }
    
    return NetworkException(
      message: e.message ?? 'خطأ في الاتصال',
      originalError: e,
    );
  }
}
