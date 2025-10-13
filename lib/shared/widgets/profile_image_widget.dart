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
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return AuthenticatedImageWidget(
        imageUrl: widget.imageUrl!,
        fit: BoxFit.cover,
        placeholder: _buildPlaceholder(),
        errorWidget: _buildFallback(),
      );
    }
    return _buildFallback();
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

      debugPrint(
          '📸 Starting image picker for ${source == ImageSource.camera ? 'camera' : 'gallery'}');

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
        debugPrint('✅ Image selected successfully: ${image.name}');
        // رفع الصورة
        await _uploadImage(image);
      } else {
        debugPrint('❌ No image selected');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء اختيار الصورة: ${e.toString()}';
      });
      _showErrorSnackBar(_errorMessage!);
    }
  }

  /// طلب الأذونات المطلوبة - يدعم الويب والموبايل
  Future<bool> _requestPermission(ImageSource source) async {
    try {
      // في الويب لا نحتاج أذونات
      if (kIsWeb) {
        debugPrint('🌐 Web: No permissions needed');
        return true;
      }

      if (source == ImageSource.camera) {
        debugPrint('📷 Requesting camera permission...');
        final status = await Permission.camera.request();
        debugPrint('📷 Camera permission result: $status');
        return status.isGranted;
      } else {
        debugPrint('🖼️ Requesting gallery permission...');

        if (Platform.isAndroid) {
          // للأندرويد - جرب photos أولاً
          final photosStatus = await Permission.photos.request();
          debugPrint('📱 Photos permission result: $photosStatus');
          if (photosStatus.isGranted) return true;

          // إذا فشل، جرب storage
          final storageStatus = await Permission.storage.request();
          debugPrint('📱 Storage permission result: $storageStatus');
          return storageStatus.isGranted;
        } else {
          // لـ iOS
          final status = await Permission.photos.request();
          debugPrint('🍎 iOS photos permission result: $status');
          return status.isGranted;
        }
      }
    } catch (e) {
      debugPrint('❌ Error requesting permission: $e');
      return false;
    }
  }

  /// رفع الصورة - يدعم الويب والموبايل
  Future<void> _uploadImage(XFile imageFile) async {
    try {
      debugPrint('📤 Starting image upload...');

      if (kIsWeb) {
        debugPrint('🌐 Web: Uploading image file');
        // للويب - استخدم XFile مباشرة
        await ref
            .read(profileProvider.notifier)
            .uploadProfilePicture(imageFile);
      } else {
        debugPrint('📱 Mobile: Converting to File and uploading');
        // للموبايل - حول إلى File
        final file = File(imageFile.path);
        await ref.read(profileProvider.notifier).uploadProfilePicture(file);
      }

      debugPrint('✅ Image uploaded successfully');

      // تحديث الواجهة
      setState(() {
        _isLoading = false;
      });

      // إشعار النجاح
      _showSuccessSnackBar('تم رفع الصورة بنجاح');

      // استدعاء callback إذا كان موجود
      widget.onImageChanged?.call();
    } catch (e) {
      debugPrint('❌ Error uploading image: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ أثناء رفع الصورة: ${e.toString()}';
      });
      _showErrorSnackBar(_errorMessage!);
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
