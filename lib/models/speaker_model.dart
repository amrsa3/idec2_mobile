import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaker_model.freezed.dart';
part 'speaker_model.g.dart';

@freezed
class SpeakerModel with _$SpeakerModel {
  const factory SpeakerModel({
    required String id,
    required String name,
    String? title,
    String? bio,
    @JsonKey(name: 'photoUrl') String? photoUrl,
    String? email,
    String? phone,
    String? organization,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    @JsonKey(name: '_count') Map<String, dynamic>? count,
    @JsonKey(name: 'eventsCount') int? eventsCount,
    @JsonKey(name: 'sessionsCount') int? sessionsCount,
  }) = _SpeakerModel;

  factory SpeakerModel.fromJson(Map<String, dynamic> json) =>
      _$SpeakerModelFromJson(json);
}

extension SpeakerModelExtensions on SpeakerModel {
  String get displayName {
    if (title != null && title!.isNotEmpty) {
      return '$title $name';
    }
    return name;
  }

  int get eventsCountValue {
    // Try direct eventsCount first (from backend)
    if (eventsCount != null) {
      return eventsCount!;
    }
    // Fallback to _count object
    if (count != null && count!['eventSpeakers'] != null) {
      return count!['eventSpeakers'] as int;
    }
    return 0;
  }

  int get sessionsCountValue {
    // Try direct sessionsCount first (from backend)
    if (sessionsCount != null) {
      return sessionsCount!;
    }
    // Fallback to _count object
    if (count != null && count!['sessionSpeakers'] != null) {
      return count!['sessionSpeakers'] as int;
    }
    return 0;
  }

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;
}

