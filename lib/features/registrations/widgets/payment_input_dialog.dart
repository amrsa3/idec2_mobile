import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/payment_instruction_model.dart';

class PaymentInputDialog extends StatefulWidget {
  final PaymentInstructionModel instruction;
  final String gatewayName;

  const PaymentInputDialog({
    super.key,
    required this.instruction,
    required this.gatewayName,
  });

  static Future<Map<String, String>?> show(
    BuildContext context,
    PaymentInstructionModel instruction,
    String gatewayName,
  ) async {
    return await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => PaymentInputDialog(
        instruction: instruction,
        gatewayName: gatewayName,
      ),
    );
  }

  @override
  State<PaymentInputDialog> createState() => _PaymentInputDialogState();
}

class _PaymentInputDialogState extends State<PaymentInputDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};
  final Map<String, String> _values = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    for (var field in widget.instruction.data.fields ?? []) {
      _controllers[field.name] = TextEditingController();
      _formKeys[field.name] = GlobalKey<FormState>();
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isValid() {
    for (var field in widget.instruction.data.fields ?? []) {
      if (field.required && (_values[field.name] == null || _values[field.name]!.isEmpty)) {
        return false;
      }
    }
    return true;
  }

  void _submit() {
    if (_isValid()) {
      Navigator.of(context).pop(_values);
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.instruction.data.fields ?? [];

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: TweenAnimationBuilder<double>(
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
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surface,
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
            // Enhanced Header with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.key,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'إدخال بيانات الدفع',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.gatewayName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Form fields
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: fields.map((field) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        key: _formKeys[field.name],
                        controller: _controllers[field.name],
                        decoration: InputDecoration(
                          labelText: field.label,
                          hintText: field.placeholder,
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getFieldIcon(field.type),
                              color: AppColors.primary,
                            ),
                          ),
                          suffixIcon: field.type == 'password'
                              ? IconButton(
                                  icon: const Icon(Icons.visibility_off),
                                  color: AppColors.textSecondary,
                                  onPressed: () {},
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        obscureText: field.type == 'password',
                        keyboardType: _getKeyboardType(field.type),
                        inputFormatters: field.type == 'number'
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
                        onChanged: (value) {
                          setState(() {
                            _values[field.name] = value;
                          });
                        },
                        validator: (value) {
                          if (field.required &&
                              (value == null || value.isEmpty)) {
                            return 'هذا الحقل مطلوب';
                          }
                          return null;
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isValid() ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: AppColors.textTertiary,
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  IconData _getFieldIcon(String? type) {
    switch (type) {
      case 'password':
        return Icons.lock;
      case 'number':
        return Icons.numbers;
      case 'text':
      default:
        return Icons.edit;
    }
  }

  TextInputType _getKeyboardType(String? type) {
    switch (type) {
      case 'number':
        return TextInputType.number;
      case 'password':
        return TextInputType.visiblePassword;
      case 'text':
      default:
        return TextInputType.text;
    }
  }
}

