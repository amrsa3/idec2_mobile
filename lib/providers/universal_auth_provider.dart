import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/enhanced_session_manager.dart';
import 'enhanced_auth_provider.dart';
import 'web_auth_provider.dart';

/// Universal AuthState that works across all platforms
class UniversalAuthState {
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
  final String? platformInfo;

  const UniversalAuthState({
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
    this.platformInfo,
  });

  UniversalAuthState copyWith({
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
    String? platformInfo,
  }) {
    return UniversalAuthState(
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
      platformInfo: platformInfo ?? this.platformInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UniversalAuthState &&
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
        other.isOnline == isOnline &&
        other.lastActivity == lastActivity &&
        other.rememberMe == rememberMe &&
        other.platformInfo == platformInfo;
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
      isOnline,
      lastActivity,
      rememberMe,
      platformInfo,
    );
  }
}

/// Universal AuthNotifier that delegates to platform-specific implementations
class UniversalAuthNotifier extends StateNotifier<UniversalAuthState> {
  final Ref _ref;
  StreamSubscription? _platformSubscription;

  UniversalAuthNotifier(this._ref) : super(const UniversalAuthState()) {
    _initialize();
  }

  /// Initialize universal auth provider
  void _initialize() {
    debugPrint('🌍 [UNIVERSAL_AUTH] Initializing Universal AuthProvider');
    
    final platformInfo = _getPlatformInfo();
    state = state.copyWith(platformInfo: platformInfo);
    
    if (kIsWeb) {
      _initializeWebAuth();
    } else {
      _initializeEnhancedAuth();
    }
    
    debugPrint('✅ [UNIVERSAL_AUTH] Universal AuthProvider initialized for: $platformInfo');
  }

  /// Get platform information
  String _getPlatformInfo() {
    if (kIsWeb) {
      return 'Flutter Web';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS';
    } else {
      return 'Unknown Platform';
    }
  }

  /// Initialize web authentication
  void _initializeWebAuth() {
    debugPrint('🌐 [UNIVERSAL_AUTH] Initializing Web Auth');
    
    _platformSubscription = _ref.listen<WebAuthState>(
      webAuthProvider,
      (previous, next) {
        _syncWebAuthState(next);
      },
    );
    
    // Get initial state
    final webState = _ref.read(webAuthProvider);
    _syncWebAuthState(webState);
  }

  /// Initialize enhanced authentication for mobile
  void _initializeEnhancedAuth() {
    debugPrint('📱 [UNIVERSAL_AUTH] Initializing Enhanced Auth');
    
    _platformSubscription = _ref.listen<EnhancedAuthState>(
      authProvider,
      (previous, next) {
        _syncEnhancedAuthState(next);
      },
    );
    
    // Get initial state
    final enhancedState = _ref.read(authProvider);
    _syncEnhancedAuthState(enhancedState);
  }

  /// Sync web auth state to universal state
  void _syncWebAuthState(WebAuthState webState) {
    state = UniversalAuthState(
      user: webState.user,
      isAuthenticated: webState.isAuthenticated,
      isLoading: webState.isLoading,
      error: webState.error,
      phoneVerified: webState.phoneVerified,
      isRegistering: webState.isRegistering,
      sessionExpired: webState.sessionExpired,
      sessionExpiredReason: webState.sessionExpiredReason,
      unverifiedPhoneNumber: webState.unverifiedPhoneNumber,
      sessionState: webState.sessionState,
      isOnline: webState.isOnline,
      lastActivity: webState.lastActivity,
      rememberMe: webState.rememberMe,
      platformInfo: state.platformInfo,
    );
  }

  /// Sync enhanced auth state to universal state
  void _syncEnhancedAuthState(EnhancedAuthState enhancedState) {
    state = UniversalAuthState(
      user: enhancedState.user,
      isAuthenticated: enhancedState.isAuthenticated,
      isLoading: enhancedState.isLoading,
      error: enhancedState.error,
      phoneVerified: enhancedState.phoneVerified,
      isRegistering: enhancedState.isRegistering,
      sessionExpired: enhancedState.sessionExpired,
      sessionExpiredReason: enhancedState.sessionExpiredReason,
      unverifiedPhoneNumber: enhancedState.unverifiedPhoneNumber,
      sessionState: enhancedState.sessionState,
      isOnline: !enhancedState.isOffline,
      lastActivity: enhancedState.lastActivity,
      rememberMe: false, // Enhanced auth doesn't have remember me
      platformInfo: state.platformInfo,
    );
  }

  /// Login with phone number
  Future<bool> loginWithPhone(String phoneNumber, String password, {bool rememberMe = false}) async {
    debugPrint('🌍 [UNIVERSAL_AUTH] Login attempt for: $phoneNumber');
    
    if (kIsWeb) {
      final webNotifier = _ref.read(webAuthProvider.notifier);
      return await webNotifier.loginWithPhone(phoneNumber, password, rememberMe: rememberMe);
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      return await enhancedNotifier.loginWithPhone(phoneNumber, password);
    }
  }

  /// Register with phone number
  Future<bool> registerWithPhone(String phoneNumber, String password, String name) async {
    debugPrint('🌍 [UNIVERSAL_AUTH] Registration attempt for: $phoneNumber');
    
    if (kIsWeb) {
      // Web registration would need to be implemented in WebAuthNotifier
      throw UnimplementedError('Web registration not implemented yet');
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      return await enhancedNotifier.registerWithPhone(phoneNumber, password, name);
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    debugPrint('🌍 [UNIVERSAL_AUTH] OTP verification for: $phoneNumber');
    
    if (kIsWeb) {
      // Web OTP verification would need to be implemented in WebAuthNotifier
      throw UnimplementedError('Web OTP verification not implemented yet');
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      return await enhancedNotifier.verifyOtp(phoneNumber, otp);
    }
  }

  /// Logout
  Future<void> logout({bool clearRememberMe = true}) async {
    debugPrint('🌍 [UNIVERSAL_AUTH] Logout initiated');
    
    if (kIsWeb) {
      final webNotifier = _ref.read(webAuthProvider.notifier);
      await webNotifier.logout(clearRememberMe: clearRememberMe);
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      await enhancedNotifier.logout();
    }
  }

  /// Refresh tokens
  Future<bool> refreshTokens() async {
    debugPrint('🌍 [UNIVERSAL_AUTH] Token refresh initiated');
    
    if (kIsWeb) {
      // Web token refresh would be handled by WebAuthNotifier
      return true; // Placeholder
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      return await enhancedNotifier.refreshTokens();
    }
  }

  /// Clear session expiration state
  void clearSessionExpiration() {
    debugPrint('🌍 [UNIVERSAL_AUTH] Clearing session expiration state');
    
    if (kIsWeb) {
      // Web session expiration clearing would be handled by WebAuthNotifier
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      enhancedNotifier.clearSessionExpiration();
    }
  }

  /// Clear error
  void clearError() {
    debugPrint('🌍 [UNIVERSAL_AUTH] Clearing error');
    
    if (kIsWeb) {
      // Web error clearing would be handled by WebAuthNotifier
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      enhancedNotifier.clearError();
    }
  }

  /// Update user activity
  void updateActivity() {
    if (kIsWeb) {
      // Web activity update would be handled by WebAuthNotifier
    } else {
      final enhancedNotifier = _ref.read(authProvider.notifier);
      enhancedNotifier.updateActivity();
    }
  }

  /// Check if current platform supports remember me
  bool get supportsRememberMe => kIsWeb;

  /// Check if current platform supports offline mode
  bool get supportsOfflineMode => !kIsWeb;

  /// Get platform-specific features
  Map<String, bool> get platformFeatures => {
    'rememberMe': supportsRememberMe,
    'offlineMode': supportsOfflineMode,
    'crossTabSync': kIsWeb,
    'biometricAuth': !kIsWeb,
    'backgroundSync': !kIsWeb,
    'pushNotifications': !kIsWeb,
  };

  @override
  void dispose() {
    _platformSubscription?.cancel();
    super.dispose();
  }
}

// Universal provider
final universalAuthProvider = StateNotifierProvider<UniversalAuthNotifier, UniversalAuthState>((ref) {
  return UniversalAuthNotifier(ref);
});

// Universal convenience providers
final isUniversalAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(universalAuthProvider).isAuthenticated;
});

final currentUniversalUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(universalAuthProvider).user;
});

final universalAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(universalAuthProvider).isLoading;
});

final universalAuthErrorProvider = Provider<String?>((ref) {
  return ref.watch(universalAuthProvider).error;
});

final universalSessionStateProvider = Provider<SessionState>((ref) {
  return ref.watch(universalAuthProvider).sessionState;
});

final isUniversalOnlineProvider = Provider<bool>((ref) {
  return ref.watch(universalAuthProvider).isOnline;
});

final universalRememberMeProvider = Provider<bool>((ref) {
  return ref.watch(universalAuthProvider).rememberMe;
});

final platformInfoProvider = Provider<String>((ref) {
  return ref.watch(universalAuthProvider).platformInfo ?? 'Unknown';
});

final platformFeaturesProvider = Provider<Map<String, bool>>((ref) {
  final notifier = ref.read(universalAuthProvider.notifier);
  return notifier.platformFeatures;
});

// Legacy compatibility providers (for backward compatibility)
final legacyAuthProvider = universalAuthProvider;
final isAuthenticatedProvider = isUniversalAuthenticatedProvider;
final currentUserProvider = currentUniversalUserProvider;
final authLoadingProvider = universalAuthLoadingProvider;
final authErrorProvider = universalAuthErrorProvider;
