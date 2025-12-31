import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/platform_storage_service.dart';

/// نوع العنصر المفضل
enum FavoriteType {
  product,
  exhibitor,
  session,
  speaker,
}

/// نموذج العنصر المفضل
class FavoriteItem {
  final String id;
  final FavoriteType type;
  final String name;
  final String? nameEn;
  final String? imageUrl;
  final String? subtitle;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.name,
    this.nameEn,
    this.imageUrl,
    this.subtitle,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'name': name,
        'nameEn': nameEn,
        'imageUrl': imageUrl,
        'subtitle': subtitle,
        'addedAt': addedAt.toIso8601String(),
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'],
        type: FavoriteType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => FavoriteType.product,
        ),
        name: json['name'] ?? '',
        nameEn: json['nameEn'],
        imageUrl: json['imageUrl'],
        subtitle: json['subtitle'],
        addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
      );

  String get typeLabel {
    switch (type) {
      case FavoriteType.product:
        return 'منتج';
      case FavoriteType.exhibitor:
        return 'عارض';
      case FavoriteType.session:
        return 'جلسة';
      case FavoriteType.speaker:
        return 'متحدث';
    }
  }

  String get typeLabelEn {
    switch (type) {
      case FavoriteType.product:
        return 'Product';
      case FavoriteType.exhibitor:
        return 'Exhibitor';
      case FavoriteType.session:
        return 'Session';
      case FavoriteType.speaker:
        return 'Speaker';
    }
  }
}

/// حالة المفضلة
class FavoritesState {
  final List<FavoriteItem> items;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<FavoriteItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<FavoriteItem> getByType(FavoriteType type) {
    return items.where((item) => item.type == type).toList();
  }

  bool isFavorite(String id, FavoriteType type) {
    return items.any((item) => item.id == id && item.type == type);
  }

  int get productCount => getByType(FavoriteType.product).length;
  int get exhibitorCount => getByType(FavoriteType.exhibitor).length;
  int get sessionCount => getByType(FavoriteType.session).length;
  int get speakerCount => getByType(FavoriteType.speaker).length;
}

/// Notifier للمفضلة
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  static const String _storageKey = 'user_favorites';

  FavoritesNotifier() : super(const FavoritesState()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = state.copyWith(isLoading: true);
    try {
      final storage = PlatformStorageService.instance;
      final data = await storage.getString(_storageKey);
      
      if (data != null && data.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
        final items = jsonList
            .map((json) => FavoriteItem.fromJson(json as Map<String, dynamic>))
            .toList();
        
        state = state.copyWith(items: items, isLoading: false);
        debugPrint('✅ [FAVORITES] Loaded ${items.length} favorites');
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      debugPrint('❌ [FAVORITES] Error loading favorites: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final storage = PlatformStorageService.instance;
      final jsonList = state.items.map((item) => item.toJson()).toList();
      await storage.setString(_storageKey, jsonEncode(jsonList));
      debugPrint('✅ [FAVORITES] Saved ${state.items.length} favorites');
    } catch (e) {
      debugPrint('❌ [FAVORITES] Error saving favorites: $e');
    }
  }

  /// إضافة عنصر للمفضلة
  Future<void> addFavorite({
    required String id,
    required FavoriteType type,
    required String name,
    String? nameEn,
    String? imageUrl,
    String? subtitle,
  }) async {
    if (state.isFavorite(id, type)) {
      debugPrint('⚠️ [FAVORITES] Item already in favorites: $id');
      return;
    }

    final newItem = FavoriteItem(
      id: id,
      type: type,
      name: name,
      nameEn: nameEn,
      imageUrl: imageUrl,
      subtitle: subtitle,
      addedAt: DateTime.now(),
    );

    state = state.copyWith(items: [...state.items, newItem]);
    await _saveFavorites();
    debugPrint('✅ [FAVORITES] Added to favorites: $name');
  }

  /// إزالة عنصر من المفضلة
  Future<void> removeFavorite(String id, FavoriteType type) async {
    final updatedItems = state.items
        .where((item) => !(item.id == id && item.type == type))
        .toList();
    
    state = state.copyWith(items: updatedItems);
    await _saveFavorites();
    debugPrint('✅ [FAVORITES] Removed from favorites: $id');
  }

  /// تبديل حالة المفضلة
  Future<bool> toggleFavorite({
    required String id,
    required FavoriteType type,
    required String name,
    String? nameEn,
    String? imageUrl,
    String? subtitle,
  }) async {
    if (state.isFavorite(id, type)) {
      await removeFavorite(id, type);
      return false;
    } else {
      await addFavorite(
        id: id,
        type: type,
        name: name,
        nameEn: nameEn,
        imageUrl: imageUrl,
        subtitle: subtitle,
      );
      return true;
    }
  }

  /// مسح جميع المفضلات
  Future<void> clearAllFavorites() async {
    state = state.copyWith(items: []);
    await _saveFavorites();
    debugPrint('✅ [FAVORITES] Cleared all favorites');
  }

  /// مسح المفضلات حسب النوع
  Future<void> clearFavoritesByType(FavoriteType type) async {
    final updatedItems = state.items
        .where((item) => item.type != type)
        .toList();
    
    state = state.copyWith(items: updatedItems);
    await _saveFavorites();
    debugPrint('✅ [FAVORITES] Cleared favorites of type: ${type.name}');
  }
}

/// Provider للمفضلة
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier();
});

/// Provider للتحقق من عنصر في المفضلة
final isFavoriteProvider = Provider.family<bool, (String, FavoriteType)>((ref, params) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.isFavorite(params.$1, params.$2);
});

/// Provider لعدد المفضلات
final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).items.length;
});
