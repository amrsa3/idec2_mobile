# دليل دمج قواعد تعديل الملف الشخصي

## 📋 نظرة عامة

تم تطبيق نظام قواعد تعديل الملف الشخصي الذي يتحكم في:
- **إمكانية التعديل**: هل يمكن تعديل الحقل أم لا
- **الحاجة للموافقة**: هل التعديل يحتاج موافقة إدارية
- **الحاجة لوثيقة**: هل التعديل يتطلب رفع وثيقة

## 🏗️ البنية المطبقة

### 1. Models
- `ProfileRuleModel`: نموذج القاعدة
- `ProfileValidationResult`: نتيجة التحقق من التعديلات
- `ApprovalPolicy`: سياسات الموافقة (3 أنواع)
- `ProfileStatus`: حالات الملف الشخصي

### 2. Services
- `ProfileRulesService`: خدمة جلب القواعد والتحقق من التعديلات

### 3. Providers
- `profileRulesProvider`: إدارة حالة القواعد
- `canEditFieldProvider`: التحقق من إمكانية تعديل حقل
- `fieldRequiresDocumentProvider`: التحقق من حاجة الحقل لوثيقة

## 🔧 كيفية الاستخدام في Profile Screen

### الخطوة 1: تحميل القواعد عند فتح الشاشة

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // تحميل بيانات الملف الشخصي
    _initializeData();
    
    // تحميل قواعد التعديل
    ref.read(profileRulesProvider.notifier).loadRules();
  });
}
```

### الخطوة 2: التحقق من إمكانية تعديل الحقل

```dart
Widget _buildEditableField(String fieldName, String label) {
  final currentStatus = ref.watch(verificationStatusProvider);
  
  // التحقق من إمكانية التعديل
  final canEdit = ref.watch(canEditFieldProvider((
    fieldName: fieldName,
    status: currentStatus,
  )));
  
  return CustomTextField(
    controller: _controllers[fieldName],
    labelText: label,
    enabled: canEdit, // تفعيل/تعطيل الحقل حسب القاعدة
    decoration: InputDecoration(
      suffixIcon: !canEdit 
        ? Icon(Icons.lock, color: Colors.grey)
        : null,
    ),
  );
}
```

### الخطوة 3: التحقق من حاجة الحقل لوثيقة

```dart
Widget _buildQualificationField() {
  final currentStatus = ref.watch(verificationStatusProvider);
  
  // التحقق من حاجة الحقل لوثيقة
  final requiresDocument = ref.watch(fieldRequiresDocumentProvider((
    fieldName: 'qualificationId',
    status: currentStatus,
  )));
  
  return Column(
    children: [
      _buildQualificationDropdown(),
      
      // إظهار قسم رفع الوثيقة إذا كان مطلوباً
      if (requiresDocument)
        _buildDocumentUploadSection('qualificationId'),
    ],
  );
}
```

### الخطوة 4: التحقق من التعديلات قبل الحفظ

```dart
Future<void> _submitProfile() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  
  // جمع التعديلات المقترحة
  final proposedChanges = {
    'fullNameAr': _arabicNameController.text,
    'fullNameEn': _englishNameController.text,
    'qualificationId': _selectedQualificationId,
    'governorateId': _selectedGovernorateId,
    // ... باقي الحقول
  };
  
  // التحقق من التعديلات
  final rulesService = ProfileRulesService();
  final validation = await rulesService.validateChanges(proposedChanges);
  
  if (!validation.isValid) {
    // عرض الأخطاء
    _showErrorDialog(validation.errors);
    return;
  }
  
  if (validation.requiresApproval) {
    // إظهار تحذير أن التعديل يحتاج موافقة
    final confirmed = await _showApprovalWarningDialog(validation.warnings);
    if (!confirmed) return;
  }
  
  if (validation.requiresDocument) {
    // التحقق من رفع الوثائق المطلوبة
    final hasAllDocuments = _checkRequiredDocuments(validation.fieldsRequiringApproval);
    if (!hasAllDocuments) {
      _showError('يرجى رفع جميع الوثائق المطلوبة');
      return;
    }
  }
  
  // إرسال التعديلات
  await _saveProfile(proposedChanges);
}
```

### الخطوة 5: عرض رسائل التحذير للمستخدم

```dart
Future<bool> _showApprovalWarningDialog(List<String> warnings) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تنبيه: يتطلب موافقة إدارية'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('التعديلات التالية تتطلب موافقة من الإدارة:'),
          const SizedBox(height: 12),
          ...warnings.map((warning) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(warning)),
              ],
            ),
          )),
          const SizedBox(height: 12),
          const Text(
            'سيتم تغيير حالة حسابك إلى "قيد المراجعة" حتى تتم الموافقة على التعديلات.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('متابعة'),
        ),
      ],
    ),
  ) ?? false;
}
```

## 📊 أمثلة على القواعد

### مثال 1: حقل الاسم العربي للمستخدم الموثق
```json
{
  "fieldName": "fullNameAr",
  "targetStatus": "VERIFIED",
  "allowEdit": true,
  "approvalPolicy": "CONDITIONAL_BY_CHANGE_LIMIT",
  "changeLimit": 3,
  "requiresDocument": false
}
```
**السلوك**: يمكن تعديل الاسم، لكن إذا تجاوز التغيير 3 أحرف، يحتاج موافقة.

### مثال 2: حقل المؤهل للمستخدم الموثق
```json
{
  "fieldName": "qualificationId",
  "targetStatus": "VERIFIED",
  "allowEdit": true,
  "approvalPolicy": "ALWAYS_REQUIRED",
  "requiresDocument": true
}
```
**السلوك**: يمكن تعديل المؤهل، لكن أي تغيير يحتاج موافقة ورفع وثيقة.

### مثال 3: حقل المحافظة للمستخدم الموثق
```json
{
  "fieldName": "governorateId",
  "targetStatus": "VERIFIED",
  "allowEdit": true,
  "approvalPolicy": "NO_APPROVAL_REQUIRED",
  "requiresDocument": false
}
```
**السلوك**: يمكن تعديل المحافظة بحرية بدون موافقة.

### مثال 4: منع تعديل حقل معين
```json
{
  "fieldName": "phoneNumber",
  "targetStatus": "VERIFIED",
  "allowEdit": false,
  "approvalPolicy": "ALWAYS_REQUIRED"
}
```
**السلوك**: لا يمكن تعديل رقم الهاتف نهائياً للمستخدم الموثق.

## 🎨 تحسينات UI المقترحة

### 1. أيقونة القفل للحقول غير القابلة للتعديل
```dart
suffixIcon: !canEdit 
  ? const Tooltip(
      message: 'هذا الحقل غير قابل للتعديل',
      child: Icon(Icons.lock, color: Colors.grey),
    )
  : null,
```

### 2. شارة تحذير للحقول التي تحتاج موافقة
```dart
suffixIcon: requiresApproval 
  ? const Tooltip(
      message: 'تعديل هذا الحقل يتطلب موافقة إدارية',
      child: Icon(Icons.admin_panel_settings, color: Colors.orange),
    )
  : null,
```

### 3. مؤشر للحقول التي تحتاج وثيقة
```dart
if (requiresDocument)
  Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Icon(Icons.attach_file, color: Colors.blue[700], size: 16),
        const SizedBox(width: 4),
        Text(
          'يتطلب رفع وثيقة',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 12,
          ),
        ),
      ],
    ),
  ),
```

## 🔄 سير العمل الكامل

1. **المستخدم يفتح صفحة الملف الشخصي**
   - يتم جلب بيانات الملف الشخصي
   - يتم جلب قواعد التعديل من الخادم
   - يتم تطبيق القواعد على الحقول

2. **المستخدم يحاول تعديل حقل**
   - إذا كان الحقل غير قابل للتعديل: يظهر مقفلاً
   - إذا كان قابلاً للتعديل: يمكن التعديل

3. **المستخدم يضغط "حفظ"**
   - يتم التحقق من التعديلات
   - إذا كانت تحتاج موافقة: يظهر تحذير
   - إذا كانت تحتاج وثيقة: يتم التحقق من رفعها
   - يتم إرسال التعديلات للخادم

4. **الخادم يعالج التعديلات**
   - إذا كانت تحتاج موافقة: تتغير الحالة إلى PENDING_VERIFICATION
   - إذا لم تحتاج موافقة: يتم الحفظ مباشرة
   - يتم إرسال إشعار للمستخدم

## 🧪 اختبار القواعد

### اختبار 1: تعديل بسيط (لا يحتاج موافقة)
```dart
// تعديل المحافظة للمستخدم الموثق
final changes = {'governorateId': 'new_governorate_id'};
final validation = await rulesService.validateChanges(changes);
// النتيجة: isValid=true, requiresApproval=false
```

### اختبار 2: تعديل يحتاج موافقة
```dart
// تعديل المؤهل للمستخدم الموثق
final changes = {'qualificationId': 'new_qualification_id'};
final validation = await rulesService.validateChanges(changes);
// النتيجة: isValid=true, requiresApproval=true, requiresDocument=true
```

### اختبار 3: تعديل ممنوع
```dart
// محاولة تعديل حقل ممنوع
final changes = {'phoneNumber': 'new_phone'};
final validation = await rulesService.validateChanges(changes);
// النتيجة: isValid=false, errors=['تعديل رقم الهاتف غير مسموح']
```

## 📝 ملاحظات مهمة

1. **الـ Cache**: القواعد يتم تخزينها في cache لمدة 5 دقائق لتحسين الأداء
2. **القواعد الافتراضية**: في حالة فشل جلب القواعد، يتم استخدام قواعد افتراضية آمنة
3. **التحديث التلقائي**: عند تغيير القواعد من لوحة التحكم، يجب تحديث التطبيق
4. **الأمان**: جميع التحققات تتم على الخادم أيضاً، التحقق في التطبيق للـ UX فقط

## 🚀 الخطوات التالية

1. ✅ تم إنشاء Models
2. ✅ تم إنشاء Services
3. ✅ تم إنشاء Providers
4. ⏳ تحديث Profile Screen لاستخدام القواعد
5. ⏳ إضافة UI indicators للحقول
6. ⏳ اختبار جميع السيناريوهات
