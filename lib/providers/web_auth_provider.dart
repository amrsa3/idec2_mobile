import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/enhanced_session_manager.dart';
import '../services/platform_storage_service.dart';
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
    this.sessionState = SessionState.inactive,
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
      unverifiedPhoneNumber: unverifiedPhoneNumber ?? this.unverifiedPhoneNumber,
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
  StreamSubscription? _visibilitySubscription;
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
    if (kIsWeb) {
      // Listen to page visibility changes
      html.document.addEventListener('visibilitychange', _handleVisibilityChange);
      
      // Listen to beforeunload for cleanup
      html.window.addEventListener('beforeunload', _handleBeforeUnload);
      
      // Listen to online/offline events
      html.window.addEventListener('online', _handleOnlineStatusChange);
      html.window.addEventListener('offline', _handleOnlineStatusChange);
      
      // Listen to storage events for cross-tab synchronization
      html.window.addEventListener('storage', _handleStorageChange);
      
      // Generate browser session ID
      final sessionId = _generateBrowserSessionId();
      state = state.copyWith(browserSessionId: sessionId);
      
      debugPrint('🌐 [WEB_AUTH] Browser listeners setup complete');
    }
  }

  /// Handle page visibility changes
  void _handleVisibilityChange(html.Event event) {
    final isVisible = !html.document.hidden!;
    
    if (isVisible && state.isAuthenticated) {
      // Page became visible, update activity
      _updateActivity();
      
      // Check if tokens need refresh
      _checkTokensOnVisibilityChange();
    }
    
    debugPrint('🌐 [WEB_AUTH] Page visibility changed: $isVisible');
  }

  /// Handle before unload for cleanup
  void _handleBeforeUnload(html.Event event) {
    if (state.isAuthenticated && !state.rememberMe) {
      // Clear session data if not remembering user
      _clearSessionOnUnload();
    }
  }

  /// Handle online/offline status changes
  void _handleOnlineStatusChange(html.Event event) {
    final isOnline = html.window.navigator.onLine!;
    
    state = state.copyWith(isOnline: isOnline);
    
    if (isOnline && state.isAuthenticated) {
      // Back online, verify tokens
      _checkTokensOnVisibilityChange();
    }
    
    debugPrint('🌐 [WEB_AUTH] Online status changed: $isOnline');
  }

  /// Handle storage changes for cross-tab synchronization
  void _handleStorageChange(html.Event event) {
    final storageEvent = event as html.StorageEvent;
    
    if (storageEvent.key == 'accessToken' || storageEvent.key == 'refreshToken') {
      // Tokens changed in another tab
      _handleCrossTabTokenChange(storageEvent);
    } else if (storageEvent.key == AppConstants.userKey) {
      // User data changed in another tab
      _handleCrossTabUserChange(storageEvent);
    }
  }

  /// Handle cross-tab token changes
  void _handleCrossTabTokenChange(html.StorageEvent event) {
    if (event.newValue == null) {
      // Tokens were cleared in another tab, logout
      debugPrint('🌐 [WEB_AUTH] Tokens cleared in another tab, logging out');
      _handleCrossTabLogout();
    } else {
      // Tokens were updated in another tab
      debugPrint('🌐 [WEB_AUTH] Tokens updated in another tab');
      _checkInitialAuthStatus();
    }
  }

  /// Handle cross-tab user data changes
  void _handleCrossTabUserChange(html.StorageEvent event) {
    if (event.newValue == null) {
      // User data cleared in another tab
      debugPrint('🌐 [WEB_AUTH] User data cleared in another tab');
      _handleCrossTabLogout();
    }
  }

  /// Handle cross-tab logout
  void _handleCrossTabLogout() {
    state = const WebAuthState();
    debugPrint('🌐 [WEB_AUTH] Cross-tab logout completed');
  }

  /// Check tokens when page becomes visible
  Future<void> _checkTokensOnVisibilityChange() async {
    try {
      final hasValidTokens = await _tokenManager.hasValidToken();
      
      if (!hasValidTokens) {
        // Tokens expired while page was hidden
        _handleSessionExpired('Tokens expired while page was inactive');
      } else {
        // Ensure tokens are still valid with server
        await _tokenManager.ensureValidTokens();
      }
    } catch (e) {
      debugPrint('⚠️ [WEB_AUTH] Token check on visibility change failed: $e');
    }
  }

  /// Generate unique browser session ID
  String _generateBrowserSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'web_session_$random';
  }

  /// Check initial authentication status
  Future<void> _checkInitialAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Check if we have valid tokens
      final hasValidTokens = await _tokenManager.hasValidToken();
      
      if (hasValidTokens) {
        // Try to load user data from storage
        final userData = await _loadUserDataFromStorage();
        
        if (userData != null) {
          // Verify tokens with server if online
          if (state.isOnline) {
            try {
              final isValid = await _tokenManager.ensureValidTokens();
              
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
                
                debugPrint('✅ [WEB_AUTH] User authenticated from storage');
                return;
              }
            } catch (e) {
              debugPrint('⚠️ [WEB_AUTH] Token verification failed: $e');
            }
          } else {
            // Offline mode, use cached data
            state = state.copyWith(
              user: userData,
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
        sessionState: SessionState.inactive,
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

  /// Listen to session events
  void _listenToSessionEvents() {
    _sessionSubscription = _sessionManager.sessionStateStream.listen((event) {
      debugPrint('🌐 [WEB_AUTH] Session event: ${event.type}');
      
      switch (event.type) {
        case SessionEventType.expired:
          _handleSessionExpired(event.reason ?? 'Session expired');
          break;
        case SessionEventType.refreshed:
          state = state.copyWith(
            sessionExpired: false,
            sessionExpiredReason: null,
            sessionState: SessionState.active,
            lastActivity: DateTime.now(),
          );
          break;
        case SessionEventType.offline:
          state = state.copyWith(isOnline: false);
          break;
        case SessionEventType.online:
          state = state.copyWith(isOnline: true);
          _checkInitialAuthStatus();
          break;
      }
    });
  }

  /// Listen to token events
  void _listenToTokenEvents() {
    _tokenSubscription = _tokenManager.sessionEventStream.listen((event) {
      debugPrint('🌐 [WEB_AUTH] Token event: ${event.type}');
      
      switch (event.type) {
        case SessionEventType.expired:
          _handleSessionExpired('Token expired');
          break;
        case SessionEventType.refreshed:
          state = state.copyWith(
            sessionExpired: false,
            sessionExpiredReason: null,
            lastActivity: DateTime.now(),
          );
          break;
      }
    });
  }

  /// Start activity tracking
  void _startActivityTracking() {
    _activityTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (state.isAuthenticated && !html.document.hidden!) {
        _updateActivity();
      }
    });
  }

  /// Start heartbeat for session management
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (state.isAuthenticated && state.isOnline) {
        _sendHeartbeat();
      }
    });
  }

  /// Send heartbeat to server
  Future<void> _sendHeartbeat() async {
    try {
      // This could be a simple ping to keep session alive
      await _tokenManager.ensureValidTokens();
      debugPrint('🌐 [WEB_AUTH] Heartbeat sent successfully');
    } catch (e) {
      debugPrint('⚠️ [WEB_AUTH] Heartbeat failed: $e');
    }
  }

  /// Update activity
  void _updateActivity() {
    if (state.isAuthenticated) {
      _sessionManager.updateActivity();
      state = state.copyWith(lastActivity: DateTime.now());
    }
  }

  /// Handle session expiration
  void _handleSessionExpired(String reason) {
    debugPrint('🌐 [WEB_AUTH] Session expired: $reason');
    
    state = state.copyWith(
      sessionExpired: true,
      sessionExpiredReason: reason,
      isAuthenticated: false,
      sessionState: SessionState.expired,
      error: reason,
    );
    
    _clearAuthData();
  }

  /// Login with phone number and remember me option
  Future<bool> loginWithPhone(String phoneNumber, String password, {bool rememberMe = false}) async {
    state = state.copyWith(isLoading: true, error: null, rememberMe: rememberMe);
    
    try {
      debugPrint('🌐 [WEB_AUTH] Attempting login for: $phoneNumber (remember: $rememberMe)');
      
      final result = await _authService.loginWithPhone(phoneNumber, password);
      
      if (result.success && result.user != null) {
        // Save tokens with appropriate persistence
        if (result.accessToken != null && result.refreshToken != null) {
          await _tokenManager.setTokens(
            result.accessToken!,
            result.refreshToken!,
          );
          
          // Store remember me preference
          if (rememberMe) {
            await _webStorage.write('rememberMe', 'true');
          }
        }
        
        // Save user data
        await _saveUserData(result.user!);
        
        // Start session
        await _sessionManager.startSession(result.user!.id);
        
        state = state.copyWith(
          user: result.user,
          isAuthenticated: true,
          isLoading: false,
          phoneVerified: result.user!.phoneVerified,
          sessionState: SessionState.active,
          lastActivity: DateTime.now(),
          rememberMe: rememberMe,
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

  /// Logout with option to clear remember me
  Future<void> logout({bool clearRememberMe = true}) async {
    state = state.copyWith(isLoading: true);
    
    try {
      debugPrint('🌐 [WEB_AUTH] Logging out user');
      
      // Logout from server
      try {
        await _authService.logout();
      } catch (e) {
        debugPrint('⚠️ [WEB_AUTH] Server logout failed: $e');
      }
      
      // End session
      await _sessionManager.endSession();
      
      // Clear authentication data
      await _clearAuthData(clearRememberMe: clearRememberMe);
      
      // Reset state
      state = const WebAuthState();
      
      debugPrint('✅ [WEB_AUTH] Logout successful');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Logout failed: $e');
      // Force logout
      await _clearAuthData(clearRememberMe: clearRememberMe);
      state = const WebAuthState();
    }
  }

  /// Clear session data on page unload
  void _clearSessionOnUnload() {
    if (kIsWeb) {
      // Clear session storage but keep local storage for remember me
      html.window.sessionStorage.clear();
    }
  }

  /// Save user data to storage
  Future<void> _saveUserData(UserModel user) async {
    try {
      debugPrint('🌐 [WEB_AUTH] Saving user data for: ${user.id}');
      
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
      await _webStorage.write(AppConstants.userKey, jsonString);
      
      debugPrint('✅ [WEB_AUTH] User data saved successfully');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to save user data: $e');
      rethrow;
    }
  }

  /// Load user data from storage
  Future<UserModel?> _loadUserDataFromStorage() async {
    try {
      debugPrint('🌐 [WEB_AUTH] Loading user data from storage');
      
      final jsonString = await _webStorage.read(AppConstants.userKey);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final userJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final user = UserModel.fromJson(userJson);
        
        debugPrint('✅ [WEB_AUTH] User data loaded from storage: ${user.id}');
        return user;
      }
      
      debugPrint('ℹ️ [WEB_AUTH] No user data found in storage');
      return null;
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to load user data: $e');
      return null;
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
      
      // Clear remember me if requested
      if (clearRememberMe) {
        await _webStorage.delete('rememberMe');
      }
      
      debugPrint('✅ [WEB_AUTH] Authentication data cleared');
    } catch (e) {
      debugPrint('❌ [WEB_AUTH] Failed to clear auth data: $e');
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    _tokenSubscription?.cancel();
    _activityTimer?.cancel();
    _heartbeatTimer?.cancel();
    
    if (kIsWeb) {
      html.document.removeEventListener('visibilitychange', _handleVisibilityChange);
      html.window.removeEventListener('beforeunload', _handleBeforeUnload);
      html.window.removeEventListener('online', _handleOnlineStatusChange);
      html.window.removeEventListener('offline', _handleOnlineStatusChange);
      html.window.removeEventListener('storage', _handleStorageChange);
    }
    
    super.dispose();
  }
}

// Web-specific provider
final webAuthProvider = StateNotifierProvider<WebAuthNotifier, WebAuthState>((ref) {
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
