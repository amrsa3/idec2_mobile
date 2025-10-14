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
      profile: json['profile'] == null
          ? null
          : UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'email': instance.email,
      'phoneVerified': instance.phoneVerified,
      'roles': instance.roles,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'profile': instance.profile,
    };

_$UserProfileModelImpl _$$UserProfileModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileModelImpl(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      fullNameAr: json['full_name_ar'] as String? ?? '',
      fullNameEn: json['full_name_en'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      graduationYear: (json['graduation_year'] as num?)?.toInt(),
      university: json['university'] as String?,
      workplace: json['workplace'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      jobTitle: json['job_title'] as String?,
      specialization: json['specialization'] as String?,
      academicDegree: json['academic_degree'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      profileData: json['profile_data'] as Map<String, dynamic>?,
      status: json['status'] as String?,
      categoryId: json['category_id'] as String?,
      qualificationId: json['qualification_id'] as String?,
      governorateId: json['governorate_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserProfileModelImplToJson(
        _$UserProfileModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'full_name_ar': instance.fullNameAr,
      'full_name_en': instance.fullNameEn,
      'birth_date': instance.birthDate?.toIso8601String(),
      'graduation_year': instance.graduationYear,
      'university': instance.university,
      'workplace': instance.workplace,
      'gender': instance.gender,
      'address': instance.address,
      'job_title': instance.jobTitle,
      'specialization': instance.specialization,
      'academic_degree': instance.academicDegree,
      'profile_photo_url': instance.profilePhotoUrl,
      'profile_data': instance.profileData,
      'status': instance.status,
      'category_id': instance.categoryId,
      'qualification_id': instance.qualificationId,
      'governorate_id': instance.governorateId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
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
    );

Map<String, dynamic> _$$OtpRequestImplToJson(_$OtpRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
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
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$$PasswordResetResponseImplToJson(
        _$PasswordResetResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'phoneNumber': instance.phoneNumber,
    };
