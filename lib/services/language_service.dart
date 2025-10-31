import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _firstLaunchKey = 'is_first_launch';
  static const String _languageFirstTimeKey = 'language_first_time';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Get the saved language from SharedPreferences
  static Future<Locale> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
    
    if (isFirstLaunch) {
      // First launch - detect device language and set it temporarily
      final deviceLocale = _getDeviceLocale();
      final supportedLocale = _getSupportedLocale(deviceLocale);
      
      // Don't save the language yet - wait for user selection
      // Just mark that we've detected the system language
      await prefs.setBool(_firstLaunchKey, false);
      
      return supportedLocale;
    }
    
    // Not first launch - get saved language
    final languageCode = prefs.getString(_languageKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    
    // Fallback to default
    return AppConstants.defaultLocale;
  }

  /// Save the selected language to SharedPreferences
  static Future<void> saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  /// Get device locale
  static Locale _getDeviceLocale() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    return deviceLocale;
  }

  /// Get supported locale based on device locale
  static Locale _getSupportedLocale(Locale deviceLocale) {
    // Check if device language is supported
    for (final supportedLocale in AppConstants.supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }
    
    // If device language is not supported, return default
    return AppConstants.defaultLocale;
  }

  /// Check if a locale is RTL
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'ar' || 
           locale.languageCode == 'he' || 
           locale.languageCode == 'fa' || 
           locale.languageCode == 'ur';
  }

  /// Get text direction for a locale
  static TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get display name for a locale
  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }

  /// Check if a locale is supported
  static bool isLocaleSupported(Locale locale) {
    return AppConstants.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  /// Get system locale or default if not supported
  static Locale getSystemLocaleOrDefault() {
    final systemLocale = PlatformDispatcher.instance.locale;
    return isLocaleSupported(systemLocale) ? systemLocale : AppConstants.defaultLocale;
  }

  /// Reset to first launch state (for testing purposes)
  static Future<void> resetFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }

  /// Check if this is the first time showing language selection
  static Future<bool> isLanguageFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_languageFirstTimeKey) ?? true;
  }

  /// Mark language selection as completed
  static Future<void> markLanguageSelectionCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_languageFirstTimeKey, false);
  }

  /// Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  /// Get the detected system locale for first time setup
  static Future<Locale> getDetectedSystemLocale() async {
    final deviceLocale = _getDeviceLocale();
    return _getSupportedLocale(deviceLocale);
  }

  /// Reset all first-time flags (for testing purposes)
  static Future<void> resetAllFirstTimeFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
    await prefs.setBool(_languageFirstTimeKey, true);
    await prefs.setBool(_onboardingCompletedKey, false);
    await prefs.remove(_languageKey);
  }
}

/// Provider for LanguageService
final languageServiceProvider = Provider<LanguageService>((ref) {
  return LanguageService();
});
