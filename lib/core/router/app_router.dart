import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/reset_password_screen.dart';
import '../../features/connection/presentation/connection_status_screen.dart';
import '../../features/connection/presentation/error_reporting_screen.dart';
import '../../features/connection/presentation/server_config_screen.dart';
import '../../features/language/presentation/language_selection_screen.dart';
import '../../features/main/presentation/main_screen.dart';
import '../../features/notifications/presentation/notifications_page.dart';
import '../../features/notifications/presentation/notifications_test_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
// Import screens
import '../../features/splash/presentation/splash_screen.dart';
// Import providers
import '../../providers/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_main_screen.dart';

// Route names
class AppRoutes {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String resetPasswordOtp = '/reset-password-otp';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String profileView = '/profile/view';
  static const String connectionStatus = '/connection-status';
  static const String serverConfig = '/server-config';
  static const String errorReporting = '/error-reporting';
  static const String notifications = '/notifications';
  static const String notificationsTest = '/notifications-test';
}

// Auth change notifier for GoRouter
class AuthChangeNotifier extends ChangeNotifier {
  final Ref ref;
  
  AuthChangeNotifier(this.ref) {
    // Listen to auth state changes
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = AuthChangeNotifier(ref);
  
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    // Listen to auth state changes to trigger router refresh
    refreshListenable: authNotifier,
    // Deep linking configuration
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final isRegistering = authState.isRegistering;
      final currentRoute = state.uri.path;

      print('GoRouter redirect: currentLocation=$currentRoute, isAuthenticated=$isAuthenticated, isLoading=$isLoading, isRegistering=$isRegistering, user=${authState.user}');

      // Don't redirect while loading
      if (isLoading) return null;

      // Public routes that don't require authentication
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.languageSelection,
        AppRoutes.onboarding,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.otpVerification,
        AppRoutes.forgotPassword,
        AppRoutes.resetPasswordOtp,
        AppRoutes.connectionStatus,
        AppRoutes.serverConfig,
        AppRoutes.errorReporting,
      ];

      // Special case: If user is registering, don't redirect from register or OTP pages
      if (isRegistering && 
          (currentRoute == AppRoutes.register || currentRoute == AppRoutes.otpVerification)) {
        return null; // Stay on current page during registration process
      }

      // If user is not authenticated and trying to access protected route
      if (!isAuthenticated && !publicRoutes.contains(currentRoute)) {
        return AppRoutes.login;
      }

      // If user is authenticated and trying to access auth routes (except OTP verification)
      if (isAuthenticated &&
          (currentRoute == AppRoutes.login ||
              currentRoute == AppRoutes.register)) {
        return AppRoutes.main;
      }

      // Special case: Don't redirect from OTP verification unless user is fully authenticated
      if (currentRoute == AppRoutes.otpVerification && !isAuthenticated) {
        return null; // Stay on OTP verification page
      }

      return null; // No redirect needed
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Language Selection Screen
      GoRoute(
        path: AppRoutes.languageSelection,
        name: 'language-selection',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),

      // Onboarding Screen
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otp-verification',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpVerificationScreen(phone: phone);
        },
      ),

      // Forgot Password Routes
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: AppRoutes.resetPasswordOtp,
        name: 'reset-password-otp',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return ResetPasswordScreen(phone: phone);
        },
      ),

      // Main Screen with Bottom Navigation
      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),

      // Profile Routes - Now using ProfileMainScreen with rules integration
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileMainScreen(),
      ),

      // Profile View Route (keeping for backward compatibility)
      GoRoute(
        path: AppRoutes.profileView,
        name: 'profile-view',
        builder: (context, state) => const ProfileMainScreen(),
      ),

      // Connection Status Route
      GoRoute(
        path: AppRoutes.connectionStatus,
        name: 'connection-status',
        builder: (context, state) => const ConnectionStatusScreen(),
      ),

      // Server Configuration Route
      GoRoute(
        path: AppRoutes.serverConfig,
        name: 'server-config',
        builder: (context, state) => const ServerConfigScreen(),
      ),

      // Error Reporting Route
      GoRoute(
        path: AppRoutes.errorReporting,
        name: 'error-reporting',
        builder: (context, state) {
          final errorMessage = state.uri.queryParameters['error'];
          final stackTrace = state.uri.queryParameters['stackTrace'];
          return ErrorReportingScreen(
            errorMessage: errorMessage,
            stackTrace: stackTrace,
          );
        },
      ),

      // Notifications Routes
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      GoRoute(
        path: AppRoutes.notificationsTest,
        name: 'notifications-test',
        builder: (context, state) => const NotificationsTestScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('خطأ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'الصفحة غير موجودة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'المسار: ${state.uri.path}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Navigation helper extensions
extension AppRouterExtension on GoRouter {
  void goToLanguageSelection() => go(AppRoutes.languageSelection);
  void goToOnboarding() => go(AppRoutes.onboarding);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToOtpVerification(String phone) =>
      go('${AppRoutes.otpVerification}?phone=$phone');
  void goToMain() => go(AppRoutes.main);
  void goToProfile() => go(AppRoutes.profile);
  void goToConnectionStatus() => go(AppRoutes.connectionStatus);
  void goToServerConfig() => go(AppRoutes.serverConfig);
  void goToErrorReporting({String? errorMessage, String? stackTrace}) {
    final params = <String, String>{};
    if (errorMessage != null) params['error'] = errorMessage;
    if (stackTrace != null) params['stackTrace'] = stackTrace;

    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    go('${AppRoutes.errorReporting}${query.isNotEmpty ? '?$query' : ''}');
  }

  void goToNotifications() => go(AppRoutes.notifications);
  void goToNotificationsTest() => go(AppRoutes.notificationsTest);
}
