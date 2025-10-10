import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Auth state class
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final bool isEmailVerified;
  final bool phoneVerified;
  final bool isRegistering; // New field to track registration process

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.isEmailVerified = false,
    this.phoneVerified = false,
    this.isRegistering = false, // Default to false
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    bool? isEmailVerified,
    bool? phoneVerified,
    bool? isRegistering,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isRegistering: isRegistering ?? this.isRegistering,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.user == user &&
        other.isAuthenticated == isAuthenticated &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isEmailVerified == isEmailVerified &&
        other.phoneVerified == phoneVerified &&
        other.isRegistering == isRegistering;
  }

  @override
  int get hashCode => Object.hash(
        user,
        isAuthenticated,
        isLoading,
        error,
        isEmailVerified,
        phoneVerified,
        isRegistering,
      );
}

// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuthStatus();
  }

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    print('🔍 [AUTH_DEBUG] _checkAuthStatus - STARTED');
    state = state.copyWith(isLoading: true);
    print('🔍 [AUTH_DEBUG] _checkAuthStatus - isLoading set to true');

    try {
      final token = await _authService.getAccessToken();
      final currentUser = await _authService.getCurrentUser();

      print('🔍 [AUTH_DEBUG] _checkAuthStatus - token: ${token != null ? 'exists' : 'null'}');
      print('🔍 [AUTH_DEBUG] _checkAuthStatus - currentUser: ${currentUser != null ? 'exists' : 'null'}');

      if (token != null && currentUser != null) {
        try {
          print('🔍 [AUTH_DEBUG] _checkAuthStatus - user found: ${currentUser.id}');
          
          // First, set authenticated state with saved data (offline mode support)
          state = state.copyWith(
            user: currentUser,
            isAuthenticated: true,
            isLoading: false,
            isEmailVerified: currentUser.isEmailVerified,
            phoneVerified: currentUser.phoneVerified,
          );
          
          print('🔍 [AUTH_DEBUG] _checkAuthStatus - user authenticated from saved data (offline mode)');
          
          // Try to verify token with server (online mode) - but don't fail if offline
          try {
            final profile = await _authService.getUserProfile();
            // Token is valid, update with latest profile data
            state = state.copyWith(
              user: profile,
              isEmailVerified: profile.isEmailVerified,
              phoneVerified: profile.phoneVerified,
            );
            
            // Update saved user data with latest profile
            await _saveUserData(profile);
            
            print('🔍 [AUTH_DEBUG] _checkAuthStatus - profile updated from server (online mode)');
            return;
          } catch (e) {
            print('🔍 [AUTH_DEBUG] _checkAuthStatus - server verification failed (offline mode): $e');
            
            // Try to refresh token if it's expired (only if we have internet)
            try {
              print('🔍 [AUTH_DEBUG] _checkAuthStatus - attempting token refresh');
              final refreshResult = await _authService.refreshToken();
              
              if (refreshResult.success && refreshResult.user != null) {
                // Token refreshed successfully
                state = state.copyWith(
                  user: refreshResult.user,
                  isEmailVerified: refreshResult.user!.isEmailVerified,
                  phoneVerified: refreshResult.user!.phoneVerified,
                );
                
                // Update saved user data
                await _saveUserData(refreshResult.user!);
                
                print('🔍 [AUTH_DEBUG] _checkAuthStatus - token refreshed successfully');
                return;
              } else {
                print('🔍 [AUTH_DEBUG] _checkAuthStatus - token refresh failed, continuing with offline data');
              }
            } catch (refreshError) {
              print('🔍 [AUTH_DEBUG] _checkAuthStatus - token refresh error, continuing with offline data: $refreshError');
            }
            
            // Continue with saved data even if server verification failed (offline mode)
            print('🔍 [AUTH_DEBUG] _checkAuthStatus - continuing with offline data');
            return;
          }
        } catch (e) {
          print('🔍 [AUTH_DEBUG] _checkAuthStatus - error parsing saved data: $e');
          // Clear invalid data
          await _clearAuthData();
        }
      }

      // No valid saved data
      state = state.copyWith(isLoading: false, isAuthenticated: false);
      print('🔍 [AUTH_DEBUG] _checkAuthStatus - no valid saved data');
    } catch (e) {
      await _clearAuthData();
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check authentication status',
      );
    }
  }

  // Login with phone number
  Future<bool> loginWithPhone(String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final loginRequest = LoginRequest(phone: phoneNumber, password: password);
      final result = await _authService.login(loginRequest);
      
      debugPrint('AuthProvider: Login result - success: ${result.success}, user: ${result.user?.fullNameAr}, accessToken: ${result.accessToken?.isNotEmpty == true}');
      
      // Check if login was successful - be more flexible with success criteria
      if ((result.success || result.user != null) && 
          (result.accessToken?.isNotEmpty == true || result.token?.isNotEmpty == true)) {
        
        // Use accessToken or fallback to token field
        final token = (result.accessToken?.isNotEmpty == true) ? result.accessToken! : result.token!;
        
        await _saveAuthData(token, result.user!);
        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          isEmailVerified: result.user!.isEmailVerified,
          phoneVerified: result.user!.phoneVerified,
        );
        
        debugPrint('AuthProvider: Login successful, user authenticated: ${state.isAuthenticated}');
        return true;
      } else {
        debugPrint('AuthProvider: Login failed - ${result.message}');
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'فشل في تسجيل الدخول',
        );
        return false;
      }
    } catch (e) {
      debugPrint('AuthProvider: Login exception - $e');
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تسجيل الدخول: $e',
      );
      return false;
    }
  }

  // Legacy login method (for backward compatibility)
  Future<bool> login(String email, String password) async {
    return loginWithPhone(email, password);
  }

  // Register with phone number
  Future<bool> registerWithPhone(
    String fullName,
    String? email,
    String phoneNumber,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, error: null, isRegistering: true);

    try {
      final registerRequest = RegisterRequest(
        name: fullName,
        email: email,
        phone: phoneNumber,
        password: password,
        confirmPassword: password,
      );
      
      final result = await _authService.register(registerRequest);
      
      if (result.success) {
        // Registration successful, but don't authenticate until phone is verified
        // For registration, we don't get user data immediately, just success confirmation
        print('Registration successful in AuthProvider');
        state = state.copyWith(
          isLoading: false,
          user: null, // No user data until verification
          isAuthenticated: false, // Keep false until phone verification
          isEmailVerified: false,
          phoneVerified: false, // Always false after registration
          isRegistering: true, // Keep true until OTP verification
          error: null,
        );
        print('AuthProvider state updated: isAuthenticated=${state.isAuthenticated}, isRegistering=${state.isRegistering}');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          isRegistering: false,
          error: result.message ?? 'فشل في التسجيل',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRegistering: false,
        error: 'فشل في التسجيل: $e',
      );
      return false;
    }
  }

  // Legacy register method (for backward compatibility)
  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.register(request);
      
      // For registration, we don't expect user data or access tokens
      // Registration is successful if we get a success response with a message
      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed: $e',
      );
      return false;
    }
  }

  // Check registration settings
  Future<bool> checkRegistrationSettings() async {
    try {
      // TODO: Implement API call to check if registration is enabled
      // For now, return true (registration enabled)
      return true;
    } catch (e) {
      state = state.copyWith(error: 'فشل في فحص إعدادات التسجيل: $e');
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.verifyOtp(phoneNumber, otp);
      
      if (result.success && result.user != null) {
        // Use accessToken or fallback to token field
        final token = result.accessToken ?? result.token ?? '';
        if (token.isEmpty) {
          throw Exception('No access token received from server');
        }
        
        await _saveAuthData(token, result.user!);
        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          phoneVerified: true,
          isRegistering: false, // Reset registration state after successful verification
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'فشل في التحقق من رمز OTP',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في التحقق من رمز OTP: $e',
      );
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOtp(String phoneNumber) async {
    try {
      final result = await _authService.resendOtp(phoneNumber);
      if (!result.success) {
        state = state.copyWith(error: result.message);
      }
      return result.success;
    } catch (e) {
      state = state.copyWith(error: 'فشل في إعادة إرسال رمز OTP: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      print('🔍 [AUTH_DEBUG] logout - server logout successful');
    } catch (e) {
      // Continue with logout even if server call fails
      print('🔍 [AUTH_DEBUG] logout - server logout failed (offline mode): $e');
    }

    // Clear all authentication data
    await _clearAuthData();
    
    // Reset state to initial state
    state = const AuthState();
    
    print('🔍 [AUTH_DEBUG] logout - authentication data cleared, user logged out');
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      // For now, just return null since we don't have this endpoint
      state = state.copyWith(error: 'رفع صورة الملف الشخصي غير متاح حالياً');
      return null;
    } catch (e) {
      state = state.copyWith(error: 'فشل في رفع صورة الملف الشخصي: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authService.updateUserProfile(updatedUser.profile!);
      
      await _saveUserData(result);
      state = state.copyWith(
        user: result,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحديث الملف الشخصي: $e',
      );
      return false;
    }
  }

  // Clear error
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  // Helper methods
  Future<void> _saveAuthData(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
    print('🔍 [AUTH_DEBUG] _saveAuthData - token saved: ${token.substring(0, 20)}...');
    print('🔍 [AUTH_DEBUG] _saveAuthData - user saved: ${user.id}');
  }

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, jsonEncode(user.toJson()));
    print('🔍 [AUTH_DEBUG] _saveUserData - user saved: ${user.id}');
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    
    // Also clear any other authentication-related data
    await prefs.remove('refresh_token');
    await prefs.remove('access_token');
    
    print('🔍 [AUTH_DEBUG] _clearAuthData - all authentication data cleared');
  }


}

// Provider instance
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});
