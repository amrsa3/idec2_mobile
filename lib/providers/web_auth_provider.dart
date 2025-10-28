import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/enhanced_session_manager.dart';

import '../services/unified_token_manager.dart';
import '../services/web_compatible_storage.dart';

/// Web-specific AuthState with browser integration
class WebAuthState {
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
  final bool isOnline;
  final DateTime? lastActivity;
  final bool rememberMe;
  final String? browserSessionId;

  const WebAuthState({
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
    this.isOnline = true,
    this.lastActivity,
    this.rememberMe = false,
    this.browserSessionId,
  });

  WebAuthState copyWith({
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
    bool? isOnline,
    DateTime? lastActivity,
    bool? rememberMe,
    String? browserSessionId,
  }) {
    return WebAuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isRegistering: isRegistering ?? this.isRegistering,
      sessionExpired: sessionExpired ?? this.sessionExpired,
      sessionExpiredReason: sessionExpiredReason,
      unverifiedPhoneNumber:
          unverifiedPhoneNumber ?? this.unverifiedPhoneNumber,
      sessionState: sessionState ?? this.sessionState,
      isOnline: isOnline ?? this.isOnline,
      lastActivity: lastActivity ?? this.lastActivity,
      rememberMe: rememberMe ?? this.rememberMe,
      browserSessionId: browserSessionId ?? this.browserSessionId,
    );
  }
}

/// Web-optimized AuthNotifier with browser-specific features
class WebAuthNotifier extends StateNotifier<WebAuthState> {
  final AuthService _authService;
  final UnifiedTokenManager _tokenManager;
  final EnhancedSessionManager _sessionManager;
  final WebCompatibleStorage _webStorage;

  StreamSubscription? _sessionSubscription;
  StreamSubscription? _tokenSubscription;
  Timer? _activityTimer;
  Timer? _heartbeatTimer;

  WebAuthNotifier(
    this._authService,
    this._tokenManager,
    this._sessionManager,
    this._webStorage,
  ) : super(const WebAuthState()) {
    _initialize();
  }

  /// Initialize web auth provider
  Future<void> _initialize() async {
    debugPrint('🌐 [WEB_AUTH] Initializing Web AuthProvider');

    try {
      // Initialize token manager
      await _tokenManager.initialize();

      // Initialize session manager
      await _sessionManager.initialize();

      // Setup browser-specific listeners
      _setupBrowserListeners();

      // Listen to session events
      _listenToSessionEvents();

      // Listen to token events
      _listenToTokenEvents();

      // Check initial auth status
      await _checkInitialAuthStatus();

      // Start activity tracking
      _startActivityTracking();

      // Start heartbeat for session management
      _startHeartbeat();

      debugPrint('✅ [WEB_AUTH] Web AuthProvider initialized successfully');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Initialization failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize web authentication: $e',
      );
    }
  }

  /// Setup browser-specific event listeners
  void _setupBrowserListeners() {
    try {
      // Listen for page visibility changes
      web.document.addEventListener('visibilitychange', (web.Event event) {
        if (web.document.visibilityState == 'visible') {
          _handlePageVisible();
        } else {
          _handlePageHidden();
        }
      }.toJS);

      // Listen for beforeunload to save state
      web.window.addEventListener('beforeunload', (web.Event event) {
        _handlePageUnload();
      }.toJS);

      // Listen for storage events (cross-tab sync)
      web.window.addEventListener('storage', (web.Event event) {
        final storageEvent = event as web.StorageEvent;
        _handleStorageEvent(storageEvent);
      }.toJS);

      debugPrint('🌐 [WEB_AUTH] Browser listeners setup complete');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to setup browser listeners: $e');
    }
  }

  /// Handle page becoming visible
  void _handlePageVisible() {
    debugPrint('🌐 [WEB_AUTH] Page became visible');
    
    // Update online status
    state = state.copyWith(isOnline: true);
    
    // Check auth status
    _checkInitialAuthStatus();
    
    // Update activity
    _updateActivity();
  }

  /// Handle page becoming hidden
  void _handlePageHidden() {
    debugPrint('🌐 [WEB_AUTH] Page became hidden');
    
    // Save current state
    _saveCurrentState();
  }

  /// Handle page unload
  void _handlePageUnload() {
    debugPrint('🌐 [WEB_AUTH] Page unloading');
    
    // Save final state
    _saveCurrentState();
    
    // Clean up timers
    _activityTimer?.cancel();
    _heartbeatTimer?.cancel();
  }

  /// Handle cross-tab storage events
  void _handleStorageEvent(web.StorageEvent event) {
    if (event.key == AppConstants.userKey) {
      debugPrint('🌐 [WEB_AUTH] User data changed in another tab');
      _checkInitialAuthStatus();
    }
  }

  /// Listen to session events
  void _listenToSessionEvents() {
    _sessionSubscription = _sessionManager.sessionStateStream.listen(
      (sessionEvent) {
        debugPrint('🌐 [WEB_AUTH] Session event: ${sessionEvent.state}');
        
        state = state.copyWith(
          sessionState: sessionEvent.state,
          lastActivity: DateTime.now(),
        );

        // Handle session expiration
        if (sessionEvent.state == SessionState.expired) {
          _handleSessionExpired(sessionEvent.reason);
        }
      },
      onError: (error) {
        debugPrint('❌ [WEB_AUTH] Session event error: $error');
      },
    );
  }

  /// Listen to token events
  void _listenToTokenEvents() {
    _tokenSubscription = _tokenManager.sessionEvents.listen(
      (tokenEvent) {
        debugPrint('🌐 [WEB_AUTH] Token event: ${tokenEvent.type}');
        
        switch (tokenEvent.type) {
          case SessionEventType.tokenRefreshed:
            // Token refreshed successfully
            break;
          case SessionEventType.sessionExpired:
            _handleSessionExpired('Token expired');
            break;
          case SessionEventType.sessionCleared:
            _handleLogout();
            break;
          case SessionEventType.loggedOut:
            _handleLogout();
            break;
          case SessionEventType.sessionWarning:
            // Handle session warning
            break;
        }
      },
      onError: (error) {
        debugPrint('❌ [WEB_AUTH] Token event error: $error');
      },
    );
  }

  /// Check initial authentication status
  Future<void> _checkInitialAuthStatus() async {
    try {
      debugPrint('🌐 [WEB_AUTH] Checking initial auth status');
      
      state = state.copyWith(isLoading: true);

      // Check if we have valid tokens
      final hasValidTokens = await _tokenManager.hasValidSession();
      
      if (hasValidTokens) {
        // Try to get user data
        final userData = await _webStorage.read(AppConstants.userKey);
        
        if (userData != null) {
          try {
            final userJson = jsonDecode(userData);
            final user = UserModel.fromJson(userJson);
            
            state = state.copyWith(
              user: user,
              isAuthenticated: true,
              isLoading: false,
              sessionState: SessionState.active,
              lastActivity: DateTime.now(),
            );

            debugPrint('✅ [WEB_AUTH] User authenticated from offline cache');
            return;
          } catch (e) {
            debugPrint('❌ [WEB_AUTH] Failed to parse cached user data: $e');
          }
        }

        // Try to fetch user profile from server
        try {
          final userProfile = await _authService.getUserProfile();
          // Save user data
          await _webStorage.write(
            AppConstants.userKey,
            jsonEncode(userProfile.toJson()),
          );

          state = state.copyWith(
            user: userProfile,
            isAuthenticated: true,
            isLoading: false,
            sessionState: SessionState.active,
            lastActivity: DateTime.now(),
          );

          debugPrint('✅ [WEB_AUTH] User authenticated from server');
          return;
        } catch (e) {
          debugPrint('❌ [WEB_AUTH] Failed to fetch user profile: $e');
          // If we have valid tokens but can't fetch profile, 
          // we might be offline - keep authenticated state
          if (userData != null) {
            state = state.copyWith(
              isAuthenticated: true,
              isLoading: false,
              sessionState: SessionState.active,
              lastActivity: DateTime.now(),
            );

            debugPrint('✅ [WEB_AUTH] User authenticated from offline cache');
            return;
          }
        }
      }

      // No valid authentication found
      await _clearAuthData();
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        sessionState: SessionState.none,
      );

      debugPrint('ℹ️ [WEB_AUTH] No valid authentication found');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Auth status check failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check authentication status: $e',
      );
    }
  }

  /// Handle session expiration
  void _handleSessionExpired(String reason) {
    debugPrint('🌐 [WEB_AUTH] Session expired: $reason');
    
    state = state.copyWith(
      sessionExpired: true,
      sessionExpiredReason: reason,
      sessionState: SessionState.expired,
    );
  }

  /// Handle logout
  void _handleLogout() {
    debugPrint('🌐 [WEB_AUTH] Handling logout');
    
    state = state.copyWith(
      user: null,
      isAuthenticated: false,
      sessionExpired: false,
      sessionExpiredReason: null,
      sessionState: SessionState.none,
    );
  }

  /// Start activity tracking
  void _startActivityTracking() {
    _activityTimer?.cancel();
    
    _activityTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (state.isAuthenticated) {
        _updateActivity();
      }
    });
  }

  /// Start heartbeat for session management
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      if (state.isAuthenticated) {
        try {
          // Check if we still have valid tokens instead of sending heartbeat
          final hasValidTokens = await _tokenManager.hasValidSession();
          if (!hasValidTokens) {
            _handleSessionExpired('Session expired - invalid tokens');
          } else {
            // Update activity
            _updateActivity();
            debugPrint('🌐 [WEB_AUTH] Session validation successful');
          }
          
          debugPrint('🌐 [WEB_AUTH] Heartbeat sent successfully');
        } catch (e) {
          debugPrint('❌ [WEB_AUTH] Heartbeat failed: $e');
          
          // If heartbeat fails, check if we're still authenticated
          final hasValidTokens = await _tokenManager.hasValidSession();
          if (!hasValidTokens) {
            _handleSessionExpired('Heartbeat failed - invalid tokens');
          }
        }
      }
    });
  }

  /// Update user activity
  void _updateActivity() {
    state = state.copyWith(lastActivity: DateTime.now());
  }

  /// Save current state to storage
  Future<void> _saveCurrentState() async {
    try {
      if (state.user != null) {
        await _webStorage.write(
          AppConstants.userKey,
          jsonEncode(state.user!.toJson()),
        );
      }
      
      if (state.rememberMe) {
        await _webStorage.write('rememberMe', 'true');
      }
      
      debugPrint('🌐 [WEB_AUTH] Current state saved');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to save current state: $e');
    }
  }

  /// Login with phone and password
  Future<bool> loginWithPhone(String phone, String password, {bool rememberMe = false}) async {
    try {
      debugPrint('🌐 [WEB_AUTH] Attempting login with phone: $phone');
      
      state = state.copyWith(isLoading: true, error: null);

      // Generate browser session ID
      final browserSessionId = _generateBrowserSessionId();
      
      // Create login request
      final loginRequest = LoginRequest(
        phone: phone,
        password: password,
      );
      
      // Attempt login using the correct method
      final result = await _authService.login(loginRequest);

      if (result.success && result.user != null) {
        // Save user data
        await _webStorage.write(
          AppConstants.userKey,
          jsonEncode(result.user!.toJson()),
        );

        // Save remember me preference
        if (rememberMe) {
          await _webStorage.write('rememberMe', 'true');
        }

        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          sessionState: SessionState.active,
          rememberMe: rememberMe,
          browserSessionId: browserSessionId,
          lastActivity: DateTime.now(),
        );

        debugPrint('✅ [WEB_AUTH] Login successful');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'Login failed',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Login failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: $e',
      );
      return false;
    }
  }

  /// Register with phone
  Future<bool> registerWithPhone({
    required String phone,
    required String password,
    required String name,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      debugPrint('🌐 [WEB_AUTH] Attempting registration with phone: $phone');
      
      state = state.copyWith(isRegistering: true, error: null);

      // Create register request
      final registerRequest = RegisterRequest(
        phone: phone,
        password: password,
        confirmPassword: password, // Use same password for confirmation
        name: name,
        email: additionalData?['email'] as String?,
      );

      final result = await _authService.register(registerRequest);

      if (result.success) {
        state = state.copyWith(
          isRegistering: false,
          unverifiedPhoneNumber: phone,
        );

        debugPrint('✅ [WEB_AUTH] Registration successful');
        return true;
      } else {
        state = state.copyWith(
          isRegistering: false,
          error: result.message ?? 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Registration failed: $e');
      state = state.copyWith(
        isRegistering: false,
        error: 'Registration failed: $e',
      );
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      debugPrint('🌐 [WEB_AUTH] Verifying OTP for phone: $phone');
      
      state = state.copyWith(isLoading: true, error: null);

      final result = await _authService.verifyOtp(phone, otp);

      if (result.success && result.user != null) {
        // Save user data
        await _webStorage.write(
          AppConstants.userKey,
          jsonEncode(result.user!.toJson()),
        );

        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          sessionState: SessionState.active,
          unverifiedPhoneNumber: null,
          lastActivity: DateTime.now(),
        );

        debugPrint('✅ [WEB_AUTH] OTP verification successful');
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.message ?? 'OTP verification failed',
        );
        return false;
      }
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] OTP verification failed: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'OTP verification failed: $e',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout({bool clearRememberMe = true}) async {
    try {
      debugPrint('🌐 [WEB_AUTH] Logging out');
      
      state = state.copyWith(isLoading: true);

      // Logout from server
      await _authService.logout();

      // Clear all data
      await _clearAuthData(clearRememberMe: clearRememberMe);

      state = const WebAuthState();

      debugPrint('✅ [WEB_AUTH] Logout successful');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Logout failed: $e');
      
      // Even if server logout fails, clear local data
      await _clearAuthData(clearRememberMe: clearRememberMe);
      state = const WebAuthState();
    }
  }

  /// Clear all authentication data
  Future<void> _clearAuthData({bool clearRememberMe = true}) async {
    try {
      debugPrint('🌐 [WEB_AUTH] Clearing authentication data');

      // Clear user data
      await _webStorage.delete(AppConstants.userKey);

      // Clear tokens
      await _tokenManager.clearTokens();

      // Clear user profile data
      await _clearUserProfileData();

      // Clear session data
      await _sessionManager.endSession();

      // Clear remember me if requested
      if (clearRememberMe) {
        await _webStorage.delete('rememberMe');
      }

      debugPrint('✅ [WEB_AUTH] Authentication data cleared');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to clear auth data: $e');
    }
  }

  /// Clear user profile data
  Future<void> _clearUserProfileData() async {
    try {
      // Clear any cached profile data
      final keys = ['userProfile', 'userPreferences', 'userSettings'];
      for (final key in keys) {
        await _webStorage.delete(key);
      }
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to clear user profile data: $e');
    }
  }

  /// Generate browser session ID
  String _generateBrowserSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'web_session_$random';
  }

  /// Clear session expiration
  void clearSessionExpiration() {
    state = state.copyWith(
      sessionExpired: false,
      sessionExpiredReason: null,
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    _tokenSubscription?.cancel();
    _activityTimer?.cancel();
    _heartbeatTimer?.cancel();
    super.dispose();
  }
}

// Provider definitions
final unifiedTokenManagerProvider = Provider<UnifiedTokenManager>((ref) {
  return UnifiedTokenManager.instance;
});

final enhancedSessionManagerProvider = Provider<EnhancedSessionManager>((ref) {
  return EnhancedSessionManager.instance;
});

// Web-specific provider
final webAuthProvider =
    StateNotifierProvider<WebAuthNotifier, WebAuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final tokenManager = ref.watch(unifiedTokenManagerProvider);
  final sessionManager = ref.watch(enhancedSessionManagerProvider);
  final webStorage = WebCompatibleStorage.instance;

  return WebAuthNotifier(
    authService,
    tokenManager,
    sessionManager,
    webStorage,
  );
});

// Web convenience providers
final isWebAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(webAuthProvider).isAuthenticated;
});

final currentWebUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(webAuthProvider).user;
});

final webAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(webAuthProvider).isLoading;
});

final webAuthErrorProvider = Provider<String?>((ref) {
  return ref.watch(webAuthProvider).error;
});

final webSessionStateProvider = Provider<SessionState>((ref) {
  return ref.watch(webAuthProvider).sessionState;
});

final isWebOnlineProvider = Provider<bool>((ref) {
  return ref.watch(webAuthProvider).isOnline;
});

final rememberMeProvider = Provider<bool>((ref) {
  return ref.watch(webAuthProvider).rememberMe;
});
