// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeakerModelImpl _$$SpeakerModelImplFromJson(Map<String, dynamic> json) =>
    _$SpeakerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      photoUrl: json['photoUrl'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      organization: json['organization'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      count: json['_count'] as Map<String, dynamic>?,
      eventsCount: (json['eventsCount'] as num?)?.toInt(),
      sessionsCount: (json['sessionsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SpeakerModelImplToJson(_$SpeakerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'title': instance.title,
      'bio': instance.bio,
      'photoUrl': instance.photoUrl,
      'email': instance.email,
      'phone': instance.phone,
      'organization': instance.organization,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      '_count': instance.count,
      'eventsCount': instance.eventsCount,
      'sessionsCount': instance.sessionsCount,
    };
