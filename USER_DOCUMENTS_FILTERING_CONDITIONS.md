# شروط الفرز والظهور للمستندات في صفحة "مستنداتي"

## الموقع
- **Provider**: `mobile-app/lib/features/profile/providers/smart_file_provider.dart`
- **Screen**: `mobile-app/lib/features/profile/presentation/screens/user_documents_viewer_screen.dart`

## شروط الظهور للمستندات

### 1. التحقق من المصادقة
- ✅ يجب أن يكون المستخدم مسجل دخول (`isAuthenticated = true`)
- ✅ يجب أن يكون `currentUser` موجوداً وغير فارغ
- ✅ يجب أن يكون `currentUser.id` موجوداً وغير فارغ
- ❌ إذا لم يتم استيفاء هذه الشروط، يتم إرجاع قائمة فارغة `[]`

### 2. جلب البيانات من API
- يتم جلب جميع الملفات من endpoint: `/api/v1/files`
- **Query Parameters**:
  - `page`: 1
  - `limit`: 100 (حتى 100 ملف)
  - `t`: timestamp (لإجبار إعادة التحميل ومنع الكاش)
- **Headers**:
  - `Cache-Control: no-cache, no-store, must-revalidate`
  - `Pragma: no-cache`
  - `Expires: 0`

### 3. فلترة حسب entityType (الفلترة الوحيدة)

**شرط إلزامي**: يجب أن يكون `entityType == 'USER_DOCUMENT'`

- ✅ **يظهر**: `entityType == 'USER_DOCUMENT'`
- ❌ **لا يظهر**: أي `entityType` آخر (مثل `USER_PROFILE`, `USER_ATTACHMENT`, إلخ)

**الكود:**
```dart
if (file.entityType != 'USER_DOCUMENT') {
  return false; // استبعاد
}
```

### 4. فلترة حسب userId (الفلترة الثانية)

**شرط إلزامي**: يجب أن يكون الملف مملوك للمستخدم الحالي

- ✅ **يظهر**: إذا كان `uploadedBy == currentUserId` **أو** `entityId == currentUserId`
- ❌ **لا يظهر**: إذا كان `uploadedBy != currentUserId` **و** `entityId != currentUserId`

**الكود:**
```dart
final belongsToUser = file.uploadedBy == currentUserId || 
                     file.entityId == currentUserId;
if (!belongsToUser) {
  return false; // استبعاد
}
```

## ملخص الشروط النهائية

يظهر المستند في صفحة "مستنداتي" إذا تحققت **جميع** الشروط التالية:

1. ✅ المستخدم مسجل دخول و `currentUser.id` موجود
2. ✅ `entityType == 'USER_DOCUMENT'` (الشرط الوحيد - بدون شرط `fileCategory`)
3. ✅ `uploadedBy == currentUserId` **أو** `entityId == currentUserId`

## أمثلة

### ✅ يظهر (مستندات صحيحة):
- `entityType: 'USER_DOCUMENT'`, `fileCategory: 'OTHER_DOCUMENT'`, `uploadedBy: 'user123'`
- `entityType: 'USER_DOCUMENT'`, `fileCategory: 'ANY_CATEGORY'`, `uploadedBy: 'user123'`
- `entityType: 'USER_DOCUMENT'`, `fileCategory: null`, `uploadedBy: 'user123'`
- `entityType: 'USER_DOCUMENT'`, `fileCategory: 'OTHER_DOCUMENT'`, `entityId: 'user123'`

### ❌ لا يظهر (مستندات مستبعدة):

1. **entityType خاطئ**:
   - `entityType: 'USER_PROFILE'` (حتى لو كان `fileCategory: 'OTHER_DOCUMENT'`)
   - `entityType: 'USER_ATTACHMENT'`
   - `entityType: 'OTHER'`
   - أي `entityType` غير `USER_DOCUMENT`

2. **مستندات مستخدمين آخرين**:
   - `entityType: 'USER_DOCUMENT'`, لكن `uploadedBy: 'other_user'` و `entityId: 'other_user'`

## Logging

يتم طباعة معلومات تفصيلية في console:

- `📋 [USER_DOCUMENTS] تم جلب X ملف من الـ API`
- `📄 [USER_DOCUMENTS] File {id}: uploadedBy=..., entityId=..., entityType=..., fileCategory=...`
- `⚠️ [USER_DOCUMENTS] Skipping file {id} - entityType is not USER_DOCUMENT`
- `⚠️ [USER_DOCUMENTS] Skipping file {id} - uploadedBy: ..., entityId: ..., currentUserId: ...`
- `✅ [USER_DOCUMENTS] Including file {id} - uploadedBy: ..., entityId: ..., fileCategory: ...`
- `✅ [USER_DOCUMENTS] تم جلب X مستند للمستخدم (userId: ...)`

## ملاحظات مهمة

1. **لا يوجد فرز حسب التاريخ أو الاسم**: المستندات تظهر بنفس الترتيب الذي جاء من API
2. **الحد الأقصى**: 100 مستند (يمكن زيادته في `limit` parameter)
3. **الكاش**: يتم تعطيل الكاش باستخدام timestamp و headers
4. **Auto-dispose**: الـ provider يتم إلغاؤه تلقائياً عند تسجيل الخروج

