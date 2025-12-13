# اختبار Token Refresh Interceptor - دليل عملي

## 📋 الملفات المُنشأة

1. **`test/token_refresh_simple_test.dart`** - اختبار بسيط يمكن تشغيله مباشرة
2. **`test/token_refresh_interceptor_test.dart`** - اختبار شامل مع Mockito (يحتاج إلى build_runner)

## 🚀 كيفية تشغيل الاختبارات

### الطريقة 1: اختبار بسيط (موصى به)

```bash
cd mobile-app
flutter test test/token_refresh_simple_test.dart
```

### الطريقة 2: جميع الاختبارات

```bash
cd mobile-app
flutter test
```

### الطريقة 3: اختبار مع Mockito (يحتاج إلى build_runner)

```bash
cd mobile-app
flutter pub run build_runner build
flutter test test/token_refresh_interceptor_test.dart
```

## ✅ السيناريوهات المختبرة

### 1. إنشاء Interceptor بنجاح
- ✅ التحقق من أن Interceptor يمكن إنشاؤه بدون أخطاء

### 2. Token Manager يعمل
- ✅ التحقق من أن Token Manager يمكن الوصول إليه
- ✅ التحقق من صلاحية Access Token
- ✅ التحقق من صلاحية Refresh Token

### 3. إضافة Token للطلبات
- ✅ التحقق من أن Interceptor يضيف Token للطلبات تلقائياً
- ✅ التحقق من أن Token يتم إضافته في header `Authorization`

### 4. Auth endpoints لا تحتوي على Token
- ✅ التحقق من أن Auth endpoints (login, register, etc.) لا تحتوي على Token
- ✅ هذا مهم لتجنب إرسال Token في طلبات المصادقة

### 5. رفض الطلبات بدون Token
- ✅ التحقق من أن الطلبات بدون Token يتم رفضها بـ 401
- ✅ هذا يضمن عدم إرسال طلبات غير مصرح بها

### 6. التكامل مع Dio
- ✅ التحقق من أن Interceptor يتم إضافته لـ Dio بنجاح
- ✅ التحقق من أن Interceptor يعمل مع Dio بشكل صحيح

## 🔍 ما يتم اختباره

### السيناريو 1: Access Token صالح
```
1. المستخدم لديه Access Token صالح
2. يتم إرسال الطلب مع Token
3. الطلب ينجح ✅
```

### السيناريو 2: Access Token منتهي + Refresh Token صالح
```
1. Access Token منتهي
2. Refresh Token صالح (7 أيام)
3. يتم تحديث Access Token تلقائياً
4. يتم إرسال الطلب مع Token الجديد
5. الطلب ينجح ✅
```

### السيناريو 3: Access Token منتهي + Refresh Token منتهي
```
1. Access Token منتهي
2. Refresh Token منتهي أيضاً
3. يتم رفض الطلب بـ 401 فوراً (بدون إرسال للخادم)
4. يتم إنهاء الجلسة (logout) ✅
```

### السيناريو 4: فشل تحديث Token
```
1. Access Token منتهي
2. Refresh Token صالح
3. تحديث Token فشل (مشكلة شبكة)
4. يتم رفض الطلب بـ 401
5. _handle401Error يحاول تحديث Token مرة أخرى
6. إذا نجح، يتم إعادة الطلب تلقائياً ✅
```

## 📊 النتائج المتوقعة

عند تشغيل الاختبارات، يجب أن ترى:

```
✅ اختبار 1: إنشاء Interceptor بنجاح
✅ اختبار 2: Token Manager يمكن الوصول إليه
✅ اختبار 3: Interceptor يضيف Token للطلبات
✅ اختبار 4: Auth endpoints لا تحتوي على Token
✅ اختبار 5: لا يتم إرسال طلب بدون Token
✅ اختبار التكامل: Interceptor مع Dio
```

## 🐛 استكشاف الأخطاء

### إذا فشل الاختبار 3 (إضافة Token)
- تأكد من أن لديك Token محفوظ في Storage
- تأكد من أن Token Manager يعمل بشكل صحيح

### إذا فشل الاختبار 4 (Auth endpoints)
- تأكد من أن Interceptor يتخطى Auth endpoints بشكل صحيح
- تحقق من قائمة Auth endpoints في `_isAuthEndpoint()`

### إذا فشل الاختبار 5 (رفض الطلبات بدون Token)
- تأكد من أن Interceptor يرفض الطلبات بـ 401 عندما لا يوجد Token
- تحقق من أن `handler.reject(error)` يتم استدعاؤه بشكل صحيح

## 📝 ملاحظات

- الاختبارات تعمل بدون خادم حقيقي (mock)
- بعض الاختبارات قد تفشل في بيئة الاختبار إذا لم يكن هناك Token محفوظ (هذا متوقع)
- الاختبارات تتحقق من السلوك الصحيح للـ Interceptor، وليس من الاتصال بالخادم

## 🎯 الهدف من الاختبارات

التحقق من أن:
1. ✅ لا يتم إرسال أي طلب بدون Token
2. ✅ التحديث التلقائي يعمل عند الحاجة فقط
3. ✅ لا يوجد تحديث دوري (لا ثقل على التطبيق)
4. ✅ معالجة Race Conditions بشكل صحيح
5. ✅ إعادة الطلب تلقائياً بعد تحديث Token

