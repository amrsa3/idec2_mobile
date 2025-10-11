import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../models/user_profile_extended.dart';
import '../../../../models/verification_model.dart';
import '../../../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../providers/profile_rules_provider.dart';
import '../../services/profile_rules_service.dart';
import '../widgets/document_uploader.dart';
import '../widgets/zoomable_profile_image.dart';

/// شاشة إدارة الوثائق
class DocumentManagementScreen extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const DocumentManagementScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends ConsumerState<DocumentManagementScreen> {
  final Map<String, File?> _selectedDocuments = {};
  final Map<String, bool> _uploadingDocuments = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVerificationRules();
  }

  void _loadVerificationRules() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // تحميل قواعد الملف الشخصي الديناميكية
      await ref.read(profileRulesProvider.notifier).loadProfileRules();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'إدارة الوثائق',
        actions: [
          if (_hasChanges())
            TextButton(
              onPressed: _isLoading ? null : _saveDocuments,
              child: Text(
                'حفظ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(profileState),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.isLoading && !_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final profileRulesState = ref.watch(profileRulesProvider);
    
    // التحقق من توفر قواعد الملف الشخصي الجديدة
    if (profileRulesState.profileRules == null) {
      return const Center(
        child: Text(
          'لم يتم تحميل قواعد التوثيق',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    // استخدام النظام الجديد لتحديد الوثائق المطلوبة
    final requiredDocuments = _getRequiredDocumentsFromProfileRules(profileRulesState.profileRules!);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات عامة
          _buildInfoCard(),
          
          const SizedBox(height: 24),

          // الوثائق المطلوبة
          if (requiredDocuments.isNotEmpty) ...[
            _buildSectionTitle('الوثائق المطلوبة'),
            const SizedBox(height: 16),
            ...requiredDocuments.map((docType) => _buildDocumentSection(docType)),
          ],

          // الوثائق الاختيارية
          _buildSectionTitle('وثائق إضافية'),
          const SizedBox(height: 16),
          _buildOptionalDocumentsSection(),

          const SizedBox(height: 24),

          // أزرار الحفظ والإلغاء
          _buildActionButtons(),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final profileRulesState = ref.watch(profileRulesProvider);
    String infoText = _getInfoText(profileRulesState);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'معلومات مهمة',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            infoText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getInfoText(ProfileRulesState profileRulesState) {
    final verificationStatus = widget.profile.verificationStatus ?? VerificationStatus.notSubmitted;
    
    if (profileRulesState.profileRules != null) {
      final rules = profileRulesState.profileRules!;
      final canEdit = rules.canEditVerifiedProfile(verificationStatus);
      final requiredPercentage = rules.getRequiredCompletionPercentage(verificationStatus);
      
      String baseInfo = '• يجب رفع جميع الوثائق المطلوبة للحصول على توثيق الحساب\n'
                       '• تأكد من وضوح الوثائق وجودة الصورة\n'
                       '• الحد الأقصى لحجم الملف: 5 ميجابايت\n'
                       '• الصيغ المدعومة: PDF, JPG, PNG\n';
      
      if (verificationStatus == VerificationStatus.verified && !canEdit) {
        baseInfo += '• تم توثيق الملف الشخصي - لا يمكن تعديل الوثائق';
      } else if (verificationStatus == VerificationStatus.underReview) {
        baseInfo += '• الملف الشخصي قيد المراجعة - قد تكون بعض التعديلات محدودة';
      } else if (requiredPercentage > 0) {
        baseInfo += '• مطلوب إكمال $requiredPercentage% من البيانات للتوثيق';
      }
      
      return baseInfo;
    }
    
    // النص الافتراضي
    return '• يجب رفع جميع الوثائق المطلوبة للحصول على توثيق الحساب\n'
           '• تأكد من وضوح الوثائق وجودة الصورة\n'
           '• الحد الأقصى لحجم الملف: 5 ميجابايت\n'
           '• الصيغ المدعومة: PDF, JPG, PNG';
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleLarge.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDocumentSection(String documentType) {
    final DocumentType docType = _getDocumentTypeFromString(documentType);
    final currentDocumentUrl = widget.profile.documents
        .where((doc) => doc.documentType == docType)
        .isNotEmpty 
        ? widget.profile.documents
            .firstWhere((doc) => doc.documentType == docType)
            .fileUrl 
        : null;
    final selectedFile = _selectedDocuments[documentType];
    final isUploading = _uploadingDocuments[documentType] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getDocumentIcon(documentType),
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getDocumentDisplayName(documentType),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (currentDocumentUrl != null || selectedFile != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'مرفق',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // عرض الوثيقة الحالية
          if (currentDocumentUrl != null && selectedFile == null)
            _buildCurrentDocument(documentType, currentDocumentUrl),
          
          // عرض الملف المختار
          if (selectedFile != null)
            _buildSelectedDocument(documentType, selectedFile),
          
          const SizedBox(height: 16),
          
          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isUploading ? null : () => _selectDocument(documentType),
                  icon: Icon(
                    selectedFile != null ? Icons.change_circle : Icons.upload_file,
                    size: 20,
                  ),
                  label: Text(
                    selectedFile != null ? 'تغيير الملف' : 'اختيار ملف',
                  ),
                ),
              ),
              
              if (currentDocumentUrl != null || selectedFile != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isUploading ? null : () => _removeDocument(documentType),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('حذف'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          if (isUploading)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'جاري الرفع...',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentDocument(String documentType, String documentUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: AppColors.success,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوثيقة الحالية',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'تم رفعها مسبقاً',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _viewDocument(documentUrl),
            icon: const Icon(Icons.visibility_outlined),
            tooltip: 'عرض الوثيقة',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDocument(String documentType, File file) {
    final fileName = file.path.split('/').last;
    final fileSize = _formatFileSize(file.lengthSync());

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  fileSize,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _previewFile(file),
            icon: const Icon(Icons.visibility_outlined),
            tooltip: 'معاينة الملف',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalDocumentsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'وثائق إضافية',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            'يمكنك رفع وثائق إضافية لتعزيز ملفك الشخصي',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          OutlinedButton.icon(
            onPressed: () => _selectDocument('additional'),
            icon: const Icon(Icons.add),
            label: const Text('إضافة وثيقة'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading || !_hasChanges() ? null : _saveDocuments,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('حفظ الوثائق'),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
      ],
    );
  }

  // Helper methods
  List<String> _getRequiredDocumentsFromProfileRules(ProfileRulesNotifier profileRules) {
    // استخدام النظام الجديد لتحديد الوثائق المطلوبة
    final requiredDocs = profileRules.getRequiredDocumentsForVerification(
      widget.profile.verificationStatus ?? VerificationStatus.notSubmitted
    );
    return requiredDocs;
  }

  @deprecated
  List<String> _getRequiredDocuments(List<RequiredDocumentModel> rules) {
    final profileRulesState = ref.read(profileRulesProvider);
    
    // استخدام قواعد الملف الشخصي الديناميكية إذا كانت متاحة
    if (profileRulesState.profileRules != null) {
      final requiredDocs = profileRulesState.profileRules!.getRequiredDocumentsForVerification(
        widget.profile.verificationStatus ?? VerificationStatus.notSubmitted
      );
      return requiredDocs;
    }
    
    // العودة للقواعد التقليدية كنسخة احتياطية
    if (rules.isNotEmpty) {
      return rules.map((rule) => rule.documentType).toList();
    }
    
    // القيم الافتراضية
    return ['qualification', 'identity'];
  }

  String _getDocumentDisplayName(String documentType) {
    switch (documentType) {
      case 'qualification':
        return 'وثيقة المؤهل العلمي';
      case 'identity':
        return 'وثيقة الهوية';
      case 'certificate':
        return 'الشهادات';
      case 'additional':
        return 'وثائق إضافية';
      default:
        return documentType;
    }
  }

  DocumentType _getDocumentTypeFromString(String documentType) {
    switch (documentType) {
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

  IconData _getDocumentIcon(String documentType) {
    switch (documentType) {
      case 'qualification':
        return Icons.school;
      case 'identity':
        return Icons.badge;
      case 'certificate':
        return Icons.workspace_premium;
      case 'additional':
        return Icons.description;
      default:
        return Icons.description;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool _hasChanges() {
    return _selectedDocuments.values.any((file) => file != null);
  }

  // Action methods
  void _selectDocument(String documentType) async {
    // فحص القواعد قبل السماح برفع الوثيقة
    final profileRulesState = ref.read(profileRulesProvider);
    if (profileRulesState.profileRules != null) {
      final canEdit = profileRulesState.profileRules!.canEditVerifiedProfile(
        widget.profile.verificationStatus ?? VerificationStatus.notSubmitted
      );
      
      if (!canEdit && widget.profile.verificationStatus == VerificationStatus.verified) {
        _showEditNotAllowedDialog('لا يمكن تعديل الوثائق للملفات الموثقة');
        return;
      }
    }
    
    try {
      // TODO: Implement file picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سيتم تنفيذ اختيار الملفات قريباً')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء اختيار الملف: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removeDocument(String documentType) {
    // فحص القواعد قبل السماح بحذف الوثيقة
    final profileRulesState = ref.read(profileRulesProvider);
    if (profileRulesState.profileRules != null) {
      final canEdit = profileRulesState.profileRules!.canEditVerifiedProfile(
        widget.profile.verificationStatus ?? VerificationStatus.notSubmitted
      );
      
      if (!canEdit && widget.profile.verificationStatus == VerificationStatus.verified) {
        _showEditNotAllowedDialog('لا يمكن حذف الوثائق للملفات الموثقة');
        return;
      }
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الوثيقة'),
        content: const Text('هل أنت متأكد من أنك تريد حذف هذه الوثيقة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedDocuments[documentType] = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف الوثيقة')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _viewDocument(String documentUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ZoomableProfileImage(
          imageUrl: documentUrl,
          heroTag: 'document_$documentUrl',
        ),
      ),
    );
  }

  void _previewFile(File file) {
    // TODO: Implement file preview
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تنفيذ معاينة الملفات قريباً')),
    );
  }

  void _saveDocuments() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implement document upload
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الوثائق بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء حفظ الوثائق: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showEditNotAllowedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل غير مسموح'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}