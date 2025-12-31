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

    // Web-specific error handling
    if (kIsWeb) {
      _initializeWebErrorHandling();
    }
  }

  /// Initialize web-specific error handling
  void _initializeWebErrorHandling() {
    print('🌐 Initializing web-specific error handling');
    
    // Handle web-specific errors that might not be caught by Flutter
    // This includes CORS errors, network connectivity issues, etc.
  }

  /// Convert any error to AppError with web-specific handling
  AppError handleError(dynamic error, [StackTrace? stackTrace]) {
    _logError(error, stackTrace);

    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is TimeoutException) {
      return const NetworkError(
        message: kIsWeb ? 'انتهت مهلة الاتصال - يرجى التحقق من الاتصال بالإنترنت' : 'Request timeout',
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

    // Web-specific error handling
    if (kIsWeb) {
      return _handleWebSpecificError(error);
    }

    // Default to unknown error
    return UnknownError(
      message: error.toString(),
      originalError: error,
    );
  }

  /// Handle Dio exceptions with web-specific logic
  NetworkError _handleDioException(DioException error) {
    if (kIsWeb) {
      // Web-specific Dio error handling
      switch (error.type) {
        case DioExceptionType.connectionError:
          // Check if it's a CORS error
          if (error.message?.contains('CORS') == true || 
              error.message?.contains('Cross-Origin') == true) {
            return NetworkError(
              message: 'خطأ في إعدادات الخادم (CORS) - يرجى المحاولة مرة أخرى',
              code: 'CORS_ERROR',
              isConnectionError: true,
              statusCode: error.response?.statusCode,
              originalError: error,
            );
          }
          
          return NetworkError(
            message: 'فشل الاتصال بالخادم - يرجى التحقق من الاتصال بالإنترنت',
            code: 'CONNECTION_ERROR',
            isConnectionError: true,
            statusCode: error.response?.statusCode,
            originalError: error,
          );

        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkError(
            message: 'انتهت مهلة الاتصال - يرجى المحاولة مرة أخرى',
            code: 'TIMEOUT_ERROR',
            isTimeout: true,
            statusCode: error.response?.statusCode,
            originalError: error,
          );

        case DioExceptionType.badResponse:
          return NetworkError(
            message: _getStatusCodeMessage(error.response?.statusCode),
            code: 'HTTP_ERROR',
            statusCode: error.response?.statusCode,
            originalError: error,
          );

        case DioExceptionType.unknown:
          // Check for network connectivity issues
          if (error.message?.toLowerCase().contains('network') == true ||
              error.message?.toLowerCase().contains('internet') == true) {
            return NetworkError(
              message: 'لا يوجد اتصال بالإنترنت - يرجى التحقق من الاتصال',
              code: 'NO_INTERNET',
              isConnectionError: true,
              originalError: error,
            );
          }
          break;

        default:
          break;
      }
    }

    // Fallback to default Dio error handling
    return NetworkError.fromDioException(error);
  }

  /// Handle web-specific errors
  AppError _handleWebSpecificError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Handle InternetAddress.lookup errors
    if (errorString.contains('internetaddress.lookup') ||
        errorString.contains('unsupported operation')) {
      return NetworkError(
        message: 'خطأ في فحص الاتصال - سيتم استخدام طريقة بديلة',
        code: 'WEB_CONNECTIVITY_ERROR',
        isConnectionError: false, // Not a real connection error
        originalError: error,
      );
    }

    // Handle web-specific network errors
    if (errorString.contains('failed to fetch') ||
        errorString.contains('network error') ||
        errorString.contains('cors')) {
      return NetworkError(
        message: 'خطأ في الشبكة - يرجى التحقق من الاتصال والمحاولة مرة أخرى',
        code: 'WEB_NETWORK_ERROR',
        isConnectionError: true,
        originalError: error,
      );
    }

    // Handle web security errors
    if (errorString.contains('security') ||
        errorString.contains('blocked') ||
        errorString.contains('mixed content')) {
      return NetworkError(
        message: 'خطأ أمني في المتصفح - يرجى التأكد من إعدادات الأمان',
        code: 'WEB_SECURITY_ERROR',
        isConnectionError: false,
        originalError: error,
      );
    }

    // Default web error
    return UnknownError(
      message: 'خطأ في تطبيق الويب: ${error.toString()}',
      originalError: error,
    );
  }

  /// Get status code specific message
  String _getStatusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'طلب غير صحيح - يرجى التحقق من البيانات المدخلة';
      case 401:
        return 'غير مصرح - يرجى تسجيل الدخول مرة أخرى';
      case 403:
        return 'ممنوع - ليس لديك صلاحية للوصول';
      case 404:
        return 'الصفحة غير موجودة';
      case 408:
        return 'انتهت مهلة الطلب';
      case 429:
        return 'تم تجاوز الحد المسموح من الطلبات - يرجى المحاولة لاحقاً';
      case 500:
        return 'خطأ في الخادم - يرجى المحاولة لاحقاً';
      case 502:
        return 'خطأ في البوابة - الخادم غير متاح مؤقتاً';
      case 503:
        return 'الخدمة غير متاحة - يرجى المحاولة لاحقاً';
      case 504:
        return 'انتهت مهلة البوابة';
      default:
        return 'خطأ في الخادم (${statusCode ?? 'غير معروف'})';
    }
  }

  /// Get user-friendly error message
  String getErrorMessage(AppError error, AppLocalizations l10n) {
    // Web-specific error messages
    if (kIsWeb && error is NetworkError) {
      switch (error.code) {
        case 'CORS_ERROR':
          return 'خطأ في إعدادات الخادم - يرجى المحاولة مرة أخرى';
        case 'WEB_CONNECTIVITY_ERROR':
          return 'تم اكتشاف خطأ في فحص الاتصال - سيتم استخدام طريقة بديلة';
        case 'WEB_NETWORK_ERROR':
          return 'خطأ في الشبكة - يرجى التحقق من الاتصال';
        case 'WEB_SECURITY_ERROR':
          return 'خطأ أمني في المتصفح - يرجى التحقق من إعدادات الأمان';
        case 'NO_INTERNET':
          return 'لا يوجد اتصال بالإنترنت - يرجى التحقق من الاتصال';
        case 'TIMEOUT_ERROR':
          return 'انتهت مهلة الاتصال - يرجى المحاولة مرة أخرى';
        case 'CONNECTION_ERROR':
          return 'فشل الاتصال بالخادم - يرجى التحقق من الاتصال';
      }
    }

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

  /// Show error dialog with web-specific styling
  void showErrorDialog(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = getErrorMessage(error, l10n);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(l10n.error),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (kIsWeb && error is NetworkError && error.code == 'CORS_ERROR') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Text(
                  'ملاحظة: هذا خطأ في إعدادات الخادم وليس في جهازك',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
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

  /// Show error snackbar with web-specific styling
  void showErrorSnackBar(
    BuildContext context,
    AppError error, {
    VoidCallback? onRetry,
  }) {
    final l10n = AppLocalizations.of(context);
    final message = getErrorMessage(error, l10n);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: onRetry != null && _isRetryable(error)
            ? SnackBarAction(
                label: l10n.retry,
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        duration: const Duration(seconds: kIsWeb ? 6 : 4), // Longer duration for web
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Check if error is retryable with web-specific logic
  bool _isRetryable(AppError error) {
    if (error is NetworkError) {
      // Web-specific retry logic
      if (kIsWeb) {
        switch (error.code) {
          case 'CORS_ERROR':
            return true; // CORS errors might be temporary
          case 'WEB_CONNECTIVITY_ERROR':
            return false; // Don't retry connectivity check errors
          case 'WEB_SECURITY_ERROR':
            return false; // Don't retry security errors
          case 'TIMEOUT_ERROR':
          case 'CONNECTION_ERROR':
          case 'NO_INTERNET':
            return true;
          default:
            return error.isRetryable;
        }
      }
      return error.isRetryable;
    }
    if (error is FileError && error.code == 'UPLOAD_FAILED') {
      return true;
    }
    return false;
  }

  /// Log error for debugging with web-specific information
  void _logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      const platform = kIsWeb ? 'WEB' : 'MOBILE';
      developer.log(
        '[$platform] Error occurred: $error',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );

      // Additional web-specific logging
      if (kIsWeb && error is DioException) {
        developer.log(
          '[WEB] Dio Error Details - Type: ${error.type}, Message: ${error.message}',
          name: 'ErrorHandler',
        );
        if (error.response != null) {
          developer.log(
            '[WEB] Response Details - Status: ${error.response?.statusCode}, Data: ${error.response?.data}',
            name: 'ErrorHandler',
          );
        }
      }
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
        title: Text(AppLocalizations.of(context).maintenanceMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error.message),
            if (error.estimatedEndTime != null) ...[
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context).estimatedTime}: ${_formatDateTime(error.estimatedEndTime!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).checkBackLater),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Web-specific error recovery methods
  void handleWebConnectivityError(BuildContext context) {
    if (!kIsWeb) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.orange),
            SizedBox(width: 8),
            Text('مشكلة في الاتصال'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تم اكتشاف مشكلة في فحص الاتصال. سيتم استخدام طريقة بديلة.'),
            SizedBox(height: 12),
            Text(
              'هذا أمر طبيعي في تطبيقات الويب ولا يؤثر على وظائف التطبيق.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  /// Show web-specific tips for connectivity issues
  void showWebConnectivityTips(BuildContext context) {
    if (!kIsWeb) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.tips_and_updates, color: Colors.blue),
            SizedBox(width: 8),
            Text('نصائح للاتصال'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إذا كنت تواجه مشاكل في الاتصال:'),
            SizedBox(height: 8),
            Text('• تأكد من اتصالك بالإنترنت'),
            Text('• جرب تحديث الصفحة'),
            Text('• تأكد من أن المتصفح يدعم التطبيق'),
            Text('• تحقق من إعدادات الأمان في المتصفح'),
            SizedBox(height: 12),
            Text(
              'ملاحظة: بعض ميزات فحص الاتصال قد لا تعمل في المتصفح وهذا أمر طبيعي.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
