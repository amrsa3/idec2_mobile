import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/profile_rule_model.dart';
import '../../providers/profile_rules_provider.dart';

/// حقل قابل للتعديل في الملف الشخصي
class EditableProfileField extends ConsumerWidget {
  final String fieldName;
  final String label;
  final String? value;
  final ProfileStatus currentStatus;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const EditableProfileField({
    super.key,
    required this.fieldName,
    required this.label,
    this.value,
    required this.currentStatus,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesNotifier = ref.read(profileRulesProvider.notifier);
    final canEdit = rulesNotifier.canEditField(fieldName, currentStatus);
    final requiresDocument =
        rulesNotifier.fieldRequiresDocument(fieldName, currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: value,
                decoration: InputDecoration(
                  labelText: label,
                  enabled: canEdit,
                  suffixIcon:
                      !canEdit ? const Icon(Icons.lock, size: 20) : null,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: keyboardType,
                maxLines: maxLines,
                enabled: canEdit,
                onChanged: onChanged,
                validator: validator,
              ),
            ),
            if (requiresDocument) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showFieldInfo(context, rulesNotifier),
                tooltip: 'معلومات الحقل',
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showFieldInfo(
      BuildContext context, ProfileRulesNotifier rulesNotifier) {
    final policy = rulesNotifier.getApprovalPolicy(fieldName, currentStatus);
    final changeLimit = rulesNotifier.getChangeLimit(fieldName, currentStatus);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('معلومات الحقل: $label'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (policy != null) ...[
              Text('سياسة الموافقة: ${policy.displayName}'),
              const SizedBox(height: 8),
              Text(policy.description),
            ],
            if (changeLimit != null) ...[
              const SizedBox(height: 8),
              Text('حد التغيير: $changeLimit حرف'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
