import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/payment_instruction_model.dart';

class PaymentInputResult {
  final Map<String, String>? data;
  final bool isCancelled;

  const PaymentInputResult._({
    required this.isCancelled,
    this.data,
  });

  factory PaymentInputResult.submitted(Map<String, String> data) {
    return PaymentInputResult._(
      isCancelled: false,
      data: data,
    );
  }

  const PaymentInputResult.cancelled()
      : data = null,
        isCancelled = true;

  bool get hasData => data != null && data!.isNotEmpty;
}

class PaymentInputDialog extends StatefulWidget {
  final PaymentInstructionModel instruction;
  final String gatewayName;
  final double? amount;
  final String? currency;

  const PaymentInputDialog({
    super.key,
    required this.instruction,
    required this.gatewayName,
    this.amount,
    this.currency,
  });

  static Future<PaymentInputResult?> show(
    BuildContext context,
    PaymentInstructionModel instruction,
    String gatewayName, {
    double? amount,
    String? currency,
  }) async {
    return await showDialog<PaymentInputResult>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => PaymentInputDialog(
        instruction: instruction,
        gatewayName: gatewayName,
        amount: amount,
        currency: currency,
      ),
    );
  }

  @override
  State<PaymentInputDialog> createState() => _PaymentInputDialogState();
}

class _PaymentInputDialogState extends State<PaymentInputDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, GlobalKey<FormState>> _formKeys = {};
  PaymentFieldModel? _receiverMobileField;
  bool _instructionsExpanded = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    final baseFields = widget.instruction.data.fields ?? [];
    for (var field in baseFields) {
      _controllers[field.name] = TextEditingController();
      _formKeys[field.name] = GlobalKey<FormState>();
    }

    if (_isJawali() &&
        baseFields.every((field) => field.name != 'receiverMobile')) {
      _receiverMobileField = const PaymentFieldModel(
        name: 'receiverMobile',
        label: 'رقم المحفظة (رقم الهاتف)',
        placeholder: 'أدخل رقم محفظة جوالي',
        type: 'phone',
        required: true,
      );
      _controllers['receiverMobile'] = TextEditingController();
      _formKeys['receiverMobile'] = GlobalKey<FormState>();
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

  List<PaymentFieldModel> get _allFields {
    final fields =
        List<PaymentFieldModel>.from(widget.instruction.data.fields ?? []);
    if (_receiverMobileField != null &&
        fields.every((field) => field.name != _receiverMobileField!.name)) {
      fields.insert(0, _receiverMobileField!);
    }
    return fields;
  }

  bool _isValid() {
    for (var field in _allFields) {
      final value = _controllers[field.name]?.text.trim() ?? '';
      if (field.required && value.isEmpty) {
        return false;
      }
      if (field.name == 'receiverMobile' &&
          (value.length < 9 ||
              value.length > 12 ||
              !RegExp(r'^\d+$').hasMatch(value))) {
        return false;
      }
      if (field.name.toLowerCase() == 'pinpass') {
        if (value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
          return false;
        }
      }
    }
    return true;
  }

  void _submit() {
    if (_isValid()) {
      final result = <String, String>{};
      for (var field in _allFields) {
        result[field.name] = _controllers[field.name]?.text.trim() ?? '';
      }
      Navigator.of(context).pop(PaymentInputResult.submitted(result));
    }
  }

  Future<void> _cancel() async {
    Navigator.of(context).pop(const PaymentInputResult.cancelled());
  }

  @override
  Widget build(BuildContext context) {
    final fields = _allFields;

    return WillPopScope(
      onWillPop: () async {
        await _cancel();
        return false;
      },
      child: Dialog(
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
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              maxWidth: 500,
            ),
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
              // Enhanced Header with gradient - full width
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGatewayLogo(),
                    const SizedBox(height: 12),
                    const Text(
                      'إدخال بيانات الدفع',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.gatewayName,
                      style: const TextStyle(
                        fontSize: 15,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...fields.map((field) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
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
                                vertical: 14,
                              ),
                            ),
                            obscureText: field.type == 'password',
                            keyboardType:
                                _getKeyboardType(field.type, field.name),
                            inputFormatters: _buildInputFormatters(field),
                            onChanged: (value) {
                              setState(() {
                                // Trigger UI update for validation
                              });
                            },
                            validator: (value) {
                              if (field.required &&
                                  (value == null || value.isEmpty)) {
                                return 'هذا الحقل مطلوب';
                              }
                              if (field.name == 'receiverMobile') {
                                final trimmed = value?.trim() ?? '';
                                if (trimmed.length < 9 || trimmed.length > 12) {
                                  return 'يرجى إدخال رقم محفظة صالح';
                                }
                                if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
                                  return 'يجب أن يحتوي رقم المحفظة على أرقام فقط';
                                }
                              }
                              if (field.name.toLowerCase() == 'pinpass') {
                                final trimmed = value?.trim() ?? '';
                                if (!RegExp(r'^\d{4}$').hasMatch(trimmed)) {
                                  return 'الرمز السري يجب أن يتكون من 4 أرقام';
                                }
                              }
                              return null;
                            },
                          ),
                        );
                      }).toList(),
                      // Instructions for Jeeb and Jeebly - collapsible (moved after fields)
                      if (_shouldShowInstructions())
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: _buildInstructionsWidget(),
                        ),
                    ],
                  ),
                ),
              ),
              // Buttons
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _cancel(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 15,
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: AppColors.textTertiary,
                          ),
                          child: const Text(
                            'تأكيد',
                            style: TextStyle(
                              fontSize: 15,
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
      ),
    );
  }

  IconData _getFieldIcon(String? type) {
    switch (type) {
      case 'password':
        return Icons.lock;
      case 'number':
        return Icons.numbers;
      case 'phone':
        return Icons.phone_iphone;
      case 'text':
      default:
        return Icons.edit;
    }
  }

  TextInputType _getKeyboardType(String? type, String fieldName) {
    if (fieldName == 'receiverMobile') {
      return TextInputType.phone;
    }
    if (fieldName.toLowerCase() == 'pinpass') {
      return TextInputType.number;
    }
    switch (type) {
      case 'number':
        return TextInputType.number;
      case 'phone':
        return TextInputType.phone;
      case 'password':
        return TextInputType.visiblePassword;
      case 'text':
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _buildInputFormatters(PaymentFieldModel field) {
    if (field.name == 'receiverMobile') {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ];
    }

    if (field.type == 'number') {
      return [FilteringTextInputFormatter.digitsOnly];
    }

    if (field.name.toLowerCase() == 'pinpass') {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ];
    }

    return null;
  }

  bool _shouldShowInstructions() {
    final gatewayName = widget.gatewayName.toLowerCase();
    return gatewayName.contains('جيب') ||
        gatewayName.contains('جوالي') ||
        gatewayName.contains('jeeb') ||
        gatewayName.contains('jwali');
  }

  bool _isJeeb() {
    final gatewayName = widget.gatewayName.toLowerCase();
    return gatewayName.contains('جيب') || gatewayName.contains('jeeb');
  }

  bool _isJawali() {
    final gatewayName = widget.gatewayName.toLowerCase();
    return gatewayName.contains('جوالي') ||
        gatewayName.contains('jwali') ||
        gatewayName.contains('jawali');
  }

  /// Get gateway logo path based on gateway name
  String _getGatewayLogoPath() {
    final gatewayName = widget.gatewayName.toLowerCase();
    if (gatewayName.contains('جيب') ||
        gatewayName.contains('jeeb') ||
        gatewayName.contains('jaib')) {
      return AppImages.jaibLogo;
    } else if (gatewayName.contains('جوالي') ||
        gatewayName.contains('jwali') ||
        gatewayName.contains('jawali')) {
      return AppImages.jawaliLogo;
    } else if (gatewayName.contains('كريمي') ||
        gatewayName.contains('kurimi')) {
      return AppImages.kurimiLogo;
    }
    return AppImages.placeholder;
  }

  /// Get gateway accent color based on gateway name
  Color _getGatewayAccentColor() {
    final gatewayName = widget.gatewayName.toLowerCase();
    if (gatewayName.contains('جيب') ||
        gatewayName.contains('jeeb') ||
        gatewayName.contains('jaib')) {
      return const Color(0xFFE53935); // Red
    } else if (gatewayName.contains('جوالي') ||
        gatewayName.contains('jwali') ||
        gatewayName.contains('jawali')) {
      return const Color(0xFFFF6B00); // Orange
    } else if (gatewayName.contains('كريمي') ||
        gatewayName.contains('kurimi')) {
      return const Color(0xFF6C3483); // Purple
    }
    return AppColors.primary;
  }

  /// Build gateway logo widget
  Widget _buildGatewayLogo() {
    final logoPath = _getGatewayLogoPath();
    final accentColor = _getGatewayAccentColor();

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          logoPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor,
                    accentColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openVideoUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('لا يمكن فتح رابط الفيديو'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في فتح رابط الفيديو: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildInstructionsWidget() {
    final isJeeb = _isJeeb();
    final amountText = widget.amount != null && widget.currency != null
        ? '${widget.amount!.toStringAsFixed(2)} ${widget.currency}'
        : 'المبلغ المطلوب';

    final steps = isJeeb
        ? [
            'قم بفتح تطبيق جيب وتسجيل دخول',
            'ادخل الى أيقونة شراء اونلاين',
            'ادخل توليد كود شراء',
            'حدد المبلغ المطلوب ($amountText) وقم بتوليد كود دفع',
            'قم بنسخ كود الدفع والصقه هنا',
          ]
        : [
            'قم بفتح تطبيق جوالي وتسجيل دخول',
            'ادخل الى أيقونة الشراء اونلاين',
            'حدد المبلغ ($amountText) وقم بالضغط على ارسال',
            'قم بنسخ كود الدفع واكتبه هنا',
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info.withOpacity(0.1),
            AppColors.info.withOpacity(0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _instructionsExpanded = !_instructionsExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'تعليمات الدفع',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  // Video icon for Jeeb
                  if (isJeeb) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () =>
                          _openVideoUrl('https://app.idec-ye.com/jaib.mp4'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  TweenAnimationBuilder<double>(
                    key: ValueKey(_instructionsExpanded),
                    duration: const Duration(milliseconds: 200),
                    tween: Tween(
                      begin: _instructionsExpanded ? 0.0 : 3.14159,
                      end: _instructionsExpanded ? 3.14159 : 0.0,
                    ),
                    builder: (context, angle, child) {
                      return Transform.rotate(
                        angle: angle,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.expand_more,
                      color: AppColors.info,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _instructionsExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...steps.asMap().entries.map((entry) {
                          final index = entry.key;
                          final step = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection: TextDirection.rtl,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: AppColors.info,
                                    borderRadius: BorderRadius.circular(11),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.info.withOpacity(0.3),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                      height: 1.4,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
