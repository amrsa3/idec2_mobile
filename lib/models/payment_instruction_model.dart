import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_instruction_model.freezed.dart';
part 'payment_instruction_model.g.dart';

@freezed
class PaymentInstructionModel with _$PaymentInstructionModel {
  const factory PaymentInstructionModel({
    required String type, // REDIRECT or INPUT_REQUIRED
    @JsonKey(name: 'data') required PaymentInstructionDataModel data,
  }) = _PaymentInstructionModel;

  factory PaymentInstructionModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInstructionModelFromJson(json);
}

@freezed
class PaymentInstructionDataModel with _$PaymentInstructionDataModel {
  const factory PaymentInstructionDataModel({
    String? url, // For REDIRECT type
    List<PaymentFieldModel>? fields, // For INPUT_REQUIRED type
  }) = _PaymentInstructionDataModel;

  factory PaymentInstructionDataModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInstructionDataModelFromJson(json);
}

@freezed
class PaymentFieldModel with _$PaymentFieldModel {
  const factory PaymentFieldModel({
    required String name,
    required String label,
    String? type, // text, number, password
    String? placeholder,
    @Default(false) bool required,
  }) = _PaymentFieldModel;

  factory PaymentFieldModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentFieldModelFromJson(json);
}

extension PaymentInstructionModelExtensions on PaymentInstructionModel {
  bool get requiresInput => type == 'INPUT_REQUIRED';
  bool get requiresRedirect => type == 'REDIRECT';
}

