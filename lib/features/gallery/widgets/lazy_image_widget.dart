import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Lazy Image Widget with caching and placeholder
class LazyImageWidget extends StatelessWidget {
  final String imageUrl;
  final String? placeholderUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final bool useThumbnail;

  const LazyImageWidget({
    super.key,
    required this.imageUrl,
    this.placeholderUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.useThumbnail = true,
  });

  @override
  Widget build(BuildContext context) {
    final url = useThumbnail && placeholderUrl != null ? placeholderUrl! : imageUrl;

    Widget image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 40,
            ),
          ),
      memCacheWidth: width != null ? width!.toInt() : null,
      memCacheHeight: height != null ? height!.toInt() : null,
    );

    // Load full image in background if using thumbnail
    if (useThumbnail && placeholderUrl != null && placeholderUrl != imageUrl) {
      // Preload full image
      CachedNetworkImage.evictFromCache(imageUrl);
      CachedNetworkImage(
        imageUrl: imageUrl,
        memCacheWidth: width != null ? width!.toInt() : null,
        memCacheHeight: height != null ? height!.toInt() : null,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}

/// Lazy Image Grid Item for gallery
class LazyImageGridItem extends StatelessWidget {
  final String imageUrl;
  final String? thumbnailUrl;
  final VoidCallback? onTap;
  final double aspectRatio;

  const LazyImageGridItem({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    this.onTap,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LazyImageWidget(
        imageUrl: imageUrl,
        placeholderUrl: thumbnailUrl,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
        useThumbnail: true,
      ),
    );
  }
}
















