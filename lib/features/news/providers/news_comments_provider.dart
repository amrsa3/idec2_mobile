import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/news_comment_model.dart';
import '../../../services/news_service.dart';
import 'news_provider.dart';

// News comments provider
final newsCommentsProvider = FutureProvider.family<List<NewsCommentModel>, String>((ref, articleId) async {
  final service = ref.watch(newsServiceProvider);
  try {
    return await service.getComments(articleId, includeReplies: true);
  } catch (e) {
    debugPrint('Error loading news comments: $e');
    return [];
  }
});

// Helper function to refresh comments
Future<void> refreshNewsComments(WidgetRef ref, String articleId) async {
  ref.invalidate(newsCommentsProvider(articleId));
}

