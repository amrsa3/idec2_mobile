import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// نموذج للملف المختار
class SelectedDocument {
  final File file;
  final String name;
  final String type;
  final int size;
  final Uint8List? bytes; // للويب

  SelectedDocument({
    required this.file,
    required this.name,
    required this.type,
    required this.size,
    this.bytes,
  });
}

/// Widget لاختيار وعرض الوثائق المتعددة
class DocumentPickerWidget extends ConsumerStatefulWidget {
  final List<SelectedDocument> selectedDocuments;
  final Function(List<SelectedDocument>) onDocumentsChanged;

  const DocumentPickerWidget({
    super.key,
    required this.selectedDocuments,
    required this.onDocumentsChanged,
  });

  @override
  ConsumerState<DocumentPickerWidget> createState() =>
      _DocumentPickerWidgetState();
}

class _DocumentPickerWidgetState extends ConsumerState<DocumentPickerWidget> {
  /// اختيار ملفات جديدة
  Future<void> _pickDocuments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: true,
        withData: true, // نحتاج البيانات للتعامل مع الملفات التي لا توفر مساراً مباشراً
      );

      if (result != null && result.files.isNotEmpty) {
        final newDocuments = <SelectedDocument>[];

        for (final platformFile in result.files) {
          int fileSize;
          File? file;

          final originalName = platformFile.name;
          final originalExtension =
              platformFile.extension?.toLowerCase() ??
                  (originalName.contains('.')
                      ? originalName.split('.').last.toLowerCase()
                      : null);

          if (kIsWeb) {
            // في بيئة الويب، استخدم bytes
            if (platformFile.bytes != null) {
              fileSize = platformFile.bytes!.length;
              // في Flutter Web، استخدام اسم الملف الأصلي مباشرة
              // البيانات الفعلية ستكون في bytes
              file = File(platformFile.name);
              debugPrint(
                  '📄 DocumentPickerWidget: Web file - preserving original name: ${platformFile.name}');
            } else {
              continue;
            }
          } else {
            // في بيئة الموبايل، استخدم path
            if (platformFile.path != null) {
              file = File(platformFile.path!);
              fileSize = await file.length();
              debugPrint(
                  '📄 DocumentPickerWidget: Mobile file - preserving original name: ${platformFile.name}');
            } else {
              if (platformFile.bytes != null) {
                fileSize = platformFile.bytes!.length;
                final tempDir = await getTemporaryDirectory();
                String tempFileName = platformFile.name.isNotEmpty
                    ? platformFile.name
                    : 'document_${DateTime.now().millisecondsSinceEpoch}';

                if (!tempFileName.contains('.') && originalExtension != null) {
                  tempFileName = '$tempFileName.$originalExtension';
                }

                final tempPath = path.join(tempDir.path, tempFileName);
                file = await File(tempPath).writeAsBytes(
                  platformFile.bytes!,
                  flush: true,
                );
                debugPrint(
                    '📄 DocumentPickerWidget: Created temp file for camera capture: $tempPath');
              } else {
                continue;
              }
            }
          }

          // التحقق من حجم الملف (أقصى 5 ميجابايت)
          if (fileSize > 5 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'الملف ${platformFile.name} كبير جداً. الحد الأقصى 5 ميجابايت'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
            continue;
          }

          final resolvedExtension =
              originalExtension ??
                  (file.path.contains('.')
                      ? file.path.split('.').last.toLowerCase()
                      : '');

          newDocuments.add(SelectedDocument(
            file: file,
            name: platformFile.name.isNotEmpty
                ? platformFile.name
                : file.path.split('/').last,
            type: resolvedExtension.isNotEmpty
                ? '.$resolvedExtension'
                : path.extension(file.path).toLowerCase(),
            size: fileSize,
            bytes: platformFile.bytes,
          ));
        }

        if (newDocuments.isNotEmpty) {
          final updatedDocuments = [
            ...widget.selectedDocuments,
            ...newDocuments
          ];
          widget.onDocumentsChanged(updatedDocuments);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إضافة ${newDocuments.length} ملف'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في اختيار الملفات: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// حذف ملف من القائمة
  void _removeDocument(int index) {
    final updatedDocuments =
        List<SelectedDocument>.from(widget.selectedDocuments);
    updatedDocuments.removeAt(index);
    widget.onDocumentsChanged(updatedDocuments);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الملف'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  /// تنسيق حجم الملف
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// الحصول على أيقونة الملف حسب النوع
  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image;
      case '.doc':
      case '.docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// الحصول على لون الأيقونة حسب النوع
  Color _getFileIconColor(String type) {
    switch (type.toLowerCase()) {
      case '.pdf':
        return Colors.red;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Colors.blue;
      case '.doc':
      case '.docx':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Row(
          children: [
            Icon(
              Icons.attach_file,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'الوثائق المطلوبة',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // زر إرفاق الوثيقة
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _pickDocuments,
            icon: const Icon(Icons.add),
            label: const Text('إرفاق وثيقة'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              side: BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // قائمة الملفات المختارة
        if (widget.selectedDocuments.isNotEmpty) ...[
          Text(
            'الملفات المختارة (${widget.selectedDocuments.length})',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.selectedDocuments.asMap().entries.map((entry) {
            final index = entry.key;
            final document = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surface,
              ),
              child: Row(
                children: [
                  // أيقونة الملف
                  Icon(
                    _getFileIcon(document.type),
                    color: _getFileIconColor(document.type),
                    size: 24,
                  ),
                  const SizedBox(width: 12),

                  // معلومات الملف
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatFileSize(document.size),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // زر الحذف
                  IconButton(
                    onPressed: () => _removeDocument(index),
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error,
                    tooltip: 'حذف الملف',
                  ),
                ],
              ),
            );
          }).toList(),
        ] else ...[
          // رسالة عدم وجود ملفات
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.surface.withOpacity(0.5),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'لم يتم اختيار أي ملفات بعد',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'اضغط على "إرفاق وثيقة" لاختيار الملفات',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 8),

        // نص توضيحي
        Text(
          'يمكنك إرفاق ملفات PDF، صور (JPG, PNG)، أو مستندات Word. الحد الأقصى لحجم الملف 5 ميجابايت.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
