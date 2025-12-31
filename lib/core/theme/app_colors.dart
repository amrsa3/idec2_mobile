import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Conference Red
  static const Color primary = Color(0xFFD32F2F); // Red
  static const Color primaryLight = Color(0xFFEF5350);
  static const Color primaryDark = Color(0xFFB71C1C);

  // Secondary Colors - Conference Black
  static const Color secondary = Color(0xFF212121); // Black
  static const Color secondaryLight = Color(0xFF424242);
  static const Color secondaryDark = Color(0xFF000000);

  // Accent Colors - Conference White/Gray
  static const Color accent = Color(0xFF757575); // Gray
  static const Color accentLight = Color(0xFF9E9E9E);
  static const Color accentDark = Color(0xFF424242);

  // Background Colors - Light Mode
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color lightGray = Color(0xFFE0E0E0);
  
  // Background Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color cardDark = Color(0xFF252525);

  // Text Colors - Light Mode
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Text Colors - Dark Mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color textHintDark = Color(0xFF666666);

  // Additional Colors
  static const Color grey = Color(0xFF9E9E9E);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Border Colors - Light Mode
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFBDBDBD);
  static const Color borderFocus = Color(0xFF2196F3);
  static const Color borderError = Color(0xFFF44336);
  
  // Border Colors - Dark Mode
  static const Color borderDarkMode = Color(0xFF424242);
  static const Color borderLightDarkMode = Color(0xFF333333);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x26000000);

  // Verification Status Colors
  static const Color verified = Color(0xFF4CAF50);
  static const Color unverified = Color(0xFFFF9800);
  static const Color underReview = Color(0xFF2196F3);
  static const Color rejected = Color(0xFFF44336);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Helper class for theme-aware colors
/// Use this to get colors that automatically adapt to light/dark mode
class ThemeColors {
  final BuildContext context;
  
  ThemeColors(this.context);
  
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  
  // Background colors
  Color get background => isDark ? AppColors.backgroundDark : AppColors.background;
  Color get surface => isDark ? AppColors.surfaceDark : AppColors.surface;
  Color get surfaceVariant => isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;
  Color get card => isDark ? AppColors.cardDark : AppColors.surface;
  
  // Text colors
  Color get textPrimary => isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get textSecondary => isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get textTertiary => isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
  Color get textHint => isDark ? AppColors.textHintDark : AppColors.textHint;
  
  // Border colors
  Color get border => isDark ? AppColors.borderDarkMode : AppColors.border;
  Color get borderLight => isDark ? AppColors.borderLightDarkMode : AppColors.borderLight;
  
  // Shadow colors
  Color get shadow => isDark ? Colors.black54 : AppColors.shadow;
  
  // Icon colors
  Color get iconPrimary => isDark ? Colors.white : AppColors.textPrimary;
  Color get iconSecondary => isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  
  // Container colors  
  Color get containerBackground => isDark 
      ? Colors.white.withOpacity(0.08) 
      : Colors.white;
  Color get containerBackgroundElevated => isDark 
      ? Colors.white.withOpacity(0.12) 
      : Colors.white;
}

/// Extension on BuildContext for easy access to theme colors
extension ThemeColorsExtension on BuildContext {
  ThemeColors get colors => ThemeColors(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
