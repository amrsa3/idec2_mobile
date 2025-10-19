import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Server Settings - Updated to match server paths
  @GET('/api/v1/server/settings')
  Future<ApiResponse> getServerSettings();

  @GET('/api/v1/health')
  Future<HealthCheckModel> getHealthCheck();

  // Authentication - Updated to match server paths
  @POST('/api/v1/auth/register')
  Future<ApiResponse> register(@Body() RegisterRequest request);

  @POST('/api/v1/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/api/auth/refresh')
  Future<AuthResponse> refreshToken(@Field('refresh_token') String refreshToken);

  @POST('/api/v1/auth/logout')
  Future<ApiResponse> logout();

  // OTP - Updated to match server implementation
  @POST('/api/v1/auth/request-otp')
  Future<ApiResponse> sendOtp(@Body() OtpRequest request);

  @POST('/api/v1/auth/verify-otp')
  Future<ApiResponse> verifyOtp(@Body() OtpVerifyRequest request);

  @POST('/api/v1/auth/resend-otp')
  Future<ApiResponse> resendOtp(@Body() OtpRequest request);

  @GET('/api/v1/auth/channels')
  Future<ApiResponse> getOtpChannels();

  // Password Reset - New endpoints
  @POST('/api/v1/auth/request-password-reset')
  Future<PasswordResetResponse> requestPasswordReset(@Body() RequestPasswordResetRequest request);

  @POST('/api/v1/auth/reset-password')
  Future<PasswordResetResponse> resetPassword(@Body() ResetPasswordRequest request);

  // User Profile - Updated to match server implementation
  @GET('/api/v1/auth/profile')
  Future<UserModel> getUserProfile();

  @PUT('/api/v1/auth/profile')
  Future<UserModel> updateUserProfile(@Body() UserProfileModel profile);

  @POST('/api/v1/auth/check-user-status')
  Future<ApiResponse> checkUserStatus(@Body() Map<String, String> request);

  // Profile endpoints - New endpoints
  @GET('/api/v1/profiles/me')
  Future<UserProfileModel> getMyProfile();

  @PUT('/api/v1/profiles/me')
  Future<UserProfileModel> updateMyProfile(@Body() UserProfileModel profile);

  @GET('/api/v1/profiles/me/status')
  Future<ProfileStatusModel> getProfileStatus();

  // File Upload - Fixed to match actual server endpoints
  @POST('/api/v1/files/upload')
  @MultiPart()
  Future<FileUploadResponse> uploadFile(
    @Part() File file,
    @Part() String entityType,
    @Part() String entityId,
    @Part() String fileCategory,
    @Part() String description,
    @Part() bool isPublic,
    @Part() String accessLevel,
  );

  @GET('/api/v1/files')
  Future<List<FileModel>> getFiles(
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('entityType') String? entityType,
    @Query('entityId') String? entityId,
  );

  @GET('/api/v1/files/{fileId}')
  Future<FileModel> getFile(@Path('fileId') String fileId);

  @DELETE('/api/v1/files/{fileId}')
  Future<ApiResponse> deleteFile(@Path('fileId') String fileId);

  @GET('/api/v1/files/{fileId}/download')
  Future<HttpResponse<List<int>>> downloadFile(@Path('fileId') String fileId);

  // Verification - Updated to match server paths
  @GET('/api/v1/verification/rules')
  Future<VerificationRulesModel> getVerificationRules();

  @POST('/api/v1/verification/documents')
  Future<ApiResponse> uploadVerificationDocument(@Body() DocumentUploadRequest request);

  @GET('/api/v1/verification/requests')
  Future<List<VerificationRequestModel>> getVerificationRequests(
    @Query('status') String? status,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );

  @POST('/api/v1/verification/requests')
  Future<VerificationRequestModel> submitVerificationRequest(@Body() SubmitVerificationRequest request);

  @GET('/api/v1/verification/requests/{requestId}')
  Future<VerificationRequestModel> getVerificationRequest(@Path('requestId') String requestId);

  @POST('/api/v1/verification/requests/{requestId}/approve')
  Future<ApiResponse> approveVerificationRequest(@Path('requestId') String requestId);

  @POST('/api/v1/verification/requests/{requestId}/reject')
  Future<ApiResponse> rejectVerificationRequest(
    @Path('requestId') String requestId,
    @Body() Map<String, dynamic> request,
  );

  // Notifications - Fixed to match actual server endpoints
  @POST('/api/v1/notifications/send')
  Future<NotificationResponse> sendNotification(@Body() SendNotificationRequest request);

  @GET('/api/v1/notifications/logs')
  Future<List<NotificationModel>> getNotifications(@Queries() Map<String, dynamic> queries);

  @GET('/api/v1/notifications/templates')
  Future<List<NotificationTemplate>> getNotificationTemplates(@Queries() Map<String, dynamic> queries);

  @GET('/api/v1/notifications/stats')
  Future<NotificationStats> getNotificationStats();

  @PUT('/api/v1/notifications/{notificationId}/read')
  Future<ApiResponse> markNotificationAsRead(@Path('notificationId') String notificationId);

  @PUT('/api/v1/notifications/read-all')
  Future<ApiResponse> markAllNotificationsAsRead();

  @POST('/api/v1/notifications/bulk-read')
  Future<ApiResponse> bulkMarkNotificationsAsRead(@Body() List<String> notificationIds);

  @DELETE('/api/v1/notifications/{notificationId}')
  Future<ApiResponse> deleteNotification(@Path('notificationId') String notificationId);

  @POST('/api/v1/notifications/bulk-delete')
  Future<ApiResponse> bulkDeleteNotifications(@Body() List<String> notificationIds);

  @GET('/api/v1/notifications/{notificationId}')
  Future<NotificationModel> getNotificationById(@Path('notificationId') String notificationId);

  @GET('/api/v1/notifications/search')
  Future<List<NotificationModel>> searchNotifications(@Queries() Map<String, dynamic> searchParams);

  @GET('/api/v1/notifications/settings')
  Future<NotificationSettings> getNotificationSettings();

  @PUT('/api/v1/notifications/settings')
  Future<ApiResponse> updateNotificationSettings(@Body() NotificationSettings settings);
}
