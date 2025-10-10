import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../l10n/app_localizations.dart';
import '../../services/image_picker_service.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../shared/widgets/loading_indicator.dart';

/// Widget لعرض وتحديث الصورة الشخصية
class ProfilePictureWidget extends ConsumerStatefulWidget {
  final String? profilePictureUrl;
  final double size;
  final bool isEditable;
  final VoidCallback? onImageUpdated;

  const ProfilePictureWidget({
    super.key,
    this.profilePictureUrl,
    this.size = 120,
    this.isEditable = true,
    this.onImageUpdated,
  });

  @override
  ConsumerState<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends ConsumerState<ProfilePictureWidget> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Stack(
      children: [
        // الصورة الشخصية
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: _buildProfileImage(),
          ),
        ),
        
        // مؤشر التحميل
        if (_isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5),
              ),
              child: const Center(
                child: LoadingIndicator(
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        
        // زر التعديل
        if (widget.isEditable && !_isUploading)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImagePicker,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (widget.profilePictureUrl != null && widget.profilePictureUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.profilePictureUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: LoadingIndicator(size: 30),
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultAvatar(),
      );
    }
    
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: widget.size * 0.6,
        color: Colors.grey[400],
      ),
    );
  }

  Future<void> _showImagePicker() async {
    final localizations = AppLocalizations.of(context)!;
    
    try {
      final imageFile = await ImagePickerService.showImageSourceDialog(context);
      
      if (imageFile != null) {
        // التحقق من صحة الملف
        final validationError = ImagePickerService.validateImageFile(imageFile, context);
        if (validationError != null) {
          _showErrorSnackBar(validationError);
          return;
        }

        // رفع الصورة
        await _uploadProfilePicture(imageFile);
      }
    } catch (e) {
      _showErrorSnackBar(
        localizations.errorSelectingImage ?? 'حدث خطأ أثناء اختيار الصورة'
      );
    }
  }

  Future<void> _uploadProfilePicture(File imageFile) async {
    final localizations = AppLocalizations.of(context)!;
    
    setState(() {
      _isUploading = true;
    });

    try {
      final profileNotifier = ref.read(profileProvider.notifier);
      final success = await profileNotifier.uploadProfilePicture(imageFile);
      
      if (success) {
        _showSuccessSnackBar(
          localizations.profilePictureUpdated ?? 'تم تحديث الصورة الشخصية بنجاح'
        );
        widget.onImageUpdated?.call();
      } else {
        _showErrorSnackBar(
          localizations.errorUploadingImage ?? 'حدث خطأ أثناء رفع الصورة'
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        localizations.errorUploadingImage ?? 'حدث خطأ أثناء رفع الصورة'
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}