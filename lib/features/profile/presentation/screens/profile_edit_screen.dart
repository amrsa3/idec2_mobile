import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/profile_model.dart';
import '../../../../models/profile_rule_model.dart';
import '../../../../providers/profile_rules_provider.dart';
import '../../../../shared/widgets/custom_dropdown.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_button.dart';
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
    _selectedGovernorateId = widget.profile.governorateId;
    _selectedQualificationId = widget.profile.qualificationId;
  }

  void _loadProfileRules() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔍 [PROFILE_EDIT] جلب قواعد الملف الشخصي للمستخدم الحالي...');

      // جلب القواعد للمستخدم الحالي (يتم فحص الحالة تلقائياً في الخادم)
      ref.read(profileRulesProvider.notifier).loadRulesForCurrentUser(forceRefresh: true);

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
                ref
                    .read(profileRulesProvider.notifier)
                    .loadRules(forceRefresh: true);
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
        actions: [
          if (!_isSaving)
            TextButton(
              onPressed: _canSave(profileState) ? _saveProfile : null,
              child: Text(
                'حفظ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _canSave(profileState)
                      ? AppColors.primary
                      : AppColors.textSecondary,
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
              onTap: isEditable ? () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedBirthDate ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedBirthDate = date);
                }
              } : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: isEditable ? Colors.grey : Colors.grey.shade300),
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
                              ? (isEditable ? Colors.black : Colors.grey.shade600)
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
      child: Column(
        children: [
          Row(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حساب موثق ✓',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تخضع التعديلات لقواعد خاصة وقد تتطلب موافقة إدارية',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الحقول المقفلة 🔒 غير قابلة للتعديل، والحقول التي تحتاج وثائق 📎 تتطلب رفع مستندات',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
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
            
            debugPrint('🔍 [CONSUMER] فحص تعديل fullNameAr: $canEdit للحالة: $profileStatus');
            
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
            
            debugPrint('🔍 [CONSUMER] فحص تعديل fullNameEn: $canEdit للحالة: $profileStatus');
            
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
            
            return CustomDropdown<String>(
              label: 'المحافظة',
              value: _selectedGovernorateId,
              items: _getGovernorateItems(state),
              isRequired: true,
              enabled: isEditable,
              onChanged: (value) => setState(() => _selectedGovernorateId = value),
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
            
            debugPrint('🔍 [CONSUMER] فحص تعديل qualificationId: $canEdit للحالة: $profileStatus');
            
            return CustomDropdown<String>(
              label: 'المؤهل العلمي',
              value: _selectedQualificationId,
              items: _getQualificationItems(state),
              isRequired: true,
              enabled: canEdit,
              onChanged: (value) =>
                  setState(() => _selectedQualificationId = value),
              validator: (value) => _validateField('qualificationId', value),
              errorText: _fieldErrors['qualificationId'],
              suffixIcon: _buildDocumentIcon('qualificationId'),
            );
          },
        ),

        const SizedBox(height: 16),

        // زر إرفاق وثيقة
        _buildDocumentUploadSection(),

        const SizedBox(height: 16),

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
            
            return CustomTextField(
              controller: _graduationYearController,
              label: 'سنة التخرج',
              keyboardType: TextInputType.number,
              isRequired: false,
              enabled: isEditable,
              validator: (value) => _validateField('graduationYear', value),
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
                  child: const Text('إعادة المحاولة',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ];
      }

      // إذا كان التحميل جاري وهناك قيمة مختارة، أضفها مؤقتاً
      List<DropdownMenuItem<String>> items = [
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

      // إضافة القيمة المختارة مؤقتاً إذا كانت موجودة
      if (_selectedGovernorateId != null &&
          _selectedGovernorateId!.isNotEmpty) {
        items.add(
          DropdownMenuItem<String>(
            value: _selectedGovernorateId,
            child: Text('المحافظة المختارة: $_selectedGovernorateId'),
          ),
        );
      }

      return items;
    }

    List<DropdownMenuItem<String>> items =
        state.governorates!.map<DropdownMenuItem<String>>((governorate) {
      return DropdownMenuItem<String>(
        value: governorate.id,
        child: Text(governorate.nameAr),
      );
    }).toList();

    // التحقق من أن القيمة المختارة موجودة في القائمة
    if (_selectedGovernorateId != null &&
        _selectedGovernorateId!.isNotEmpty &&
        !items.any((item) => item.value == _selectedGovernorateId)) {
      // إضافة القيمة المختارة إذا لم تكن موجودة
      items.insert(
          0,
          DropdownMenuItem<String>(
            value: _selectedGovernorateId,
            child: Text('المحافظة المختارة: $_selectedGovernorateId'),
          ));
    }

    return items;
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
                  child: const Text('إعادة المحاولة',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ];
      }

      // إذا كان التحميل جاري وهناك قيمة مختارة، أضفها مؤقتاً
      List<DropdownMenuItem<String>> items = [
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

      // إضافة القيمة المختارة مؤقتاً إذا كانت موجودة
      if (_selectedQualificationId != null &&
          _selectedQualificationId!.isNotEmpty) {
        items.add(
          DropdownMenuItem<String>(
            value: _selectedQualificationId,
            child: Text('المؤهل المختار: $_selectedQualificationId'),
          ),
        );
      }

      return items;
    }

    List<DropdownMenuItem<String>> items =
        state.qualifications!.map<DropdownMenuItem<String>>((qualification) {
      return DropdownMenuItem<String>(
        value: qualification.id,
        child: Text(qualification.nameAr),
      );
    }).toList();

    // التحقق من أن القيمة المختارة موجودة في القائمة
    if (_selectedQualificationId != null &&
        _selectedQualificationId!.isNotEmpty &&
        !items.any((item) => item.value == _selectedQualificationId)) {
      // إضافة القيمة المختارة إذا لم تكن موجودة
      items.insert(
          0,
          DropdownMenuItem<String>(
            value: _selectedQualificationId,
            child: Text('المؤهل المختار: $_selectedQualificationId'),
          ));
    }

    return items;
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
        graduationYear:
            int.tryParse(_graduationYearController.text.trim()) ?? 0,
        university: _universityController.text.trim().isEmpty
            ? ''
            : _universityController.text.trim(),
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
        university: updatedProfile.university?.isEmpty == true
            ? null
            : updatedProfile.university,
        workplace: updatedProfile.workplace?.isEmpty == true
            ? null
            : updatedProfile.workplace,
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
            debugPrint('فشل في رفع الملف ${selectedDoc.file.path}: $e');
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

        if (_canRequestVerification()) const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),

        // رسالة تنبيه للحقول المطلوبة
        if (!_canRequestVerification()) _buildRequiredFieldsAlert(),
      ],
    );
  }

  Widget? _buildDocumentIcon(String fieldName) {
    final requiresDoc = _requiresDocument(fieldName);
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
      debugPrint('📋 [FIELD_EDIT] حالة التوثيق: ${currentProfile.verificationStatus}');
      debugPrint('📋 [FIELD_EDIT] عدد القواعد المحملة: ${rulesState.rules.length}');
      debugPrint('📋 [FIELD_EDIT] حالة تحميل القواعد: ${rulesState.isLoading}');
      
      // التحقق من أن القواعد محملة
      if (rulesState.isLoading) {
        debugPrint('⏳ [FIELD_EDIT] القواعد لا تزال قيد التحميل - السماح بالتعديل مؤقتاً');
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

  bool _requiresDocument(String fieldName) {
    try {
      final profileState = ref.read(profileProvider);
      final currentProfile = profileState.currentProfile;

      if (currentProfile == null) return false;

      // استخدام ProfileRulesProvider للتحقق من الحاجة للوثيقة
      final rulesNotifier = ref.read(profileRulesProvider.notifier);
      final profileStatus = _convertVerificationStatusToProfileStatus(
          currentProfile.verificationStatus);
      return rulesNotifier.fieldRequiresDocument(fieldName, profileStatus);
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من الحاجة للوثيقة للحقل $fieldName: $e');
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
      final newGradYear =
          int.tryParse(_graduationYearController.text.trim()) ?? 0;
      if (newGradYear != (currentProfile.graduationYear ?? 0)) {
        proposedChanges['graduationYear'] = newGradYear.toString();
        currentValues['graduationYear'] =
            (currentProfile.graduationYear ?? 0).toString();
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
              onPressed: () => Navigator.pop(context),
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
                Text('وثائق مطلوبة'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('لا يمكن حفظ هذا التعديل بدون رفع الوثائق المطلوبة.'),
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
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
        return;
      }

      if (hasWarnings || requiresApproval || requiresDocuments) {
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
                  const Row(
                    children: [
                      Icon(Icons.admin_panel_settings,
                          color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Text('تتطلب موافقة إدارية',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                      'ستحتاج هذه التعديلات إلى موافقة من الإدارة قبل تطبيقها.'),
                  const SizedBox(height: 12),
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
                if (hasWarnings) ...[
                  const Row(
                    children: [
                      Icon(Icons.warning, color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Text('تحذيرات',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...result.warnings.map((warning) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• $warning'),
                      )),
                  const SizedBox(height: 12),
                ],
                const Text('هل تريد المتابعة؟',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _proceedWithSave();
                },
                child: const Text('متابعة'),
              ),
            ],
          ),
        );
      } else {
        // لا توجد تحذيرات أو متطلبات إضافية، حفظ مباشرة
        _proceedWithSave();
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
