import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../services/authenticated_image_service.dart';

/// ويدجت لعرض الصور مع المصادقة
class AuthenticatedImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AuthenticatedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AuthenticatedImageWidget> createState() => _AuthenticatedImageWidgetState();
}

class _AuthenticatedImageWidgetState extends State<AuthenticatedImageWidget> {
  Uint8List? _imageData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(AuthenticatedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageData = null;
    });

    try {
      final fullUrl = AuthenticatedImageService.getFullImageUrl(widget.imageUrl);
      debugPrint('🖼️ AuthenticatedImageWidget: Loading image: $fullUrl');

      final imageData = await AuthenticatedImageService.loadImageWithAuth(fullUrl);
      
      if (mounted) {
        setState(() {
          _imageData = imageData;
          _isLoading = false;
          _hasError = imageData == null;
        });
      }
    } catch (e) {
      debugPrint('❌ AuthenticatedImageWidget: Error loading image: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ?? 
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    if (_hasError || _imageData == null) {
      return widget.errorWidget ?? 
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Center(
            child: Icon(Icons.error),
          ),
        );
    }

    return Image.memory(
      _imageData!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}