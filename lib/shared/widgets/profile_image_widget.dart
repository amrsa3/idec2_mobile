import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_colors.dart';
import '../../features/profile/providers/profile_provider.dart';
import 'authenticated_image_widget.dart';

/// مكون احترافي ومبسط لعرض وتعديل صورة الملف الشخصي
class ProfileImageWidget extends ConsumerStatefulWidget {
  final String? imageUrl;
  final double size;
  final String fallbackText;
  final bool showEditIcon;
  final bool isEditable;
  final VoidCallback? onImageChanged;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    required this.size,
    required this.fallbackText,
    this.showEditIcon = true,
    this.isEditable = true,
    this.onImageChanged,
  });

  @override
  ConsumerState<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends ConsumerState<ProfileImageWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isUploading = false;
  bool _forceImageReload = false;
  int _imageReloadKey = 0;
  String? _currentImageUrl; // لتتبع URL الحالي

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(ProfileImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // إذا تغير URL، قم بتحديث المفتاح لإجبار إعادة التحميل
    if (oldWidget.imageUrl != widget.imageUrl) {
      if (kDebugMode) {
        debugPrint('ProfileImageWidget: Image URL changed');
      }
      setState(() {
        _currentImageUrl = widget.imageUrl;
        _imageReloadKey++;
        _forceImageReload = true;
      });
      
      // إعادة تعيين forceReload بعد فترة قصيرة
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            _forceImageReload = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditable ? _showImageOptions : null,
      child: Stack(
        children: [
          // الصورة الرئيسية
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: _buildImageContent(),
            ),
          ),

          // أيقونة التعديل
          if (widget.showEditIcon && widget.isEditable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),

          // مؤشر التحميل
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// بناء محتوى الصورة
  Widget _buildImageContent() {
    final imageUrl = widget.imageUrl;
    final size = widget.size;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage();
    }

    return AuthenticatedImageWidget(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      forceReload: _forceImageReload,
      reloadKey: '${_imageReloadKey}_${DateTime.now().millisecondsSinceEpoch}', // مفتاح فريد
      key: ValueKey('profile_image_${imageUrl}_${_imageReloadKey}'), // مفتاح فريد للويدجت
      placeholder: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: _buildFallbackImage(),
    );
  }

  /// بناء الصورة الاحتياطية
  Widget _buildFallback() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          widget.fallbackText,
          style: TextStyle(
            fontSize: widget.size * 0.4,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  /// بناء الصورة الاحتياطية (نفس _buildFallback)
  Widget _buildFallbackImage() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.fallbackText,
          style: TextStyle(
            fontSize: widget.size * 0.4,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  /// بناء مؤشر التحميل
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }

  /// عرض خيارات الصورة
  Future<void> _showImageOptions() async {
    if (!widget.isEditable) return;

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // العنوان
              Text(
                'اختر مصدر الصورة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // خيارات الصورة
              _buildOption(
                icon: Icons.camera_alt,
                title: 'الكاميرا',
                subtitle: 'التقط صورة جديدة',
                onTap: () {
                  Navigator.pop(context, 'camera');
                },
              ),
              _buildOption(
                icon: Icons.photo_library,
                title: 'المعرض',
                subtitle: 'اختر من الصور المحفوظة',
                onTap: () {
                  Navigator.pop(context, 'gallery');
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    if (result != null) {
      final source =
          result == 'camera' ? ImageSource.camera : ImageSource.gallery;
      await _pickImage(source);
    }
  }

  /// بناء خيار واحد
  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  /// اختيار الصورة - يدعم الويب والموبايل
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // طلب الأذونات (في الويب لا نحتاج أذونات)
      if (!await _requestPermission(source)) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'يجب منح الأذونات للوصول إلى ${source == ImageSource.camera ? 'الكاميرا' : 'المعرض'}';
        });
        _showErrorSnackBar(_errorMessage!);
        return;
      }

      // اختيار الصورة
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // رفع الصورة
        await _uploadImage(image);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Failed to pick image: $e');
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء اختيار الصورة';
      });
      _showErrorSnackBar(_errorMessage!);
    }
  }

  /// طلب الأذونات المطلوبة - يدعم الويب والموبايل
  Future<bool> _requestPermission(ImageSource source) async {
    try {
      // في الويب لا نحتاج أذونات
      if (kIsWeb) {
        return true;
      }

      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        return status.isGranted;
      } else {
        if (Platform.isAndroid) {
          // للأندرويد - جرب photos أولاً
          final photosStatus = await Permission.photos.request();
          if (photosStatus.isGranted) return true;

          // إذا فشل، جرب storage
          final storageStatus = await Permission.storage.request();
          return storageStatus.isGranted;
        } else {
          // لـ iOS
          final status = await Permission.photos.request();
          return status.isGranted;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Failed to request permission: $e');
      }
      return false;
    }
  }

  /// رفع الصورة - يدعم الويب والموبايل
  Future<void> _uploadImage(XFile imageFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      // رفع الصورة
      final success = await ref.read(profileProvider.notifier).uploadProfilePicture(imageFile);
      
      if (success) {
        // إجبار إعادة تحميل الصورة فوراً
        setState(() {
          _forceImageReload = true;
          _imageReloadKey++;
        });
        
        // إعادة تعيين forceReload بعد فترة قصيرة
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _forceImageReload = false;
            });
          }
        });

        // إظهار رسالة نجاح
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث صورة الملف الشخصي بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل في تحديث صورة الملف الشخصي'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          debugPrint('ERROR: Failed to upload image: $e');
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('خطأ في رفع الصورة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// عرض رسالة نجاح
  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// عرض رسالة خطأ
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
