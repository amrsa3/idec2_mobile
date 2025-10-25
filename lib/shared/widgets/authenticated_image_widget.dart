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
  final bool forceReload; // إضافة خاصية لإجبار إعادة التحميل
  final String? reloadKey; // مفتاح إضافي لإجبار إعادة التحميل

  const AuthenticatedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.forceReload = false,
    this.reloadKey,
  });

  @override
  State<AuthenticatedImageWidget> createState() => _AuthenticatedImageWidgetState();
}

class _AuthenticatedImageWidgetState extends State<AuthenticatedImageWidget> {
  Uint8List? _imageData;
  bool _isLoading = true;
  bool _hasError = false;
  String? _lastLoadedUrl; // لتتبع آخر URL تم تحميله
  String? _lastReloadKey; // لتتبع آخر مفتاح إعادة تحميل
  int _reloadCounter = 0; // عداد لإجبار إعادة التحميل

  @override
  void initState() {
    super.initState();
    _lastLoadedUrl = widget.imageUrl;
    _lastReloadKey = widget.reloadKey;
    _loadImage();
  }

  @override
  void didUpdateWidget(AuthenticatedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // إعادة تحميل الصورة في الحالات التالية:
    bool shouldReload = false;
    
    // 1. تغيير URL
    if (oldWidget.imageUrl != widget.imageUrl) {
      debugPrint('🔄 AuthenticatedImageWidget: URL changed from ${oldWidget.imageUrl} to ${widget.imageUrl}');
      shouldReload = true;
    }
    
    // 2. تغيير مفتاح إعادة التحميل
    if (oldWidget.reloadKey != widget.reloadKey) {
      debugPrint('🔄 AuthenticatedImageWidget: Reload key changed from ${oldWidget.reloadKey} to ${widget.reloadKey}');
      shouldReload = true;
    }
    
    // 3. تفعيل forceReload
    if (widget.forceReload && !oldWidget.forceReload) {
      debugPrint('🔄 AuthenticatedImageWidget: Force reload activated');
      shouldReload = true;
    }
    
    // 4. forceReload مفعل ونفس URL (لإجبار إعادة التحميل)
    if (widget.forceReload && widget.imageUrl == _lastLoadedUrl) {
      debugPrint('🔄 AuthenticatedImageWidget: Force reload for same URL');
      shouldReload = true;
    }
    
    if (shouldReload) {
      _reloadCounter++;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageData = null;
    });

    try {
      // مسح cache للصورة الحالية أولاً
      AuthenticatedImageService.clearImageCache(widget.imageUrl);
      
      // إضافة timestamp لتجنب مشاكل cache
      String urlWithTimestamp = widget.imageUrl;
      if (widget.forceReload || _reloadCounter > 0 || widget.reloadKey != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final separator = widget.imageUrl.contains('?') ? '&' : '?';
        urlWithTimestamp = '${widget.imageUrl}${separator}t=$timestamp&reload=$_reloadCounter';
        if (widget.reloadKey != null) {
          urlWithTimestamp += '&key=${widget.reloadKey}';
        }
        debugPrint('🔄 AuthenticatedImageWidget: Added timestamp to URL: $urlWithTimestamp');
      }
      
      final fullUrl = AuthenticatedImageService.getFullImageUrl(urlWithTimestamp);
      debugPrint('🖼️ AuthenticatedImageWidget: Loading image: $fullUrl');

      final imageData = await AuthenticatedImageService.loadImageWithAuth(fullUrl);
      
      if (mounted) {
        setState(() {
          _imageData = imageData;
          _isLoading = false;
          _hasError = imageData == null;
          _lastLoadedUrl = widget.imageUrl; // حفظ URL الأصلي (بدون timestamp)
          _lastReloadKey = widget.reloadKey; // حفظ مفتاح إعادة التحميل
        });
        
        if (imageData != null) {
          debugPrint('✅ AuthenticatedImageWidget: Image loaded successfully for URL: ${widget.imageUrl}');
        } else {
          debugPrint('❌ AuthenticatedImageWidget: Image data is null for URL: ${widget.imageUrl}');
        }
      }
    } catch (e) {
      debugPrint('❌ AuthenticatedImageWidget: Error loading image: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _lastLoadedUrl = null;
          _lastReloadKey = null;
        });
      }
    }
  }

  /// إجبار إعادة تحميل الصورة
  void forceReload() {
    debugPrint('🔄 AuthenticatedImageWidget: Manual force reload triggered');
    _reloadCounter++;
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    // إنشاء مفتاح فريد يتضمن جميع العوامل المؤثرة على الصورة
    final uniqueKey = '${widget.imageUrl}_${widget.reloadKey}_$_reloadCounter${widget.forceReload}';
    
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
      // إضافة key فريد لإجبار إعادة بناء الويدجت
      key: ValueKey(uniqueKey),
    );
  }
}
