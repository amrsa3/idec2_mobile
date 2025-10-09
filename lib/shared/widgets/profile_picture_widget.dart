import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../services/image_picker_service.dart';
import '../../providers/profile_provider.dart';

/// ويدجت عرض وتحديث صورة الملف الشخصي
class ProfilePictureWidget extends ConsumerWidget {
  final String? imageUrl;
  final double size;
  final String? fallbackText;
  final bool showEditIcon;
  final VoidCallback? onImageChanged;

  const ProfilePictureWidget({
    super.key,
    this.imageUrl,
    this.size = 80,
    this.fallbackText,
    this.showEditIcon = true,
    this.onImageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final isLoading = profileState.isLoading;

    return GestureDetector(
      onTap: showEditIcon ? () => _showImagePicker(context, ref) : null,
      child: Stack(
        children: [
          // الصورة الرئيسية
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: _buildImage(),
            ),
          ),

          // مؤشر التحميل
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),

          // أيقونة التعديل
          if (showEditIcon && !isLoading)
            Positioned(
              bottom: 0,
              right: 0,
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

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallback();
        },
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          fallbackText ?? '?',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ImagePickerBottomSheet(
        onImageSelected: (file) async {
          Navigator.pop(context);
          await _uploadImage(ref, file);
          onImageChanged?.call();
        },
      ),
    );
  }

  Future<void> _uploadImage(WidgetRef ref, File imageFile) async {
    try {
      await ref.read(profileProvider.notifier).uploadProfilePicture(imageFile);
      
      // عرض رسالة نجاح
      final context = ref.context;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث صورة الملف الشخصي بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // عرض رسالة خطأ
      final context = ref.context;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحديث الصورة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// BottomSheet لاختيار مصدر الصورة
class _ImagePickerBottomSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const _ImagePickerBottomSheet({
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مؤشر السحب
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // العنوان
          Text(
            'اختر صورة الملف الشخصي',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // خيارات الاختيار
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // الكاميرا
              _buildOption(
                context,
                icon: Icons.camera_alt,
                label: 'الكاميرا',
                onTap: () => _pickFromCamera(context),
              ),
              
              // المعرض
              _buildOption(
                context,
                icon: Icons.photo_library,
                label: 'المعرض',
                onTap: () => _pickFromGallery(context),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // زر الإلغاء
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    try {
      final file = await ImagePickerService.pickFromCamera();
      if (file != null) {
        onImageSelected(file);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في التقاط الصورة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final file = await ImagePickerService.pickFromGallery();
      if (file != null) {
        onImageSelected(file);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في اختيار الصورة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}