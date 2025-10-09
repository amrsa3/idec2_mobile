import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/registration_settings_model.dart';
import '../../core/theme/app_colors.dart';
import 'custom_button.dart';

/// Widget for displaying registration status and handling restrictions
class RegistrationStatusWidget extends StatelessWidget {
  final RegistrationStatusResponse status;
  final VoidCallback? onRetry;
  final VoidCallback? onContactSupport;
  final bool showActions;

  const RegistrationStatusWidget({
    super.key,
    required this.status,
    this.onRetry,
    this.onContactSupport,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    if (status.canRegister) {
      return _buildOpenStatus(context);
    }

    switch (status.status) {
      case RegistrationStatus.closed:
        return _buildClosedStatus(context);
      case RegistrationStatus.maintenance:
        return _buildMaintenanceStatus(context);
      case RegistrationStatus.limited:
        return _buildLimitedStatus(context);
      case RegistrationStatus.open:
        return _buildOpenStatus(context);
    }
  }

  Widget _buildOpenStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registration Open',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You can register for the conference now',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClosedStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.red.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registration Closed',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status.message ?? 'Registration is currently closed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status.reason != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      status.reason!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (status.nextAvailableTime != null) ...[
            const SizedBox(height: 12),
            _buildNextAvailableTime(context, status.nextAvailableTime!),
          ],
          if (showActions) ...[
            const SizedBox(height: 16),
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildMaintenanceStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.build_circle,
                  color: Colors.orange.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.maintenanceMode,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status.message ?? l10n.maintenanceMessage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status.nextAvailableTime != null) ...[
            const SizedBox(height: 12),
            _buildNextAvailableTime(context, status.nextAvailableTime!),
          ],
          if (showActions) ...[
            const SizedBox(height: 16),
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildLimitedStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.yellow.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warning,
                  color: Colors.yellow.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Limited Registration',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status.message ?? 'Registration is currently limited',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.yellow.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showActions) ...[
            const SizedBox(height: 16),
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildNextAvailableTime(BuildContext context, DateTime nextTime) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Available',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(nextTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      children: [
        if (onRetry != null)
          Expanded(
            child: CustomButton(
              text: l10n.retry,
              onPressed: onRetry,
              type: ButtonType.outline,
              height: 32.0,
              icon: Icons.refresh,
              fontSize: 14.0,
            ),
          ),
        if (onRetry != null && onContactSupport != null)
          const SizedBox(width: 12),
        if (onContactSupport != null)
          Expanded(
            child: CustomButton(
              text: l10n.contactSupport,
              onPressed: onContactSupport,
              type: ButtonType.primary,
              height: 32.0,
              icon: Icons.support_agent,
              fontSize: 14.0,
            ),
          ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Compact registration status indicator
class RegistrationStatusIndicator extends StatelessWidget {
  final RegistrationStatus status;
  final String? message;
  final bool showText;

  const RegistrationStatusIndicator({
    super.key,
    required this.status,
    this.message,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _getStatusColor(),
            shape: BoxShape.circle,
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            message ?? _getStatusText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case RegistrationStatus.open:
        return Colors.green;
      case RegistrationStatus.closed:
        return Colors.red;
      case RegistrationStatus.maintenance:
        return Colors.orange;
      case RegistrationStatus.limited:
        return Colors.yellow.shade700;
    }
  }

  String _getStatusText() {
    switch (status) {
      case RegistrationStatus.open:
        return 'Open';
      case RegistrationStatus.closed:
        return 'Closed';
      case RegistrationStatus.maintenance:
        return 'Maintenance';
      case RegistrationStatus.limited:
        return 'Limited';
    }
  }
}

/// Registration guard widget that checks status before showing content
class RegistrationGuard extends StatelessWidget {
  final Widget child;
  final RegistrationStatusResponse status;
  final Widget Function(BuildContext context, RegistrationStatusResponse status)? 
      restrictedBuilder;
  final VoidCallback? onRetry;
  final VoidCallback? onContactSupport;

  const RegistrationGuard({
    super.key,
    required this.child,
    required this.status,
    this.restrictedBuilder,
    this.onRetry,
    this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    if (status.canRegister) {
      return child;
    }

    if (restrictedBuilder != null) {
      return restrictedBuilder!(context, status);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: RegistrationStatusWidget(
          status: status,
          onRetry: onRetry,
          onContactSupport: onContactSupport,
        ),
      ),
    );
  }
}
