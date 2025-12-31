// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConferenceModelImpl _$$ConferenceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConferenceModelImpl(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String?,
      year: (json['year'] as num).toInt(),
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      location: json['location'] as String?,
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      isActive: json['isActive'] as bool,
      status: json['status'] as String,
      processingMechanism: json['processingMechanism'] as String?,
      submissionPolicy: json['submissionPolicy'] as String?,
      showTimeRemaining: json['showTimeRemaining'] as bool?,
      watchModeEnabled: json['watchModeEnabled'] as bool?,
      registrationStartDate: json['registrationStartDate'] == null
          ? null
          : DateTime.parse(json['registrationStartDate'] as String),
      registrationEndDate: json['registrationEndDate'] == null
          ? null
          : DateTime.parse(json['registrationEndDate'] as String),
      registrationShowCount: json['registrationShowCount'] as bool?,
      defaultCurrency: json['defaultCurrency'] as String?,
      paymentDeadlineEnabled: json['paymentDeadlineEnabled'] as bool?,
      paymentDeadlineDays: (json['paymentDeadlineDays'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      eventsCount: (json['eventsCount'] as num?)?.toInt(),
      sessionsCount: (json['sessionsCount'] as num?)?.toInt(),
      sponsorsCount: (json['sponsorsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ConferenceModelImplToJson(
        _$ConferenceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'year': instance.year,
      'descriptionAr': instance.descriptionAr,
      'descriptionEn': instance.descriptionEn,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'location': instance.location,
      'logoUrl': instance.logoUrl,
      'bannerUrl': instance.bannerUrl,
      'isActive': instance.isActive,
      'status': instance.status,
      'processingMechanism': instance.processingMechanism,
      'submissionPolicy': instance.submissionPolicy,
      'showTimeRemaining': instance.showTimeRemaining,
      'watchModeEnabled': instance.watchModeEnabled,
      'registrationStartDate':
          instance.registrationStartDate?.toIso8601String(),
      'registrationEndDate': instance.registrationEndDate?.toIso8601String(),
      'registrationShowCount': instance.registrationShowCount,
      'defaultCurrency': instance.defaultCurrency,
      'paymentDeadlineEnabled': instance.paymentDeadlineEnabled,
      'paymentDeadlineDays': instance.paymentDeadlineDays,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'eventsCount': instance.eventsCount,
      'sessionsCount': instance.sessionsCount,
      'sponsorsCount': instance.sponsorsCount,
    };
