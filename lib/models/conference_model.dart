import 'package:freezed_annotation/freezed_annotation.dart';

part 'conference_model.freezed.dart';
part 'conference_model.g.dart';

@freezed
class ConferenceModel with _$ConferenceModel {
  const factory ConferenceModel({
    required String id,
    required String nameAr,
    String? nameEn,
    required int year,
    String? descriptionAr,
    String? descriptionEn,
    required DateTime startDate,
    required DateTime endDate,
    String? location,
    String? logoUrl,
    String? bannerUrl,
    required bool isActive,
    required String status,
    String? processingMechanism,
    String? submissionPolicy,
    bool? showTimeRemaining,
    bool? watchModeEnabled,
    DateTime? registrationStartDate,
    DateTime? registrationEndDate,
    bool? registrationShowCount,
    String? defaultCurrency,
    bool? paymentDeadlineEnabled,
    int? paymentDeadlineDays,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? eventsCount,
    int? sessionsCount,
    int? sponsorsCount,
  }) = _ConferenceModel;

  factory ConferenceModel.fromJson(Map<String, dynamic> json) =>
      _$ConferenceModelFromJson(json);
}
