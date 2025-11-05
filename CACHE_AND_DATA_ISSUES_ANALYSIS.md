# تحليل شامل لمشاكل الكاش والبيانات في نسخة الويب

## المشاكل المحددة

### 1. مشكلة SharedPreferences على الويب
**المشكلة**: 
- `LocalProfileService.clearCache()` يستخدم `SharedPreferences` لحفظ الكاش
- على الويب، `SharedPreferences` يستخدم `localStorage` تحت الغطاء
- عند logout، يتم مسح الكاش لكن `SharedPreferences` قد لا يمسح localStorage بشكل كامل
- الكاش يبقى في localStorage ويظهر للمستخدم التالي

**الملفات المتأثرة**:
- `mobile-app/lib/features/profile/services/profile_service.dart` (السطر 1967-1976)
- الكاش المحفوظ في `SharedPreferences` بمفاتيح:
  - `cached_profile_data`
  - `profile_cache_timestamp`

### 2. مشكلة إشعار التوثيق
**المشكلة**: 
- الإشعار يستخدم `enhancedAuthProvider` (السطر 17 في `verification_notification_banner.dart`)
- التطبيق يستخدم `compatibleAuthProvider` بشكل أساسي
- `enhancedAuthProvider` قد لا يكون محدثاً بشكل صحيح
- الإشعار لا يظهر لأن `enhancedAuthProvider` لا يحتوي على بيانات المستخدم الحالي

**الملفات المتأثرة**:
- `mobile-app/lib/shared/widgets/verification_notification_banner.dart`

### 3. مشكلة المستندات
**المشكلة**: 
- المستندات تأتي من `userDocumentsProvider` الذي يعتمد على `profileProvider`
- إذا لم يتم مسح `profileProvider` بشكل صحيح، المستندات القديمة تظهر
- الكاش في `SharedPreferences` للمستندات قد لا يتم مسحه

### 4. مشكلة تحديث البيانات
**المشكلة**: 
- قد يكون هناك race condition عند تحميل البيانات بعد login
- الكاش القديم قد يُستخدم قبل تحميل البيانات الجديدة
- `forceRefresh` قد لا يعمل بشكل صحيح على الويب

## الحلول المقترحة

### الحل 1: تحسين مسح SharedPreferences على الويب
- إضافة مسح شامل لـ SharedPreferences في localStorage عند logout
- مسح جميع المفاتيح المتعلقة بالـ profile والـ documents
- استخدام `localStorage.clear()` بعد مسح المفاتيح المحددة

### الحل 2: إصلاح إشعار التوثيق
- تغيير `enhancedAuthProvider` إلى `compatibleAuthProvider` في الإشعار
- التأكد من أن الإشعار يعمل مع النظام المستخدم فعلياً

### الحل 3: تحسين مسح الكاش في logout
- إضافة مسح SharedPreferences بشكل كامل على الويب
- مسح جميع المفاتيح التي تبدأ بـ `cached_` أو `profile_`
- إضافة مسح localStorage بشكل كامل بعد مسح المفاتيح المحددة

### الحل 4: إضافة User ID Tracking
- حفظ userId مع كل بيانات الكاش
- التحقق من userId قبل استخدام الكاش
- مسح الكاش تلقائياً إذا كان userId مختلف

## خطة التنفيذ

1. إصلاح `LocalProfileService.clearCache()` لمسح SharedPreferences على الويب
2. تغيير `enhancedAuthProvider` إلى `compatibleAuthProvider` في الإشعار
3. تحسين دالة logout لمسح SharedPreferences بشكل كامل
4. إضافة User ID validation في الكاش
5. إضافة مسح شامل لـ localStorage عند logout

