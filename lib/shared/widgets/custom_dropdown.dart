import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Custom dropdown widget with consistent styling
class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final double? maxHeight;

  const CustomDropdown({
    super.key,
    this.value,
    required this.items,
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
    this.maxHeight,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          const SizedBox(height: 8),
        ],
        
        DropdownButtonFormField<T>(
          initialValue: _getValidValue(),
          items: widget.items,
          onChanged: widget.enabled ? widget.onChanged : null,
          validator: widget.validator,
          decoration: _buildInputDecoration(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
          ),
          dropdownColor: Colors.white,
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          menuMaxHeight: widget.maxHeight ?? 300,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: widget.enabled ? AppColors.textSecondary : AppColors.textTertiary,
          ),
          iconSize: 24,
          isExpanded: true,
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

  /// التحقق من صحة القيمة المختارة وإرجاع قيمة صالحة
  T? _getValidValue() {
    // إذا كانت القيمة null، إرجاع null مباشرة
    if (widget.value == null) return null;
    
    // إذا كانت قائمة العناصر فارغة، إرجاع null
    if (widget.items.isEmpty) {
      debugPrint('⚠️ CustomDropdown: قائمة العناصر فارغة');
      return null;
    }
    
    // التحقق من أن القيمة موجودة في قائمة العناصر
    final validValues = widget.items.map((item) => item.value).toSet();
    
    // معالجة خاصة للقيم النصية الفارغة أو "0"
    if (widget.value is String) {
      final stringValue = widget.value as String;
      if (stringValue.isEmpty || stringValue == "0" || stringValue.trim().isEmpty) {
        debugPrint('⚠️ CustomDropdown: القيمة النصية فارغة أو غير صالحة: "$stringValue"');
        return null;
      }
    }
    
    if (validValues.contains(widget.value)) {
      return widget.value;
    }
    
    // إذا لم تكن القيمة موجودة، إرجاع null مع تسجيل تفصيلي
    debugPrint('⚠️ CustomDropdown: القيمة المختارة غير موجودة في القائمة: ${widget.value}');
    debugPrint('⚠️ CustomDropdown: نوع القيمة: ${widget.value.runtimeType}');
    debugPrint('⚠️ CustomDropdown: القيم الصالحة: $validValues');
    
    // إشعار الوالد بأن القيمة غير صالحة (إذا كان هناك callback)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onChanged != null) {
        debugPrint('🔄 CustomDropdown: إعادة تعيين القيمة إلى null');
        widget.onChanged!(null);
      }
    });
    
    return null;
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
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
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

/// Multi-select dropdown widget
class MultiSelectDropdown<T> extends StatefulWidget {
  final List<T> selectedValues;
  final List<DropdownMenuItem<T>> items;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final String? Function(List<T>?)? validator;
  final void Function(List<T>)? onChanged;
  final String Function(T) itemDisplayText;

  const MultiSelectDropdown({
    super.key,
    required this.selectedValues,
    required this.items,
    this.label,
    this.hint,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    required this.itemDisplayText,
  });

  @override
  State<MultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<MultiSelectDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          _buildLabel(),
          const SizedBox(height: 8),
        ],
        
        InkWell(
          onTap: widget.enabled ? _showMultiSelectDialog : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.enabled 
                  ? Colors.white 
                  : AppColors.surfaceVariant,
              border: Border.all(
                color: widget.errorText != null 
                    ? AppColors.error 
                    : AppColors.borderLight,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: widget.selectedValues.isEmpty
                      ? Text(
                          widget.hint ?? 'اختر العناصر',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: widget.selectedValues.map((value) {
                            return Chip(
                              label: Text(
                                widget.itemDisplayText(value),
                                style: AppTextStyles.bodySmall,
                              ),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              onDeleted: () => _removeItem(value),
                            );
                          }).toList(),
                        ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.enabled ? AppColors.textSecondary : AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
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

  void _showMultiSelectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.label ?? 'اختر العناصر'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isSelected = widget.selectedValues.contains(item.value);
              
              return CheckboxListTile(
                title: item.child,
                value: isSelected,
                onChanged: (selected) {
                  if (selected == true) {
                    _addItem(item.value as T);
                  } else {
                    _removeItem(item.value as T);
                  }
                },
                activeColor: AppColors.primary,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _addItem(T value) {
    if (!widget.selectedValues.contains(value)) {
      final newValues = List<T>.from(widget.selectedValues)..add(value);
      widget.onChanged?.call(newValues);
    }
  }

  void _removeItem(T value) {
    final newValues = List<T>.from(widget.selectedValues)..remove(value);
    widget.onChanged?.call(newValues);
  }
}

/// Searchable dropdown widget
class SearchableDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? label;
  final String? hint;
  final String? searchHint;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final String Function(T) itemSearchText;

  const SearchableDropdown({
    super.key,
    this.value,
    required this.items,
    this.label,
    this.hint,
    this.searchHint,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    required this.itemSearchText,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<DropdownMenuItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        
        InkWell(
          onTap: widget.enabled ? _showSearchableDialog : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.enabled 
                  ? Colors.white 
                  : AppColors.surfaceVariant,
              border: Border.all(
                color: widget.errorText != null 
                    ? AppColors.error 
                    : AppColors.borderLight,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value != null
                        ? widget.items
                            .firstWhere((item) => item.value == widget.value)
                            .child
                            .toString()
                        : widget.hint ?? 'اختر عنصر',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: widget.value != null 
                          ? AppColors.textPrimary 
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.enabled ? AppColors.textSecondary : AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
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

  void _showSearchableDialog() {
    _filteredItems = widget.items;
    _searchController.clear();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(widget.label ?? 'اختر عنصر'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint ?? 'البحث...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredItems = widget.items.where((item) {
                        final searchText = widget.itemSearchText(item.value as T);
                        return searchText.toLowerCase().contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Items list
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      
                      return ListTile(
                        title: item.child,
                        onTap: () {
                          widget.onChanged?.call(item.value);
                          Navigator.pop(context);
                        },
                        selected: widget.value == item.value,
                        selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}
