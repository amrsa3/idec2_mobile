// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: json['id'] as String,
      conferenceId: json['conferenceId'] as String,
      type: json['type'] as String,
      category: json['category'] as String?,
      categoryId: json['categoryId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      duration: (json['duration'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      status: json['status'] as String?,
      instructorId: json['instructorId'] as String?,
      requirements: json['requirements'] as String?,
      courseDetails: json['courseDetails'] as String?,
      courseLevel: json['courseLevel'] as String?,
      promotionalImages: (json['promotionalImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      promotionalVideo: json['promotionalVideo'] as String?,
      certificate: json['certificate'] as bool? ?? false,
      notes: json['notes'] as String?,
      subscriptionPolicy: json['subscriptionPolicy'] as String?,
      processingMechanism: json['processingMechanism'] as String?,
      submissionPolicy: json['submissionPolicy'] as String?,
      paymentDeadlineEnabled: json['paymentDeadlineEnabled'] as bool? ?? false,
      paymentDeadlineDays: (json['paymentDeadlineDays'] as num?)?.toInt(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      subscriptionRules: json['subscriptionRules'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      conference: json['conference'] as Map<String, dynamic>?,
      instructor: json['instructor'] as Map<String, dynamic>?,
      speakers: (json['speakers'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      count: json['_count'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conferenceId': instance.conferenceId,
      'type': instance.type,
      'category': instance.category,
      'categoryId': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'duration': instance.duration,
      'price': instance.price,
      'currency': instance.currency,
      'capacity': instance.capacity,
      'isActive': instance.isActive,
      'status': instance.status,
      'instructorId': instance.instructorId,
      'requirements': instance.requirements,
      'courseDetails': instance.courseDetails,
      'courseLevel': instance.courseLevel,
      'promotionalImages': instance.promotionalImages,
      'promotionalVideo': instance.promotionalVideo,
      'certificate': instance.certificate,
      'notes': instance.notes,
      'subscriptionPolicy': instance.subscriptionPolicy,
      'processingMechanism': instance.processingMechanism,
      'submissionPolicy': instance.submissionPolicy,
      'paymentDeadlineEnabled': instance.paymentDeadlineEnabled,
      'paymentDeadlineDays': instance.paymentDeadlineDays,
      'paymentMethods': instance.paymentMethods,
      'subscriptionRules': instance.subscriptionRules,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'conference': instance.conference,
      'instructor': instance.instructor,
      'speakers': instance.speakers,
      '_count': instance.count,
    };
