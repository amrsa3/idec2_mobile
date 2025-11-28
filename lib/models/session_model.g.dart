// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionModelImpl _$$SessionModelImplFromJson(Map<String, dynamic> json) =>
    _$SessionModelImpl(
      id: json['id'] as String,
      conferenceId: json['conferenceId'] as String,
      eventId: json['eventId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      conference: json['conference'] as Map<String, dynamic>?,
      event: json['event'] as Map<String, dynamic>?,
      count: json['_count'] as Map<String, dynamic>?,
      speakersCount: (json['speakersCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SessionModelImplToJson(_$SessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conferenceId': instance.conferenceId,
      'eventId': instance.eventId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
      'capacity': instance.capacity,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'conference': instance.conference,
      'event': instance.event,
      '_count': instance.count,
      'speakersCount': instance.speakersCount,
    };
