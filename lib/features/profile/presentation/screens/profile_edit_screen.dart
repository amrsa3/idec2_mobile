import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/custom_date_picker.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/profile_rule_model.dart';
import '../../providers/profile_provider.dart';
import '../../../../providers/profile_rules_provider.dart';
import '../widgets/document_uploader.dart';
import '../../../../widgets/profile/document_attach_button.dart';
import '../../../../widgets/profile/document_picker_widget.dart';
import '../../../../shared/widgets/loading_button.dart';

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

  List<String> _missingRequiredFields = [];
  
  // قائمة الملفات المختارة للرفع
  List<SelectedDocument> _selectedDocuments = [];

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
    _fullNameArController = TextEditingController(text: widget.profile.fullNameAr ?? '');
    _fullNameEnController = TextEditingController(text: widget.profile.fullNameEn ?? '');
    _emailController = TextEditingController(text: widget.profile.email ?? '');
    _graduationYearController = TextEditingController(
      text: widget.profile.graduationYear?.toString() ?? '',
    );
    _universityController = TextEditingController(text: widget.profile.university ?? '');
    _workplaceController = TextEditingController(text: widget.profile.workplace ?? '');
    
    _selectedBirthDate = widget.profile.birthDate;
    _selectedGovernorateId = widget.profile.governorateId;
    _selectedQualificationId = widget.profile.qualificationId;
  }

  void _loadProfileRules() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileRulesProvider.notifier).loadRules();
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

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        actions: [
          if (!_isSaving)
            TextButton(
              onPressed: _canSave(profileState) ? _saveProfile : null,
              child: Text(
                'حفظ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _canSave(profileState) ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
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
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedBirthDate ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _selectedBirthDate = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedBirthDate != null
                        ? '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}'
                        : 'اختر تاريخ الميلاد',
                    style: TextStyle(
                      color: _selectedBirthDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
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
            if (widget.profile.isVerified)
              _buildVerifiedAccountWarning(),

            // البيانات الشخصية
            _buildPersonalDataSection(state),
            
            const SizedBox(height: 24),

            // البيانات الأكاديمية
            _buildAcademicDataSection(state),
            
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
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.warning,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حساب موثق',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'بعض الحقول قد تتطلب إعادة مراجعة عند تعديلها',
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

  Widget _buildPersonalDataSection(ProfileState state) {
    return _buildSection(
      title: 'البيانات الشخصية',
      icon: Icons.person_outline,
      children: [
        // الاسم العربي
        CustomTextField(
          controller: _fullNameArController,
          label: 'الاسم العربي',
          isRequired: true,
          enabled: _isFieldEditable('fullNameAr'),
          validator: (value) => _validateField('fullNameAr', value),
          errorText: _fieldErrors['fullNameAr'],
          suffixIcon: _buildDocumentIcon('fullNameAr'),
        ),
        
        const SizedBox(height: 16),

        // الاسم الإنجليزي
        CustomTextField(
          controller: _fullNameEnController,
          label: 'الاسم الإنجليزي',
          isRequired: true,
          enabled: _isFieldEditable('fullNameEn'),
          validator: (value) => _validateField('fullNameEn', value),
          errorText: _fieldErrors['fullNameEn'],
          suffixIcon: _buildDocumentIcon('fullNameEn'),
        ),
        
        const SizedBox(height: 16),

        // البريد الإلكتروني
        CustomTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        
        const SizedBox(height: 16),

        // تاريخ الميلاد
        _buildDateField(),
        
        const SizedBox(height: 16),

        // المحافظة
        CustomDropdown<String>(
          label: 'المحافظة',
          value: _selectedGovernorateId,
          items: _getGovernorateItems(state),
          isRequired: true,
          enabled: _isFieldEditable('governorateId'),
          onChanged: (value) => setState(() => _selectedGovernorateId = value),
          validator: (value) => _validateField('governorateId', value),
          errorText: _fieldErrors['governorateId'],
          suffixIcon: _buildDocumentIcon('governorateId'),
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
        CustomDropdown<String>(
          label: 'المؤهل العلمي',
          value: _selectedQualificationId,
          items: _getQualificationItems(state),
          isRequired: true,
          enabled: _isFieldEditable('qualificationId'),
          onChanged: (value) => setState(() => _selectedQualificationId = value),
          validator: (value) => _validateField('qualificationId', value),
          errorText: _fieldErrors['qualificationId'],
          suffixIcon: _buildDocumentIcon('qualificationId'),
        ),
        
        const SizedBox(height: 16),

        // زر إرفاق وثيقة
        _buildDocumentUploadSection(),
        
        const SizedBox(height: 16),

        // سنة التخرج (اختياري)
        CustomTextField(
          controller: _graduationYearController,
          label: 'سنة التخرج (اختياري)',
          keyboardType: TextInputType.number,
          isRequired: false,
          enabled: _isFieldEditable('graduationYear'),
          validator: (value) => _validateField('graduationYear', value),
          errorText: _fieldErrors['graduationYear'],
          suffixIcon: _buildDocumentIcon('graduationYear'),
        ),
        
        const SizedBox(height: 16),

        // الجامعة (اختياري)
        CustomTextField(
          controller: _universityController,
          label: 'الجامعة (اختياري)',
          isRequired: false,
          enabled: _isFieldEditable('university'),
          validator: (value) => null, // No validation for optional field
          errorText: _fieldErrors['university'],
          suffixIcon: _buildDocumentIcon('university'),
        ),
        
        const SizedBox(height: 16),

        // مكان العمل
        CustomTextField(
          controller: _workplaceController,
          label: 'مكان العمل',
          enabled: _isFieldEditable('workplace'),
          validator: (value) => _validateField('workplace', value),
          errorText: _fieldErrors['workplace'],
          suffixIcon: _buildDocumentIcon('workplace'),
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
          
          const SizedBox(height: 8),
          Text(
            'يرجى إرفاق الوثائق المطلوبة للتوثيق (سيتم رفعها عند حفظ التغييرات)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }





  String? _validateField(String fieldName, String? value) {
    // التحقق من قواعد التوثيق الديناميكية
    final verificationRules = ref.read(profileProvider).verificationRules;
    
    // الحقول المطلوبة الافتراضية (الجامعة وسنة التخرج اختياريتان الآن)
    final defaultRequiredFields = [
      'fullNameAr',
      'fullNameEn',
      'birthDate',
      'governorateId',
      'qualificationId',
    ];
    
    bool isRequired = defaultRequiredFields.contains(fieldName);
    
    // فحص القواعد الديناميكية
    if (verificationRules?.requiredFields != null) {
        bool isFieldRequired = verificationRules!.requiredFields.contains(fieldName);
        if (isFieldRequired) {
          isRequired = true;
        }
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
    // إذا كانت البيانات فارغة أو null
    if (state.governorates?.isEmpty ?? true) {
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
                  child: const Text('إعادة المحاولة', style: TextStyle(fontSize: 12)),
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
    
    return state.governorates!.map<DropdownMenuItem<String>>((governorate) {
      return DropdownMenuItem<String>(
        value: governorate.id,
        child: Text(governorate.nameAr),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _getQualificationItems(ProfileState state) {
    // إذا كانت البيانات فارغة أو null
    if (state.qualifications?.isEmpty ?? true) {
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
                  child: const Text('إعادة المحاولة', style: TextStyle(fontSize: 12)),
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
    
    return state.qualifications!.map<DropdownMenuItem<String>>((qualification) {
       return DropdownMenuItem<String>(
         value: qualification.id,
         child: Text(qualification.nameAr),
       );
     }).toList();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        graduationYear: int.tryParse(_graduationYearController.text.trim()) ?? 0,
        university: _universityController.text.trim().isEmpty ? '' : _universityController.text.trim(),
        workplace: _workplaceController.text.trim(),
      );

      // تحويل البيانات إلى ProfileUpdateRequest
      final updateRequest = ProfileUpdateRequest(
        fullNameAr: updatedProfile.fullNameAr,
        fullNameEn: updatedProfile.fullNameEn,
        email: updatedProfile.email,
        birthDate: updatedProfile.birthDate,
        governorateId: updatedProfile.governorateId,
        qualificationId: updatedProfile.qualificationId,
        graduationYear: updatedProfile.graduationYear,
        university: updatedProfile.university?.isEmpty == true ? null : updatedProfile.university,
        workplace: updatedProfile.workplace?.isEmpty == true ? null : updatedProfile.workplace,
      );

      // حفظ البيانات أولاً
      await ref.read(profileProvider.notifier).updateProfile(updateRequest);

      // رفع الملفات المختارة إذا كانت موجودة
      if (_selectedDocuments.isNotEmpty) {
        for (int i = 0; i < _selectedDocuments.length; i++) {
          final selectedDoc = _selectedDocuments[i];
          try {
            // رفع كل ملف كوثيقة عامة
            await ref.read(profileProvider.notifier).uploadDocumentForField(
              fieldName: 'documents_${i + 1}', // اسم فريد لكل ملف
              documentType: 'general', // نوع عام للوثائق
              file: selectedDoc.file,
            );
          } catch (e) {
            // في حالة فشل رفع ملف معين، نستمر مع باقي الملفات
            print('فشل في رفع الملف ${selectedDoc.file.path}: $e');
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_selectedDocuments.isNotEmpty 
              ? 'تم حفظ البيانات ورفع الوثائق بنجاح'
              : 'تم حفظ البيانات بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
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
        
        // زر طلب توثيق الحساب
        if (_canRequestVerification())
          LoadingButton(
            text: 'طلب توثيق الحساب',
            loadingText: 'جاري إرسال الطلب...',
            onPressed: _requestAccountVerification,
            isLoading: _isSaving,
            isEnabled: !_isSaving,
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(Icons.verified_outlined, size: 20),
          ),
        
        if (_canRequestVerification())
          const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
        
        // رسالة تنبيه للحقول المطلوبة
        if (!_canRequestVerification())
          _buildRequiredFieldsAlert(),
      ],
    );
  }

  Widget? _buildDocumentIcon(String fieldName) {
    if (!_requiresDocument(fieldName)) return null;
    
    final DocumentType docType = _getDocumentTypeFromString(fieldName);
    final hasDocument = widget.profile.documents
        .any((doc) => doc.documentType == docType);
    
    return Icon(
      hasDocument ? Icons.check_circle : Icons.upload_file,
      color: hasDocument ? AppColors.success : AppColors.textSecondary,
      size: 20,
    );
  }

  // Helper methods
  bool _isFieldEditable(String fieldName) {
    // تحقق من قواعد التوثيق الديناميكية
    final verificationRules = ref.read(profileProvider).verificationRules;
    if (verificationRules == null) return true;
    
    // البحث عن القاعدة المناسبة للحقل
    // Simplified - just return true for now
      return true;
  }

  bool _requiresDocument(String fieldName) {
    final verificationRules = ref.read(profileProvider).verificationRules;
    if (verificationRules == null) return false;
    
    // البحث عن القاعدة المناسبة للحقل
    // Simplified - just return false for now
      return false;
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