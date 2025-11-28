import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class ExitConfirmationWrapper extends StatefulWidget {
  final Widget child;

  const ExitConfirmationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ExitConfirmationWrapper> createState() =>
      _ExitConfirmationWrapperState();
}

class _ExitConfirmationWrapperState extends State<ExitConfirmationWrapper> {
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final now = DateTime.now();

        // If this is the first back press or more than 2 seconds have passed
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;

          // Show snackbar with exit confirmation message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.pressBackAgainToExit,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.warning,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
                elevation: 6,
                action: SnackBarAction(
                  label: l10n.exit,
                  textColor: Colors.white,
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
            );
          }
        } else {
          // Second back press within 2 seconds - exit the app
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}
