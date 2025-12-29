# 🔐 خطة إصلاح وتوحيد نظام المصادقة الشاملة

**التاريخ:** 29 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** جاهزة للتنفيذ  
**الأولوية:** عالية جداً

---

## 📋 ملخص تنفيذي

نظام المصادقة الحالي يعاني من **تكرار كبير** و**تشتت في الكود** مع وجود 8+ ملفات
خدمات و4+ مُزودات مختلفة. هذه الخطة تهدف إلى **توحيد النظام** بشكل كامل مع
الحفاظ على **التوافق العكسي** وتقليل **المخاطر**.

---

## 🎯 الأهداف الرئيسية

| #   | الهدف                  | النتيجة المتوقعة          |
| --- | ---------------------- | ------------------------- |
| 1   | توحيد خدمات المصادقة   | ملف واحد بدلاً من 4       |
| 2   | توحيد إدارة التوكنات   | مدير واحد بدلاً من 3      |
| 3   | توحيد مُزودات المصادقة | مُزود واحد بدلاً من 4     |
| 4   | تحسين الأداء           | تقليل 70% من كود المصادقة |
| 5   | تبسيط الصيانة          | واجهة موحدة وواضحة        |

---

## 📊 تحليل الوضع الحالي

### ملفات الخدمات (Services) - 8 ملفات

```
lib/services/
├── auth_service.dart              [47KB] - Auth الأصلي مع Retrofit
├── compatible_auth_service.dart   [71KB] - المستخدم الرئيسي حالياً ⭐
├── unified_auth_service.dart      [24KB] - استخدام محدود
├── auth_facade.dart               [13KB] - واجهة موحدة (غير مستخدمة فعلياً)
├── unified_token_manager.dart     [36KB] - مستخدم بكثرة ⭐
├── secure_token_manager.dart      [14KB] - استخدام محدود
├── session_manager.dart           [14KB] - استخدام محدود
├── enhanced_session_manager.dart  [27KB] - مستخدم ⭐
└── silent_token_refresh_service.dart [16KB] - استخدام محدود
```

### ملفات المُزودات (Providers) - 4 ملفات

```
lib/providers/
├── enhanced_auth_provider.dart     [8KB] - 11 ملف يستخدمه
├── enhanced_auth_provider_v2.dart  [8KB] - مستخدم في main.dart ⭐
├── universal_auth_provider.dart    [13KB] - غير مستخدم
└── web_auth_provider.dart          [22KB] - استخدام محدود
```

### خريطة الاستخدام الفعلي

| المكون                   | عدد الملفات المستخدمة | الحالة                   |
| ------------------------ | --------------------- | ------------------------ |
| `compatibleAuthProvider` | **19**                | الأكثر استخداماً         |
| `enhancedAuthProvider`   | **11**                | مستخدم في main.dart      |
| `UnifiedTokenManager`    | **متعدد**             | الخدمة الأساسية للتوكنات |
| `EnhancedSessionManager` | **متعدد**             | الخدمة الأساسية للجلسات  |

---

## 🏗️ هيكل النظام الجديد المقترح

### المرحلة النهائية (Target Architecture)

```
lib/
├── core/
│   └── auth/
│       ├── auth_service.dart         # خدمة المصادقة الموحدة
│       ├── auth_provider.dart        # المُزود الموحد
│       ├── auth_state.dart           # حالات المصادقة
│       ├── auth_repository.dart      # عمليات API
│       ├── token_manager.dart        # إدارة التوكنات الموحدة
│       ├── session_manager.dart      # إدارة الجلسات الموحدة
│       ├── auth_exceptions.dart      # استثناءات مخصصة
│       └── auth_compat.dart          # طبقة التوافق (مؤقتة)
│
├── services/                         # الملفات الأخرى (غير auth)
└── providers/                        # المُزودات الأخرى (غير auth)
```

---

## 📅 خطة التنفيذ المرحلية

### 🔹 المرحلة 0: التحضير (يوم 1)

#### المهام:

- [ ] **0.1** إنشاء نسخة احتياطية كاملة
- [ ] **0.2** إنشاء branch جديد: `refactor/unified-auth`
- [ ] **0.3** توثيق جميع نقاط الاستدعاء الحالية
- [ ] **0.4** إنشاء اختبارات للوظائف الحالية (baseline tests)

#### الملفات المتأثرة:

```
لا تغييرات على الكود الحالي
```

---

### 🔹 المرحلة 1: إنشاء البنية الجديدة (يوم 2-3)

#### 1.1 إنشاء `AuthState` الموحد

```dart
/// lib/core/auth/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserModel user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.phoneNotVerified({
    required String phone,
    String? message,
  }) = AuthPhoneNotVerified;
  const factory AuthState.error(String message) = AuthError;
  const factory AuthState.sessionExpired() = AuthSessionExpired;
}
```

#### 1.2 إنشاء `AuthExceptions`

```dart
/// lib/core/auth/auth_exceptions.dart
abstract class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String message = 'Invalid credentials'])
      : super(message, code: 'INVALID_CREDENTIALS');
}

class PhoneNotVerifiedException extends AuthException {
  final String phone;
  const PhoneNotVerifiedException(this.phone)
      : super('Phone not verified', code: 'PHONE_NOT_VERIFIED');
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException([String message = 'Session expired'])
      : super(message, code: 'SESSION_EXPIRED');
}

class TokenRefreshException extends AuthException {
  const TokenRefreshException([String message = 'Token refresh failed'])
      : super(message, code: 'TOKEN_REFRESH_FAILED');
}

class NetworkException extends AuthException {
  const NetworkException([String message = 'Network error'])
      : super(message, code: 'NETWORK_ERROR');
}
```

#### 1.3 إنشاء `TokenManager` الموحد

```dart
/// lib/core/auth/token_manager.dart
/// يجمع من: unified_token_manager.dart + secure_token_manager.dart

class TokenManager {
  static TokenManager? _instance;
  static TokenManager get instance => _instance ??= TokenManager._();

  TokenManager._();

  // Delegate to existing UnifiedTokenManager for now
  final _delegate = UnifiedTokenManager.instance;

  /// Initialize the token manager
  Future<void> initialize() => _delegate.initialize();

  /// Save tokens securely
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    int? refreshExpiresIn,
    String? sessionId,
    Map<String, dynamic>? userData,
  }) => _delegate.saveTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
    refreshExpiresIn: refreshExpiresIn,
    sessionId: sessionId,
    userData: userData,
  );

  /// Get valid access token (auto-refresh if needed)
  Future<String?> getValidAccessToken() => _delegate.getValidAccessToken();

  /// Check if access token is valid
  Future<bool> isAccessTokenValid() => _delegate.isAccessTokenValid();

  /// Check if refresh token is valid
  Future<bool> hasValidRefreshToken() => _delegate.hasValidRefreshToken();

  /// Refresh access token
  Future<bool> refreshAccessToken() => _delegate.refreshAccessToken();

  /// Clear all tokens
  Future<void> clearTokens() => _delegate.clearTokens();

  /// Get session events stream
  Stream<SessionEvent> get sessionEvents => _delegate.sessionEvents;

  /// Check if there's a valid session
  Future<bool> hasValidSession() => _delegate.hasValidSession();

  /// Dispose resources
  void dispose() => _delegate.dispose();
}
```

#### 1.4 إنشاء `AuthRepository`

```dart
/// lib/core/auth/auth_repository.dart
/// يتعامل مع API فقط

import 'package:dio/dio.dart';
import '../../services/enhanced_dio_service_v2.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  static AuthRepository? _instance;
  static AuthRepository get instance => _instance ??= AuthRepository._();

  AuthRepository._();

  Dio get _dio => EnhancedDioServiceV2.instance.dio;

  /// Login with phone and password
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.login,
      data: {'phone': phone, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String phone,
    required String password,
    required String fullName,
    required String email,
    String? gender,
  }) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.register,
      data: {
        'phone': phone,
        'password': password,
        'full_name': fullName,
        'email': email,
        if (gender != null) 'gender': gender,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.verifyOtp,
      data: {'phone': phone, 'otp': otp},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Resend OTP
  Future<Map<String, dynamic>> resendOtp(String phone) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.resendOtp,
      data: {'phone': phone},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Logout
  Future<void> logout() async {
    await _dio.post(ApiConstants.authEndpoints.logout);
  }

  /// Request password reset
  Future<Map<String, dynamic>> requestPasswordReset(String phone) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.forgotPassword,
      data: {'phone': phone},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.resetPassword,
      data: {
        'phone': phone,
        'otp': otp,
        'password': newPassword,
        'password_confirmation': newPassword,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Refresh token
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.authEndpoints.refresh,
      data: {'refresh_token': refreshToken},
    );
    return response.data as Map<String, dynamic>;
  }
}
```

---

### 🔹 المرحلة 2: إنشاء خدمة المصادقة الموحدة (يوم 4-5)

```dart
/// lib/core/auth/auth_service.dart
/// الخدمة الموحدة للمصادقة

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import 'auth_exceptions.dart';
import 'auth_repository.dart';
import 'auth_state.dart';
import 'token_manager.dart';
import '../session_manager.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  // Dependencies
  final _repository = AuthRepository.instance;
  final _tokenManager = TokenManager.instance;
  final _sessionManager = EnhancedSessionManager.instance;

  // State
  final _stateController = StreamController<AuthState>.broadcast();
  AuthState _currentState = const AuthState.initial();
  UserModel? _user;
  bool _isInitialized = false;

  // Getters
  Stream<AuthState> get stateStream => _stateController.stream;
  AuthState get currentState => _currentState;
  UserModel? get user => _user;
  bool get isAuthenticated => _currentState is AuthAuthenticated;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _tokenManager.initialize();
      await _restoreSession();
      _isInitialized = true;
      debugPrint('✅ [AuthService] Initialized successfully');
    } catch (e) {
      debugPrint('❌ [AuthService] Initialization failed: $e');
      _updateState(const AuthState.unauthenticated());
    }
  }

  /// Login with phone and password
  Future<AuthResult> login({
    required String phone,
    required String password,
  }) async {
    _updateState(const AuthState.loading());

    try {
      final response = await _repository.login(
        phone: phone,
        password: password,
      );

      return await _handleLoginResponse(response, phone);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      final error = 'Login failed: $e';
      _updateState(AuthState.error(error));
      return AuthResult.failure(error);
    }
  }

  /// Register new user
  Future<AuthResult> register({
    required String phone,
    required String password,
    required String fullName,
    required String email,
    String? gender,
  }) async {
    _updateState(const AuthState.loading());

    try {
      final response = await _repository.register(
        phone: phone,
        password: password,
        fullName: fullName,
        email: email,
        gender: gender,
      );

      return _handleRegisterResponse(response, phone);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      final error = 'Registration failed: $e';
      _updateState(AuthState.error(error));
      return AuthResult.failure(error);
    }
  }

  /// Verify OTP
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
    bool isLogin = false,
  }) async {
    _updateState(const AuthState.loading());

    try {
      final response = await _repository.verifyOtp(
        phone: phone,
        otp: otp,
      );

      return await _handleOtpVerificationResponse(response, isLogin);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      final error = 'OTP verification failed: $e';
      _updateState(AuthState.error(error));
      return AuthResult.failure(error);
    }
  }

  /// Resend OTP
  Future<AuthResult> resendOtp(String phone) async {
    try {
      await _repository.resendOtp(phone);
      return AuthResult.success(message: 'OTP sent successfully');
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResult.failure('Failed to resend OTP: $e');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Clear local data first
      _user = null;
      await _tokenManager.clearTokens();
      await _sessionManager.clearSession();

      // Try to logout from server (ignore errors)
      try {
        await _repository.logout();
      } catch (e) {
        debugPrint('⚠️ [AuthService] Server logout failed: $e');
      }

      _updateState(const AuthState.unauthenticated());
      debugPrint('✅ [AuthService] Logout completed');
    } catch (e) {
      debugPrint('❌ [AuthService] Logout error: $e');
      // Still update state to unauthenticated
      _updateState(const AuthState.unauthenticated());
    }
  }

  /// Request password reset
  Future<AuthResult> requestPasswordReset(String phone) async {
    try {
      await _repository.requestPasswordReset(phone);
      return AuthResult.success(message: 'Password reset OTP sent');
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResult.failure('Failed to request password reset: $e');
    }
  }

  /// Reset password
  Future<AuthResult> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _repository.resetPassword(
        phone: phone,
        otp: otp,
        newPassword: newPassword,
      );
      return AuthResult.success(message: 'Password reset successfully');
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return AuthResult.failure('Failed to reset password: $e');
    }
  }

  /// Refresh auth state
  Future<void> refreshAuthState() async {
    // Re-check session validity
    final hasSession = await _tokenManager.hasValidSession();
    if (!hasSession) {
      _updateState(const AuthState.unauthenticated());
      return;
    }

    // Try to get user data
    final userData = await _tokenManager.getUserData();
    if (userData != null) {
      try {
        final user = UserModel.fromJson(userData);
        _user = user;
        _updateState(AuthState.authenticated(user));
      } catch (e) {
        debugPrint('⚠️ [AuthService] Failed to parse user data: $e');
      }
    }
  }

  // Private helpers

  void _updateState(AuthState state) {
    _currentState = state;
    _stateController.add(state);
  }

  Future<void> _restoreSession() async {
    try {
      final hasSession = await _tokenManager.hasValidSession();
      if (!hasSession) {
        _updateState(const AuthState.unauthenticated());
        return;
      }

      final userData = await _tokenManager.getUserData();
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        _user = user;
        _updateState(AuthState.authenticated(user));
        debugPrint('✅ [AuthService] Session restored for: ${user.phone}');
      } else {
        _updateState(const AuthState.unauthenticated());
      }
    } catch (e) {
      debugPrint('❌ [AuthService] Failed to restore session: $e');
      _updateState(const AuthState.unauthenticated());
    }
  }

  Future<AuthResult> _handleLoginResponse(
    Map<String, dynamic> response,
    String phone,
  ) async {
    final success = response['success'] == true;
    final data = response['data'] as Map<String, dynamic>?;

    if (!success) {
      // Check for phone not verified
      final message = response['message'] as String? ?? 'Login failed';
      if (message.contains('not verified') ||
          response['phone_verified'] == false) {
        _updateState(AuthState.phoneNotVerified(phone: phone));
        return AuthResult.phoneNotVerified(phone);
      }

      _updateState(AuthState.error(message));
      return AuthResult.failure(message);
    }

    // Extract tokens
    final tokens = data?['tokens'] as Map<String, dynamic>?;
    if (tokens == null) {
      return AuthResult.failure('Invalid response: missing tokens');
    }

    // Save tokens
    await _tokenManager.saveTokens(
      accessToken: tokens['access_token'] as String,
      refreshToken: tokens['refresh_token'] as String,
      expiresIn: tokens['expires_in'] as int? ?? 3600,
      refreshExpiresIn: tokens['refresh_expires_in'] as int?,
      userData: data?['user'] as Map<String, dynamic>?,
    );

    // Parse user
    final userData = data?['user'] as Map<String, dynamic>?;
    if (userData != null) {
      final user = UserModel.fromJson(userData);
      _user = user;
      _updateState(AuthState.authenticated(user));
      return AuthResult.success(user: user);
    }

    return AuthResult.failure('Invalid response: missing user data');
  }

  AuthResult _handleRegisterResponse(
    Map<String, dynamic> response,
    String phone,
  ) {
    final success = response['success'] == true;

    if (!success) {
      final message = response['message'] as String? ?? 'Registration failed';
      _updateState(AuthState.error(message));
      return AuthResult.failure(message);
    }

    // Registration successful, need OTP verification
    _updateState(AuthState.phoneNotVerified(phone: phone));
    return AuthResult.otpSent(phone);
  }

  Future<AuthResult> _handleOtpVerificationResponse(
    Map<String, dynamic> response,
    bool isLogin,
  ) async {
    final success = response['success'] == true;
    final data = response['data'] as Map<String, dynamic>?;

    if (!success) {
      final message = response['message'] as String? ?? 'OTP verification failed';
      _updateState(AuthState.error(message));
      return AuthResult.failure(message);
    }

    // Extract tokens
    final tokens = data?['tokens'] as Map<String, dynamic>?;
    if (tokens != null) {
      await _tokenManager.saveTokens(
        accessToken: tokens['access_token'] as String,
        refreshToken: tokens['refresh_token'] as String,
        expiresIn: tokens['expires_in'] as int? ?? 3600,
        refreshExpiresIn: tokens['refresh_expires_in'] as int?,
        userData: data?['user'] as Map<String, dynamic>?,
      );
    }

    // Parse user
    final userData = data?['user'] as Map<String, dynamic>?;
    if (userData != null) {
      final user = UserModel.fromJson(userData);
      _user = user;
      _updateState(AuthState.authenticated(user));
      return AuthResult.success(user: user);
    }

    return AuthResult.success(message: 'OTP verified successfully');
  }

  AuthResult _handleDioError(DioException e) {
    final response = e.response;
    String message = 'Network error';

    if (response != null) {
      final data = response.data as Map<String, dynamic>?;
      message = data?['message'] as String? ?? 'Request failed';

      // Check for specific error codes
      if (response.statusCode == 401) {
        message = 'Invalid credentials';
      } else if (response.statusCode == 422) {
        // Validation error
        final errors = data?['errors'] as Map<String, dynamic>?;
        if (errors != null && errors.isNotEmpty) {
          message = errors.values.first.toString();
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'Connection failed';
    }

    _updateState(AuthState.error(message));
    return AuthResult.failure(message);
  }

  void dispose() {
    _stateController.close();
  }
}

/// Result of authentication operations
class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? phone;
  final AuthResultType type;

  const AuthResult._({
    required this.success,
    this.message,
    this.user,
    this.phone,
    required this.type,
  });

  factory AuthResult.success({String? message, UserModel? user}) {
    return AuthResult._(
      success: true,
      message: message,
      user: user,
      type: AuthResultType.success,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(
      success: false,
      message: message,
      type: AuthResultType.failure,
    );
  }

  factory AuthResult.phoneNotVerified(String phone) {
    return AuthResult._(
      success: false,
      phone: phone,
      message: 'Phone not verified',
      type: AuthResultType.phoneNotVerified,
    );
  }

  factory AuthResult.otpSent(String phone) {
    return AuthResult._(
      success: true,
      phone: phone,
      message: 'OTP sent',
      type: AuthResultType.otpSent,
    );
  }
}

enum AuthResultType {
  success,
  failure,
  phoneNotVerified,
  otpSent,
}
```

---

### 🔹 المرحلة 3: إنشاء المُزود الموحد (يوم 6)

```dart
/// lib/core/auth/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import 'auth_state.dart';
import '../../models/user_model.dart';

/// Main auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Computed: Is user authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
});

/// Computed: Current user
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
});

/// Computed: Is loading
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthLoading;
});

/// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final _service = AuthService.instance;

  AuthNotifier() : super(const AuthState.initial()) {
    _initialize();
  }

  UserModel? get user => _service.user;

  Future<void> _initialize() async {
    await _service.initialize();
    _service.stateStream.listen((newState) {
      state = newState;
    });
    state = _service.currentState;
  }

  Future<AuthResult> loginWithPhone(String phone, String password) {
    return _service.login(phone: phone, password: password);
  }

  Future<AuthResult> registerWithPhone(
    String phone,
    String password,
    String fullName,
    String email, {
    String? gender,
  }) {
    return _service.register(
      phone: phone,
      password: password,
      fullName: fullName,
      email: email,
      gender: gender,
    );
  }

  Future<AuthResult> verifyOtp(String phone, String otp, {bool isLogin = false}) {
    return _service.verifyOtp(phone: phone, otp: otp, isLogin: isLogin);
  }

  Future<AuthResult> resendOtp(String phone) {
    return _service.resendOtp(phone);
  }

  Future<void> logout() {
    return _service.logout();
  }

  Future<AuthResult> requestPasswordReset(String phone) {
    return _service.requestPasswordReset(phone);
  }

  Future<AuthResult> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) {
    return _service.resetPassword(
      phone: phone,
      otp: otp,
      newPassword: newPassword,
    );
  }

  Future<void> refreshAuthState() {
    return _service.refreshAuthState();
  }

  void clearError() {
    if (state is AuthError) {
      state = const AuthState.unauthenticated();
    }
  }
}
```

---

### 🔹 المرحلة 4: طبقة التوافق (يوم 7)

```dart
/// lib/core/auth/auth_compat.dart
/// طبقة توافق للكود القديم أثناء فترة الترحيل

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'auth_state.dart';
import '../../models/user_model.dart';
import '../../services/compatible_auth_service.dart';

/// Compatibility layer for old compatibleAuthProvider
/// TODO: Migrate all usages to authProvider and remove this
@Deprecated('Use authProvider instead')
final compatibleAuthProviderLegacy = Provider<CompatibleAuthState>((ref) {
  final state = ref.watch(authProvider);
  return _convertToCompatibleState(state, ref);
});

CompatibleAuthState _convertToCompatibleState(AuthState state, Ref ref) {
  return state.when(
    initial: () => CompatibleAuthState(
      isLoading: false,
      isAuthenticated: false,
    ),
    loading: () => CompatibleAuthState(
      isLoading: true,
      isAuthenticated: false,
    ),
    authenticated: (user) => CompatibleAuthState(
      isLoading: false,
      isAuthenticated: true,
      user: user,
    ),
    unauthenticated: () => CompatibleAuthState(
      isLoading: false,
      isAuthenticated: false,
    ),
    phoneNotVerified: (phone, message) => CompatibleAuthState(
      isLoading: false,
      isAuthenticated: false,
      unverifiedPhoneNumber: phone,
      error: message,
    ),
    error: (message) => CompatibleAuthState(
      isLoading: false,
      isAuthenticated: false,
      error: message,
    ),
    sessionExpired: () => CompatibleAuthState(
      isLoading: false,
      isAuthenticated: false,
      sessionExpired: true,
    ),
  );
}

/// State class for compatibility
class CompatibleAuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;
  final String? unverifiedPhoneNumber;
  final bool sessionExpired;

  const CompatibleAuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.user,
    this.error,
    this.unverifiedPhoneNumber,
    this.sessionExpired = false,
  });
}
```

---

### 🔹 المرحلة 5: ترحيل الشاشات (يوم 8-10)

#### ترتيب الترحيل حسب المخاطر:

**🟢 مخاطر منخفضة (الأولوية 1):** | الملف | الاستخدام الحالي | التحديث المطلوب |
|-------|-----------------|-----------------| | `home_screen_old.dart` |
compatibleAuthProvider | → authProvider | | `profile_main_screen.dart` |
compatibleAuthProvider | → currentUserProvider | | `app_drawer.dart` |
enhancedAuthProvider | → authProvider | | `profile_side_drawer.dart` |
compatibleAuthProvider | → currentUserProvider |

**🟡 مخاطر متوسطة (الأولوية 2):** | الملف | الاستخدام الحالي | التحديث المطلوب |
|-------|-----------------|-----------------| | `login_screen.dart` |
compatibleAuthProvider | → authProvider.notifier | | `register_screen.dart` |
compatibleAuthProvider | → authProvider.notifier | |
`otp_verification_screen.dart` | compatibleAuthProvider | →
authProvider.notifier | | `forgot_password_screen.dart` | compatibleAuthProvider
| → authProvider.notifier | | `reset_password_screen.dart` |
compatibleAuthProvider | → authProvider.notifier |

**🔴 مخاطر عالية (الأولوية 3):** | الملف | الاستخدام الحالي | التحديث المطلوب |
|-------|-----------------|-----------------| | `main.dart` |
enhancedAuthProvider | → authProvider | | `app_router.dart` |
compatibleAuthProvider | → authProvider | | `push_notification_service.dart` |
متعدد | → AuthService.instance | | `splash_screen.dart` | enhancedAuthProvider |
→ authProvider |

---

### 🔹 المرحلة 6: التنظيف النهائي (يوم 11-12)

#### الملفات المراد حذفها:

```powershell
# Services to delete (after migration complete)
lib/services/auth_service.dart           # → merged into core/auth/
lib/services/compatible_auth_service.dart # → replaced by core/auth/
lib/services/unified_auth_service.dart    # → replaced
lib/services/auth_facade.dart             # → replaced
lib/services/secure_token_manager.dart    # → merged into TokenManager
lib/services/session_manager.dart         # → merged into SessionManager
lib/services/silent_token_refresh_service.dart # → integrated

# Providers to delete
lib/providers/enhanced_auth_provider.dart     # → replaced by authProvider
lib/providers/enhanced_auth_provider_v2.dart  # → replaced
lib/providers/universal_auth_provider.dart    # → deleted
lib/providers/web_auth_provider.dart          # → deleted
```

---

## 📊 مقارنة قبل وبعد

| المعيار             | قبل       | بعد    | التحسن |
| ------------------- | --------- | ------ | ------ |
| عدد ملفات Services  | 8         | 4      | -50%   |
| عدد ملفات Providers | 4         | 1      | -75%   |
| إجمالي سطور الكود   | ~10,000   | ~2,500 | -75%   |
| التكرار في الكود    | عالي جداً | منعدم  | ✅     |
| سهولة الصيانة       | صعبة      | سهلة   | ✅     |
| وضوح الواجهة        | مفرقة     | موحدة  | ✅     |
| اختبار الكود        | صعب       | سهل    | ✅     |

---

## ⚠️ المخاطر والتحفظات

### المخاطر العالية:

1. **كسر الوظائف الموجودة** - يحتاج اختبار دقيق
2. **فقدان الجلسات النشطة** - يحتاج ترحيل سلس
3. **تأثير على المستخدمين** - يحتاج إصدار تدريجي

### استراتيجيات التخفيف:

| المخاطرة         | الحل                           |
| ---------------- | ------------------------------ |
| كسر الوظائف      | طبقة توافق + اختبارات شاملة    |
| فقدان الجلسات    | ترحيل بيانات التوكن + fallback |
| تأثير المستخدمين | إصدار beta أولاً               |
| أخطاء غير متوقعة | git tag قبل كل مرحلة           |

---

## 🔧 أوامر التنفيذ

```powershell
# إنشاء branch جديد
git checkout -b refactor/unified-auth

# إنشاء هيكل المجلدات
mkdir -p lib/core/auth

# تشغيل الاختبارات بعد كل تغيير
flutter test

# Build للتأكد من عدم وجود أخطاء
flutter build apk --debug

# Build للويب
flutter build web
```

---

## 📋 قائمة التحقق (Checklist)

### المرحلة 0: التحضير

- [ ] إنشاء نسخة احتياطية
- [ ] إنشاء branch جديد
- [ ] توثيق الاستخدامات الحالية
- [ ] كتابة اختبارات baseline

### المرحلة 1: البنية الجديدة

- [ ] إنشاء `lib/core/auth/` directory
- [ ] إنشاء `auth_state.dart`
- [ ] إنشاء `auth_exceptions.dart`
- [ ] إنشاء `token_manager.dart`
- [ ] إنشاء `auth_repository.dart`
- [ ] تشغيل build command

### المرحلة 2: خدمة المصادقة

- [ ] إنشاء `auth_service.dart`
- [ ] تنفيذ كل الوظائف
- [ ] اختبار العمليات الأساسية

### المرحلة 3: المُزود الموحد

- [ ] إنشاء `auth_provider.dart`
- [ ] إنشاء providers المشتقة
- [ ] اختبار التكامل

### المرحلة 4: طبقة التوافق

- [ ] إنشاء `auth_compat.dart`
- [ ] ربط مع الكود القديم

### المرحلة 5: ترحيل الشاشات

- [ ] ترحيل شاشات المخاطر المنخفضة
- [ ] اختبار
- [ ] ترحيل شاشات المخاطر المتوسطة
- [ ] اختبار
- [ ] ترحيل شاشات المخاطر العالية
- [ ] اختبار شامل

### المرحلة 6: التنظيف

- [ ] حذف الملفات القديمة
- [ ] تحديث التوثيق
- [ ] إضافة اختبارات الوحدة
- [ ] Merge to main

---

## 📞 جهات الاتصال

- **مسؤول التنفيذ:** فريق التطوير
- **المراجع:** Lead Developer
- **تاريخ البدء المقترح:** فوراً

---

_تم إنشاء هذه الخطة في 29 ديسمبر 2025_
