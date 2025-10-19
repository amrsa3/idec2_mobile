import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (backgroundColor != null) return backgroundColor!;
      switch (type) {
        case ButtonType.primary:
          return AppColors.primary;
        case ButtonType.secondary:
          return AppColors.secondary;
        case ButtonType.outline:
          return Colors.transparent;
        case ButtonType.text:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (textColor != null) return textColor!;
      switch (type) {
        case ButtonType.primary:
        case ButtonType.secondary:
          return AppColors.textOnPrimary;
        case ButtonType.outline:
          return AppColors.primary;
        case ButtonType.text:
          return AppColors.primary;
      }
    }

    BorderSide getBorderSide() {
      switch (type) {
        case ButtonType.outline:
          return const BorderSide(color: AppColors.primary, width: 1.5);
        default:
          return BorderSide.none;
      }
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 48.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getTextColor(),
          side: getBorderSide(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          elevation: type == ButtonType.primary ? 2.0 : 0.0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18.0),
                    const SizedBox(width: 8.0),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
