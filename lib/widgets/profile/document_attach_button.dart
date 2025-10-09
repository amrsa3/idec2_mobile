import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/profile/providers/profile_provider.dart';
import '../../models/profile_model.dart';

/// زر إرفاق وثيقة
class DocumentAttachButton extends ConsumerWidget {
  final String fieldName;
  final String label;

  const DocumentAttachButton({
    super.key,
    required this.fieldName,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final hasDocument = _hasDocument(profileState.currentProfile, fieldName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: profileState.isUploadingDocument
              ? null
              : () => _pickAndUploadDocument(context, ref),
          icon: Icon(hasDocument ? Icons.check_circle : Icons.attach_file),
          label: Text(hasDocument ? 'تم إرفاق الوثيقة' : 'إرفاق وثيقة $label'),
          style: OutlinedButton.styleFrom(
            foregroundColor: hasDocument ? Colors.green : null,
          ),
        ),
        if (hasDocument) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.description, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _getDocumentFileName(profileState.currentProfile!, fieldName),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _pickAndUploadDocument(
      BuildContext context, WidgetRef ref) async {
    try {
      // Show options: Camera or Gallery
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('اختر مصدر الوثيقة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('الكاميرا'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('المعرض'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final documentType = _getDocumentTypeString(fieldName);
        
        final success = await ref
            .read(profileProvider.notifier)
            .uploadDocumentForField(
              fieldName: fieldName,
              documentType: documentType,
              file: file,
            );

        if (context.mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفع الوثيقة بنجاح')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في رفع الوثيقة: $e')),
        );
      }
    }
  }

  /// Check if document exists for field
  bool _hasDocument(ProfileModel? profile, String fieldName) {
    if (profile == null) return false;
    final docType = _getDocumentTypeFromString(fieldName);
    return profile.documents.any((doc) => doc.documentType == docType);
  }

  /// Get document file name
  String _getDocumentFileName(ProfileModel profile, String fieldName) {
    final docType = _getDocumentTypeFromString(fieldName);
    try {
      final doc = profile.documents.firstWhere(
        (doc) => doc.documentType == docType,
      );
      return doc.originalName;
    } catch (e) {
      return 'وثيقة غير معروفة';
    }
  }

  /// Convert field name to DocumentType
  DocumentType _getDocumentTypeFromString(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'qualification':
        return DocumentType.qualification;
      case 'identity':
        return DocumentType.identity;
      case 'certificate':
        return DocumentType.certificate;
      case 'license':
        return DocumentType.license;
      default:
        return DocumentType.other;
    }
  }

  /// Convert field name to document type string
  String _getDocumentTypeString(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'qualification':
        return 'qualification';
      case 'identity':
        return 'identity';
      case 'certificate':
        return 'certificate';
      case 'license':
        return 'license';
      default:
        return 'other';
    }
  }
}
