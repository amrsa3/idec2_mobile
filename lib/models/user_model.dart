import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'verification_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    String? email,
    @Default(false) bool phoneVerified,
    @Default([]) List<String> roles,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfileModel? profile,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Safe fromJson with detailed debugging
  factory UserModel.fromJsonSafe(Map<String, dynamic> json) {
    try {
      debugPrint('UserModel.fromJsonSafe: Starting parsing');
      debugPrint('UserModel.fromJsonSafe: Input JSON: $json');

      // Create a safe copy of the JSON with proper null handling
      final safeJson = Map<String, dynamic>.from(json);

      // Handle required fields
      safeJson['id'] = json['id']?.toString() ?? '';
      safeJson['phone'] = json['phone']?.toString() ?? '';
      safeJson['email'] = json['email'] as String?;
      safeJson['phoneVerified'] = json['phoneVerified'] as bool? ?? false;

      // Handle roles array
      if (json['roles'] != null) {
        if (json['roles'] is List) {
          safeJson['roles'] =
              (json['roles'] as List).map((e) => e.toString()).toList();
        } else {
          safeJson['roles'] = <String>[];
        }
      } else {
        safeJson['roles'] = <String>[];
      }

      // Handle optional date fields
      if (json['createdAt'] != null) {
        try {
          safeJson['createdAt'] = DateTime.parse(json['createdAt'].toString());
        } catch (e) {
          debugPrint('UserModel.fromJsonSafe: Error parsing createdAt: $e');
        }
      }

      if (json['updatedAt'] != null) {
        try {
          safeJson['updatedAt'] = DateTime.parse(json['updatedAt'].toString());
        } catch (e) {
          debugPrint('UserModel.fromJsonSafe: Error parsing updatedAt: $e');
        }
      }

      debugPrint('UserModel.fromJsonSafe: Safe JSON prepared: $safeJson');

      final user = UserModel.fromJson(safeJson);
      debugPrint(
          'UserModel.fromJsonSafe: Success - User created with phoneVerified: ${user.phoneVerified}');
      return user;
    } catch (e, stackTrace) {
      debugPrint('UserModel.fromJsonSafe: Error parsing user data: $e');
      debugPrint('UserModel.fromJsonSafe: Stack trace: $stackTrace');
      debugPrint('UserModel.fromJsonSafe: Raw JSON: $json');
      rethrow;
    }
  }
}

// Type alias for backward compatibility
typedef User = UserModel;

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    @Default('') String id,
    @Default('') String userId,
    @Default('') String fullNameAr,
    String? fullNameEn,
    DateTime? birthDate,
    int? graduationYear,
    String? university,
    String? workplace,
    String? gender,
    String? address,
    String? jobTitle,
    String? specialization,
    String? academicDegree,
    String? profilePhotoUrl,
    Map<String, dynamic>? profileData,
    String? status,
    String? categoryId,
    String? qualificationId,
    String? governorateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  // Safe fromJson that handles snake_case to camelCase conversion
  factory UserProfileModel.fromJsonSafe(Map<String, dynamic> json) {
    try {
      debugPrint('UserProfileModel.fromJsonSafe: Starting parsing');
      debugPrint('UserProfileModel.fromJsonSafe: Input JSON: $json');

      // Convert snake_case keys to camelCase for freezed
      final convertedJson = <String, dynamic>{};

      // Map snake_case keys to camelCase
      convertedJson['id'] = json['id']?.toString() ?? '';
      convertedJson['userId'] = json['user_id']?.toString() ?? '';
      convertedJson['fullNameAr'] = json['full_name_ar']?.toString() ?? '';
      convertedJson['fullNameEn'] = json['full_name_en']?.toString();
      convertedJson['birthDate'] = json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'].toString())
          : null;
      convertedJson['graduationYear'] = json['graduation_year'] != null
          ? int.tryParse(json['graduation_year'].toString())
          : null;
      convertedJson['university'] = json['university']?.toString();
      convertedJson['workplace'] = json['workplace']?.toString();
      convertedJson['gender'] = json['gender']?.toString();
      convertedJson['address'] = json['address']?.toString();
      convertedJson['jobTitle'] = json['job_title']?.toString();
      convertedJson['specialization'] = json['specialization']?.toString();
      convertedJson['academicDegree'] = json['academic_degree']?.toString();
      convertedJson['profilePhotoUrl'] = json['profile_photo_url']?.toString();
      convertedJson['profileData'] =
          json['profile_data'] as Map<String, dynamic>?;
      convertedJson['status'] = json['status']?.toString();
      convertedJson['categoryId'] = json['category_id']?.toString();
      convertedJson['qualificationId'] = json['qualification_id']?.toString();
      convertedJson['governorateId'] = json['governorate_id']?.toString();
      convertedJson['createdAt'] = json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null;
      convertedJson['updatedAt'] = json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null;

      debugPrint(
          'UserProfileModel.fromJsonSafe: Converted JSON: $convertedJson');

      final profile = UserProfileModel.fromJson(convertedJson);
      debugPrint('UserProfileModel.fromJsonSafe: Success - Profile created');
      return profile;
    } catch (e, stackTrace) {
      debugPrint(
          'UserProfileModel.fromJsonSafe: Error parsing profile data: $e');
      debugPrint('UserProfileModel.fromJsonSafe: Stack trace: $stackTrace');
      debugPrint('UserProfileModel.fromJsonSafe: Raw JSON: $json');
      rethrow;
    }
  }
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String phone,
    required String password,
    required String confirmPassword,
    required String name,
    String? email,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
    @Default(true) bool success,
    String? message,
    String? token,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  // Safe fromJson with detailed debugging
  factory AuthResponse.fromJsonSafe(Map<String, dynamic> json) {
    try {
      debugPrint('AuthResponse.fromJsonSafe: Starting parsing');
      debugPrint('AuthResponse.fromJsonSafe: Input JSON: $json');

      // Handle the case where the response is a simple registration response
      // without user data (just success, message, otpCode)
      if (json.containsKey('otpCode') && !json.containsKey('user')) {
        debugPrint(
            'AuthResponse.fromJsonSafe: Registration response detected (no user data)');
        return AuthResponse(
          accessToken: null,
          refreshToken: null,
          user: null,
          success:
              true, // Registration responses are always successful if we get here
          message: json['message'] as String?,
          token: null,
        );
      }

      // Extract fields with safe casting
      String? accessToken = json['accessToken'] as String?;
      String? refreshToken = json['refreshToken'] as String?;
      final userData = json['user'] as Map<String, dynamic>?;
      final success = json['success'] as bool? ?? true;
      final message = json['message'] as String?;
      final token = json['token'] as String?;

      // Handle tokens object if present
      final tokensData = json['tokens'] as Map<String, dynamic>?;
      if (tokensData != null) {
        accessToken = accessToken ?? tokensData['accessToken'] as String?;
        refreshToken = refreshToken ?? tokensData['refreshToken'] as String?;
      }

      // Fallback to access_token field if accessToken is still null
      accessToken = accessToken ?? json['access_token'] as String?;

      // Parse user data safely if it exists
      UserModel? user;
      if (userData != null) {
        try {
          user = UserModel.fromJsonSafe(userData);
        } catch (e) {
          debugPrint('AuthResponse.fromJsonSafe: Error parsing user data: $e');
          // Continue without user data rather than failing completely
          user = null;
        }
      }

      final authResponse = AuthResponse(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
        success: success,
        message: message,
        token: token,
      );

      debugPrint('AuthResponse.fromJsonSafe: Success');
      return authResponse;
    } catch (e, stackTrace) {
      debugPrint('AuthResponse.fromJsonSafe: Error: $e');
      debugPrint('AuthResponse.fromJsonSafe: Stack trace: $stackTrace');
      rethrow;
    }
  }
}

@freezed
class OtpRequest with _$OtpRequest {
  const factory OtpRequest({
    required String phone,
  }) = _OtpRequest;

  factory OtpRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestFromJson(json);
}

@freezed
class OtpVerifyRequest with _$OtpVerifyRequest {
  const factory OtpVerifyRequest({
    required String phone,
    required String otp,
  }) = _OtpVerifyRequest;

  factory OtpVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyRequestFromJson(json);
}

@freezed
class ProfileStatusModel with _$ProfileStatusModel {
  const factory ProfileStatusModel({
    required String status,
    required double completionPercentage,
    required UserModel user,
    required List<VerificationRequestModel> pendingRequests,
    required List<DocumentModel> documents,
  }) = _ProfileStatusModel;

  factory ProfileStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatusModelFromJson(json);
}

@freezed
class DocumentModel with _$DocumentModel {
  const factory DocumentModel({
    required String id,
    required String type,
    required String url,
    required String status,
    DateTime? uploadedAt,
  }) = _DocumentModel;

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);
}

@freezed
class RequestPasswordResetRequest with _$RequestPasswordResetRequest {
  const factory RequestPasswordResetRequest({
    required String phone,
    String? preferredChannel,
  }) = _RequestPasswordResetRequest;

  factory RequestPasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestPasswordResetRequestFromJson(json);
}

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

@freezed
class PasswordResetResponse with _$PasswordResetResponse {
  const factory PasswordResetResponse({
    @Default(true) bool success,
    String? message,
    String? phoneNumber,
  }) = _PasswordResetResponse;

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetResponseFromJson(json);
}
