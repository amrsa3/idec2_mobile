import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/authenticated_image_widget.dart';

/// Enhanced profile avatar widget with editing capabilities
class EnhancedProfileAvatar extends StatefulWidget {
  final String? imageUrl;
  final File? imageFile;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final String? initials;
  final bool isLoading;

  const EnhancedProfileAvatar({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.size = 80,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 3,
    this.onTap,
    this.showEditIcon = false,
    this.initials,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Avatar container
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: showBorder
                  ? Border.all(
                      color: borderColor ?? AppColors.primary,
                      width: borderWidth,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildAvatarContent(),
            ),
          ),

          // Loading overlay
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),

          // Edit icon
          if (showEditIcon && !isLoading)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: size * 0.15,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    // Priority: File > URL > Initials
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Ensure the URL is complete
      String fullImageUrl = imageUrl!;
      if (!fullImageUrl.startsWith('http')) {
        // Add base URL if it's a relative path
        fullImageUrl = '${ApiConstants.baseUrl}$imageUrl';
      }

      return AuthenticatedImageWidget(
        imageUrl: fullImageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: _buildShimmerPlaceholder(),
        errorWidget: _buildInitials(),
      );
    }

    return _buildInitials();
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildInitials() {
    final displayInitials = initials ?? 'U';
    final fontSize = size * 0.35;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          displayInitials.toUpperCase(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

/// Profile image picker widget with options
class ProfileImagePicker extends StatelessWidget {
  final String? currentImageUrl;
  final File? selectedImageFile;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onRemovePressed;
  final bool isLoading;

  const ProfileImagePicker({
    super.key,
    this.currentImageUrl,
    this.selectedImageFile,
    this.onCameraPressed,
    this.onGalleryPressed,
    this.onRemovePressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar display
        EnhancedProfileAvatar(
          imageUrl: currentImageUrl,
          imageFile: selectedImageFile,
          size: 120,
          showEditIcon: true,
          isLoading: isLoading,
          onTap: () => _showImagePickerOptions(context),
        ),

        const SizedBox(height: 16),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              icon: Icons.camera_alt,
              label: 'كاميرا',
              onPressed: isLoading ? null : onCameraPressed,
            ),
            const SizedBox(width: 16),
            _buildActionButton(
              icon: Icons.photo_library,
              label: 'معرض',
              onPressed: isLoading ? null : onGalleryPressed,
            ),
            if (currentImageUrl != null || selectedImageFile != null) ...[
              const SizedBox(width: 16),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'حذف',
                onPressed: isLoading ? null : onRemovePressed,
                isDestructive: true,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDestructive
                  ? AppColors.error.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.3),
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'تغيير صورة الملف الشخصي',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Options
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('التقاط صورة'),
              subtitle: const Text('استخدام الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                onCameraPressed?.call();
              },
            ),

            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('اختيار من المعرض'),
              subtitle: const Text('اختيار صورة موجودة'),
              onTap: () {
                Navigator.pop(context);
                onGalleryPressed?.call();
              },
            ),

            if (currentImageUrl != null || selectedImageFile != null)
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                ),
                title: const Text('حذف الصورة'),
                subtitle: const Text('إزالة الصورة الحالية'),
                onTap: () {
                  Navigator.pop(context);
                  onRemovePressed?.call();
                },
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Compact profile avatar for lists
class CompactProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final VoidCallback? onTap;

  const CompactProfileAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedProfileAvatar(
      imageUrl: imageUrl,
      size: size,
      showBorder: false,
      initials: initials,
      onTap: onTap,
    );
  }
}
