import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/errors/app_error.dart';
import 'custom_button.dart';

enum ServiceStatus {
  operational,
  maintenance,
  degraded,
  outage,
  registrationClosed,
}

/// Banner widget for displaying service status messages
class ServiceStatusBanner extends StatelessWidget {
  final ServiceStatus status;
  final String? message;
  final DateTime? estimatedEndTime;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionText;
  final bool dismissible;

  const ServiceStatusBanner({
    super.key,
    required this.status,
    this.message,
    this.estimatedEndTime,
    this.onDismiss,
    this.onAction,
    this.actionText,
    this.dismissible = true,
  });

  /// Create banner from maintenance error
  factory ServiceStatusBanner.fromMaintenanceError(
    MaintenanceError error, {
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return ServiceStatusBanner(
      status: ServiceStatus.maintenance,
      message: error.message,
      estimatedEndTime: error.estimatedEndTime,
      onDismiss: onDismiss,
      onAction: onAction,
      actionText: actionText,
    );
  }

  /// Create banner for registration closed
  factory ServiceStatusBanner.registrationClosed({
    String? message,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return ServiceStatusBanner(
      status: ServiceStatus.registrationClosed,
      message: message,
      onDismiss: onDismiss,
      onAction: onAction,
      actionText: actionText,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (status == ServiceStatus.operational) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border(
          bottom: BorderSide(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getTitle(context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(),
                    fontSize: 16,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: TextStyle(
                      color: _getTextColor().withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
                if (estimatedEndTime != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${AppLocalizations.of(context)!.estimatedTime}: ${_formatDateTime(estimatedEndTime!)}',
                    style: TextStyle(
                      color: _getTextColor().withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (onAction != null && actionText != null) ...[
                  const SizedBox(height: 8),
                  CustomButton(
                    text: actionText!,
                    onPressed: onAction,
                    type: ButtonType.outline,
                    height: 32.0,
                    textColor: _getTextColor(),
                    fontSize: 14.0,
                  ),
                ],
              ],
            ),
          ),
          if (dismissible && onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close,
                color: _getTextColor(),
                size: 20,
              ),
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
        ],
      ),
    );
  }

  String _getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (status) {
      case ServiceStatus.operational:
        return 'Service Operational';
      case ServiceStatus.maintenance:
        return l10n.maintenanceMode;
      case ServiceStatus.degraded:
        return 'Service Degraded';
      case ServiceStatus.outage:
        return 'Service Outage';
      case ServiceStatus.registrationClosed:
        return 'Registration Closed';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case ServiceStatus.operational:
        return Icons.check_circle;
      case ServiceStatus.maintenance:
        return Icons.build_circle;
      case ServiceStatus.degraded:
        return Icons.warning;
      case ServiceStatus.outage:
        return Icons.error;
      case ServiceStatus.registrationClosed:
        return Icons.lock;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case ServiceStatus.operational:
        return Colors.green.shade50;
      case ServiceStatus.maintenance:
        return Colors.orange.shade50;
      case ServiceStatus.degraded:
        return Colors.yellow.shade50;
      case ServiceStatus.outage:
        return Colors.red.shade50;
      case ServiceStatus.registrationClosed:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case ServiceStatus.operational:
        return Colors.green.shade200;
      case ServiceStatus.maintenance:
        return Colors.orange.shade200;
      case ServiceStatus.degraded:
        return Colors.yellow.shade200;
      case ServiceStatus.outage:
        return Colors.red.shade200;
      case ServiceStatus.registrationClosed:
        return Colors.blue.shade200;
    }
  }

  Color _getIconColor() {
    switch (status) {
      case ServiceStatus.operational:
        return Colors.green.shade600;
      case ServiceStatus.maintenance:
        return Colors.orange.shade600;
      case ServiceStatus.degraded:
        return Colors.yellow.shade700;
      case ServiceStatus.outage:
        return Colors.red.shade600;
      case ServiceStatus.registrationClosed:
        return Colors.blue.shade600;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case ServiceStatus.operational:
        return Colors.green.shade800;
      case ServiceStatus.maintenance:
        return Colors.orange.shade800;
      case ServiceStatus.degraded:
        return Colors.yellow.shade800;
      case ServiceStatus.outage:
        return Colors.red.shade800;
      case ServiceStatus.registrationClosed:
        return Colors.blue.shade800;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Service status provider for managing global service status
class ServiceStatusProvider extends ChangeNotifier {
  ServiceStatus _status = ServiceStatus.operational;
  String? _message;
  DateTime? _estimatedEndTime;
  bool _isDismissed = false;

  ServiceStatus get status => _status;
  String? get message => _message;
  DateTime? get estimatedEndTime => _estimatedEndTime;
  bool get isDismissed => _isDismissed;
  bool get shouldShowBanner => _status != ServiceStatus.operational && !_isDismissed;

  /// Update service status
  void updateStatus({
    required ServiceStatus status,
    String? message,
    DateTime? estimatedEndTime,
  }) {
    _status = status;
    _message = message;
    _estimatedEndTime = estimatedEndTime;
    _isDismissed = false;
    notifyListeners();
  }

  /// Set maintenance mode
  void setMaintenance({
    String? message,
    DateTime? estimatedEndTime,
  }) {
    updateStatus(
      status: ServiceStatus.maintenance,
      message: message,
      estimatedEndTime: estimatedEndTime,
    );
  }

  /// Set registration closed
  void setRegistrationClosed({String? message}) {
    updateStatus(
      status: ServiceStatus.registrationClosed,
      message: message,
    );
  }

  /// Set service operational
  void setOperational() {
    updateStatus(status: ServiceStatus.operational);
  }

  /// Dismiss the banner
  void dismiss() {
    _isDismissed = true;
    notifyListeners();
  }

  /// Reset dismissal state
  void resetDismissal() {
    _isDismissed = false;
    notifyListeners();
  }
}

/// Widget that automatically shows service status banner
class ServiceStatusWrapper extends StatelessWidget {
  final Widget child;
  final ServiceStatusProvider statusProvider;

  const ServiceStatusWrapper({
    super.key,
    required this.child,
    required this.statusProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: statusProvider,
      builder: (context, _) {
        return Column(
          children: [
            if (statusProvider.shouldShowBanner)
              ServiceStatusBanner(
                status: statusProvider.status,
                message: statusProvider.message,
                estimatedEndTime: statusProvider.estimatedEndTime,
                onDismiss: statusProvider.dismiss,
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
