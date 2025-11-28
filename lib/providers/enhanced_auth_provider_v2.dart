import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auth_models.dart';
import '../models/user_model.dart';
import '../services/unified_auth_service.dart';

/// Provider محسن لإدارة حالة المصادقة
class EnhancedAuthNotifier extends StateNotifier<AuthState> {
  final UnifiedAuthService _authService;

  EnhancedAuthNotifier(this._authService) : super(const AuthState.initial()) {
    _initialize();
  }

  void _initialize() {
    // مراقبة تغييرات حالة المصادقة
    _authService.authStateStream.listen((authState) {
      if (!mounted) return;
      state = authState;
    });
  }

  /// تسجيل الدخول
  Future<AuthResult> login({
    required String phone,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      state = const AuthState.loading('جاري تسجيل الدخول...');
      final result = await _authService.login(
        phone: phone,
        password: password,
        rememberMe: rememberMe,
      );
      return result;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] Login error: $e');
      state = const AuthState.error('خطأ في تسجيل الدخول');
      return AuthResult.error('خطأ في تسجيل الدخول: $e');
    }
  }

  /// تسجيل المستخدم الجديد
  Future<AuthResult> register({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    String? email,
  }) async {
    try {
      state = const AuthState.loading('جاري إنشاء الحساب...');
      final result = await _authService.register(
        phone: phone,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      return result;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] Registration error: $e');
      state = const AuthState.error('خطأ في إنشاء الحساب');
      return AuthResult.error('خطأ في إنشاء الحساب: $e');
    }
  }

  /// طلب رمز التحقق
  Future<AuthResult> requestOtp(String phone) async {
    try {
      state = const AuthState.loading('جاري إرسال رمز التحقق...');
      final result = await _authService.requestOtp(phone: phone);
      return result;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] OTP request error: $e');
      return AuthResult.error('خطأ في إرسال رمز التحقق: $e');
    }
  }

  /// التحقق من رمز OTP
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
    bool isLogin = false,
  }) async {
    try {
      state = const AuthState.loading('جاري التحقق من الرمز...');
      final result = await _authService.verifyOtp(
        phone: phone,
        otp: otp,
      );
      return result;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] OTP verification error: $e');
      return AuthResult.error('خطأ في التحقق من الرمز: $e');
    }
  }

  /// تسجيل الخروج
  Future<AuthResult> logout({bool fromAllDevices = false}) async {
    try {
      state = const AuthState.loading('جاري تسجيل الخروج...');
      final result = await _authService.logout(fromAllDevices: fromAllDevices);
      return result;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] Logout error: $e');
      state = const AuthState.error('خطأ في تسجيل الخروج');
      return AuthResult.error('خطأ في تسجيل الخروج: $e');
    }
  }

  /// التحقق من حالة المصادقة
  bool get isAuthenticated {
    return state.when(
      initial: () => false,
      loading: (message) => false,
      authenticated: (user) => true,
      unauthenticated: () => false,
      registered: () => false,
      error: (message) => false,
    );
  }

  /// التحقق من حالة التحميل
  bool get isLoading {
    return state.when(
      initial: () => false,
      loading: (message) => true,
      authenticated: (user) => false,
      unauthenticated: () => false,
      registered: () => false,
      error: (message) => false,
    );
  }

  /// التحقق من حالة التسجيل
  bool get isRegistering {
    return state.when(
      initial: () => false,
      loading: (message) =>
          message.contains('إنشاء الحساب') || message.contains('التحقق'),
      authenticated: (user) => false,
      unauthenticated: () => false,
      registered: () => true,
      error: (message) => false,
    );
  }

  /// الحصول على المستخدم الحالي
  UserModel? get user {
    return state.when(
      initial: () => null,
      loading: (message) => null,
      authenticated: (user) => user,
      unauthenticated: () => null,
      registered: () => null,
      error: (message) => null,
    );
  }

  /// التحقق من انتهاء الجلسة
  bool get sessionExpired {
    return state.when(
      initial: () => false,
      loading: (message) => false,
      authenticated: (user) => false,
      unauthenticated: () => false,
      registered: () => false,
      error: (message) =>
          message.contains('انتهت صلاحية الجلسة') ||
          message.contains('session expired'),
    );
  }

  /// سبب انتهاء الجلسة
  String? get sessionExpiredReason {
    return state.when(
      initial: () => null,
      loading: (message) => null,
      authenticated: (user) => null,
      unauthenticated: () => null,
      registered: () => null,
      error: (message) => message.contains('انتهت صلاحية الجلسة') ||
              message.contains('session expired')
          ? message
          : null,
    );
  }

  /// مسح حالة انتهاء الجلسة
  void clearSessionExpiration() {
    if (state is ErrorState) {
      final errorState = state as ErrorState;
      if (errorState.message.contains('انتهت صلاحية الجلسة') ||
          errorState.message.contains('session expired')) {
        state = const AuthState.unauthenticated();
      }
    }
  }

  /// التحقق من صحة الجلسة
  Future<bool> isSessionValid() async {
    try {
      return await _authService.isSessionValid();
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] Session validation error: $e');
      return false;
    }
  }

  /// الحصول على المستخدم الحالي
  Future<UserModel?> getCurrentUser() async {
    try {
      return await _authService.getCurrentUser();
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH_NOTIFIER] Get current user error: $e');
      return null;
    }
  }
}

/// Provider للخدمة المحسنة
final enhancedAuthServiceProvider = Provider<UnifiedAuthService>((ref) {
  return UnifiedAuthService.instance;
});

/// Provider المحسن للمصادقة
final enhancedAuthProvider =
    StateNotifierProvider<EnhancedAuthNotifier, AuthState>((ref) {
  final authService = ref.watch(enhancedAuthServiceProvider);
  return EnhancedAuthNotifier(authService);
});

/// Provider لحالة المصادقة
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(enhancedAuthServiceProvider);
  return authService.authStateStream;
});

/// Provider للمستخدم الحالي
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(enhancedAuthServiceProvider);
  return await authService.getCurrentUser();
});

/// Provider لصحة الجلسة
final sessionValidProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(enhancedAuthServiceProvider);
  return await authService.isSessionValid();
});
