import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/constants/api_constants.dart';
import 'dio_service.dart';

/// خدمة لتحميل الصور مع المصادقة
class AuthenticatedImageService {
  // Cache للصور المحملة
  static final Map<String, Uint8List> _imageCache = {};
  
  /// مسح cache صورة معينة
  static void clearImageCache(String imageUrl) {
    final fullUrl = getFullImageUrl(imageUrl);
    
    // مسح جميع الإصدارات المختلفة من نفس URL
    final keysToRemove = <String>[];
    for (final key in _imageCache.keys) {
      if (key.contains(fullUrl) || key.contains(imageUrl)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _imageCache.remove(key);
      debugPrint('🗑️ AuthenticatedImageService: Cleared cache for: $key');
    }
    
    if (keysToRemove.isEmpty) {
      debugPrint('🗑️ AuthenticatedImageService: No cache found for: $fullUrl');
    }
  }
  
  /// مسح cache لجميع الصور المرتبطة بـ URL معين (بما في ذلك الإصدارات المختلفة)
  static void clearImageCacheCompletely(String imageUrl) {
    final baseUrl = imageUrl.split('?')[0]; // إزالة query parameters
    final keysToRemove = <String>[];
    
    for (final key in _imageCache.keys) {
      if (key.contains(baseUrl)) {
        keysToRemove.add(key);
      }
    }
    
    for (final key in keysToRemove) {
      _imageCache.remove(key);
      debugPrint('🗑️ AuthenticatedImageService: Completely cleared cache for: $key');
    }
    
    debugPrint('🗑️ AuthenticatedImageService: Completely cleared ${keysToRemove.length} cache entries for: $baseUrl');
  }
  
  /// مسح جميع cache الصور
  static void clearAllImageCache() {
    final count = _imageCache.length;
    _imageCache.clear();
    debugPrint('🗑️ AuthenticatedImageService: Cleared all image cache ($count entries)');
  }

  /// تحميل الصورة مع رؤوس المصادقة
  static Future<Uint8List?> loadImageWithAuth(String imageUrl) async {
    try {
      debugPrint(
          '🖼️ AuthenticatedImageService: Loading image with auth: $imageUrl');

      final fullUrl = getFullImageUrl(imageUrl);
      
      // فحص cache أولاً (فقط إذا لم يكن URL يحتوي على timestamp أو reload)
      if (!imageUrl.contains('t=') && !imageUrl.contains('reload=') && !imageUrl.contains('key=') && _imageCache.containsKey(fullUrl)) {
        debugPrint('📦 AuthenticatedImageService: Returning cached image for: $fullUrl');
        return _imageCache[fullUrl];
      }

      // الحصول على رمز المصادقة
      final token = await EnhancedDioServiceV2.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint(
            '❌ AuthenticatedImageService: No authentication token found');
        throw Exception('No authentication token available');
      }

      // استخدام EnhancedDioServiceV2.instance.dio للاستفادة من interceptors
      // استخراج fileId من URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      String? fileId;

      // البحث عن fileId في المسار
      for (int i = 0; i < pathSegments.length; i++) {
        if (pathSegments[i] == 'files' && i + 1 < pathSegments.length) {
          fileId = pathSegments[i + 1];
          break;
        }
      }

      if (fileId == null) {
        throw Exception('Invalid file URL format');
      }

      // استخدام endpoint الملفات العام الصحيح
      final profileFileUrl =
          '${ApiConstants.baseUrl}/api/v1/files/$fileId/download';

      final response = await EnhancedDioServiceV2.instance.dio.get(
        profileFileUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Cache-Control': 'no-cache, no-store, must-revalidate', // منع cache
            'Pragma': 'no-cache', // منع cache للمتصفحات القديمة
            'Expires': '0', // انتهاء فوري للـ cache
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ AuthenticatedImageService: Image loaded successfully');
        final imageData = Uint8List.fromList(response.data);
        
        // حفظ في cache فقط إذا لم يكن URL يحتوي على timestamp أو reload أو key
        if (!imageUrl.contains('t=') && !imageUrl.contains('reload=') && !imageUrl.contains('key=')) {
          _imageCache[fullUrl] = imageData;
          debugPrint('📦 AuthenticatedImageService: Cached image for: $fullUrl');
        } else {
          debugPrint('🔄 AuthenticatedImageService: Skipped caching for timestamped/reload URL');
        }
        
        return imageData;
      } else {
        debugPrint(
            '❌ AuthenticatedImageService: Failed to load image: ${response.statusCode}');
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint(
          '❌ AuthenticatedImageService: DioException loading image: ${e.response?.statusCode} - ${e.message}');

      // إذا كان خطأ 401، فهذا يعني مشكلة في المصادقة
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed');
      }

      throw Exception('Failed to load image: ${e.message}');
    } catch (e) {
      debugPrint('❌ AuthenticatedImageService: Error loading image: $e');
      throw Exception('Failed to load image: $e');
    }
  }

  /// تحويل URL النسبي إلى URL مطلق
  static String getFullImageUrl(String relativeUrl) {
    if (relativeUrl.startsWith('http')) {
      return relativeUrl;
    }

    // إزالة الشرطة المائلة في البداية إذا كانت موجودة
    final cleanUrl =
        relativeUrl.startsWith('/') ? relativeUrl.substring(1) : relativeUrl;

    return '${ApiConstants.baseUrl}/$cleanUrl';
  }

  /// فحص ما إذا كان URL يحتاج إلى مصادقة
  static bool requiresAuthentication(String imageUrl) {
    // إذا كان URL يحتوي على endpoint تحميل الملفات، فهو يحتاج مصادقة
    return imageUrl.contains('/api/v1/files/') &&
        imageUrl.contains('/download');
  }
}
