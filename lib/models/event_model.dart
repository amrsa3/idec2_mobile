import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

class CategoryConverter implements JsonConverter<String?, dynamic> {
  const CategoryConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is Map<String, dynamic>) {
      // It's a CourseCategory object, extract name
      return json['nameAr'] as String? ?? json['nameEn'] as String?;
    }
    return null;
  }

  @override
  dynamic toJson(String? object) => object;
}

class SubscriptionRulesConverter implements JsonConverter<String?, dynamic> {
  const SubscriptionRulesConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    // If it's an object or array, convert to JSON string
    try {
      return jsonEncode(json);
    } catch (e) {
      return null;
    }
  }

  @override
  dynamic toJson(String? object) => object;
}

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    @JsonKey(name: 'conferenceId') required String conferenceId,
    required String type, // 'COURSE' | 'WORKSHOP' | 'SEMINAR'
    @CategoryConverter() String? category,
    @JsonKey(name: 'categoryId') String? categoryId,
    required String title,
    String? description,
    String? location,
    @JsonKey(name: 'startTime') required DateTime startTime,
    @JsonKey(name: 'endTime') required DateTime endTime,
    double? duration,
    double? price,
    String? currency,
    int? capacity,
    @JsonKey(name: 'isActive') @Default(true) bool? isActive,
    String? status,
    @JsonKey(name: 'instructorId') String? instructorId,
    String? requirements,
    @JsonKey(name: 'courseDetails') String? courseDetails,
    @JsonKey(name: 'courseLevel') String? courseLevel,
    @JsonKey(name: 'promotionalImages') List<String>? promotionalImages,
    @JsonKey(name: 'promotionalVideo') String? promotionalVideo,
    @Default(false) bool? certificate,
    String? notes,
    @JsonKey(name: 'subscriptionPolicy') String? subscriptionPolicy,
    @JsonKey(name: 'processingMechanism') String? processingMechanism,
    @JsonKey(name: 'submissionPolicy') String? submissionPolicy,
    @JsonKey(name: 'paymentDeadlineEnabled') @Default(false) bool? paymentDeadlineEnabled,
    @JsonKey(name: 'paymentDeadlineDays') int? paymentDeadlineDays,
    @JsonKey(name: 'paymentMethods') List<String>? paymentMethods,
    @JsonKey(name: 'subscriptionRules') @SubscriptionRulesConverter() String? subscriptionRules,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    // Relations
    Map<String, dynamic>? conference,
    Map<String, dynamic>? instructor,
    @JsonKey(name: 'speakers') List<Map<String, dynamic>>? speakers,
    @JsonKey(name: '_count') Map<String, dynamic>? count,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

extension EventModelExtensions on EventModel {
  String get formattedDate {
    // Convert to local time if needed
    final date = startTime.isUtc ? startTime.toLocal() : startTime;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    // Convert to local time for display
    final start = startTime.isUtc ? startTime.toLocal() : startTime;
    final end = endTime.isUtc ? endTime.toLocal() : endTime;
    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }
  
  // Helper to get local start time
  DateTime get localStartTime {
    return startTime.isUtc ? startTime.toLocal() : startTime;
  }
  
  // Helper to get local end time
  DateTime get localEndTime {
    return endTime.isUtc ? endTime.toLocal() : endTime;
  }

  String get typeLabel {
    switch (type) {
      case 'COURSE':
        return 'دورة';
      case 'WORKSHOP':
        return 'ورشة عمل';
      case 'SEMINAR':
        return 'ندوة';
      default:
        return type;
    }
  }

  String? get firstPromotionalImage {
    if (promotionalImages != null && promotionalImages!.isNotEmpty) {
      return promotionalImages!.first;
    }
    return null;
  }

  int get speakersCount {
    if (speakers != null) {
      return speakers!.length;
    }
    if (count != null && count!['eventSpeakers'] != null) {
      return count!['eventSpeakers'] as int;
    }
    return 0;
  }

  int get registrationsCount {
    if (count != null && count!['registrations'] != null) {
      return count!['registrations'] as int;
    }
    return 0;
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool get isCompleted {
    return endTime.isBefore(DateTime.now());
  }
}

