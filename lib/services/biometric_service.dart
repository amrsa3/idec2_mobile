import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform_storage_service.dart';

/// Service for handling biometric authentication
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  static BiometricService get instance => _instance;
  
  BiometricService._internal();
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricCredentialsKey = 'biometric_credentials';
  
  /// Check if device supports biometrics
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException catch (e) {
      print('❌ Error checking device support: $e');
      return false;
    }
  }
  
  /// Check if biometrics are available and enrolled
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('❌ Error checking biometrics: $e');
      return false;
    }
  }
  
  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('❌ Error getting available biometrics: $e');
      return [];
    }
  }
  
  /// Authenticate using biometrics
  Future<bool> authenticate({
    String localizedReason = 'الرجاء التحقق من هويتك للدخول',
    bool biometricOnly = true,
  }) async {
    try {
      final canAuth = await canCheckBiometrics();
      final isSupported = await isDeviceSupported();
      
      if (!canAuth || !isSupported) {
        print('⚠️ Biometrics not available');
        return false;
      }
      
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      print('❌ Error authenticating: $e');
      return false;
    }
  }
  
  /// Check if biometric login is enabled
  Future<bool> isBiometricLoginEnabled() async {
    try {
      final storage = PlatformStorageService.instance;
      final enabled = await storage.getBool(_biometricEnabledKey);
      return enabled ?? false;
    } catch (e) {
      print('❌ Error checking biometric enabled: $e');
      return false;
    }
  }
  
  /// Enable or disable biometric login
  Future<void> setBiometricLoginEnabled(bool enabled) async {
    try {
      final storage = PlatformStorageService.instance;
      await storage.setBool(_biometricEnabledKey, enabled);
      print('✅ Biometric login ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      print('❌ Error setting biometric enabled: $e');
    }
  }
  
  /// Save credentials for biometric login (encrypted)
  Future<void> saveCredentials(String phone, String password) async {
    try {
      final storage = PlatformStorageService.instance;
      // Store credentials in secure storage
      final credentials = '$phone|$password';
      await storage.writeSecure(_biometricCredentialsKey, credentials);
      print('✅ Credentials saved for biometric login');
    } catch (e) {
      print('❌ Error saving credentials: $e');
    }
  }
  
  /// Get saved credentials for biometric login
  Future<Map<String, String>?> getSavedCredentials() async {
    try {
      final storage = PlatformStorageService.instance;
      final credentials = await storage.readSecure(_biometricCredentialsKey);
      
      if (credentials != null && credentials.contains('|')) {
        final parts = credentials.split('|');
        if (parts.length >= 2) {
          return {
            'phone': parts[0],
            'password': parts.sublist(1).join('|'), // Handle passwords with |
          };
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting credentials: $e');
      return null;
    }
  }
  
  /// Clear saved credentials
  Future<void> clearCredentials() async {
    try {
      final storage = PlatformStorageService.instance;
      await storage.deleteSecure(_biometricCredentialsKey);
      await storage.setBool(_biometricEnabledKey, false);
      print('✅ Credentials cleared');
    } catch (e) {
      print('❌ Error clearing credentials: $e');
    }
  }
  
  /// Get biometric type name for display
  String getBiometricTypeName(List<BiometricType> types, {bool isArabic = true}) {
    if (types.contains(BiometricType.face)) {
      return isArabic ? 'التعرف على الوجه' : 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return isArabic ? 'بصمة الإصبع' : 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return isArabic ? 'مسح القزحية' : 'Iris scan';
    }
    return isArabic ? 'التحقق البيومتري' : 'Biometric';
  }
  
  /// Get biometric icon
  IconData getBiometricIcon(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return Icons.face;
    } else if (types.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    }
    return Icons.fingerprint;
  }
}

// Biometric state for provider
class BiometricState {
  final bool isAvailable;
  final bool isEnabled;
  final List<BiometricType> availableTypes;
  final bool isLoading;
  final String? error;
  
  const BiometricState({
    this.isAvailable = false,
    this.isEnabled = false,
    this.availableTypes = const [],
    this.isLoading = true,
    this.error,
  });
  
  BiometricState copyWith({
    bool? isAvailable,
    bool? isEnabled,
    List<BiometricType>? availableTypes,
    bool? isLoading,
    String? error,
  }) {
    return BiometricState(
      isAvailable: isAvailable ?? this.isAvailable,
      isEnabled: isEnabled ?? this.isEnabled,
      availableTypes: availableTypes ?? this.availableTypes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Biometric notifier
class BiometricNotifier extends StateNotifier<BiometricState> {
  BiometricNotifier() : super(const BiometricState()) {
    _initialize();
  }
  
  final BiometricService _biometricService = BiometricService.instance;
  
  Future<void> _initialize() async {
    try {
      final isSupported = await _biometricService.isDeviceSupported();
      final canAuth = await _biometricService.canCheckBiometrics();
      final types = await _biometricService.getAvailableBiometrics();
      final isEnabled = await _biometricService.isBiometricLoginEnabled();
      
      state = state.copyWith(
        isAvailable: isSupported && canAuth,
        isEnabled: isEnabled,
        availableTypes: types,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> setEnabled(bool enabled, {String? phone, String? password}) async {
    if (enabled && (phone == null || password == null)) {
      // Need credentials to enable
      state = state.copyWith(error: 'Credentials required to enable biometric login');
      return;
    }
    
    try {
      if (enabled) {
        // First authenticate to verify setup
        final authenticated = await _biometricService.authenticate(
          localizedReason: 'الرجاء التحقق لتفعيل تسجيل الدخول بالبصمة',
        );
        
        if (!authenticated) {
          state = state.copyWith(error: 'Authentication failed');
          return;
        }
        
        // Save credentials
        await _biometricService.saveCredentials(phone!, password!);
      } else {
        await _biometricService.clearCredentials();
      }
      
      await _biometricService.setBiometricLoginEnabled(enabled);
      state = state.copyWith(isEnabled: enabled, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  Future<bool> authenticateAndGetCredentials() async {
    try {
      final authenticated = await _biometricService.authenticate(
        localizedReason: 'الرجاء التحقق من هويتك للدخول',
      );
      return authenticated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
  
  Future<Map<String, String>?> getCredentials() async {
    return await _biometricService.getSavedCredentials();
  }
  
  void refresh() {
    _initialize();
  }
}

// Provider
final biometricProvider = StateNotifierProvider<BiometricNotifier, BiometricState>((ref) {
  return BiometricNotifier();
});

// Helper provider to check if biometric login is available AND enabled
final canUseBiometricLoginProvider = Provider<bool>((ref) {
  final state = ref.watch(biometricProvider);
  return state.isAvailable && state.isEnabled && !state.isLoading;
});
