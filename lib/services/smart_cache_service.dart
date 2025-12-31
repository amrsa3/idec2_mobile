import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'platform_storage_service.dart';

/// خدمة التخزين المؤقت الذكي
/// تخزين البيانات محلياً مع انتهاء صلاحية محددة
class SmartCacheService {
  static SmartCacheService? _instance;
  static SmartCacheService get instance => _instance ??= SmartCacheService._();

  SmartCacheService._();

  static const String _cachePrefix = 'cache_';
  static const String _expiryPrefix = 'cache_expiry_';

  /// حفظ بيانات في الكاش مع انتهاء صلاحية
  Future<void> set<T>(
    String key,
    T data, {
    Duration expiry = const Duration(hours: 1),
  }) async {
    try {
      final storage = PlatformStorageService.instance;
      final cacheKey = '$_cachePrefix$key';
      final expiryKey = '$_expiryPrefix$key';

      // حفظ البيانات
      String dataString;
      if (data is String) {
        dataString = data;
      } else if (data is Map || data is List) {
        dataString = jsonEncode(data);
      } else {
        dataString = data.toString();
      }

      await storage.setString(cacheKey, dataString);

      // حفظ وقت انتهاء الصلاحية
      final expiryTime = DateTime.now().add(expiry).toIso8601String();
      await storage.setString(expiryKey, expiryTime);

      debugPrint('✅ [CACHE] Saved: $key (expires in ${expiry.inMinutes} minutes)');
    } catch (e) {
      debugPrint('❌ [CACHE] Error saving: $e');
    }
  }

  /// الحصول على بيانات من الكاش
  /// يُرجع null إذا انتهت الصلاحية أو لم توجد البيانات
  Future<String?> get(String key) async {
    try {
      final storage = PlatformStorageService.instance;
      final cacheKey = '$_cachePrefix$key';
      final expiryKey = '$_expiryPrefix$key';

      // التحقق من وجود وقت صلاحية
      final expiryString = await storage.getString(expiryKey);
      if (expiryString == null) {
        return null;
      }

      // التحقق من انتهاء الصلاحية
      final expiryTime = DateTime.tryParse(expiryString);
      if (expiryTime == null || DateTime.now().isAfter(expiryTime)) {
        // انتهت الصلاحية - حذف الكاش
        await clear(key);
        debugPrint('⏰ [CACHE] Expired: $key');
        return null;
      }

      // إرجاع البيانات
      final data = await storage.getString(cacheKey);
      debugPrint('✅ [CACHE] Hit: $key');
      return data;
    } catch (e) {
      debugPrint('❌ [CACHE] Error getting: $e');
      return null;
    }
  }

  /// الحصول على بيانات كـ JSON
  Future<T?> getJson<T>(String key) async {
    final data = await get(key);
    if (data == null) return null;

    try {
      return jsonDecode(data) as T;
    } catch (e) {
      debugPrint('❌ [CACHE] Error parsing JSON: $e');
      return null;
    }
  }

  /// الحصول على بيانات أو جلبها إذا لم تكن موجودة
  Future<T> getOrFetch<T>(
    String key,
    Future<T> Function() fetcher, {
    Duration expiry = const Duration(hours: 1),
    T Function(dynamic)? parser,
  }) async {
    // محاولة الحصول من الكاش
    final cachedData = await get(key);
    if (cachedData != null) {
      try {
        if (parser != null) {
          return parser(jsonDecode(cachedData));
        }
        return jsonDecode(cachedData) as T;
      } catch (e) {
        debugPrint('⚠️ [CACHE] Error parsing cached data: $e');
      }
    }

    // جلب البيانات الجديدة
    debugPrint('🔄 [CACHE] Miss: $key - fetching...');
    final freshData = await fetcher();

    // حفظ في الكاش
    await set(key, freshData, expiry: expiry);

    return freshData;
  }

  /// التحقق من وجود بيانات صالحة في الكاش
  Future<bool> has(String key) async {
    return await get(key) != null;
  }

  /// الحصول على وقت انتهاء الصلاحية
  Future<DateTime?> getExpiry(String key) async {
    try {
      final storage = PlatformStorageService.instance;
      final expiryKey = '$_expiryPrefix$key';
      final expiryString = await storage.getString(expiryKey);
      if (expiryString == null) return null;
      return DateTime.tryParse(expiryString);
    } catch (_) {
      return null;
    }
  }

  /// الوقت المتبقي قبل انتهاء الصلاحية
  Future<Duration?> getTimeToLive(String key) async {
    final expiry = await getExpiry(key);
    if (expiry == null) return null;
    final remaining = expiry.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }

  /// مسح بيانات معينة من الكاش
  Future<void> clear(String key) async {
    try {
      final storage = PlatformStorageService.instance;
      await storage.remove('$_cachePrefix$key');
      await storage.remove('$_expiryPrefix$key');
      debugPrint('🗑️ [CACHE] Cleared: $key');
    } catch (e) {
      debugPrint('❌ [CACHE] Error clearing: $e');
    }
  }

  /// مسح جميع الكاش
  Future<void> clearAll() async {
    try {
      final storage = PlatformStorageService.instance;
      final allKeys = await storage.getAllKeys();
      
      for (final key in allKeys) {
        if (key.startsWith(_cachePrefix) || key.startsWith(_expiryPrefix)) {
          await storage.remove(key);
        }
      }
      
      debugPrint('🗑️ [CACHE] All cache cleared');
    } catch (e) {
      debugPrint('❌ [CACHE] Error clearing all: $e');
    }
  }

  /// مسح الكاش المنتهي الصلاحية
  Future<int> clearExpired() async {
    int count = 0;
    try {
      final storage = PlatformStorageService.instance;
      final allKeys = await storage.getAllKeys();
      
      for (final key in allKeys) {
        if (key.startsWith(_expiryPrefix)) {
          final dataKey = key.replaceFirst(_expiryPrefix, '');
          final expiryString = await storage.getString(key);
          if (expiryString != null) {
            final expiryTime = DateTime.tryParse(expiryString);
            if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
              await clear(dataKey);
              count++;
            }
          }
        }
      }
      
      debugPrint('🗑️ [CACHE] Cleared $count expired items');
    } catch (e) {
      debugPrint('❌ [CACHE] Error clearing expired: $e');
    }
    return count;
  }

  /// الحصول على حجم الكاش
  Future<int> getCacheSize() async {
    int size = 0;
    try {
      final storage = PlatformStorageService.instance;
      final allKeys = await storage.getAllKeys();
      
      for (final key in allKeys) {
        if (key.startsWith(_cachePrefix)) {
          final data = await storage.getString(key);
          if (data != null) {
            size += data.length;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [CACHE] Error getting size: $e');
    }
    return size;
  }

  /// الحصول على إحصائيات الكاش
  Future<Map<String, dynamic>> getStats() async {
    final storage = PlatformStorageService.instance;
    final allKeys = await storage.getAllKeys();
    
    int totalItems = 0;
    int expiredItems = 0;
    int totalSize = 0;
    
    for (final key in allKeys) {
      if (key.startsWith(_cachePrefix)) {
        totalItems++;
        final data = await storage.getString(key);
        if (data != null) {
          totalSize += data.length;
        }
      }
      if (key.startsWith(_expiryPrefix)) {
        final expiryString = await storage.getString(key);
        if (expiryString != null) {
          final expiryTime = DateTime.tryParse(expiryString);
          if (expiryTime != null && DateTime.now().isAfter(expiryTime)) {
            expiredItems++;
          }
        }
      }
    }
    
    return {
      'totalItems': totalItems,
      'expiredItems': expiredItems,
      'validItems': totalItems - expiredItems,
      'totalSizeBytes': totalSize,
      'totalSizeKB': (totalSize / 1024).toStringAsFixed(2),
    };
  }
}

/// مدير الكاش للبيانات المحددة
class CacheManager {
  final SmartCacheService _cache = SmartCacheService.instance;
  
  // مفاتيح الكاش المعروفة
  static const String keyProducts = 'products';
  static const String keyCategories = 'categories';
  static const String keyExhibitors = 'exhibitors';
  static const String keySessions = 'sessions';
  static const String keySpeakers = 'speakers';
  static const String keyUserProfile = 'user_profile';
  static const String keyNotifications = 'notifications';

  // مدة الكاش الافتراضية لكل نوع
  static const Map<String, Duration> defaultExpiry = {
    keyProducts: Duration(minutes: 30),
    keyCategories: Duration(hours: 6),
    keyExhibitors: Duration(hours: 1),
    keySessions: Duration(hours: 2),
    keySpeakers: Duration(hours: 4),
    keyUserProfile: Duration(minutes: 15),
    keyNotifications: Duration(minutes: 5),
  };

  /// حفظ مع المدة الافتراضية حسب النوع
  Future<void> saveWithDefaultExpiry(String key, dynamic data) async {
    final expiry = defaultExpiry[key] ?? const Duration(hours: 1);
    await _cache.set(key, data, expiry: expiry);
  }

  /// إلغاء كاش معين عند التحديث
  Future<void> invalidate(String key) async {
    await _cache.clear(key);
  }

  /// إلغاء كل الكاش المتعلق بالمستخدم
  Future<void> invalidateUserData() async {
    await _cache.clear(keyUserProfile);
    await _cache.clear(keyNotifications);
  }

  /// إلغاء كل الكاش المتعلق بالمحتوى
  Future<void> invalidateContentData() async {
    await _cache.clear(keyProducts);
    await _cache.clear(keyCategories);
    await _cache.clear(keyExhibitors);
    await _cache.clear(keySessions);
    await _cache.clear(keySpeakers);
  }
}
