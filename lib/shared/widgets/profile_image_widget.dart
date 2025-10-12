import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/theme/app_colors.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../services/dio_service.dart';

/// Widget احترافي لعرض وتعديل صورة الملف الشخصي
/// يتضمن أدوات الاقتصاص والتعديل والرفع الآمن
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

class _ProfileImageWidgetState extends ConsumerState<ProfileImageWidget>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// عرض خيارات اختيار الصورة
  Future<void> _showImageSourceDialog() async {
    if (!widget.isEditable) return;

    await showModalBottomSheet(
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
              Text(
                'اختر مصدر الصورة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _buildImageSourceOption(
                icon: Icons.camera_alt,
                title: 'الكاميرا',
                subtitle: 'التقط صورة جديدة',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              _buildImageSourceOption(
                icon: Icons.photo_library,
                title: 'المعرض',
                subtitle: 'اختر من الصور المحفوظة',
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (widget.imageUrl != null)
                _buildImageSourceOption(
                  icon: Icons.delete,
                  title: 'حذف الصورة',
                  subtitle: 'إزالة الصورة الحالية',
                  onTap: () {
                    Navigator.pop(context);
                    _removeImage();
                  },
                  isDestructive: true,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء خيار مصدر الصورة
  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  /// اختيار الصورة من المصدر المحدد
  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _errorMessage = null;
      });

      // طلب الأذونات
      bool hasPermission = await _requestPermissions(source);
      if (!hasPermission) {
        setState(() {
          _errorMessage = 'يجب منح الأذونات للوصول إلى ${source == ImageSource.camera ? 'الكاميرا' : 'المعرض'}';
        });
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _cropAndUploadImage(image.path);
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      setState(() {
        _errorMessage = 'حدث خطأ أثناء اختيار الصورة';
      });
    }
  }

  /// طلب الأذونات المطلوبة
  Future<bool> _requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      return status.isGranted;
    } else {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  /// اقتصاص ورفع الصورة
  Future<void> _cropAndUploadImage(String imagePath) async {
    try {
      // اقتصاص الصورة
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'اقتصاص الصورة',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
            showCropGrid: true,
          ),
          IOSUiSettings(
            title: 'اقتصاص الصورة',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        // ضغط الصورة
        final compressedImage = await _compressImage(croppedFile.path);
        if (compressedImage != null) {
          await _uploadImage(compressedImage);
        }
      }
    } catch (e) {
      debugPrint('❌ Error cropping image: $e');
      setState(() {
        _errorMessage = 'حدث خطأ أثناء معالجة الصورة';
      });
    }
  }

  /// ضغط الصورة
  Future<File?> _compressImage(String imagePath) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        targetPath,
        quality: 80,
        minWidth: 512,
        minHeight: 512,
        format: CompressFormat.jpeg,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      debugPrint('❌ Error compressing image: $e');
      return File(imagePath);
    }
  }

  /// رفع الصورة إلى الخادم
  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final profileNotifier = ref.read(profileProvider.notifier);
      await profileNotifier.uploadProfilePicture(imageFile);
      
      widget.onImageChanged?.call();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم رفع الصورة بنجاح'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error uploading image: $e');
      setState(() {
        _errorMessage = 'فشل في رفع الصورة. يرجى المحاولة مرة أخرى';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// حذف الصورة
  Future<void> _removeImage() async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final profileNotifier = ref.read(profileProvider.notifier);
      await profileNotifier.removeProfilePicture();
      
      widget.onImageChanged?.call();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم حذف الصورة بنجاح'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error removing image: $e');
      setState(() {
        _errorMessage = 'فشل في حذف الصورة. يرجى المحاولة مرة أخرى';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// بناء صورة الملف الشخصي
  Widget _buildProfileImage() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
            ? _buildNetworkImage()
            : _buildFallbackImage(),
      ),
    );
  }

  /// بناء صورة الشبكة
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl!,
      fit: BoxFit.cover,
      httpHeaders: _getAuthHeaders(),
      placeholder: (context, url) => Container(
        color: AppColors.primary.withOpacity(0.1),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        debugPrint('❌ Error loading profile image: $error');
        return _buildFallbackImage();
      },
    );
  }

  /// بناء الصورة الافتراضية
  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: widget.fallbackText.isNotEmpty
            ? Text(
                widget.fallbackText,
                style: TextStyle(
                  fontSize: widget.size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                Icons.person,
                size: widget.size * 0.5,
                color: AppColors.primary,
              ),
      ),
    );
  }

  /// الحصول على headers المصادقة
  Map<String, String> _getAuthHeaders() {
    // سيتم تحديث هذا لاحقاً للحصول على التوكن من DioService
    return {};
  }

  /// بناء أيقونة التعديل
  Widget _buildEditIcon() {
    if (!widget.showEditIcon || !widget.isEditable) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: _showImageSourceDialog,
        child: Container(
          width: widget.size * 0.3,
          height: widget.size * 0.3,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: widget.size * 0.15,
          ),
        ),
      ),
    );
  }

  /// بناء مؤشر التحميل
  Widget _buildLoadingOverlay() {
    if (!_isUploading) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: widget.isEditable ? _showImageSourceDialog : null,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Stack(
                  children: [
                    _buildProfileImage(),
                    _buildEditIcon(),
                    _buildLoadingOverlay(),
                  ],
                ),
              );
            },
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}