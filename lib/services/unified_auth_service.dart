import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../models/auth_models.dart';
import 'connectivity_service.dart';
import 'enhanced_dio_service_v2.dart';
import 'offline_storage_service.dart';
import 'platform_storage_service.dart';
import 'secure_token_manager.dart';
import 'session_manager.dart';

/// نظام مصادقة موحد ومحسن يدعم جميع المنصات
/// يدعم وضع عدم الاتصال وتحسين تجربة المستخدم
class UnifiedAuthService {
  static UnifiedAuthService? _instance;
  static UnifiedAuthService get instance =>
      _instance ??= UnifiedAuthService._internal();

  late Dio _dio;
  late PlatformStorageService _storage;
  late OfflineStorageService _offlineStorage;
  late SecureTokenManager _tokenManager;
  late SessionManager _sessionManager;
  late ConnectivityService _connectivityService;

  // Stream controllers for real-time updates
  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>.broadcast();
  final StreamController<ConnectivityStatus> _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();

  // Current state
  AuthState _currentAuthState = AuthState.initial();

  // Configuration
  static const Duration _tokenRefreshThreshold =
      Duration(minutes: 5); // تحديث التوكن قبل انتهاء الصلاحية بـ 5 دقائق

  UnifiedAuthService._internal() {
    // Initialize services synchronously where possible
    _initializeCoreServices();
  }

  /// تهيئة الخدمات الأساسية بشكل متزامن
  void _initializeCoreServices() {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Initializing core services...');
      
      // Initialize core services that don't require async operations
      _dio = EnhancedDioServiceV2.instance.dio;
      _storage = PlatformStorageService.instance;
      _tokenManager = SecureTokenManager.instance;
      _sessionManager = SessionManager.instance;
      _connectivityService = ConnectivityService.instance;
      
      debugPrint('✅ [UNIFIED_AUTH] Core services initialized successfully');
      
      // Start async initialization in background
      _initializeAsyncServices();
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Core initialization error: $e');
      _updateAuthState(AuthState.error('خطأ في تهيئة النظام'));
    }
  }

  /// تهيئة الخدمات التي تتطلب عمليات غير متزامنة
  Future<void> _initializeAsyncServices() async {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Initializing async services...');
      
      // Initialize services that require async operations
      await _storage.init();
      await _tokenManager.initialize();
      await _sessionManager.initialize();
      await _connectivityService.initialize();
      
      // Initialize offline storage if available
      try {
        _offlineStorage = OfflineStorageService.instance;
        await _offlineStorage.initialize();
      } catch (e) {
        debugPrint('⚠️ [UNIFIED_AUTH] Offline storage not available: $e');
        // Continue without offline storage
      }

      // Listen to connectivity changes
      _connectivityService.connectivityStream.listen(_onConnectivityChanged);

      // Start background services
      _startBackgroundServices();

      // Restore previous session if available
      await _restoreSession();

      debugPrint('✅ [UNIFIED_AUTH] Async services initialized successfully');
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Async initialization error: $e');
      _updateAuthState(AuthState.error('خطأ في تهيئة النظام'));
    }
  }

  /// Stream للاستماع لتغييرات حالة المصادقة
  Stream<AuthState> get authStateStream => _authStateController.stream;

  /// Stream للاستماع لتغييرات حالة الاتصال
  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivityController.stream;

  /// الحالة الحالية للمصادقة
  AuthState get currentAuthState => _currentAuthState;


  /// تسجيل الدخول مع دعم وضع عدم الاتصال
  Future<AuthResult> login({
    required String phone,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Starting login for: $phone');

      _updateAuthState(AuthState.loading('جاري تسجيل الدخول...'));

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();

      if (!isOnline) {
        // Try offline login
        return await _offlineLogin(phone, password);
      }

      // Online login
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: {
          'phone': phone,
          'password': password,
          'remember_me': rememberMe,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Extract user and tokens
        final user = UserModel.fromJsonSafe(data['user']);
        final accessToken = data['access_token'] as String;
        final refreshToken = data['refresh_token'] as String;
        final expiresIn = data['expires_in'] as int? ?? 3600; // Default 1 hour

        // Save tokens securely
        await _tokenManager.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiresIn,
        );

        // Save user data
        await _saveUserData(user);

        // Start session
        await _sessionManager.startSession(user.id);

        // Cache data for offline use
        await _offlineStorage.cacheUserData(user.toJson());
        await _offlineStorage.cacheAuthData({
          'phone': phone,
          'password': password,
          'remember_me': rememberMe,
        });

        _updateAuthState(AuthState.authenticated(user));

        debugPrint('✅ [UNIFIED_AUTH] Login successful for: ${user.phone}');
        return AuthResult.success(user, 'تم تسجيل الدخول بنجاح');
      } else {
        throw Exception('خطأ في تسجيل الدخول');
      }
    } on DioException catch (e) {
      return _handleLoginError(e);
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Login error: $e');
      _updateAuthState(AuthState.error('خطأ في تسجيل الدخول'));
      return AuthResult.error('خطأ في تسجيل الدخول: $e');
    }
  }

  /// تسجيل الدخول في وضع عدم الاتصال
  Future<AuthResult> _offlineLogin(String phone, String password) async {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Attempting offline login for: $phone');

      // Check if we have cached auth data
      final cachedAuthData = await _offlineStorage.getCachedAuthData();
      if (cachedAuthData == null) {
        return AuthResult.error('لا يمكن تسجيل الدخول بدون اتصال بالإنترنت');
      }

      // Verify credentials match cached data
      if (cachedAuthData['phone'] != phone ||
          cachedAuthData['password'] != password) {
        return AuthResult.error('بيانات تسجيل الدخول غير صحيحة');
      }

      // Get cached user data
      final cachedUser = await _offlineStorage.getCachedUserData();
      if (cachedUser == null) {
        return AuthResult.error('لا توجد بيانات مستخدم محفوظة');
      }

      // Check if tokens are still valid
      final hasValidTokens = await _tokenManager.hasValidTokens();
      if (!hasValidTokens) {
        return AuthResult.error('انتهت صلاحية الجلسة، يرجى الاتصال بالإنترنت');
      }

      final user = UserModel.fromJsonSafe(cachedUser);
      _updateAuthState(AuthState.authenticated(user));
      return AuthResult.success(
          user, 'تم تسجيل الدخول في وضع عدم الاتصال');
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Offline login error: $e');
      return AuthResult.error('خطأ في تسجيل الدخول في وضع عدم الاتصال');
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
      debugPrint('🔐 [UNIFIED_AUTH] Starting registration for: $phone');

      _updateAuthState(AuthState.loading('جاري إنشاء الحساب...'));

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();
      if (!isOnline) {
        return AuthResult.error('يجب الاتصال بالإنترنت لإنشاء حساب جديد');
      }

      final response = await _dio.post(
        '/api/v1/auth/register',
        data: {
          'phone': phone,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          if (email != null) 'email': email,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;

        _updateAuthState(AuthState.registered());
        return AuthResult.success(
            null, data['message'] ?? 'تم إنشاء الحساب بنجاح');
      } else {
        throw Exception('خطأ في إنشاء الحساب');
      }
    } on DioException catch (e) {
      return _handleRegistrationError(e);
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Registration error: $e');
      _updateAuthState(AuthState.error('خطأ في إنشاء الحساب'));
      return AuthResult.error('خطأ في إنشاء الحساب: $e');
    }
  }

  /// طلب رمز التحقق
  Future<AuthResult> requestOtp({
    required String phone,
    String purpose = 'verification',
  }) async {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Requesting OTP for: $phone');

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();
      if (!isOnline) {
        return AuthResult.error('يجب الاتصال بالإنترنت لطلب رمز التحقق');
      }

      final response = await _dio.post(
        '/api/v1/auth/request-otp',
        data: {
          'phone': phone,
          'purpose': purpose,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return AuthResult.success(
            null, data['message'] ?? 'تم إرسال رمز التحقق');
      } else {
        throw Exception('خطأ في طلب رمز التحقق');
      }
    } on DioException catch (e) {
      return _handleOtpError(e);
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] OTP request error: $e');
      return AuthResult.error('خطأ في طلب رمز التحقق: $e');
    }
  }

  /// التحقق من رمز OTP
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Verifying OTP for: $phone');

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();
      if (!isOnline) {
        return AuthResult.error('يجب الاتصال بالإنترنت للتحقق من الرمز');
      }

      final response = await _dio.post(
        '/api/v1/auth/verify-otp',
        data: {
          'phone': phone,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Extract user and tokens
        final user = UserModel.fromJsonSafe(data['user']);
        final accessToken = data['access_token'] as String;
        final refreshToken = data['refresh_token'] as String;
        final expiresIn = data['expires_in'] as int? ?? 3600;

        // Save tokens securely
        await _tokenManager.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiresIn,
        );

        // Save user data
        await _saveUserData(user);

        // Start session
        await _sessionManager.startSession(user.id);

        // Cache data for offline use
        await _offlineStorage.cacheUserData(user.toJson());

        _updateAuthState(AuthState.authenticated(user));

        return AuthResult.success(user, 'تم التحقق بنجاح');
      } else {
        throw Exception('رمز التحقق غير صحيح');
      }
    } on DioException catch (e) {
      return _handleOtpError(e);
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] OTP verification error: $e');
      return AuthResult.error('خطأ في التحقق من الرمز: $e');
    }
  }

  /// تسجيل الخروج
  Future<AuthResult> logout({bool fromAllDevices = false}) async {
    try {
      debugPrint('🔐 [UNIFIED_AUTH] Logging out...');

      _updateAuthState(AuthState.loading('جاري تسجيل الخروج...'));

      // Check connectivity
      final isOnline = await _connectivityService.checkConnection();

      if (isOnline) {
        // Online logout
        try {
          await _dio.post(
            '/api/v1/auth/logout',
            data: {
              'from_all_devices': fromAllDevices,
            },
          );
        } catch (e) {
          debugPrint(
              '⚠️ [UNIFIED_AUTH] Server logout failed, continuing with local logout');
        }
      }

      // Clear local data
      await _tokenManager.clearTokens();
      await _sessionManager.endSession();
      await _offlineStorage.clearAuthData();

      _updateAuthState(AuthState.unauthenticated());

      debugPrint('✅ [UNIFIED_AUTH] Logout successful');
      return AuthResult.success(null, 'تم تسجيل الخروج بنجاح');
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Logout error: $e');
      // Force logout even if there's an error
      await _tokenManager.clearTokens();
      await _sessionManager.endSession();
      _updateAuthState(AuthState.unauthenticated());
      return AuthResult.success(null, 'تم تسجيل الخروج');
    }
  }

  /// تحديث التوكن تلقائياً
  Future<bool> refreshToken() async {
    try {
      debugPrint('🔄 [UNIFIED_AUTH] Refreshing token...');

      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) {
        debugPrint('❌ [UNIFIED_AUTH] No refresh token available');
        return false;
      }

      final response = await _dio.post(
        '/api/v1/auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        await _tokenManager.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'] ?? refreshToken,
          expiresIn: data['expires_in'] ?? 3600,
        );

        debugPrint('✅ [UNIFIED_AUTH] Token refreshed successfully');
        return true;
      } else {
        debugPrint('❌ [UNIFIED_AUTH] Token refresh failed');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Token refresh error: $e');
      return false;
    }
  }

  /// التحقق من صحة الجلسة الحالية
  Future<bool> isSessionValid() async {
    try {
      // Check if we have valid tokens
      final hasValidTokens = await _tokenManager.hasValidTokens();
      if (!hasValidTokens) {
        return false;
      }

      // Check if session is active
      final isSessionActive = await _sessionManager.isSessionActive();
      if (!isSessionActive) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Session validation error: $e');
      return false;
    }
  }

  /// الحصول على المستخدم الحالي
  Future<UserModel?> getCurrentUser() async {
    try {
      // Try to get from memory first
      final userFromMemory = _currentAuthState.when(
        initial: () => null,
        loading: (message) => null,
        authenticated: (user) => user,
        unauthenticated: () => null,
        registered: () => null,
        error: (message) => null,
      );

      if (userFromMemory != null) {
        return userFromMemory;
      }

      // Try to get from storage
      final userData = await _storage.readSecure('current_user');
      if (userData != null) {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        return UserModel.fromJsonSafe(userMap);
      }

      return null;
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Error getting current user: $e');
      return null;
    }
  }

  /// حفظ بيانات المستخدم
  Future<void> _saveUserData(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _storage.writeSecure('current_user', userJson);
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Error saving user data: $e');
    }
  }

  /// استعادة الجلسة السابقة
  Future<void> _restoreSession() async {
    try {
      debugPrint('🔄 [UNIFIED_AUTH] Restoring previous session...');

      final hasValidTokens = await _tokenManager.hasValidTokens();
      final isSessionActive = await _sessionManager.isSessionActive();
      final user = await getCurrentUser();

      if (hasValidTokens && isSessionActive && user != null) {
        _updateAuthState(AuthState.authenticated(user));
        debugPrint('✅ [UNIFIED_AUTH] Session restored successfully');
      } else {
        _updateAuthState(AuthState.unauthenticated());
        debugPrint('ℹ️ [UNIFIED_AUTH] No valid session to restore');
      }
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Session restoration error: $e');
      _updateAuthState(AuthState.unauthenticated());
    }
  }

  /// بدء الخدمات الخلفية
  void _startBackgroundServices() {
    // Token refresh monitoring
    Timer.periodic(Duration(minutes: 1), (timer) async {
      try {
        final isOnline = await _connectivityService.checkConnection();
        if (isOnline) {
          await _monitorTokenExpiry();
        }
      } catch (e) {
        debugPrint('❌ [UNIFIED_AUTH] Background monitoring error: $e');
      }
    });

    // Session monitoring
    Timer.periodic(Duration(minutes: 5), (timer) async {
      try {
        await _monitorSession();
      } catch (e) {
        debugPrint('❌ [UNIFIED_AUTH] Session monitoring error: $e');
      }
    });
  }

  /// مراقبة انتهاء صلاحية التوكن
  Future<void> _monitorTokenExpiry() async {
    try {
      final timeUntilExpiry = await _tokenManager.getTimeUntilExpiry();

      if (timeUntilExpiry != null &&
          timeUntilExpiry <= _tokenRefreshThreshold) {
        debugPrint('🔄 [UNIFIED_AUTH] Token expires soon, refreshing...');
        final refreshed = await refreshToken();

        if (!refreshed) {
          debugPrint('❌ [UNIFIED_AUTH] Token refresh failed, logging out');
          await logout();
        }
      }
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Token expiry monitoring error: $e');
    }
  }

  /// مراقبة الجلسة
  Future<void> _monitorSession() async {
    try {
      final isValid = await isSessionValid();

      if (!isValid) {
        debugPrint('❌ [UNIFIED_AUTH] Session invalid, logging out');
        await logout();
      }
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Session monitoring error: $e');
    }
  }

  /// التعامل مع تغييرات الاتصال
  void _onConnectivityChanged(ConnectivityStatus status) {
    _connectivityController.add(status);

    if (status == ConnectivityStatus.wifi || status == ConnectivityStatus.mobile) {
      debugPrint('🌐 [UNIFIED_AUTH] Connection restored, syncing data...');
      _syncOfflineData();
    } else {
      debugPrint(
          '🌐 [UNIFIED_AUTH] Connection lost, switching to offline mode');
    }
  }

  /// مزامنة البيانات المحفوظة محلياً
  Future<void> _syncOfflineData() async {
    try {
      // Sync any pending operations
      await _offlineStorage.syncPendingOperations();

      // Refresh user data if online
      final user = await getCurrentUser();
      if (user != null) {
        // Fetch latest user data
        // Implementation depends on your API
      }
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Data sync error: $e');
    }
  }

  /// تحديث حالة المصادقة
  void _updateAuthState(AuthState state) {
    _currentAuthState = state;
    _authStateController.add(state);
  }

  /// معالجة أخطاء تسجيل الدخول
  AuthResult _handleLoginError(DioException e) {
    String message = 'خطأ في تسجيل الدخول';

    switch (e.response?.statusCode) {
      case 401:
        message = 'رقم الهاتف أو كلمة المرور غير صحيحة';
        break;
      case 422:
        message = 'خطأ في البيانات المدخلة';
        break;
      case 400:
        message = 'طلب غير صحيح';
        break;
      case 500:
        message = 'خطأ في الخادم';
        break;
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = 'انتهت مهلة الاتصال';
        } else if (e.type == DioExceptionType.connectionError) {
          message = 'خطأ في الاتصال بالإنترنت';
        }
    }

    _updateAuthState(AuthState.error(message));
    return AuthResult.error(message);
  }

  /// معالجة أخطاء التسجيل
  AuthResult _handleRegistrationError(DioException e) {
    String message = 'خطأ في إنشاء الحساب';

    switch (e.response?.statusCode) {
      case 409:
        message = 'رقم الهاتف أو البريد الإلكتروني موجود مسبقاً';
        break;
      case 422:
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        message = errors?.values.first?.first ?? 'خطأ في البيانات المدخلة';
        break;
      case 400:
        message = e.response?.data['message'] ?? 'طلب غير صحيح';
        break;
    }

    _updateAuthState(AuthState.error(message));
    return AuthResult.error(message);
  }

  /// معالجة أخطاء OTP
  AuthResult _handleOtpError(DioException e) {
    String message = 'خطأ في رمز التحقق';

    switch (e.response?.statusCode) {
      case 400:
        message = 'رمز التحقق غير صحيح أو منتهي الصلاحية';
        break;
      case 422:
        message = 'خطأ في البيانات المدخلة';
        break;
      case 410:
        message = 'انتهت صلاحية رمز التحقق';
        break;
    }

    return AuthResult.error(message);
  }

  /// تنظيف الموارد
  Future<void> dispose() async {
    try {
      await _authStateController.close();
      await _connectivityController.close();
      await _offlineStorage.dispose();
      await _tokenManager.dispose();
      await _sessionManager.dispose();
      await _connectivityService.dispose();
    } catch (e) {
      debugPrint('❌ [UNIFIED_AUTH] Disposal error: $e');
    }
  }
}

/// Provider للخدمة الموحدة
final unifiedAuthServiceProvider = Provider<UnifiedAuthService>((ref) {
  return UnifiedAuthService.instance;
});

/// Provider لحالة المصادقة
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(unifiedAuthServiceProvider);
  return authService.authStateStream;
});

/// Provider لحالة الاتصال
final connectivityProvider = StreamProvider<ConnectivityStatus>((ref) {
  final authService = ref.watch(unifiedAuthServiceProvider);
  return authService.connectivityStream;
});
