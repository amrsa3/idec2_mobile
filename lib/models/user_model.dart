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
    @Default(false) bool isPhoneVerified,
    UserProfileModel? profile,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Safe fromJson with detailed debugging
  factory UserModel.fromJsonSafe(Map<String, dynamic> json) {
    try {
      debugPrint('🔍 [USER_DEBUG] ========== UserModel.fromJsonSafe START ==========');
      debugPrint('🔍 [USER_DEBUG] Input JSON type: ${json.runtimeType}');
      debugPrint('🔍 [USER_DEBUG] Input JSON keys: ${json.keys.toList()}');
      debugPrint('🔍 [USER_DEBUG] Input JSON: $json');
      
      // Check each field individually with detailed logging
      debugPrint('🔍 [USER_DEBUG] Checking individual fields...');
      
      // ID field
      final id = json['id'];
      debugPrint('🔍 [USER_DEBUG] id: $id (${id.runtimeType})');
      if (id == null) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: Missing required field: id');
        throw Exception('Missing required field: id');
      }
      if (id is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: id is not a String: ${id.runtimeType}');
        throw Exception('Field id must be a String, got ${id.runtimeType}');
      }
      
      // Phone field
      final phone = json['phone'];
      debugPrint('🔍 [USER_DEBUG] phone: $phone (${phone.runtimeType})');
      if (phone == null) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: Missing required field: phone');
        throw Exception('Missing required field: phone');
      }
      if (phone is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: phone is not a String: ${phone.runtimeType}');
        throw Exception('Field phone must be a String, got ${phone.runtimeType}');
      }
      
      // Email field (optional)
      final email = json['email'];
      debugPrint('🔍 [USER_DEBUG] email: $email (${email.runtimeType})');
      if (email != null && email is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: email is not a String: ${email.runtimeType}');
        throw Exception('Field email must be a String or null, got ${email.runtimeType}');
      }
      
      // FirstName field (optional with default)
      final firstName = json['firstName'];
      debugPrint('🔍 [USER_DEBUG] firstName: $firstName (${firstName.runtimeType})');
      if (firstName != null && firstName is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: firstName is not a String: ${firstName.runtimeType}');
        throw Exception('Field firstName must be a String or null, got ${firstName.runtimeType}');
      }
      
      // LastName field (optional with default)
      final lastName = json['lastName'];
      debugPrint('🔍 [USER_DEBUG] lastName: $lastName (${lastName.runtimeType})');
      if (lastName != null && lastName is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: lastName is not a String: ${lastName.runtimeType}');
        throw Exception('Field lastName must be a String or null, got ${lastName.runtimeType}');
      }
      
      // FullNameAr field (with JsonKey mapping)
      final fullNameAr = json['full_name_ar'] ?? json['fullNameAr'];
      debugPrint('🔍 [USER_DEBUG] fullNameAr: $fullNameAr (${fullNameAr.runtimeType})');
      if (fullNameAr != null && fullNameAr is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: fullNameAr is not a String: ${fullNameAr.runtimeType}');
        throw Exception('Field fullNameAr must be a String or null, got ${fullNameAr.runtimeType}');
      }
      
      // FullNameEn field (optional with JsonKey mapping)
      final fullNameEn = json['full_name_en'] ?? json['fullNameEn'];
      debugPrint('🔍 [USER_DEBUG] fullNameEn: $fullNameEn (${fullNameEn.runtimeType})');
      if (fullNameEn != null && fullNameEn is! String) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: fullNameEn is not a String: ${fullNameEn.runtimeType}');
        throw Exception('Field fullNameEn must be a String or null, got ${fullNameEn.runtimeType}');
      }
      
      // PhoneVerified field (boolean)
      final phoneVerified = json['phoneVerified'];
      debugPrint('🔍 [USER_DEBUG] phoneVerified: $phoneVerified (${phoneVerified.runtimeType})');
      if (phoneVerified != null && phoneVerified is! bool) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: phoneVerified is not a bool: ${phoneVerified.runtimeType}');
        throw Exception('Field phoneVerified must be a bool or null, got ${phoneVerified.runtimeType}');
      }
      
      // Roles field (array)
      final roles = json['roles'];
      debugPrint('🔍 [USER_DEBUG] roles: $roles (${roles.runtimeType})');
      if (roles != null && roles is! List) {
        debugPrint('🔍 [USER_DEBUG] ❌ ERROR: roles is not a List: ${roles.runtimeType}');
        throw Exception('Field roles must be a List or null, got ${roles.runtimeType}');
      }
      if (roles is List) {
        for (int i = 0; i < roles.length; i++) {
          final role = roles[i];
          debugPrint('🔍 [USER_DEBUG] roles[$i]: $role (${role.runtimeType})');
          if (role is! String) {
            debugPrint('🔍 [USER_DEBUG] ❌ ERROR: roles[$i] is not a String: ${role.runtimeType}');
            throw Exception('Field roles[$i] must be a String, got ${role.runtimeType}');
          }
        }
      }
      
      // CreatedAt field (optional datetime)
      final createdAt = json['createdAt'];
      debugPrint('🔍 [USER_DEBUG] createdAt: $createdAt (${createdAt.runtimeType})');
      
      // UpdatedAt field (optional datetime)
      final updatedAt = json['updatedAt'];
      debugPrint('🔍 [USER_DEBUG] updatedAt: $updatedAt (${updatedAt.runtimeType})');
      
      // Profile field (optional object)
      final profile = json['profile'];
      debugPrint('🔍 [USER_DEBUG] profile: $profile (${profile.runtimeType})');
      
      debugPrint('🔍 [USER_DEBUG] ✅ All fields validated successfully');
      debugPrint('🔍 [USER_DEBUG] Attempting to create UserModel with fromJson...');
      
      try {
        // Try to create the UserModel using the generated fromJson
        final userModel = UserModel.fromJson(json);
        debugPrint('🔍 [USER_DEBUG] ✅ UserModel created successfully: ${userModel.id}');
        debugPrint('🔍 [USER_DEBUG] UserModel.phone: ${userModel.phone}');
        debugPrint('🔍 [USER_DEBUG] UserModel.email: ${userModel.email}');
        debugPrint('🔍 [USER_DEBUG] UserModel.phoneVerified: ${userModel.phoneVerified}');
        debugPrint('🔍 [USER_DEBUG] UserModel.roles: ${userModel.roles}');
        debugPrint('🔍 [USER_DEBUG] ========== UserModel.fromJsonSafe SUCCESS ==========');
        return userModel;
      } catch (createError) {
        debugPrint('🔍 [USER_DEBUG] ❌ UserModel.fromJson failed: $createError');
        debugPrint('🔍 [USER_DEBUG] Error type: ${createError.runtimeType}');
        rethrow;
      }
      
    } catch (e, stackTrace) {
      debugPrint('🔍 [USER_DEBUG] ❌❌❌ CRITICAL ERROR in UserModel.fromJsonSafe ❌❌❌');
      debugPrint('🔍 [USER_DEBUG] Error: $e');
      debugPrint('🔍 [USER_DEBUG] Error type: ${e.runtimeType}');
      debugPrint('🔍 [USER_DEBUG] Stack trace: $stackTrace');
      debugPrint('🔍 [USER_DEBUG] ========== UserModel.fromJsonSafe FAILED ==========');
      rethrow;
    }
  }
}

// Type alias for backward compatibility
typedef User = UserModel;

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    required String userId,
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
    required DateTime createdAt,
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
    required String accessToken,
    required String refreshToken,
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
      debugPrint('🔍 [AUTH_DEBUG] ========== AuthResponse.fromJsonSafe START ==========');
      debugPrint('🔍 [AUTH_DEBUG] Input JSON type: ${json.runtimeType}');
      debugPrint('🔍 [AUTH_DEBUG] Input JSON keys: ${json.keys.toList()}');
      debugPrint('🔍 [AUTH_DEBUG] Input JSON: $json');
      
      // Check for tokens structure
      final tokens = json['tokens'];
      debugPrint('🔍 [AUTH_DEBUG] tokens field: $tokens (${tokens.runtimeType})');
      
      String? accessToken;
      String? refreshToken;
      
      if (tokens != null && tokens is Map<String, dynamic>) {
        debugPrint('🔍 [AUTH_DEBUG] Found tokens object, extracting...');
        accessToken = tokens['accessToken'];
        refreshToken = tokens['refreshToken'];
        final expiresIn = tokens['expiresIn'];
        debugPrint('🔍 [AUTH_DEBUG] accessToken from tokens: $accessToken (${accessToken.runtimeType})');
        debugPrint('🔍 [AUTH_DEBUG] refreshToken from tokens: $refreshToken (${refreshToken.runtimeType})');
        debugPrint('🔍 [AUTH_DEBUG] expiresIn from tokens: $expiresIn (${expiresIn.runtimeType})');
      } else {
        debugPrint('🔍 [AUTH_DEBUG] No tokens object found, trying direct access...');
        // Try direct access
        accessToken = json['accessToken'] ?? json['access_token'];
        refreshToken = json['refreshToken'] ?? json['refresh_token'];
        debugPrint('🔍 [AUTH_DEBUG] accessToken direct: $accessToken (${accessToken.runtimeType})');
        debugPrint('🔍 [AUTH_DEBUG] refreshToken direct: $refreshToken (${refreshToken.runtimeType})');
      }
      
      // Validate required fields
      debugPrint('🔍 [AUTH_DEBUG] Validating required fields...');
      if (accessToken == null) {
        debugPrint('🔍 [AUTH_DEBUG] ERROR: accessToken is null');
        throw Exception('Missing required field: accessToken');
      }
      if (refreshToken == null) {
        debugPrint('🔍 [AUTH_DEBUG] ERROR: refreshToken is null');
        throw Exception('Missing required field: refreshToken');
      }
      
      debugPrint('🔍 [AUTH_DEBUG] ✅ Required tokens validated successfully');
      debugPrint('🔍 [AUTH_DEBUG] Final accessToken: $accessToken');
      debugPrint('🔍 [AUTH_DEBUG] Final refreshToken: $refreshToken');
      
      // Check user field
      final userData = json['user'];
      debugPrint('🔍 [AUTH_DEBUG] user field: $userData (${userData.runtimeType})');
      
      UserModel? user;
      if (userData != null && userData is Map<String, dynamic>) {
        debugPrint('🔍 [AUTH_DEBUG] Found user data, attempting to parse...');
        try {
          user = UserModel.fromJsonSafe(userData);
          debugPrint('🔍 [AUTH_DEBUG] ✅ User parsed successfully: ${user.id}');
        } catch (userError) {
          debugPrint('🔍 [AUTH_DEBUG] ❌ User parsing failed: $userError');
          rethrow;
        }
      } else {
        debugPrint('🔍 [AUTH_DEBUG] ⚠️ No user data found or invalid format');
      }
      
      // Check other fields
      final success = json['success'];
      final message = json['message'];
      final token = json['token'] ?? json['access_token'];
      
      debugPrint('🔍 [AUTH_DEBUG] success: $success (${success.runtimeType})');
      debugPrint('🔍 [AUTH_DEBUG] message: $message (${message.runtimeType})');
      debugPrint('🔍 [AUTH_DEBUG] token: $token (${token.runtimeType})');
      
      // Create modified JSON for AuthResponse.fromJson
      final modifiedJson = {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'user': userData,
        'success': success ?? true,
        'message': message,
        'token': token,
      };
      
      debugPrint('🔍 [AUTH_DEBUG] Modified JSON for AuthResponse: $modifiedJson');
      debugPrint('🔍 [AUTH_DEBUG] Attempting to create AuthResponse with fromJson...');
      
      try {
        final authResponse = AuthResponse.fromJson(modifiedJson);
        debugPrint('🔍 [AUTH_DEBUG] ✅ AuthResponse created successfully');
        debugPrint('🔍 [AUTH_DEBUG] AuthResponse.accessToken: ${authResponse.accessToken}');
        debugPrint('🔍 [AUTH_DEBUG] AuthResponse.refreshToken: ${authResponse.refreshToken}');
        debugPrint('🔍 [AUTH_DEBUG] AuthResponse.user: ${authResponse.user?.id}');
        debugPrint('🔍 [AUTH_DEBUG] AuthResponse.success: ${authResponse.success}');
        debugPrint('🔍 [AUTH_DEBUG] ========== AuthResponse.fromJsonSafe SUCCESS ==========');
        return authResponse;
      } catch (createError) {
        debugPrint('🔍 [AUTH_DEBUG] ❌ AuthResponse.fromJson failed: $createError');
        debugPrint('🔍 [AUTH_DEBUG] Error type: ${createError.runtimeType}');
        rethrow;
      }
      
    } catch (e, stackTrace) {
      debugPrint('🔍 [AUTH_DEBUG] ❌❌❌ CRITICAL ERROR in AuthResponse.fromJsonSafe ❌❌❌');
      debugPrint('🔍 [AUTH_DEBUG] Error: $e');
      debugPrint('🔍 [AUTH_DEBUG] Error type: ${e.runtimeType}');
      debugPrint('🔍 [AUTH_DEBUG] Stack trace: $stackTrace');
      debugPrint('🔍 [AUTH_DEBUG] ========== AuthResponse.fromJsonSafe FAILED ==========');
      rethrow;
    }
  }
}

@freezed
class OtpRequest with _$OtpRequest {
  const factory OtpRequest({
    required String email,
    required String channel, // 'email' or 'sms'
  }) = _OtpRequest;

  factory OtpRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestFromJson(json);
}

@freezed
class OtpVerifyRequest with _$OtpVerifyRequest {
  const factory OtpVerifyRequest({
    required String email,
    required String code,
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
