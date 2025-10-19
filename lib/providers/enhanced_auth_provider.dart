import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../models/api_response_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/enhanced_session_manager.dart';
import '../services/platform_storage_service.dart';
import '../services/unified_token_manager.dart';

/// Enhanced AuthState with better web support and session management
class EnhancedAuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final bool phoneVerified;
  final bool isRegistering;
  final bool sessionExpired;
  final String? sessionExpiredReason;
  final String? unverifiedPhoneNumber;
  final SessionState sessionState;
  final bool isOffline;
  final DateTime? lastActivity;

  const EnhancedAuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.phoneVerified = false,
    this.isRegistering = false,
    this.sessionExpired = false,
    this.sessionExpiredReason,
    this.unverifiedPhoneNumber,
    this.sessionState = SessionState.none,
    this.isOffline = false,
    this.lastActivity,
  });

  EnhancedAuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    bool? phoneVerified,
    bool? isRegistering,
    bool? sessionExpired,
    String? sessionExpiredReason,
    String? unverifiedPhoneNumber,
    SessionState? sessionState,
    bool? isOffline,
    DateTime? lastActivity,
  }) {
    return EnhancedAuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isRegistering: isRegistering ?? this.isRegistering,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      sessionExpiredReason: sessionExpiredReason,
      unverifiedPhoneNumber: unverifiedPhoneNumber ?? this.unverifiedPhoneNumber,
      sessionState: sessionState ?? this.sessionState,
      isOffline: isOffline ?? this.isOffline,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnhancedAuthState &&
        other.user == user &&
        other.isAuthenticated == isAuthenticated &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.phoneVerified == phoneVerified &&
        other.isRegistering == isRegistering &&
        other.sessionExpired == sessionExpired &&
        other.sessionExpiredReason == sessionExpiredReason &&
        other.unverifiedPhoneNumber == unverifiedPhoneNumber &&
        other.sessionState == sessionState &&
        other.isOffline == isOffline &&
        other.lastActivity == lastActivity;
  }

  @override
  int get hashCode {
    return Object.hash(
      user,
      isAuthenticated,
      isLoading,
      error,
      phoneVerified,
      isRegistering,
      sessionExpired,
      sessionExpiredReason,
      unverifiedPhoneNumber,
      sessionState,
      isOffline,
      lastActivity,
    );
  }
}

/// Enhanced AuthNotifier with unified token management and web support
class EnhancedAuthNotifier extends StateNotifier<EnhancedAuthState> {
  final AuthService _authService;
  final UnifiedTokenManager _tokenManager;
  final EnhancedSessionManager _sessionManager;
  final PlatformStorageService _storageService;

  StreamSubscription? _sessionSubscription;
  StreamSubscription? _tokenSubscription;
  Timer? _activityTimer;

  EnhancedAuthNotifier(
    this._authService,
    this._tokenManager,
    this._sessionManager,
    this._storageService,
  ) : super(const EnhancedAuthState()) {
    _initialize();
  }

  /// Initialize the auth provider
  Future<void> _initialize() async {
    debugPrint('🔍 [ENHANCED_AUTH] Initializing Enhanced AuthProvider');
    
    try {
      // Initialize token manager
      await _tokenManager.initialize();
      
      // Initialize session manager
      await _sessionManager.initialize();
      
      // Listen to session events
      _listenToSessionEvents();
      
      // Listen to token events
      _listenToTokenEvents();
      
      // Check initial auth status
      await _checkInitialAuthStatus();
      
      // Start activity tracking
      _startActivityTracking();
      
      debugPrint('✅ [ENHANCED_AUTH] Enhanced AuthProvider initialized successfully');
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Initialization failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize authentication: $e',
      );
    }
  }

  /// Check initial authentication status
  Future<void> _checkInitialAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Check if we have valid tokens
      final hasValidTokens = await _tokenManager.hasValidSession();
      
      if (hasValidTokens) {
        // Try to load user data from storage
        final userData = await _loadUserDataFromStorage();
        
        if (userData != null) {
          // Verify tokens with server if online
          if (!state.isOffline) {
            try {
              // This will automatically refresh tokens if needed
              final isValid = await _tokenManager.hasValidSession();
              
              if (isValid) {
                state = state.copyWith(
                  user: userData,
                  isAuthenticated: true,
                  isLoading: false,
                  sessionState: SessionState.active,
                  lastActivity: DateTime.now(),
                );
                
                // Update session activity
                await _sessionManager.updateActivity();
                
                debugPrint('✅ [ENHANCED_AUTH] User authenticated from storage');
                return;
              }
            } catch (e) {
              debugPrint('⚠️ [ENHANCED_AUTH] Token verification failed: $e');
              // Continue with offline data if available
            }
          }
          
          // Use offline data
          state = state.copyWith(
            user: userData,
            isAuthenticated: true,
            isLoading: false,
            sessionState: SessionState.active,
            isOffline: true,
            lastActivity: DateTime.now(),
          );
          
          debugPrint('✅ [ENHANCED_AUTH] User authenticated from offline storage');
          return;
        }
      }
      
      // No valid authentication found
      await _clearAuthData();
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        sessionState: SessionState.none,
      );
      
      debugPrint('ℹ️ [ENHANCED_AUTH] No valid authentication found');
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Auth status check failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check authentication status: $e',
      );
    }
  }

  /// Listen to session events
  void _listenToSessionEvents() {
    _sessionSubscription = _sessionManager.sessionStateStream.listen((event) {
      debugPrint('🔍 [ENHANCED_AUTH] Session event: ${event.state}');
      
      switch (event.state) {
        case SessionState.expired:
          _handleSessionExpired('Session expired');
          break;
        case SessionState.active:
          // Session active
          state = state.copyWith(
            sessionExpired: false,
            sessionExpiredReason: null,
            lastActivity: DateTime.now(),
          );
          break;
        default:
          break;
      }
    });
  }

  /// Listen to token events
  void _listenToTokenEvents() {
    _tokenSubscription = _tokenManager.sessionEvents.listen((event) {
      debugPrint('🔍 [ENHANCED_AUTH] Token event: ${event.type}');
      
      switch (event.type) {
        case SessionEventType.sessionExpired:
          _handleSessionExpired('Token expired');
          break;
        case SessionEventType.tokenRefreshed:
          // Token refreshed successfully
          state = state.copyWith(
            sessionExpired: false,
            sessionExpiredReason: null,
            lastActivity: DateTime.now(),
          );
          break;
        default:
          break;
      }
    });
  }

  /// Start activity tracking
  void _startActivityTracking() {
    _activityTimer = Timer.periodic(const Duration(minutes: 5), (timer) { // تغيير من دقيقة إلى 5 دقائق
      if (state.isAuthenticated) {
        _sessionManager.updateActivity();
        state = state.copyWith(lastActivity: DateTime.now());
      }
    });
  }

  /// Handle session expiration
  void _handleSessionExpired(String reason) {
    debugPrint('🔍 [ENHANCED_AUTH] Session expired: $reason');
    
    state = state.copyWith(
      sessionExpired: true,
      sessionExpiredReason: reason,
      isAuthenticated: false,
      sessionState: SessionState.expired,
      error: reason,
    );
    
    // Clear authentication data
    _clearAuthData();
  }

  /// Login with phone number
  Future<bool> loginWithPhone(String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Attempting login for: $phoneNumber');
      
      final loginRequest = LoginRequest(phone: phoneNumber, password: password);
      final result = await _authService.login(loginRequest);
      
      if (result.success && result.user != null) {
        // Note: Tokens are already saved by AuthService with correct 30-day expiry
        // No need to save tokens again here to avoid overriding with incorrect expiry
        
        // Save user data
        await _saveUserData(result.user!);
        
        // Start session
        await _sessionManager.startSession(
          userId: result.user!.id,
          deviceId: result.user!.id, // Using user ID as device ID for now
          metadata: {'loginTime': DateTime.now().toIso8601String()},
        );
        
        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          phoneVerified: result.user!.phoneVerified,
          sessionState: SessionState.active,
          lastActivity: DateTime.now(),
        );
        
        debugPrint('✅ [ENHANCED_AUTH] Login successful');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'Login failed',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Login failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: $e',
      );
      return false;
    }
  }

  /// Register with phone number
  Future<bool> registerWithPhone(String phoneNumber, String password, String name) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Create register request
      final registerRequest = RegisterRequest(
        phone: phoneNumber,
        password: password,
        confirmPassword: password, // Use same password for confirmation
        name: name,
      );
      
      final result = await _authService.register(registerRequest);
      
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
      debugPrint('🔴 [ENHANCED_AUTH] Registration error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed: $e',
      );
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Verifying OTP for: $phoneNumber');
      
      final result = await _authService.verifyOtp(phoneNumber, otp);
      
      if (result.success && result.user != null) {
        // Note: Tokens are already saved by AuthService with correct 30-day expiry
        // No need to save tokens again here to avoid overriding with incorrect expiry
        
        // Save user data
        await _saveUserData(result.user!);
        
        // Start session
        await _sessionManager.startSession(
          userId: result.user!.id,
          deviceId: result.user!.id, // Using user ID as device ID for now
          metadata: {'otpVerificationTime': DateTime.now().toIso8601String()},
        );
        
        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          phoneVerified: true,
          isRegistering: false,
          sessionState: SessionState.active,
          lastActivity: DateTime.now(),
        );
        
        debugPrint('✅ [ENHANCED_AUTH] OTP verification successful');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'OTP verification failed',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] OTP verification failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'OTP verification failed: $e',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Logging out user');
      
      // Logout from server
      try {
        await _authService.logout();
      } catch (e) {
        debugPrint('⚠️ [ENHANCED_AUTH] Server logout failed (offline mode): $e');
      }
      
      // End session
      await _sessionManager.endSession();
      
      // Clear all authentication data
      await _clearAuthData();
      
      // Reset state
      state = const EnhancedAuthState();
      
      debugPrint('✅ [ENHANCED_AUTH] Logout successful');
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Logout failed: $e');
      // Force logout even if there are errors
      await _clearAuthData();
      state = const EnhancedAuthState();
    }
  }

  /// Refresh tokens
  Future<bool> refreshTokens() async {
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Refreshing tokens');
      
      final success = await _tokenManager.refreshAccessToken();
      
      if (success) {
        state = state.copyWith(
          sessionExpired: false,
          sessionExpiredReason: null,
          lastActivity: DateTime.now(),
        );
        debugPrint('✅ [ENHANCED_AUTH] Tokens refreshed successfully');
        return true;
      } else {
        debugPrint('❌ [ENHANCED_AUTH] Token refresh failed');
        _handleSessionExpired('Token refresh failed');
        return false;
      }
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Token refresh error: $e');
      _handleSessionExpired('Token refresh error: $e');
      return false;
    }
  }

  /// Clear session expiration state
  void clearSessionExpiration() {
    debugPrint('🔍 [ENHANCED_AUTH] Clearing session expiration state');
    state = state.copyWith(
      sessionExpired: false,
      sessionExpiredReason: null,
      error: null,
    );
    
    // Re-check authentication status
    _checkInitialAuthStatus();
  }

  /// Clear error
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  /// Update user activity
  void updateActivity() {
    if (state.isAuthenticated) {
      _sessionManager.updateActivity();
      state = state.copyWith(lastActivity: DateTime.now());
    }
  }

  /// Save user data to storage
  Future<void> _saveUserData(UserModel user) async {
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Saving user data for: ${user.id}');
      
      // Create safe minimal representation
      final userJson = {
        'id': user.id,
        'phone': user.phone,
        'email': user.email,
        'phoneVerified': user.phoneVerified,
        'roles': user.roles,
        'createdAt': user.createdAt?.toIso8601String(),
        'updatedAt': user.updatedAt?.toIso8601String(),
        'profile': user.profile?.toJson(),
      };
      
      final jsonString = jsonEncode(userJson);
      
      // Use platform storage service
      await _storageService.write(AppConstants.userKey, jsonString);
      
      debugPrint('✅ [ENHANCED_AUTH] User data saved successfully');
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Failed to save user data: $e');
      rethrow;
    }
  }

  /// Load user data from storage
  Future<UserModel?> _loadUserDataFromStorage() async {
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Loading user data from storage');
      
      final jsonString = await _storageService.read(AppConstants.userKey);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final userJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final user = UserModel.fromJson(userJson);
        
        debugPrint('✅ [ENHANCED_AUTH] User data loaded from storage: ${user.id}');
        return user;
      }
      
      debugPrint('ℹ️ [ENHANCED_AUTH] No user data found in storage');
      return null;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Failed to load user data: $e');
      return null;
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthData() async {
    try {
      debugPrint('🔍 [ENHANCED_AUTH] Clearing authentication data');
      
      // Clear user data
      await _storageService.delete(AppConstants.userKey);
      
      // Clear tokens
      await _tokenManager.clearTokens();
      
      debugPrint('✅ [ENHANCED_AUTH] Authentication data cleared');
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Failed to clear auth data: $e');
    }
  }

  /// Request password reset
  Future<bool> requestPasswordReset(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      debugPrint('🔍 [ENHANCED_AUTH] Requesting password reset for: $phoneNumber');
      
      // Call auth service to request password reset
      final result = await _authService.requestPasswordReset(phoneNumber);
      
      state = state.copyWith(
        isLoading: false,
        error: result.success ? null : (result.message ?? 'Failed to request password reset'),
      );
      
      return result.success;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Password reset request error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to request password reset: $e',
      );
      return false;
    }
  }

  /// Reset password with OTP
  Future<bool> resetPassword(String phoneNumber, String otpCode, String newPassword) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      debugPrint('🔍 [ENHANCED_AUTH] Resetting password for: $phoneNumber');
      
      // Call auth service to reset password
      final result = await _authService.resetPassword(phoneNumber, otpCode, newPassword);
      
      state = state.copyWith(
        isLoading: false,
        error: result.success ? null : (result.message ?? 'Failed to reset password'),
      );
      
      return result.success;
    } catch (e) {
      debugPrint('❌ [ENHANCED_AUTH] Password reset error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reset password: $e',
      );
      return false;
    }
  }

  /// Resend OTP for phone verification
  Future<ApiResponse> resendOtp(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final response = await _authService.sendOtp(phoneNumber);
      
      state = state.copyWith(
        isLoading: false,
        unverifiedPhoneNumber: phoneNumber,
      );
      
      return response;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return ApiResponse(success: false, message: e.toString());
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    _tokenSubscription?.cancel();
    _activityTimer?.cancel();
    super.dispose();
  }
}

// Provider instances
final authProvider = StateNotifierProvider<EnhancedAuthNotifier, EnhancedAuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final tokenManager = ref.watch(unifiedTokenManagerProvider);
  final sessionManager = ref.watch(enhancedSessionManagerProvider);
  final storageService = ref.watch(platformStorageServiceProvider);
  
  return EnhancedAuthNotifier(
    authService,
    tokenManager,
    sessionManager,
    storageService,
  );
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

final sessionStateProvider = Provider<SessionState>((ref) {
  return ref.watch(authProvider).sessionState;
});

final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isOffline;
});

// Provider dependencies
final unifiedTokenManagerProvider = Provider<UnifiedTokenManager>((ref) {
  return UnifiedTokenManager.instance;
});

final enhancedSessionManagerProvider = Provider<EnhancedSessionManager>((ref) {
  return EnhancedSessionManager.instance;
});

final platformStorageServiceProvider = Provider<PlatformStorageService>((ref) {
  return PlatformStorageService.instance;
});
