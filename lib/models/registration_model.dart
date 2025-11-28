import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_model.freezed.dart';
part 'registration_model.g.dart';

class DecimalConverter implements JsonConverter<double, dynamic> {
  const DecimalConverter();

  @override
  double fromJson(dynamic json) {
    if (json is num) {
      return json.toDouble();
    } else if (json is String) {
      return double.parse(json);
    }
    return 0.0;
  }

  @override
  dynamic toJson(double object) => object;
}

@freezed
class RegistrationModel with _$RegistrationModel {
  const factory RegistrationModel({
    required String id,
    required String userId,
    @JsonKey(name: 'registrationType')
    required String registrationType, // 'CONFERENCE' or 'EVENT'
    @JsonKey(name: 'eventId') String? eventId,
    @JsonKey(name: 'conferenceId') String? conferenceId,
    required String status, // UNDER_REVIEW, ACCEPTED, PAYMENT_PENDING, etc.
    @DecimalConverter() @JsonKey(name: 'calculatedPrice') required double calculatedPrice,
    @JsonKey(name: 'currency') String? currency,
    @JsonKey(name: 'appliedRuleSet') String? appliedRuleSet,
    @JsonKey(name: 'paymentDeadline') DateTime? paymentDeadline,
    @JsonKey(name: 'onHoldReason') String? onHoldReason,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    // Relations
    @JsonKey(name: 'event') Map<String, dynamic>? event,
    @JsonKey(name: 'conference') Map<String, dynamic>? conference,
    @JsonKey(name: 'user') Map<String, dynamic>? user,
  }) = _RegistrationModel;

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationModelFromJson(json);
}

extension RegistrationModelExtensions on RegistrationModel {
  String get entityTitle {
    if (registrationType == 'CONFERENCE') {
      return conference?['nameAr'] ?? conference?['nameEn'] ?? 'مؤتمر';
    } else {
      return event?['title'] ?? event?['nameAr'] ?? 'فعالية';
    }
  }

  bool get isConference => registrationType == 'CONFERENCE';
  bool get isEvent => registrationType == 'EVENT';

  bool get isUnderReview => status == 'UNDER_REVIEW';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isPaymentPending => status == 'PAYMENT_PENDING';
  bool get isActiveParticipant => status == 'ACTIVE_PARTICIPANT';
  bool get isRejected => status == 'REJECTED';
  bool get isOnHold => status == 'ON_HOLD';
}










