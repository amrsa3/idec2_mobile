import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// زر مع مؤشر تحميل
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? icon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? loadingText;

  const LoadingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    final bool buttonEnabled = isEnabled && !isLoading && onPressed != null;
    
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: buttonEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonEnabled 
              ? (backgroundColor ?? AppColors.primary)
              : (disabledBackgroundColor ?? AppColors.primary.withValues(alpha: 0.3)),
          foregroundColor: buttonEnabled
              ? (foregroundColor ?? Colors.white)
              : (disabledForegroundColor ?? Colors.white.withValues(alpha: 0.7)),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          elevation: buttonEnabled ? 2 : 0,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? _buildLoadingContent()
              : _buildNormalContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              foregroundColor ?? Colors.white,
            ),
          ),
        ),
        if (loadingText != null) ...[
          const SizedBox(width: 8),
          Text(
            loadingText!,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNormalContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w600,
      ),
    );
  }
}

/// زر تحميل مخصص للحفظ
class SaveLoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final String? customText;
  final String? customLoadingText;

  const SaveLoadingButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.customText,
    this.customLoadingText,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      text: customText ?? 'حفظ التغييرات',
      loadingText: customLoadingText ?? 'جاري الحفظ...',
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      width: double.infinity,
      height: 50,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.save_outlined, size: 20),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}

/// زر تحميل مخصص للإرسال
class SubmitLoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final String? customText;
  final String? customLoadingText;

  const SubmitLoadingButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.customText,
    this.customLoadingText,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
      text: customText ?? 'إرسال',
      loadingText: customLoadingText ?? 'جاري الإرسال...',
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      backgroundColor: AppColors.success,
      foregroundColor: Colors.white,
      width: double.infinity,
      height: 50,
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.send_outlined, size: 20),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
