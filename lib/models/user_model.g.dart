// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      fullNameAr: json['full_name_ar'] as String? ?? '',
      fullNameEn: json['full_name_en'] as String?,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      profilePicture: json['profilePicture'] as String?,
      isVerified: json['isVerified'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      profile: json['profile'] == null
          ? null
          : UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'full_name_ar': instance.fullNameAr,
      'full_name_en': instance.fullNameEn,
      'phoneVerified': instance.phoneVerified,
      'roles': instance.roles,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'profilePictureUrl': instance.profilePictureUrl,
      'profilePicture': instance.profilePicture,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'isEmailVerified': instance.isEmailVerified,
      'profile': instance.profile,
    };

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String?,
      specialization: json['specialization'] as String?,
      workPlace: json['workPlace'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      telegramNumber: json['telegramNumber'] as String?,
      linkedinProfile: json['linkedinProfile'] as String?,
      facebookProfile: json['facebookProfile'] as String?,
      instagramProfile: json['instagramProfile'] as String?,
      twitterProfile: json['twitterProfile'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String?,
      nationality: json['nationality'] as String?,
      passportNumber: json['passportNumber'] as String?,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactPhone: json['emergencyContactPhone'] as String?,
      emergencyContactRelation: json['emergencyContactRelation'] as String?,
      dietaryRestrictions: json['dietaryRestrictions'] as String?,
      medicalConditions: json['medicalConditions'] as String?,
      accommodationPreferences: json['accommodationPreferences'] as String?,
      transportationNeeds: json['transportationNeeds'] as String?,
      languagePreference: json['languagePreference'] as String?,
      marketingConsent: json['marketingConsent'] as bool?,
      dataProcessingConsent: json['dataProcessingConsent'] as bool?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'specialization': instance.specialization,
      'workPlace': instance.workPlace,
      'country': instance.country,
      'city': instance.city,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'whatsappNumber': instance.whatsappNumber,
      'telegramNumber': instance.telegramNumber,
      'linkedinProfile': instance.linkedinProfile,
      'facebookProfile': instance.facebookProfile,
      'instagramProfile': instance.instagramProfile,
      'twitterProfile': instance.twitterProfile,
      'websiteUrl': instance.websiteUrl,
      'bio': instance.bio,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'nationality': instance.nationality,
      'passportNumber': instance.passportNumber,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactPhone': instance.emergencyContactPhone,
      'emergencyContactRelation': instance.emergencyContactRelation,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'medicalConditions': instance.medicalConditions,
      'accommodationPreferences': instance.accommodationPreferences,
      'transportationNeeds': instance.transportationNeeds,
      'languagePreference': instance.languagePreference,
      'marketingConsent': instance.marketingConsent,
      'dataProcessingConsent': instance.dataProcessingConsent,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      phone: json['phone'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      phone: json['phone'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'name': instance.name,
      'email': instance.email,
    };

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'success': instance.success,
      'message': instance.message,
      'token': instance.token,
    };

_$OtpRequestImpl _$$OtpRequestImplFromJson(Map<String, dynamic> json) =>
    _$OtpRequestImpl(
      phone: json['phone'] as String,
      channel: json['channel'] as String,
    );

Map<String, dynamic> _$$OtpRequestImplToJson(_$OtpRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'channel': instance.channel,
    };

_$OtpVerifyRequestImpl _$$OtpVerifyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpVerifyRequestImpl(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$$OtpVerifyRequestImplToJson(
        _$OtpVerifyRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
    };

_$ProfileStatusModelImpl _$$ProfileStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileStatusModelImpl(
      status: json['status'] as String,
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      pendingRequests: (json['pendingRequests'] as List<dynamic>)
          .map((e) =>
              VerificationRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      documents: (json['documents'] as List<dynamic>)
          .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProfileStatusModelImplToJson(
        _$ProfileStatusModelImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'completionPercentage': instance.completionPercentage,
      'user': instance.user,
      'pendingRequests': instance.pendingRequests,
      'documents': instance.documents,
    };

_$DocumentModelImpl _$$DocumentModelImplFromJson(Map<String, dynamic> json) =>
    _$DocumentModelImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      status: json['status'] as String,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$$DocumentModelImplToJson(_$DocumentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'url': instance.url,
      'status': instance.status,
      'uploadedAt': instance.uploadedAt?.toIso8601String(),
    };

_$RequestPasswordResetRequestImpl _$$RequestPasswordResetRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestPasswordResetRequestImpl(
      phone: json['phone'] as String,
      preferredChannel: json['preferredChannel'] as String?,
    );

Map<String, dynamic> _$$RequestPasswordResetRequestImplToJson(
        _$RequestPasswordResetRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'preferredChannel': instance.preferredChannel,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestImpl(
      phone: json['phone'] as String,
      otp: json['otp'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
        _$ResetPasswordRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
      'newPassword': instance.newPassword,
    };

_$PasswordResetResponseImpl _$$PasswordResetResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PasswordResetResponseImpl(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String?,
      availableChannels: (json['availableChannels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      selectedChannel: json['selectedChannel'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      requiresChannelSelection:
          json['requiresChannelSelection'] as bool? ?? false,
      purpose: json['purpose'] as String?,
    );

Map<String, dynamic> _$$PasswordResetResponseImplToJson(
        _$PasswordResetResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'availableChannels': instance.availableChannels,
      'selectedChannel': instance.selectedChannel,
      'phoneNumber': instance.phoneNumber,
      'requiresChannelSelection': instance.requiresChannelSelection,
      'purpose': instance.purpose,
    };
