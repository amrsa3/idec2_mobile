import 'package:freezed_annotation/freezed_annotation.dart';

part 'governorate_model.freezed.dart';
part 'governorate_model.g.dart';

@freezed
class GovernorateModel with _$GovernorateModel {
  const factory GovernorateModel({
    required String id,
    String? name,
    required String nameAr,
  }) = _GovernorateModel;

  factory GovernorateModel.fromJson(Map<String, dynamic> json) =>
      _$GovernorateModelFromJson(json);
}
