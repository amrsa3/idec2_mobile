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
      
      // مسح من CachedNetworkImage cache
      await CachedNetworkImage.evictFromCache(imageUrl);
      
      // مسح من DefaultCacheManager أيضاً
      await DefaultCacheManager().removeFile(imageUrl);
      
      // مسح أي variations للـ URL (مع query parameters)
      final baseUrl = imageUrl.split('?')[0];
      if (baseUrl != imageUrl) {
        await CachedNetworkImage.evictFromCache(baseUrl);
        await DefaultCacheManager().removeFile(baseUrl);
      }
      
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

  /// مسح cache لصورة مع جميع variations المحتملة
  static Future<void> evictImageWithVariations(String imageUrl) async {
    try {
      debugPrint('🗑️ ImageCacheService: Evicting image with variations: $imageUrl');
      
      // مسح الـ URL الأساسي
      await evictImage(imageUrl);
      
      // مسح variations مع timestamps مختلفة
      final baseUrl = imageUrl.split('?')[0];
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // مسح timestamps من آخر دقيقة
      for (int i = 0; i < 60; i++) {
        final timestampUrl = '$baseUrl?t=${now - (i * 1000)}';
        await evictImage(timestampUrl);
      }
      
      debugPrint('✅ ImageCacheService: Successfully evicted image with variations');
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error evicting image variations: $e');
    }
  }

  /// إنشاء مفتاح فريد للصورة
  static String generateUniqueKey(String imageUrl) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${imageUrl}_$timestamp';
  }

  /// إنشاء URL مع timestamp فريد
  static String addTimestampToUrl(String imageUrl) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final separator = imageUrl.contains('?') ? '&' : '?';
    return '$imageUrl${separator}t=$timestamp';
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

  /// مسح cache قديم (أكثر من عدد أيام محدد)
  static Future<void> clearOldCache({int daysOld = 7}) async {
    try {
      debugPrint('🗑️ ImageCacheService: Clearing cache older than $daysOld days');
      
      final cacheManager = DefaultCacheManager();
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      
      // هذا يتطلب تنفيذ مخصص لـ cache manager
      // للآن سنستخدم emptyCache إذا كان الـ cache كبير جداً
      final cacheSize = await getCacheSize();
      if (cacheSize > 100 * 1024 * 1024) { // 100MB
        await cacheManager.emptyCache();
        debugPrint('✅ ImageCacheService: Cleared large cache');
      }
      
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error clearing old cache: $e');
    }
  }

  /// إعادة تحميل صورة معينة
  static Future<void> refreshImage(String imageUrl) async {
    try {
      debugPrint('🔄 ImageCacheService: Refreshing image: $imageUrl');
      
      // مسح من الـ cache أولاً
      await evictImage(imageUrl);
      
      // إضافة timestamp جديد لإجبار إعادة التحميل
      final refreshedUrl = addTimestampToUrl(imageUrl);
      
      debugPrint('✅ ImageCacheService: Image refresh prepared with URL: $refreshedUrl');
    } catch (e) {
      debugPrint('❌ ImageCacheService: Error refreshing image: $e');
    }
  }
}
