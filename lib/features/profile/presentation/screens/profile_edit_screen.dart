import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/smart_message_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/profile_rule_model.dart';
import '../../../../providers/profile_rules_provider.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_button.dart';
import '../../../../shared/widgets/upload_progress_dialog.dart';
import '../../../../widgets/profile/document_picker_widget.dart';
import '../../providers/profile_provider.dart';

/// شاشة تعديل البيانات الشخصية
class ProfileEditScreen extends ConsumerStatefulWidget {
  final ProfileModel profile;

  const ProfileEditScreen({
    super.key,
    required this.profile,
  });

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers للحقول النصية
  late final TextEditingController _fullNameArController;
  late final TextEditingController _fullNameEnController;
  late final TextEditingController _emailController;
  late final TextEditingController _graduationYearController;
  late final TextEditingController _universityController;
  late final TextEditingController _workplaceController;

  // متغيرات للقيم المختارة
  DateTime? _selectedBirthDate;
  String? _selectedGovernorateId;
  String? _selectedQualificationId;

  // متغيرات لحالة التحميل والأخطاء
  bool _isLoading = false;
  bool _isSaving = false;
  Map<String, String> _fieldErrors = {};
  Map<String, bool> _fieldEditability = {};

  // متغيرات لتتبع حالة رفع الملفات
  Map<int, double> _uploadProgress = {}; // تقدم رفع كل ملف
  Map<int, bool> _uploadSuccess = {}; // نجاح رفع كل ملف
  Map<int, String> _uploadErrors = {}; // أخطاء رفع كل ملف
  bool _isUploadingFiles = false;

  List<String> _missingRequiredFields = [];

  // قائمة الملفات المختارة للرفع
  List<SelectedDocument> _selectedDocuments = [];

  // متغير لسنة التخرج المختارة
  int? _selectedGraduationYear;

  // دالة لتوليد قائمة السنوات
  List<DropdownMenuItem<int>> _getGraduationYearItems() {
    final currentYear = DateTime.now().year;
    final startYear = 1950;
    final endYear = currentYear + 5;

    List<DropdownMenuItem<int>> items = [];

    for (int year = endYear; year >= startYear; year--) {
      items.add(
        DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        ),
      );
    }

    return items;
  }

  /// التحقق من وجود تغييرات في الحقول التي تتطلب وثائق
  bool _hasDocumentRequiringChanges(WidgetRef ref) {
    try {
      // التحقق من صحة البيانات الأساسية
      if (widget.profile == null) {
        debugPrint('⚠️ لا يمكن التحقق من التغييرات: الملف الشخصي غير متاح');
        return false;
      }

      // قائمة الحقول التي قد تتطلب وثائق
      final fieldsToCheck = [
        'fullNameAr',
        'fullNameEn',
        'email',
        'birthDate',
        'governorateId',
        'qualificationId',
        'graduationYear',
        'university',
        'workplace'
      ];

      for (final fieldName in fieldsToCheck) {
        try {
          // التحقق من وجود تغيير في الحقل مع null safety
          bool hasChange = false;

          switch (fieldName) {
            case 'fullNameAr':
              final currentValue = _fullNameArController.text.trim();
              final originalValue = widget.profile.fullNameAr ?? '';
              hasChange = currentValue != originalValue;
              break;
            case 'fullNameEn':
              final currentValue = _fullNameEnController.text.trim();
              final originalValue = widget.profile.fullNameEn ?? '';
              hasChange = currentValue != originalValue;
              break;
            case 'email':
              final currentValue = _emailController.text.trim();
              final originalValue = widget.profile.email ?? '';
              hasChange = currentValue != originalValue;
              break;
            case 'birthDate':
              hasChange = _selectedBirthDate != widget.profile.birthDate;
              break;
            case 'governorateId':
              // معالجة خاصة للمحافظة مع null safety
              final currentValue = _selectedGovernorateId ?? '';
              final originalValue = widget.profile.governorateId ?? '';
              hasChange = currentValue != originalValue;
              break;
            case 'qualificationId':
              // معالجة خاصة للمؤهل مع null safety
              final currentValue = _selectedQualificationId ?? '';
              final originalValue = widget.profile.qualificationId ?? '';
              hasChange = currentValue != originalValue;
              debugPrint(
                  '🎓 فحص تغيير المؤهل: الحالي="$currentValue", الأصلي="$originalValue", تغيير=$hasChange');
              break;
            case 'graduationYear':
              // معالجة خاصة لسنة التخرج مع null safety
              final currentValue = _selectedGraduationYear;
              final originalValue = widget.profile.graduationYear;
              hasChange = currentValue != originalValue;
              break;
            case 'university':
              final currentValue = _universityController.text.trim();
              final originalValue = widget.profile.university ?? '';
              hasChange = currentValue != originalValue;
              break;
            case 'workplace':
              final currentValue = _workplaceController.text.trim();
              final originalValue = widget.profile.workplace ?? '';
              hasChange = currentValue != originalValue;
              break;
          }

          // إذا كان هناك تغيير، التحقق من الحاجة للوثيقة
          if (hasChange) {
            debugPrint('📝 تم اكتشاف تغيير في الحقل: $fieldName');

            // التحقق من الحاجة للوثيقة مع معالجة الأخطاء
            final requiresDoc = _requiresDocument(fieldName, ref);
            if (requiresDoc) {
              debugPrint('📄 الحقل $fieldName يتطلب وثيقة');
              return true;
            }
          }
        } catch (fieldError) {
          debugPrint('❌ خطأ في فحص الحقل $fieldName: $fieldError');
          // الاستمرار في فحص الحقول الأخرى
          continue;
        }
      }

      return false;
    } catch (e, stackTrace) {
      debugPrint('❌ خطأ عام في التحقق من التغييرات التي تتطلب وثائق: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).initializeProfilePage();
    });
  }

  void _retryLoadData() {
    // إعادة تحميل البيانات مع مسح الكاش
    ref.read(profileProvider.notifier).refresh();

    // إظهار رسالة للمستخدم
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('جاري إعادة تحميل البيانات...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _initializeForm() {
    _initializeControllers();
    _loadProfileRules();
  }

  void _initializeControllers() {
    _fullNameArController =
        TextEditingController(text: widget.profile.fullNameAr ?? '');
    _fullNameEnController =
        TextEditingController(text: widget.profile.fullNameEn ?? '');
    _emailController = TextEditingController(text: widget.profile.email ?? '');
    _graduationYearController = TextEditingController(
      text: widget.profile.graduationYear?.toString() ?? '',
    );
    _universityController =
        TextEditingController(text: widget.profile.university ?? '');
    _workplaceController =
        TextEditingController(text: widget.profile.workplace ?? '');

    _selectedBirthDate = widget.profile.birthDate;

    // التعامل مع governorateId - تحويل "0" إلى null لتجنب خطأ DropdownButton
    final governorateId = widget.profile.governorateId;
    if (governorateId == null ||
        governorateId.isEmpty ||
        governorateId == "0") {
      _selectedGovernorateId = null;
    } else {
      _selectedGovernorateId = governorateId;
    }

    // التعامل مع qualificationId - تحويل القيم غير الصالحة إلى null لتجنب خطأ DropdownButton
    final qualificationId = widget.profile.qualificationId;
    if (qualificationId == null ||
        qualificationId.isEmpty ||
        qualificationId == "0" ||
        qualificationId.trim().isEmpty) {
      _selectedQualificationId = null;
      debugPrint(
          '🔄 تم تعيين qualificationId إلى null (القيمة الأصلية: "$qualificationId")');
    } else {
      _selectedQualificationId = qualificationId;
      debugPrint('✅ تم تعيين qualificationId إلى: "$qualificationId"');
    }

    _selectedGraduationYear = widget.profile.graduationYear;
  }

  void _loadProfileRules() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔍 [PROFILE_EDIT] جلب قواعد الملف الشخصي للمستخدم الحالي...');

      // جلب القواعد للمستخدم الحالي (يتم فحص الحالة تلقائياً في الخادم)
      ref
          .read(profileRulesProvider.notifier)
          .loadRulesForCurrentUser(forceRefresh: true);

      // طباعة حالة الملف الشخصي الحالية للتأكد من صحة التطبيق
      final profileState = ref.read(profileProvider);
      final currentProfile = profileState.currentProfile;
      if (currentProfile != null) {
        final profileStatus = _convertVerificationStatusToProfileStatus(
            currentProfile.verificationStatus);
        debugPrint(
            '📋 [PROFILE_EDIT] حالة الملف الشخصي الحالية: $profileStatus');
        debugPrint(
            '📋 [PROFILE_EDIT] حالة التوثيق: ${currentProfile.verificationStatus}');
      }
    });
  }

  @override
  void dispose() {
    _fullNameArController.dispose();
    _fullNameEnController.dispose();
    _emailController.dispose();
    _graduationYearController.dispose();
    _universityController.dispose();
    _workplaceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// النظام الهرمي الجديد لتصنيف الملفات
  /// المستوى الأول: الفئات الرئيسية (profile, documents, attachments, certificates)
  /// المستوى الثاني: أنواع الملفات (image, pdf, word, excel, text)
  /// المستوى الثالث: الترقيم (1, 2, 3...)
  String _getSmartFileCategory(int index, String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    // تحديد الفئة الرئيسية
    String mainCategory;
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      mainCategory = 'profile_image'; // الصور الشخصية
    } else {
      mainCategory = 'documents'; // الوثائق المطلوبة
    }

    // تحديد نوع الملف
    String fileType;
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
      fileType = 'image';
    } else if (extension == 'pdf') {
      fileType = 'pdf';
    } else if (['doc', 'docx'].contains(extension)) {
      fileType = 'word';
    } else if (['xls', 'xlsx'].contains(extension)) {
      fileType = 'excel';
    } else if (['txt', 'rtf'].contains(extension)) {
      fileType = 'text';
    } else {
      fileType = 'other'; // أنواع أخرى
    }

    return '${mainCategory}_${fileType}_${index + 1}';
  }

  /// الحصول على اسم عرضي للملف حسب فئته الذكية
  String _getSmartFileDisplayName(String category) {
    if (category.startsWith('profile_image_')) {
      return 'صورة شخصية';
    } else if (category.startsWith('documents_pdf_')) {
      return 'وثيقة PDF';
    } else if (category.startsWith('documents_word_')) {
      return 'وثيقة Word';
    } else if (category.startsWith('documents_excel_')) {
      return 'ملف Excel';
    } else if (category.startsWith('documents_text_')) {
      return 'ملف نصي';
    } else if (category.startsWith('documents_')) {
      return 'وثيقة';
    } else {
      return 'ملف';
    }
  }

  /// الحصول على أيقونة الملف حسب فئته الذكية
  IconData _getSmartFileIcon(String category) {
    if (category.startsWith('profile_image_')) {
      return Icons.person;
    } else if (category.startsWith('documents_pdf_')) {
      return Icons.picture_as_pdf;
    } else if (category.startsWith('documents_word_')) {
      return Icons.description;
    } else if (category.startsWith('documents_excel_')) {
      return Icons.table_chart;
    } else if (category.startsWith('documents_text_')) {
      return Icons.text_snippet;
    } else if (category.startsWith('documents_')) {
      return Icons.attach_file;
    } else {
      return Icons.insert_drive_file;
    }
  }

  /// الحصول على الرسالة باللغة العربية حسب الكود
  String _getMessageByCode(
      String code, int successfulUploads, int totalUploads) {
    switch (code) {
      case 'PROFILE_EDIT_WITH_DOCS_SUCCESS':
        return 'تم حفظ البيانات ورفع جميع الوثائق بنجاح';
      case 'PROFILE_EDIT_PARTIAL_DOCS_SUCCESS':
        return 'تم حفظ البيانات ورفع $successfulUploads من $totalUploads وثائق';
      case 'PROFILE_EDIT_DOCS_FAILED':
        return 'تم حفظ البيانات لكن فشل في رفع الوثائق';
      case 'PROFILE_EDIT_FAILED':
        return 'فشل في حفظ البيانات';
      case 'PROFILE_EDIT_SUCCESS':
        return 'تم حفظ البيانات بنجاح';
      default:
        return 'تم حفظ البيانات بنجاح';
    }
  }

  /// الحصول على الرسالة باللغة الإنجليزية حسب الكود
  String _getMessageByCodeEn(
      String code, int successfulUploads, int totalUploads) {
    switch (code) {
      case 'PROFILE_EDIT_WITH_DOCS_SUCCESS':
        return 'Data saved and all documents uploaded successfully';
      case 'PROFILE_EDIT_PARTIAL_DOCS_SUCCESS':
        return 'Data saved and $successfulUploads of $totalUploads documents uploaded';
      case 'PROFILE_EDIT_DOCS_FAILED':
        return 'Data saved but failed to upload documents';
      case 'PROFILE_EDIT_FAILED':
        return 'Failed to save data';
      case 'PROFILE_EDIT_SUCCESS':
        return 'Data saved successfully';
      default:
        return 'Data saved successfully';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileRulesState = ref.watch(profileRulesProvider);

    // إظهار رسالة خطأ إذا فشل جلب القواعد
    if (profileRulesState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileRulesState.error!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'إعادة المحاولة',
              textColor: Colors.white,
              onPressed: () {
                if (mounted) {
                  ref
                      .read(profileRulesProvider.notifier)
                      .loadRules(forceRefresh: true);
                }
              },
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
      ),
      body: _buildBody(profileState),
    );
  }

  bool _canSave(ProfileState state) {
    if (_isSaving || state.isLoading) return false;

    // Check if required fields are filled
    _validateRequiredFields();
    return _missingRequiredFields.isEmpty;
  }

  void _validateRequiredFields() {
    _missingRequiredFields.clear();

    if (_fullNameArController.text.trim().isEmpty) {
      _missingRequiredFields.add('الاسم العربي');
    }
    if (_fullNameEnController.text.trim().isEmpty) {
      _missingRequiredFields.add('الاسم الإنجليزي');
    }
    if (_selectedGovernorateId == null || _selectedGovernorateId!.isEmpty) {
      _missingRequiredFields.add('المحافظة');
    }
    if (_selectedQualificationId == null || _selectedQualificationId!.isEmpty) {
      _missingRequiredFields.add('المؤهل العلمي');
    }
    if (_selectedBirthDate == null) {
      _missingRequiredFields.add('تاريخ الميلاد');
    }
    // سنة التخرج لم تعد مطلوبة
  }

  bool _canRequestVerification() {
    _validateRequiredFields();

    // Check if all required fields are filled and at least one document is attached
    return _missingRequiredFields.isEmpty && _hasAnyDocument();
  }

  bool _hasAnyDocument() {
    final profile = ref.read(profileProvider).currentProfile;
    return profile?.documents.isNotEmpty ?? false;
  }

  Widget _buildDateField() {
    return Consumer(
      builder: (context, ref, child) {
        final profileState = ref.watch(profileProvider);
        final currentProfile = profileState.currentProfile;

        if (currentProfile == null) return const SizedBox.shrink();

        final profileStatus = _convertVerificationStatusToProfileStatus(
            currentProfile.verificationStatus);
        final isEditable = ref.watch(canEditFieldProvider((
          fieldName: 'birthDate',
          status: profileStatus,
        )));
        print('DEBUG: birthDate field enabled: $isEditable');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تاريخ الميلاد',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: isEditable
                  ? () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedBirthDate ?? DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => _selectedBirthDate = date);
                      }
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isEditable ? Colors.grey : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: isEditable ? null : Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedBirthDate != null
                            ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                            : 'اختر تاريخ الميلاد',
                        style: TextStyle(
                          color: _selectedBirthDate != null
                              ? (isEditable
                                  ? Colors.black
                                  : Colors.grey.shade600)
                              : Colors.grey,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: isEditable ? null : Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.isLoading && !_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رسالة تحذيرية إذا كان الحساب موثق
            if (widget.profile.isVerified) _buildVerifiedAccountWarning(),

            // البيانات الشخصية
            _buildPersonalDataSection(state),

            const SizedBox(height: 24),

            // البيانات الأكاديمية
            _buildAcademicDataSection(state),

            const SizedBox(height: 24),

            // مؤشر تقدم رفع الملفات
            _buildUploadProgressWidget(),

            const SizedBox(height: 24),

            // أزرار الحفظ والإلغاء
            _buildActionButtons(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedAccountWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.1),
            AppColors.warning.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.verified_user,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'حساب موثق ✓',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDataSection(ProfileState state) {
    return _buildSection(
      title: 'البيانات الشخصية',
      icon: Icons.person_outline,
      children: [
        // الاسم العربي
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final canEdit = ref.watch(canEditFieldProvider((
              fieldName: 'fullNameAr',
              status: profileStatus,
            )));

            debugPrint(
                '🔍 [CONSUMER] فحص تعديل fullNameAr: $canEdit للحالة: $profileStatus');

            return CustomTextField(
              controller: _fullNameArController,
              label: 'الاسم العربي',
              isRequired: true,
              enabled: canEdit,
              validator: (value) => _validateField('fullNameAr', value),
              errorText: _fieldErrors['fullNameAr'],
              suffixIcon: _buildDocumentIcon('fullNameAr'),
            );
          },
        ),

        const SizedBox(height: 16),

        // الاسم الإنجليزي
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final canEdit = ref.watch(canEditFieldProvider((
              fieldName: 'fullNameEn',
              status: profileStatus,
            )));

            debugPrint(
                '🔍 [CONSUMER] فحص تعديل fullNameEn: $canEdit للحالة: $profileStatus');

            return CustomTextField(
              controller: _fullNameEnController,
              label: 'الاسم الإنجليزي',
              isRequired: true,
              enabled: canEdit,
              validator: (value) => _validateField('fullNameEn', value),
              errorText: _fieldErrors['fullNameEn'],
              suffixIcon: _buildDocumentIcon('fullNameEn'),
            );
          },
        ),

        const SizedBox(height: 16),

        // البريد الإلكتروني
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final isEditable = ref.watch(canEditFieldProvider((
              fieldName: 'email',
              status: profileStatus,
            )));
            print('DEBUG: email field enabled: $isEditable');

            return CustomTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              keyboardType: TextInputType.emailAddress,
              enabled: isEditable,
              suffixIcon: Icon(
                Icons.email_outlined,
                color: AppColors.textSecondary,
                size: 20,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // تاريخ الميلاد
        _buildDateField(),

        const SizedBox(height: 16),

        // المحافظة
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final isEditable = ref.watch(canEditFieldProvider((
              fieldName: 'governorateId',
              status: profileStatus,
            )));
            print('DEBUG: governorateId field enabled: $isEditable');

            // معالجة آمنة للقيمة المختارة
            final governorateItems = _getGovernorateItems(state);
            final validValues =
                governorateItems.map((item) => item.value).toSet();

            // التحقق من صحة القيمة المختارة
            String? safeValue = _selectedGovernorateId;
            if (safeValue != null &&
                (safeValue.isEmpty ||
                    safeValue == "0" ||
                    !validValues.contains(safeValue))) {
              debugPrint(
                  '⚠️ إعادة تعيين قيمة المحافظة غير الصالحة: "$safeValue"');
              safeValue = null;
              // تحديث القيمة في الحالة
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedGovernorateId = null;
                  });
                }
              });
            }

            return CustomDropdown<String>(
              label: 'المحافظة',
              value: safeValue,
              items: governorateItems,
              isRequired: true,
              enabled: isEditable,
              onChanged: (value) =>
                  setState(() => _selectedGovernorateId = value),
              validator: (value) => _validateField('governorateId', value),
              errorText: _fieldErrors['governorateId'],
              suffixIcon: _buildDocumentIcon('governorateId'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAcademicDataSection(ProfileState state) {
    return _buildSection(
      title: 'البيانات الأكاديمية',
      icon: Icons.school_outlined,
      children: [
        // المؤهل العلمي
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final canEdit = ref.watch(canEditFieldProvider((
              fieldName: 'qualificationId',
              status: profileStatus,
            )));

            debugPrint(
                '🔍 [CONSUMER] فحص تعديل qualificationId: $canEdit للحالة: $profileStatus');

            // الحصول على قائمة العناصر المتاحة
            final qualificationItems = _getQualificationItems(state);

            // التحقق الآمن من صحة القيمة المختارة
            String? safeValue = _selectedQualificationId;

            // معالجة القيم غير الصالحة
            if (safeValue != null) {
              if (safeValue.isEmpty ||
                  safeValue == "0" ||
                  safeValue.trim().isEmpty) {
                safeValue = null;
              } else {
                // التحقق من وجود القيمة في قائمة العناصر
                final validValues =
                    qualificationItems.map((item) => item.value).toSet();
                if (!validValues.contains(safeValue)) {
                  debugPrint(
                      '⚠️ القيمة المختارة غير موجودة في القائمة: "$safeValue"');
                  safeValue = null;
                }
              }
            }

            // تحديث القيمة إذا تغيرت
            if (safeValue != _selectedQualificationId) {
              debugPrint(
                  '🔄 تصحيح قيمة المؤهل من "$_selectedQualificationId" إلى "$safeValue"');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _selectedQualificationId = safeValue;
                  });
                }
              });
            }

            return CustomDropdown<String>(
              label: 'المؤهل العلمي',
              value: safeValue,
              items: qualificationItems,
              isRequired: true,
              enabled: canEdit,
              onChanged: (value) {
                debugPrint('🔄 تغيير قيمة المؤهل إلى: "$value"');
                setState(() => _selectedQualificationId = value);
              },
              validator: (value) => _validateField('qualificationId', value),
              errorText: _fieldErrors['qualificationId'],
              suffixIcon: _buildDocumentIcon('qualificationId'),
            );
          },
        ),

        const SizedBox(height: 16),

        // زر إرفاق وثيقة (يظهر فقط عند وجود تغييرات تتطلب وثائق)
        Consumer(
          builder: (context, ref, child) {
            final hasDocumentChanges = _hasDocumentRequiringChanges(ref);
            if (hasDocumentChanges) {
              return Column(
                children: [
                  _buildDocumentUploadSection(),
                  const SizedBox(height: 16),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // سنة التخرج (اختياري)
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final isEditable = ref.watch(canEditFieldProvider((
              fieldName: 'graduationYear',
              status: profileStatus,
            )));
            print('DEBUG: graduationYear field enabled: $isEditable');

            return CustomDropdown<int>(
              label: 'سنة التخرج',
              value: _selectedGraduationYear,
              items: _getGraduationYearItems(),
              isRequired: false,
              enabled: isEditable,
              onChanged: (value) =>
                  setState(() => _selectedGraduationYear = value),
              validator: (value) => null, // No validation for optional field
              errorText: _fieldErrors['graduationYear'],
              suffixIcon: _buildDocumentIcon('graduationYear'),
            );
          },
        ),

        const SizedBox(height: 16),

        // الجامعة (اختياري)
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final isEditable = ref.watch(canEditFieldProvider((
              fieldName: 'university',
              status: profileStatus,
            )));
            print('DEBUG: university field enabled: $isEditable');

            return CustomTextField(
              controller: _universityController,
              label: 'الجامعة',
              isRequired: false,
              enabled: isEditable,
              validator: (value) => null, // No validation for optional field
              errorText: _fieldErrors['university'],
              suffixIcon: _buildDocumentIcon('university'),
            );
          },
        ),

        const SizedBox(height: 16),

        // مكان العمل
        Consumer(
          builder: (context, ref, child) {
            final profileState = ref.watch(profileProvider);
            final currentProfile = profileState.currentProfile;

            if (currentProfile == null) return const SizedBox.shrink();

            final profileStatus = _convertVerificationStatusToProfileStatus(
                currentProfile.verificationStatus);
            final isEditable = ref.watch(canEditFieldProvider((
              fieldName: 'workplace',
              status: profileStatus,
            )));
            print('DEBUG: workplace field enabled: $isEditable');

            return CustomTextField(
              controller: _workplaceController,
              label: 'مكان العمل',
              enabled: isEditable,
              validator: (value) => _validateField('workplace', value),
              errorText: _fieldErrors['workplace'],
              suffixIcon: _buildDocumentIcon('workplace'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentUploadSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'إرفاق الوثائق',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Widget جديد لاختيار الملفات
          DocumentPickerWidget(
            selectedDocuments: _selectedDocuments,
            onDocumentsChanged: (documents) {
              setState(() {
                _selectedDocuments = documents;
              });
            },
          ),
        ],
      ),
    );
  }

  String? _validateField(String fieldName, String? value) {
    // التحقق من قواعد التوثيق الديناميكية باستخدام ProfileRulesProvider
    final rulesNotifier = ref.read(profileRulesProvider.notifier);
    final profileStatus = _convertVerificationStatusToProfileStatus(
        widget.profile.verificationStatus);

    // التحقق من الحقول المطلوبة باستخدام القواعد الديناميكية
    final requiredFields = rulesNotifier.getRequiredFieldsForVerification();
    bool isRequired = requiredFields.contains(fieldName);

    // الحقول المطلوبة الافتراضية كنسخة احتياطية
    if (!isRequired) {
      final defaultRequiredFields = [
        'fullNameAr',
        'fullNameEn',
        'birthDate',
        'governorateId',
        'qualificationId',
      ];
      isRequired = defaultRequiredFields.contains(fieldName);
    }

    // التحقق من الحقول المطلوبة
    if (isRequired && (value == null || value.isEmpty)) {
      return 'هذا الحقل مطلوب';
    }

    // التحقق من سنة التخرج
    if (fieldName == 'graduationYear' && value != null && value.isNotEmpty) {
      final year = int.tryParse(value);
      if (year == null || year < 1950 || year > DateTime.now().year) {
        return 'يرجى إدخال سنة تخرج صحيحة';
      }
    }

    // التحقق من البريد الإلكتروني
    if (fieldName == 'email' && value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'يرجى إدخال بريد إلكتروني صحيح';
      }
    }

    return null;
  }

  List<DropdownMenuItem<String>> _getGovernorateItems(ProfileState state) {
    try {
      // إذا كانت البيانات فارغة أو null
      if (state.governorates?.isEmpty ?? true) {
        // إعادة تعيين القيمة المختارة إلى null فوراً
        if (_selectedGovernorateId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedGovernorateId = null;
              });
            }
          });
        }

        // إذا كان هناك خطأ في التحميل
        if (state.error != null && state.error!.isNotEmpty) {
          return [
            DropdownMenuItem<String>(
              value: null,
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('فشل تحميل المحافظات')),
                  TextButton(
                    onPressed: () => _retryLoadData(),
                    child: const Text('إعادة المحاولة',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ];
        }

        // إذا كان التحميل جاري
        return [
          const DropdownMenuItem<String>(
            value: null,
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('جاري تحميل المحافظات...'),
              ],
            ),
          ),
        ];
      }

      // إنشاء قائمة العناصر من البيانات المحملة
      List<DropdownMenuItem<String>> items = [];
      final validValues = <String?>{}; // تتبع القيم الصالحة

      // إضافة عنصر فارغ اختياري
      items.add(
        const DropdownMenuItem<String>(
          value: null,
          child: Text('اختر المحافظة'),
        ),
      );
      validValues.add(null);

      // إضافة المحافظات المتاحة
      for (final governorate in state.governorates!) {
        if (governorate.id.isNotEmpty &&
            governorate.id != "0" &&
            governorate.id.trim().isNotEmpty &&
            !validValues.contains(governorate.id)) {
          validValues.add(governorate.id);
          items.add(
            DropdownMenuItem<String>(
              value: governorate.id,
              child: Text(governorate.nameAr),
            ),
          );
        }
      }

      // التحقق الفوري من صحة القيمة المختارة
      if (_selectedGovernorateId != null) {
        // معالجة القيم غير الصالحة
        if (_selectedGovernorateId!.isEmpty ||
            _selectedGovernorateId == "0" ||
            _selectedGovernorateId!.trim().isEmpty ||
            !validValues.contains(_selectedGovernorateId)) {
          debugPrint(
              '⚠️ القيمة المختارة للمحافظة غير صالحة: "$_selectedGovernorateId"');
          debugPrint('⚠️ القيم الصالحة: $validValues');

          // إعادة تعيين فورية
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedGovernorateId = null;
              });
            }
          });
        }
      }

      return items;
    } catch (e) {
      debugPrint('❌ خطأ في _getGovernorateItems: $e');

      // في حالة حدوث خطأ، إعادة تعيين القيمة المختارة فوراً
      if (_selectedGovernorateId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedGovernorateId = null;
            });
          }
        });
      }

      return [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('خطأ في تحميل المحافظات'),
        ),
      ];
    }
  }

  List<DropdownMenuItem<String>> _getQualificationItems(ProfileState state) {
    try {
      // إذا كانت البيانات فارغة أو null
      if (state.qualifications?.isEmpty ?? true) {
        // إعادة تعيين القيمة المختارة إلى null فوراً
        if (_selectedQualificationId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedQualificationId = null;
              });
            }
          });
        }

        // إذا كان هناك خطأ في التحميل
        if (state.error != null && state.error!.isNotEmpty) {
          return [
            DropdownMenuItem<String>(
              value: null,
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('فشل تحميل المؤهلات')),
                  TextButton(
                    onPressed: () => _retryLoadData(),
                    child: const Text('إعادة المحاولة',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ];
        }

        // إذا كان التحميل جاري
        return [
          const DropdownMenuItem<String>(
            value: null,
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('جاري تحميل المؤهلات...'),
              ],
            ),
          ),
        ];
      }

      // إنشاء قائمة العناصر من البيانات المحملة
      List<DropdownMenuItem<String>> items = [];
      final validValues = <String?>{}; // تتبع القيم الصالحة

      // إضافة عنصر فارغ اختياري
      items.add(
        const DropdownMenuItem<String>(
          value: null,
          child: Text('اختر المؤهل العلمي'),
        ),
      );
      validValues.add(null);

      // إضافة المؤهلات المتاحة مع تجنب القيم المكررة
      for (final qualification in state.qualifications!) {
        if (qualification.id.isNotEmpty &&
            qualification.id != "0" &&
            qualification.id.trim().isNotEmpty &&
            !validValues.contains(qualification.id)) {
          validValues.add(qualification.id);
          items.add(
            DropdownMenuItem<String>(
              value: qualification.id,
              child: Text(qualification.nameAr ?? 'مؤهل غير محدد'),
            ),
          );
        }
      }

      // التحقق الفوري من صحة القيمة المختارة
      if (_selectedQualificationId != null) {
        // معالجة القيم غير الصالحة
        if (_selectedQualificationId!.isEmpty ||
            _selectedQualificationId == "0" ||
            _selectedQualificationId!.trim().isEmpty ||
            !validValues.contains(_selectedQualificationId)) {
          debugPrint(
              '⚠️ القيمة المختارة للمؤهل غير صالحة: "$_selectedQualificationId"');
          debugPrint('⚠️ القيم الصالحة: $validValues');

          // إعادة تعيين فورية
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedQualificationId = null;
              });
            }
          });
        }
      }

      return items;
    } catch (e) {
      debugPrint('❌ خطأ في _getQualificationItems: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');

      // في حالة حدوث خطأ، إعادة تعيين القيمة المختارة فوراً
      if (_selectedQualificationId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedQualificationId = null;
            });
          }
        });
      }

      return [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('خطأ في تحميل المؤهلات'),
        ),
      ];
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من صحة التعديلات باستخدام قواعد الملف الشخصي
    final validationResult = await _validateChanges();

    if (validationResult == null) {
      // خطأ في التحقق
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في التحقق من صحة التعديلات'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!validationResult.isValid) {
      // عرض الأخطاء للمستخدم
      _showValidationResults(validationResult);
      return;
    }

    // إذا كانت التعديلات صحيحة، عرض النتائج للمستخدم
    _showValidationResults(validationResult);
  }

  /// Widget لعرض تقدم رفع الملفات
  Widget _buildUploadProgressWidget() {
    if (!_isUploadingFiles && _selectedDocuments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isUploadingFiles ? Icons.upload : Icons.attach_file,
                  color:
                      _isUploadingFiles ? AppColors.primary : AppColors.success,
                ),
                const SizedBox(width: 8),
                Text(
                  _isUploadingFiles ? 'جاري رفع الملفات...' : 'الملفات المرفقة',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: _isUploadingFiles
                        ? AppColors.primary
                        : AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // عرض تقدم كل ملف
            for (int i = 0; i < _selectedDocuments.length; i++) ...[
              _buildFileProgressItem(i),
              if (i < _selectedDocuments.length - 1) const SizedBox(height: 12),
            ],

            // إجمالي التقدم
            if (_isUploadingFiles) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إجمالي التقدم:',
                    style: AppTextStyles.bodyMedium,
                  ),
                  Text(
                    '${_uploadProgress.values.isNotEmpty ? (_uploadProgress.values.reduce((a, b) => a + b) / _uploadProgress.length * 100).toStringAsFixed(1) : '0.0'}%',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget لعرض تقدم ملف واحد
  Widget _buildFileProgressItem(int index) {
    final progress = _uploadProgress[index] ?? 0.0;
    final isSuccess = _uploadSuccess[index] ?? false;
    final error = _uploadErrors[index] ?? '';
    final fileName = _selectedDocuments[index].file.path.split('/').last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle
                  : error.isNotEmpty
                      ? Icons.error
                      : _isUploadingFiles
                          ? Icons.upload
                          : Icons.attach_file,
              color: isSuccess
                  ? AppColors.success
                  : error.isNotEmpty
                      ? AppColors.error
                      : AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                fileName,
                style: AppTextStyles.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSuccess)
              Text(
                '100%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (error.isNotEmpty)
              Text(
                'فشل',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),

        // شريط التقدم
        if (_isUploadingFiles || isSuccess) ...[
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              isSuccess
                  ? AppColors.success
                  : error.isNotEmpty
                      ? AppColors.error
                      : AppColors.primary,
            ),
          ),
        ],

        // رسالة الخطأ
        if (error.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            error,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  /// متابعة الحفظ بعد التحقق من القواعد - مع الرسالة المنبثقة الاحترافية
  Future<void> _proceedWithSaveProfessional() async {
    await showUploadProgressDialog(
      context: context,
      uploadFunction: _performUploadAndSave,
      onSuccess: () {
        Navigator.pop(context, true); // العودة لصفحة الملف الشخصي
      },
    );
  }

  /// تنفيذ عملية الرفع والحفظ مع تحديث التقدم
  Future<void> _performUploadAndSave() async {
    final uploadNotifier = ref.read(uploadProgressProvider.notifier);

    try {
      // الخطوة 1: التحضير
      uploadNotifier.setPreparing();
      await Future.delayed(const Duration(milliseconds: 500));

      // الخطوة 2: رفع الملفات (إذا وجدت) - إجبارية إذا كانت مطلوبة
      List<String> uploadedDocumentIds = [];
      bool allUploadsSuccessful = true;

      if (_selectedDocuments.isNotEmpty) {
        // تهيئة بيانات الملفات
        final filesData = _selectedDocuments
            .map((doc) => FileProgressData(
                  fileName: doc.file.path.split('/').last,
                ))
            .toList();

        uploadNotifier.setUploading(filesData);

        for (int i = 0; i < _selectedDocuments.length; i++) {
          final selectedDoc = _selectedDocuments[i];
          try {
            // تحديث حالة الملف إلى "جاري الرفع"
            uploadNotifier.updateFileProgress(
                i,
                filesData[i].copyWith(
                  progress: 0.1,
                ));

            // تحديد فئة الملف الذكية باستخدام النظام الهرمي الجديد
            final fileName = selectedDoc.file.path.split('/').last;
            final smartCategory = _getSmartFileCategory(i, fileName);

            debugPrint(
                '📄 ProfileEditScreen: Smart file category for ${fileName}: $smartCategory');
            debugPrint(
                '📄 ProfileEditScreen: Display name: ${_getSmartFileDisplayName(smartCategory)}');

            // رفع الملف مع تتبع التقدم
            final uploadSuccess = await ref
                .read(profileProvider.notifier)
                .uploadDocumentForFieldWithRetry(
                  fieldName: smartCategory, // استخدام الفئة الذكية الجديدة
                  documentType: 'general',
                  file: selectedDoc.file,
                  fileBytes: selectedDoc.bytes,
                  maxRetries: 3,
                  onProgress: (progress) {
                    // تحديث التقدم في الرسالة المنبثقة
                    uploadNotifier.updateFileProgress(
                        i,
                        filesData[i].copyWith(
                          progress: progress,
                        ));
                  },
                );

            if (uploadSuccess) {
              uploadNotifier.updateFileProgress(
                  i,
                  filesData[i].copyWith(
                    progress: 1.0,
                    isSuccess: true,
                  ));
              // إضافة معرف الملف المرفوع بنجاح إلى القائمة مع الفئة الذكية
              final fileName = selectedDoc.file.path.split('/').last;
              final smartCategory = _getSmartFileCategory(i, fileName);
              uploadedDocumentIds.add(smartCategory);
            } else {
              uploadNotifier.updateFileProgress(
                  i,
                  filesData[i].copyWith(
                    errorMessage: 'فشل في رفع الملف',
                  ));
              allUploadsSuccessful = false;
            }
          } catch (e) {
            uploadNotifier.updateFileProgress(
                i,
                filesData[i].copyWith(
                  errorMessage: e.toString(),
                ));
            allUploadsSuccessful = false;
          }
        }

        // إذا فشل رفع أي ملف، لا نكمل عملية الحفظ
        if (!allUploadsSuccessful) {
          uploadNotifier
              .setError('فشل في رفع بعض الملفات. يرجى المحاولة مرة أخرى.');
          return;
        }
      }

      // الخطوة 3: حفظ البيانات (فقط إذا نجح رفع جميع الملفات)
      uploadNotifier.setSaving();

      final updatedProfile = widget.profile.copyWith(
        fullNameAr: _fullNameArController.text.trim(),
        fullNameEn: _fullNameEnController.text.trim(),
        email: _emailController.text.trim(),
        birthDate: _selectedBirthDate,
        governorateId: _selectedGovernorateId,
        qualificationId: _selectedQualificationId,
        graduationYear: _selectedGraduationYear,
        university: _universityController.text.trim().isEmpty
            ? ''
            : _universityController.text.trim(),
        workplace: _workplaceController.text.trim(),
      );

      final updateRequest = ProfileUpdateRequest(
        fullNameAr: updatedProfile.fullNameAr,
        fullNameEn: updatedProfile.fullNameEn,
        email: updatedProfile.email.isEmpty ? null : updatedProfile.email,
        birthDate: updatedProfile.birthDate,
        governorateId: updatedProfile.governorateId,
        qualificationId: updatedProfile.qualificationId,
        graduationYear: updatedProfile.graduationYear,
        university: updatedProfile.university?.isEmpty == true
            ? null
            : updatedProfile.university,
        workplace: updatedProfile.workplace?.isEmpty == true
            ? null
            : updatedProfile.workplace,
      );

      final updateResult =
          await ref.read(profileProvider.notifier).updateProfile(updateRequest);

      if (updateResult) {
        // الخطوة 4: النجاح
        uploadNotifier.setSuccess();
        await Future.delayed(
            const Duration(milliseconds: 1000)); // عرض رسالة النجاح
      } else {
        throw Exception('فشل في حفظ البيانات');
      }
    } catch (e) {
      uploadNotifier.setError(e.toString());
    }
  }

  /// متابعة الحفظ بعد التحقق من القواعد - الآلية الجديدة
  Future<void> _proceedWithSaveNew() async {
    setState(() => _isSaving = true);

    try {
      // الخطوة 1: رفع الملفات أولاً (إذا وجدت)
      List<String> uploadedDocumentIds = [];

      if (_selectedDocuments.isNotEmpty) {
        setState(() => _isUploadingFiles = true);

        // تهيئة متغيرات التتبع
        for (int i = 0; i < _selectedDocuments.length; i++) {
          _uploadProgress[i] = 0.0;
          _uploadSuccess[i] = false;
          _uploadErrors[i] = '';
        }

        debugPrint('📄 ProfileEditScreen: Starting file uploads...');

        for (int i = 0; i < _selectedDocuments.length; i++) {
          final selectedDoc = _selectedDocuments[i];
          try {
            debugPrint(
                '📄 ProfileEditScreen: Uploading document ${i + 1}/${_selectedDocuments.length}');

            // تحديد فئة الملف الذكية باستخدام النظام الهرمي الجديد
            final fileName = selectedDoc.file.path.split('/').last;
            final smartCategory = _getSmartFileCategory(i, fileName);

            debugPrint(
                '📄 ProfileEditScreen: Smart file category for ${fileName}: $smartCategory');
            debugPrint(
                '📄 ProfileEditScreen: Display name: ${_getSmartFileDisplayName(smartCategory)}');

            // رفع الملف مع تتبع التقدم
            final uploadSuccess = await ref
                .read(profileProvider.notifier)
                .uploadDocumentForFieldWithRetry(
                  fieldName: smartCategory, // استخدام الفئة الذكية الجديدة
                  documentType: 'general',
                  file: selectedDoc.file,
                  fileBytes: selectedDoc.bytes,
                  maxRetries: 3,
                  onProgress: (progress) {
                    // تحديث التقدم في الواجهة
                    setState(() {
                      _uploadProgress[i] = progress;
                    });
                  },
                );

            if (uploadSuccess) {
              setState(() {
                _uploadSuccess[i] = true;
                _uploadProgress[i] = 1.0;
              });
              // إضافة معرف الملف المرفوع بنجاح إلى القائمة مع الفئة الذكية
              final fileName = selectedDoc.file.path.split('/').last;
              final smartCategory = _getSmartFileCategory(i, fileName);
              uploadedDocumentIds.add(smartCategory);
              debugPrint(
                  '✅ ProfileEditScreen: Document ${i + 1} uploaded successfully');
            } else {
              setState(() {
                _uploadSuccess[i] = false;
                _uploadErrors[i] = 'فشل في رفع الملف';
              });
              debugPrint(
                  '❌ ProfileEditScreen: Document ${i + 1} upload failed');
            }
          } catch (e) {
            setState(() {
              _uploadSuccess[i] = false;
              _uploadErrors[i] = e.toString();
            });
            debugPrint(
                '❌ ProfileEditScreen: Failed to upload document ${i + 1}: $e');
          }
        }

        setState(() => _isUploadingFiles = false);
      }

      // الخطوة 2: إنشاء البيانات المحدثة مع مراجع الملفات المرفقة
      final updatedProfile = widget.profile.copyWith(
        fullNameAr: _fullNameArController.text.trim(),
        fullNameEn: _fullNameEnController.text.trim(),
        email: _emailController.text.trim(),
        birthDate: _selectedBirthDate,
        governorateId: _selectedGovernorateId,
        qualificationId: _selectedQualificationId,
        graduationYear: _selectedGraduationYear,
        university: _universityController.text.trim().isEmpty
            ? ''
            : _universityController.text.trim(),
        workplace: _workplaceController.text.trim(),
      );

      // تحويل البيانات إلى ProfileUpdateRequest مع مراجع الملفات
      final updateRequest = ProfileUpdateRequest(
        fullNameAr: updatedProfile.fullNameAr,
        fullNameEn: updatedProfile.fullNameEn,
        email: updatedProfile.email.isEmpty ? null : updatedProfile.email,
        birthDate: updatedProfile.birthDate,
        governorateId: updatedProfile.governorateId,
        qualificationId: updatedProfile.qualificationId,
        graduationYear: updatedProfile.graduationYear,
        university: updatedProfile.university?.isEmpty == true
            ? null
            : updatedProfile.university,
        workplace: updatedProfile.workplace?.isEmpty == true
            ? null
            : updatedProfile.workplace,
        // لا نرسل attached_documents لأن الخادم لا يدعمها في هذا endpoint
      );

      // الخطوة 3: حفظ البيانات مع مراجع الملفات
      debugPrint(
          '📄 ProfileEditScreen: Saving profile data with ${uploadedDocumentIds.length} attached documents');
      final updateResult =
          await ref.read(profileProvider.notifier).updateProfile(updateRequest);

      // الخطوة 4: عرض النتائج للمستخدم
      if (mounted) {
        String message;
        Color backgroundColor;

        if (_selectedDocuments.isEmpty) {
          // لا توجد وثائق للرفع
          final messageCode =
              updateResult ? 'PROFILE_EDIT_SUCCESS' : 'PROFILE_EDIT_FAILED';
          final smartMessage = SmartMessageHandler.instance.handleApiResponse({
            'success': updateResult,
            'code': messageCode,
            'messageAr':
                updateResult ? 'تم حفظ البيانات بنجاح' : 'فشل في حفظ البيانات',
            'messageEn': updateResult
                ? 'Data saved successfully'
                : 'Failed to save data',
          }, 'ar');
          message = smartMessage['message'] ??
              (updateResult ? 'تم حفظ البيانات بنجاح' : 'فشل في حفظ البيانات');
          backgroundColor = updateResult ? AppColors.success : AppColors.error;
        } else {
          // حساب النتائج
          int successfulUploads =
              _uploadSuccess.values.where((success) => success).length;
          int totalUploads = _selectedDocuments.length;

          String messageCode;
          if (updateResult && successfulUploads == totalUploads) {
            // تم حفظ البيانات ورفع جميع الوثائق بنجاح
            messageCode = 'PROFILE_EDIT_WITH_DOCS_SUCCESS';
          } else if (updateResult && successfulUploads > 0) {
            // تم حفظ البيانات ورفع بعض الوثائق
            messageCode = 'PROFILE_EDIT_PARTIAL_DOCS_SUCCESS';
          } else if (updateResult) {
            // تم حفظ البيانات لكن فشل في رفع جميع الوثائق
            messageCode = 'PROFILE_EDIT_DOCS_FAILED';
          } else {
            // فشل في حفظ البيانات
            messageCode = 'PROFILE_EDIT_FAILED';
          }

          final smartMessage = SmartMessageHandler.instance.handleApiResponse({
            'success': updateResult,
            'code': messageCode,
            'messageAr':
                _getMessageByCode(messageCode, successfulUploads, totalUploads),
            'messageEn': _getMessageByCodeEn(
                messageCode, successfulUploads, totalUploads),
          }, 'ar');
          message = smartMessage['message'] ??
              _getMessageByCode(messageCode, successfulUploads, totalUploads);
          backgroundColor = updateResult
              ? (successfulUploads == totalUploads
                  ? AppColors.success
                  : AppColors.warning)
              : AppColors.error;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            action: backgroundColor == AppColors.warning
                ? SnackBarAction(
                    label: 'إعادة المحاولة',
                    textColor: Colors.white,
                    onPressed: () => _proceedWithSaveNew(),
                  )
                : null,
          ),
        );

        if (updateResult) {
          Navigator.pop(context, true); // إرجاع true للإشارة إلى أن هناك تحديث
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء حفظ البيانات: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
        _isUploadingFiles = false;
      });
    }
  }

  /// متابعة الحفظ بعد التحقق من القواعد
  Future<void> _proceedWithSave() async {
    setState(() => _isSaving = true);

    try {
      // إنشاء البيانات المحدثة
      final updatedProfile = widget.profile.copyWith(
        fullNameAr: _fullNameArController.text.trim(),
        fullNameEn: _fullNameEnController.text.trim(),
        email: _emailController.text.trim(),
        birthDate: _selectedBirthDate,
        governorateId: _selectedGovernorateId,
        qualificationId: _selectedQualificationId,
        graduationYear: _selectedGraduationYear,
        university: _universityController.text.trim().isEmpty
            ? ''
            : _universityController.text.trim(),
        workplace: _workplaceController.text.trim(),
      );

      // تحويل البيانات إلى ProfileUpdateRequest
      final updateRequest = ProfileUpdateRequest(
        fullNameAr: updatedProfile.fullNameAr,
        fullNameEn: updatedProfile.fullNameEn,
        email: updatedProfile.email.isEmpty ? null : updatedProfile.email,
        birthDate: updatedProfile.birthDate,
        governorateId: updatedProfile.governorateId,
        qualificationId: updatedProfile.qualificationId,
        graduationYear: updatedProfile.graduationYear,
        university: updatedProfile.university?.isEmpty == true
            ? null
            : updatedProfile.university,
        workplace: updatedProfile.workplace?.isEmpty == true
            ? null
            : updatedProfile.workplace,
      );

      // حفظ البيانات أولاً
      final updateResult =
          await ref.read(profileProvider.notifier).updateProfile(updateRequest);

      // فحص نتيجة تحديث البيانات
      if (!updateResult) {
        // فشل في تحديث البيانات
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(SmartMessageHandler.instance.handleApiResponse({
                    'success': false,
                    'code': 'PROFILE_EDIT_FAILED',
                    'messageAr': 'فشل في حفظ البيانات. يرجى المحاولة مرة أخرى',
                    'messageEn': 'Failed to save data. Please try again',
                  }, 'ar')['message'] ??
                  'فشل في حفظ البيانات. يرجى المحاولة مرة أخرى'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return; // إيقاف العملية
      }

      // إذا نجح تحديث البيانات، نتابع لرفع الوثائق
      bool documentsUploadSuccess = true;
      int uploadedDocuments = 0;
      List<String> failedDocuments = [];

      if (_selectedDocuments.isNotEmpty) {
        // فحص الاتصال قبل رفع الملفات
        debugPrint(
            '📄 ProfileEditScreen: Checking connection before uploading documents...');

        for (int i = 0; i < _selectedDocuments.length; i++) {
          final selectedDoc = _selectedDocuments[i];
          try {
            debugPrint(
                '📄 ProfileEditScreen: Uploading document ${i + 1}/${_selectedDocuments.length}');

            // تحديد فئة الملف الذكية باستخدام النظام الهرمي الجديد
            final fileName = selectedDoc.file.path.split('/').last;
            final smartCategory = _getSmartFileCategory(i, fileName);

            debugPrint(
                '📄 ProfileEditScreen: Smart file category for ${fileName}: $smartCategory');
            debugPrint(
                '📄 ProfileEditScreen: Display name: ${_getSmartFileDisplayName(smartCategory)}');

            // رفع كل ملف كوثيقة عامة مع آلية إعادة المحاولة
            final uploadSuccess = await ref
                .read(profileProvider.notifier)
                .uploadDocumentForFieldWithRetry(
                  fieldName: smartCategory, // استخدام الفئة الذكية الجديدة
                  documentType: 'general', // نوع عام للوثائق
                  file: selectedDoc.file,
                  fileBytes: selectedDoc.bytes, // تمرير البيانات للويب
                  maxRetries: 3, // 3 محاولات لكل ملف
                );

            if (uploadSuccess) {
              uploadedDocuments++;
              debugPrint(
                  '✅ ProfileEditScreen: Document ${i + 1} uploaded successfully');
            } else {
              failedDocuments.add('الوثيقة ${i + 1}');
              debugPrint(
                  '❌ ProfileEditScreen: Document ${i + 1} upload failed');
            }
          } catch (e) {
            // في حالة فشل رفع ملف معين، نستمر مع باقي الملفات
            failedDocuments.add('الوثيقة ${i + 1}');
            debugPrint(
                '❌ ProfileEditScreen: Failed to upload document ${i + 1}: $e');
            documentsUploadSuccess = false;
          }
        }
      }

      if (mounted) {
        String message;
        Color backgroundColor;

        if (_selectedDocuments.isEmpty) {
          // لا توجد وثائق للرفع
          message = 'تم حفظ البيانات بنجاح';
          backgroundColor = AppColors.success;
        } else if (documentsUploadSuccess &&
            uploadedDocuments == _selectedDocuments.length) {
          // تم رفع جميع الوثائق بنجاح
          message = 'تم حفظ البيانات ورفع جميع الوثائق بنجاح';
          backgroundColor = AppColors.success;
        } else if (uploadedDocuments > 0) {
          // تم رفع بعض الوثائق فقط
          message =
              'تم حفظ البيانات ورفع $uploadedDocuments من ${_selectedDocuments.length} وثائق';
          backgroundColor = AppColors.warning;
        } else {
          // فشل في رفع جميع الوثائق
          message = 'تم حفظ البيانات لكن فشل في رفع الوثائق';
          backgroundColor = AppColors.warning;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
          ),
        );
        Navigator.pop(context, true); // إرجاع true للإشارة إلى أن هناك تحديث
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء حفظ البيانات: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  /// بناء تنبيه الحقول المطلوبة
  Widget _buildRequiredFieldsAlert() {
    _validateRequiredFields();

    if (_missingRequiredFields.isEmpty && !_hasAnyDocument()) {
      _missingRequiredFields.add('وثيقة مرفقة');
    }

    if (_missingRequiredFields.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'لطلب توثيق الحساب، يرجى إكمال:',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._missingRequiredFields.map((field) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(
                  '• $field',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
                icon,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SaveLoadingButton(
          onPressed: _saveProfile,
          isLoading: _isSaving,
          isEnabled: _canSave(ref.watch(profileProvider)),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isSaving
                ? null
                : () => Navigator.pop(
                    context, false), // إرجاع false للإشارة إلى عدم وجود تحديث
            child: const Text('إلغاء'),
          ),
        ),

        // رسالة تنبيه للحقول المطلوبة (فقط للحسابات غير الموثقة)
        if (!widget.profile.isVerified && !_canRequestVerification())
          _buildRequiredFieldsAlert(),
      ],
    );
  }

  Widget? _buildDocumentIcon(String fieldName) {
    final requiresDoc = _requiresDocument(fieldName, ref);
    final isEditable = _isFieldEditable(fieldName);

    if (!requiresDoc && isEditable) return null;

    // إذا كان الحقل غير قابل للتعديل
    if (!isEditable) {
      return Tooltip(
        message: 'هذا الحقل غير قابل للتعديل حسب قواعد الملف الشخصي',
        child: Icon(
          Icons.lock,
          color: AppColors.textSecondary,
          size: 20,
        ),
      );
    }

    // إذا كان الحقل يتطلب وثيقة
    if (requiresDoc) {
      final DocumentType docType = _getDocumentTypeFromString(fieldName);
      final hasDocument =
          widget.profile.documents.any((doc) => doc.documentType == docType);

      return Tooltip(
        message: hasDocument
            ? 'تم رفع وثيقة لهذا الحقل'
            : 'هذا الحقل يتطلب رفع وثيقة',
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: hasDocument
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            hasDocument ? Icons.check_circle : Icons.upload_file,
            color: hasDocument ? AppColors.success : AppColors.warning,
            size: 16,
          ),
        ),
      );
    }

    return null;
  }

  // Helper methods

  // تحويل VerificationStatus إلى ProfileStatus
  ProfileStatus _convertVerificationStatusToProfileStatus(
      VerificationStatus status) {
    switch (status) {
      case VerificationStatus.unverified:
        return ProfileStatus.unverified;
      case VerificationStatus.underReview:
        return ProfileStatus.pendingVerification;
      case VerificationStatus.verified:
        return ProfileStatus.verified;
      case VerificationStatus.rejected:
        return ProfileStatus.rejected;
    }
  }

  bool _isFieldEditable(String fieldName) {
    try {
      final profileState = ref.read(profileProvider);
      final currentProfile = profileState.currentProfile;

      if (currentProfile == null) {
        debugPrint('⚠️ [FIELD_EDIT] لا يوجد ملف شخصي حالي للحقل $fieldName');
        return true;
      }

      // استخدام ProfileRulesProvider للتحقق من إمكانية التعديل
      final rulesState = ref.read(profileRulesProvider);
      final profileStatus = _convertVerificationStatusToProfileStatus(
          currentProfile.verificationStatus);

      debugPrint('🔍 [FIELD_EDIT] فحص الحقل: $fieldName');
      debugPrint('📋 [FIELD_EDIT] حالة الملف الشخصي: $profileStatus');
      debugPrint(
          '📋 [FIELD_EDIT] حالة التوثيق: ${currentProfile.verificationStatus}');
      debugPrint(
          '📋 [FIELD_EDIT] عدد القواعد المحملة: ${rulesState.rules.length}');
      debugPrint('📋 [FIELD_EDIT] حالة تحميل القواعد: ${rulesState.isLoading}');

      // التحقق من أن القواعد محملة
      if (rulesState.isLoading) {
        debugPrint(
            '⏳ [FIELD_EDIT] القواعد لا تزال قيد التحميل - السماح بالتعديل مؤقتاً');
        return true;
      }

      if (rulesState.error != null) {
        debugPrint('❌ [FIELD_EDIT] خطأ في تحميل القواعد: ${rulesState.error}');
        return true;
      }

      // استخدام الـ notifier للتحقق من إمكانية التعديل
      final rulesNotifier = ref.read(profileRulesProvider.notifier);
      final canEdit = rulesNotifier.canEditField(fieldName, profileStatus);
      debugPrint('✅ [FIELD_EDIT] هل يمكن تعديل $fieldName؟ $canEdit');

      return canEdit;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من إمكانية تعديل الحقل $fieldName: $e');
      return true; // السماح بالتعديل في حالة الخطأ
    }
  }

  bool _requiresDocument(String fieldName, WidgetRef ref) {
    try {
      // التحقق من صحة المدخلات
      if (fieldName.isEmpty) {
        debugPrint('⚠️ اسم الحقل فارغ، لا يمكن التحقق من الحاجة للوثيقة');
        return false;
      }

      final profileState = ref.read(profileProvider);
      final currentProfile = profileState.currentProfile;

      if (currentProfile == null) {
        debugPrint(
            '⚠️ الملف الشخصي غير متاح، لا يمكن التحقق من الحاجة للوثيقة للحقل: $fieldName');
        return false;
      }

      // التحقق من حالة ProfileRulesProvider
      final rulesState = ref.read(profileRulesProvider);
      if (rulesState.rules.isEmpty) {
        debugPrint(
            '⚠️ قواعد الملف الشخصي غير متاحة، لا يمكن التحقق من الحاجة للوثيقة للحقل: $fieldName');
        return false;
      }

      // استخدام ProfileRulesProvider للتحقق من الحاجة للوثيقة
      final rulesNotifier = ref.read(profileRulesProvider.notifier);
      final profileStatus = _convertVerificationStatusToProfileStatus(
          currentProfile.verificationStatus);

      final requiresDoc =
          rulesNotifier.fieldRequiresDocument(fieldName, profileStatus);
      debugPrint('📋 فحص الحاجة للوثيقة للحقل $fieldName: $requiresDoc');

      return requiresDoc;
    } catch (e, stackTrace) {
      debugPrint('❌ خطأ في التحقق من الحاجة للوثيقة للحقل $fieldName: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      return false; // عدم طلب وثيقة في حالة الخطأ
    }
  }

  /// التحقق من صحة التعديلات قبل الحفظ
  Future<ProfileValidationResult?> _validateChanges() async {
    try {
      final profileState = ref.read(profileProvider);
      final currentProfile = profileState.currentProfile;

      if (currentProfile == null) return null;

      // إعداد البيانات المقترحة للتعديل
      final proposedChanges = <String, dynamic>{};
      final currentValues = <String, dynamic>{};

      // التحقق من التغييرات في الاسم العربي
      if (_fullNameArController.text.trim() !=
          (currentProfile.fullNameAr ?? '')) {
        proposedChanges['fullNameAr'] = _fullNameArController.text.trim();
        currentValues['fullNameAr'] = currentProfile.fullNameAr ?? '';
      }

      // التحقق من التغييرات في الاسم الإنجليزي
      if (_fullNameEnController.text.trim() !=
          (currentProfile.fullNameEn ?? '')) {
        proposedChanges['fullNameEn'] = _fullNameEnController.text.trim();
        currentValues['fullNameEn'] = currentProfile.fullNameEn ?? '';
      }

      // التحقق من التغييرات في المؤهل
      if (_selectedQualificationId != currentProfile.qualificationId) {
        proposedChanges['qualificationId'] = _selectedQualificationId ?? '';
        currentValues['qualificationId'] = currentProfile.qualificationId ?? '';
      }

      // التحقق من التغييرات في المحافظة
      if (_selectedGovernorateId != currentProfile.governorateId) {
        proposedChanges['governorateId'] = _selectedGovernorateId ?? '';
        currentValues['governorateId'] = currentProfile.governorateId ?? '';
      }

      // التحقق من التغييرات في سنة التخرج
      if (_selectedGraduationYear != currentProfile.graduationYear) {
        proposedChanges['graduationYear'] =
            _selectedGraduationYear?.toString() ?? '';
        currentValues['graduationYear'] =
            currentProfile.graduationYear?.toString() ?? '';
      }

      // التحقق من التغييرات في الجامعة
      if (_universityController.text.trim() !=
          (currentProfile.university ?? '')) {
        proposedChanges['university'] = _universityController.text.trim();
        currentValues['university'] = currentProfile.university ?? '';
      }

      // التحقق من التغييرات في مكان العمل
      if (_workplaceController.text.trim() !=
          (currentProfile.workplace ?? '')) {
        proposedChanges['workplace'] = _workplaceController.text.trim();
        currentValues['workplace'] = currentProfile.workplace ?? '';
      }

      // إذا لم تكن هناك تغييرات، لا حاجة للتحقق
      if (proposedChanges.isEmpty) {
        return const ProfileValidationResult(
          isValid: true,
          requiresApproval: false,
          requiresDocument: false,
          warnings: ['لا توجد تغييرات للحفظ'],
        );
      }

      // استخدام ProfileRulesProvider للتحقق من صحة التعديلات
      final rulesNotifier = ref.read(profileRulesProvider.notifier);
      final profileStatus = _convertVerificationStatusToProfileStatus(
          currentProfile.verificationStatus);
      return await rulesNotifier.validateChanges(
        proposedChanges,
        currentValues,
        profileStatus,
      );
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من صحة التعديلات: $e');
      return const ProfileValidationResult(
        isValid: false,
        errors: ['فشل في التحقق من صحة التعديلات'],
      );
    }
  }

  /// عرض نتائج التحقق من صحة التعديلات
  void _showValidationResults(ProfileValidationResult result) {
    if (!result.isValid) {
      // عرض الأخطاء في نافذة حوار
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: AppColors.error),
              SizedBox(width: 8),
              Text('خطأ في التعديلات'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('لا يمكن حفظ التعديلات للأسباب التالية:'),
              const SizedBox(height: 8),
              ...result.errors.map((error) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(color: AppColors.error)),
                        Expanded(child: Text(error)),
                      ],
                    ),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(
                  context, false), // إرجاع false للإشارة إلى عدم وجود تحديث
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } else {
      // التعديلات صحيحة، التحقق من الوثائق المطلوبة
      final hasWarnings = result.warnings.isNotEmpty;
      final requiresApproval = result.requiresApproval;
      final requiresDocuments = result.requiresDocument;

      // التحقق من وجود وثائق إذا كانت مطلوبة
      if (requiresDocuments && _selectedDocuments.isEmpty) {
        // منع الحفظ إذا كانت الوثائق مطلوبة ولم يتم رفعها
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: AppColors.warning),
                SizedBox(width: 8),
                Text('تحذير'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('لا يمكن حفظ هذا التعديل بدون رفع الوثائق الداعمة.'),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يرجى رفع الوثائق الداعمة أولاً ثم المحاولة مرة أخرى.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(
                    context, false), // إرجاع false للإشارة إلى عدم وجود تحديث
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
        return;
      }

      if (requiresApproval || requiresDocuments) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info, color: AppColors.primary),
                SizedBox(width: 8),
                Text('معلومات مهمة'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (requiresApproval) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'مراجعة إدارية',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'سيتم رفع هذه التعديلات للإدارة للمراجعة..',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'ستتلقى إشعاراً عند اكتمال المراجعة',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (requiresDocuments) ...[
                  const Row(
                    children: [
                      Icon(Icons.attach_file,
                          color: AppColors.success, size: 20),
                      SizedBox(width: 8),
                      Text('وثائق مرفقة ✓',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('تم رفع ${_selectedDocuments.length} وثيقة داعمة'),
                  const SizedBox(height: 12),
                ],

                const Text('هل تريد المتابعة؟',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // أزرار مخصصة
                Column(
                  children: [
                    // زر طلب توثيق الحساب
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context,
                              true); // إرجاع true للإشارة إلى أن هناك تحديث
                          _proceedWithSaveProfessional();
                        },
                        icon: const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'طلب توثيق الحساب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // زر الإلغاء
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context,
                            false), // إرجاع false للإشارة إلى عدم وجود تحديث
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actionsPadding: EdgeInsets.zero,
          ),
        );
      } else {
        // لا توجد تحذيرات أو متطلبات إضافية، حفظ مباشرة
        _proceedWithSaveProfessional();
      }
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

  /// طلب توثيق الحساب
  Future<void> _requestAccountVerification() async {
    try {
      setState(() => _isSaving = true);

      // حفظ البيانات أولاً
      await _saveProfile();

      // طلب التوثيق
      // TODO: إضافة API call لطلب التوثيق

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال طلب توثيق الحساب بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إرسال طلب التوثيق: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
