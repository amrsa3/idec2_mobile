import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/api_response_model.dart';
import '../models/registration_settings_model.dart';
import '../core/constants/app_constants.dart';
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
      
      final dio = DioService.instance.dio;
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
            debugPrint('🔍 [AUTH_DEBUG] User parsed successfully: ${user.phone}');
          } catch (userParseError) {
            debugPrint('🔍 [AUTH_DEBUG] Error parsing user data: $userParseError');
            return _createErrorResponse('خطأ في تحليل بيانات المستخدم من الخادم');
          }
          
          // Extract tokens
          String accessToken = '';
          String refreshToken = '';
          
          // Get access token from either location
          if (responseData.containsKey('access_token')) {
            accessToken = responseData['access_token'].toString();
          }
          
          if (responseData.containsKey('tokens')) {
            final tokensData = responseData['tokens'] as Map<String, dynamic>;
            if (accessToken.isEmpty && tokensData.containsKey('accessToken')) {
              accessToken = tokensData['accessToken'].toString();
            }
            if (tokensData.containsKey('refreshToken')) {
              refreshToken = tokensData['refreshToken'].toString();
            }
          }
          
          if (accessToken.isNotEmpty && user != null) {
            // Store tokens and user data
            await DioService.instance.setTokens(accessToken, refreshToken);
            await _storageService.setString('user_data', jsonEncode(user.toJson()));
            
            debugPrint('🔍 [AUTH_DEBUG] Login successful for user: ${user.phone} (${user.fullNameAr.isNotEmpty ? user.fullNameAr : 'No name'})');
            
            return AuthResponse(
              accessToken: accessToken,
              refreshToken: refreshToken,
              user: user,
              success: true,
              message: 'تم تسجيل الدخول بنجاح',
              token: accessToken,
            );
          } else {
            debugPrint('🔍 [AUTH_DEBUG] Login failed: Missing access token or user data');
            return _createErrorResponse('خطأ في استجابة الخادم - بيانات المستخدم غير مكتملة');
          }
        }
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

  // Request OTP with improved error handling and dynamic channel selection
  Future<ApiResponse> requestOtp(String phoneNumber, {String? channel}) async {
    try {
      debugPrint('Requesting OTP for phone: $phoneNumber');
      
      // Get available channels and select appropriate one
      String selectedChannel = channel ?? 'sms';
      
      if (channel == null) {
        try {
          final defaultChannel = await _registrationSettingsService.getDefaultOtpChannel();
          if (defaultChannel != null) {
            selectedChannel = defaultChannel;
            debugPrint('Using default OTP channel: $selectedChannel');
          }
        } catch (e) {
          debugPrint('Failed to get default channel, using SMS: $e');
        }
      }
      
      debugPrint('Sending OTP via channel: $selectedChannel');
      
      // Direct API call for OTP request
      final dio = DioService.instance.dio;
      final response = await dio.post(
        '/api/v1/auth/request-otp',
        data: {
          'phone': phoneNumber,
          'channel': selectedChannel,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('OTP request successful via $selectedChannel');
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? 'OTP sent successfully',
          data: response.data,
        );
      } else {
        debugPrint('OTP request failed: ${response.data}');
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      debugPrint('OTP request error: $e');
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
        await _storageService.setString('user_data', jsonEncode(authResponse.user!.toJson()));
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
            await _storageService.setString('user_data', jsonEncode(authResponse.user!.toJson()));
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
  Future<ApiResponse> resendOtp(String phoneNumber, {String channel = 'sms'}) async {
    try {
      debugPrint('Resending OTP for phone: $phoneNumber via $channel');
      
      final otpRequest = OtpRequest(
        phone: phoneNumber,
        channel: channel,
      );
      
      final response = await _apiService.resendOtp(otpRequest);
      
      if (response.success) {
        debugPrint('OTP resend successful');
        return response;
      } else {
        debugPrint('OTP resend failed: ${response.message}');
        return ApiResponse(
          success: false,
          message: response.message ?? 'Failed to resend OTP',
        );
      }
    } on DioException catch (e) {
      debugPrint('OTP resend DioException: ${e.response?.statusCode} - ${e.response?.data}');
      
      if (e.response?.statusCode == 429) {
        return const ApiResponse(success: false, message: 'Too many requests. Please wait before requesting again.');
      }
      
      return ApiResponse(
        success: false,
        message: e.response?.data['message'] ?? 'Failed to resend OTP',
      );
    } catch (e) {
      debugPrint('OTP resend error: $e');
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
        await DioService.instance.setTokens(response.accessToken!, response.refreshToken!);
        
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

  // Request password reset OTP
  Future<PasswordResetResponse> requestPasswordReset(String phone, {String? preferredChannel}) async {
    try {
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Requesting password reset for phone: $phone');
      
      final request = RequestPasswordResetRequest(
        phone: phone,
        preferredChannel: preferredChannel,
      );
      
      // Make direct Dio call to handle response manually
      final dio = DioService.instance.dio;
      final response = await dio.post(
        '/api/v1/auth/request-password-reset-otp',
        data: request.toJson(),
      );
      
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Raw response received successfully');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response status: ${response.statusCode}');
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
      return passwordResetResponse;
      
    } on DioException catch (e) {
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] DioException occurred: ${e.message}');
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Response data: ${e.response?.data}');
      
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? 'حدث خطأ أثناء طلب إعادة تعيين كلمة المرور';
        throw Exception(errorMessage);
      }
      
      throw Exception('حدث خطأ في الشبكة أثناء طلب إعادة تعيين كلمة المرور');
    } catch (e) {
      debugPrint('🔍 [PASSWORD_RESET_DEBUG] Unexpected error: $e');
      throw Exception('حدث خطأ غير متوقع أثناء طلب إعادة تعيين كلمة المرور');
    }
  }

  // Confirm password reset OTP sending after channel selection
  Future<PasswordResetResponse> confirmPasswordResetOtp({
    required String phoneNumber,
    required String selectedChannel,
    required String purpose,
  }) async {
    try {
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Confirming password reset OTP for phone: $phoneNumber');
      
      final requestData = {
        'phoneNumber': phoneNumber,
        'selectedChannel': selectedChannel,
        'purpose': purpose,
      };
      
      // Make direct Dio call to handle response manually
      final dio = DioService.instance.dio;
      final response = await dio.post(
        '/api/v1/auth/confirm-password-reset-otp',
        data: requestData,
      );
      
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Raw response received successfully');
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Response status: ${response.statusCode}');
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Response data: ${response.data}');
      
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      
      if (response.data is! Map<String, dynamic>) {
        throw Exception('Response data is not a Map<String, dynamic>: ${response.data.runtimeType}');
      }
      
      final responseData = response.data as Map<String, dynamic>;
      final passwordResetResponse = PasswordResetResponse.fromJson(responseData);
      
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Password reset OTP confirmation successful');
      return passwordResetResponse;
      
    } on DioException catch (e) {
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] DioException occurred: ${e.message}');
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Response status: ${e.response?.statusCode}');
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] Response data: ${e.response?.data}');
      
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? 'حدث خطأ أثناء تأكيد إرسال كود إعادة تعيين كلمة المرور';
        throw Exception(errorMessage);
      }
      
      throw Exception('حدث خطأ في الشبكة أثناء تأكيد إرسال كود إعادة تعيين كلمة المرور');
    } catch (e) {
      debugPrint('🔍 [CONFIRM_PASSWORD_RESET_DEBUG] General exception: $e');
      throw Exception('حدث خطأ غير متوقع أثناء تأكيد إرسال كود إعادة تعيين كلمة المرور');
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
