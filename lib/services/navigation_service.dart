import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';

/// Service for handling programmatic navigation throughout the app
class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance => _instance ??= NavigationService._();
  
  NavigationService._();
  
  /// Global navigator key for accessing navigation context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// Get current context
  BuildContext? get context => navigatorKey.currentContext;
  
  /// Get current router
  GoRouter? get router => context != null ? GoRouter.of(context!) : null;
  
  // Navigation methods
  
  /// Navigate to splash screen
  void goToSplash() {
    router?.go(AppRoutes.splash);
  }
  
  /// Navigate to language selection
  void goToLanguageSelection() {
    router?.go(AppRoutes.languageSelection);
  }
  
  /// Navigate to onboarding
  void goToOnboarding() {
    router?.go(AppRoutes.onboarding);
  }
  
  /// Navigate to login screen
  void goToLogin() {
    router?.go(AppRoutes.login);
  }
  
  /// Navigate to register screen
  void goToRegister() {
    router?.go(AppRoutes.register);
  }
  
  /// Navigate to OTP verification
  void goToOtpVerification(String phone) {
    router?.go('${AppRoutes.otpVerification}?phone=$phone');
  }
  
  /// Navigate to main screen
  void goToMain() {
    router?.go(AppRoutes.main);
  }
  
  /// Navigate to profile screen
  void goToProfile() {
    router?.go(AppRoutes.profile);
  }

  /// Navigate to profile screen for editing
  void goToEditProfile() {
    router?.go(AppRoutes.profile);
  }

  /// Navigate to connection status screen
  void goToConnectionStatus() {
    router?.go(AppRoutes.connectionStatus);
  }
  
  /// Navigate to server configuration screen
  void goToServerConfig() {
    router?.go(AppRoutes.serverConfig);
  }
  
  /// Navigate to error reporting screen
  void goToErrorReporting({String? errorMessage, String? stackTrace}) {
    final params = <String, String>{};
    if (errorMessage != null) params['error'] = errorMessage;
    if (stackTrace != null) params['stackTrace'] = stackTrace;
    
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    router?.go('${AppRoutes.errorReporting}${query.isNotEmpty ? '?$query' : ''}');
  }
  
  /// Navigate to notifications screen
  void goToNotifications() {
    router?.go(AppRoutes.notifications);
  }
  
  /// Navigate to notifications test screen
  void goToNotificationsTest() {
    router?.go(AppRoutes.notificationsTest);
  }
  
  /// Navigate to event details
  void goToEvent(String eventId) {
    router?.go('/event/$eventId');
  }
  
  /// Navigate to registration details
  void goToRegistration(String registrationId) {
    router?.go('/registration/$registrationId');
  }
  
  /// Navigate to conference details
  void goToConference(String conferenceId) {
    router?.go('/conference/$conferenceId');
  }
  
  /// Navigate to payment details
  void goToPayment(String transactionId) {
    router?.go('/payment/$transactionId');
  }
  
  // Push methods (for modal navigation)
  
  /// Push a route onto the navigation stack
  void push(String route) {
    router?.push(route);
  }
  
  /// Push and replace current route
  void pushReplacement(String route) {
    router?.pushReplacement(route);
  }
  
  /// Pop current route
  void pop([dynamic result]) {
    if (context != null && Navigator.of(context!).canPop()) {
      Navigator.of(context!).pop(result);
    }
  }
  
  /// Pop until a specific route
  void popUntil(String route) {
    router?.go(route);
  }
  
  /// Clear navigation stack and go to route
  void clearAndGoTo(String route) {
    router?.go(route);
  }

  /// Pop all routes until the root (first) route.
  void popToRoot() {
    final navigator = navigatorKey.currentState;
    navigator?.popUntil((route) => route.isFirst);
  }
  
  // Utility methods
  
  /// Check if we can pop the current route
  bool canPop() {
    return context != null && Navigator.of(context!).canPop();
  }
  
  /// Get current route name
  String? getCurrentRoute() {
    if (context == null) return null;
    final route = ModalRoute.of(context!);
    return route?.settings.name;
  }
  
  /// Show modal bottom sheet
  Future<T?> showCustomModalBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    if (context == null) return Future.value(null);
    
    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (context) => child,
    );
  }
  
  /// Show dialog
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    if (context == null) return Future.value(null);
    
    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (context) => child,
    );
  }
  
  /// Show snack bar
  void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    if (context == null) return;
    
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }
  
  /// Show success snack bar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.green,
    );
  }
  
  /// Show error snack bar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.red,
    );
  }
  
  /// Show warning snack bar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.orange,
    );
  }
  
  /// Show info snack bar
  void showInfoSnackBar(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.blue,
    );
  }
}

/// Extension methods for easier navigation
extension NavigationExtension on BuildContext {
  /// Get navigation service instance
  NavigationService get nav => NavigationService.instance;
  
  /// Quick navigation methods
  void goToLogin() => nav.goToLogin();
  void goToMain() => nav.goToMain();
  void goToProfile() => nav.goToProfile();
  void goBack() => nav.pop();
}
