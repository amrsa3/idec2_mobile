/// Application-wide timeout and duration constants
/// 
/// This file contains all timeout, delay, and duration constants
/// used throughout the application to avoid magic numbers.

class TimeoutConstants {
  TimeoutConstants._();

  // ============ Server Settings ============
  /// Timeout for server settings validation
  static const Duration serverSettingsTimeout = Duration(seconds: 10);
  
  /// Timeout for server health check
  static const Duration serverHealthCheckTimeout = Duration(seconds: 5);

  // ============ API Timeouts ============
  /// Default connect timeout for API requests
  static const Duration connectTimeout = Duration(seconds: 30);
  
  /// Default receive timeout for API requests
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  /// Default send timeout for API requests
  static const Duration sendTimeout = Duration(seconds: 30);
  
  /// Timeout for file upload requests
  static const Duration uploadTimeout = Duration(minutes: 5);
  
  /// Timeout for file download requests
  static const Duration downloadTimeout = Duration(minutes: 5);

  // ============ Token Expiry ============
  /// Default access token expiry (15 minutes)
  static const Duration defaultTokenExpiry = Duration(minutes: 15);
  static const int defaultTokenExpirySeconds = 900;
  
  /// Default refresh token expiry (30 days)
  static const Duration defaultRefreshTokenExpiry = Duration(days: 30);
  static const int defaultRefreshTokenExpirySeconds = 2592000;
  
  /// Time before token expiry to trigger refresh
  static const Duration tokenRefreshBuffer = Duration(minutes: 2);

  // ============ Session Management ============
  /// Session heartbeat interval
  static const Duration sessionHeartbeatInterval = Duration(minutes: 5);
  
  /// Session activity update interval
  static const Duration sessionActivityInterval = Duration(minutes: 1);
  
  /// Session idle timeout
  static const Duration sessionIdleTimeout = Duration(hours: 24);

  // ============ UI Delays ============
  /// Default delay for animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  /// Short delay for UI feedback
  static const Duration shortDelay = Duration(milliseconds: 100);
  
  /// Medium delay for transitions
  static const Duration mediumDelay = Duration(milliseconds: 300);
  
  /// Delay before showing loading indicator
  static const Duration loadingDelay = Duration(milliseconds: 500);
  
  /// Debounce delay for search input
  static const Duration searchDebounce = Duration(milliseconds: 300);
  
  /// Delay after successful operation
  static const Duration successDelay = Duration(milliseconds: 500);

  // ============ Refresh & Retry ============
  /// Delay between retry attempts
  static const Duration retryDelay = Duration(seconds: 2);
  
  /// Maximum retry delay (exponential backoff cap)
  static const Duration maxRetryDelay = Duration(seconds: 30);
  
  /// Auto-refresh interval for lists
  static const Duration listRefreshInterval = Duration(minutes: 5);

  // ============ Cache ============
  /// Cache validity duration
  static const Duration cacheValidity = Duration(hours: 24);
  
  /// Recent cache threshold
  static const Duration recentCacheThreshold = Duration(minutes: 5);
  
  /// Image cache duration
  static const Duration imageCacheValidity = Duration(days: 7);

  // ============ Connection Status ============
  /// Delay before showing connection status indicator
  static const Duration connectionIndicatorDelay = Duration(seconds: 2);
  
  /// Reconnection attempt interval
  static const Duration reconnectionInterval = Duration(seconds: 5);
  
  /// Connection timeout for WebSocket
  static const Duration websocketTimeout = Duration(seconds: 10);

  // ============ Notifications ============
  /// Snackbar display duration
  static const Duration snackbarDuration = Duration(seconds: 4);
  
  /// Web snackbar display duration (longer for web)
  static const Duration webSnackbarDuration = Duration(seconds: 6);
  
  /// Toast display duration
  static const Duration toastDuration = Duration(seconds: 3);
}

/// Maximum limits and sizes
class LimitConstants {
  LimitConstants._();

  // ============ Retry Limits ============
  /// Maximum number of retry attempts
  static const int maxRetryAttempts = 3;
  
  /// Maximum number of server discovery retries
  static const int maxServerDiscoveryRetries = 9;

  // ============ Size Limits ============
  /// Maximum file size for upload (10 MB)
  static const int maxFileUploadSizeBytes = 10 * 1024 * 1024;
  
  /// Maximum image size for upload (5 MB)
  static const int maxImageUploadSizeBytes = 5 * 1024 * 1024;
  
  /// Maximum document size for upload (20 MB)
  static const int maxDocumentUploadSizeBytes = 20 * 1024 * 1024;

  // ============ Pagination ============
  /// Default page size
  static const int defaultPageSize = 20;
  
  /// Maximum page size
  static const int maxPageSize = 100;
  
  /// Chat messages page size
  static const int chatMessagesPageSize = 50;

  // ============ Input Limits ============
  /// Maximum phone number length
  static const int maxPhoneLength = 15;
  
  /// Minimum phone number length
  static const int minPhoneLength = 7;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;
  
  /// Minimum password length
  static const int minPasswordLength = 6;

  // ============ Cache Limits ============
  /// Maximum image cache entries
  static const int maxImageCacheEntries = 100;
  
  /// Maximum failed image cache entries
  static const int maxFailedImageCacheEntries = 50;
}

/// Storage keys used throughout the application
class StorageKeys {
  StorageKeys._();

  // ============ Authentication ============
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String currentUser = 'current_user';
  static const String userData = 'user_data';
  static const String rememberMe = 'rememberMe';
  static const String fcmToken = 'fcm_device_token';

  // ============ Settings ============
  static const String serverUrl = 'server_url';
  static const String selectedLanguage = 'selected_language';
  static const String themeMode = 'theme_mode';
  static const String onboardingCompleted = 'onboarding_completed';

  // ============ Cache ============
  static const String cachedProfile = 'cached_profile_data';
  static const String profileCacheTimestamp = 'profile_cache_timestamp';
  static const String pendingProfileUpdate = 'pending_profile_update';

  // ============ Session ============
  static const String sessionData = 'session_data';
  static const String lastActivity = 'last_activity';
  static const String offlineActivities = 'offline_activities';
}
