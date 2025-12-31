import 'package:flutter/material.dart';

/// Helper methods for profile fields
class ProfileFieldHelpers {
  /// Get field display name in Arabic
  static String getFieldDisplayName(String fieldName) {
    const fieldNames = {
      'fullNameAr': 'الاسم العربي',
      'fullNameEn': 'الاسم الإنجليزي',
      'email': 'البريد الإلكتروني',
      'qualificationId': 'المؤهل',
      'governorateId': 'المحافظة',
      'university': 'الجامعة',
      'workplace': 'مكان العمل',
      'graduationYear': 'سنة التخرج',
      'birthDate': 'تاريخ الميلاد',
    };

    return fieldNames[fieldName] ?? fieldName;
  }

  /// Show error dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required List<String> errors,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors
                .map((error) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.close, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(error)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  /// Show approval warning dialog
  static Future<bool> showApprovalWarningDialog(
    BuildContext context, {
    required List<String> warnings,
    required List<String> fieldsRequiringApproval,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('تنبيه: يتطلب موافقة إدارية'),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'التعديلات التالية تتطلب موافقة من الإدارة:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Fields requiring approval
                  ...fieldsRequiringApproval.map((field) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.orange[700],
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(getFieldDisplayName(field)),
                            ),
                          ],
                        ),
                      )),

                  const Divider(height: 24),

                  // Warnings
                  ...warnings.map((warning) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                warning,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'سيتم تغيير حالة حسابك إلى "قيد المراجعة" حتى تتم الموافقة على التعديلات.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                ),
                child: const Text('متابعة وإرسال للمراجعة'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Build field lock icon
  static Widget buildLockIcon() {
    return const Tooltip(
      message: 'هذا الحقل غير قابل للتعديل',
      child: Icon(Icons.lock, color: Colors.grey, size: 20),
    );
  }

  /// Build approval required icon
  static Widget buildApprovalIcon() {
    return const Tooltip(
      message: 'تعديل هذا الحقل يتطلب موافقة إدارية',
      child: Icon(Icons.admin_panel_settings, color: Colors.orange, size: 20),
    );
  }

  /// Build document required indicator
  static Widget buildDocumentRequiredIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.attach_file, color: Colors.blue[700], size: 16),
          const SizedBox(width: 4),
          Text(
            'يتطلب رفع وثيقة',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Build change warning message
  static Widget buildChangeWarningMessage(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.orange[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
