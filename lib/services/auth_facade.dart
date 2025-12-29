import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import 'compatible_auth_service.dart';
import 'unified_token_manager.dart';
import 'enhanced_session_manager.dart';

/// واجهة موحدة للمصادقة تخفي التعقيد الداخلي
/// 
/// هذه طبقة Facade توفر واجهة بسيطة وموحدة للمصادقة
/// بينما تستخدم الخدمات الموجودة داخلياً
/// 
/// **الاستخدام:**
/// ```dart
/// // تسجيل الدخول
/// final success = await AuthFacade.instance.login(phone, password);
/// 
/// // التحقق من حالة المصادقة
/// if (AuthFacade.instance.isAuthenticated) {
///   final user = AuthFacade.instance.user;
/// }
/// 
/// // تسجيل الخروج
/// await AuthFacade.instance.logout();
/// ```
class AuthFacade {
  static AuthFacade get instance => _instance ??= AuthFacade._();
  static AuthFacade? _instance;
  
  AuthFacade._() {
    debugPrint('🔐 [AUTH_FACADE] Initializing unified auth facade');
  }
  
  // الخدمات الداخلية
  final _compatAuth = CompatibleAuthService.instance;
  
  UnifiedTokenManager get _tokenManager => UnifiedTokenManager.instance;
  EnhancedSessionManager get _sessionManager => EnhancedSessionManager.instance;

  // ============================================================
  // واجهة المصادقة الموحدة
  // ============================================================

  /// تسجيل الدخول بالهاتف وكلمة المرور
  Future<AuthResult> login(String phone, String password) async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Attempting login for: $phone');
      
      final success = await _compatAuth.loginWithPhone(phone, password);
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] Login successful');
        return AuthResult.success(user: _compatAuth.user);
      } else {
        final error = _compatAuth.error ?? 'فشل في تسجيل الدخول';
        debugPrint('❌ [AUTH_FACADE] Login failed: $error');
        
        // التحقق من حالة الهاتف غير المُتحقق منه
        if (_compatAuth.unverifiedPhoneNumber != null) {
          return AuthResult.phoneNotVerified(
            phone: _compatAuth.unverifiedPhoneNumber!,
          );
        }
        
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] Login error: $e');
      return AuthResult.failure(message: 'خطأ غير متوقع: $e');
    }
  }

  /// تسجيل مستخدم جديد
  Future<AuthResult> register({
    required String phone,
    required String password,
    required String fullName,
    required String email,
    String? gender,
  }) async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Attempting registration for: $phone');
      
      final success = await _compatAuth.registerWithPhone(
        phone, 
        password, 
        fullName, 
        email,
        gender: gender,
      );
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] Registration successful');
        return AuthResult.registrationSuccess(phone: phone);
      } else {
        final error = _compatAuth.error ?? 'فشل في إنشاء الحساب';
        debugPrint('❌ [AUTH_FACADE] Registration failed: $error');
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] Registration error: $e');
      return AuthResult.failure(message: 'خطأ غير متوقع: $e');
    }
  }

  /// التحقق من رمز OTP
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
    bool isLogin = false,
  }) async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Verifying OTP for: $phone');
      
      final success = await _compatAuth.verifyOtp(phone, otp, isLogin: isLogin);
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] OTP verification successful');
        return AuthResult.success(user: _compatAuth.user);
      } else {
        final error = _compatAuth.error ?? 'فشل في التحقق من الرمز';
        debugPrint('❌ [AUTH_FACADE] OTP verification failed: $error');
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] OTP verification error: $e');
      return AuthResult.failure(message: 'خطأ غير متوقع: $e');
    }
  }

  /// إعادة إرسال رمز OTP
  Future<AuthResult> resendOtp(String phone) async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Resending OTP to: $phone');
      
      final success = await _compatAuth.requestOtp(phone);
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] OTP sent successfully');
        return AuthResult.otpSent(phone: phone);
      } else {
        final error = _compatAuth.error ?? 'فشل في إرسال الرمز';
        debugPrint('❌ [AUTH_FACADE] OTP send failed: $error');
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] OTP send error: $e');
      return AuthResult.failure(message: 'خطأ غير متوقع: $e');
    }
  }

  /// تسجيل الخروج
  Future<AuthResult> logout() async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Logging out');
      
      final success = await _compatAuth.logout();
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] Logout successful');
        return AuthResult.loggedOut();
      } else {
        final error = _compatAuth.error ?? 'فشل في تسجيل الخروج';
        debugPrint('❌ [AUTH_FACADE] Logout failed: $error');
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] Logout error: $e');
      // حتى لو فشل، نعتبر المستخدم قد خرج
      return AuthResult.loggedOut();
    }
  }

  /// طلب إعادة تعيين كلمة المرور
  Future<AuthResult> requestPasswordReset(String phone) async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Requesting password reset for: $phone');
      
      final success = await _compatAuth.requestPasswordReset(phone);
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] Password reset OTP sent');
        return AuthResult.otpSent(phone: phone);
      } else {
        final error = _compatAuth.error ?? 'فشل في إرسال رمز إعادة التعيين';
        debugPrint('❌ [AUTH_FACADE] Password reset request failed: $error');
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] Password reset request error: $e');
      return AuthResult.failure(message: 'خطأ غير متوقع: $e');
    }
  }

  /// إعادة تعيين كلمة المرور
  Future<AuthResult> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      debugPrint('🔐 [AUTH_FACADE] Resetting password for: $phone');
      
      final success = await _compatAuth.resetPassword(phone, otp, newPassword);
      
      if (success) {
        debugPrint('✅ [AUTH_FACADE] Password reset successful');
        return AuthResult.passwordResetSuccess();
      } else {
        final error = _compatAuth.error ?? 'فشل في إعادة تعيين كلمة المرور';
        debugPrint('❌ [AUTH_FACADE] Password reset failed: $error');
        return AuthResult.failure(message: error);
      }
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] Password reset error: $e');
      return AuthResult.failure(message: 'خطأ غير متوقع: $e');
    }
  }

  // ============================================================
  // حالة المصادقة
  // ============================================================

  /// هل المستخدم مسجل الدخول؟
  bool get isAuthenticated => _compatAuth.isAuthenticated;

  /// المستخدم الحالي
  UserModel? get user => _compatAuth.user;

  /// هل جارٍ التحميل؟
  bool get isLoading => _compatAuth.isLoading;

  /// رسالة الخطأ (إن وجدت)
  String? get error => _compatAuth.error;

  /// رقم الهاتف غير المُتحقق منه (إن وجد)
  String? get unverifiedPhoneNumber => _compatAuth.unverifiedPhoneNumber;

  /// هل انتهت صلاحية الجلسة؟
  bool get isSessionExpired => _compatAuth.isSessionExpired;

  // ============================================================
  // إدارة الجلسة
  // ============================================================

  /// التحقق من صحة الجلسة
  Future<bool> isSessionValid() async {
    return await _tokenManager.hasValidSession();
  }

  /// تجديد التوكن
  Future<bool> refreshToken() async {
    try {
      return await _tokenManager.refreshAccessToken();
    } catch (e) {
      debugPrint('❌ [AUTH_FACADE] Token refresh error: $e');
      return false;
    }
  }

  /// الحصول على Access Token صالح
  Future<String?> getValidAccessToken() async {
    return await _tokenManager.getValidAccessToken();
  }

  // ============================================================
  // للتوافق مع الكود القديم
  // ============================================================

  /// الوصول للخدمة الأصلية (للحالات الخاصة فقط)
  @Deprecated('Use AuthFacade methods directly. This is only for backward compatibility.')
  CompatibleAuthService get compatibleService => _compatAuth;

  /// الوصول لمدير التوكنات (للحالات الخاصة فقط)
  @Deprecated('Use AuthFacade methods directly. This is only for backward compatibility.')
  UnifiedTokenManager get tokenManager => _tokenManager;
  
  /// الوصول لمدير الجلسات (للحالات الخاصة فقط)
  @Deprecated('Use AuthFacade methods directly. This is only for backward compatibility.')
  EnhancedSessionManager get sessionManager => _sessionManager;
}

/// نتيجة عملية المصادقة
class AuthResult {
  final AuthResultType type;
  final UserModel? user;
  final String? message;
  final String? phone;

  const AuthResult._({
    required this.type,
    this.user,
    this.message,
    this.phone,
  });

  /// نجاح مع بيانات المستخدم
  factory AuthResult.success({UserModel? user}) {
    return AuthResult._(
      type: AuthResultType.success,
      user: user,
    );
  }

  /// فشل مع رسالة خطأ
  factory AuthResult.failure({required String message}) {
    return AuthResult._(
      type: AuthResultType.failure,
      message: message,
    );
  }

  /// الهاتف غير متحقق منه
  factory AuthResult.phoneNotVerified({required String phone}) {
    return AuthResult._(
      type: AuthResultType.phoneNotVerified,
      phone: phone,
    );
  }

  /// تم إرسال OTP بنجاح
  factory AuthResult.otpSent({required String phone}) {
    return AuthResult._(
      type: AuthResultType.otpSent,
      phone: phone,
    );
  }

  /// نجاح التسجيل
  factory AuthResult.registrationSuccess({required String phone}) {
    return AuthResult._(
      type: AuthResultType.registrationSuccess,
      phone: phone,
    );
  }

  /// تم تسجيل الخروج
  factory AuthResult.loggedOut() {
    return const AuthResult._(
      type: AuthResultType.loggedOut,
    );
  }

  /// نجاح إعادة تعيين كلمة المرور
  factory AuthResult.passwordResetSuccess() {
    return const AuthResult._(
      type: AuthResultType.passwordResetSuccess,
    );
  }

  /// هل نجحت العملية؟
  bool get isSuccess => type == AuthResultType.success;
  
  /// هل فشلت العملية؟
  bool get isFailure => type == AuthResultType.failure;
  
  /// هل الهاتف غير متحقق منه؟
  bool get isPhoneNotVerified => type == AuthResultType.phoneNotVerified;
}

/// أنواع نتائج المصادقة
enum AuthResultType {
  success,
  failure,
  phoneNotVerified,
  otpSent,
  registrationSuccess,
  loggedOut,
  passwordResetSuccess,
}

// ============================================================
// Providers للتكامل مع Riverpod
// ============================================================

/// Provider للـ AuthFacade
final authFacadeProvider = Provider<AuthFacade>((ref) {
  return AuthFacade.instance;
});

/// Provider لحالة المصادقة
final isAuthenticatedFacadeProvider = Provider<bool>((ref) {
  return AuthFacade.instance.isAuthenticated;
});

/// Provider للمستخدم الحالي
final currentUserFacadeProvider = Provider<UserModel?>((ref) {
  return AuthFacade.instance.user;
});
