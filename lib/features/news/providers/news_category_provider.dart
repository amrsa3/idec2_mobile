import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/news_category_model.dart';
import '../../../services/news_service.dart';
import 'news_provider.dart';

// News categories provider
final newsCategoriesProvider = FutureProvider.autoDispose<List<NewsCategoryModel>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  try {
    return await service.getCategories(activeOnly: true);
  } catch (e) {
    debugPrint('Error loading news categories: $e');
    return [];
  }
});

// All categories (including inactive)
final allNewsCategoriesProvider = FutureProvider.autoDispose<List<NewsCategoryModel>>((ref) async {
  final service = ref.watch(newsServiceProvider);
  try {
    return await service.getCategories(activeOnly: false);
  } catch (e) {
    debugPrint('Error loading all news categories: $e');
    return [];
  }
});

// Helper function to refresh categories
Future<void> refreshNewsCategories(WidgetRef ref) async {
  ref.invalidate(newsCategoriesProvider);
  ref.invalidate(allNewsCategoriesProvider);
}

