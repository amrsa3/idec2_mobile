import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    @JsonKey(name: 'conferenceId') required String conferenceId,
    @JsonKey(name: 'eventId') String? eventId,
    required String title,
    String? description,
    @JsonKey(name: 'startTime') required DateTime startTime,
    @JsonKey(name: 'endTime') required DateTime endTime,
    String? location,
    int? capacity,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    // Relations
    Map<String, dynamic>? conference,
    Map<String, dynamic>? event,
    @JsonKey(name: '_count') Map<String, dynamic>? count,
    @JsonKey(name: 'speakersCount') int? speakersCount,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

extension SessionModelExtensions on SessionModel {
  String get formattedDate {
    final date = startTime;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedTime {
    final start = startTime;
    final end = endTime;
    return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
  }

  int get speakersCountValue {
    if (speakersCount != null) {
      return speakersCount!;
    }
    if (count != null && count!['sessionSpeakers'] != null) {
      return count!['sessionSpeakers'] as int;
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

