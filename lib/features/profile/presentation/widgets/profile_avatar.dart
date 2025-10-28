import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/models.dart';

/// Profile avatar widget that displays user's profile picture or initials
class ProfileAvatar extends StatelessWidget {
  final User user;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool showOnlineIndicator;
  final bool isOnline;

  const ProfileAvatar({
    super.key,
    required this.user,
    this.size = 40,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
    this.onTap,
    this.showOnlineIndicator = false,
    this.isOnline = false,
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildAvatarContent(),
            ),
          ),
          
          // Online indicator
          if (showOnlineIndicator)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    // UserProfileModel doesn't have profilePictureUrl, use user.profilePictureUrl instead
    final profilePictureUrl = user.profilePictureUrl;
    
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profilePictureUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) => _buildInitials(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
      );
    }
    
    return _buildInitials();
  }

  /// بناء placeholder مع تأثير shimmer
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
    final initials = _getInitials();
    final fontSize = size * 0.4;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getBackgroundColor(),
            _getBackgroundColor().withValues(alpha: 0.8),
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
          child: Text(initials),
        ),
      ),
    );
  }

  String _getInitials() {
    // Try to get initials from user names
    final fullNameAr = user.fullNameAr;
    final fullNameEn = user.fullNameEn;
    final firstName = user.firstName;
    final lastName = user.lastName;
    final phone = user.phone;
    
    // Try Arabic name first
    if (fullNameAr != null && fullNameAr.isNotEmpty) {
      final parts = fullNameAr.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}';
      } else if (parts.isNotEmpty) {
        return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1);
      }
    }
    
    // Try English name
    if (fullNameEn != null && fullNameEn.isNotEmpty) {
      final parts = fullNameEn.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}';
      } else if (parts.isNotEmpty) {
        return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1);
      }
    }
    
    // Try first and last name
    if (firstName != null && firstName.isNotEmpty && lastName != null && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}';
    } else if (firstName != null && firstName.isNotEmpty) {
      return firstName.substring(0, firstName.length >= 2 ? 2 : 1);
    }
    
    // Fallback to phone number
    if (phone.isNotEmpty) {
      return phone.substring(phone.length - 2);
    }
    
    return 'U'; // Ultimate fallback
  }

  Color _getBackgroundColor() {
    // Generate a color based on user ID or phone number
    final identifier = user.id;
    final hash = identifier.hashCode;
    
    const colors = [
      AppColors.primary,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    
    return colors[hash.abs() % colors.length];
  }
}

/// Large profile avatar for profile screens
class LargeProfileAvatar extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const LargeProfileAvatar({
    super.key,
    required this.user,
    this.onTap,
    this.showEditIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfileAvatar(
          user: user,
          size: 120,
          showBorder: true,
          borderColor: AppColors.primary,
          borderWidth: 3,
          onTap: onTap,
        ),
        
        if (showEditIcon)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
      ],
    );
  }
}

/// Small profile avatar for lists and compact displays
class SmallProfileAvatar extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const SmallProfileAvatar({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileAvatar(
      user: user,
      size: 32,
      onTap: onTap,
    );
  }
}

/// Profile avatar with status indicator
class ProfileAvatarWithStatus extends StatelessWidget {
  final User user;
  final double size;
  final VoidCallback? onTap;

  const ProfileAvatarWithStatus({
    super.key,
    required this.user,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfileAvatar(
          user: user,
          size: size,
          onTap: onTap,
        ),
        
        // Verification status indicator
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Icon(
              _getStatusIcon(),
              color: Colors.white,
              size: size * 0.15,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    // For now, return grey as default since we don't have verification status in UserModel
    return Colors.grey;
  }

  IconData _getStatusIcon() {
    // For now, return help_outline as default since we don't have verification status in UserModel
    return Icons.help_outline;
  }
}
