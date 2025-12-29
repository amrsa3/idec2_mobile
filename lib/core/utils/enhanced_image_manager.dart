import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Enhanced Image Cache Manager
/// Provides optimized image loading with caching and error handling
class EnhancedImageManager {
  static final EnhancedImageManager _instance = EnhancedImageManager._internal();
  static EnhancedImageManager get instance => _instance;
  EnhancedImageManager._internal();

  // Configuration
  static const int maxCacheSize = 100; // Max images in memory cache
  static const Duration cacheExpiry = Duration(hours: 24);
  
  // Memory cache for loaded images
  final Map<String, _CachedImage> _memoryCache = {};
  
  // Track failed URLs to avoid repeated attempts
  final Set<String> _failedUrls = {};

  /// Check if URL is valid for loading
  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (!url.startsWith('http://') && !url.startsWith('https://')) return false;
    if (_failedUrls.contains(url)) return false;
    return true;
  }

  /// Mark URL as failed
  void markAsFailed(String url) {
    _failedUrls.add(url);
    // Clear after some time to allow retry
    Future.delayed(const Duration(minutes: 30), () {
      _failedUrls.remove(url);
    });
  }

  /// Clear failed URLs cache
  void clearFailedUrls() {
    _failedUrls.clear();
  }

  /// Build optimized network image with fallback
  Widget buildNetworkImage({
    required String? imageUrl,
    required Widget Function() fallbackBuilder,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    if (!isValidImageUrl(imageUrl)) {
      return fallbackBuilder();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        // Optimize image loading
        cacheWidth: width != null ? (width * 2).toInt() : null,
        cacheHeight: height != null ? (height * 2).toInt() : null,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: borderRadius,
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          markAsFailed(imageUrl);
          if (kDebugMode) {
            debugPrint('⚠️ [ImageManager] Failed to load: $imageUrl');
          }
          return fallbackBuilder();
        },
      ),
    );
  }

  /// Build avatar with fallback to letter
  Widget buildAvatar({
    required String? imageUrl,
    required String name,
    required double size,
    Color? backgroundColor,
    Color? textColor,
    BorderRadius? borderRadius,
  }) {
    final fallbackColor = backgroundColor ?? Colors.grey.shade400;
    final fallbackTextColor = textColor ?? Colors.white;
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    Widget fallback() => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: fallbackColor,
            borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: fallbackTextColor,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

    return buildNetworkImage(
      imageUrl: imageUrl,
      fallbackBuilder: fallback,
      width: size,
      height: size,
      borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
    );
  }

  /// Build gradient avatar with image or letter fallback
  Widget buildGradientAvatar({
    required String? imageUrl,
    required String name,
    required double size,
    required List<Color> gradientColors,
    BorderRadius? borderRadius,
  }) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final radius = borderRadius ?? BorderRadius.circular(size / 4);

    Widget fallback() => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: radius,
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

    if (!isValidImageUrl(imageUrl)) {
      return fallback();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: radius,
      ),
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.network(
          imageUrl!,
          width: size - 4,
          height: size - 4,
          fit: BoxFit.cover,
          cacheWidth: (size * 2).toInt(),
          cacheHeight: (size * 2).toInt(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return fallback();
          },
          errorBuilder: (context, error, stackTrace) {
            markAsFailed(imageUrl);
            return fallback();
          },
        ),
      ),
    );
  }

  /// Preload images
  Future<void> preloadImages(BuildContext context, List<String> urls) async {
    for (final url in urls) {
      if (isValidImageUrl(url)) {
        try {
          await precacheImage(NetworkImage(url), context);
        } catch (e) {
          markAsFailed(url);
        }
      }
    }
  }

  /// Clear memory cache
  void clearCache() {
    _memoryCache.clear();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'memoryCacheSize': _memoryCache.length,
      'failedUrlsCount': _failedUrls.length,
      'imageCacheSize': PaintingBinding.instance.imageCache.currentSize,
      'imageCacheSizeBytes': PaintingBinding.instance.imageCache.currentSizeBytes,
    };
  }
}

class _CachedImage {
  final ImageProvider provider;
  final DateTime cachedAt;

  _CachedImage(this.provider, this.cachedAt);

  bool get isExpired =>
      DateTime.now().difference(cachedAt) > EnhancedImageManager.cacheExpiry;
}

// Global instance for easy access
final imageManager = EnhancedImageManager.instance;
