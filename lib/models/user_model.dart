import 'package:freezed_annotation/freezed_annotation.dart';
import 'verification_model.dart';
import 'package:flutter/foundation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    String? email,
    @Default('') String firstName,
    @Default('') String lastName,
    @JsonKey(name: 'full_name_ar') @Default('') String fullNameAr,
    @JsonKey(name: 'full_name_en') String? fullNameEn,
    @Default(false) bool phoneVerified,
    @Default([]) List<String> roles,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePictureUrl,
    String? profilePicture,
    @Default(true) bool isVerified,
    @Default(true) bool isActive,
    @Default(false) bool isEmailVerified,
    UserProfileModel? profile,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Safe fromJson with detailed debugging
  factory UserModel.fromJsonSafe(Map<String, dynamic> json) {
    try {
      debugPrint('UserModel.fromJsonSafe: Starting parsing');
      debugPrint('UserModel.fromJsonSafe: Input JSON: $json');
      
      // Create a safe copy of the JSON with proper null handling for boolean fields
      final safeJson = Map<String, dynamic>.from(json);
      
      // Handle boolean fields that might be null or missing
      // Use phoneVerified from server response directly
      safeJson['phoneVerified'] = json['phoneVerified'] as bool? ?? false;
      
      // Handle other boolean fields with safe defaults
      safeJson['isEmailVerified'] = json['isEmailVerified'] as bool? ?? false;
      safeJson['isVerified'] = json['isVerified'] as bool? ?? true;
      safeJson['isActive'] = json['isActive'] as bool? ?? true;
      
      // Handle string fields with safe defaults
      safeJson['firstName'] = json['firstName'] as String? ?? '';
      safeJson['lastName'] = json['lastName'] as String? ?? '';
      safeJson['fullNameAr'] = json['full_name_ar'] as String? ?? json['fullNameAr'] as String? ?? '';
      safeJson['full_name_ar'] = safeJson['fullNameAr']; // Ensure JsonKey mapping works
      
      // Handle roles array
      if (json['roles'] != null) {
        if (json['roles'] is List) {
          safeJson['roles'] = (json['roles'] as List).map((e) => e.toString()).toList();
        } else {
          safeJson['roles'] = <String>[];
        }
      } else {
        safeJson['roles'] = <String>[];
      }
      
      // Handle id field - keep as string (don't convert to int)
      if (json['id'] != null) {
        safeJson['id'] = json['id'].toString();
      }
      
      // Handle optional numeric fields
      if (json['governorateId'] != null) {
        if (json['governorateId'] is String) {
          safeJson['governorateId'] = int.tryParse(json['governorateId']);
        }
      }
      
      if (json['qualificationId'] != null) {
        if (json['qualificationId'] is String) {
          safeJson['qualificationId'] = int.tryParse(json['qualificationId']);
        }
      }
      
      debugPrint('UserModel.fromJsonSafe: Safe JSON prepared: $safeJson');
      
      final user = UserModel.fromJson(safeJson);
      debugPrint('UserModel.fromJsonSafe: Success - User created with phoneVerified: ${user.phoneVerified}');
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
    String? title,
    String? specialization,
    String? workPlace,
    String? country,
    String? city,
    String? address,
    String? phoneNumber,
    String? whatsappNumber,
    String? telegramNumber,
    String? linkedinProfile,
    String? facebookProfile,
    String? instagramProfile,
    String? twitterProfile,
    String? websiteUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? nationality,
    String? passportNumber,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,
    String? dietaryRestrictions,
    String? medicalConditions,
    String? accommodationPreferences,
    String? transportationNeeds,
    String? languagePreference,
    bool? marketingConsent,
    bool? dataProcessingConsent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
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
         debugPrint('AuthResponse.fromJsonSafe: Registration response detected (no user data)');
         return AuthResponse(
           accessToken: null,
           refreshToken: null,
           user: null,
           success: true, // Registration responses are always successful if we get here
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
