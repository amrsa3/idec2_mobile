import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/registration_settings_model.dart';
import '../../core/theme/app_colors.dart';
import 'custom_button.dart';

/// Widget for selecting OTP channel when multiple channels are available
class OtpChannelSelector extends StatefulWidget {
  final List<OtpChannelModel> availableChannels;
  final OtpChannelModel? selectedChannel;
  final void Function(OtpChannelModel channel) onChannelSelected;
  final String? phoneNumber;
  final bool showDescription;

  const OtpChannelSelector({
    super.key,
    required this.availableChannels,
    required this.onChannelSelected,
    this.selectedChannel,
    this.phoneNumber,
    this.showDescription = true,
  });

  @override
  State<OtpChannelSelector> createState() => _OtpChannelSelectorState();
}

class _OtpChannelSelectorState extends State<OtpChannelSelector> {
  OtpChannelModel? _selectedChannel;

  @override
  void initState() {
    super.initState();
    _selectedChannel = widget.selectedChannel ?? 
        (widget.availableChannels.isNotEmpty ? widget.availableChannels.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.availableChannels.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    if (widget.availableChannels.length == 1) {
      return _buildSingleChannel(context, l10n);
    }

    return _buildMultipleChannels(context, l10n);
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No OTP channels available',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleChannel(BuildContext context, AppLocalizations l10n) {
    final channel = widget.availableChannels.first;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          _buildChannelIcon(channel),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OTP will be sent via ${channel.friendlyName}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.showDescription && channel.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    channel.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (widget.phoneNumber != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'to ${widget.phoneNumber}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChannels(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose how to receive your verification code:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.availableChannels.map((channel) => _buildChannelOption(
          context,
          channel,
          _selectedChannel?.id == channel.id,
        )),
        const SizedBox(height: 16),
        CustomButton(
          text: l10n.continueButton,
          onPressed: _selectedChannel != null 
              ? () => widget.onChannelSelected(_selectedChannel!)
              : null,
          type: ButtonType.primary,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildChannelOption(
    BuildContext context,
    OtpChannelModel channel,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedChannel = channel;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.1)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary
                  : Theme.of(context).dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _buildChannelIcon(channel),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.friendlyName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                    if (widget.showDescription && channel.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        channel.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (widget.phoneNumber != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Send to ${widget.phoneNumber}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Radio<String>(
                value: channel.id,
                groupValue: _selectedChannel?.id,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedChannel = widget.availableChannels
                          .firstWhere((c) => c.id == value);
                    });
                  }
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelIcon(OtpChannelModel channel) {
    IconData iconData;
    Color iconColor;

    switch (channel.id.toLowerCase()) {
      case 'sms':
        iconData = Icons.sms;
        iconColor = Colors.green;
        break;
      case 'whatsapp':
        iconData = Icons.chat;
        iconColor = Colors.green;
        break;
      case 'email':
        iconData = Icons.email;
        iconColor = Colors.blue;
        break;
      case 'call':
        iconData = Icons.phone;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.message;
        iconColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}

/// Dialog for selecting OTP channel
class OtpChannelSelectionDialog extends StatelessWidget {
  final List<OtpChannelModel> availableChannels;
  final OtpChannelModel? selectedChannel;
  final String? phoneNumber;

  const OtpChannelSelectionDialog({
    super.key,
    required this.availableChannels,
    this.selectedChannel,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.selectLanguage), // TODO: Add proper localization
      content: SizedBox(
        width: double.maxFinite,
        child: OtpChannelSelector(
          availableChannels: availableChannels,
          selectedChannel: selectedChannel,
          phoneNumber: phoneNumber,
          onChannelSelected: (channel) {
            Navigator.of(context).pop(channel);
          },
        ),
      ),
    );
  }

  /// Show the dialog and return selected channel
  static Future<OtpChannelModel?> show(
    BuildContext context, {
    required List<OtpChannelModel> availableChannels,
    OtpChannelModel? selectedChannel,
    String? phoneNumber,
  }) {
    return showDialog<OtpChannelModel>(
      context: context,
      barrierDismissible: false,
      builder: (context) => OtpChannelSelectionDialog(
        availableChannels: availableChannels,
        selectedChannel: selectedChannel,
        phoneNumber: phoneNumber,
      ),
    );
  }
}

/// Bottom sheet for selecting OTP channel
class OtpChannelSelectionBottomSheet extends StatelessWidget {
  final List<OtpChannelModel> availableChannels;
  final OtpChannelModel? selectedChannel;
  final String? phoneNumber;

  const OtpChannelSelectionBottomSheet({
    super.key,
    required this.availableChannels,
    this.selectedChannel,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Verification Method',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OtpChannelSelector(
            availableChannels: availableChannels,
            selectedChannel: selectedChannel,
            phoneNumber: phoneNumber,
            onChannelSelected: (channel) {
              Navigator.of(context).pop(channel);
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  /// Show the bottom sheet and return selected channel
  static Future<OtpChannelModel?> show(
    BuildContext context, {
    required List<OtpChannelModel> availableChannels,
    OtpChannelModel? selectedChannel,
    String? phoneNumber,
  }) {
    return showModalBottomSheet<OtpChannelModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OtpChannelSelectionBottomSheet(
        availableChannels: availableChannels,
        selectedChannel: selectedChannel,
        phoneNumber: phoneNumber,
      ),
    );
  }
}
