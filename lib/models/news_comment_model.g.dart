// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsCommentModelImpl _$$NewsCommentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NewsCommentModelImpl(
      id: json['id'] as String,
      articleId: json['articleId'] as String,
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String,
      authorEmail: json['authorEmail'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      parentId: json['parentId'] as String?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => NewsCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NewsCommentModelImplToJson(
        _$NewsCommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'articleId': instance.articleId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorEmail': instance.authorEmail,
      'content': instance.content,
      'status': instance.status,
      'parentId': instance.parentId,
      'replies': instance.replies,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
