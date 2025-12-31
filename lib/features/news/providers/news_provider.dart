import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/news_article_model.dart';
import '../../../models/news_category_model.dart';
import '../../../services/news_service.dart';

// Provider for NewsService
final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService();
});

// News Filter class
class NewsFilters {
  final int page;
  final int limit;
  final String? categoryId;
  final String? status;
  final String? priority;
  final bool featuredOnly;
  final bool breakingOnly;
  final String? search;
  final String? targetType;
  final String? targetId;
  final String? sortBy;
  final String? sortOrder;

  NewsFilters({
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.status,
    this.priority,
    this.featuredOnly = false,
    this.breakingOnly = false,
    this.search,
    this.targetType,
    this.targetId,
    this.sortBy,
    this.sortOrder,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsFilters &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          limit == other.limit &&
          categoryId == other.categoryId &&
          status == other.status &&
          priority == other.priority &&
          featuredOnly == other.featuredOnly &&
          breakingOnly == other.breakingOnly &&
          search == other.search &&
          targetType == other.targetType &&
          targetId == other.targetId &&
          sortBy == other.sortBy &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      page.hashCode ^
      limit.hashCode ^
      categoryId.hashCode ^
      status.hashCode ^
      priority.hashCode ^
      featuredOnly.hashCode ^
      breakingOnly.hashCode ^
      search.hashCode ^
      targetType.hashCode ^
      targetId.hashCode ^
      sortBy.hashCode ^
      sortOrder.hashCode;
}

// News list provider
final newsListProvider = FutureProvider.family<Map<String, dynamic>, NewsFilters>((ref, filters) async {
  final service = ref.watch(newsServiceProvider);
  try {
    final result = await service.getNews(
      page: filters.page,
      limit: filters.limit,
      categoryId: filters.categoryId,
      status: filters.status,
      priority: filters.priority,
      featuredOnly: filters.featuredOnly,
      breakingOnly: filters.breakingOnly,
      search: filters.search,
      targetType: filters.targetType,
      targetId: filters.targetId,
      sortBy: filters.sortBy,
      sortOrder: filters.sortOrder,
    );
    return result;
  } catch (e) {
    debugPrint('Error loading news list: $e');
    rethrow;
  }
});

// News detail provider
final newsDetailProvider = FutureProvider.family<NewsArticleModel, String>((ref, id) async {
  final service = ref.watch(newsServiceProvider);
  try {
    return await service.getNewsById(id);
  } catch (e) {
    debugPrint('Error loading news detail: $e');
    rethrow;
  }
});

// Featured news provider
final featuredNewsProvider = FutureProvider.autoDispose<List<NewsArticleModel>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  try {
    return await service.getFeatured();
  } catch (e) {
    debugPrint('Error loading featured news: $e');
    return [];
  }
});

// Breaking news provider
final breakingNewsProvider = FutureProvider.autoDispose<List<NewsArticleModel>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  try {
    return await service.getBreaking();
  } catch (e) {
    debugPrint('Error loading breaking news: $e');
    return [];
  }
});

// Helper function to refresh news list
Future<void> refreshNewsList(WidgetRef ref, NewsFilters filters) async {
  ref.invalidate(newsListProvider(filters));
}

// Helper function to refresh news detail
Future<void> refreshNewsDetail(WidgetRef ref, String id) async {
  ref.invalidate(newsDetailProvider(id));
}

// Helper function to refresh featured news
Future<void> refreshFeaturedNews(WidgetRef ref) async {
  ref.invalidate(featuredNewsProvider);
}

// Helper function to refresh breaking news
Future<void> refreshBreakingNews(WidgetRef ref) async {
  ref.invalidate(breakingNewsProvider);
}

