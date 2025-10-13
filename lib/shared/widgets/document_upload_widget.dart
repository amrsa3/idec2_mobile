import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Document upload widget with support for images and files
class DocumentUploadWidget extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool isRequired;
  final bool enabled;
  final File? selectedFile;
  final String? existingFileUrl;
  final String? existingFileName;
  final List<String> allowedExtensions;
  final int maxFileSizeInMB;
  final bool allowImages;
  final bool allowDocuments;
  final String? Function(File?)? validator;
  final void Function(File?)? onFileSelected;
  final void Function()? onFileRemoved;
  final VoidCallback? onViewFile;

  const DocumentUploadWidget({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.isRequired = false,
    this.enabled = true,
    this.selectedFile,
    this.existingFileUrl,
    this.existingFileName,
    this.allowedExtensions = const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    this.maxFileSizeInMB = 5,
    this.allowImages = true,
    this.allowDocuments = true,
    this.validator,
    this.onFileSelected,
    this.onFileRemoved,
    this.onViewFile,
  });

  @override
  State<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State<DocumentUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  bool get hasFile =>
      widget.selectedFile != null || widget.existingFileUrl != null;

  String get fileName {
    if (widget.selectedFile != null) {
      return widget.selectedFile!.path.split('/').last;
    }
    return widget.existingFileName ?? 'ملف مرفق';
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
        _buildUploadArea(),
        if (widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
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

  Widget _buildUploadArea() {
    if (hasFile) {
      return _buildFilePreview();
    } else {
      return _buildUploadButton();
    }
  }

  Widget _buildUploadButton() {
    return InkWell(
      onTap: widget.enabled ? _showUploadOptions : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: widget.enabled
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.grey.withOpacity(0.1),
          border: Border.all(
            color: widget.errorText != null
                ? AppColors.error
                : AppColors.primary.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: widget.enabled ? AppColors.primary : AppColors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              widget.hint ?? 'اضغط لرفع الملف',
              style: AppTextStyles.bodyMedium.copyWith(
                color: widget.enabled ? AppColors.primary : AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _buildAllowedFormatsText(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildFileIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.selectedFile != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(widget.selectedFile!.lengthSync()),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildFileActions(),
        ],
      ),
    );
  }

  Widget _buildFileIcon() {
    IconData iconData;
    Color iconColor = AppColors.success;

    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        iconData = Icons.image;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        size: 24,
        color: iconColor,
      ),
    );
  }

  Widget _buildFileActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onViewFile != null || widget.existingFileUrl != null)
          IconButton(
            onPressed: widget.onViewFile,
            icon: const Icon(Icons.visibility),
            iconSize: 20,
            color: AppColors.primary,
            tooltip: 'عرض الملف',
          ),
        if (widget.enabled)
          IconButton(
            onPressed: _showUploadOptions,
            icon: const Icon(Icons.edit),
            iconSize: 20,
            color: AppColors.warning,
            tooltip: 'تغيير الملف',
          ),
        if (widget.enabled)
          IconButton(
            onPressed: _removeFile,
            icon: const Icon(Icons.delete),
            iconSize: 20,
            color: AppColors.error,
            tooltip: 'حذف الملف',
          ),
      ],
    );
  }

  String _buildAllowedFormatsText() {
    final formats =
        widget.allowedExtensions.map((e) => e.toUpperCase()).join(', ');
    return 'الصيغ المدعومة: $formats\nالحد الأقصى: ${widget.maxFileSizeInMB} ميجابايت';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes بايت';
    if (bytes < 1024 * 1024)
      return '${(bytes / 1024).toStringAsFixed(1)} كيلوبايت';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} ميجابايت';
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'اختر مصدر الملف',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (widget.allowImages) ...[
                _buildOptionTile(
                  icon: Icons.camera_alt,
                  title: 'الكاميرا',
                  subtitle: 'التقط صورة جديدة',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                _buildOptionTile(
                  icon: Icons.photo_library,
                  title: 'معرض الصور',
                  subtitle: 'اختر صورة من المعرض',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
              ],
              if (widget.allowDocuments)
                _buildOptionTile(
                  icon: Icons.folder,
                  title: 'الملفات',
                  subtitle: 'اختر ملف من الجهاز',
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument();
                  },
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        if (_validateFile(file)) {
          widget.onFileSelected?.call(file);
        }
      }
    } catch (e) {
      _showErrorSnackBar('فشل في التقاط الصورة: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        if (_validateFile(file)) {
          widget.onFileSelected?.call(file);
        }
      }
    } catch (e) {
      _showErrorSnackBar('فشل في اختيار الصورة: $e');
    }
  }

  Future<void> _pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.single;

        // في بيئة الويب، استخدم البيانات المرسلة مباشرة
        if (kIsWeb) {
          if (platformFile.bytes != null) {
            // في الويب، يمكن استخدام PlatformFile مباشرة
            debugPrint(
                '🌐 Web: Using PlatformFile with bytes for document upload');
            // يمكن إضافة منطق رفع الملفات هنا في المستقبل
            final file = File('web_file_${platformFile.name}');
            if (_validateFile(file)) {
              widget.onFileSelected?.call(file);
            }
          } else {
            debugPrint('❌ Web: No bytes available for document upload');
            _showErrorSnackBar('لم يتم توفير بيانات الملف');
          }
        } else {
          // في البيئات الأخرى (Android/iOS)، استخدم path
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            if (_validateFile(file)) {
              widget.onFileSelected?.call(file);
            }
          }
        }
      }
    } catch (e) {
      _showErrorSnackBar('فشل في اختيار الملف: $e');
    }
  }

  bool _validateFile(File file) {
    // Check file size
    final fileSizeInMB = file.lengthSync() / (1024 * 1024);
    if (fileSizeInMB > widget.maxFileSizeInMB) {
      _showErrorSnackBar(
          'حجم الملف كبير جداً. الحد الأقصى ${widget.maxFileSizeInMB} ميجابايت');
      return false;
    }

    // Check file extension
    final extension = file.path.split('.').last.toLowerCase();
    if (!widget.allowedExtensions.contains(extension)) {
      _showErrorSnackBar('صيغة الملف غير مدعومة');
      return false;
    }

    return true;
  }

  void _removeFile() {
    widget.onFileRemoved?.call();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Compact document upload widget for lists
class CompactDocumentUpload extends StatelessWidget {
  final String label;
  final File? selectedFile;
  final String? existingFileUrl;
  final bool isRequired;
  final bool enabled;
  final VoidCallback? onUpload;
  final VoidCallback? onView;
  final VoidCallback? onRemove;

  const CompactDocumentUpload({
    super.key,
    required this.label,
    this.selectedFile,
    this.existingFileUrl,
    this.isRequired = false,
    this.enabled = true,
    this.onUpload,
    this.onView,
    this.onRemove,
  });

  bool get hasFile => selectedFile != null || existingFileUrl != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasFile
            ? AppColors.success.withOpacity(0.05)
            : AppColors.grey.withOpacity(0.05),
        border: Border.all(
          color: hasFile
              ? AppColors.success.withOpacity(0.3)
              : AppColors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            hasFile ? Icons.check_circle : Icons.upload_file,
            color: hasFile ? AppColors.success : AppColors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (hasFile && onView != null)
            IconButton(
              onPressed: onView,
              icon: const Icon(Icons.visibility),
              iconSize: 16,
              color: AppColors.primary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          if (enabled)
            IconButton(
              onPressed: onUpload,
              icon: Icon(hasFile ? Icons.edit : Icons.upload),
              iconSize: 16,
              color: hasFile ? AppColors.warning : AppColors.primary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          if (hasFile && enabled && onRemove != null)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete),
              iconSize: 16,
              color: AppColors.error,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
        ],
      ),
    );
  }
}
