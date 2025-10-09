import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

/// Widget لعرض صورة الملف الشخصي مع إمكانية التكبير
class ZoomableProfileImage extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  final Color? backgroundColor;

  const ZoomableProfileImage({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => _downloadImage(context),
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        heroAttributes: heroTag != null 
          ? PhotoViewHeroAttributes(tag: heroTag!)
          : null,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3.0,
        backgroundDecoration: BoxDecoration(
          color: backgroundColor ?? Colors.black,
        ),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null 
              ? null 
              : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            color: Colors.white,
          ),
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'فشل في تحميل الصورة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// تحميل الصورة إلى الجهاز
  void _downloadImage(BuildContext context) {
    // يمكن إضافة منطق تحميل الصورة هنا
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ميزة التحميل ستكون متاحة قريباً'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// عرض الصورة في نافذة منبثقة
  static void show(
    BuildContext context, 
    String imageUrl, {
    String? heroTag,
    Color? backgroundColor,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: ZoomableProfileImage(
              imageUrl: imageUrl,
              heroTag: heroTag,
              backgroundColor: backgroundColor,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

/// Widget للصورة الشخصية القابلة للنقر والتكبير
class TappableProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String? initials;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool enableZoom;

  const TappableProfileAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.initials,
    this.backgroundColor,
    this.onTap,
    this.enableZoom = true,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'profile_avatar_${imageUrl ?? initials}';
    
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (enableZoom && imageUrl != null && imageUrl!.isNotEmpty) {
          ZoomableProfileImage.show(
            context, 
            imageUrl!,
            heroTag: heroTag,
          );
        }
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => _buildInitialsWidget(),
      );
    } else {
      return _buildInitialsWidget();
    }
  }

  Widget _buildInitialsWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor ?? Colors.blue,
            (backgroundColor ?? Colors.blue).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials ?? '؟',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}