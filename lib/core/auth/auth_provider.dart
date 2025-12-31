import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import 'auth_service.dart';
import 'auth_state.dart';

// ============================================================
// المُزود الرئيسي للمصادقة
// ============================================================

/// المُزود الرئيسي لحالة المصادقة
/// 
/// هذا المُزود هو نقطة الوصول الرئيسية لحالة المصادقة في التطبيق.
/// 
/// الاستخدام:
/// ```dart
/// // قراءة الحالة
/// final authState = ref.watch(authProvider);
/// 
/// // التحقق من المصادقة
/// final isAuth = ref.watch(isAuthenticatedProvider);
/// 
/// // الحصول على المستخدم
/// final user = ref.watch(currentUserProvider);
/// 
/// // تنفيذ عملية
/// await ref.read(authProvider.notifier).loginWithPhone('777123456', 'password');
/// ```
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// ============================================================
// Computed Providers
// ============================================================

/// هل المستخدم مُصادق؟
final isAuthenticatedProvider = Provider<bool>((ref) {
  final state = ref.watch(authProvider);
  return state.isAuthenticated;
});

/// المستخدم الحالي (null إذا غير مُصادق)
final currentUserProvider = Provider<UserModel?>((ref) {
  final state = ref.watch(authProvider);
  return state.user;
});

/// هل جاري التحميل؟
final isAuthLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(authProvider);
  return state.isLoading;
});

/// رسالة الخطأ (null إذا لا يوجد خطأ)
final authErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(authProvider);
  return state.errorMessage;
});

/// رقم الهاتف غير المُفعل (null إذا لا يوجد)
final unverifiedPhoneProvider = Provider<String?>((ref) {
  final state = ref.watch(authProvider);
  return state.unverifiedPhone;
});

/// هل الجلسة منتهية؟
final isSessionExpiredProvider = Provider<bool>((ref) {
  final state = ref.watch(authProvider);
  return state.isSessionExpired;
});

// ============================================================
// Auth Notifier
// ============================================================

/// مُدير حالة المصادقة
class AuthNotifier extends StateNotifier<AuthState> {
  /// خدمة المصادقة
  final _service = AuthService.instance;
  
  /// اشتراك في Stream الحالة
  StreamSubscription<AuthState>? _stateSubscription;
  
  /// آخر نتيجة عملية (للتوافق مع الكود القديم)
  AuthResult? _lastResult;
  
  AuthNotifier() : super(const AuthState.initial()) {
    _initialize();
  }
  
  // ============================================================
  // Getters مساعدة
  // ============================================================
  
  /// المستخدم الحالي
  UserModel? get user => _service.user;
  
  /// هل المستخدم مُصادق
  bool get isAuthenticated => _service.isAuthenticated;
  
  /// هل جاري التحميل
  bool get isLoading => state.isLoading;
  
  /// آخر نتيجة عملية (للتوافق مع lastResponse)
  AuthResult? get lastResult => _lastResult;
  
  /// آخر استجابة من الخادم (للتوافق العكسي)
  Map<String, dynamic>? get lastResponse => _lastResult?.lastResponse;
  
  // ============================================================
  // التهيئة
  // ============================================================
  
  /// تهيئة المُزود
  Future<void> _initialize() async {
    debugPrint('🚀 [AuthNotifier] Initializing...');
    
    try {
      // تهيئة الخدمة
      await _service.initialize();
      
      // الاستماع لتغييرات الحالة
      _stateSubscription = _service.stateStream.listen((newState) {
        state = newState;
        debugPrint('📊 [AuthNotifier] State updated: ${newState.runtimeType}');
      });
      
      // تحديث الحالة الأولية
      state = _service.currentState;
      
      debugPrint('✅ [AuthNotifier] Initialized. Current state: ${state.runtimeType}');
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthNotifier] Initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      state = AuthState.error(message: 'فشل تهيئة المصادقة: $e');
    }
  }
  
  // ============================================================
  // تسجيل الدخول
  // ============================================================
  
  /// تسجيل الدخول بالهاتف وكلمة المرور
  Future<AuthResult> loginWithPhone(String phone, String password) async {
    debugPrint('🔐 [AuthNotifier] Login attempt for: $phone');
    
    final result = await _service.login(
      phone: phone,
      password: password,
    );
    
    _lastResult = result;
    debugPrint('📊 [AuthNotifier] Login result: ${result.type}');
    return result;
  }
  
  // ============================================================
  // التسجيل
  // ============================================================
  
  /// تسجيل مستخدم جديد
  Future<AuthResult> registerWithPhone(
    String phone,
    String password,
    String fullName,
    String email, {
    String? gender,
  }) async {
    debugPrint('📝 [AuthNotifier] Register attempt for: $phone');
    
    final result = await _service.register(
      phone: phone,
      password: password,
      fullName: fullName,
      email: email,
      gender: gender,
    );
    
    _lastResult = result;
    debugPrint('📊 [AuthNotifier] Register result: ${result.type}');
    return result;
  }
  
  // ============================================================
  // التحقق من OTP
  // ============================================================
  
  /// التحقق من رمز OTP
  Future<AuthResult> verifyOtp(
    String phone,
    String otp, {
    bool isLogin = false,
  }) async {
    debugPrint('🔢 [AuthNotifier] Verify OTP for: $phone');
    
    final result = await _service.verifyOtp(
      phone: phone,
      otp: otp,
      isLogin: isLogin,
    );
    
    _lastResult = result;
    debugPrint('📊 [AuthNotifier] Verify OTP result: ${result.type}');
    return result;
  }
  
  /// إعادة إرسال رمز OTP
  Future<AuthResult> resendOtp(String phone) async {
    debugPrint('📤 [AuthNotifier] Resend OTP for: $phone');
    final result = await _service.resendOtp(phone);
    _lastResult = result;
    return result;
  }
  
  // ============================================================
  // تسجيل الخروج
  // ============================================================
  
  /// تسجيل الخروج
  Future<void> logout() async {
    debugPrint('🚪 [AuthNotifier] Logout');
    await _service.logout();
  }
  
  /// تسجيل الخروج من جميع الأجهزة
  Future<void> logoutFromAllDevices() async {
    debugPrint('🚪 [AuthNotifier] Logout from all devices');
    await _service.logoutFromAllDevices();
  }
  
  // ============================================================
  // إعادة تعيين كلمة المرور
  // ============================================================
  
  /// طلب إعادة تعيين كلمة المرور
  Future<AuthResult> requestPasswordReset(String phone) async {
    debugPrint('🔑 [AuthNotifier] Request password reset for: $phone');
    final result = await _service.requestPasswordReset(phone);
    _lastResult = result;
    return result;
  }
  
  /// إعادة تعيين كلمة المرور
  Future<AuthResult> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    debugPrint('🔑 [AuthNotifier] Reset password for: $phone');
    final result = await _service.resetPassword(
      phone: phone,
      otp: otp,
      newPassword: newPassword,
    );
    _lastResult = result;
    return result;
  }
  
  // ============================================================
  // تحديث الحالة
  // ============================================================
  
  /// تحديث حالة المصادقة
  Future<void> refreshAuthState() async {
    debugPrint('🔄 [AuthNotifier] Refresh auth state');
    await _service.refreshAuthState();
  }
  
  /// مسح رسالة الخطأ
  void clearError() {
    debugPrint('🧹 [AuthNotifier] Clear error');
    _service.clearError();
  }
  
  // ============================================================
  // التخلص
  // ============================================================
  
  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
    debugPrint('🗑️ [AuthNotifier] Disposed');
  }
}

// ============================================================
// Providers إضافية للتوافق
// ============================================================

/// Provider للخدمة مباشرة (للاستخدامات المتقدمة)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

/// Stream provider للحالة
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return AuthService.instance.stateStream;
});
