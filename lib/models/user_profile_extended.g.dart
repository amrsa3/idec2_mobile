// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_extended.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileExtendedImpl _$$UserProfileExtendedImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileExtendedImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullNameAr: json['fullNameAr'] as String?,
      fullNameEn: json['fullNameEn'] as String?,
      email: json['email'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      governorateId: json['governorateId'] as String?,
      qualificationId: json['qualificationId'] as String?,
      graduationYear: (json['graduationYear'] as num?)?.toInt(),
      university: json['university'] as String?,
      workplace: json['workplace'] as String?,
      status: $enumDecodeNullable(_$ProfileStatusEnumMap, json['status']) ??
          ProfileStatus.unverified,
      rejectionReason: json['rejectionReason'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      profilePictureFileId: json['profilePictureFileId'] as String?,
      documentUrls: (json['documentUrls'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      documentFileIds: (json['documentFileIds'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      pendingChanges:
          json['pendingChanges'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileExtendedImplToJson(
        _$UserProfileExtendedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullNameAr': instance.fullNameAr,
      'fullNameEn': instance.fullNameEn,
      'email': instance.email,
      'birthDate': instance.birthDate?.toIso8601String(),
      'governorateId': instance.governorateId,
      'qualificationId': instance.qualificationId,
      'graduationYear': instance.graduationYear,
      'university': instance.university,
      'workplace': instance.workplace,
      'status': _$ProfileStatusEnumMap[instance.status]!,
      'rejectionReason': instance.rejectionReason,
      'profilePictureUrl': instance.profilePictureUrl,
      'profilePictureFileId': instance.profilePictureFileId,
      'documentUrls': instance.documentUrls,
      'documentFileIds': instance.documentFileIds,
      'pendingChanges': instance.pendingChanges,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };

const _$ProfileStatusEnumMap = {
  ProfileStatus.unverified: 'UNVERIFIED',
  ProfileStatus.pendingVerification: 'PENDING_VERIFICATION',
  ProfileStatus.verified: 'VERIFIED',
  ProfileStatus.rejected: 'REJECTED',
};
