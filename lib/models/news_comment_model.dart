import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_comment_model.freezed.dart';
part 'news_comment_model.g.dart';

@freezed
class NewsCommentModel with _$NewsCommentModel {
  const factory NewsCommentModel({
    required String id,
    @JsonKey(name: 'articleId') required String articleId,
    @JsonKey(name: 'authorId') String? authorId,
    @JsonKey(name: 'authorName') required String authorName,
    @JsonKey(name: 'authorEmail') required String authorEmail,
    required String content,
    required String status, // 'PENDING' | 'APPROVED' | 'REJECTED' | 'SPAM'
    @JsonKey(name: 'parentId') String? parentId,
    List<NewsCommentModel>? replies,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _NewsCommentModel;

  factory NewsCommentModel.fromJson(Map<String, dynamic> json) =>
      _$NewsCommentModelFromJson(json);
}

extension NewsCommentModelExtensions on NewsCommentModel {
  String get statusLabel {
    switch (status) {
      case 'APPROVED':
        return 'موافق عليه';
      case 'PENDING':
        return 'قيد الانتظار';
      case 'REJECTED':
        return 'مرفوض';
      case 'SPAM':
        return 'رسالة غير مرغوبة';
      default:
        return status;
    }
  }

  bool get isApproved {
    return status == 'APPROVED';
  }

  bool get isPending {
    return status == 'PENDING';
  }

  String get timeAgo {
    final now = DateTime.now();
    final commentDate = createdAt.isUtc ? createdAt.toLocal() : createdAt;
    final difference = now.difference(commentDate);

    if (difference.inDays > 30) {
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

  int get repliesCount {
    return replies?.length ?? 0;
  }
}

