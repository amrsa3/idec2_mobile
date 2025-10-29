import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_status_model.freezed.dart';
part 'registration_status_model.g.dart';

@freezed
class RegistrationStatusModel with _$RegistrationStatusModel {
  const factory RegistrationStatusModel({
    required String id,
    required String status,
    required String calculatedPrice,
    String? currency,
    required DateTime registrationDate,
    DateTime? paymentDeadline,
  }) = _RegistrationStatusModel;

  factory RegistrationStatusModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationStatusModelFromJson(json);
}
