# ملاحظات تقنية: إصلاح مشكلة expiresIn في نظام المصادقة

## التاريخ: 29 أكتوبر 2025

## المشكلة الأساسية

عند تسجيل الدخول، كان Access Token ينتهي بعد **900 ثانية (15 دقيقة)** بدلاً من
**3600 ثانية (1 ساعة)** مما كان يسبب فشل المصادقة عند محاولة رفع صورة الملف
الشخصي.

### السبب الجذري

في ملف `mobile-app/lib/services/compatible_auth_service.dart`، كانت هناك **3
مواقع** تحفظ التوكنات بقيمة `expiresIn` ثابتة `900` بدلاً من قراءة القيمة
الحقيقية من استجابة الخادم التي تحتوي على `expiresIn: 3600`.

## المواقع التي تم تعديلها

### 1. السطر 155-173: في `loginWithPhone` - Smart Messages Handler

**الموقع**: داخل `CompatibleAuthService.loginWithPhone()` عند التعامل مع استجابة
Smart Messages System

**الكود القديم**:

```dart
if (accessToken != null) {
  await _tokenManager.saveTokens(
    accessToken: accessToken,
    refreshToken: refreshToken ?? '',
    expiresIn: 900,  // ❌ قيمة ثابتة خاطئة
  );
}
```

**الكود الجديد**:

```dart
if (accessToken != null) {
  int expiresIn = 3600; // Default 1 hour

  // Try to get expiresIn from tokens object
  if (data.containsKey('tokens') &&
      data['tokens'] != null &&
      data['tokens'] is Map<String, dynamic>) {
    final tokens = data['tokens'] as Map<String, dynamic>;
    if (tokens.containsKey('expiresIn')) {
      expiresIn = tokens['expiresIn'] as int;
    }
  }

  await _tokenManager.saveTokens(
    accessToken: accessToken,
    refreshToken: refreshToken ?? '',
    expiresIn: expiresIn,  // ✅ قيمة ديناميكية من الخادم
  );
}
```

### 2. السطر 559-579: في `verifyOtp` - Smart Messages Handler

**الموقع**: داخل `CompatibleAuthService.verifyOtp()` عند التعامل مع استجابة
Smart Messages System للـ OTP

**الكود**: نفس التغيير مثل الموقع الأول

### 3. السطر 614-636: في `verifyOtp` - Legacy Handler

**الموقع**: داخل `CompatibleAuthService.verifyOtp()` للتعامل مع التنسيق القديم
(Legacy)

**الكود**: إضافة منطق قراءة `expiresIn` من الاستجابة

## ملاحظة مهمة جداً ⚠️

**هذه التغييرات ليست في نظام Smart Messages System المستقل**، بل في
`CompatibleAuthService` الذي يستخدم فحص تنسيق الاستجابة للتمييز بين:

1. **Smart Messages Format**: استجابة تحتوي على `success`, `data`, `code`,
   `messageAr`, `messageEn`
2. **Legacy Format**: تنسيق قديم مختلف

### التحقق من تنسيق الاستجابة

```dart
// في السطر 112-115
if (responseData.containsKey('success') &&
    responseData.containsKey('data')) {
  // هذا النص "Smart Messages System" هو مجرد تعليق لوصف التنسيق
  // وليس نظاماً منفصلاً عن المصادقة
}
```

## التأثير على الوظائف

### ✅ لن تتأثر

- `loginWithPhone()` - تعمل بشكل أفضل
- `verifyOtp()` - تعمل بشكل أفضل
- حفظ التوكنات
- UnifiedTokenManager

### ⚠️ إذا حدثت مشاكل

1. راجع سجلات Console للبحث عن: `expiresIn from server`
2. تحقق من أن الخادم يرجع `expiresIn` في الاستجابة
3. إذا كان الخادم يرجع تنسيقاً مختلفاً، قد تحتاج لتعديل منطق القراءة

## كيفية التراجع عن التغييرات

إذا حدثت مشكلة:

```bash
cd mobile-app
git checkout HEAD -- lib/services/compatible_auth_service.dart
```

أو عدل القيمة الافتراضية في السطر 155, 559, 614 من:

```dart
int expiresIn = 3600; // Default 1 hour
```

إلى:

```dart
int expiresIn = 900; // 15 minutes (القيمة القديمة)
```

## اختبار التأثير

بعد التعديل، يجب أن:

1. ✅ Access Token ينتهي بعد **1 ساعة** وليس 15 دقيقة
2. ✅ رفع صورة الملف الشخصي يعمل بدون مشاكل
3. ✅ لا تظهر رسالة "خطأ في المصادقة - يرجى تسجيل الدخول أولاً"

## السجلات المتوقعة

في Console، يجب أن ترى:

```
✅ [COMPATIBLE_AUTH] Using expiresIn from tokens object: 3600
🔐 [COMPATIBLE_AUTH] Final expiresIn: 3600 seconds
```

وليس:

```
❌ ExpiresIn from server: 900 seconds (0.010416666666666666 days)
```
