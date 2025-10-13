import '../services/server_settings_service.dart';

class ApiConstants {
  // Default Base URLs (fallback values)
  static const String defaultBaseUrl = 'http://idec-ye.com:3000';
  static const String devUrl = 'http://10.0.2.2:3000'; // For Android emulator
  static const String prodUrl = 'http://192.168.0.165:3000'; // Production URL

  // Dynamic base URL - will be updated from server settings
  static String baseUrl = defaultBaseUrl;

  // API Version
  static const String apiVersion = '/api/v1';

  // Server endpoints
  static const String serverSettings = '$apiVersion/server/settings';
  static const String health = '$apiVersion/health';

  // Authentication endpoints
  static const String register = '$apiVersion/auth/register';
  static const String login = '$apiVersion/auth/login';
  static const String refreshToken = '$apiVersion/auth/refresh';
  static const String logout = '$apiVersion/auth/logout';

  // OTP endpoints
  static const String sendOtp = '$apiVersion/auth/request-otp';
  static const String verifyOtp = '$apiVersion/auth/verify-otp';
  static const String resendOtp = '$apiVersion/auth/resend-otp';
  static const String otpChannels = '$apiVersion/auth/otp-channels';

  // User endpoints
  static const String userProfile = '$apiVersion/users/profile';
  static const String updateProfile = '$apiVersion/users/profile';
  static const String userStatus = '$apiVersion/users/status';

  // Profile endpoints
  static const String profileMe = '$apiVersion/profiles/me';
  static const String updateProfileMe = '$apiVersion/profiles/me';
  static const String profileStatus = '$apiVersion/profiles/me/status';

  // File management endpoints
  static const String uploadFile = '$apiVersion/files/upload';
  static const String uploadMultipleFiles = '$apiVersion/files/upload-multiple';
  static const String getFiles = '$apiVersion/files';
  static const String searchFiles = '$apiVersion/files/search';
  static String getFile(String id) => '$apiVersion/files/$id';
  static String deleteFile(String id) => '$apiVersion/files/$id';
  static String downloadFile(String id) => '$apiVersion/files/$id/download';
  static String getFileThumbnail(String id) =>
      '$apiVersion/files/$id/thumbnail';
  static String getFilePreview(String id) => '$apiVersion/files/$id/preview';

  // Verification endpoints
  static const String verificationRules = '$apiVersion/verification/rules';
  static const String verificationRequests =
      '$apiVersion/verification/requests';
  static const String uploadVerificationDocument =
      '$apiVersion/verification/upload';
  static String getVerificationRequest(String id) =>
      '$apiVersion/verification/requests/$id';
  static String approveVerificationRequest(String id) =>
      '$apiVersion/verification/requests/$id/approve';
  static String rejectVerificationRequest(String id) =>
      '$apiVersion/verification/requests/$id/reject';

  // Notification endpoints
  static const String getNotifications = '$apiVersion/notifications/logs';
  static const String sendNotification = '$apiVersion/notifications/send';
  static const String getNotificationTemplates =
      '$apiVersion/notifications/templates';
  static const String getNotificationStats = '$apiVersion/notifications/stats';
  static const String getNotificationSettings =
      '$apiVersion/notifications/settings';
  static const String updateNotificationSettings =
      '$apiVersion/notifications/settings';
  static String markNotificationAsRead(String id) =>
      '$apiVersion/notifications/$id/read';
  static const String markAllNotificationsAsRead =
      '$apiVersion/notifications/mark-all-read';
  static String deleteNotification(String id) =>
      '$apiVersion/notifications/$id';
  static String getNotificationById(String id) =>
      '$apiVersion/notifications/$id';
  static const String bulkMarkNotificationsAsRead =
      '$apiVersion/notifications/bulk-mark-read';
  static const String bulkDeleteNotifications =
      '$apiVersion/notifications/bulk-delete';
  static const String searchNotifications = '$apiVersion/notifications/search';

  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // File upload limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache keys
  static const String userCacheKey = 'user_data';
  static const String tokenCacheKey = 'auth_token';
  static const String refreshTokenCacheKey = 'refresh_token';
  static const String settingsCacheKey = 'app_settings';

  // Error codes
  static const String errorUnauthorized = 'UNAUTHORIZED';
  static const String errorForbidden = 'FORBIDDEN';
  static const String errorNotFound = 'NOT_FOUND';
  static const String errorValidation = 'VALIDATION_ERROR';
  static const String errorServer = 'SERVER_ERROR';
  static const String errorNetwork = 'NETWORK_ERROR';
  static const String errorTimeout = 'TIMEOUT_ERROR';

  // Success codes
  static const String successOk = 'OK';
  static const String successCreated = 'CREATED';
  static const String successUpdated = 'UPDATED';
  static const String successDeleted = 'DELETED';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String contentTypeFormData = 'multipart/form-data';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  // Development flags
  static const bool isDevelopment = true;
  static const bool enableLogging = true;
  static const bool enableMockData = false;

  // Update base URL from server settings
  static Future<void> updateBaseUrlFromSettings(
      ServerSettingsService serverSettingsService) async {
    try {
      final settings = await serverSettingsService.getCurrentSettings();
      baseUrl = settings.baseUrl;
      print('🔄 ApiConstants: Base URL updated to ${baseUrl}');
    } catch (e) {
      // Fallback to default if there's an error
      baseUrl = defaultBaseUrl;
      print(
          '❌ ApiConstants: Failed to update base URL, using default: ${baseUrl}');
    }
  }

  // Get full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  // Get headers with auth token
  static Map<String, String> getAuthHeaders(String? token) {
    final headers = <String, String>{
      'Content-Type': contentTypeJson,
      'Accept': contentTypeJson,
    };

    if (token != null && token.isNotEmpty) {
      headers[authorizationHeader] = '$bearerPrefix$token';
    }

    return headers;
  }

  // Get multipart headers with auth token
  static Map<String, String> getMultipartHeaders(String? token) {
    final headers = <String, String>{
      'Accept': contentTypeJson,
    };

    if (token != null && token.isNotEmpty) {
      headers[authorizationHeader] = '$bearerPrefix$token';
    }

    return headers;
  }
}
