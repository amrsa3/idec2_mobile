import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/file_model.dart';
import '../../providers/smart_file_provider.dart';

/// صفحة احترافية لعرض المستندات المرفوعة من المستخدم
class UserDocumentsViewerScreen extends ConsumerStatefulWidget {
  const UserDocumentsViewerScreen({super.key});

  @override
  ConsumerState<UserDocumentsViewerScreen> createState() =>
      _UserDocumentsViewerScreenState();
}

class _UserDocumentsViewerScreenState
    extends ConsumerState<UserDocumentsViewerScreen> {
  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(userDocumentsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'مستنداتي',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: () {
              ref.invalidate(userDocumentsProvider);
            },
          ),
        ],
      ),
      body: documentsAsync.when(
        data: (documents) => _buildDocumentsList(documents),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildDocumentsList(List<FileModel> documents) {
    if (documents.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return _buildDocumentCard(documents[index]);
      },
    );
  }

  Widget _buildDocumentCard(FileModel document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _viewDocument(document),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getDocumentColor(document.mimeType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getDocumentIcon(document.mimeType),
                  color: _getDocumentColor(document.mimeType),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.displayName ?? document.originalName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFileTypeLabel(document.mimeType),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatFileSize(document.fileSize),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Action
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                color: AppColors.primary,
                onPressed: () => _viewDocument(document),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد مستندات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قم برفع المستندات أولاً',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              'حدث خطأ في تحميل المستندات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(userDocumentsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _viewDocument(FileModel document) async {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => DocumentPreviewDialog(document: document),
      );
    }
  }

  Color _getDocumentColor(String mimeType) {
    if (mimeType.contains('image')) return Colors.blue;
    if (mimeType.contains('pdf')) return Colors.red;
    return AppColors.primary;
  }

  IconData _getDocumentIcon(String mimeType) {
    if (mimeType.contains('image')) return Icons.image_outlined;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  String _getFileTypeLabel(String mimeType) {
    if (mimeType.contains('image')) return 'صورة';
    if (mimeType.contains('pdf')) return 'ملف PDF';
    if (mimeType.contains('word')) return 'مستند Word';
    if (mimeType.contains('excel')) return 'جدول Excel';
    return mimeType;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Dialog لعرض معلومات المستند
class DocumentPreviewDialog extends StatelessWidget {
  final FileModel document;

  const DocumentPreviewDialog({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final isImage = document.mimeType.toLowerCase().contains('image');
    final isPDF = document.mimeType.toLowerCase().contains('pdf');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isImage
                    ? Colors.blue.withOpacity(0.1)
                    : isPDF
                        ? Colors.red.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isImage
                    ? Icons.image_outlined
                    : isPDF
                        ? Icons.picture_as_pdf_outlined
                        : Icons.insert_drive_file_outlined,
                size: 40,
                color: isImage
                    ? Colors.blue
                    : isPDF
                        ? Colors.red
                        : AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              document.displayName ?? document.originalName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Details
            _buildDetailRow('النوع', _getFileTypeLabel(document.mimeType)),
            _buildDetailRow('الحجم', _formatFileSize(document.fileSize)),
            _buildDetailRow('تاريخ الرفع', _formatDate(document.createdAt)),

            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('إغلاق'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Open file
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('فتح'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _getFileTypeLabel(String mimeType) {
    if (mimeType.contains('image')) return 'صورة';
    if (mimeType.contains('pdf')) return 'ملف PDF';
    if (mimeType.contains('word')) return 'مستند Word';
    if (mimeType.contains('excel')) return 'جدول Excel';
    return mimeType;
  }
}
