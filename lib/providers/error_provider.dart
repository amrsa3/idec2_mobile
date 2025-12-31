import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/errors/app_error.dart';
import '../core/errors/error_handler.dart';

/// Global error state provider
final errorProvider = StateNotifierProvider<ErrorNotifier, ErrorState>((ref) {
  return ErrorNotifier();
});

/// Error state class
class ErrorState {
  final Map<String, AppError> errors;
  final AppError? globalError;
  final List<AppError> errorHistory;

  const ErrorState({
    this.errors = const {},
    this.globalError,
    this.errorHistory = const [],
  });

  /// Check if there are any errors
  bool get hasErrors => errors.isNotEmpty || globalError != null;

  /// Check if there's an error for a specific key
  bool hasErrorFor(String key) => errors.containsKey(key);

  /// Get error for a specific key
  AppError? getError(String key) => errors[key];

  /// Get all error keys
  List<String> get errorKeys => errors.keys.toList();

  /// Copy with new values
  ErrorState copyWith({
    Map<String, AppError>? errors,
    AppError? globalError,
    List<AppError>? errorHistory,
    bool clearGlobalError = false,
  }) {
    return ErrorState(
      errors: errors ?? this.errors,
      globalError: clearGlobalError ? null : (globalError ?? this.globalError),
      errorHistory: errorHistory ?? this.errorHistory,
    );
  }
}

/// Error state notifier
class ErrorNotifier extends StateNotifier<ErrorState> {
  ErrorNotifier() : super(const ErrorState());

  /// Add error for a specific key
  void addError(String key, dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    
    final newErrors = Map<String, AppError>.from(state.errors);
    newErrors[key] = appError;
    
    final newHistory = List<AppError>.from(state.errorHistory);
    newHistory.add(appError);
    
    // Keep only last 50 errors in history
    if (newHistory.length > 50) {
      newHistory.removeAt(0);
    }

    state = state.copyWith(
      errors: newErrors,
      errorHistory: newHistory,
    );
  }

  /// Set global error
  void setGlobalError(dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    
    final newHistory = List<AppError>.from(state.errorHistory);
    newHistory.add(appError);
    
    if (newHistory.length > 50) {
      newHistory.removeAt(0);
    }

    state = state.copyWith(
      globalError: appError,
      errorHistory: newHistory,
    );
  }

  /// Clear error for a specific key
  void clearError(String key) {
    final newErrors = Map<String, AppError>.from(state.errors);
    newErrors.remove(key);

    state = state.copyWith(errors: newErrors);
  }

  /// Clear global error
  void clearGlobalError() {
    state = state.copyWith(clearGlobalError: true);
  }

  /// Clear all errors
  void clearAll() {
    state = const ErrorState();
  }

  /// Clear multiple errors
  void clearMultiple(List<String> keys) {
    final newErrors = Map<String, AppError>.from(state.errors);
    
    for (final key in keys) {
      newErrors.remove(key);
    }

    state = state.copyWith(errors: newErrors);
  }

  /// Handle authentication error
  void handleAuthError(dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    
    if (appError is AuthError) {
      setGlobalError(appError);
    } else {
      addError('auth', appError);
    }
  }

  /// Handle network error
  void handleNetworkError(String key, dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    addError(key, appError);
  }

  /// Handle file error
  void handleFileError(String key, dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    addError(key, appError);
  }

  /// Handle validation error
  void handleValidationError(String key, dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    addError(key, appError);
  }
}

/// Extension for easy error management
extension ErrorExtension on WidgetRef {
  /// Add error
  void addError(String key, dynamic error, [StackTrace? stackTrace]) {
    read(errorProvider.notifier).addError(key, error, stackTrace);
  }

  /// Set global error
  void setGlobalError(dynamic error, [StackTrace? stackTrace]) {
    read(errorProvider.notifier).setGlobalError(error, stackTrace);
  }

  /// Clear error
  void clearError(String key) {
    read(errorProvider.notifier).clearError(key);
  }

  /// Clear global error
  void clearGlobalError() {
    read(errorProvider.notifier).clearGlobalError();
  }

  /// Clear all errors
  void clearAllErrors() {
    read(errorProvider.notifier).clearAll();
  }

  /// Check if there's an error
  bool hasError([String? key]) {
    final state = watch(errorProvider);
    return key != null ? state.hasErrorFor(key) : state.hasErrors;
  }

  /// Get error
  AppError? getError(String key) {
    return watch(errorProvider).getError(key);
  }

  /// Get global error
  AppError? get globalError => watch(errorProvider).globalError;

  /// Handle auth error
  void handleAuthError(dynamic error, [StackTrace? stackTrace]) {
    read(errorProvider.notifier).handleAuthError(error, stackTrace);
  }

  /// Handle network error
  void handleNetworkError(String key, dynamic error, [StackTrace? stackTrace]) {
    read(errorProvider.notifier).handleNetworkError(key, error, stackTrace);
  }

  /// Handle file error
  void handleFileError(String key, dynamic error, [StackTrace? stackTrace]) {
    read(errorProvider.notifier).handleFileError(key, error, stackTrace);
  }

  /// Handle validation error
  void handleValidationError(String key, dynamic error, [StackTrace? stackTrace]) {
    read(errorProvider.notifier).handleValidationError(key, error, stackTrace);
  }
}

/// Common error keys
class ErrorKeys {
  static const String login = 'login';
  static const String register = 'register';
  static const String verifyOtp = 'verify_otp';
  static const String resendOtp = 'resend_otp';
  static const String loadProfile = 'load_profile';
  static const String updateProfile = 'update_profile';
  static const String uploadProfilePicture = 'upload_profile_picture';
  static const String uploadDocument = 'upload_document';
  static const String deleteDocument = 'delete_document';
  static const String loadQualifications = 'load_qualifications';
  static const String connectionTest = 'connection_test';
  static const String serverConfig = 'server_config';
  static const String logout = 'logout';
  static const String refreshToken = 'refresh_token';
  static const String syncData = 'sync_data';
  static const String fileUpload = 'file_upload';
  static const String imageUpload = 'image_upload';
  static const String documentUpload = 'document_upload';
  static const String profileSave = 'profile_save';
  static const String otpValidation = 'otp_validation';
  static const String passwordValidation = 'password_validation';
  static const String emailValidation = 'email_validation';
  static const String phoneValidation = 'phone_validation';
}
