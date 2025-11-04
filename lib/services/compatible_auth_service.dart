import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'enhanced_dio_service_v2.dart';
import 'enhanced_storage_service.dart';
import 'lazy_loading_service.dart';
import 'platform_storage_service.dart';
import 'unified_token_manager.dart';
import '../features/profile/services/profile_service.dart' as profile_service;

// Conditional import for web
import 'dart:html' as html;

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
  Map<String, dynamic>? _lastResponse;
  
  // Cached session expiry state (updated periodically)
  bool _cachedSessionExpired = false;
  DateTime? _lastSessionCheck;

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
      
      // تحديث حالة انتهاء الجلسة عند التهيئة
      await _updateSessionExpiryState();

      debugPrint('✅ [COMPATIBLE_AUTH] Async services initialized successfully');
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Async initialization error: $e');
    }
  }

  /// اختيار الرسالة المناسبة حسب لغة التطبيق
  String _selectMessageByLanguage(
      String messageAr, String messageEn, Locale? locale) {
    // الحصول على اللغة الحالية من النظام
    final currentLocale =
        locale ?? PlatformStorageService.instance.getCurrentLocale();

    // إذا كانت اللغة العربية، استخدم العربية
    if (currentLocale != null && currentLocale.languageCode == 'ar') {
      return messageAr.isNotEmpty ? messageAr : messageEn;
    }
    // إذا كانت اللغة الإنجليزية أو لم يتم تحديد اللغة، استخدم الإنجليزية
    else if (currentLocale == null || currentLocale.languageCode == 'en') {
      return messageEn.isNotEmpty ? messageEn : messageAr;
    }
    // افتراضي: استخدم العربية إذا كانت متوفرة، وإلا الإنجليزية
    else {
      return messageAr.isNotEmpty ? messageAr : messageEn;
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

        // حفظ آخر استجابة من الخادم
        _lastResponse = responseData;

        // 🔥 NEW: Handle Smart Messages System
        if (responseData.containsKey('success') &&
            responseData.containsKey('data')) {
          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Detected Smart Messages System response');

          final bool success = responseData['success'] as bool;
          final String messageAr = responseData['messageAr'] ?? '';
          final String messageEn = responseData['messageEn'] ?? '';
          final String code = responseData['code'] ?? '';

          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Smart Message - Success: $success, Code: $code');
          debugPrint('🔍 [COMPATIBLE_AUTH] MessageAr: $messageAr');
          debugPrint('🔍 [COMPATIBLE_AUTH] MessageEn: $messageEn');

          if (success && responseData['data'] != null) {
            final data = responseData['data'] as Map<String, dynamic>;

            // Extract user data from new structure
            Map<String, dynamic>? userData;
            if (data.containsKey('user')) {
              userData = data['user'] as Map<String, dynamic>;
            } else {
              userData = data;
            }

            if (userData != null) {
              debugPrint(
                  '🔐 [COMPATIBLE_AUTH] Creating user from Smart Messages data');
              _currentUser = UserModel.fromJsonSafe(userData);

              // Extract tokens from new structure
              String? accessToken;
              String? refreshToken;

              if (data.containsKey('tokens')) {
                final tokens = data['tokens'] as Map<String, dynamic>;
                accessToken = tokens['accessToken'] as String?;
                refreshToken = tokens['refreshToken'] as String?;
              }

              // Save tokens using existing method
              if (accessToken != null) {
                await _tokenManager.saveTokens(
                  accessToken: accessToken,
                  refreshToken: refreshToken ?? '',
                  expiresIn: 2592000, // 30 days (30 * 24 * 60 * 60 = 2592000 seconds)
                );
                await _storage.setString('access_token', accessToken);
                debugPrint('🔐 [COMPATIBLE_AUTH] Smart Messages tokens saved');
              }
              if (refreshToken != null) {
                await _storage.setString('refresh_token', refreshToken);
              }

              await _storage.writeSecure(
                  'current_user', _currentUser!.toJson().toString());
              await _storage.setString(
                  'user_data', _currentUser!.toJson().toString());

              // تحديث حالة الجلسة بعد تسجيل الدخول الناجح
              await _updateSessionExpiryState();

              _isLoading = false;
              debugPrint('✅ [COMPATIBLE_AUTH] Smart Messages login successful');
              return true;
            }
          } else {
            // Handle error from Smart Messages System
            _error = _selectMessageByLanguage(messageAr, messageEn, null);
            _isLoading = false;
            debugPrint('❌ [COMPATIBLE_AUTH] Smart Messages error: $_error');
            return false;
          }
        }

        // Extract user data - check both possible structures (LEGACY SUPPORT)
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
              expiresIn: 2592000, // 30 days (30 * 24 * 60 * 60 = 2592000 seconds)
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

          // تحديث حالة الجلسة بعد تسجيل الدخول الناجح
          await _updateSessionExpiryState();

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

      // Handle DioException specifically
      if (e is DioException) {
        if (e.response?.data != null) {
          final responseData = e.response!.data as Map<String, dynamic>;

          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final message = errorData['message'] as String? ?? 'خطأ غير معروف';

            // Check if it's a validation error for phone number
            if (message.contains('phone number') ||
                message.contains('رقم الهاتف')) {
              _error =
                  'رقم الهاتف غير صحيح. يرجى التأكد من الرقم وإعادة المحاولة';
            } else if (message.contains('password') ||
                message.contains('كلمة المرور')) {
              _error = 'كلمة المرور غير صحيحة';
            } else if (message.contains('not found') ||
                message.contains('غير موجود')) {
              _error = 'رقم الهاتف غير مسجل في النظام';
            } else {
              _error = message;
            }
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'خطأ في تسجيل الدخول. يرجى المحاولة مرة أخرى';
          }
        } else {
          _error =
              'خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مرة أخرى';
        }
      } else {
        _error = 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

      _isLoading = false;
      return false;
    }
  }

  /// تسجيل المستخدم الجديد
  Future<bool> registerWithPhone(
      String phone, String password, String fullName, String email) async {
    try {
      _isLoading = true;
      _error = null;

      debugPrint('🔐 [COMPATIBLE_AUTH] Attempting registration for: $phone');

      final response = await _dio.post(ApiConstants.registerEndpoint, data: {
        'name': fullName, // Send full name as 'name'
        'phone': phone,
        'password': password,
        'confirmPassword': password, // Use same password for confirmation
        'email': email.isNotEmpty ? email : null, // Send email if provided
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;

        // حفظ آخر استجابة من الخادم
        _lastResponse = responseData;

        // 🔥 NEW: Handle Smart Messages System for Registration
        if (responseData.containsKey('success') &&
            responseData.containsKey('data')) {
          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Detected Smart Messages System registration response');

          final bool success = responseData['success'] as bool;
          final String messageAr = responseData['messageAr'] ?? '';
          final String messageEn = responseData['messageEn'] ?? '';
          final String code = responseData['code'] ?? '';

          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Smart Registration Message - Success: $success, Code: $code');

          if (success) {
            _isLoading = false;
            debugPrint(
                '✅ [COMPATIBLE_AUTH] Smart Messages registration successful');
            return true;
          } else {
            // Handle error from Smart Messages System
            _error = _selectMessageByLanguage(messageAr, messageEn, null);
            _isLoading = false;
            debugPrint(
                '❌ [COMPATIBLE_AUTH] Smart Messages registration error: $_error');
            return false;
          }
        }

        // LEGACY SUPPORT for registration
        _isLoading = false;
        debugPrint('✅ [COMPATIBLE_AUTH] Registration successful for: $phone');
        return true;
      } else if (response.statusCode == 409) {
        // Handle 409 Conflict (phone already exists) with Smart Messages
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('success') &&
            responseData.containsKey('messageAr')) {
          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Detected Smart Messages System 409 response');

          final bool success = responseData['success'] as bool;
          final String messageAr = responseData['messageAr'] ?? '';
          final String messageEn = responseData['messageEn'] ?? '';
          final String code = responseData['code'] ?? '';

          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Smart 409 Message - Success: $success, Code: $code');

          _error = _selectMessageByLanguage(messageAr, messageEn, null);
          _isLoading = false;
          debugPrint('❌ [COMPATIBLE_AUTH] Smart Messages 409 error: $_error');
          return false;
        } else {
          // Fallback for non-smart message 409 responses
          _error = 'رقم الهاتف مستخدم بالفعل. جرب تسجيل الدخول';
          _isLoading = false;
          debugPrint('❌ [COMPATIBLE_AUTH] Registration failed - phone exists');
          return false;
        }
      } else {
        // Handle other error status codes with Smart Messages
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('success') &&
            responseData.containsKey('messageAr')) {
          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Detected Smart Messages System error response');

          final bool success = responseData['success'] as bool;
          final String messageAr = responseData['messageAr'] ?? '';
          final String messageEn = responseData['messageEn'] ?? '';
          final String code = responseData['code'] ?? '';

          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Smart Error Message - Success: $success, Code: $code');

          _error = _selectMessageByLanguage(messageAr, messageEn, null);
          _isLoading = false;
          debugPrint('❌ [COMPATIBLE_AUTH] Smart Messages error: $_error');
          return false;
        } else {
          // Fallback for non-smart message error responses
          _error = 'فشل في إنشاء الحساب';
          _isLoading = false;
          debugPrint(
              '❌ [COMPATIBLE_AUTH] Registration failed with status: ${response.statusCode}');
          return false;
        }
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Registration error: $e');

      // Handle DioException specifically
      if (e is DioException) {
        if (e.response?.data != null) {
          final responseData = e.response!.data as Map<String, dynamic>;

          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final message = errorData['message'] as String? ?? 'خطأ غير معروف';

            // Check if it's a validation error for phone number
            if (message.contains('phone number') ||
                message.contains('رقم الهاتف')) {
              _error =
                  'رقم الهاتف غير صحيح. يرجى التأكد من الرقم وإعادة المحاولة';
            } else if (message.contains('password') ||
                message.contains('كلمة المرور')) {
              _error = 'كلمة المرور غير صحيحة';
            } else if (message.contains('already exists') ||
                message.contains('مستخدم بالفعل')) {
              _error = 'رقم الهاتف مستخدم بالفعل. جرب تسجيل الدخول';
            } else {
              _error = message;
            }
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'خطأ في إنشاء الحساب. يرجى المحاولة مرة أخرى';
          }
        } else {
          _error =
              'خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مرة أخرى';
        }
      } else {
        _error = 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

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
      });

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // حفظ آخر استجابة من الخادم
        _lastResponse = responseData;

        // 🔥 NEW: Handle Smart Messages System for OTP
        if (responseData.containsKey('success') &&
            responseData.containsKey('data')) {
          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Detected Smart Messages System OTP response');

          final bool success = responseData['success'] as bool;
          final String messageAr = responseData['messageAr'] ?? '';
          final String messageEn = responseData['messageEn'] ?? '';
          final String code = responseData['code'] ?? '';

          debugPrint(
              '🔍 [COMPATIBLE_AUTH] Smart OTP Message - Success: $success, Code: $code');

          if (success && responseData['data'] != null) {
            final data = responseData['data'] as Map<String, dynamic>;

            // Extract user data from new structure
            Map<String, dynamic>? userData;
            if (data.containsKey('user')) {
              userData = data['user'] as Map<String, dynamic>;
            } else {
              userData = data;
            }

            if (userData != null) {
              debugPrint(
                  '🔐 [COMPATIBLE_AUTH] Creating user from Smart Messages OTP data');
              _currentUser = UserModel.fromJsonSafe(userData);

              // Extract tokens from new structure
              String? accessToken;
              String? refreshToken;

              if (data.containsKey('tokens')) {
                final tokens = data['tokens'] as Map<String, dynamic>;
                accessToken = tokens['accessToken'] as String?;
                refreshToken = tokens['refreshToken'] as String?;
              }

              // Save tokens using existing method
              if (accessToken != null) {
                await _tokenManager.saveTokens(
                  accessToken: accessToken,
                  refreshToken: refreshToken ?? '',
                  expiresIn: 2592000, // 30 days (30 * 24 * 60 * 60 = 2592000 seconds)
                );
                await _storage.setString('access_token', accessToken);
                debugPrint(
                    '🔐 [COMPATIBLE_AUTH] Smart Messages OTP tokens saved');
              }
              if (refreshToken != null) {
                await _storage.setString('refresh_token', refreshToken);
              }

              await _storage.writeSecure(
                  'current_user', _currentUser!.toJson().toString());
              await _storage.setString(
                  'user_data', _currentUser!.toJson().toString());
              
              // تحديث حالة الجلسة بعد التحقق الناجح
              await _updateSessionExpiryState();
            }
          } else if (!success) {
            // Handle error from Smart Messages System
            _error = _selectMessageByLanguage(messageAr, messageEn, null);
            _isLoading = false;
            debugPrint('❌ [COMPATIBLE_AUTH] Smart Messages OTP error: $_error');
            return false;
          }

          _isLoading = false;
          debugPrint(
              '✅ [COMPATIBLE_AUTH] Smart Messages OTP verification successful');
          return true;
        }

        // LEGACY SUPPORT for OTP verification
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
              expiresIn: 2592000, // 30 days (30 * 24 * 60 * 60 = 2592000 seconds)
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
          
          // تحديث حالة الجلسة بعد التحقق الناجح
          await _updateSessionExpiryState();
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

      // Handle DioException specifically
      if (e is DioException) {
        if (e.response?.data != null) {
          final responseData = e.response!.data as Map<String, dynamic>;

          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final message = errorData['message'] as String? ?? 'خطأ غير معروف';

            // Check if it's a validation error for OTP
            if (message.contains('OTP') || message.contains('رمز التحقق')) {
              _error =
                  'رمز التحقق غير صحيح. يرجى التأكد من الرمز وإعادة المحاولة';
            } else if (message.contains('expired') ||
                message.contains('منتهي الصلاحية')) {
              _error = 'رمز التحقق منتهي الصلاحية. يرجى طلب رمز جديد';
            } else if (message.contains('invalid') ||
                message.contains('غير صحيح')) {
              _error = 'رمز التحقق غير صحيح';
            } else {
              _error = message;
            }
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'خطأ في التحقق من الرمز. يرجى المحاولة مرة أخرى';
          }
        } else {
          _error =
              'خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مرة أخرى';
        }
      } else {
        _error = 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

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
        final responseData = response.data as Map<String, dynamic>;

        // حفظ آخر استجابة من الخادم
        _lastResponse = responseData;

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

      // Handle DioException specifically
      if (e is DioException) {
        if (e.response?.data != null) {
          final responseData = e.response!.data as Map<String, dynamic>;

          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final message = errorData['message'] as String? ?? 'خطأ غير معروف';

            // Check if it's a rate limiting error
            if (message.contains('rate limit') ||
                message.contains('محاولات كثيرة')) {
              _error =
                  'تم تجاوز عدد المحاولات المسموح. يرجى الانتظار قليلاً والمحاولة مرة أخرى';
            } else if (message.contains('not found') ||
                message.contains('غير موجود')) {
              _error = 'رقم الهاتف غير مسجل في النظام';
            } else {
              _error = message;
            }
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'خطأ في إرسال رمز التحقق. يرجى المحاولة مرة أخرى';
          }
        } else {
          _error =
              'خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مرة أخرى';
        }
      } else {
        _error = 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

      _isLoading = false;
      return false;
    }
  }

  /// طلب إعادة تعيين كلمة المرور
  Future<bool> requestPasswordReset(String phone) async {
    try {
      _isLoading = true;
      _error = null;

      final response =
          await _dio.post('/api/v1/auth/request-password-reset', data: {
        'phone': phone,
      });

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;

        // حفظ آخر استجابة من الخادم
        if (responseData != null) {
          _lastResponse = responseData;
        }

        _isLoading = false;
        return true;
      } else {
        // Handle non-200 responses
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          
          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
            
            if (messageAr.isNotEmpty || messageEn.isNotEmpty) {
              _error = _selectMessageByLanguage(messageAr, messageEn, null);
            } else {
              _error = errorData['message'] as String? ?? 'فشل في طلب إعادة تعيين كلمة المرور';
            }
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'فشل في طلب إعادة تعيين كلمة المرور';
          }
        } else {
          _error = 'فشل في طلب إعادة تعيين كلمة المرور';
        }
        
        _isLoading = false;
        return false;
      }
    } catch (e) {
      debugPrint('❌ Password reset request error: $e');

      // Handle DioException specifically
      if (e is DioException) {
        if (e.response?.data != null) {
          final responseData = e.response!.data as Map<String, dynamic>;

          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
            
            if (messageAr.isNotEmpty || messageEn.isNotEmpty) {
              _error = _selectMessageByLanguage(messageAr, messageEn, null);
            } else {
              _error = errorData['message'] as String? ?? 'خطأ في طلب إعادة تعيين كلمة المرور';
            }
          } else if (responseData.containsKey('messageAr') &&
              responseData.containsKey('messageEn')) {
            // Direct Smart Messages System format
            final messageAr = responseData['messageAr'] as String? ?? '';
            final messageEn = responseData['messageEn'] as String? ?? '';
            _error = _selectMessageByLanguage(messageAr, messageEn, null);
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'خطأ في طلب إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى';
          }
        } else {
          _error = 'خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مرة أخرى';
        }
      } else {
        _error = 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

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

      final response = await _dio.post('/api/v1/auth/reset-password', data: {
        'phone': phone,
        'otp': otp,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;

        // حفظ آخر استجابة من الخادم
        if (responseData != null) {
          _lastResponse = responseData;
        }

        _isLoading = false;
        return true;
      } else {
        // Handle non-200 responses
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          
          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
            
            if (messageAr.isNotEmpty || messageEn.isNotEmpty) {
              _error = _selectMessageByLanguage(messageAr, messageEn, null);
            } else {
              _error = errorData['message'] as String? ?? 'فشل في إعادة تعيين كلمة المرور';
            }
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'فشل في إعادة تعيين كلمة المرور';
          }
        } else {
          _error = 'فشل في إعادة تعيين كلمة المرور';
        }
        
        _isLoading = false;
        return false;
      }
    } catch (e) {
      debugPrint('❌ Password reset error: $e');

      // Handle DioException specifically
      if (e is DioException) {
        if (e.response?.data != null) {
          final responseData = e.response!.data as Map<String, dynamic>;

          // Check for Smart Messages System error
          if (responseData.containsKey('error') &&
              responseData['error'] is Map<String, dynamic>) {
            final errorData = responseData['error'] as Map<String, dynamic>;
            final messageAr = errorData['messageAr'] as String? ?? '';
            final messageEn = errorData['messageEn'] as String? ?? '';
            
            if (messageAr.isNotEmpty || messageEn.isNotEmpty) {
              _error = _selectMessageByLanguage(messageAr, messageEn, null);
            } else {
              _error = errorData['message'] as String? ?? 'خطأ في إعادة تعيين كلمة المرور';
            }
          } else if (responseData.containsKey('messageAr') &&
              responseData.containsKey('messageEn')) {
            // Direct Smart Messages System format
            final messageAr = responseData['messageAr'] as String? ?? '';
            final messageEn = responseData['messageEn'] as String? ?? '';
            _error = _selectMessageByLanguage(messageAr, messageEn, null);
          } else if (responseData.containsKey('message')) {
            _error = responseData['message'] as String;
          } else {
            _error = 'خطأ في إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى';
          }
        } else {
          _error = 'خطأ في الاتصال بالخادم. يرجى التحقق من الإنترنت والمحاولة مرة أخرى';
        }
      } else {
        _error = 'خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

      _isLoading = false;
      return false;
    }
  }

  /// تسجيل الخروج
  Future<bool> logout() async {
    try {
      _isLoading = true;
      _error = null;

      debugPrint('🔐 [COMPATIBLE_AUTH] Starting comprehensive logout process...');

      // إرسال طلب تسجيل الخروج للخادم
      try {
        await _dio.post('/auth/logout');
        debugPrint('✅ [COMPATIBLE_AUTH] Server logout successful');
      } catch (e) {
        debugPrint('⚠️ [COMPATIBLE_AUTH] Server logout failed, continuing with local logout: $e');
      }

      // مسح البيانات المحلية - مسح جميع المفاتيح
      debugPrint('🔐 [COMPATIBLE_AUTH] Clearing tokens...');
      await _tokenManager.clearTokens();
      
      debugPrint('🔐 [COMPATIBLE_AUTH] Clearing storage keys...');
      await _storage.delete('access_token');
      await _storage.delete('refresh_token');
      await _storage.delete('user_data');
      await _storage.deleteSecure('secure_access_token');
      await _storage.deleteSecure('secure_refresh_token');
      await _storage.deleteSecure('current_user');

      // مسح الكاش الإضافي - Lazy loading cache
      debugPrint('🔐 [COMPATIBLE_AUTH] Clearing lazy loading cache...');
      try {
        await LazyLoadingService.instance.clearAllCache();
        debugPrint('✅ [COMPATIBLE_AUTH] Lazy loading cache cleared');
      } catch (e) {
        debugPrint('⚠️ [COMPATIBLE_AUTH] Error clearing lazy loading cache: $e');
      }

      // مسح Enhanced Storage
      debugPrint('🔐 [COMPATIBLE_AUTH] Clearing enhanced storage...');
      try {
        await EnhancedStorageService.instance.clearAllData();
        debugPrint('✅ [COMPATIBLE_AUTH] Enhanced storage cleared');
      } catch (e) {
        debugPrint('⚠️ [COMPATIBLE_AUTH] Error clearing enhanced storage: $e');
      }

      // مسح كاش الملف الشخصي
      debugPrint('🔐 [COMPATIBLE_AUTH] Clearing profile cache...');
      try {
        // Import will be added at top of file
        await _clearProfileCache();
        debugPrint('✅ [COMPATIBLE_AUTH] Profile cache cleared');
      } catch (e) {
        debugPrint('⚠️ [COMPATIBLE_AUTH] Error clearing profile cache: $e');
      }

      // مسح إضافي للويب - مسح جميع البيانات المخزنة
      if (kIsWeb) {
        debugPrint('🌐 [COMPATIBLE_AUTH] Additional web cleanup...');
        try {
          // Clear all platform storage
          await _storage.clearSecure();
          await _storage.clear();
          
          // Clear browser storage
          html.window.localStorage.clear();
          html.window.sessionStorage.clear();
          
          debugPrint('✅ [COMPATIBLE_AUTH] Web storage cleared successfully');
        } catch (e) {
          debugPrint('⚠️ [COMPATIBLE_AUTH] Web cleanup error: $e');
        }
      }

      // مسح الكاش من الذاكرة
      _currentUser = null;
      _isLoading = false;
      
      // تحديث حالة الجلسة بعد تسجيل الخروج
      await _updateSessionExpiryState();
      
      debugPrint('✅ [COMPATIBLE_AUTH] Logout completed successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Logout error: $e');
      _error = 'خطأ في تسجيل الخروج: $e';
      _isLoading = false;
      
      // Force clear even on error
      _currentUser = null;
      if (kIsWeb) {
        try {
          html.window.localStorage.clear();
          html.window.sessionStorage.clear();
        } catch (e) {
          debugPrint('⚠️ [COMPATIBLE_AUTH] Force web cleanup error: $e');
        }
      }
      
      return false;
    }
  }

  /// مسح كاش الملف الشخصي (private helper)
  Future<void> _clearProfileCache() async {
    try {
      await profile_service.LocalProfileService.clearCache();
      debugPrint('✅ [COMPATIBLE_AUTH] Profile cache cleared successfully');
    } catch (e) {
      debugPrint('⚠️ [COMPATIBLE_AUTH] Error clearing profile cache: $e');
      // لا نريد أن يفشل تسجيل الخروج بسبب خطأ في مسح الكاش
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

  /// الحصول على آخر استجابة من الخادم
  Map<String, dynamic>? get lastResponse => _lastResponse;

  /// التحقق من حالة المصادقة
  bool get isAuthenticated => _currentUser != null;

  /// التحقق من انتهاء الجلسة
  /// التحقق من انتهاء صلاحية الجلسة
  bool get sessionExpired {
    // إذا لم يكن هناك مستخدم، فالجلسة منتهية الصلاحية
    if (_currentUser == null) {
      _cachedSessionExpired = true;
      return true;
    }

    // تحديث حالة الجلسة بشكل دوري (كل 5 دقائق)
    // نستخدم unawaited لأن getter يجب أن يكون synchronous
    final now = DateTime.now();
    if (_lastSessionCheck == null || 
        now.difference(_lastSessionCheck!).inMinutes >= 5) {
      _lastSessionCheck = now;
      // تحديث في الخلفية بدون انتظار
      _updateSessionExpiryState().catchError((e) {
        debugPrint('🔐 [COMPATIBLE_AUTH] Error updating session expiry: $e');
      });
    }

    return _cachedSessionExpired;
  }

  /// تحديث حالة انتهاء الجلسة بشكل غير متزامن
  Future<void> _updateSessionExpiryState() async {
    try {
      // التحقق من وجود refresh token صالح
      // إذا كان refresh token موجود وصالح، فالجلسة لا تزال صالحة حتى لو انتهى access token
      // لأننا يمكننا استخدام refresh token لتجديد access token
      final hasValidRefreshToken = await _tokenManager.hasValidRefreshToken();
      final hasValidAccessToken = await _tokenManager.isAccessTokenValid();
      
      // الجلسة صالحة إذا كان هناك refresh token صالح أو access token صالح
      _cachedSessionExpired = !(hasValidRefreshToken || hasValidAccessToken);
      
      debugPrint('🔐 [COMPATIBLE_AUTH] Session expiry check: hasValidRefreshToken=$hasValidRefreshToken, hasValidAccessToken=$hasValidAccessToken, sessionExpired=$_cachedSessionExpired');
    } catch (e) {
      debugPrint('🔐 [COMPATIBLE_AUTH] Error checking session expiry: $e');
      // في حالة الخطأ، نفترض أن الجلسة منتهية للسلامة
      _cachedSessionExpired = true;
    }
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
            
            // تحديث حالة الجلسة بعد استعادة المستخدم
            await _updateSessionExpiryState();
          } catch (e) {
            debugPrint('❌ [COMPATIBLE_AUTH] Error parsing user data: $e');
          }
        }
      } else {
        debugPrint('🔐 [COMPATIBLE_AUTH] No access token found');
        // تحديث حالة الجلسة حتى لو لم يكن هناك token
        await _updateSessionExpiryState();
      }
    } catch (e) {
      debugPrint('❌ [COMPATIBLE_AUTH] Session restoration error: $e');
      // تحديث حالة الجلسة في حالة الخطأ
      await _updateSessionExpiryState();
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
  final Map<String, dynamic>? lastResponse;

  CompatibleAuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.sessionExpired = false,
    this.unverifiedPhoneNumber,
    this.lastResponse,
  });

  CompatibleAuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool? sessionExpired,
    String? unverifiedPhoneNumber,
    Map<String, dynamic>? lastResponse,
  }) {
    return CompatibleAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      unverifiedPhoneNumber:
          unverifiedPhoneNumber ?? this.unverifiedPhoneNumber,
      lastResponse: lastResponse ?? this.lastResponse,
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
      lastResponse: _authService.lastResponse,
    );
  }

  /// تسجيل الدخول بالهاتف
  Future<bool> loginWithPhone(String phone, String password) async {
    final previousState = state;
    final result = await _authService.loginWithPhone(phone, password);
    _updateState();
    
    // If login successful, ensure state change is detected
    if (result && _authService.isAuthenticated) {
      debugPrint('✅ [COMPATIBLE_AUTH] Login successful, ProfileProvider should load profile');
      debugPrint('✅ [COMPATIBLE_AUTH] Previous auth state: ${previousState.isAuthenticated}, Current: ${state.isAuthenticated}');
      
      // Force state update to ensure listener is triggered even if values appear the same
      // This is important because sometimes state doesn't change reference
      if (previousState.isAuthenticated == state.isAuthenticated) {
        state = CompatibleAuthState(
          user: _authService.user,
          isLoading: _authService.isLoading,
          error: _authService.error,
          isAuthenticated: _authService.isAuthenticated,
          sessionExpired: _authService.sessionExpired,
          unverifiedPhoneNumber: _authService.unverifiedPhoneNumber,
          lastResponse: _authService.lastResponse,
        );
        debugPrint('🔄 [COMPATIBLE_AUTH] Forced state update after login to trigger listeners');
      }
      
      // ProfileProvider listener will automatically trigger loadCurrentProfile
      // when it detects isAuthenticated changed from false to true
    }
    
    return result;
  }

  /// تسجيل المستخدم الجديد
  Future<bool> registerWithPhone(
      String phone, String password, String fullName, String email) async {
    // بدء الـ loading في الخدمة أولاً
    _authService._isLoading = true;
    _authService._error = null;
    // تحديث الحالة لبدء الـ loading
    _updateState();

    final result =
        await _authService.registerWithPhone(phone, password, fullName, email);
    _updateState();
    return result;
  }

  /// التحقق من رمز OTP
  Future<bool> verifyOtp(String phone, String otp,
      {bool isLogin = false}) async {
    // بدء الـ loading في الخدمة أولاً
    _authService._isLoading = true;
    _authService._error = null;
    // تحديث الحالة لبدء الـ loading
    _updateState();

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
  /// This method updates auth state and should trigger profile refresh
  void refreshAuthState() {
    debugPrint('🔄 [COMPATIBLE_AUTH] Refreshing auth state...');
    final previousState = state;
    _updateState();
    
    // If user is authenticated, ensure ProfileProvider gets notified
    if (_authService.isAuthenticated) {
      debugPrint('✅ [COMPATIBLE_AUTH] User is authenticated, ProfileProvider should refresh');
      
      // Force state update to trigger listeners even if values appear unchanged
      // This ensures ProfileProvider gets notified when refreshAuthState is called
      if (previousState.isAuthenticated == state.isAuthenticated) {
        // If auth state didn't change, force an update by creating a new state
        // This will trigger listeners even if values are the same
        state = CompatibleAuthState(
          user: _authService.user,
          isLoading: _authService.isLoading,
          error: _authService.error,
          isAuthenticated: _authService.isAuthenticated,
          sessionExpired: _authService.sessionExpired,
          unverifiedPhoneNumber: _authService.unverifiedPhoneNumber,
          lastResponse: _authService.lastResponse,
        );
        debugPrint('🔄 [COMPATIBLE_AUTH] Forced state update to trigger listeners');
      }
    } else {
      debugPrint('⚠️ [COMPATIBLE_AUTH] User is not authenticated');
    }
  }

  /// التحقق من حالة المصادقة
  bool get isAuthenticated => _authService.isAuthenticated;

  /// التحقق من حالة التحميل
  bool get isLoading => _authService.isLoading;

  /// الحصول على الخطأ
  String? get error => _authService.error;

  /// الحصول على آخر استجابة من الخادم
  Map<String, dynamic>? get lastResponse => _authService.lastResponse;

  /// الحصول على المستخدم الحالي
  UserModel? get user => _authService.user;

  /// التحقق من انتهاء الجلسة
  bool get sessionExpired => _authService.sessionExpired;

  /// الحصول على رقم الهاتف غير الموثق
  String? get unverifiedPhoneNumber => _authService.unverifiedPhoneNumber;
}
