import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/payment_gateway_model.dart';

class PaymentGatewaySelector extends StatelessWidget {
  final List<PaymentGatewayModel> gateways;
  final Function(PaymentGatewayModel) onGatewaySelected;

  const PaymentGatewaySelector({
    super.key,
    required this.gateways,
    required this.onGatewaySelected,
  });

  static Future<PaymentGatewayModel?> show(
    BuildContext context,
    List<PaymentGatewayModel> gateways,
  ) async {
    PaymentGatewayModel? selectedGateway;

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          // Safe scale: ensure value is valid number and between 0.5 and 1.0
          final safeScale = value.isNaN || value < 0.5 ? 1.0 : value;
          return Transform.scale(
            scale: safeScale,
            child: Opacity(opacity: value, child: child),
          );
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compact header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.payment,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'اختر بوابة الدفع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                // Gateways in single row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: gateways.map((gateway) {
                      final index = gateways.indexOf(gateway);
                      return Expanded(
                        child: TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 200 + (index * 100)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            // Safe scale: ensure value is valid number and between 0.5 and 1.0
                            final safeScale = value.isNaN || value < 0.5 ? 1.0 : value;
                            return Transform.scale(
                              scale: safeScale,
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _GatewayCard(
                              gateway: gateway,
                              onTap: () {
                                selectedGateway = gateway;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return selectedGateway;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _GatewayCard extends StatelessWidget {
  final PaymentGatewayModel gateway;
  final VoidCallback onTap;

  const _GatewayCard({
    required this.gateway,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gateway.accentColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: gateway.accentColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: gateway.accentColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.5),
                    child: Image.asset(
                      gateway.logoPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: gateway.accentColor.withOpacity(0.1),
                          ),
                          child: Icon(
                            _getIcon(gateway.iconName),
                            size: 28,
                            color: gateway.accentColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Name
                Text(
                  gateway.displayName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: gateway.accentColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'jwali':
        return Icons.account_balance_wallet;
      case 'jaib':
        return Icons.wallet;
      case 'kurimi':
        return Icons.payment;
      default:
        return Icons.account_balance_wallet;
    }
  }
}

