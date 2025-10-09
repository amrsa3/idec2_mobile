import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global loading state provider
final loadingProvider = StateNotifierProvider<LoadingNotifier, LoadingState>((ref) {
  return LoadingNotifier();
});

/// Loading state class
class LoadingState {
  final Map<String, bool> loadingStates;
  final Map<String, double> progressStates;
  final Map<String, String> messageStates;

  const LoadingState({
    this.loadingStates = const {},
    this.progressStates = const {},
    this.messageStates = const {},
  });

  /// Check if any operation is loading
  bool get isLoading => loadingStates.values.any((loading) => loading);

  /// Check if specific operation is loading
  bool isLoadingFor(String key) => loadingStates[key] ?? false;

  /// Get progress for specific operation
  double? getProgress(String key) => progressStates[key];

  /// Get message for specific operation
  String? getMessage(String key) => messageStates[key];

  /// Copy with new values
  LoadingState copyWith({
    Map<String, bool>? loadingStates,
    Map<String, double>? progressStates,
    Map<String, String>? messageStates,
  }) {
    return LoadingState(
      loadingStates: loadingStates ?? this.loadingStates,
      progressStates: progressStates ?? this.progressStates,
      messageStates: messageStates ?? this.messageStates,
    );
  }
}

/// Loading state notifier
class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(const LoadingState());

  /// Start loading for a specific operation
  void startLoading(String key, {String? message}) {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    final newMessageStates = Map<String, String>.from(state.messageStates);
    
    newLoadingStates[key] = true;
    if (message != null) {
      newMessageStates[key] = message;
    }

    state = state.copyWith(
      loadingStates: newLoadingStates,
      messageStates: newMessageStates,
    );
  }

  /// Stop loading for a specific operation
  void stopLoading(String key) {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    final newProgressStates = Map<String, double>.from(state.progressStates);
    final newMessageStates = Map<String, String>.from(state.messageStates);
    
    newLoadingStates.remove(key);
    newProgressStates.remove(key);
    newMessageStates.remove(key);

    state = state.copyWith(
      loadingStates: newLoadingStates,
      progressStates: newProgressStates,
      messageStates: newMessageStates,
    );
  }

  /// Update progress for a specific operation
  void updateProgress(String key, double progress, {String? message}) {
    final newProgressStates = Map<String, double>.from(state.progressStates);
    final newMessageStates = Map<String, String>.from(state.messageStates);
    
    newProgressStates[key] = progress;
    if (message != null) {
      newMessageStates[key] = message;
    }

    state = state.copyWith(
      progressStates: newProgressStates,
      messageStates: newMessageStates,
    );
  }

  /// Update message for a specific operation
  void updateMessage(String key, String message) {
    final newMessageStates = Map<String, String>.from(state.messageStates);
    newMessageStates[key] = message;

    state = state.copyWith(messageStates: newMessageStates);
  }

  /// Clear all loading states
  void clearAll() {
    state = const LoadingState();
  }

  /// Clear loading states for multiple keys
  void clearMultiple(List<String> keys) {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    final newProgressStates = Map<String, double>.from(state.progressStates);
    final newMessageStates = Map<String, String>.from(state.messageStates);
    
    for (final key in keys) {
      newLoadingStates.remove(key);
      newProgressStates.remove(key);
      newMessageStates.remove(key);
    }

    state = state.copyWith(
      loadingStates: newLoadingStates,
      progressStates: newProgressStates,
      messageStates: newMessageStates,
    );
  }
}

/// Extension for easy loading management
extension LoadingExtension on WidgetRef {
  /// Start loading
  void startLoading(String key, {String? message}) {
    read(loadingProvider.notifier).startLoading(key, message: message);
  }

  /// Stop loading
  void stopLoading(String key) {
    read(loadingProvider.notifier).stopLoading(key);
  }

  /// Update progress
  void updateProgress(String key, double progress, {String? message}) {
    read(loadingProvider.notifier).updateProgress(key, progress, message: message);
  }

  /// Update loading message
  void updateLoadingMessage(String key, String message) {
    read(loadingProvider.notifier).updateMessage(key, message);
  }

  /// Check if loading
  bool isLoading([String? key]) {
    final state = watch(loadingProvider);
    return key != null ? state.isLoadingFor(key) : state.isLoading;
  }

  /// Get progress
  double? getProgress(String key) {
    return watch(loadingProvider).getProgress(key);
  }

  /// Get loading message
  String? getLoadingMessage(String key) {
    return watch(loadingProvider).getMessage(key);
  }
}

/// Common loading keys
class LoadingKeys {
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
}
