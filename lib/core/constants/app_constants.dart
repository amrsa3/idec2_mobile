import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://192.168.0.165:3000';

  // Supported Locales
  static const List<Locale> supportedLocales = [
    Locale('ar', 'SA'), // Arabic
    Locale('en', 'US'), // English
  ];

  // Default Locale
  static const Locale defaultLocale = Locale('ar', 'SA');

  // Storage Keys
  static const String languageKey = 'selected_language';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String isFirstTimeKey = 'is_first_time';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double buttonHeight = 48.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int otpLength = 6;

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'pdf'];
}

class ApiEndpoints {
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadProfilePicture = '/users/profile/picture';
  static const String changePassword = '/auth/change-password';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String deleteAccount = '/users/account';
  static const String governorates = '/governorates';
  static const String qualifications = '/qualifications';
  static const String uploadFile = '/files/upload';
  static const String refreshToken = '/auth/refresh';
}

class AppImages {
  static const String logo = 'assets/images/idec-logo.svg';
  static const String splash = 'assets/images/splash_bg.png';
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String placeholder = 'assets/images/placeholder.png';
}

class AppAnimations {
  static const String loading = 'assets/animations/loading.json';
  static const String success = 'assets/animations/success.json';
  static const String error = 'assets/animations/error.json';
  static const String noConnection = 'assets/animations/no_connection.json';
}
