import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Enhanced profile image picker with advanced features
class EnhancedProfileImagePicker extends StatefulWidget {
  final String? imageUrl;
  final Function(File) onImageSelected;
  final Function(String)? onImageDeleted;
  final double size;
  final bool showDeleteOption;
  final bool enableCropping;
  final bool enableCompression;
  final int maxSizeInMB;
  final int imageQuality;

  const EnhancedProfileImagePicker({
    super.key,
    this.imageUrl,
    required this.onImageSelected,
    this.onImageDeleted,
    this.size = 120,
    this.showDeleteOption = true,
    this.enableCropping = true,
    this.enableCompression = true,
    this.maxSizeInMB = 5,
    this.imageQuality = 85,
  });

  @override
  State<EnhancedProfileImagePicker> createState() =>
      _EnhancedProfileImagePickerState();
}

class _EnhancedProfileImagePickerState extends State<EnhancedProfileImagePicker>
    with TickerProviderStateMixin {
  File? _selectedImage;
  bool _isProcessing = false;

  final ImagePicker _picker = ImagePicker();

  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    await _scaleController.forward();
    await _scaleController.reverse();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'اختر مصدر الصورة',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'يمكنك اختيار صورة من الكاميرا أو المعرض',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Options
                  Row(
                    children: [
                      Expanded(
                        child: _buildImageSourceOption(
                          icon: Icons.camera_alt_rounded,
                          label: 'الكاميرا',
                          subtitle: 'التقط صورة جديدة',
                          onTap: () => _pickImage(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImageSourceOption(
                          icon: Icons.photo_library_rounded,
                          label: 'المعرض',
                          subtitle: 'اختر من المعرض',
                          onTap: () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),

                  // Delete option
                  if (widget.showDeleteOption &&
                      (widget.imageUrl != null || _selectedImage != null)) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildDeleteOption(),
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteOption() {
    return GestureDetector(
      onTap: _deleteImage,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'حذف الصورة',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // Close the bottom sheet

    try {
      setState(() {
        _isProcessing = true;
      });

      // طلب الأذونات المطلوبة
      bool hasPermission = await _requestPermissions(source);
      if (!hasPermission) {
        setState(() {
          _isProcessing = false;
        });
        if (mounted) {
          _showErrorSnackBar(
              'يجب منح الأذونات للوصول إلى ${source == ImageSource.camera ? 'الكاميرا' : 'المعرض'}');
        }
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 100, // Keep original quality for processing
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        // Check file size
        final fileSizeInBytes = await imageFile.length();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > widget.maxSizeInMB) {
          if (mounted) {
            _showErrorSnackBar(
                'حجم الصورة كبير جداً. الحد الأقصى ${widget.maxSizeInMB} ميجابايت');
          }
          return;
        }

        File processedImage = imageFile;

        // Crop image if enabled and not on web
        if (widget.enableCropping && !kIsWeb) {
          processedImage = await _cropImage(processedImage) ?? processedImage;
        } else if (kIsWeb) {
          debugPrint('🌐 Web: Skipping image cropping');
        }

        // Compress image if enabled and not on web
        if (widget.enableCompression && !kIsWeb) {
          processedImage =
              await _compressImage(processedImage) ?? processedImage;
        } else if (kIsWeb) {
          debugPrint('🌐 Web: Skipping image compression');
        }

        setState(() {
          _selectedImage = processedImage;
          _isProcessing = false;
        });

        // Trigger callback
        widget.onImageSelected(processedImage);

        // Show success message
        if (mounted) {
          _showSuccessSnackBar('تم اختيار الصورة بنجاح');
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        _showErrorSnackBar('حدث خطأ أثناء اختيار الصورة: $e');
      }
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'قص الصورة',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: 'قص الصورة',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }

  Future<File?> _compressImage(File imageFile) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        quality: widget.imageQuality,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }

  /// طلب الأذونات المطلوبة
  Future<bool> _requestPermissions(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        return status.isGranted;
      } else {
        // للمعرض، نحتاج للتحقق من إصدار Android
        PermissionStatus permission;
        if (Platform.isAndroid) {
          // للأندرويد 13+ نستخدم photos، وللإصدارات الأقدم نستخدم storage
          final androidInfo = await Permission.photos.status;
          if (androidInfo == PermissionStatus.permanentlyDenied) {
            permission = await Permission.storage.request();
          } else {
            permission = await Permission.photos.request();
          }
        } else {
          // لـ iOS
          permission = await Permission.photos.request();
        }
        return permission.isGranted;
      }
    } catch (e) {
      debugPrint('❌ Error requesting permissions: $e');
      return false;
    }
  }

  void _deleteImage() {
    Navigator.of(context).pop(); // Close the bottom sheet

    setState(() {
      _selectedImage = null;
    });

    if (widget.onImageDeleted != null && widget.imageUrl != null) {
      widget.onImageDeleted!(widget.imageUrl!);
    }

    _showSuccessSnackBar('تم حذف الصورة');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_isProcessing) {
      return _buildProcessingWidget();
    }

    if (_selectedImage != null) {
      return _buildSelectedImageWidget();
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return _buildNetworkImageWidget();
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildProcessingWidget() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: widget.size * 0.4,
              height: widget.size * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.image_rounded,
              size: widget.size * 0.2,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImageWidget() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ClipOval(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.file(
                _selectedImage!,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNetworkImageWidget() {
    return ClipOval(
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: _getFullImageUrl(widget.imageUrl!),
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) {
            debugPrint('❌ Error loading image: $error');
            debugPrint('❌ Image URL: ${_getFullImageUrl(widget.imageUrl!)}');
            return _buildDefaultAvatar();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: widget.size * 0.3,
              height: widget.size * 0.3,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.person_rounded,
              size: widget.size * 0.4,
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person_rounded,
        size: widget.size * 0.5,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: _showImageSourceDialog,
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size * 0.3,
                height: widget.size * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  _isProcessing
                      ? Icons.hourglass_empty_rounded
                      : Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: widget.size * 0.15,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Get full image URL
  String _getFullImageUrl(String imageUrl) {
    if (!imageUrl.startsWith('http')) {
      return '${ApiConstants.baseUrl}$imageUrl';
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          _buildImageWidget(),
          if (!_isProcessing) _buildEditButton(),
        ],
      ),
    );
  }
}
