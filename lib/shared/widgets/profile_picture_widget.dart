import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../services/image_picker_service.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../services/authenticated_image_service.dart';
import '../../services/dio_service.dart';
import '../../services/image_cache_service.dart';
import '../../features/profile/presentation/widgets/zoomable_profile_image.dart';

/// ويدجت عرض وتحديث صورة الملف الشخصي المحسّن
class ProfilePictureWidget extends ConsumerStatefulWidget {
  final String? imageUrl;
  final double size;
  final String? fallbackText;
  final bool showEditIcon;
  final bool enableZoom;
  final VoidCallback? onImageChanged;

  const ProfilePictureWidget({
    super.key,
    this.imageUrl,
    this.size = 120, // زيادة الحجم الافتراضي
    this.fallbackText,
    this.showEditIcon = true,
    this.enableZoom = true,
    this.onImageChanged,
  });

  @override
  ConsumerState<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends ConsumerState<ProfilePictureWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  
  // Cache للـ token لمنع إعادة الطلب المستمر
  String? _cachedToken;
  String? _lastImageUrl;
  bool _isLoadingToken = false;

  @override
  void initState() {
    super.initState();
    
    // إعداد animations
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    // بدء animation الـ glow
    _glowController.repeat(reverse: true);
    
    // تحميل الـ token مسبقاً
    _loadTokenIfNeeded();
  }

  @override
  void didUpdateWidget(ProfilePictureWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // إعادة تحميل الـ token إذا تغير URL الصورة
    final profileState = ref.read(profileProvider);
    final currentImageUrl = profileState.currentProfile?.profilePictureUrl ?? widget.imageUrl;
    
    if (currentImageUrl != _lastImageUrl) {
      _lastImageUrl = currentImageUrl;
      _loadTokenIfNeeded();
    }
  }

  Future<void> _loadTokenIfNeeded() async {
    final profileState = ref.read(profileProvider);
    final currentImageUrl = profileState.currentProfile?.profilePictureUrl ?? widget.imageUrl;
    
    if (currentImageUrl != null && 
        currentImageUrl.isNotEmpty && 
        AuthenticatedImageService.requiresAuthentication(currentImageUrl) &&
        _cachedToken == null &&
        !_isLoadingToken) {
      
      _isLoadingToken = true;
      try {
        final token = await DioService.instance.getAccessToken();
        if (mounted) {
          setState(() {
            _cachedToken = token;
            _isLoadingToken = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoadingToken = false;
          });
        }
        debugPrint('❌ ProfilePictureWidget: Error loading token: $e');
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final isLoading = profileState.isLoading || profileState.isUploadingProfilePicture;
    
    // استخدام الصورة من الحالة الحالية للملف الشخصي إذا كانت متوفرة
    final currentImageUrl = profileState.currentProfile?.profilePictureUrl ?? widget.imageUrl;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _scaleController.forward(),
            onTapUp: (_) {
              _scaleController.reverse();
              _handleTap(currentImageUrl);
            },
            onTapCancel: () => _scaleController.reverse(),
            child: Container(
              width: widget.size,
              height: widget.size,
              child: Stack(
                children: [
                  // الصورة الرئيسية مع التأثيرات
                  _buildMainImage(currentImageUrl, isLoading),
                  
                  // مؤشر التحميل المحسّن
                  if (isLoading || _isLoadingToken) _buildLoadingIndicator(),
                  
                  // أيقونة التعديل المحسّنة
                  if (widget.showEditIcon && !isLoading && !_isLoadingToken)
                    _buildEditIcon(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainImage(String? currentImageUrl, bool isLoading) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Gradient border مع تأثير glow
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: _glowAnimation.value),
                AppColors.primary.withValues(alpha: 0.3),
                Colors.purple.withValues(alpha: _glowAnimation.value * 0.5),
                AppColors.primary.withValues(alpha: 0.6),
              ],
            ),
            boxShadow: [
              // ظل أساسي
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: 2,
              ),
              // تأثير glow
              BoxShadow(
                color: AppColors.primary.withValues(alpha: _glowAnimation.value * 0.4),
                blurRadius: 20,
                offset: const Offset(0, 0),
                spreadRadius: 3,
              ),
            ],
          ),
          padding: const EdgeInsets.all(3), // مساحة للـ border
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildImage(currentImageUrl),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String? currentImageUrl) {
    if (currentImageUrl == null || currentImageUrl.isEmpty) {
      return _buildFallback();
    }
    
    // فحص ما إذا كان URL يحتاج إلى مصادقة
    if (AuthenticatedImageService.requiresAuthentication(currentImageUrl)) {
      // إذا لم يكن لدينا token، عرض fallback
      if (_cachedToken == null) {
        if (!_isLoadingToken) {
          _loadTokenIfNeeded();
        }
        return _buildFallback();
      }
      
      final fullImageUrl = AuthenticatedImageService.getFullImageUrl(currentImageUrl);
      
      return CachedNetworkImage(
        imageUrl: fullImageUrl,
        width: widget.size - 6,
        height: widget.size - 6,
        fit: BoxFit.cover,
        httpHeaders: {
          'Authorization': 'Bearer $_cachedToken',
        },
        placeholder: (context, url) => _buildFallback(),
        errorWidget: (context, url, error) {
          debugPrint('❌ ProfilePictureWidget: Error loading image: $error');
          // إعادة تحميل الـ token في حالة الخطأ
          _cachedToken = null;
          _loadTokenIfNeeded();
          return _buildFallback();
        },
        // استخدام URL كـ key بدلاً من timestamp
        key: ValueKey(currentImageUrl),
        cacheKey: currentImageUrl,
      );
    } else {
      // استخدام التحميل العادي للصور العامة
      return CachedNetworkImage(
        imageUrl: currentImageUrl,
        width: widget.size - 6,
        height: widget.size - 6,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildFallback(),
        errorWidget: (context, url, error) {
          debugPrint('❌ ProfilePictureWidget: Error loading image: $error');
          return _buildFallback();
        },
        key: ValueKey(currentImageUrl),
        cacheKey: currentImageUrl,
      );
    }
  }

  Widget _buildFallback() {
    return Container(
      width: widget.size - 6,
      height: widget.size - 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
            Colors.purple.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: widget.fallbackText != null
            ? Text(
                widget.fallbackText!,
                style: TextStyle(
                  fontSize: widget.size * 0.3,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                Icons.person,
                size: widget.size * 0.4,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.6),
        ),
        child: Center(
          child: SizedBox(
            width: widget.size * 0.3,
            height: widget.size * 0.3,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditIcon() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: widget.size * 0.25,
        height: widget.size * 0.25,
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
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: widget.size * 0.12,
        ),
      ),
    );
  }

  void _handleTap(String? currentImageUrl) {
    if (widget.showEditIcon) {
      _showImagePicker();
    } else if (widget.enableZoom && currentImageUrl != null && currentImageUrl.isNotEmpty) {
      // عرض الصورة بحجم كامل
      final fullImageUrl = AuthenticatedImageService.requiresAuthentication(currentImageUrl)
          ? AuthenticatedImageService.getFullImageUrl(currentImageUrl)
          : currentImageUrl;
      
      ZoomableProfileImage.show(
        context,
        fullImageUrl,
        heroTag: 'profile_picture_${widget.hashCode}',
      );
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ImagePickerBottomSheet(
        onImageSelected: (file) async {
          Navigator.pop(context);
          await _uploadImage(file);
          widget.onImageChanged?.call();
        },
      ),
    );
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final profileState = ref.read(profileProvider);
      final oldImageUrl = profileState.currentProfile?.profilePictureUrl;
      
      // مسح الـ cache للصورة القديمة قبل رفع الجديدة
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await ImageCacheService.evictImage(oldImageUrl);
        debugPrint('🗑️ ProfilePictureWidget: Cleared cache for old image: $oldImageUrl');
      }
      
      // مسح الـ token المخزن مؤقتاً لإعادة تحميله
      _cachedToken = null;
      
      await ref.read(profileProvider.notifier).uploadProfilePicture(imageFile);
      
      // التحقق من حالة الرفع
      final updatedState = ref.read(profileProvider);
      if (updatedState.successMessage != null) {
        // مسح الـ cache للصورة الجديدة للتأكد من إعادة التحميل
        final newImageUrl = updatedState.currentProfile?.profilePictureUrl;
        if (newImageUrl != null && newImageUrl != oldImageUrl) {
          await ImageCacheService.evictImage(newImageUrl);
          debugPrint('🗑️ ProfilePictureWidget: Cleared cache for new image: $newImageUrl');
          
          // تحديث الـ URL المحفوظ وإعادة تحميل الـ token
          _lastImageUrl = newImageUrl;
          _loadTokenIfNeeded();
        }
        
        // عرض رسالة نجاح
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(updatedState.successMessage!),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else if (updatedState.error != null) {
        // عرض رسالة خطأ
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(updatedState.error!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ ProfilePictureWidget: Error uploading image: $e');
      // عرض رسالة خطأ
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحديث الصورة: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}

/// BottomSheet محسّن لاختيار مصدر الصورة
class _ImagePickerBottomSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  const _ImagePickerBottomSheet({
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFF8F9FA),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مؤشر السحب المحسّن
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // العنوان المحسّن
          Text(
            'اختر صورة الملف الشخصي',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'يمكنك اختيار صورة من الكاميرا أو المعرض',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // خيارات الاختيار المحسّنة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // الكاميرا
              _buildOption(
                context,
                icon: Icons.camera_alt,
                label: 'الكاميرا',
                color: Colors.blue,
                onTap: () => _pickFromCamera(context),
              ),
              
              // المعرض
              _buildOption(
                context,
                icon: Icons.photo_library,
                label: 'المعرض',
                color: Colors.green,
                onTap: () => _pickFromGallery(context),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // زر الإلغاء المحسّن
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          // مساحة إضافية للأجهزة مع notch
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    try {
      final imageFile = await ImagePickerService.pickFromCamera();
      if (imageFile != null) {
        onImageSelected(imageFile);
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
      final imageFile = await ImagePickerService.pickFromGallery();
      if (imageFile != null) {
        onImageSelected(imageFile);
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