import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../core/theme/app_colors.dart';
import 'custom_button.dart';

/// Generic error display widget with retry functionality
class AppErrorWidget extends StatelessWidget {
  final AppError error;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool showDetails;
  final String? customMessage;

  const AppErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onDismiss,
    this.showDetails = false,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final errorHandler = ErrorHandler.instance;
    final message = customMessage ?? errorHandler.getErrorMessage(error, l10n);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getErrorIcon(),
            size: 64,
            color: _getErrorColor(context),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.error,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _getErrorColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (showDetails && error.code != null) ...[
            const SizedBox(height: 8),
            Text(
              'Error Code: ${error.code}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (onRetry != null && _isRetryable())
                CustomButton(
                  text: l10n.retry,
                  onPressed: onRetry,
                  type: ButtonType.primary,
                  height: 40.0,
                ),
              if (onRetry != null && onDismiss != null)
                const SizedBox(width: 16),
              if (onDismiss != null)
                CustomButton(
                  text: l10n.cancel,
                  onPressed: onDismiss,
                  type: ButtonType.outline,
                  height: 40.0,
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getErrorIcon() {
    if (error is NetworkError) {
      final networkError = error as NetworkError;
      if (networkError.isConnectionError) {
        return Icons.wifi_off;
      }
      if (networkError.isTimeout) {
        return Icons.access_time;
      }
      return Icons.cloud_off;
    }
    
    if (error is AuthError) {
      return Icons.lock;
    }
    
    if (error is FileError) {
      return Icons.file_present;
    }
    
    if (error is MaintenanceError) {
      return Icons.build;
    }
    
    return Icons.error_outline;
  }

  Color _getErrorColor(BuildContext context) {
    if (error is MaintenanceError) {
      return Colors.orange;
    }
    
    if (error is NetworkError) {
      return Colors.blue;
    }
    
    return Theme.of(context).colorScheme.error;
  }

  bool _isRetryable() {
    if (error is NetworkError) {
      return (error as NetworkError).isRetryable;
    }
    if (error is FileError && error.code == 'UPLOAD_FAILED') {
      return true;
    }
    return false;
  }
}

/// Network error specific widget
class NetworkErrorWidget extends StatelessWidget {
  final NetworkError error;
  final VoidCallback? onRetry;
  final VoidCallback? onSettings;

  const NetworkErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            error.isConnectionError ? Icons.wifi_off : Icons.cloud_off,
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            error.isConnectionError 
                ? l10n.noInternetConnection 
                : l10n.serverError,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.isConnectionError
                ? l10n.pleaseCheckInternet
                : 'Please try again later or contact support',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              if (onRetry != null)
                CustomButton(
                  text: l10n.tryAgain,
                  onPressed: onRetry,
                  type: ButtonType.primary,
                  isFullWidth: true,
                  icon: Icons.refresh,
                ),
              if (error.isConnectionError && onSettings != null) ...[
                const SizedBox(height: 12),
                CustomButton(
                  text: l10n.connectionStatus,
                  onPressed: onSettings,
                  type: ButtonType.outline,
                  isFullWidth: true,
                  icon: Icons.settings,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Maintenance mode widget
class MaintenanceWidget extends StatelessWidget {
  final MaintenanceError error;
  final VoidCallback? onCheckAgain;

  const MaintenanceWidget({
    super.key,
    required this.error,
    this.onCheckAgain,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.build_circle,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.maintenanceMode,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (error.estimatedEndTime != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.estimatedTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(error.estimatedEndTime!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (onCheckAgain != null)
            CustomButton(
              text: l10n.checkBackLater,
              onPressed: onCheckAgain,
              type: ButtonType.outline,
              isFullWidth: true,
              icon: Icons.refresh,
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(height: 24),
            CustomButton(
              text: actionText!,
              onPressed: onAction,
              type: ButtonType.primary,
            ),
          ],
        ],
      ),
    );
  }
}

/// Retry button widget
class RetryButton extends StatelessWidget {
  final VoidCallback onRetry;
  final String? text;
  final bool isLoading;
  final IconData? icon;

  const RetryButton({
    super.key,
    required this.onRetry,
    this.text,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CustomButton(
      text: text ?? l10n.retry,
      onPressed: isLoading ? null : onRetry,
      isLoading: isLoading,
      type: ButtonType.primary,
      icon: icon ?? Icons.refresh,
    );
  }
}

/// Connection status indicator
class ConnectionStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final VoidCallback? onTap;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isConnected ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              isConnected ? l10n.connected : l10n.disconnected,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
