import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Status badge widget for displaying various status types
class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;
  final StatusSize size;
  final bool showIcon;
  final IconData? customIcon;
  final Color? customColor;
  final Color? customBackgroundColor;
  final EdgeInsetsGeometry? padding;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
    this.size = StatusSize.medium,
    this.showIcon = true,
    this.customIcon,
    this.customColor,
    this.customBackgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();
    
    return Container(
      padding: padding ?? _getPadding(),
      decoration: BoxDecoration(
        color: customBackgroundColor ?? config.backgroundColor,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(
          color: (customColor ?? config.color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              customIcon ?? config.icon,
              size: _getIconSize(),
              color: customColor ?? config.color,
            ),
            SizedBox(width: _getSpacing()),
          ],
          Text(
            text,
            style: _getTextStyle().copyWith(
              color: customColor ?? config.color,
            ),
          ),
        ],
      ),
    );
  }

  StatusConfig _getStatusConfig() {
    switch (type) {
      case StatusType.success:
        return StatusConfig(
          color: AppColors.success,
          backgroundColor: AppColors.success.withOpacity(0.1),
          icon: Icons.check_circle,
        );
      case StatusType.warning:
        return StatusConfig(
          color: AppColors.warning,
          backgroundColor: AppColors.warning.withOpacity(0.1),
          icon: Icons.warning,
        );
      case StatusType.error:
        return StatusConfig(
          color: AppColors.error,
          backgroundColor: AppColors.error.withOpacity(0.1),
          icon: Icons.error,
        );
      case StatusType.info:
        return StatusConfig(
          color: AppColors.info,
          backgroundColor: AppColors.info.withOpacity(0.1),
          icon: Icons.info,
        );
      case StatusType.pending:
        return StatusConfig(
          color: AppColors.warning,
          backgroundColor: AppColors.warning.withOpacity(0.1),
          icon: Icons.schedule,
        );
      case StatusType.verified:
        return StatusConfig(
          color: AppColors.success,
          backgroundColor: AppColors.success.withOpacity(0.1),
          icon: Icons.verified,
        );
      case StatusType.unverified:
        return StatusConfig(
          color: AppColors.grey,
          backgroundColor: AppColors.grey.withOpacity(0.1),
          icon: Icons.help_outline,
        );
      case StatusType.rejected:
        return StatusConfig(
          color: AppColors.error,
          backgroundColor: AppColors.error.withOpacity(0.1),
          icon: Icons.cancel,
        );
      case StatusType.active:
        return StatusConfig(
          color: AppColors.success,
          backgroundColor: AppColors.success.withOpacity(0.1),
          icon: Icons.check_circle,
        );
      case StatusType.inactive:
        return StatusConfig(
          color: AppColors.grey,
          backgroundColor: AppColors.grey.withOpacity(0.1),
          icon: Icons.radio_button_unchecked,
        );
      case StatusType.primary:
        return StatusConfig(
          color: AppColors.primary,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          icon: Icons.star,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case StatusSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case StatusSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case StatusSize.large:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case StatusSize.small:
        return 4;
      case StatusSize.medium:
        return 6;
      case StatusSize.large:
        return 8;
    }
  }

  double _getIconSize() {
    switch (size) {
      case StatusSize.small:
        return 12;
      case StatusSize.medium:
        return 16;
      case StatusSize.large:
        return 20;
    }
  }

  double _getSpacing() {
    switch (size) {
      case StatusSize.small:
        return 4;
      case StatusSize.medium:
        return 6;
      case StatusSize.large:
        return 8;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case StatusSize.small:
        return AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        );
      case StatusSize.medium:
        return AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        );
      case StatusSize.large:
        return AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }
}

/// Profile verification status badge
class ProfileStatusBadge extends StatelessWidget {
  final String status;
  final StatusSize size;

  const ProfileStatusBadge({
    super.key,
    required this.status,
    this.size = StatusSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getProfileStatusConfig(status);
    
    return StatusBadge(
      text: config.text,
      type: config.type,
      size: size,
      customIcon: config.icon,
    );
  }

  ProfileStatusConfig _getProfileStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'موثق':
        return ProfileStatusConfig(
          text: 'موثق',
          type: StatusType.verified,
          icon: Icons.verified_user,
        );
      case 'pending':
      case 'تحت المراجعة':
        return ProfileStatusConfig(
          text: 'تحت المراجعة',
          type: StatusType.pending,
          icon: Icons.schedule,
        );
      case 'rejected':
      case 'مرفوض':
        return ProfileStatusConfig(
          text: 'مرفوض',
          type: StatusType.rejected,
          icon: Icons.cancel,
        );
      case 'unverified':
      case 'غير موثق':
      default:
        return ProfileStatusConfig(
          text: 'غير موثق',
          type: StatusType.unverified,
          icon: Icons.help_outline,
        );
    }
  }
}

/// Document status badge
class DocumentStatusBadge extends StatelessWidget {
  final String status;
  final StatusSize size;

  const DocumentStatusBadge({
    super.key,
    required this.status,
    this.size = StatusSize.small,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getDocumentStatusConfig(status);
    
    return StatusBadge(
      text: config.text,
      type: config.type,
      size: size,
      customIcon: config.icon,
    );
  }

  DocumentStatusConfig _getDocumentStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'معتمد':
        return DocumentStatusConfig(
          text: 'معتمد',
          type: StatusType.success,
          icon: Icons.check_circle,
        );
      case 'pending':
      case 'قيد المراجعة':
        return DocumentStatusConfig(
          text: 'قيد المراجعة',
          type: StatusType.pending,
          icon: Icons.schedule,
        );
      case 'rejected':
      case 'مرفوض':
        return DocumentStatusConfig(
          text: 'مرفوض',
          type: StatusType.error,
          icon: Icons.cancel,
        );
      case 'missing':
      case 'مفقود':
        return DocumentStatusConfig(
          text: 'مطلوب',
          type: StatusType.warning,
          icon: Icons.warning,
        );
      case 'uploaded':
      case 'مرفوع':
      default:
        return DocumentStatusConfig(
          text: 'مرفوع',
          type: StatusType.info,
          icon: Icons.upload_file,
        );
    }
  }
}

/// Completion percentage badge
class CompletionBadge extends StatelessWidget {
  final double percentage;
  final StatusSize size;
  final bool showPercentage;

  const CompletionBadge({
    super.key,
    required this.percentage,
    this.size = StatusSize.medium,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getCompletionConfig(percentage);
    final text = showPercentage 
        ? '${percentage.toInt()}% ${config.text}'
        : config.text;
    
    return StatusBadge(
      text: text,
      type: config.type,
      size: size,
      customIcon: config.icon,
    );
  }

  CompletionConfig _getCompletionConfig(double percentage) {
    if (percentage >= 100) {
      return CompletionConfig(
        text: 'مكتمل',
        type: StatusType.success,
        icon: Icons.check_circle,
      );
    } else if (percentage >= 75) {
      return CompletionConfig(
        text: 'شبه مكتمل',
        type: StatusType.info,
        icon: Icons.trending_up,
      );
    } else if (percentage >= 50) {
      return CompletionConfig(
        text: 'متوسط',
        type: StatusType.warning,
        icon: Icons.trending_neutral,
      );
    } else {
      return CompletionConfig(
        text: 'ناقص',
        type: StatusType.error,
        icon: Icons.trending_down,
      );
    }
  }
}

/// Priority badge
class PriorityBadge extends StatelessWidget {
  final String priority;
  final StatusSize size;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.size = StatusSize.small,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getPriorityConfig(priority);
    
    return StatusBadge(
      text: config.text,
      type: config.type,
      size: size,
      customIcon: config.icon,
    );
  }

  PriorityConfig _getPriorityConfig(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'عالي':
        return PriorityConfig(
          text: 'عالي',
          type: StatusType.error,
          icon: Icons.priority_high,
        );
      case 'medium':
      case 'متوسط':
        return PriorityConfig(
          text: 'متوسط',
          type: StatusType.warning,
          icon: Icons.remove,
        );
      case 'low':
      case 'منخفض':
      default:
        return PriorityConfig(
          text: 'منخفض',
          type: StatusType.info,
          icon: Icons.keyboard_arrow_down,
        );
    }
  }
}

// Enums and Config Classes
enum StatusType {
  success,
  warning,
  error,
  info,
  pending,
  verified,
  unverified,
  rejected,
  active,
  inactive,
  primary,
}

enum StatusSize {
  small,
  medium,
  large,
}

class StatusConfig {
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  StatusConfig({
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });
}

class ProfileStatusConfig {
  final String text;
  final StatusType type;
  final IconData icon;

  ProfileStatusConfig({
    required this.text,
    required this.type,
    required this.icon,
  });
}

class DocumentStatusConfig {
  final String text;
  final StatusType type;
  final IconData icon;

  DocumentStatusConfig({
    required this.text,
    required this.type,
    required this.icon,
  });
}

class CompletionConfig {
  final String text;
  final StatusType type;
  final IconData icon;

  CompletionConfig({
    required this.text,
    required this.type,
    required this.icon,
  });
}

class PriorityConfig {
  final String text;
  final StatusType type;
  final IconData icon;

  PriorityConfig({
    required this.text,
    required this.type,
    required this.icon,
  });
}