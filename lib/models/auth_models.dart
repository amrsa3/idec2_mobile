import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/user_model.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// نتيجة عملية المصادقة
@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult.success(
    UserModel? user,
    String message,
  ) = AuthSuccess;

  const factory AuthResult.error(
    String message,
  ) = AuthError;

  const factory AuthResult.loading(
    String message,
  ) = AuthLoading;
}

/// حالة المصادقة
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = InitialState;

  const factory AuthState.loading(String message) = LoadingState;

  const factory AuthState.authenticated(UserModel user) = AuthenticatedState;

  const factory AuthState.unauthenticated() = UnauthenticatedState;

  const factory AuthState.registered() = RegisteredState;

  const factory AuthState.error(String message) = ErrorState;
}

/// طلب تسجيل الدخول
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    required String password,
    @Default(false) bool rememberMe,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// طلب التسجيل
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    String? email,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// طلب رمز التحقق
@freezed
class OtpRequest with _$OtpRequest {
  const factory OtpRequest({
    required String phone,
    @Default('verification') String purpose,
  }) = _OtpRequest;

  factory OtpRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestFromJson(json);
}

/// طلب التحقق من رمز OTP
@freezed
class OtpVerifyRequest with _$OtpVerifyRequest {
  const factory OtpVerifyRequest({
    required String phone,
    required String otp,
  }) = _OtpVerifyRequest;

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestFromJson(json);
}

/// طلب إعادة تعيين كلمة المرور
@freezed
class PasswordResetRequest with _$PasswordResetRequest {
  const factory PasswordResetRequest({
    required String phone,
  }) = _PasswordResetRequest;

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
}

/// طلب إعادة تعيين كلمة المرور مع OTP
@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String phone,
    required String otp,
    required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

/// استجابة إعادة تعيين كلمة المرور
@freezed
class PasswordResetResponse with _$PasswordResetResponse {
  const factory PasswordResetResponse({
    required bool success,
    required String message,
    String? otpCode,
  }) = _PasswordResetResponse;

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetResponseFromJson(json);
}

/// استجابة المصادقة
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required bool success,
    required String message,
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    String? token,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  /// إنشاء استجابة آمنة من JSON
  factory AuthResponse.fromJsonSafe(Map<String, dynamic> json) {
    try {
      return AuthResponse(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String? ?? '',
        accessToken:
            json['access_token'] as String? ?? json['accessToken'] as String?,
        refreshToken:
            json['refresh_token'] as String? ?? json['refreshToken'] as String?,
        user: json['user'] != null
            ? UserModel.fromJsonSafe(json['user'] as Map<String, dynamic>)
            : null,
        token: json['token'] as String? ??
            json['access_token'] as String? ??
            json['accessToken'] as String?,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'خطأ في تحليل استجابة المصادقة: $e',
      );
    }
  }
}

/// معلومات الجلسة
@freezed
class SessionInfo with _$SessionInfo {
  const factory SessionInfo({
    required String sessionId,
    required String userId,
    required DateTime startTime,
    required DateTime lastActivity,
    required bool isActive,
    required Duration duration,
    required Duration inactivityDuration,
  }) = _SessionInfo;

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);
}

/// معلومات التوكن
@freezed
class TokenInfo with _$TokenInfo {
  const factory TokenInfo({
    required bool hasAccessToken,
    required bool hasRefreshToken,
    required bool isValid,
    String? expiryTime,
    String? lastRefresh,
    int? timeUntilExpiry,
    required bool integrityValid,
    required String platform,
  }) = _TokenInfo;

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);
}

/// معلومات التخزين المحلي
@freezed
class StorageInfo with _$StorageInfo {
  const factory StorageInfo({
    String? lastSyncTime,
    required int pendingOperationsCount,
    required bool hasUserData,
    required bool hasAuthData,
    required int totalOfflineData,
    required int dataRetentionPeriod,
  }) = _StorageInfo;

  factory StorageInfo.fromJson(Map<String, dynamic> json) =>
      _$StorageInfoFromJson(json);
}

/// معلومات الاتصال
@freezed
class ConnectivityInfo with _$ConnectivityInfo {
  const factory ConnectivityInfo({
    required String currentStatus,
    required bool isConnected,
    required String connectionType,
    required String lastCheck,
    required String platform,
  }) = _ConnectivityInfo;

  factory ConnectivityInfo.fromJson(Map<String, dynamic> json) =>
      _$ConnectivityInfoFromJson(json);
}

/// معلومات النظام الشاملة
@freezed
class SystemInfo with _$SystemInfo {
  const factory SystemInfo({
    required SessionInfo sessionInfo,
    required TokenInfo tokenInfo,
    required StorageInfo storageInfo,
    required ConnectivityInfo connectivityInfo,
    required DateTime timestamp,
  }) = _SystemInfo;

  factory SystemInfo.fromJson(Map<String, dynamic> json) =>
      _$SystemInfoFromJson(json);
}



