import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'enhanced_dio_service_v2.dart';
import 'platform_storage_service.dart';
import 'unified_token_manager.dart';

/// نظام مصادقة متوافق تماماً مع النظام الحالي
class CompatibleAuthService {
  static CompatibleAuthService? _instance;
  static CompatibleAuthService get instance =>
      _instance ??= CompatibleAuthService._internal();

  late Dio _dio;
  late PlatformStorageService _storage;
  late UnifiedTokenManager _tokenManager;

  // Current state
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  String? _unverifiedPhoneNumber;

  CompatibleAuthService._internal() {
    // Initialize core services synchronously
    _initializeCoreServices();
  }

  /// تهيئة الخدمات الأساسية بشكل متزامن
  void _initializeCoreServices() {
    try {
      debugPrint('🔐 [COMPATIBLE_AUTH] Initializing core services...');

      _dio = EnhancedDioServiceV2.instance.dio;
      _storage = PlatformStorageService.instance;
      _tokenManager = UnifiedTokenManager.instance;

      debugPrint('✅ [COMPATIBLE_AUTH] Core services initialized successfully');

      // Start async initialization in background
      _initializeAsyncServices();
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Core initialization error: $e');
    }
  }

  /// تهيئة الخدمات التي تتطلب عمليات غير متزامنة
  Future<void> _initializeAsyncServices() async {
    try {
      debugPrint('🔐 [COMPATIBLE_AUTH] Initializing async services...');

      await _storage.init();
      await _tokenManager.initialize();

      // محاولة استعادة الجلسة المحفوظة
      await _restoreSession();

      debugPrint('✅ [COMPATIBLE_AUTH] Async services initialized successfully');
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Async initialization error: $e');
    }
  }

  /// تسجيل الدخول بالهاتف
  Future<bool> loginWithPhone(String phone, String password) async {
    try {
      _isLoading = true;
      _error = null;

      debugPrint('🔐 [COMPATIBLE_AUTH] Attempting login for: $phone');

      final response = await _dio.post(ApiConstants.loginEndpoint, data: {
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract user data - check both possible structures
        Map<String, dynamic>? userData;
        if (responseData.containsKey('user')) {
          userData = responseData['user'] as Map<String, dynamic>;
        } else if (responseData.containsKey('data')) {
          userData = responseData['data'] as Map<String, dynamic>;
        } else {
          // If no nested structure, use the response data directly
          userData = responseData;
        }

        if (userData != null) {
          debugPrint('🔐 [COMPATIBLE_AUTH] Creating user from data: $userData');
          _currentUser = UserModel.fromJsonSafe(userData);
          debugPrint(
              '🔐 [COMPATIBLE_AUTH] User created: ${_currentUser?.phone}');
          debugPrint(
              '🔐 [COMPATIBLE_AUTH] User authenticated: ${_currentUser != null}');

          // Extract tokens - check both possible structures
          String? accessToken;
          String? refreshToken;

          if (responseData.containsKey('tokens')) {
            final tokens = responseData['tokens'] as Map<String, dynamic>;
            accessToken = tokens['accessToken'] as String?;
            refreshToken = tokens['refreshToken'] as String?;
          } else {
            accessToken = responseData['access_token'] as String?;
            refreshToken = responseData['refresh_token'] as String?;
          }

          // حفظ التوكنات - استخدام UnifiedTokenManager
          if (accessToken != null) {
            await _tokenManager.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken ?? '',
              expiresIn: 900, // 15 minutes default
            );
            // أيضاً احفظ في المفاتيح القديمة للتوافق
            await _storage.setString('access_token', accessToken);
            debugPrint(
                '🔐 [COMPATIBLE_AUTH] Access token saved via UnifiedTokenManager');
          }
          if (refreshToken != null) {
            await _storage.setString('refresh_token', refreshToken);
            debugPrint('🔐 [COMPATIBLE_AUTH] Refresh token saved');
          }
          await _storage.writeSecure(
              'current_user', _currentUser!.toJson().toString());
          await _storage.setString(
              'user_data', _currentUser!.toJson().toString());
          debugPrint('🔐 [COMPATIBLE_AUTH] User data saved');

          _isLoading = false;
          debugPrint('✅ [COMPATIBLE_AUTH] Login successful for: $phone');
          debugPrint(
              '✅ [COMPATIBLE_AUTH] Final auth state - isAuthenticated: ${_currentUser != null}');
          return true;
        } else {
          _error = 'بيانات المستخدم غير صحيحة';
          _isLoading = false;
          debugPrint('❌ [COMPATIBLE_AUTH] Invalid user data structure');
          return false;
        }
      } else {
        _error = 'فشل في تسجيل الدخول';
        _isLoading = false;
        debugPrint(
            '❌ [COMPATIBLE_AUTH] Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Login error: $e');
      _error = 'خطأ في تسجيل الدخول: $e';
      _isLoading = false;
      return false;
    }
  }

  /// تسجيل المستخدم الجديد
  Future<bool> registerWithPhone(
      String phone, String password, String firstName, String lastName) async {
    try {
      _isLoading = true;
      _error = null;

      debugPrint('🔐 [COMPATIBLE_AUTH] Attempting registration for: $phone');

      final response = await _dio.post(ApiConstants.registerEndpoint, data: {
        'phone': phone,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      });

      if (response.statusCode == 200) {
        _isLoading = false;
        debugPrint('✅ [COMPATIBLE_AUTH] Registration successful for: $phone');
        return true;
      } else {
        _error = 'فشل في إنشاء الحساب';
        _isLoading = false;
        debugPrint(
            '❌ [COMPATIBLE_AUTH] Registration failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Registration error: $e');
      _error = 'خطأ في إنشاء الحساب: $e';
      _isLoading = false;
      return false;
    }
  }

  /// التحقق من رمز OTP
  Future<bool> verifyOtp(String phone, String otp,
      {bool isLogin = false}) async {
    try {
      _isLoading = true;
      _error = null;

      debugPrint('🔐 [COMPATIBLE_AUTH] Verifying OTP for: $phone');

      final response = await _dio.post(ApiConstants.verifyPhoneEndpoint, data: {
        'phone': phone,
        'otp': otp,
        'isLogin': isLogin,
      });

      if (response.statusCode == 200) {
        if (isLogin) {
          // تسجيل دخول بعد التحقق
          final userData = response.data['data'];
          _currentUser = UserModel.fromJsonSafe(userData);

          // حفظ التوكنات بنفس الطريقة المستخدمة في loginWithPhone
          final accessToken = response.data['accessToken'] ?? '';
          final refreshToken = response.data['refreshToken'] ?? '';

          if (accessToken.isNotEmpty) {
            await _tokenManager.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
              expiresIn: 900, // 15 minutes default
            );
            await _storage.setString('access_token', accessToken);
          }
          if (refreshToken.isNotEmpty) {
            await _storage.setString('refresh_token', refreshToken);
          }
          await _storage.writeSecure(
              'current_user', _currentUser!.toJson().toString());
          await _storage.setString(
              'user_data', _currentUser!.toJson().toString());
        }

        _isLoading = false;
        debugPrint(
            '✅ [COMPATIBLE_AUTH] OTP verification successful for: $phone');
        return true;
      } else {
        _error = 'رمز التحقق غير صحيح';
        _isLoading = false;
        debugPrint(
            '❌ [COMPATIBLE_AUTH] OTP verification failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] OTP verification error: $e');
      _error = 'خطأ في التحقق من الرمز: $e';
      _isLoading = false;
      return false;
    }
  }

  /// إعادة إرسال رمز OTP
  Future<bool> resendOtp(String phone) async {
    try {
      _isLoading = true;
      _error = null;

      debugPrint('🔐 [COMPATIBLE_AUTH] Resending OTP for: $phone');

      final response = await _dio.post(ApiConstants.resendOtpEndpoint, data: {
        'phone': phone,
      });

      if (response.statusCode == 200) {
        _isLoading = false;
        debugPrint('✅ [COMPATIBLE_AUTH] OTP resent successfully for: $phone');
        return true;
      } else {
        _error = 'فشل في إرسال رمز التحقق';
        _isLoading = false;
        debugPrint(
            '❌ [COMPATIBLE_AUTH] OTP resend failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] OTP resend error: $e');
      _error = 'خطأ في إرسال رمز التحقق: $e';
      _isLoading = false;
      return false;
    }
  }

  /// طلب إعادة تعيين كلمة المرور
  Future<bool> requestPasswordReset(String phone) async {
    try {
      _isLoading = true;
      _error = null;

      final response = await _dio.post('/auth/forgot-password', data: {
        'phone': phone,
      });

      if (response.statusCode == 200) {
        _isLoading = false;
        return true;
      } else {
        _error = 'فشل في طلب إعادة تعيين كلمة المرور';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      debugPrint('❌ Password reset request error: $e');
      _error = 'خطأ في طلب إعادة تعيين كلمة المرور: $e';
      _isLoading = false;
      return false;
    }
  }

  /// إعادة تعيين كلمة المرور
  Future<bool> resetPassword(
      String phone, String otp, String newPassword) async {
    try {
      _isLoading = true;
      _error = null;

      final response = await _dio.post('/auth/reset-password', data: {
        'phone': phone,
        'otp': otp,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        _isLoading = false;
        return true;
      } else {
        _error = 'فشل في إعادة تعيين كلمة المرور';
        _isLoading = false;
        return false;
      }
    } catch (e) {
      debugPrint('❌ Password reset error: $e');
      _error = 'خطأ في إعادة تعيين كلمة المرور: $e';
      _isLoading = false;
      return false;
    }
  }

  /// تسجيل الخروج
  Future<bool> logout() async {
    try {
      _isLoading = true;
      _error = null;

      // إرسال طلب تسجيل الخروج للخادم
      try {
        await _dio.post('/auth/logout');
      } catch (e) {
        debugPrint('⚠️ Server logout failed, continuing with local logout: $e');
      }

      // مسح البيانات المحلية - مسح جميع المفاتيح
      await _tokenManager.clearTokens();
      await _storage.delete('access_token');
      await _storage.delete('refresh_token');
      await _storage.delete('user_data');
      await _storage.deleteSecure('secure_access_token');
      await _storage.deleteSecure('secure_refresh_token');
      await _storage.deleteSecure('current_user');

      _currentUser = null;
      _isLoading = false;
      return true;
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      _error = 'خطأ في تسجيل الخروج: $e';
      _isLoading = false;
      return false;
    }
  }

  /// مسح الخطأ
  void clearError() {
    _error = null;
  }

  /// الحصول على المستخدم الحالي
  UserModel? get user => _currentUser;

  /// التحقق من حالة التحميل
  bool get isLoading => _isLoading;

  /// الحصول على الخطأ
  String? get error => _error;

  /// التحقق من حالة المصادقة
  bool get isAuthenticated => _currentUser != null;

  /// التحقق من انتهاء الجلسة
  /// التحقق من انتهاء صلاحية الجلسة
  bool get sessionExpired {
    // إذا لم يكن هناك مستخدم، فالجلسة منتهية الصلاحية
    if (_currentUser == null) return true;

    // يمكن إضافة منطق أكثر تعقيداً هنا للتحقق من انتهاء صلاحية التوكن
    // لكن في الوقت الحالي، إذا كان المستخدم موجود، فالجلسة صالحة
    return false;
  }

  /// الحصول على رقم الهاتف غير الموثق
  String? get unverifiedPhoneNumber => _unverifiedPhoneNumber;

  /// استعادة الجلسة المحفوظة
  Future<void> _restoreSession() async {
    try {
      debugPrint('🔐 [COMPATIBLE_AUTH] Restoring session...');

      // محاولة قراءة التوكن من UnifiedTokenManager أولاً
      String? accessToken = await _tokenManager.getValidAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        // إذا لم يوجد، جرب المفاتيح القديمة
        accessToken = await _storage.getString('access_token');
      }

      if (accessToken != null && accessToken.isNotEmpty) {
        debugPrint(
            '🔐 [COMPATIBLE_AUTH] Access token found, restoring user...');

        // محاولة قراءة بيانات المستخدم من المفاتيح الآمنة أولاً
        String? userDataString = await _storage.readSecure('current_user');
        if (userDataString == null || userDataString.isEmpty) {
          // إذا لم يوجد، جرب المفاتيح القديمة
          userDataString = await _storage.getString('user_data');
        }

        if (userDataString != null && userDataString.isNotEmpty) {
          try {
            // تحويل JSON string إلى Map
            final userData = jsonDecode(userDataString) as Map<String, dynamic>;
            _currentUser = UserModel.fromJsonSafe(userData);
            debugPrint(
                '🔐 [COMPATIBLE_AUTH] User restored: ${_currentUser?.phone}');
          } catch (e) {
            debugPrint('❌ [COMPATIBLE_AUTH] Error parsing user data: $e');
          }
        }
      } else {
        debugPrint('🔐 [COMPATIBLE_AUTH] No access token found');
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Session restoration error: $e');
    }
  }
}

/// Provider للخدمة المتوافقة
final compatibleAuthServiceProvider = Provider<CompatibleAuthService>((ref) {
  return CompatibleAuthService.instance;
});

/// Provider متوافق للمصادقة
final compatibleAuthProvider =
    StateNotifierProvider<CompatibleAuthNotifier, CompatibleAuthState>((ref) {
  final authService = ref.watch(compatibleAuthServiceProvider);
  return CompatibleAuthNotifier(authService);
});

/// حالة المصادقة المتوافقة
class CompatibleAuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final bool sessionExpired;
  final String? unverifiedPhoneNumber;

  CompatibleAuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.sessionExpired = false,
    this.unverifiedPhoneNumber,
  });

  CompatibleAuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool? sessionExpired,
    String? unverifiedPhoneNumber,
  }) {
    return CompatibleAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      unverifiedPhoneNumber:
          unverifiedPhoneNumber ?? this.unverifiedPhoneNumber,
    );
  }
}

/// Provider محسن لإدارة حالة المصادقة المتوافقة
class CompatibleAuthNotifier extends StateNotifier<CompatibleAuthState> {
  final CompatibleAuthService _authService;

  CompatibleAuthNotifier(this._authService) : super(CompatibleAuthState()) {
    _initialize();
  }

  void _initialize() {
    // تحديث الحالة بناءً على الخدمة
    _updateState();

    // تأكد من تحديث الحالة بعد استعادة الجلسة
    Future.delayed(const Duration(milliseconds: 100), () {
      _updateState();
    });
  }

  void _updateState() {
    state = CompatibleAuthState(
      user: _authService.user,
      isLoading: _authService.isLoading,
      error: _authService.error,
      isAuthenticated: _authService.isAuthenticated,
      sessionExpired: _authService.sessionExpired,
      unverifiedPhoneNumber: _authService.unverifiedPhoneNumber,
    );
  }

  /// تسجيل الدخول بالهاتف
  Future<bool> loginWithPhone(String phone, String password) async {
    final result = await _authService.loginWithPhone(phone, password);
    _updateState();
    return result;
  }

  /// تسجيل المستخدم الجديد
  Future<bool> registerWithPhone(
      String phone, String password, String firstName, String lastName) async {
    final result = await _authService.registerWithPhone(
        phone, password, firstName, lastName);
    _updateState();
    return result;
  }

  /// التحقق من رمز OTP
  Future<bool> verifyOtp(String phone, String otp,
      {bool isLogin = false}) async {
    final result = await _authService.verifyOtp(phone, otp, isLogin: isLogin);
    _updateState();
    return result;
  }

  /// إعادة إرسال رمز OTP
  Future<bool> resendOtp(String phone) async {
    final result = await _authService.resendOtp(phone);
    _updateState();
    return result;
  }

  /// طلب إعادة تعيين كلمة المرور
  Future<bool> requestPasswordReset(String phone) async {
    final result = await _authService.requestPasswordReset(phone);
    _updateState();
    return result;
  }

  /// إعادة تعيين كلمة المرور
  Future<bool> resetPassword(
      String phone, String otp, String newPassword) async {
    final result = await _authService.resetPassword(phone, otp, newPassword);
    _updateState();
    return result;
  }

  /// تسجيل الخروج
  Future<bool> logout() async {
    final result = await _authService.logout();
    _updateState();
    return result;
  }

  /// مسح الخطأ
  void clearError() {
    _authService.clearError();
    _updateState();
  }

  /// تحديث حالة المصادقة يدوياً
  void refreshAuthState() {
    _updateState();
  }

  /// التحقق من حالة المصادقة
  bool get isAuthenticated => _authService.isAuthenticated;

  /// التحقق من حالة التحميل
  bool get isLoading => _authService.isLoading;

  /// الحصول على الخطأ
  String? get error => _authService.error;

  /// الحصول على المستخدم الحالي
  UserModel? get user => _authService.user;

  /// التحقق من انتهاء الجلسة
  bool get sessionExpired => _authService.sessionExpired;

  /// الحصول على رقم الهاتف غير الموثق
  String? get unverifiedPhoneNumber => _authService.unverifiedPhoneNumber;
}
