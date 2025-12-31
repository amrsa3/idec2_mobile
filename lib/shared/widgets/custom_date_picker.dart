import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Custom date picker widget with consistent styling
class CustomDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;
  final DateFormat? dateFormat;
  final String? dateFormatPattern;

  const CustomDatePicker({
    super.key,
    this.selectedDate,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.dateFormat,
    this.dateFormatPattern,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = widget.dateFormat ?? 
        DateFormat(widget.dateFormatPattern ?? 'yyyy/MM/dd');
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
          readOnly: true,
          enabled: widget.enabled,
          validator: (value) => widget.validator?.call(widget.selectedDate),
          decoration: _buildInputDecoration(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          controller: TextEditingController(
            text: widget.selectedDate != null 
                ? _dateFormat.format(widget.selectedDate!)
                : '',
          ),
          onTap: widget.enabled ? _selectDate : null,
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
            const TextSpan(
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
      prefixIcon: widget.prefixIcon ?? const Icon(Icons.calendar_today),
      suffixIcon: widget.suffixIcon,
      errorText: widget.errorText,
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
      filled: true,
      fillColor: widget.enabled 
          ? Colors.white 
          : AppColors.grey.withValues(alpha: 0.1),
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
    );
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
      borderColor = AppColors.grey.withValues(alpha: 0.3);
    } else {
      borderColor = AppColors.grey.withValues(alpha: 0.5);
    }
    
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime.now(),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != widget.selectedDate) {
      widget.onChanged?.call(picked);
    }
  }
}

/// Date range picker widget
class CustomDateRangePicker extends StatefulWidget {
  final DateTimeRange? selectedRange;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTimeRange?)? validator;
  final void Function(DateTimeRange?)? onChanged;
  final DateFormat? dateFormat;
  final String? dateFormatPattern;

  const CustomDateRangePicker({
    super.key,
    this.selectedRange,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.dateFormat,
    this.dateFormatPattern,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _dateFormat = widget.dateFormat ?? 
        DateFormat(widget.dateFormatPattern ?? 'yyyy/MM/dd');
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
          readOnly: true,
          enabled: widget.enabled,
          validator: (value) => widget.validator?.call(widget.selectedRange),
          decoration: _buildInputDecoration(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          controller: TextEditingController(
            text: widget.selectedRange != null 
                ? '${_dateFormat.format(widget.selectedRange!.start)} - ${_dateFormat.format(widget.selectedRange!.end)}'
                : '',
          ),
          onTap: widget.enabled ? _selectDateRange : null,
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
            const TextSpan(
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
      prefixIcon: widget.prefixIcon ?? const Icon(Icons.date_range),
      suffixIcon: widget.suffixIcon,
      errorText: widget.errorText,
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
      filled: true,
      fillColor: widget.enabled 
          ? Colors.white 
          : AppColors.grey.withValues(alpha: 0.1),
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
    );
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
      borderColor = AppColors.grey.withValues(alpha: 0.3);
    } else {
      borderColor = AppColors.grey.withValues(alpha: 0.5);
    }
    
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: widget.selectedRange,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime.now(),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != widget.selectedRange) {
      widget.onChanged?.call(picked);
    }
  }
}

/// Time picker widget
class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(TimeOfDay?)? validator;
  final void Function(TimeOfDay?)? onChanged;
  final bool use24HourFormat;

  const CustomTimePicker({
    super.key,
    this.selectedTime,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.use24HourFormat = true,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
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
          readOnly: true,
          enabled: widget.enabled,
          validator: (value) => widget.validator?.call(widget.selectedTime),
          decoration: _buildInputDecoration(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          controller: TextEditingController(
            text: widget.selectedTime != null 
                ? _formatTime(widget.selectedTime!)
                : '',
          ),
          onTap: widget.enabled ? _selectTime : null,
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
            const TextSpan(
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
      prefixIcon: widget.prefixIcon ?? const Icon(Icons.access_time),
      suffixIcon: widget.suffixIcon,
      errorText: widget.errorText,
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
      ),
      filled: true,
      fillColor: widget.enabled 
          ? Colors.white 
          : AppColors.grey.withValues(alpha: 0.1),
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
    );
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
      borderColor = AppColors.grey.withValues(alpha: 0.3);
    } else {
      borderColor = AppColors.grey.withValues(alpha: 0.5);
    }
    
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    if (widget.use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'ص' : 'م';
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != widget.selectedTime) {
      widget.onChanged?.call(picked);
    }
  }
}
