// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsCategoryModelImpl _$$NewsCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NewsCategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      color: json['color'] as String? ?? '#1890ff',
      icon: json['icon'] as String?,
      parentId: json['parentId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NewsCategoryModelImplToJson(
        _$NewsCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameAr': instance.nameAr,
      'description': instance.description,
      'descriptionAr': instance.descriptionAr,
      'color': instance.color,
      'icon': instance.icon,
      'parentId': instance.parentId,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
