import 'package:freezed_annotation/freezed_annotation.dart';
import 'news_category_model.dart';

part 'news_article_model.freezed.dart';
part 'news_article_model.g.dart';

@freezed
class NewsArticleModel with _$NewsArticleModel {
  const factory NewsArticleModel({
    required String id,
    required String title,
    @JsonKey(name: 'titleAr') String? titleAr,
    required String content,
    @JsonKey(name: 'contentAr') String? contentAr,
    String? summary,
    @JsonKey(name: 'summaryAr') String? summaryAr,
    required String status, // 'DRAFT' | 'SCHEDULED' | 'PUBLISHED' | 'ARCHIVED'
    required String priority, // 'LOW' | 'NORMAL' | 'HIGH' | 'URGENT'
    @JsonKey(name: 'isFeatured') @Default(false) bool isFeatured,
    @JsonKey(name: 'isBreaking') @Default(false) bool isBreaking,
    @JsonKey(name: 'featuredImage') String? featuredImage,
    List<String>? images,
    @JsonKey(name: 'seoTitle') String? seoTitle,
    @JsonKey(name: 'seoDescription') String? seoDescription,
    @JsonKey(name: 'seoKeywords') List<String>? seoKeywords,
    required NewsCategoryModel category,
    @JsonKey(name: 'categoryId') required String categoryId,
    @JsonKey(name: 'authorId') required String authorId,
    @JsonKey(name: 'authorName') String? authorName,
    @JsonKey(name: 'targetType') String? targetType,
    @JsonKey(name: 'targetId') String? targetId,
    @JsonKey(name: 'isCommercial') @Default(false) bool isCommercial,
    @JsonKey(name: 'commercialCost') double? commercialCost,
    @JsonKey(name: 'publishedAt') DateTime? publishedAt,
    @JsonKey(name: 'scheduledAt') DateTime? scheduledAt,
    @Default(0) int views,
    @Default(0) int likes,
    @JsonKey(name: 'commentsCount') @Default(0) int commentsCount,
    @Default(0) int shares,
    @Default([]) List<String> tags,
    @JsonKey(name: 'allowComments') @Default(true) bool allowComments,
    @JsonKey(name: 'hideComments') @Default(false) bool hideComments,
    @JsonKey(name: 'autoApproveComments') @Default(false) bool autoApproveComments,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    @JsonKey(name: 'deletedAt') DateTime? deletedAt,
    @JsonKey(name: 'isLiked') bool? isLiked,
    @JsonKey(name: 'isBookmarked') bool? isBookmarked,
  }) = _NewsArticleModel;

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) =>
      _$NewsArticleModelFromJson(json);
}

extension NewsArticleModelExtensions on NewsArticleModel {
  String get displayTitle {
    // Use Arabic title if available, otherwise English
    return titleAr ?? title;
  }

  String get displaySummary {
    // Use Arabic summary if available, otherwise English
    return summaryAr ?? summary ?? '';
  }

  String get displayContent {
    // Use Arabic content if available, otherwise English
    return contentAr ?? content;
  }

  String get formattedPublishedDate {
    if (publishedAt == null) return '';
    final date = publishedAt!.isUtc ? publishedAt!.toLocal() : publishedAt!;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedPublishedTime {
    if (publishedAt == null) return '';
    final date = publishedAt!.isUtc ? publishedAt!.toLocal() : publishedAt!;
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get timeAgo {
    if (publishedAt == null) return '';
    final now = DateTime.now();
    final published = publishedAt!.isUtc ? publishedAt!.toLocal() : publishedAt!;
    final difference = now.difference(published);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? 'منذ سنة واحدة' : 'منذ $years سنوات';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'منذ شهر واحد' : 'منذ $months أشهر';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 
          ? 'منذ يوم واحد' 
          : 'منذ ${difference.inDays} أيام';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 
          ? 'منذ ساعة واحدة' 
          : 'منذ ${difference.inHours} ساعات';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 
          ? 'منذ دقيقة واحدة' 
          : 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case 'URGENT':
        return 'عاجل';
      case 'HIGH':
        return 'عالي';
      case 'NORMAL':
        return 'عادي';
      case 'LOW':
        return 'منخفض';
      default:
        return priority;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'PUBLISHED':
        return 'منشور';
      case 'DRAFT':
        return 'مسودة';
      case 'SCHEDULED':
        return 'مجدول';
      case 'ARCHIVED':
        return 'مؤرشف';
      default:
        return status;
    }
  }

  bool get isPublished {
    return status == 'PUBLISHED' && publishedAt != null;
  }

  String? get mainImage {
    return featuredImage ?? (images != null && images!.isNotEmpty ? images!.first : null);
  }
}

