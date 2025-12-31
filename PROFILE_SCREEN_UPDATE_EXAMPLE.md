# مثال عملي: تحديث Profile Screen لاستخدام القواعد

## 🎯 التغييرات المطلوبة في `new_profile_screen.dart`

### 1. إضافة Imports

```dart
// في بداية الملف
import '../providers/profile_rules_provider.dart';
import '../models/profile_rule_model.dart';
import '../services/profile_rules_service.dart';
```

### 2. تحديث initState لتحميل القواعد

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeData();
    
    // تحميل قواعد التعديل
    ref.read(profileRulesProvider.notifier).loadRules();
  });
}
```

### 3. تحديث حقل الاسم العربي ليستخدم القواعد

**قبل:**
```dart
CustomTextField(
  controller: _arabicNameController,
  labelText: 'الاسم العربي',
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم العربي مطلوب';
    }
    return null;
  },
),
```

**بعد:**
```dart
Widget _buildArabicNameField() {
  final currentStatus = ref.watch(verificationStatusProvider);
  final canEdit = ref.watch(canEditFieldProvider((
    fieldName: 'fullNameAr',
    status: currentStatus,
  )));
  
  // التحقق من حاجة التعديل لموافقة
  final rulesNotifier = ref.read(profileRulesProvider.notifier);
  final requiresApproval = rulesNotifier.changeRequiresApproval(
    'fullNameAr',
    _originalArabicName ?? '',
    _arabicNameController.text,
    currentStatus,
  );
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomTextField(
        controller: _arabicNameController,
        labelText: 'الاسم العربي',
        enabled: canEdit,
        decoration: InputDecoration(
          suffixIcon: !canEdit 
            ? const Tooltip(
                message: 'هذا الحقل غير قابل للتعديل',
                child: Icon(Icons.lock, color: Colors.grey),
              )
            : requiresApproval
              ? const Tooltip(
                  message: 'تعديل هذا الحقل يتطلب موافقة إدارية',
                  child: Icon(Icons.admin_panel_settings, color: Colors.orange),
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'الاسم العربي مطلوب';
          }
          return null;
        },
      ),
      
      // رسالة تحذير إذا كان التعديل يحتاج موافقة
      if (requiresApproval && _arabicNameController.text != _originalArabicName)
        Container(
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
                  'تعديل الاسم بهذا الحجم يتطلب موافقة إدارية',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
```

### 4. تحديث حقل المؤهل ليدعم رفع الوثيقة الديناميكي

**قبل:**
```dart
_buildQualificationDropdown(qualifications),
```

**بعد:**
```dart
Widget _buildQualificationSection() {
  final currentStatus = ref.watch(verificationStatusProvider);
  final qualifications = ref.watch(profileDataProvider).qualifications;
  
  final canEdit = ref.watch(canEditFieldProvider((
    fieldName: 'qualificationId',
    status: currentStatus,
  )));
  
  final requiresDocument = ref.watch(fieldRequiresDocumentProvider((
    fieldName: 'qualificationId',
    status: currentStatus,
  )));
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Dropdown المؤهل
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: canEdit ? Colors.white : Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'المؤهل *',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (!canEdit)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.lock, size: 16, color: Colors.grey),
                  ),
              ],
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedQualificationId,
                isExpanded: true,
                hint: const Text('اختر المؤهل'),
                items: qualifications.map((qualification) {
                  return DropdownMenuItem<String>(
                    value: qualification.id,
                    child: Text(qualification.getDisplayName('ar')),
                  );
                }).toList(),
                onChanged: canEdit 
                  ? (value) {
                      setState(() {
                        _selectedQualificationId = value;
                      });
                    }
                  : null,
              ),
            ),
          ],
        ),
      ),
      
      // قسم رفع الوثيقة (يظهر فقط إذا كان مطلوباً)
      if (requiresDocument && _selectedQualificationId != null)
        _buildDynamicDocumentUpload(
          fieldName: 'qualificationId',
          documentTitle: 'وثيقة المؤهل',
          isRequired: true,
        ),
    ],
  );
}
```

### 5. إنشاء Widget ديناميكي لرفع الوثائق

```dart
Widget _buildDynamicDocumentUpload({
  required String fieldName,
  required String documentTitle,
  required bool isRequired,
}) {
  final notifier = ref.read(profileDataProvider.notifier);
  final documents = ref.watch(profileDataProvider).documents;
  final document = documents[fieldName];
  
  return Container(
    margin: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.attach_file, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              documentTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'يرجى رفع وثيقة واضحة (PDF أو صورة)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        
        // عرض الوثيقة المرفوعة أو زر الرفع
        if (document != null && document.isUploaded)
          _buildUploadedDocumentCard(fieldName, document)
        else
          _buildUploadButton(fieldName, documentTitle),
      ],
    ),
  );
}

Widget _buildUploadedDocumentCard(String fieldName, DocumentFile document) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.green[200]!),
    ),
    child: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.green[600], size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.fileName,
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'تم الرفع بنجاح',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _removeDocument(fieldName),
          icon: Icon(Icons.close, color: Colors.red[600], size: 20),
          tooltip: 'حذف الوثيقة',
        ),
      ],
    ),
  );
}

Widget _buildUploadButton(String fieldName, String documentTitle) {
  return ElevatedButton.icon(
    onPressed: () => _pickDocument(fieldName, documentTitle),
    icon: const Icon(Icons.upload_file),
    label: const Text('اختر الوثيقة'),
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
```

### 6. تحديث دالة الحفظ للتحقق من القواعد

```dart
Future<void> _submitVerificationRequest() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  
  // جمع التعديلات المقترحة
  final proposedChanges = {
    'fullNameAr': _arabicNameController.text.trim(),
    'fullNameEn': _englishNameController.text.trim(),
    'email': _emailController.text.trim(),
    'birthDate': _selectedBirthDate?.toIso8601String(),
    'governorateId': _selectedGovernorateId,
    'qualificationId': _selectedQualificationId,
    'graduationYear': int.tryParse(_graduationYearController.text.trim()),
    'university': _universityController.text.trim(),
    'workplace': _workplaceController.text.trim(),
  };
  
  // إزالة القيم الفارغة
  proposedChanges.removeWhere((key, value) => value == null);
  
  // التحقق من التعديلات حسب القواعد
  final rulesService = ProfileRulesService();
  final validation = await rulesService.validateChanges(proposedChanges);
  
  // إذا كانت التعديلات غير صالحة
  if (!validation.isValid) {
    _showErrorDialog(
      title: 'خطأ في التعديلات',
      errors: validation.errors,
    );
    return;
  }
  
  // إذا كانت التعديلات تحتاج موافقة
  if (validation.requiresApproval) {
    final confirmed = await _showApprovalWarningDialog(
      warnings: validation.warnings,
      fieldsRequiringApproval: validation.fieldsRequiringApproval,
    );
    
    if (!confirmed) return;
  }
  
  // إذا كانت التعديلات تحتاج وثائق
  if (validation.requiresDocument) {
    final hasAllDocuments = _checkRequiredDocuments(
      validation.fieldsRequiringApproval,
    );
    
    if (!hasAllDocuments) {
      _showError('يرجى رفع جميع الوثائق المطلوبة');
      return;
    }
  }
  
  // حفظ التعديلات
  await _saveProfileChanges(proposedChanges);
}

Future<bool> _showApprovalWarningDialog({
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
          const Text('تنبيه: يتطلب موافقة إدارية'),
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
            
            // عرض الحقول التي تحتاج موافقة
            ...fieldsRequiringApproval.map((field) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, 
                    color: Colors.orange[700], 
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_getFieldDisplayName(field)),
                  ),
                ],
              ),
            )),
            
            const Divider(height: 24),
            
            // عرض التحذيرات
            ...warnings.map((warning) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, 
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
  ) ?? false;
}

String _getFieldDisplayName(String fieldName) {
  const fieldNames = {
    'fullNameAr': 'الاسم العربي',
    'fullNameEn': 'الاسم الإنجليزي',
    'qualificationId': 'المؤهل',
    'governorateId': 'المحافظة',
    'university': 'الجامعة',
    'workplace': 'مكان العمل',
    'graduationYear': 'سنة التخرج',
  };
  
  return fieldNames[fieldName] ?? fieldName;
}

bool _checkRequiredDocuments(List<String> fieldsRequiringApproval) {
  final documents = ref.read(profileDataProvider).documents;
  
  for (final field in fieldsRequiringApproval) {
    final document = documents[field];
    if (document == null || !document.isUploaded) {
      return false;
    }
  }
  
  return true;
}
```

### 7. إضافة متغيرات لتتبع القيم الأصلية

```dart
class _NewProfileScreenState extends ConsumerState<NewProfileScreen> {
  // ... المتغيرات الموجودة
  
  // إضافة متغيرات للقيم الأصلية (للمقارنة)
  String? _originalArabicName;
  String? _originalEnglishName;
  String? _originalQualificationId;
  String? _originalGovernorateId;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
      ref.read(profileRulesProvider.notifier).loadRules();
    });
  }
  
  void _populateFields() {
    final profileData = ref.read(profileDataProvider).profileData;
    if (profileData != null) {
      // حفظ القيم الأصلية
      _originalArabicName = profileData.personalData.arabicName;
      _originalEnglishName = profileData.personalData.englishName;
      _originalQualificationId = profileData.academicData.qualificationId;
      _originalGovernorateId = profileData.personalData.governorate;
      
      // ملء الحقول
      _arabicNameController.text = _originalArabicName ?? '';
      _englishNameController.text = _originalEnglishName ?? '';
      // ... باقي الحقول
    }
  }
}
```

## 🎨 النتيجة النهائية

بعد تطبيق هذه التغييرات، ستحصل على:

1. ✅ **حقول ديناميكية** تتغير حسب حالة التوثيق
2. ✅ **أيقونات توضيحية** (قفل، تحذير، وثيقة)
3. ✅ **رسائل تحذير** قبل إرسال التعديلات
4. ✅ **رفع وثائق ديناميكي** حسب الحاجة
5. ✅ **تجربة مستخدم محسّنة** مع توضيح كامل للقواعد

## 🧪 اختبار التطبيق

### سيناريو 1: مستخدم جديد (UNVERIFIED)
- جميع الحقول قابلة للتعديل
- لا توجد قيود
- يمكن الحفظ مباشرة

### سيناريو 2: مستخدم موثق (VERIFIED) يعدل الاسم قليلاً
- يمكن التعديل
- إذا كان التغيير أقل من 3 أحرف: يحفظ مباشرة
- إذا كان أكثر: يظهر تحذير ويحتاج موافقة

### سيناريو 3: مستخدم موثق يغير المؤهل
- يمكن التعديل
- يظهر تحذير أن التعديل يحتاج موافقة
- يجب رفع وثيقة المؤهل الجديد
- تتغير الحالة إلى PENDING_VERIFICATION
