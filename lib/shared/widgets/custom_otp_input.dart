import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

class CustomOtpInput extends StatefulWidget {
  final Function(String) onChanged;
  final Function(String)? onCompleted;
  final int length;
  final bool autoFocus;
  final String? errorText;

  const CustomOtpInput({
    super.key,
    required this.onChanged,
    this.onCompleted,
    this.length = 4,
    this.autoFocus = true,
    this.errorText,
  });

  @override
  State<CustomOtpInput> createState() => _CustomOtpInputState();
}

class _CustomOtpInputState extends State<CustomOtpInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _otpValue = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    
    // Add focus listeners to trigger rebuild when focus changes
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        setState(() {});
      });
    }
    
    // Focus on first field if autoFocus is enabled
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste operation
      _handlePaste(value, index);
      return;
    }

    // Update the OTP value
    _updateOtpValue();

    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus
        _focusNodes[index].unfocus();
      }
    }

    widget.onChanged(_otpValue);
    
    // Check if OTP is complete
    if (_otpValue.length == widget.length) {
      widget.onCompleted?.call(_otpValue);
    }
  }

  void _handlePaste(String pastedText, int startIndex) {
    // Extract only digits from pasted text
    String digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Fill the fields starting from the current index
    for (int i = 0; i < digits.length && (startIndex + i) < widget.length; i++) {
      _controllers[startIndex + i].text = digits[i];
    }
    
    // Focus on the next empty field or the last field
    int nextIndex = (startIndex + digits.length).clamp(0, widget.length - 1);
    _focusNodes[nextIndex].requestFocus();
    
    _updateOtpValue();
    widget.onChanged(_otpValue);
    
    if (_otpValue.length == widget.length) {
      widget.onCompleted?.call(_otpValue);
    }
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        // Move to previous field and clear it
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
        _updateOtpValue();
        widget.onChanged(_otpValue);
      }
    }
  }

  void _updateOtpValue() {
    _otpValue = _controllers.map((controller) => controller.text).join();
  }

  void clear() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _otpValue = '';
    if (widget.autoFocus) {
      _focusNodes[0].requestFocus();
    }
    widget.onChanged(_otpValue);
  }

  String get value => _otpValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.ltr, // Always LTR for OTP
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.length, (index) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) => _onKeyEvent(event, index),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _focusNodes[index].hasFocus
                              ? (widget.errorText != null ? AppColors.error : AppColors.primary)
                              : (widget.errorText != null ? AppColors.error : AppColors.border),
                          width: _focusNodes[index].hasFocus ? 2 : 1,
                        ),
                        color: AppColors.surface,
                        boxShadow: _focusNodes[index].hasFocus
                            ? [
                                BoxShadow(
                                  color: (widget.errorText != null ? AppColors.error : AppColors.primary).withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          filled: false,
                        ),
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
