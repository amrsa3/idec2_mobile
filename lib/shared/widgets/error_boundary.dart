import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import 'error_widgets.dart' as error_widgets;
import 'custom_button.dart';

/// Error boundary widget that catches and displays errors gracefully
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, AppError error)? errorBuilder;
  final void Function(AppError error)? onError;
  final bool showErrorDetails;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
    this.showErrorDetails = false,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppError? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error!);
      }
      
      return _buildDefaultErrorWidget(context, _error!);
    }

    return ErrorCatcher(
      onError: _handleError,
      child: widget.child,
    );
  }

  void _handleError(AppError error) {
    setState(() {
      _error = error;
    });
    
    widget.onError?.call(error);
  }

  Widget _buildDefaultErrorWidget(BuildContext context, AppError error) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              error_widgets.AppErrorWidget(
                error: error,
                showDetails: widget.showErrorDetails,
                onRetry: () {
                  setState(() {
                    _error = null;
                  });
                },
                onDismiss: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget that catches errors in its child tree
class ErrorCatcher extends StatefulWidget {
  final Widget child;
  final void Function(AppError error) onError;

  const ErrorCatcher({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  State<ErrorCatcher> createState() => _ErrorCatcherState();
}

class _ErrorCatcherState extends State<ErrorCatcher> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Set up error handling for this widget tree
    WidgetsFlutterBinding.ensureInitialized();
  }
}

/// Async error boundary for handling Future errors
class AsyncErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, AppError error)? errorBuilder;
  final void Function(AppError error)? onError;

  const AsyncErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<AsyncErrorBoundary> createState() => _AsyncErrorBoundaryState();
}

class _AsyncErrorBoundaryState extends State<AsyncErrorBoundary> {
  AppError? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error!);
      }
      
      return _buildDefaultErrorWidget(context, _error!);
    }

    return widget.child;
  }

  void handleAsyncError(dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    
    setState(() {
      _error = appError;
    });
    
    widget.onError?.call(appError);
  }

  Widget _buildDefaultErrorWidget(BuildContext context, AppError error) {
    return Center(
      child: error_widgets.AppErrorWidget(
        error: error,
        onRetry: () {
          setState(() {
            _error = null;
          });
        },
      ),
    );
  }
}

/// Mixin for handling errors in StatefulWidgets
mixin ErrorHandlerMixin<T extends StatefulWidget> on State<T> {
  AppError? _currentError;

  /// Handle an error and update the UI
  void handleError(dynamic error, [StackTrace? stackTrace]) {
    final appError = ErrorHandler.instance.handleError(error, stackTrace);
    
    setState(() {
      _currentError = appError;
    });
  }

  /// Clear the current error
  void clearError() {
    setState(() {
      _currentError = null;
    });
  }

  /// Get the current error
  AppError? get currentError => _currentError;

  /// Check if there's an error
  bool get hasError => _currentError != null;

  /// Show error dialog
  void showErrorDialog({VoidCallback? onRetry}) {
    if (_currentError != null) {
      ErrorHandler.instance.showErrorDialog(
        context,
        _currentError!,
        onRetry: onRetry,
        onDismiss: clearError,
      );
    }
  }

  /// Show error snackbar
  void showErrorSnackBar({VoidCallback? onRetry}) {
    if (_currentError != null) {
      ErrorHandler.instance.showErrorSnackBar(
        context,
        _currentError!,
        onRetry: onRetry,
      );
    }
  }

  /// Build error widget if there's an error, otherwise build normal content
  Widget buildWithErrorHandling(Widget Function() builder) {
    if (_currentError != null) {
      return Center(
        child: error_widgets.AppErrorWidget(
          error: _currentError!,
          onRetry: clearError,
        ),
      );
    }
    
    return builder();
  }
}

/// Safe async operation wrapper
class SafeAsyncOperation<T> {
  final Future<T> Function() operation;
  final void Function(AppError error)? onError;
  final void Function(T result)? onSuccess;
  final VoidCallback? onFinally;

  SafeAsyncOperation({
    required this.operation,
    this.onError,
    this.onSuccess,
    this.onFinally,
  });

  /// Execute the operation safely
  Future<T?> execute() async {
    try {
      final result = await operation();
      onSuccess?.call(result);
      return result;
    } catch (error, stackTrace) {
      final appError = ErrorHandler.instance.handleError(error, stackTrace);
      onError?.call(appError);
      return null;
    } finally {
      onFinally?.call();
    }
  }
}

/// Extension for safe async operations
extension SafeAsyncExtension<T> on Future<T> {
  /// Execute future safely with error handling
  Future<T?> safely({
    void Function(AppError error)? onError,
    void Function(T result)? onSuccess,
    VoidCallback? onFinally,
  }) {
    return SafeAsyncOperation<T>(
      operation: () => this,
      onError: onError,
      onSuccess: onSuccess,
      onFinally: onFinally,
    ).execute();
  }
}
