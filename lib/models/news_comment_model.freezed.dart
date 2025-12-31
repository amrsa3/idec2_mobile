// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsCommentModel _$NewsCommentModelFromJson(Map<String, dynamic> json) {
  return _NewsCommentModel.fromJson(json);
}

/// @nodoc
mixin _$NewsCommentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'articleId')
  String get articleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'authorId')
  String? get authorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'authorName')
  String get authorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'authorEmail')
  String get authorEmail => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'PENDING' | 'APPROVED' | 'REJECTED' | 'SPAM'
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;
  List<NewsCommentModel>? get replies => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewsCommentModelCopyWith<NewsCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsCommentModelCopyWith<$Res> {
  factory $NewsCommentModelCopyWith(
          NewsCommentModel value, $Res Function(NewsCommentModel) then) =
      _$NewsCommentModelCopyWithImpl<$Res, NewsCommentModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'articleId') String articleId,
      @JsonKey(name: 'authorId') String? authorId,
      @JsonKey(name: 'authorName') String authorName,
      @JsonKey(name: 'authorEmail') String authorEmail,
      String content,
      String status,
      @JsonKey(name: 'parentId') String? parentId,
      List<NewsCommentModel>? replies,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class _$NewsCommentModelCopyWithImpl<$Res, $Val extends NewsCommentModel>
    implements $NewsCommentModelCopyWith<$Res> {
  _$NewsCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? articleId = null,
    Object? authorId = freezed,
    Object? authorName = null,
    Object? authorEmail = null,
    Object? content = null,
    Object? status = null,
    Object? parentId = freezed,
    Object? replies = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      articleId: null == articleId
          ? _value.articleId
          : articleId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: freezed == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String?,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorEmail: null == authorEmail
          ? _value.authorEmail
          : authorEmail // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      replies: freezed == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<NewsCommentModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsCommentModelImplCopyWith<$Res>
    implements $NewsCommentModelCopyWith<$Res> {
  factory _$$NewsCommentModelImplCopyWith(_$NewsCommentModelImpl value,
          $Res Function(_$NewsCommentModelImpl) then) =
      __$$NewsCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'articleId') String articleId,
      @JsonKey(name: 'authorId') String? authorId,
      @JsonKey(name: 'authorName') String authorName,
      @JsonKey(name: 'authorEmail') String authorEmail,
      String content,
      String status,
      @JsonKey(name: 'parentId') String? parentId,
      List<NewsCommentModel>? replies,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt});
}

/// @nodoc
class __$$NewsCommentModelImplCopyWithImpl<$Res>
    extends _$NewsCommentModelCopyWithImpl<$Res, _$NewsCommentModelImpl>
    implements _$$NewsCommentModelImplCopyWith<$Res> {
  __$$NewsCommentModelImplCopyWithImpl(_$NewsCommentModelImpl _value,
      $Res Function(_$NewsCommentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? articleId = null,
    Object? authorId = freezed,
    Object? authorName = null,
    Object? authorEmail = null,
    Object? content = null,
    Object? status = null,
    Object? parentId = freezed,
    Object? replies = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NewsCommentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      articleId: null == articleId
          ? _value.articleId
          : articleId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: freezed == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String?,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorEmail: null == authorEmail
          ? _value.authorEmail
          : authorEmail // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      replies: freezed == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<NewsCommentModel>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsCommentModelImpl implements _NewsCommentModel {
  const _$NewsCommentModelImpl(
      {required this.id,
      @JsonKey(name: 'articleId') required this.articleId,
      @JsonKey(name: 'authorId') this.authorId,
      @JsonKey(name: 'authorName') required this.authorName,
      @JsonKey(name: 'authorEmail') required this.authorEmail,
      required this.content,
      required this.status,
      @JsonKey(name: 'parentId') this.parentId,
      final List<NewsCommentModel>? replies,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt})
      : _replies = replies;

  factory _$NewsCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsCommentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'articleId')
  final String articleId;
  @override
  @JsonKey(name: 'authorId')
  final String? authorId;
  @override
  @JsonKey(name: 'authorName')
  final String authorName;
  @override
  @JsonKey(name: 'authorEmail')
  final String authorEmail;
  @override
  final String content;
  @override
  final String status;
// 'PENDING' | 'APPROVED' | 'REJECTED' | 'SPAM'
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;
  final List<NewsCommentModel>? _replies;
  @override
  List<NewsCommentModel>? get replies {
    final value = _replies;
    if (value == null) return null;
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NewsCommentModel(id: $id, articleId: $articleId, authorId: $authorId, authorName: $authorName, authorEmail: $authorEmail, content: $content, status: $status, parentId: $parentId, replies: $replies, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsCommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.articleId, articleId) ||
                other.articleId == articleId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorEmail, authorEmail) ||
                other.authorEmail == authorEmail) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      articleId,
      authorId,
      authorName,
      authorEmail,
      content,
      status,
      parentId,
      const DeepCollectionEquality().hash(_replies),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsCommentModelImplCopyWith<_$NewsCommentModelImpl> get copyWith =>
      __$$NewsCommentModelImplCopyWithImpl<_$NewsCommentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsCommentModelImplToJson(
      this,
    );
  }
}

abstract class _NewsCommentModel implements NewsCommentModel {
  const factory _NewsCommentModel(
          {required final String id,
          @JsonKey(name: 'articleId') required final String articleId,
          @JsonKey(name: 'authorId') final String? authorId,
          @JsonKey(name: 'authorName') required final String authorName,
          @JsonKey(name: 'authorEmail') required final String authorEmail,
          required final String content,
          required final String status,
          @JsonKey(name: 'parentId') final String? parentId,
          final List<NewsCommentModel>? replies,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt}) =
      _$NewsCommentModelImpl;

  factory _NewsCommentModel.fromJson(Map<String, dynamic> json) =
      _$NewsCommentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'articleId')
  String get articleId;
  @override
  @JsonKey(name: 'authorId')
  String? get authorId;
  @override
  @JsonKey(name: 'authorName')
  String get authorName;
  @override
  @JsonKey(name: 'authorEmail')
  String get authorEmail;
  @override
  String get content;
  @override
  String get status;
  @override // 'PENDING' | 'APPROVED' | 'REJECTED' | 'SPAM'
  @JsonKey(name: 'parentId')
  String? get parentId;
  @override
  List<NewsCommentModel>? get replies;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NewsCommentModelImplCopyWith<_$NewsCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
