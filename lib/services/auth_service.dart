import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/api_response_model.dart';
import '../models/registration_settings_model.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/api_constants.dart';
import '../core/errors/app_error.dart';
import '../providers/api_provider.dart';
import 'api_service.dart';
import 'dio_service.dart';
import 'storage_service.dart';
import 'registration_settings_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._internal();

  late ApiService _apiService;
  late StorageService _storageService;
  late RegistrationSettingsService _registrationSettingsService;

  AuthService._internal() {
    _apiService = ApiService(DioService.instance.dio);
    _storageService = StorageService.instance;
    _registrationSettingsService = RegistrationSettingsService.instance;
  }

  // Helper method to print detailed error information
  void _printDetailedError(String context, dynamic error, StackTrace? stackTrace, {Map<String, dynamic>? additionalData}) {
    debugPrint('🚨 [ERROR_DEBUG] ==========================================');
    debugPrint('🚨 [ERROR_DEBUG] Context: $context');
    debugPrint('🚨 [ERROR_DEBUG] Error Type: ${error.runtimeType}');
    debugPrint('🚨 [ERROR_DEBUG] Error Message: $error');
    if (additionalData != null) {
      debugPrint('🚨 [ERROR_DEBUG] Additional Data: $additionalData');
    }
    if (stackTrace != null) {
      debugPrint('🚨 [ERROR_DEBUG] Stack Trace:');
      debugPrint('$stackTrace');
    }
    debugPrint('🚨 [ERROR_DEBUG] ==========================================');
  }

  // Safe user data storage with detailed error handling
  Future<bool> _safeStoreUserData(UserModel user) async {
    try {
      debugPrint('🔍 [STORAGE_DEBUG] Starting safe user data storage...');
      debugPrint('🔍 [STORAGE_DEBUG] User ID: ${user.id}');
      debugPrint('🔍 [STORAGE_DEBUG] User Phone: ${user.phone}');
      debugPrint('🔍 [STORAGE_DEBUG] User Profile: ${user.profile != null ? 'exists' : 'null'}');
      
      // First, try to convert user to JSON safely
      Map<String, dynamic> userJson;
      try {
        userJson = user.toJson();
        debugPrint('🔍 [STORAGE_DEBUG] User.toJson() successful');
        debugPrint('🔍 [STORAGE_DEBUG] JSON keys: ${userJson.keys.toList()}');
      } catch (toJsonError, stackTrace) {
        _printDetailedError('User.toJson() failed', toJsonError, stackTrace, additionalData: {
          'userId': user.id,
          'userPhone': user.phone,
          'hasProfile': user.profile != null,
          'createdAt': user.createdAt?.toString(),
          'updatedAt': user.updatedAt?.toString(),
        });
        
        // Create a safe minimal JSON representation
        userJson = {
          'id': user.id,
          'phone': user.phone,
          'email': user.email,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'fullNameAr': user.fullNameAr,
          'phoneVerified': user.phoneVerified,
          'roles': user.roles,
          'isVerified': user.isVerified,
          'isActive': user.isActive,
          'isEmailVerified': user.isEmailVerified,
          // Skip problematic fields that might cause null check errors
          'createdAt': user.createdAt?.toIso8601String(),
          'updatedAt': user.updatedAt?.toIso8601String(),
          'profilePictureUrl': user.profilePictureUrl,
          'profilePicture': user.profilePicture,
          // Skip profile object if it's causing issues
          'profile': null,
        };
        debugPrint('🔍 [STORAGE_DEBUG] Created safe JSON representation');
      }
      
      // Now try to encode to JSON string
      String jsonString;
      try {
        jsonString = jsonEncode(userJson);
        debugPrint('🔍 [STORAGE_DEBUG] JSON encoding successful, length: ${jsonString.length}');
      } catch (encodeError, stackTrace) {
        _printDetailedError('JSON encoding failed', encodeError, stackTrace, additionalData: {
          'userJsonKeys': userJson.keys.toList(),
          'userJsonSize': userJson.length,
        });
        return false;
      }
      
      // Finally, try to store in storage
      try {
        await _storageService.setString('user_data', jsonString);
        debugPrint('🔍 [STORAGE_DEBUG] User data stored successfully');
        return true;
      } catch (storageError, stackTrace) {
        _printDetailedError('Storage operation failed', storageError, stackTrace, additionalData: {
          'jsonStringLength': jsonString.length,
          'storageKey': 'user_data',
        });
        return false;
      }
      
    } catch (generalError, stackTrace) {
      _printDetailedError('General storage error', generalError, stackTrace, additionalData: {
        'userId': user.id,
        'userPhone': user.phone,
      });
      return false;
    }
  }

  // Helper method to create error response
  AuthResponse _createErrorResponse(String message) {
    return AuthResponse(
      success: false,
      message: message,
      accessToken: '',
      refreshToken: '',
      user: null,
      token: '',
    );
  }

  // Simplified login method
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      debugPrint('🔍 [AUTH_DEBUG] Starting login for phone: ${request.phone}');
      
      // Production-specific debugging
      if (!kDebugMode) {
        debugPrint('🏭 [AUTH_PRODUCTION] Production login attempt');
        debugPrint('🏭 [AUTH_PRODUCTION] Current ApiConstants.baseUrl: ${ApiConstants.baseUrl}');
        debugPrint('🏭 [AUTH_PRODUCTION] DioService baseUrl: ${DioService.instance.dio.options.baseUrl}');
        debugPrint('🏭 [AUTH_PRODUCTION] Port check: ${DioService.instance.dio.options.baseUrl.contains(":3000")}');
      }
      
      final dio = DioService.instance.dio;
      
      // Additional production logging before request
      if (!kDebugMode) {
        debugPrint('🏭 [AUTH_PRODUCTION] About to make request to: ${dio.options.baseUrl}/api/v1/auth/login');
        debugPrint('🏭 [AUTH_PRODUCTION] Full URL will be: ${dio.options.baseUrl}/api/v1/auth/login');
      }
      
      final response = await dio.post(
        '/api/v1/auth/login',
        data: request.toJson(),
      );
      
      debugPrint('🔍 [AUTH_DEBUG] Login response received');
      debugPrint('🔍 [AUTH_DEBUG] Status: ${response.statusCode}');
      debugPrint('🔍 [AUTH_DEBUG] Data: ${response.data}');
      
      // Check for successful response
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Validate response structure
        if (responseData.containsKey('user') && 
            (responseData.containsKey('tokens') || responseData.containsKey('access_token'))) {
          
          // Extract user data
          final userData = responseData['user'] as Map<String, dynamic>;
          UserModel? user;
          try {
            user = UserModel.fromJsonSafe(userData);
            debugPrint('🔍 [AUTH_DEBUG] User parsed successfully: ${user?.phone ?? 'Unknown'}');
          } catch (userParseError) {
            debugPrint('🔍 [AUTH_DEBUG] Error parsing user data: $userParseError');
            return _createErrorResponse('خطأ في تحليل بيانات المستخدم من الخادم');
          }
          
          // Extract tokens
          String accessToken = '';
          String refreshToken = '';
          
          debugPrint('🔍 [AUTH_DEBUG] Extracting tokens...');
          
          // Get access token from either location
          if (responseData.containsKey('access_token')) {
            final accessTokenValue = responseData['access_token'];
            if (accessTokenValue != null) {
              accessToken = accessTokenValue.toString();
              debugPrint('🔍 [AUTH_DEBUG] Access token from access_token field: ${accessToken.isNotEmpty ? 'present' : 'empty'}');
            }
          }
          
          if (responseData.containsKey('tokens')) {
            final tokensData = responseData['tokens'] as Map<String, dynamic>?;
            if (tokensData != null) {
              if (accessToken.isEmpty && tokensData.containsKey('accessToken')) {
                final tokenValue = tokensData['accessToken'];
                if (tokenValue != null) {
                  accessToken = tokenValue.toString();
                  debugPrint('🔍 [AUTH_DEBUG] Access token from tokens.accessToken: ${accessToken.isNotEmpty ? 'present' : 'empty'}');
                }
              }
              if (tokensData.containsKey('refreshToken')) {
                final refreshTokenValue = tokensData['refreshToken'];
                if (refreshTokenValue != null) {
                  refreshToken = refreshTokenValue.toString();
                  debugPrint('🔍 [AUTH_DEBUG] Refresh token: ${refreshToken.isNotEmpty ? 'present' : 'empty'}');
                }
              }
            }
          }
          
          debugPrint('🔍 [AUTH_DEBUG] Final validation - accessToken: ${accessToken.isNotEmpty ? 'present' : 'empty'}, user: ${user != null ? 'present' : 'null'}');
          
          if (accessToken.isNotEmpty && user != null) {
            try {
              // Store tokens and user data
              debugPrint('🔍 [AUTH_DEBUG] Storing tokens and user data...');
              await DioService.instance.setTokens(accessToken, refreshToken);
              
              // Use safe storage method
              final storageSuccess = await _safeStoreUserData(user);
              if (!storageSuccess) {
                debugPrint('🔍 [AUTH_DEBUG] Failed to store user data safely');
                return _createErrorResponse('خطأ في حفظ بيانات المستخدم');
              }
              
              debugPrint('🔍 [AUTH_DEBUG] Login successful for user: ${user.phone} (${user.fullNameAr?.isNotEmpty == true ? user.fullNameAr : 'No name'})');
              
              return AuthResponse(
                accessToken: accessToken,
                refreshToken: refreshToken,
                user: user,
                success: true,
                message: 'تم تسجيل الدخول بنجاح',
                token: accessToken,
              );
            } catch (storageError) {
              _printDetailedError('Error storing user data in login', storageError, null, additionalData: {
                'userId': user.id,
                'userPhone': user.phone,
                'accessTokenLength': accessToken.length,
              });
              return _createErrorResponse('خطأ في حفظ بيانات المستخدم');
            }
          } else {

            debugPrint('🔍 [AUTH_DEBUG] Login failed: Missing access token or user data');
            debugPrint('🔍 [AUTH_DEBUG] - accessToken empty: ${accessToken.isEmpty}');
            debugPrint('🔍 [AUTH_DEBUG] - user is null: ${user == null}');
            return _createErrorResponse('خطأ في استجابة الخادم - بيانات المستخدم غير مكتملة');
          }
        } else {
          debugPrint('🔍 [AUTH_DEBUG] Invalid response structure - missing user or tokens');
          debugPrint('🔍 [AUTH_DEBUG] Response keys: ${responseData.keys.toList()}');
          return _createErrorResponse('استجابة غير صحيحة من الخادم - هيكل البيانات غير مكتمل');
        }
      } else {
        debugPrint('🔍 [AUTH_DEBUG] Invalid response - status: ${response.statusCode}, data null: ${response.data == null}');
        return _createErrorResponse('استجابة غير صحيحة من الخادم');
      }
      
      // If we reach here, something went wrong
      return _createErrorResponse('استجابة غير صحيحة من الخادم');
      
    } on DioException catch (e) {
      debugPrint('🔍 [AUTH_DEBUG] DioException: ${e.response?.statusCode} - ${e.message}');
      
      // Handle specific error status codes
      if (e.response?.statusCode == 401) {
        return _createErrorResponse('رقم الهاتف أو كلمة المرور غير صحيحة');
      } else if (e.response?.statusCode == 422) {
        return _createErrorResponse('خطأ في البيانات المدخلة');
      } else if (e.response?.statusCode == 400) {
        return _createErrorResponse('طلب غير صحيح');
      } else if (e.response?.statusCode == 500) {
        return _createErrorResponse('خطأ في الخادم');
      } else {
        // Network or connection error
        return _createErrorResponse('خطأ في الاتصال بالإنترنت - يرجى التحقق من الاتصال');
      }
    } catch (e) {
      debugPrint('🔍 [AUTH_DEBUG] General error: $e');
      
      // Determine error type for better user feedback
      String errorMessage = 'خطأ في الاتصال بالإنترنت - يرجى التحقق من الاتصال';
      
      if (e.toString().contains('SocketException') || 
          e.toString().contains('NetworkException') ||
          e.toString().contains('Connection refused')) {
        errorMessage = 'لا يمكن الاتصال بالخادم - تحقق من الاتصال بالإنترنت';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'انتهت مهلة الاتصال - حاول مرة أخرى';
      } else if (e.toString().contains('FormatException') || 
                 e.toString().contains('JsonUnsupportedObjectError')) {
        errorMessage = 'خطأ في تحليل البيانات من الخادم';
      } else if (e.toString().contains('CORS') || 
                 e.toString().contains('Cross-Origin')) {
        errorMessage = 'خطأ في إعدادات الأمان - اتصل بالدعم الفني';
      }
      
      return _createErrorResponse(errorMessage);
    }
  }

  // Register with improved error handling and registration settings validation
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      debugPrint('Attempting registration for phone: ${request.phone}');
      
      // Check registration status first
      final registrationAllowed = await _registrationSettingsService.validateRegistrationAllowed();
      if (!registrationAllowed) {
        final status = await _registrationSettingsService.checkRegistrationStatus();
        return _createErrorResponse(status.message ?? 'Registration is not currently available');
      }
      
      // Make direct API call instead of using the wrapped ApiService
      final dio = DioService.instance.dio;
      final response = await dio.post(
        '/api/v1/auth/register',
        data: request.toJson(),
      );
      
      debugPrint('Registration API response: status=${response.statusCode}, data=${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          // The backend returns direct response: {message, phone, otpCode}
          // We need to create an AuthResponse from this
          final responseData = response.data as Map<String, dynamic>;
          
          // Create a registration success response
          final authResponse = AuthResponse(
            success: true,
            message: responseData['message'] as String? ?? 'Registration successful',
            accessToken: null,
            refreshToken: null,
            user: null,
            token: null,
          );
          
          debugPrint('Registration successful - AuthResponse created');
          return authResponse;
        } catch (e, stackTrace) {
          debugPrint('Error parsing registration response: $e');
          debugPrint('Stack trace: $stackTrace');
          debugPrint('Raw response data: ${response.data}');
          return _createErrorResponse('Registration parsing error: $e');
        }
      } else {
        debugPrint('Registration failed with status: ${response.statusCode}');
        return _createErrorResponse('Registration failed');
      }
    } on DioException catch (e) {
      debugPrint('Registration DioException: ${e.response?.statusCode} - ${e.response?.data}');
      
      if (e.response?.statusCode == 409) {
        return _createErrorResponse('Phone number or email already exists');
      } else if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        final message = errors?.values.first?.first ?? 'Validation error';
        return _createErrorResponse(message);
      } else if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data['message'] ?? 'Bad request';
        return _createErrorResponse(errorMessage);
      } else if (e.response?.statusCode == 503) {
        // Handle registration closed/maintenance
        return _createErrorResponse('Registration is temporarily unavailable');
      }
      
      return _createErrorResponse('Registration failed: ${e.message}');
    } catch (e) {
      debugPrint('Registration error: $e');
      return _createErrorResponse('Network error: $e');
    }
  }

  // Request OTP - simplified version without channel selection
  Future<ApiResponse> requestOtp(String phoneNumber, {String purpose = 'registration'}) async {
    try {
      debugPrint('🔍 [OTP_REQUEST] Requesting OTP for phone: $phoneNumber, purpose: $purpose');
      
      // Direct API call for OTP request - server will use default channel
      final dio = DioService.instance.dio;
      final requestData = {
        'phone': phoneNumber,
        'purpose': purpose,
      };
      
      debugPrint('🔍 [OTP_REQUEST] Request data: $requestData');
      
      final response = await dio.post(
        '/api/v1/auth/request-otp',
        data: requestData,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('🔍 [OTP_REQUEST] OTP request successful');
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'OTP sent successfully',
          data: response.data,
        );
      } else {
        debugPrint('🔍 [OTP_REQUEST] OTP request failed: ${response.data}');
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      debugPrint('🔍 [OTP_REQUEST] OTP request error: $e');
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Verify OTP with improved error handling
  Future<AuthResponse> verifyOtp(String phoneNumber, String otp) async {
    try {
      debugPrint('Verifying OTP for phone: $phoneNumber');
      
      final otpRequest = OtpVerifyRequest(
        phone: phoneNumber,
        otp: otp,
      );
      
      // Make direct Dio call to bypass generated API service and handle response manually
      final dio = DioService.instance.dio;
      final response = await dio.post(
        '/api/v1/auth/verify-otp',
        data: otpRequest.toJson(),
      );
      
      debugPrint('🔍 [OTP_DEBUG] Raw response received successfully');
      debugPrint('🔍 [OTP_DEBUG] Response status: ${response.statusCode}');
      debugPrint('🔍 [OTP_DEBUG] Response data type: ${response.data.runtimeType}');
      debugPrint('🔍 [OTP_DEBUG] Response data: ${response.data}');
      
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Response data is not a Map<String, dynamic>: ${response.data.runtimeType}');
      }
      
      final responseData = response.data as Map<String, dynamic>;
      debugPrint('🔍 [OTP_DEBUG] Response data keys: ${responseData.keys.toList()}');
      
      // Use AuthResponse.fromJsonSafe to parse the response directly
      debugPrint('🔍 [OTP_DEBUG] Attempting to parse AuthResponse with fromJsonSafe...');
      final authResponse = AuthResponse.fromJsonSafe(responseData);
      
      // Store tokens using DioService to ensure consistency
      final accessToken = authResponse.accessToken ?? '';
      final refreshToken = authResponse.refreshToken ?? '';
      
      if (accessToken.isNotEmpty) {
        await DioService.instance.setTokens(accessToken, refreshToken);
      }
      
      // Store user data
      if (authResponse.user != null) {
        try {
          final storageSuccess = await _safeStoreUserData(authResponse.user!);
          if (!storageSuccess) {
            debugPrint('🔍 [OTP_DEBUG] Failed to store user data safely');
            // Continue without failing the entire operation
          }
        } catch (storageError) {
          _printDetailedError('Error storing user data in OTP verification', storageError, null, additionalData: {
            'userId': authResponse.user?.id,
            'userPhone': authResponse.user?.phone,
          });
          // Continue without failing the entire operation
        }
      }
      
      debugPrint('🔍 [OTP_DEBUG] OTP verification successful');
      return authResponse;
      
    } on DioException catch (e) {
      debugPrint('🔍 [OTP_DEBUG] DioException caught: ${e.response?.statusCode} - ${e.message}');
      
      // Handle successful response that comes as DioException due to parsing issues
      if (e.response?.statusCode == 200 && e.response?.data != null) {
        try {
          debugPrint('🔍 [OTP_DEBUG] Processing 200 response from DioException...');
          final data = e.response!.data as Map<String, dynamic>;
          debugPrint('🔍 [OTP_DEBUG] Raw response data: $data');
          
          final authResponse = AuthResponse.fromJsonSafe(data);
          
          // Store tokens using DioService to ensure consistency
          final accessToken = authResponse.accessToken ?? '';
          final refreshToken = authResponse.refreshToken ?? '';
          
          if (accessToken.isNotEmpty) {
            await DioService.instance.setTokens(accessToken, refreshToken);
          }
          
          // Store user data
          if (authResponse.user != null) {
            try {
              final storageSuccess = await _safeStoreUserData(authResponse.user!);
              if (!storageSuccess) {
                debugPrint('🔍 [OTP_DEBUG] Failed to store user data safely (from DioException)');
                // Continue without failing the entire operation
              }
            } catch (storageError) {
              _printDetailedError('Error storing user data in OTP verification (DioException)', storageError, null, additionalData: {
                'userId': authResponse.user?.id,
                'userPhone': authResponse.user?.phone,
              });
              // Continue without failing the entire operation
            }
          }
          
          debugPrint('🔍 [OTP_DEBUG] OTP verification successful (from DioException)');
          return authResponse;
        } catch (parseError) {
          debugPrint('🔍 [OTP_DEBUG] Error parsing successful OTP response: $parseError');
        }
      }
      
      if (e.response?.statusCode == 400) {
        final errorMessage = e.response?.data['message'] ?? 'رمز التحقق غير صحيح';
        // Check for specific error messages
        if (errorMessage.toLowerCase().contains('expired')) {
          return _createErrorResponse('انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد');
        } else if (errorMessage.toLowerCase().contains('attempts')) {
          return _createErrorResponse('محاولات كثيرة جداً. يرجى طلب رمز جديد');
        }
        return _createErrorResponse('رمز التحقق غير صحيح');
      } else if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        final message = errors?.values.first?.first ?? 'خطأ في التحقق من البيانات';
        return _createErrorResponse('رمز التحقق غير صحيح');
      } else if (e.response?.statusCode == 410) {
        return _createErrorResponse('انتهت صلاحية رمز التحقق. يرجى طلب رمز جديد');
      }
      
      return _createErrorResponse(e.response?.data['message'] ?? 'OTP verification failed');
    } catch (e) {
      debugPrint('OTP verification error: $e');
      return _createErrorResponse('Network error: $e');
    }
  }

  // Resend OTP
  Future<ApiResponse> resendOtp(String phoneNumber) async {
    try {
      debugPrint('🔍 [RESEND_OTP] Resending OTP for phone: $phoneNumber');
      
      // Use the same requestOtp method with proper parameters
      return await requestOtp(phoneNumber, purpose: 'registration');
    } catch (e) {
      debugPrint('🔍 [RESEND_OTP] Resend OTP error: $e');
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Get OTP channels from registration settings (simplified)
  Future<List<String>> getOtpChannels() async {
    try {
      debugPrint('Getting OTP channels from registration settings');
      
      final channels = await _registrationSettingsService.getAvailableOtpChannels();
      debugPrint('OTP channels retrieved: ${channels.length} channels');
      
      return channels;
    } catch (e) {
      debugPrint('Error getting OTP channels: $e');
      // Return default SMS channel
      return ['SMS'];
    }
  }



  // Refresh token
  Future<AuthResponse> refreshToken() async {
    try {
      final storedRefreshToken = await DioService.instance.getRefreshToken();
      
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        return _createErrorResponse('No refresh token available');
      }
      
      debugPrint('Refreshing token');
      
      final response = await _apiService.refreshToken(storedRefreshToken);
      
      if (response.success && response.accessToken != null && response.accessToken!.isNotEmpty) {
        // Store new tokens using DioService to ensure consistency
        final refreshTokenValue = response.refreshToken ?? '';
        await DioService.instance.setTokens(response.accessToken!, refreshTokenValue);
        
        debugPrint('Token refresh successful');
        return response;
      } else {
        debugPrint('Token refresh failed: ${response.message}');
        return _createErrorResponse(response.message ?? 'Token refresh failed');
      }
    } on DioException catch (e) {
      debugPrint('Token refresh DioException: ${e.response?.statusCode} - ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        // Refresh token is invalid, user needs to login again
        await logout();
        return _createErrorResponse('Session expired. Please login again.');
      }
      
      return _createErrorResponse(e.response?.data['message'] ?? 'Token refresh failed');
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return _createErrorResponse('Network error: $e');
    }
  }

  // Logout
  Future<bool> logout() async {
    try {
      final accessToken = await DioService.instance.getAccessToken();
      
      if (accessToken != null && accessToken.isNotEmpty) {
        debugPrint('Logging out user');
        
        try {
          await _apiService.logout();
        } catch (e) {
          debugPrint('Logout API call failed: $e');
          // Continue with local logout even if API call fails
        }
      }
      
      // Clear stored data using DioService to ensure consistency
      await DioService.instance.clearTokens();
      await _storageService.remove('user_data');
      
      debugPrint('Logout successful');
      return true;
    } catch (e) {
      debugPrint('Logout error: $e');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final accessToken = await DioService.instance.getAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return false;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = _storageService.getString('user_data');
      if (userData != null && userData.isNotEmpty) {
        try {
          // Try to parse as JSON first
          if (userData.startsWith('{')) {
            final userMap = jsonDecode(userData) as Map<String, dynamic>;
            return UserModel.fromJsonSafe(userMap);
          } else {
            // Old format, clear and return null
            await _storageService.remove('user_data');
            return null;
          }
        } catch (parseError) {
          debugPrint('Error parsing user data: $parseError');
          // Clear corrupted data
          await _storageService.remove('user_data');
          return null;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Get access token
  Future<String?> getAccessToken() async {
    try {
      return await DioService.instance.getAccessToken();
    } catch (e) {
      debugPrint('Error getting access token: $e');
      return null;
    }
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await DioService.instance.getRefreshToken();
    } catch (e) {
      debugPrint('Error getting refresh token: $e');
      return null;
    }
  }

  // Check user status
  Future<ApiResponse> checkUserStatus(String phoneNumber) async {
    try {
      debugPrint('Checking user status for phone: $phoneNumber');
      
      final response = await _apiService.checkUserStatus({
        'phone': phoneNumber,
      });
      
      debugPrint('User status check result: ${response.message}');
      return response;
    } catch (e) {
      debugPrint('Error checking user status: $e');
      return ApiResponse(
        success: false,
        message: 'Failed to check user status: $e',
      );
    }
  }

  // Check if registration is allowed
  Future<bool> isRegistrationAllowed() async {
    try {
      return await _registrationSettingsService.validateRegistrationAllowed();
    } catch (e) {
      debugPrint('Error checking registration status: $e');
      return false;
    }
  }

  // Get registration status
  Future<RegistrationStatusResponse> getRegistrationStatus() async {
    try {
      return await _registrationSettingsService.checkRegistrationStatus();
    } catch (e) {
      debugPrint('Error getting registration status: $e');
      return const RegistrationStatusResponse(
        canRegister: false,
        status: RegistrationStatus.maintenance,
        message: 'Unable to check registration status',
      );
    }
  }

  // Get registration settings
  Future<RegistrationSettingsModel> getRegistrationSettings() async {
    try {
      return await _registrationSettingsService.getCurrentSettings();
    } catch (e) {
      debugPrint('Error getting registration settings: $e');
      rethrow;
    }
  }

  // Select OTP channel for user
  Future<OtpChannelSelection> selectOtpChannel(
    String phoneNumber,
    List<OtpChannelModel> availableChannels,
  ) async {
    try {
      return await _registrationSettingsService.selectOtpChannel(
        phoneNumber,
        availableChannels,
      );
    } catch (e) {
      debugPrint('Error selecting OTP channel: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<UserModel> getUserProfile() async {
    try {
      debugPrint('Getting user profile');
      final result = await _apiService.getUserProfile();
      debugPrint('Profile fetch successful');
      return result;
    } catch (e) {
      debugPrint('Error getting profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<UserModel> updateUserProfile(UserProfileModel profile) async {
    try {
      debugPrint('Updating user profile');
      final result = await _apiService.updateUserProfile(profile);
      debugPrint('Profile update successful');
      return result;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }

  // Request password reset OTP - simplified version
  Future<PasswordResetResponse> requestPasswordReset(String phone) async {
    try {
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] ===== بدء طلب إعادة تعيين كلمة المرور =====');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Phone number received: "$phone"');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Phone number length: ${phone.length}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Phone number starts with +: ${phone.startsWith('+')}');
      
      // Clean and validate phone number
      String cleanPhone = phone.trim();
      if (!cleanPhone.startsWith('+')) {
        debugPrint('🔍 [PASSWORD_RESET_DEBUG] Phone number does not start with +, adding +967');
        cleanPhone = '+967$cleanPhone';
      }
      
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Cleaned phone number: "$cleanPhone"');
      
      final requestData = {
        'phone': cleanPhone,
      };
      
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Request data: $requestData');
      
      // Make direct Dio call to handle response manually
      final dio = DioService.instance.dio;
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Making POST request to: /api/v1/auth/request-password-reset');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Request headers: ${dio.options.headers}');
      
      final response = await dio.post(
        '/api/v1/auth/request-password-reset',
        data: requestData,
      );
      
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] ===== استجابة ناجحة =====');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response status: ${response.statusCode}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response headers: ${response.headers}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response data type: ${response.data.runtimeType}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response data: ${response.data}');
      
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Response data is not a Map<String, dynamic>: ${response.data.runtimeType}');
      }
      
      final responseData = response.data as Map<String, dynamic>;
      final passwordResetResponse = PasswordResetResponse.fromJson(responseData);
      
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Password reset request successful');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] ===== انتهاء طلب إعادة تعيين كلمة المرور بنجاح =====');
      return passwordResetResponse;
      
    } on DioException catch (e) {
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] ===== خطأ DioException =====');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Error type: ${e.type}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Error message: ${e.message}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response status code: ${e.response?.statusCode}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response status message: ${e.response?.statusMessage}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response headers: ${e.response?.headers}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response data type: ${e.response?.data.runtimeType}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response data: ${e.response?.data}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Request path: ${e.requestOptions.path}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Request method: ${e.requestOptions.method}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Request data: ${e.requestOptions.data}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Request headers: ${e.requestOptions.headers}');
      
      String errorMessage = 'حدث خطأ أثناء طلب إعادة تعيين كلمة المرور';
      
      if (e.response?.data != null) {
        try {
          if (e.response!.data is Map<String, dynamic>) {
            final errorData = e.response!.data as Map<String, dynamic>;
            debugPrint('🔍 [PASSWORD_RESET_DEBUG] Error data keys: ${errorData.keys.toList()}');
            
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'] ?? errorMessage;
              debugPrint('🔍 [PASSWORD_RESET_DEBUG] Server error message: $errorMessage');
            }
            
            if (errorData.containsKey('errors')) {
              debugPrint('🔍 [PASSWORD_RESET_DEBUG] Validation errors: ${errorData['errors']}');
            }
            
            if (errorData.containsKey('statusCode')) {
              debugPrint('🔍 [PASSWORD_RESET_DEBUG] Server status code: ${errorData['statusCode']}');
            }
          } else if (e.response!.data is String) {
            debugPrint('🔍 [PASSWORD_RESET_DEBUG] Error response is string: ${e.response!.data}');
            errorMessage = e.response!.data;
          }
        } catch (parseError) {
          debugPrint('🔍 [PASSWORD_RESET_DEBUG] Error parsing response data: $parseError');
        }
      }
      
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Final error message: $errorMessage');
      throw Exception(errorMessage);
      
    } catch (e) {
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] ===== خطأ عام =====');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Unexpected error type: ${e.runtimeType}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Unexpected error: $e');
      throw Exception('حدث خطأ غير متوقع أثناء طلب إعادة تعيين كلمة المرور: $e');
    }
  }



  // Reset password with OTP
  Future<PasswordResetResponse> resetPassword(String phone, String otp, String newPassword) async {
    try {
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Resetting password for phone: $phone');
      
      final request = ResetPasswordRequest(
        phone: phone,
        otp: otp,
        newPassword: newPassword,
      );
      
      // Make direct Dio call to handle response manually
      final dio = DioService.instance.dio;
      final response = await dio.post(
        '/api/v1/auth/reset-password',
        data: request.toJson(),
      );
      
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Raw response received successfully');
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Response status: ${response.statusCode}');
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Response data: ${response.data}');
      
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Response data is not a Map<String, dynamic>: ${response.data.runtimeType}');
      }
      
      final responseData = response.data as Map<String, dynamic>;
      final passwordResetResponse = PasswordResetResponse.fromJson(responseData);
      
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Password reset successful');
      return passwordResetResponse;
      
    } on DioException catch (e) {
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] DioException occurred: ${e.message}');
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Response data: ${e.response?.data}');
      
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? 'حدث خطأ أثناء إعادة تعيين كلمة المرور';
        throw Exception(errorMessage);
      }
      
      throw Exception('حدث خطأ في الشبكة أثناء إعادة تعيين كلمة المرور');
    } catch (e) {
      debugPrint('🔍 [RESET_PASSWORD_DEBUG] Unexpected error: $e');
      throw Exception('حدث خطأ غير متوقع أثناء إعادة تعيين كلمة المرور');
    }
  }
}

// Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});
