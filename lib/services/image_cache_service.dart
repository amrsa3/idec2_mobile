import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart';

/// خدمة إدارة الـ cache للصور
class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  /// مسح صورة معينة من الـ cache
  static Future<void> evictImage(String imageUrl) async {
    try {
      debugPrint('🗑️ ImageCacheService: Evicting image from cache: $imageUrl');
      await CachedNetworkImage.evictFromCache(imageUrl);
      debugPrint('✅ ImageCacheService: Successfully evicted image from cache');
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error evicting image from cache: $e');
    }
  }

  /// مسح جميع الصور من الـ cache
  static Future<void> clearAllCache() async {
    try {
      debugPrint('🗑️ ImageCacheService: Clearing all image cache');
      await DefaultCacheManager().emptyCache();
      debugPrint('✅ ImageCacheService: Successfully cleared all cache');
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error clearing cache: $e');
    }
  }

  /// مسح الـ cache للصور القديمة للملف الشخصي
  static Future<void> clearProfilePictureCache(String? oldUrl, String? newUrl) async {
    try {
      if (oldUrl != null && oldUrl.isNotEmpty) {
        debugPrint('🗑️ ImageCacheService: Clearing old profile picture cache: $oldUrl');
        await evictImage(oldUrl);
      }
      
      if (newUrl != null && newUrl.isNotEmpty && newUrl != oldUrl) {
        debugPrint('🗑️ ImageCacheService: Clearing new profile picture cache: $newUrl');
        await evictImage(newUrl);
      }
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error clearing profile picture cache: $e');
    }
  }

  /// إنشاء مفتاح فريد للصورة
  static String generateUniqueKey(String imageUrl) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${imageUrl}_$timestamp';
  }

  /// فحص حجم الـ cache
  static Future<int> getCacheSize() async {
    try {
      final cacheManager = DefaultCacheManager();
      final files = await cacheManager.getFileFromCache('');
      return files?.file.lengthSync() ?? 0;
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error getting cache size: $e');
      return 0;
    }
  }
}