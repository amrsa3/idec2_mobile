import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_category_model.freezed.dart';
part 'news_category_model.g.dart';

@freezed
class NewsCategoryModel with _$NewsCategoryModel {
  const factory NewsCategoryModel({
    required String id,
    required String name,
    @JsonKey(name: 'nameAr') String? nameAr,
    String? description,
    @JsonKey(name: 'descriptionAr') String? descriptionAr,
    @Default('#1890ff') String color,
    String? icon,
    @JsonKey(name: 'parentId') String? parentId,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    @JsonKey(name: 'sortOrder') @Default(0) int sortOrder,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _NewsCategoryModel;

  factory NewsCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$NewsCategoryModelFromJson(json);
}

extension NewsCategoryModelExtensions on NewsCategoryModel {
  String get displayName {
    // Use Arabic name if available, otherwise English
    return nameAr ?? name;
  }

  String get displayDescription {
    // Use Arabic description if available, otherwise English
    return descriptionAr ?? description ?? '';
  }
}

