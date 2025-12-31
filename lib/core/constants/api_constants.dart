import 'package:flutter/foundation.dart';

class ApiConstants {
<<<<<<< HEAD
  // Default URLs - using production API server
  static const String defaultBaseUrl = 'https://api.idec-ye.com';
  static const String devUrl = 'https://api.idec-ye.com';
  static const String prodUrl = 'https://api.idec-ye.com';

  // Fallback domain URL
  static const String domainUrl = 'https://api.idec-ye.com';
=======
  // Production API URL - Primary server
  static const String productionUrl = 'https://api.idec-ye.com';

  // Development URLs for local testing
  static const String devUrl = 'http://localhost:3000';
  static const String localhostUrl = 'http://localhost:3000';

  // Default base URL - Using production server
  static const String defaultBaseUrl = productionUrl;
>>>>>>> working-version-fixed

  // Current base URL - will be updated dynamically
  static String _baseUrl = defaultBaseUrl;

  /// Get current base URL with validation
  static String get baseUrl {
    debugPrint('🔍 [API_CONSTANTS] Getting baseUrl - _baseUrl: $_baseUrl');
    debugPrint('🔍 [API_CONSTANTS] defaultBaseUrl: $defaultBaseUrl');
    debugPrint('🔍 [API_CONSTANTS] productionUrl: $productionUrl');

    // Validate current URL
    if (_baseUrl.isEmpty || !_baseUrl.contains(':')) {
      debugPrint(
        '⚠️ [API_CONSTANTS] Invalid baseUrl detected: $_baseUrl, using fallback',
      );
      _baseUrl = _getFallbackUrl();
    }

<<<<<<< HEAD
    // Ensure HTTPS is used for production API
    if (!_baseUrl.startsWith('https://')) {
      debugPrint(
        '⚠️ [API_CONSTANTS] HTTPS missing in baseUrl: $_baseUrl, fixing...',
      );
      _baseUrl = _fixUrlWithHttps(_baseUrl);
=======
    // For localhost, ensure port 3000 is included
    if (_baseUrl.contains('localhost') && !_baseUrl.contains(':3000')) {
      debugPrint(
          '⚠️ [API_CONSTANTS] Port missing for localhost: $_baseUrl, fixing...');
      _baseUrl = '${_baseUrl.replaceAll(RegExp(r':\d+'), '')}:3000';
>>>>>>> working-version-fixed
    }

    // Validate HTTPS for production API only
    if (!_baseUrl.startsWith('https://') &&
        _baseUrl.contains('api.idec-ye.com')) {
      debugPrint(
          '⚠️ [API_CONSTANTS] HTTPS missing for production API: $_baseUrl, fixing...');
      _baseUrl = _baseUrl.replaceFirst('http://', 'https://');
    }

    debugPrint('🔗 [API_CONSTANTS] Final baseUrl: $_baseUrl');
    return _baseUrl;
  }

  /// Update base URL with validation
  static void updateBaseUrl(String newUrl) {
    debugPrint(
      '🔄 [API_CONSTANTS] Updating baseUrl from: $_baseUrl to: $newUrl',
    );

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

      // Ensure https:// prefix for production API
      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        cleanUrl = 'https://$cleanUrl';
      }

      // Parse URL to validate
      final uri = Uri.parse(cleanUrl);
      final host = uri.host;

      if (host.isEmpty) {
        debugPrint('❌ [API_CONSTANTS] Invalid host in URL: $url');
        return _getFallbackUrl();
      }

<<<<<<< HEAD
      // Ensure HTTPS is used for production API
      if (cleanUrl.startsWith('http://')) {
=======
      // For localhost, ensure port 3000
      if (host == 'localhost' && !cleanUrl.contains(':3000')) {
        cleanUrl = 'http://localhost:3000';
      }

      // Ensure HTTPS for production API only
      if (cleanUrl.contains('api.idec-ye.com') &&
          !cleanUrl.startsWith('https://')) {
>>>>>>> working-version-fixed
        cleanUrl = cleanUrl.replaceFirst('http://', 'https://');
      }

      debugPrint(
        '🔧 [API_CONSTANTS] URL validated and fixed: $url -> $cleanUrl',
      );
      return cleanUrl;
    } catch (e) {
      debugPrint('❌ [API_CONSTANTS] Error validating URL $url: $e');
      return _getFallbackUrl();
    }
  }

<<<<<<< HEAD
  /// Fix URL by ensuring HTTPS is used
  static String _fixUrlWithHttps(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.replaceAll(
        RegExp(r':\d+$'),
        '',
      ); // Remove any existing port
      final fixedUrl = 'https://$host';
      debugPrint('🔧 [API_CONSTANTS] Fixed URL with HTTPS: $url -> $fixedUrl');
      return fixedUrl;
=======
  /// Fix URL by ensuring HTTPS for production API
  static String _fixUrlWithHttps(String url) {
    try {
      if (url.contains('api.idec-ye.com') && !url.startsWith('https://')) {
        final fixedUrl = url.replaceFirst('http://', 'https://');
        debugPrint(
            '🔧 [API_CONSTANTS] Fixed URL with HTTPS: $url -> $fixedUrl');
        return fixedUrl;
      }
      return url;
>>>>>>> working-version-fixed
    } catch (e) {
      debugPrint('❌ [API_CONSTANTS] Error fixing URL: $e');
      return _getFallbackUrl();
    }
  }

  /// Get fallback URL based on build mode
  static String _getFallbackUrl() {
    // Use localhost in debug mode, production in release mode
    const fallback = kDebugMode ? devUrl : productionUrl;
    debugPrint(
<<<<<<< HEAD
      '🆘 [API_CONSTANTS] Using fallback URL: $fallback (debug: $kDebugMode)',
    );
=======
        '🆘 [API_CONSTANTS] Using fallback URL: $fallback (debug: $kDebugMode, web: $kIsWeb)');
>>>>>>> working-version-fixed
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
<<<<<<< HEAD
        _baseUrl.startsWith('https://') &&
        _baseUrl.contains('api.idec-ye.com');
=======
        _baseUrl.contains('http') &&
        (_baseUrl.contains(':3000') ||
            _baseUrl.contains('api.idec-ye.com') ||
            _baseUrl.contains('localhost'));
>>>>>>> working-version-fixed

    debugPrint(
      '🔍 [API_CONSTANTS] Config validation: $isValid (URL: $_baseUrl)',
    );

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
  static const String verifyPhoneEndpoint = '$authEndpoint/verify-otp';
  static const String resendOtpEndpoint = '$authEndpoint/resend-otp';
  static const String forgotPasswordEndpoint = '$authEndpoint/request-password-reset';
  static const String resetPasswordEndpoint = '$authEndpoint/reset-password';
  static const String changePasswordEndpoint = '$authEndpoint/change-password';

  // User endpoints
  static const String userEndpoint = '/api/v1/user';
  static const String profileEndpoint = '$userEndpoint/profile';
  static const String updateProfileEndpoint = '$userEndpoint/update';

  // Other endpoints
  static const String uploadsEndpoint = '/api/v1/uploads';
  static const String notificationsEndpoint = '/api/v1/notifications';
  
  // Events endpoints
  static const String eventsEndpoint = '/api/v1/events';
  static const String featuredEventsEndpoint = '/api/v1/events?isFeatured=true';
  
  // Speakers endpoints
  static const String speakersEndpoint = '/api/v1/speakers';
  
  // Exhibitors endpoints
  static const String exhibitorsEndpoint = '/api/v1/exhibitors';

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
