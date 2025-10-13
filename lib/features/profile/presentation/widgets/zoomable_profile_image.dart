import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../shared/widgets/authenticated_image_widget.dart';

/// Widget لعرض صورة الملف الشخصي مع إمكانية التكبير
class ZoomableProfileImage extends StatefulWidget {
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
  State<ZoomableProfileImage> createState() => _ZoomableProfileImageState();
}

class _ZoomableProfileImageState extends State<ZoomableProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black,
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
        imageProvider: CachedNetworkImageProvider(widget.imageUrl),
        heroAttributes: widget.heroTag != null
            ? PhotoViewHeroAttributes(tag: widget.heroTag!)
            : null,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3.0,
        backgroundDecoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.black,
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
  static void _downloadImage(BuildContext context) {
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
class TappableProfileAvatar extends StatefulWidget {
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
  State<TappableProfileAvatar> createState() => _TappableProfileAvatarState();
}

class _TappableProfileAvatarState extends State<TappableProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    final heroTag = 'profile_avatar_${widget.imageUrl ?? widget.initials}';

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else if (widget.enableZoom &&
            widget.imageUrl != null &&
            widget.imageUrl!.isNotEmpty) {
          _ZoomableProfileImageState.show(
            context,
            widget.imageUrl!,
            heroTag: heroTag,
          );
        }
      },
      child: Hero(
        tag: heroTag,
        child: Container(
          width: widget.size,
          height: widget.size,
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
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      // Ensure the URL is complete
      String fullImageUrl = widget.imageUrl!;
      if (!fullImageUrl.startsWith('http')) {
        fullImageUrl = '${ApiConstants.baseUrl}${widget.imageUrl}';
      }

      return AuthenticatedImageWidget(
        imageUrl: fullImageUrl,
        fit: BoxFit.cover,
        placeholder: Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: _buildInitialsWidget(),
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
            widget.backgroundColor ?? Colors.blue,
            (widget.backgroundColor ?? Colors.blue).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          widget.initials ?? '؟',
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
