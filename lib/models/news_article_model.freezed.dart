// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsArticleModel _$NewsArticleModelFromJson(Map<String, dynamic> json) {
  return _NewsArticleModel.fromJson(json);
}

/// @nodoc
mixin _$NewsArticleModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'titleAr')
  String? get titleAr => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'contentAr')
  String? get contentAr => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  @JsonKey(name: 'summaryAr')
  String? get summaryAr => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'DRAFT' | 'SCHEDULED' | 'PUBLISHED' | 'ARCHIVED'
  String get priority =>
      throw _privateConstructorUsedError; // 'LOW' | 'NORMAL' | 'HIGH' | 'URGENT'
  @JsonKey(name: 'isFeatured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'isBreaking')
  bool get isBreaking => throw _privateConstructorUsedError;
  @JsonKey(name: 'featuredImage')
  String? get featuredImage => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'seoTitle')
  String? get seoTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'seoDescription')
  String? get seoDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'seoKeywords')
  List<String>? get seoKeywords => throw _privateConstructorUsedError;
  NewsCategoryModel get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'categoryId')
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'authorId')
  String get authorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'authorName')
  String? get authorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'targetType')
  String? get targetType => throw _privateConstructorUsedError;
  @JsonKey(name: 'targetId')
  String? get targetId => throw _privateConstructorUsedError;
  @JsonKey(name: 'isCommercial')
  bool get isCommercial => throw _privateConstructorUsedError;
  @JsonKey(name: 'commercialCost')
  double? get commercialCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'publishedAt')
  DateTime? get publishedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduledAt')
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  @JsonKey(name: 'commentsCount')
  int get commentsCount => throw _privateConstructorUsedError;
  int get shares => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'allowComments')
  bool get allowComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'hideComments')
  bool get hideComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'autoApproveComments')
  bool get autoApproveComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deletedAt')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'isLiked')
  bool? get isLiked => throw _privateConstructorUsedError;
  @JsonKey(name: 'isBookmarked')
  bool? get isBookmarked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewsArticleModelCopyWith<NewsArticleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsArticleModelCopyWith<$Res> {
  factory $NewsArticleModelCopyWith(
          NewsArticleModel value, $Res Function(NewsArticleModel) then) =
      _$NewsArticleModelCopyWithImpl<$Res, NewsArticleModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'titleAr') String? titleAr,
      String content,
      @JsonKey(name: 'contentAr') String? contentAr,
      String? summary,
      @JsonKey(name: 'summaryAr') String? summaryAr,
      String status,
      String priority,
      @JsonKey(name: 'isFeatured') bool isFeatured,
      @JsonKey(name: 'isBreaking') bool isBreaking,
      @JsonKey(name: 'featuredImage') String? featuredImage,
      List<String>? images,
      @JsonKey(name: 'seoTitle') String? seoTitle,
      @JsonKey(name: 'seoDescription') String? seoDescription,
      @JsonKey(name: 'seoKeywords') List<String>? seoKeywords,
      NewsCategoryModel category,
      @JsonKey(name: 'categoryId') String categoryId,
      @JsonKey(name: 'authorId') String authorId,
      @JsonKey(name: 'authorName') String? authorName,
      @JsonKey(name: 'targetType') String? targetType,
      @JsonKey(name: 'targetId') String? targetId,
      @JsonKey(name: 'isCommercial') bool isCommercial,
      @JsonKey(name: 'commercialCost') double? commercialCost,
      @JsonKey(name: 'publishedAt') DateTime? publishedAt,
      @JsonKey(name: 'scheduledAt') DateTime? scheduledAt,
      int views,
      int likes,
      @JsonKey(name: 'commentsCount') int commentsCount,
      int shares,
      List<String> tags,
      @JsonKey(name: 'allowComments') bool allowComments,
      @JsonKey(name: 'hideComments') bool hideComments,
      @JsonKey(name: 'autoApproveComments') bool autoApproveComments,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: 'deletedAt') DateTime? deletedAt,
      @JsonKey(name: 'isLiked') bool? isLiked,
      @JsonKey(name: 'isBookmarked') bool? isBookmarked});

  $NewsCategoryModelCopyWith<$Res> get category;
}

/// @nodoc
class _$NewsArticleModelCopyWithImpl<$Res, $Val extends NewsArticleModel>
    implements $NewsArticleModelCopyWith<$Res> {
  _$NewsArticleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? titleAr = freezed,
    Object? content = null,
    Object? contentAr = freezed,
    Object? summary = freezed,
    Object? summaryAr = freezed,
    Object? status = null,
    Object? priority = null,
    Object? isFeatured = null,
    Object? isBreaking = null,
    Object? featuredImage = freezed,
    Object? images = freezed,
    Object? seoTitle = freezed,
    Object? seoDescription = freezed,
    Object? seoKeywords = freezed,
    Object? category = null,
    Object? categoryId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? targetType = freezed,
    Object? targetId = freezed,
    Object? isCommercial = null,
    Object? commercialCost = freezed,
    Object? publishedAt = freezed,
    Object? scheduledAt = freezed,
    Object? views = null,
    Object? likes = null,
    Object? commentsCount = null,
    Object? shares = null,
    Object? tags = null,
    Object? allowComments = null,
    Object? hideComments = null,
    Object? autoApproveComments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? isLiked = freezed,
    Object? isBookmarked = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      titleAr: freezed == titleAr
          ? _value.titleAr
          : titleAr // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentAr: freezed == contentAr
          ? _value.contentAr
          : contentAr // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryAr: freezed == summaryAr
          ? _value.summaryAr
          : summaryAr // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isBreaking: null == isBreaking
          ? _value.isBreaking
          : isBreaking // ignore: cast_nullable_to_non_nullable
              as bool,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      seoTitle: freezed == seoTitle
          ? _value.seoTitle
          : seoTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      seoDescription: freezed == seoDescription
          ? _value.seoDescription
          : seoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      seoKeywords: freezed == seoKeywords
          ? _value.seoKeywords
          : seoKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as NewsCategoryModel,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetType: freezed == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as String?,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCommercial: null == isCommercial
          ? _value.isCommercial
          : isCommercial // ignore: cast_nullable_to_non_nullable
              as bool,
      commercialCost: freezed == commercialCost
          ? _value.commercialCost
          : commercialCost // ignore: cast_nullable_to_non_nullable
              as double?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as bool,
      hideComments: null == hideComments
          ? _value.hideComments
          : hideComments // ignore: cast_nullable_to_non_nullable
              as bool,
      autoApproveComments: null == autoApproveComments
          ? _value.autoApproveComments
          : autoApproveComments // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLiked: freezed == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool?,
      isBookmarked: freezed == isBookmarked
          ? _value.isBookmarked
          : isBookmarked // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NewsCategoryModelCopyWith<$Res> get category {
    return $NewsCategoryModelCopyWith<$Res>(_value.category, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NewsArticleModelImplCopyWith<$Res>
    implements $NewsArticleModelCopyWith<$Res> {
  factory _$$NewsArticleModelImplCopyWith(_$NewsArticleModelImpl value,
          $Res Function(_$NewsArticleModelImpl) then) =
      __$$NewsArticleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'titleAr') String? titleAr,
      String content,
      @JsonKey(name: 'contentAr') String? contentAr,
      String? summary,
      @JsonKey(name: 'summaryAr') String? summaryAr,
      String status,
      String priority,
      @JsonKey(name: 'isFeatured') bool isFeatured,
      @JsonKey(name: 'isBreaking') bool isBreaking,
      @JsonKey(name: 'featuredImage') String? featuredImage,
      List<String>? images,
      @JsonKey(name: 'seoTitle') String? seoTitle,
      @JsonKey(name: 'seoDescription') String? seoDescription,
      @JsonKey(name: 'seoKeywords') List<String>? seoKeywords,
      NewsCategoryModel category,
      @JsonKey(name: 'categoryId') String categoryId,
      @JsonKey(name: 'authorId') String authorId,
      @JsonKey(name: 'authorName') String? authorName,
      @JsonKey(name: 'targetType') String? targetType,
      @JsonKey(name: 'targetId') String? targetId,
      @JsonKey(name: 'isCommercial') bool isCommercial,
      @JsonKey(name: 'commercialCost') double? commercialCost,
      @JsonKey(name: 'publishedAt') DateTime? publishedAt,
      @JsonKey(name: 'scheduledAt') DateTime? scheduledAt,
      int views,
      int likes,
      @JsonKey(name: 'commentsCount') int commentsCount,
      int shares,
      List<String> tags,
      @JsonKey(name: 'allowComments') bool allowComments,
      @JsonKey(name: 'hideComments') bool hideComments,
      @JsonKey(name: 'autoApproveComments') bool autoApproveComments,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      @JsonKey(name: 'updatedAt') DateTime updatedAt,
      @JsonKey(name: 'deletedAt') DateTime? deletedAt,
      @JsonKey(name: 'isLiked') bool? isLiked,
      @JsonKey(name: 'isBookmarked') bool? isBookmarked});

  @override
  $NewsCategoryModelCopyWith<$Res> get category;
}

/// @nodoc
class __$$NewsArticleModelImplCopyWithImpl<$Res>
    extends _$NewsArticleModelCopyWithImpl<$Res, _$NewsArticleModelImpl>
    implements _$$NewsArticleModelImplCopyWith<$Res> {
  __$$NewsArticleModelImplCopyWithImpl(_$NewsArticleModelImpl _value,
      $Res Function(_$NewsArticleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? titleAr = freezed,
    Object? content = null,
    Object? contentAr = freezed,
    Object? summary = freezed,
    Object? summaryAr = freezed,
    Object? status = null,
    Object? priority = null,
    Object? isFeatured = null,
    Object? isBreaking = null,
    Object? featuredImage = freezed,
    Object? images = freezed,
    Object? seoTitle = freezed,
    Object? seoDescription = freezed,
    Object? seoKeywords = freezed,
    Object? category = null,
    Object? categoryId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? targetType = freezed,
    Object? targetId = freezed,
    Object? isCommercial = null,
    Object? commercialCost = freezed,
    Object? publishedAt = freezed,
    Object? scheduledAt = freezed,
    Object? views = null,
    Object? likes = null,
    Object? commentsCount = null,
    Object? shares = null,
    Object? tags = null,
    Object? allowComments = null,
    Object? hideComments = null,
    Object? autoApproveComments = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? isLiked = freezed,
    Object? isBookmarked = freezed,
  }) {
    return _then(_$NewsArticleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      titleAr: freezed == titleAr
          ? _value.titleAr
          : titleAr // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentAr: freezed == contentAr
          ? _value.contentAr
          : contentAr // ignore: cast_nullable_to_non_nullable
              as String?,
      summary: freezed == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      summaryAr: freezed == summaryAr
          ? _value.summaryAr
          : summaryAr // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isBreaking: null == isBreaking
          ? _value.isBreaking
          : isBreaking // ignore: cast_nullable_to_non_nullable
              as bool,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as String?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      seoTitle: freezed == seoTitle
          ? _value.seoTitle
          : seoTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      seoDescription: freezed == seoDescription
          ? _value.seoDescription
          : seoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      seoKeywords: freezed == seoKeywords
          ? _value._seoKeywords
          : seoKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as NewsCategoryModel,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetType: freezed == targetType
          ? _value.targetType
          : targetType // ignore: cast_nullable_to_non_nullable
              as String?,
      targetId: freezed == targetId
          ? _value.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCommercial: null == isCommercial
          ? _value.isCommercial
          : isCommercial // ignore: cast_nullable_to_non_nullable
              as bool,
      commercialCost: freezed == commercialCost
          ? _value.commercialCost
          : commercialCost // ignore: cast_nullable_to_non_nullable
              as double?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as bool,
      hideComments: null == hideComments
          ? _value.hideComments
          : hideComments // ignore: cast_nullable_to_non_nullable
              as bool,
      autoApproveComments: null == autoApproveComments
          ? _value.autoApproveComments
          : autoApproveComments // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLiked: freezed == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool?,
      isBookmarked: freezed == isBookmarked
          ? _value.isBookmarked
          : isBookmarked // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsArticleModelImpl implements _NewsArticleModel {
  const _$NewsArticleModelImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'titleAr') this.titleAr,
      required this.content,
      @JsonKey(name: 'contentAr') this.contentAr,
      this.summary,
      @JsonKey(name: 'summaryAr') this.summaryAr,
      required this.status,
      required this.priority,
      @JsonKey(name: 'isFeatured') this.isFeatured = false,
      @JsonKey(name: 'isBreaking') this.isBreaking = false,
      @JsonKey(name: 'featuredImage') this.featuredImage,
      final List<String>? images,
      @JsonKey(name: 'seoTitle') this.seoTitle,
      @JsonKey(name: 'seoDescription') this.seoDescription,
      @JsonKey(name: 'seoKeywords') final List<String>? seoKeywords,
      required this.category,
      @JsonKey(name: 'categoryId') required this.categoryId,
      @JsonKey(name: 'authorId') required this.authorId,
      @JsonKey(name: 'authorName') this.authorName,
      @JsonKey(name: 'targetType') this.targetType,
      @JsonKey(name: 'targetId') this.targetId,
      @JsonKey(name: 'isCommercial') this.isCommercial = false,
      @JsonKey(name: 'commercialCost') this.commercialCost,
      @JsonKey(name: 'publishedAt') this.publishedAt,
      @JsonKey(name: 'scheduledAt') this.scheduledAt,
      this.views = 0,
      this.likes = 0,
      @JsonKey(name: 'commentsCount') this.commentsCount = 0,
      this.shares = 0,
      final List<String> tags = const [],
      @JsonKey(name: 'allowComments') this.allowComments = true,
      @JsonKey(name: 'hideComments') this.hideComments = false,
      @JsonKey(name: 'autoApproveComments') this.autoApproveComments = false,
      @JsonKey(name: 'createdAt') required this.createdAt,
      @JsonKey(name: 'updatedAt') required this.updatedAt,
      @JsonKey(name: 'deletedAt') this.deletedAt,
      @JsonKey(name: 'isLiked') this.isLiked,
      @JsonKey(name: 'isBookmarked') this.isBookmarked})
      : _images = images,
        _seoKeywords = seoKeywords,
        _tags = tags;

  factory _$NewsArticleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsArticleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'titleAr')
  final String? titleAr;
  @override
  final String content;
  @override
  @JsonKey(name: 'contentAr')
  final String? contentAr;
  @override
  final String? summary;
  @override
  @JsonKey(name: 'summaryAr')
  final String? summaryAr;
  @override
  final String status;
// 'DRAFT' | 'SCHEDULED' | 'PUBLISHED' | 'ARCHIVED'
  @override
  final String priority;
// 'LOW' | 'NORMAL' | 'HIGH' | 'URGENT'
  @override
  @JsonKey(name: 'isFeatured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'isBreaking')
  final bool isBreaking;
  @override
  @JsonKey(name: 'featuredImage')
  final String? featuredImage;
  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'seoTitle')
  final String? seoTitle;
  @override
  @JsonKey(name: 'seoDescription')
  final String? seoDescription;
  final List<String>? _seoKeywords;
  @override
  @JsonKey(name: 'seoKeywords')
  List<String>? get seoKeywords {
    final value = _seoKeywords;
    if (value == null) return null;
    if (_seoKeywords is EqualUnmodifiableListView) return _seoKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final NewsCategoryModel category;
  @override
  @JsonKey(name: 'categoryId')
  final String categoryId;
  @override
  @JsonKey(name: 'authorId')
  final String authorId;
  @override
  @JsonKey(name: 'authorName')
  final String? authorName;
  @override
  @JsonKey(name: 'targetType')
  final String? targetType;
  @override
  @JsonKey(name: 'targetId')
  final String? targetId;
  @override
  @JsonKey(name: 'isCommercial')
  final bool isCommercial;
  @override
  @JsonKey(name: 'commercialCost')
  final double? commercialCost;
  @override
  @JsonKey(name: 'publishedAt')
  final DateTime? publishedAt;
  @override
  @JsonKey(name: 'scheduledAt')
  final DateTime? scheduledAt;
  @override
  @JsonKey()
  final int views;
  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey(name: 'commentsCount')
  final int commentsCount;
  @override
  @JsonKey()
  final int shares;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey(name: 'allowComments')
  final bool allowComments;
  @override
  @JsonKey(name: 'hideComments')
  final bool hideComments;
  @override
  @JsonKey(name: 'autoApproveComments')
  final bool autoApproveComments;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'deletedAt')
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'isLiked')
  final bool? isLiked;
  @override
  @JsonKey(name: 'isBookmarked')
  final bool? isBookmarked;

  @override
  String toString() {
    return 'NewsArticleModel(id: $id, title: $title, titleAr: $titleAr, content: $content, contentAr: $contentAr, summary: $summary, summaryAr: $summaryAr, status: $status, priority: $priority, isFeatured: $isFeatured, isBreaking: $isBreaking, featuredImage: $featuredImage, images: $images, seoTitle: $seoTitle, seoDescription: $seoDescription, seoKeywords: $seoKeywords, category: $category, categoryId: $categoryId, authorId: $authorId, authorName: $authorName, targetType: $targetType, targetId: $targetId, isCommercial: $isCommercial, commercialCost: $commercialCost, publishedAt: $publishedAt, scheduledAt: $scheduledAt, views: $views, likes: $likes, commentsCount: $commentsCount, shares: $shares, tags: $tags, allowComments: $allowComments, hideComments: $hideComments, autoApproveComments: $autoApproveComments, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, isLiked: $isLiked, isBookmarked: $isBookmarked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsArticleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.titleAr, titleAr) || other.titleAr == titleAr) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.contentAr, contentAr) ||
                other.contentAr == contentAr) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.summaryAr, summaryAr) ||
                other.summaryAr == summaryAr) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isBreaking, isBreaking) ||
                other.isBreaking == isBreaking) &&
            (identical(other.featuredImage, featuredImage) ||
                other.featuredImage == featuredImage) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.seoTitle, seoTitle) ||
                other.seoTitle == seoTitle) &&
            (identical(other.seoDescription, seoDescription) ||
                other.seoDescription == seoDescription) &&
            const DeepCollectionEquality()
                .equals(other._seoKeywords, _seoKeywords) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.isCommercial, isCommercial) ||
                other.isCommercial == isCommercial) &&
            (identical(other.commercialCost, commercialCost) ||
                other.commercialCost == commercialCost) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.shares, shares) || other.shares == shares) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.hideComments, hideComments) ||
                other.hideComments == hideComments) &&
            (identical(other.autoApproveComments, autoApproveComments) ||
                other.autoApproveComments == autoApproveComments) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isBookmarked, isBookmarked) ||
                other.isBookmarked == isBookmarked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        titleAr,
        content,
        contentAr,
        summary,
        summaryAr,
        status,
        priority,
        isFeatured,
        isBreaking,
        featuredImage,
        const DeepCollectionEquality().hash(_images),
        seoTitle,
        seoDescription,
        const DeepCollectionEquality().hash(_seoKeywords),
        category,
        categoryId,
        authorId,
        authorName,
        targetType,
        targetId,
        isCommercial,
        commercialCost,
        publishedAt,
        scheduledAt,
        views,
        likes,
        commentsCount,
        shares,
        const DeepCollectionEquality().hash(_tags),
        allowComments,
        hideComments,
        autoApproveComments,
        createdAt,
        updatedAt,
        deletedAt,
        isLiked,
        isBookmarked
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsArticleModelImplCopyWith<_$NewsArticleModelImpl> get copyWith =>
      __$$NewsArticleModelImplCopyWithImpl<_$NewsArticleModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsArticleModelImplToJson(
      this,
    );
  }
}

abstract class _NewsArticleModel implements NewsArticleModel {
  const factory _NewsArticleModel(
          {required final String id,
          required final String title,
          @JsonKey(name: 'titleAr') final String? titleAr,
          required final String content,
          @JsonKey(name: 'contentAr') final String? contentAr,
          final String? summary,
          @JsonKey(name: 'summaryAr') final String? summaryAr,
          required final String status,
          required final String priority,
          @JsonKey(name: 'isFeatured') final bool isFeatured,
          @JsonKey(name: 'isBreaking') final bool isBreaking,
          @JsonKey(name: 'featuredImage') final String? featuredImage,
          final List<String>? images,
          @JsonKey(name: 'seoTitle') final String? seoTitle,
          @JsonKey(name: 'seoDescription') final String? seoDescription,
          @JsonKey(name: 'seoKeywords') final List<String>? seoKeywords,
          required final NewsCategoryModel category,
          @JsonKey(name: 'categoryId') required final String categoryId,
          @JsonKey(name: 'authorId') required final String authorId,
          @JsonKey(name: 'authorName') final String? authorName,
          @JsonKey(name: 'targetType') final String? targetType,
          @JsonKey(name: 'targetId') final String? targetId,
          @JsonKey(name: 'isCommercial') final bool isCommercial,
          @JsonKey(name: 'commercialCost') final double? commercialCost,
          @JsonKey(name: 'publishedAt') final DateTime? publishedAt,
          @JsonKey(name: 'scheduledAt') final DateTime? scheduledAt,
          final int views,
          final int likes,
          @JsonKey(name: 'commentsCount') final int commentsCount,
          final int shares,
          final List<String> tags,
          @JsonKey(name: 'allowComments') final bool allowComments,
          @JsonKey(name: 'hideComments') final bool hideComments,
          @JsonKey(name: 'autoApproveComments') final bool autoApproveComments,
          @JsonKey(name: 'createdAt') required final DateTime createdAt,
          @JsonKey(name: 'updatedAt') required final DateTime updatedAt,
          @JsonKey(name: 'deletedAt') final DateTime? deletedAt,
          @JsonKey(name: 'isLiked') final bool? isLiked,
          @JsonKey(name: 'isBookmarked') final bool? isBookmarked}) =
      _$NewsArticleModelImpl;

  factory _NewsArticleModel.fromJson(Map<String, dynamic> json) =
      _$NewsArticleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'titleAr')
  String? get titleAr;
  @override
  String get content;
  @override
  @JsonKey(name: 'contentAr')
  String? get contentAr;
  @override
  String? get summary;
  @override
  @JsonKey(name: 'summaryAr')
  String? get summaryAr;
  @override
  String get status;
  @override // 'DRAFT' | 'SCHEDULED' | 'PUBLISHED' | 'ARCHIVED'
  String get priority;
  @override // 'LOW' | 'NORMAL' | 'HIGH' | 'URGENT'
  @JsonKey(name: 'isFeatured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'isBreaking')
  bool get isBreaking;
  @override
  @JsonKey(name: 'featuredImage')
  String? get featuredImage;
  @override
  List<String>? get images;
  @override
  @JsonKey(name: 'seoTitle')
  String? get seoTitle;
  @override
  @JsonKey(name: 'seoDescription')
  String? get seoDescription;
  @override
  @JsonKey(name: 'seoKeywords')
  List<String>? get seoKeywords;
  @override
  NewsCategoryModel get category;
  @override
  @JsonKey(name: 'categoryId')
  String get categoryId;
  @override
  @JsonKey(name: 'authorId')
  String get authorId;
  @override
  @JsonKey(name: 'authorName')
  String? get authorName;
  @override
  @JsonKey(name: 'targetType')
  String? get targetType;
  @override
  @JsonKey(name: 'targetId')
  String? get targetId;
  @override
  @JsonKey(name: 'isCommercial')
  bool get isCommercial;
  @override
  @JsonKey(name: 'commercialCost')
  double? get commercialCost;
  @override
  @JsonKey(name: 'publishedAt')
  DateTime? get publishedAt;
  @override
  @JsonKey(name: 'scheduledAt')
  DateTime? get scheduledAt;
  @override
  int get views;
  @override
  int get likes;
  @override
  @JsonKey(name: 'commentsCount')
  int get commentsCount;
  @override
  int get shares;
  @override
  List<String> get tags;
  @override
  @JsonKey(name: 'allowComments')
  bool get allowComments;
  @override
  @JsonKey(name: 'hideComments')
  bool get hideComments;
  @override
  @JsonKey(name: 'autoApproveComments')
  bool get autoApproveComments;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'deletedAt')
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'isLiked')
  bool? get isLiked;
  @override
  @JsonKey(name: 'isBookmarked')
  bool? get isBookmarked;
  @override
  @JsonKey(ignore: true)
  _$$NewsArticleModelImplCopyWith<_$NewsArticleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
