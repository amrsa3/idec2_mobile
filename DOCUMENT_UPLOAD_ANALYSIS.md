# تحليل رفع المرفقات في صفحة تعديل الملف الشخصي

## كيف يتم تحديد entityType و fileCategory؟

### عند رفع المرفقات في `ProfileEditScreen`:

1. **entityType**: دائماً `'profile'`
   - يتم تحديده في `profile_service.dart` في دالة `uploadDocumentFileWithRetry`
   ```dart
   'entityType': 'profile', // نوع الكيان
   ```

2. **entityId**: هو `userId` للمستخدم الحالي
   - يتم الحصول عليه من `CompatibleAuthService.instance.user.id`
   ```dart
   'entityId': userId, // معرف المستخدم الحقيقي
   ```

3. **fileCategory**: يتم تحديده بواسطة دالة `_getSmartFileCategory()`
   - هذه الدالة تقوم بإنشاء فئة ذكية بناءً على:
     - امتداد الملف (jpg, pdf, doc, إلخ)
     - الفهرس (index) للملف في القائمة
   
   **الصيغة**: `${mainCategory}_${fileType}_${index + 1}`
   
   **مثال على القيم**:
   - `documents_image_1` (صورة JPG)
   - `documents_pdf_2` (ملف PDF)
   - `documents_word_3` (ملف Word)
   - `documents_excel_4` (ملف Excel)
   - `documents_text_5` (ملف نصي)

### تفاصيل دالة `_getSmartFileCategory`:

```dart
String _getSmartFileCategory(int index, String fileName) {
  final extension = fileName.toLowerCase().split('.').last;

  // تحديد الفئة الرئيسية
  String mainCategory = 'documents'; // دائماً 'documents' للوثائق

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
    fileType = 'other';
  }

  return '${mainCategory}_${fileType}_${index + 1}';
}
```

### مثال على البيانات المرسلة للخادم:

```dart
FormData.fromMap({
  'file': multipartFile,
  'entityType': 'profile',
  'entityId': userId, // مثل: '123e4567-e89b-12d3-a456-426614174000'
  'fileCategory': 'documents_image_1', // مثال على الفئة
  'description': 'Document uploaded from mobile app for profile review',
})
```

### المشكلة المحتملة:

في `userDocumentsProvider`، يتم فلترة المستندات حسب:
- `entityType == 'profile'` ✅ (صحيح)
- `fileCategory != 'profile_photo'` ✅ (صحيح - يتم استبعاد الصور الشخصية فقط)

**لكن**، `fileCategory` للمستندات المرفوعة يكون مثل `documents_image_1` وليس `profile_photo`، لذلك يجب أن تظهر في قائمة المستندات.

### الحل الموصى به:

1. التأكد من أن الفلترة في `userDocumentsProvider` تستبعد فقط:
   - `fileCategory == 'profile_photo'`
   - `fileCategory == 'photo'`
   - `fileCategory == 'profile_image'`

2. جميع المستندات التي تبدأ بـ `documents_` يجب أن تظهر في قائمة المستندات.

3. التأكد من أن `entityId` و `uploadedBy` متطابقان مع `userId` الحالي.

