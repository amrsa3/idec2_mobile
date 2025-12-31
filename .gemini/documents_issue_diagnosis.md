# تشخيص مشكلة عدم ظهور المستندات

## المشكلة:
المستخدم لديه مستندات ولكنها لا تظهر في صفحة "مستنداتي"

## بيانات الاختبار:
- رقم الهاتف: 777034999
- كلمة المرور: 456456456

## التشخيص:

### 1. الكود الحالي (`smart_file_provider.dart`):
```dart
final userDocumentsProvider = FutureProvider.autoDispose<List<FileModel>>((ref) async {
  // يجلب الملفات من: /api/v1/files
  // يفلتر حسب:
  // 1. entityType == 'USER_DOCUMENT'
  // 2. uploadedBy أو entityId == currentUserId
});
```

### 2. المشاكل المحتملة:

#### أ. entityType غير صحيح:
الكود يبحث عن `entityType == 'USER_DOCUMENT'` (case-insensitive)
لكن قد تكون القيمة الفعلية في قاعدة البيانات:
- `USER_PROFILE`
- `PROFILE_DOCUMENT`
- `DOCUMENT`
- أو قيمة أخرى

#### ب. userId لا يتطابق:
الكود يتحقق من:
```dart
file.uploadedBy == currentUserId || file.entityId == currentUserId
```

قد تكون المشكلة:
- userId في الملفات مختلف عن userId الحالي
- الملفات مرفوعة بـ userId قديم
- entityId يشير إلى شيء آخر (مثل profileId)

### 3. الحل المقترح:

#### الخيار 1: توسيع الفلترة (موصى به)
تعديل الفلترة لتشمل جميع الملفات المرتبطة بالمستخدم:

```dart
final userFiles = allFiles.where((file) {
  // قبول أي entityType يحتوي على "USER" أو "PROFILE" أو "DOCUMENT"
  final entityTypeUpper = (file.entityType ?? '').toUpperCase().trim();
  final isUserRelated = entityTypeUpper.contains('USER') || 
                        entityTypeUpper.contains('PROFILE') ||
                        entityTypeUpper.contains('DOCUMENT');
  
  // التحقق من ملكية الملف
  final belongsToUser = (file.uploadedBy == currentUserId) || 
                       (file.entityId == currentUserId);
  
  return isUserRelated && belongsToUser;
}).toList();
```

#### الخيار 2: استخدام endpoint مخصص
إنشاء endpoint جديد في الـ backend:
```
GET /api/v1/users/me/documents
```

يرجع جميع مستندات المستخدم الحالي بدون حاجة للفلترة.

#### الخيار 3: فحص البيانات الفعلية
تسجيل الدخول بالحساب المذكور وفحص:
1. console logs للتحقق من entityType الفعلي
2. userId الحالي
3. الملفات المرجعة من API

### 4. التنفيذ الفوري:

سأقوم بتطبيق **الخيار 1** مع إضافة logs إضافية للتشخيص.
