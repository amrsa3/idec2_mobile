import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../models/user_model.dart';
import 'auth_exceptions.dart';
import 'auth_repository.dart';
import 'auth_state.dart';
import 'token_manager.dart';
import 'session_manager.dart';

/// خدمة المصادقة الموحدة
/// 
/// هذه الخدمة هي النقطة المركزية لجميع عمليات المصادقة:
/// - تسجيل الدخول والخروج
/// - التسجيل والتحقق من OTP
/// - إعادة تعيين كلمة المرور
/// - إدارة حالة المصادقة
/// 
/// الاستخدام:
/// ```dart
/// final authService = AuthService.instance;
/// 
/// // تسجيل الدخول
/// final result = await authService.login(phone: '777123456', password: '****');
/// if (result.isSuccess) {
///   print('مرحباً ${result.user?.fullName}');
/// }
/// 
/// // الاستماع لتغييرات الحالة
/// authService.stateStream.listen((state) {
///   state.when(
///     authenticated: (user, _) => print('مسجل دخول: ${user.fullName}'),
///     unauthenticated: (_) => print('غير مسجل'),
///     // ...
///   );
/// });
/// ```
class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  
  AuthService._();
  
  // ============================================================
  // التبعيات
  // ============================================================
  
  final _repository = AuthRepository.instance;
  final _tokenManager = TokenManager.instance;
  final _sessionManager = SessionManager.instance;
  
  // ============================================================
  // الحالة
  // ============================================================
  
  /// Stream controller للحالة
  final _stateController = StreamController<AuthState>.broadcast();
  
  /// الحالة الحالية
  AuthState _currentState = const AuthState.initial();
  
  /// المستخدم الحالي
  UserModel? _user;
  
  /// هل تم التهيئة
  bool _isInitialized = false;
  
  // ============================================================
  // Getters
  // ============================================================
  
  /// Stream للحالة
  Stream<AuthState> get stateStream => _stateController.stream;
  
  /// الحالة الحالية
  AuthState get currentState => _currentState;
  
  /// المستخدم الحالي
  UserModel? get user => _user;
  
  /// هل المستخدم مُصادق
  bool get isAuthenticated => _currentState.isAuthenticated;
  
  /// هل جاري التحميل
  bool get isLoading => _currentState.isLoading;
  
  /// هل تم التهيئة
  bool get isInitialized => _isInitialized;
  
  // ============================================================
  // التهيئة
  // ============================================================
  
  /// تهيئة الخدمة
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ [AuthService] Already initialized');
      return;
    }
    
    try {
      debugPrint('🚀 [AuthService] Initializing...');
      
      // تهيئة مدير التوكنات
      await _tokenManager.initialize();
      
      // تهيئة مدير الجلسات
      await _sessionManager.initialize();
      
      // محاولة استعادة الجلسة
      await _restoreSession();
      
      _isInitialized = true;
      debugPrint('✅ [AuthService] Initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthService] Initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateState(const AuthState.unauthenticated());
    }
  }
  
  /// التأكد من التهيئة
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  // ============================================================
  // تسجيل الدخول
  // ============================================================
  
  /// تسجيل الدخول بالهاتف وكلمة المرور
  Future<AuthResult> login({
    required String phone,
    required String password,
  }) async {
    await ensureInitialized();
    
    debugPrint('🔐 [AuthService] Login attempt for: $phone');
    _updateState(const AuthState.loading(message: 'جاري تسجيل الدخول...'));
    
    try {
      final response = await _repository.login(
        phone: phone,
        password: password,
      );
      
      return await _handleLoginResponse(response, phone);
    } on PhoneNotVerifiedException catch (e) {
      debugPrint('⚠️ [AuthService] Phone not verified: ${e.phone}');
      _updateState(AuthState.phoneNotVerified(
        phone: e.phone,
        message: e.message,
        otpSent: true,
      ));
      return AuthResult.phoneNotVerified(e.phone);
    } on AuthException catch (e) {
      debugPrint('❌ [AuthService] Login auth error: ${e.message}');
      _updateState(AuthState.error(message: e.message, code: e.code));
      return AuthResult.failure(e.message, code: e.code);
    } catch (e, stackTrace) {
      final error = 'فشل تسجيل الدخول: $e';
      debugPrint('❌ [AuthService] Login error: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateState(AuthState.error(message: error));
      return AuthResult.failure(error);
    }
  }
  
  // ============================================================
  // التسجيل
  // ============================================================
  
  /// تسجيل مستخدم جديد
  Future<AuthResult> register({
    required String phone,
    required String password,
    required String fullName,
    required String email,
    String? gender,
  }) async {
    await ensureInitialized();
    
    debugPrint('📝 [AuthService] Register attempt for: $phone');
    _updateState(const AuthState.loading(message: 'جاري التسجيل...'));
    
    try {
      final response = await _repository.register(
        phone: phone,
        password: password,
        fullName: fullName,
        email: email,
        gender: gender,
      );
      
      return _handleRegisterResponse(response, phone);
    } on AuthException catch (e) {
      debugPrint('❌ [AuthService] Register auth error: ${e.message}');
      _updateState(AuthState.error(message: e.message, code: e.code));
      return AuthResult.failure(e.message, code: e.code);
    } catch (e, stackTrace) {
      final error = 'فشل التسجيل: $e';
      debugPrint('❌ [AuthService] Register error: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateState(AuthState.error(message: error));
      return AuthResult.failure(error);
    }
  }
  
  // ============================================================
  // التحقق من OTP
  // ============================================================
  
  /// التحقق من رمز OTP
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
    bool isLogin = false,
  }) async {
    await ensureInitialized();
    
    debugPrint('🔢 [AuthService] Verify OTP for: $phone');
    _updateState(const AuthState.loading(message: 'جاري التحقق...'));
    
    try {
      final response = await _repository.verifyOtp(
        phone: phone,
        otp: otp,
        isLogin: isLogin,
      );
      
      return await _handleOtpVerificationResponse(response, isLogin);
    } on AuthException catch (e) {
      debugPrint('❌ [AuthService] Verify OTP auth error: ${e.message}');
      _updateState(AuthState.error(message: e.message, code: e.code));
      return AuthResult.failure(e.message, code: e.code);
    } catch (e, stackTrace) {
      final error = 'فشل التحقق: $e';
      debugPrint('❌ [AuthService] Verify OTP error: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateState(AuthState.error(message: error));
      return AuthResult.failure(error);
    }
  }
  
  /// إعادة إرسال رمز OTP
  Future<AuthResult> resendOtp(String phone) async {
    await ensureInitialized();
    
    debugPrint('📤 [AuthService] Resend OTP for: $phone');
    
    try {
      await _repository.resendOtp(phone);
      return AuthResult.success(message: 'تم إرسال رمز التحقق');
    } on AuthException catch (e) {
      return AuthResult.failure(e.message, code: e.code);
    } catch (e) {
      return AuthResult.failure('فشل إرسال رمز التحقق: $e');
    }
  }
  
  // ============================================================
  // تسجيل الخروج
  // ============================================================
  
  /// تسجيل الخروج
  Future<void> logout({bool silent = false}) async {
    await ensureInitialized();
    
    debugPrint('🚪 [AuthService] Logging out...');
    
    try {
      // مسح البيانات المحلية أولاً
      _user = null;
      
      // مسح التوكنات
      await _tokenManager.clearTokens();
      
      // إنهاء الجلسة
      await _sessionManager.clearSession();
      
      // إخطار الخادم (تجاهل الأخطاء)
      try {
        await _repository.logout();
      } catch (e) {
        debugPrint('⚠️ [AuthService] Server logout failed: $e');
      }
      
      _updateState(AuthState.unauthenticated(
        message: silent ? null : 'تم تسجيل الخروج بنجاح',
      ));
      
      debugPrint('✅ [AuthService] Logout completed');
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthService] Logout error: $e');
      debugPrint('Stack trace: $stackTrace');
      // حتى لو حدث خطأ، نحدث الحالة
      _updateState(const AuthState.unauthenticated());
    }
  }
  
  /// تسجيل الخروج من جميع الأجهزة
  Future<void> logoutFromAllDevices() async {
    await ensureInitialized();
    
    debugPrint('🚪 [AuthService] Logging out from all devices...');
    
    try {
      await _repository.logoutFromAllDevices();
    } catch (e) {
      debugPrint('⚠️ [AuthService] Server logout from all devices failed: $e');
    }
    
    await logout(silent: true);
  }
  
  // ============================================================
  // إعادة تعيين كلمة المرور
  // ============================================================
  
  /// طلب إعادة تعيين كلمة المرور
  Future<AuthResult> requestPasswordReset(String phone) async {
    await ensureInitialized();
    
    debugPrint('🔑 [AuthService] Request password reset for: $phone');
    
    try {
      await _repository.requestPasswordReset(phone);
      return AuthResult.success(message: 'تم إرسال رمز إعادة التعيين');
    } on AuthException catch (e) {
      return AuthResult.failure(e.message, code: e.code);
    } catch (e) {
      return AuthResult.failure('فشل طلب إعادة تعيين كلمة المرور: $e');
    }
  }
  
  /// إعادة تعيين كلمة المرور
  Future<AuthResult> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    await ensureInitialized();
    
    debugPrint('🔑 [AuthService] Reset password for: $phone');
    
    try {
      await _repository.resetPassword(
        phone: phone,
        otp: otp,
        newPassword: newPassword,
      );
      return AuthResult.success(message: 'تم تغيير كلمة المرور بنجاح');
    } on AuthException catch (e) {
      return AuthResult.failure(e.message, code: e.code);
    } catch (e) {
      return AuthResult.failure('فشل إعادة تعيين كلمة المرور: $e');
    }
  }
  
  // ============================================================
  // تحديث الحالة
  // ============================================================
  
  /// تحديث حالة المصادقة يدوياً
  Future<void> refreshAuthState() async {
    await ensureInitialized();
    
    debugPrint('🔄 [AuthService] Refreshing auth state...');
    
    try {
      // التحقق من صحة الجلسة
      final hasSession = await _tokenManager.hasValidSession();
      if (!hasSession) {
        _user = null;
        _updateState(const AuthState.unauthenticated());
        return;
      }
      
      // محاولة الحصول على بيانات المستخدم
      final userData = await _tokenManager.getUserData();
      if (userData != null) {
        try {
          final user = UserModel.fromJson(userData);
          _user = user;
          _updateState(AuthState.authenticated(user: user, isRefreshed: true));
          debugPrint('✅ [AuthService] Auth state refreshed');
        } catch (e) {
          debugPrint('⚠️ [AuthService] Failed to parse user data: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ [AuthService] Failed to refresh auth state: $e');
    }
  }
  
  /// مسح رسالة الخطأ
  void clearError() {
    if (_currentState.hasError) {
      _updateState(const AuthState.unauthenticated());
    }
  }
  
  // ============================================================
  // الدوال المساعدة الخاصة
  // ============================================================
  
  /// تحديث الحالة
  void _updateState(AuthState state) {
    _currentState = state;
    _stateController.add(state);
    debugPrint('📊 [AuthService] State updated: ${state.runtimeType}');
  }
  
  /// استعادة الجلسة عند بدء التطبيق
  Future<void> _restoreSession() async {
    try {
      debugPrint('🔄 [AuthService] Restoring session...');
      
      final hasSession = await _tokenManager.hasValidSession();
      if (!hasSession) {
        debugPrint('ℹ️ [AuthService] No valid session found');
        _updateState(const AuthState.unauthenticated());
        return;
      }
      
      final userData = await _tokenManager.getUserData();
      if (userData != null) {
        try {
          final user = UserModel.fromJson(userData);
          _user = user;
          
          // بدء جلسة جديدة
          await _sessionManager.startSession(userId: user.id.toString());
          
          _updateState(AuthState.authenticated(user: user));
          debugPrint('✅ [AuthService] Session restored for: ${user.phone}');
        } catch (e) {
          debugPrint('⚠️ [AuthService] Failed to parse stored user data: $e');
          _updateState(const AuthState.unauthenticated());
        }
      } else {
        debugPrint('ℹ️ [AuthService] No user data found');
        _updateState(const AuthState.unauthenticated());
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthService] Failed to restore session: $e');
      debugPrint('Stack trace: $stackTrace');
      _updateState(const AuthState.unauthenticated());
    }
  }
  
  /// معالجة استجابة تسجيل الدخول
  Future<AuthResult> _handleLoginResponse(
    Map<String, dynamic> response,
    String phone,
  ) async {
    final success = response['success'] == true;
    final data = response['data'] as Map<String, dynamic>?;
    final message = response['message'] as String?;
    
    // استخراج الرسائل متعددة اللغات
    final messageAr = response['messageAr'] as String?;
    final messageEn = response['messageEn'] as String?;
    
    // التحقق من الهاتف غير المُفعل
    if (!success) {
      if (response['phone_verified'] == false ||
          (message?.toLowerCase().contains('not verified') ?? false) ||
          (message?.contains('غير متحقق') ?? false) ||
          (message?.contains('غير مفعل') ?? false)) {
        _updateState(AuthState.phoneNotVerified(
          phone: phone,
          message: message ?? 'رقم الهاتف غير مُفعل',
          otpSent: true,
        ));
        return AuthResult.phoneNotVerified(
          phone,
          message: message,
          messageAr: messageAr,
          messageEn: messageEn,
          lastResponse: response,
        );
      }
      
      _updateState(AuthState.error(message: message ?? 'فشل تسجيل الدخول'));
      return AuthResult.failure(
        message ?? 'فشل تسجيل الدخول',
        messageAr: messageAr,
        messageEn: messageEn,
        lastResponse: response,
      );
    }
    
    // استخراج التوكنات
    final tokens = data?['tokens'] as Map<String, dynamic>? ??
        data?['token'] as Map<String, dynamic>?;
    
    if (tokens == null) {
      // ربما التوكنات في المستوى الأعلى
      final accessToken = data?['access_token'] as String?;
      final refreshToken = data?['refresh_token'] as String?;
      
      if (accessToken == null) {
        return AuthResult.failure('استجابة غير صالحة: لا توجد توكنات');
      }
      
      await _tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        expiresIn: data?['expires_in'] as int? ?? 3600,
        refreshExpiresIn: data?['refresh_expires_in'] as int?,
        userData: data?['user'] as Map<String, dynamic>?,
      );
    } else {
      final accessToken = (tokens['access_token'] ?? tokens['accessToken']) as String?;
      if (accessToken == null) {
        return AuthResult.failure('استجابة غير صالحة: لا يوجد توكن وصول');
      }

      await _tokenManager.saveTokens(
        accessToken: accessToken,
        refreshToken: (tokens['refresh_token'] ?? tokens['refreshToken']) as String? ?? '',
        expiresIn: tokens['expires_in'] as int? ?? 
            _extractExpiresIn(tokens) ?? 3600,
        refreshExpiresIn: tokens['refresh_expires_in'] as int? ??
            _extractRefreshExpiresIn(tokens),
        userData: data?['user'] as Map<String, dynamic>?,
      );
    }
    
    // استخراج بيانات المستخدم
    final userData = data?['user'] as Map<String, dynamic>?;
    if (userData != null) {
      try {
        final user = UserModel.fromJson(userData);
        _user = user;
        
        // بدء جلسة
        await _sessionManager.startSession(userId: user.id.toString());
        
        _updateState(AuthState.authenticated(user: user));
        return AuthResult.success(
          user: user, 
          message: 'تم تسجيل الدخول بنجاح',
          messageAr: messageAr ?? 'تم تسجيل الدخول بنجاح',
          messageEn: messageEn ?? 'Login successful',
          lastResponse: response,
        );
      } catch (e) {
        debugPrint('⚠️ [AuthService] Failed to parse user: $e');
      }
    }
    
    _updateState(const AuthState.unauthenticated());
    return AuthResult.failure('استجابة غير صالحة: لا توجد بيانات مستخدم');
  }
  
  /// معالجة استجابة التسجيل
  AuthResult _handleRegisterResponse(
    Map<String, dynamic> response,
    String phone,
  ) {
    final success = response['success'] == true;
    final message = response['message'] as String?;
    final messageAr = response['messageAr'] as String?;
    final messageEn = response['messageEn'] as String?;
    
    if (!success) {
      _updateState(AuthState.error(message: message ?? 'فشل التسجيل'));
      return AuthResult.failure(
        message ?? 'فشل التسجيل',
        messageAr: messageAr,
        messageEn: messageEn,
        lastResponse: response,
      );
    }
    
    // التسجيل ناجح، يحتاج تفعيل الهاتف
    _updateState(AuthState.phoneNotVerified(
      phone: phone,
      message: message ?? 'تم التسجيل بنجاح، يرجى تفعيل رقم الهاتف',
      otpSent: true,
    ));
    
    return AuthResult.otpSent(
      phone, 
      message: message,
      messageAr: messageAr ?? 'تم التسجيل بنجاح، يرجى تفعيل رقم الهاتف',
      messageEn: messageEn ?? 'Registration successful, please verify your phone',
      lastResponse: response,
    );
  }
  
  /// معالجة استجابة التحقق من OTP
  Future<AuthResult> _handleOtpVerificationResponse(
    Map<String, dynamic> response,
    bool isLogin,
  ) async {
    final success = response['success'] == true;
    final data = response['data'] as Map<String, dynamic>?;
    final message = response['message'] as String?;
    final messageAr = response['messageAr'] as String?;
    final messageEn = response['messageEn'] as String?;
    
    if (!success) {
      _updateState(AuthState.error(message: message ?? 'رمز التحقق غير صحيح'));
      return AuthResult.failure(
        message ?? 'رمز التحقق غير صحيح',
        messageAr: messageAr,
        messageEn: messageEn,
        lastResponse: response,
      );
    }
    
    // استخراج التوكنات (إذا موجودة)
    final tokens = data?['tokens'] as Map<String, dynamic>? ??
        data?['token'] as Map<String, dynamic>?;
    
    if (tokens != null) {
      await _tokenManager.saveTokens(
        accessToken: tokens['access_token'] as String,
        refreshToken: tokens['refresh_token'] as String? ?? '',
        expiresIn: tokens['expires_in'] as int? ?? 3600,
        refreshExpiresIn: tokens['refresh_expires_in'] as int?,
        userData: data?['user'] as Map<String, dynamic>?,
      );
    }
    
    // استخراج بيانات المستخدم
    final userData = data?['user'] as Map<String, dynamic>?;
    if (userData != null) {
      try {
        final user = UserModel.fromJson(userData);
        _user = user;
        
        // بدء جلسة
        await _sessionManager.startSession(userId: user.id.toString());
        
        _updateState(AuthState.authenticated(user: user));
        return AuthResult.success(
          user: user,
          message: message ?? 'تم التحقق بنجاح',
          messageAr: messageAr ?? 'تم التحقق بنجاح',
          messageEn: messageEn ?? 'Verification successful',
          lastResponse: response,
        );
      } catch (e) {
        debugPrint('⚠️ [AuthService] Failed to parse user: $e');
      }
    }
    
    return AuthResult.success(
      message: message ?? 'تم التحقق بنجاح',
      messageAr: messageAr ?? 'تم التحقق بنجاح',
      messageEn: messageEn ?? 'Verification successful',
      lastResponse: response,
    );
  }
  
  /// استخراج expiresIn من استجابة متنوعة
  int? _extractExpiresIn(Map<String, dynamic> tokens) {
    // محاولة قراءة من مفاتيح مختلفة
    final expiresIn = tokens['expires_in'];
    if (expiresIn is int) return expiresIn;
    if (expiresIn is String) return int.tryParse(expiresIn);
    
    final expiresAt = tokens['expires_at'];
    if (expiresAt is int) {
      // تحويل timestamp إلى ثواني من الآن
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expiresAt - now;
    }
    
    return null;
  }
  
  /// استخراج refreshExpiresIn
  int? _extractRefreshExpiresIn(Map<String, dynamic> tokens) {
    final refreshExpiresIn = tokens['refresh_expires_in'];
    if (refreshExpiresIn is int) return refreshExpiresIn;
    if (refreshExpiresIn is String) return int.tryParse(refreshExpiresIn);
    return null;
  }
  
  // ============================================================
  // التخلص
  // ============================================================
  
  /// التخلص من الموارد
  void dispose() {
    _stateController.close();
    _isInitialized = false;
    debugPrint('🗑️ [AuthService] Disposed');
  }
  
  /// إعادة تعيين الـ instance (للاختبارات)
  @visibleForTesting
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}

// ============================================================
// نتيجة عملية المصادقة
// ============================================================

/// نتيجة عملية المصادقة
class AuthResult {
  /// هل نجحت العملية
  final bool isSuccess;
  
  /// رسالة (نجاح أو خطأ)
  final String? message;
  
  /// رسالة بالعربية (من الخادم)
  final String? messageAr;
  
  /// رسالة بالإنجليزية (من الخادم)
  final String? messageEn;
  
  /// كود الخطأ (إذا فشلت)
  final String? code;
  
  /// المستخدم (إذا نجحت وأرجعت مستخدم)
  final UserModel? user;
  
  /// رقم الهاتف (للحالات التي تحتاج OTP)
  final String? phone;
  
  /// نوع النتيجة
  final AuthResultType type;
  
  /// الاستجابة الكاملة من الخادم (للتوافق مع الكود القديم)
  final Map<String, dynamic>? lastResponse;
  
  const AuthResult._({
    required this.isSuccess,
    required this.type,
    this.message,
    this.messageAr,
    this.messageEn,
    this.code,
    this.user,
    this.phone,
    this.lastResponse,
  });
  
  /// نتيجة ناجحة
  factory AuthResult.success({
    String? message, 
    UserModel? user,
    String? messageAr,
    String? messageEn,
    Map<String, dynamic>? lastResponse,
  }) {
    return AuthResult._(
      isSuccess: true,
      type: AuthResultType.success,
      message: message,
      messageAr: messageAr,
      messageEn: messageEn,
      user: user,
      lastResponse: lastResponse,
    );
  }
  
  /// نتيجة فاشلة
  factory AuthResult.failure(
    String message, {
    String? code,
    String? messageAr,
    String? messageEn,
    Map<String, dynamic>? lastResponse,
  }) {
    return AuthResult._(
      isSuccess: false,
      type: AuthResultType.failure,
      message: message,
      messageAr: messageAr,
      messageEn: messageEn,
      code: code,
      lastResponse: lastResponse,
    );
  }
  
  /// الهاتف غير مُفعل
  factory AuthResult.phoneNotVerified(
    String phone, {
    String? message,
    String? messageAr,
    String? messageEn,
    Map<String, dynamic>? lastResponse,
  }) {
    return AuthResult._(
      isSuccess: false,
      type: AuthResultType.phoneNotVerified,
      phone: phone,
      message: message ?? 'رقم الهاتف غير مُفعل',
      messageAr: messageAr,
      messageEn: messageEn,
      lastResponse: lastResponse,
    );
  }
  
  /// تم إرسال OTP
  factory AuthResult.otpSent(
    String phone, {
    String? message,
    String? messageAr,
    String? messageEn,
    Map<String, dynamic>? lastResponse,
  }) {
    return AuthResult._(
      isSuccess: true,
      type: AuthResultType.otpSent,
      phone: phone,
      message: message ?? 'تم إرسال رمز التحقق',
      messageAr: messageAr,
      messageEn: messageEn,
      lastResponse: lastResponse,
    );
  }
  
  /// الحصول على الرسالة حسب اللغة
  String? getLocalizedMessage(String languageCode) {
    if (languageCode == 'ar' && messageAr != null && messageAr!.isNotEmpty) {
      return messageAr;
    }
    if (messageEn != null && messageEn!.isNotEmpty) {
      return messageEn;
    }
    return message;
  }
  
  @override
  String toString() => 'AuthResult(success: $isSuccess, type: $type, message: $message)';
}

/// أنواع نتائج المصادقة
enum AuthResultType {
  /// نجاح عام
  success,
  
  /// فشل عام
  failure,
  
  /// الهاتف غير مُفعل
  phoneNotVerified,
  
  /// تم إرسال OTP
  otpSent,
}
