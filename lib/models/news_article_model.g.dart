// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsArticleModelImpl _$$NewsArticleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NewsArticleModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String?,
      content: json['content'] as String,
      contentAr: json['contentAr'] as String?,
      summary: json['summary'] as String?,
      summaryAr: json['summaryAr'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isBreaking: json['isBreaking'] as bool? ?? false,
      featuredImage: json['featuredImage'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      seoTitle: json['seoTitle'] as String?,
      seoDescription: json['seoDescription'] as String?,
      seoKeywords: (json['seoKeywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      category:
          NewsCategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      categoryId: json['categoryId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String?,
      targetType: json['targetType'] as String?,
      targetId: json['targetId'] as String?,
      isCommercial: json['isCommercial'] as bool? ?? false,
      commercialCost: (json['commercialCost'] as num?)?.toDouble(),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      views: (json['views'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      allowComments: json['allowComments'] as bool? ?? true,
      hideComments: json['hideComments'] as bool? ?? false,
      autoApproveComments: json['autoApproveComments'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      isLiked: json['isLiked'] as bool?,
      isBookmarked: json['isBookmarked'] as bool?,
    );

Map<String, dynamic> _$$NewsArticleModelImplToJson(
        _$NewsArticleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'titleAr': instance.titleAr,
      'content': instance.content,
      'contentAr': instance.contentAr,
      'summary': instance.summary,
      'summaryAr': instance.summaryAr,
      'status': instance.status,
      'priority': instance.priority,
      'isFeatured': instance.isFeatured,
      'isBreaking': instance.isBreaking,
      'featuredImage': instance.featuredImage,
      'images': instance.images,
      'seoTitle': instance.seoTitle,
      'seoDescription': instance.seoDescription,
      'seoKeywords': instance.seoKeywords,
      'category': instance.category,
      'categoryId': instance.categoryId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'targetType': instance.targetType,
      'targetId': instance.targetId,
      'isCommercial': instance.isCommercial,
      'commercialCost': instance.commercialCost,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'views': instance.views,
      'likes': instance.likes,
      'commentsCount': instance.commentsCount,
      'shares': instance.shares,
      'tags': instance.tags,
      'allowComments': instance.allowComments,
      'hideComments': instance.hideComments,
      'autoApproveComments': instance.autoApproveComments,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isLiked': instance.isLiked,
      'isBookmarked': instance.isBookmarked,
    };
