import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Custom text field widget with consistent styling
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
    this.focusNode,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          const SizedBox(height: 8),
        ],
        
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          style: AppTextStyles.bodyMedium.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          decoration: _buildInputDecoration(),
        ),
        
        if (widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: widget.label!,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        children: [
          if (widget.isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    final hasError = widget.errorText != null;
    
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      errorText: widget.errorText,
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
      filled: true,
      fillColor: widget.enabled 
          ? Colors.white 
          : AppColors.surfaceVariant,
      border: _buildBorder(),
      enabledBorder: _buildBorder(),
      focusedBorder: _buildBorder(isFocused: true),
      errorBorder: _buildBorder(hasError: true),
      focusedErrorBorder: _buildBorder(hasError: true, isFocused: true),
      disabledBorder: _buildBorder(isDisabled: true),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      counterText: widget.maxLength != null ? null : '',
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    return widget.suffixIcon;
  }

  OutlineInputBorder _buildBorder({
    bool isFocused = false,
    bool hasError = false,
    bool isDisabled = false,
  }) {
    Color borderColor;
    double borderWidth = 1.5;
    
    if (hasError) {
      borderColor = AppColors.error;
      borderWidth = 2;
    } else if (isFocused) {
      borderColor = AppColors.primary;
      borderWidth = 2;
    } else if (isDisabled) {
      borderColor = AppColors.border;
    } else {
      borderColor = AppColors.borderLight;
    }
    
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}

/// Multi-line text field for longer content
class CustomTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextArea({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      errorText: errorText,
      isRequired: isRequired,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }
}

/// Search text field with search icon
class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;

  const SearchTextField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hint: hint ?? 'البحث...',
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefixIcon: Icon(
        Icons.search,
        color: AppColors.textSecondary,
      ),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                controller?.clear();
                onClear?.call();
              },
            )
          : null,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }
}
