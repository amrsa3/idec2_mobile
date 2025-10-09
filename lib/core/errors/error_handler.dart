import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

import 'app_error.dart';
import '../utils/crash_reporter.dart';

/// Global error handler for the application
class ErrorHandler {
  static ErrorHandler? _instance;
  static ErrorHandler get instance => _instance ??= ErrorHandler._();

  ErrorHandler._();

  /// Initialize error handling
  void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError(details.exception, details.stack);
      
      if (!kDebugMode) {
        CrashReporter.recordError(
          details.exception,
          details.stack,
          fatal: true,
        );
      }
    };

    // Handle async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError(error, stack);
      
      if (!kDebugMode) {
        CrashReporter.recordError(error, stack, fatal: true);
      }
      
      return true;
    };
  }

  /// Convert any error to AppError
  AppError handleError(dynamic error, [StackTrace? stackTrace]) {
    _logError(error, stackTrace);

    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return NetworkError.fromDioException(error);
    }

    if (error is TimeoutException) {
      return const NetworkError(
        message: 'Request timeout',
        code: 'TIMEOUT',
        isTimeout: true,
      );
    }

    if (error is FormatException) {
      return ValidationError(
        message: 'Invalid data format',
        code: 'FORMAT_ERROR',
        originalError: error,
      );
    }

    // Default to unknown error
    return UnknownError(
      message: error.toString(),
      originalError: error,
    );
  }

  /// Get user-friendly error message
  String getErrorMessage(AppError error, AppLocalizations l10n) {
    switch (error.runtimeType) {
      case NetworkError:
        final networkError = error as NetworkError;
        if (networkError.isConnectionError) {
          return l10n.noInternetConnection;
        }
        if (networkError.isTimeout) {
          return l10n.requestTimeout;
        }
        if (networkError.statusCode == 500) {
          return l10n.serverError;
        }
        if (networkError.statusCode == 503) {
          return l10n.serverNotAvailable;
        }
        return networkError.message;

      case AuthError:
        final authError = error as AuthError;
        if (authError.isTokenExpired) {
          return l10n.sessionExpired;
        }
        if (authError.code == 'INVALID_CREDENTIALS') {
          return l10n.invalidCredentials;
        }
        return authError.message;

      case ValidationError:
        return l10n.fieldRequired; // Generic validation message

      case FileError:
        final fileError = error as FileError;
        switch (fileError.code) {
          case 'FILE_TOO_LARGE':
            return l10n.fileTooLarge;
          case 'INVALID_FORMAT':
            return l10n.invalidFileType;
          case 'UPLOAD_FAILED':
            return l10n.uploadFailed;
          default:
            return fileError.message;
        }

      case MaintenanceError:
        return l10n.maintenanceMessage;

      case BusinessError:
        final businessError = error as BusinessError;
        switch (businessError.code) {
          case 'REGISTRATION_CLOSED':
            return 'Registration is currently closed'; // Add to l10n
          case 'ACCOUNT_NOT_VERIFIED':
            return l10n.pleaseVerifyAccount;
          default:
            return businessError.message;
        }

      default:
        return l10n.unknownError;
    }
  }

  /// Show error dialog
  void showErrorDialog(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final message = getErrorMessage(error, l10n);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.error),
        content: Text(message),
        actions: [
          if (onRetry != null && _isRetryable(error))
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: Text(l10n.retry),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final message = getErrorMessage(error, l10n);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: onRetry != null && _isRetryable(error)
            ? SnackBarAction(
                label: l10n.retry,
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Check if error is retryable
  bool _isRetryable(AppError error) {
    if (error is NetworkError) {
      return error.isRetryable;
    }
    if (error is FileError && error.code == 'UPLOAD_FAILED') {
      return true;
    }
    return false;
  }

  /// Log error for debugging
  void _logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        'Error occurred: $error',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handle authentication errors globally
  void handleAuthError(BuildContext context, AuthError error) {
    if (error.requiresReauth) {
      // Navigate to login screen
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    } else {
      showErrorSnackBar(context, error);
    }
  }

  /// Handle maintenance errors
  void handleMaintenanceError(BuildContext context, MaintenanceError error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.maintenanceMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error.message),
            if (error.estimatedEndTime != null) ...[
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.estimatedTime}: ${_formatDateTime(error.estimatedEndTime!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.checkBackLater),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
