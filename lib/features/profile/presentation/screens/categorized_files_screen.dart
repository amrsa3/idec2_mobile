import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/file_model.dart';
import '../../providers/smart_file_provider.dart';

/// شاشة عرض الملفات المصنفة حسب النظام الهرمي الجديد
class CategorizedFilesScreen extends ConsumerWidget {
  final String? entityId;
  final String? title;

  const CategorizedFilesScreen({
    super.key,
    this.entityId,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorizedFilesAsync = ref.watch(categorizedFilesProvider(entityId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title ?? 'الملفات المصنفة',
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: categorizedFilesAsync.when(
        data: (categorizedFiles) =>
            _buildFilesContent(context, categorizedFiles),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'حدث خطأ في تحميل الملفات',
                style: AppTextStyles.h3.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: AppTextStyles.body2
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilesContent(
      BuildContext context, Map<String, List<FileModel>> categorizedFiles) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصور الشخصية
          _buildFileCategory(
            context,
            title: 'الصور الشخصية',
            icon: Icons.person,
            color: AppColors.primary,
            files: categorizedFiles['profile_images'] ?? [],
          ),

          const SizedBox(height: 24),

          // الوثائق والمستندات
          _buildFileCategory(
            context,
            title: 'الوثائق والمستندات',
            icon: Icons.description,
            color: AppColors.secondary,
            files: categorizedFiles['documents'] ?? [],
          ),

          const SizedBox(height: 24),

          // المرفقات الإضافية
          _buildFileCategory(
            context,
            title: 'المرفقات الإضافية',
            icon: Icons.attach_file,
            color: AppColors.accent,
            files: categorizedFiles['attachments'] ?? [],
          ),

          const SizedBox(height: 24),

          // الشهادات
          _buildFileCategory(
            context,
            title: 'الشهادات',
            icon: Icons.school,
            color: AppColors.success,
            files: categorizedFiles['certificates'] ?? [],
          ),
        ],
      ),
    );
  }

  Widget _buildFileCategory(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<FileModel> files,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس الفئة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.h3.copyWith(color: color),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${files.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قائمة الملفات
          if (files.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'لا توجد ملفات في هذه الفئة',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return _buildFileItem(context, file, color);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFileItem(
      BuildContext context, FileModel file, Color categoryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // أيقونة الملف
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileIcon(file.mimeType),
              color: categoryColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // معلومات الملف
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.originalName,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatFileSize(file.fileSize),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getFileType(file.mimeType),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // تاريخ الرفع
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(file.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              if (file.url != null)
                IconButton(
                  onPressed: () {
                    // فتح الملف
                    _openFile(context, file);
                  },
                  icon: Icon(
                    Icons.open_in_new,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String mimeType) {
    if (mimeType.startsWith('image/')) {
      return Icons.image;
    } else if (mimeType == 'application/pdf') {
      return Icons.picture_as_pdf;
    } else if (mimeType.contains('word') || mimeType.contains('document')) {
      return Icons.description;
    } else if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) {
      return Icons.table_chart;
    } else if (mimeType.startsWith('text/')) {
      return Icons.text_snippet;
    } else {
      return Icons.insert_drive_file;
    }
  }

  String _getFileType(String mimeType) {
    if (mimeType.startsWith('image/')) {
      return 'صورة';
    } else if (mimeType == 'application/pdf') {
      return 'PDF';
    } else if (mimeType.contains('word') || mimeType.contains('document')) {
      return 'Word';
    } else if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) {
      return 'Excel';
    } else if (mimeType.startsWith('text/')) {
      return 'نص';
    } else {
      return 'ملف';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _openFile(BuildContext context, FileModel file) {
    // يمكن إضافة منطق فتح الملف هنا
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح الملف: ${file.originalName}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
