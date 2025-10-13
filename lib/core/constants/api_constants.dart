import '../services/server_settings_service.dart';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Default URLs with port explicitly included - using IP to avoid DNS issues
  static const String defaultBaseUrl = 'http://84.247.128.128:3000';
  static const String devUrl = 'http://84.247.128.128:3000';
  static const String prodUrl = 'http://84.247.128.128:3000';
  
  // Fallback domain URL (in case IP doesn't work)
  static const String domainUrl = 'http://idec-ye.com:3000';
  
  // Current base URL - will be updated dynamically
  static String _baseUrl = defaultBaseUrl;
  
  /// Get current base URL with validation
  static String get baseUrl {
    // Validate current URL
    if (_baseUrl.isEmpty || !_baseUrl.contains(':')) {
      debugPrint('⚠️ [API_CONSTANTS] Invalid baseUrl detected: $_baseUrl, using fallback');
      _baseUrl = _getFallbackUrl();
    }
    
    // Ensure port is included
    if (!_baseUrl.contains(':3000')) {
      debugPrint('⚠️ [API_CONSTANTS] Port missing in baseUrl: $_baseUrl, fixing...');
      _baseUrl = _fixUrlWithPort(_baseUrl);
    }
    
    debugPrint('🔗 [API_CONSTANTS] Current baseUrl: $_baseUrl');
    return _baseUrl;
  }
  
  /// Update base URL with validation
  static void updateBaseUrl(String newUrl) {
    debugPrint('🔄 [API_CONSTANTS] Updating baseUrl from: $_baseUrl to: $newUrl');
    
    if (newUrl.isEmpty) {
      debugPrint('❌ [API_CONSTANTS] Empty URL provided, using fallback');
      _baseUrl = _getFallbackUrl();
      return;
    }
    
    // Validate and fix the URL
    final validatedUrl = _validateAndFixUrl(newUrl);
    _baseUrl = validatedUrl;
    
    debugPrint('✅ [API_CONSTANTS] BaseUrl updated to: $_baseUrl');
  }
  
  /// Validate and fix URL format
  static String _validateAndFixUrl(String url) {
    try {
      // Remove any trailing slashes
      String cleanUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
      
      // Ensure http:// prefix
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        cleanUrl = 'http://$cleanUrl';
      }
      
      // Parse URL to validate
      final uri = Uri.parse(cleanUrl);
      final host = uri.host;
      
      if (host.isEmpty) {
        debugPrint('❌ [API_CONSTANTS] Invalid host in URL: $url');
        return _getFallbackUrl();
      }
      
      // Ensure port is included
      if (!cleanUrl.contains(':3000')) {
        // Remove any existing port and add 3000
        final hostWithoutPort = host.replaceAll(RegExp(r':\d+$'), '');
        cleanUrl = 'http://$hostWithoutPort:3000';
      }
      
      debugPrint('🔧 [API_CONSTANTS] URL validated and fixed: $url -> $cleanUrl');
      return cleanUrl;
      
    } catch (e) {
      debugPrint('❌ [API_CONSTANTS] Error validating URL $url: $e');
      return _getFallbackUrl();
    }
  }
  
  /// Fix URL by ensuring port 3000 is included
  static String _fixUrlWithPort(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.replaceAll(RegExp(r':\d+$'), ''); // Remove any existing port
      final fixedUrl = 'http://$host:3000';
      debugPrint('🔧 [API_CONSTANTS] Fixed URL with port: $url -> $fixedUrl');
      return fixedUrl;
    } catch (e) {
      debugPrint('❌ [API_CONSTANTS] Error fixing URL: $e');
      return _getFallbackUrl();
    }
  }
  
  /// Get fallback URL based on build mode
  static String _getFallbackUrl() {
    final fallback = kDebugMode ? devUrl : prodUrl;
    debugPrint('🆘 [API_CONSTANTS] Using fallback URL: $fallback (debug: $kDebugMode)');
    return fallback;
  }
  
  /// Reset to default URL
  static void resetToDefault() {
    debugPrint('🔄 [API_CONSTANTS] Resetting to default URL');
    _baseUrl = defaultBaseUrl;
  }
  
  /// Validate current configuration
  static bool validateCurrentConfig() {
    final isValid = _baseUrl.isNotEmpty && 
                   _baseUrl.contains('http') && 
                   _baseUrl.contains(':3000');
    
    debugPrint('🔍 [API_CONSTANTS] Config validation: $isValid (URL: $_baseUrl)');
    
    if (!isValid) {
      debugPrint('❌ [API_CONSTANTS] Invalid config detected, fixing...');
      _baseUrl = _getFallbackUrl();
      return false;
    }
    
    return true;
  }

  // API Endpoints
  static const String authEndpoint = '/api/v1/auth';
  static const String loginEndpoint = '$authEndpoint/login';
  static const String registerEndpoint = '$authEndpoint/register';
  static const String refreshTokenEndpoint = '$authEndpoint/refresh';
  static const String logoutEndpoint = '$authEndpoint/logout';
  static const String verifyPhoneEndpoint = '$authEndpoint/verify-phone';
  static const String resendOtpEndpoint = '$authEndpoint/resend-otp';
  static const String forgotPasswordEndpoint = '$authEndpoint/forgot-password';
  static const String resetPasswordEndpoint = '$authEndpoint/reset-password';
  static const String changePasswordEndpoint = '$authEndpoint/change-password';

  // User endpoints
  static const String userEndpoint = '/api/v1/user';
  static const String profileEndpoint = '$userEndpoint/profile';
  static const String updateProfileEndpoint = '$userEndpoint/update';

  // Other endpoints
  static const String uploadsEndpoint = '/api/v1/uploads';
  static const String notificationsEndpoint = '/api/v1/notifications';
  
  // Full URLs with validation
  static String get loginUrl {
    final url = '$baseUrl$loginEndpoint';
    debugPrint('🔗 [API_CONSTANTS] Login URL: $url');
    return url;
  }
  
  static String get registerUrl {
    final url = '$baseUrl$registerEndpoint';
    debugPrint('🔗 [API_CONSTANTS] Register URL: $url');
    return url;
  }
  
  static String get refreshTokenUrl {
    final url = '$baseUrl$refreshTokenEndpoint';
    debugPrint('🔗 [API_CONSTANTS] Refresh token URL: $url');
    return url;
  }
}
