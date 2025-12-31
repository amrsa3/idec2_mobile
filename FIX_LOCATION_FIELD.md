# إصلاح حقل المكان (Location Field)

## المشكلة
تم إضافة حقل `location` إلى `EventModel` ولكن ملفات freezed المولدة لم يتم تحديثها.

## الحل
يجب إعادة توليد ملفات freezed لتشمل حقل `location` الجديد.

### الطريقة 1: استخدام سكريبت Windows (موصى بها)

1. افتح PowerShell أو Command Prompt في مجلد `mobile-app`
2. شغّل السكريبت:
   ```powershell
   .\regenerate-freezed.bat
   ```

### الطريقة 2: استخدام Flutter مباشرة

```bash
cd mobile-app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### الطريقة 3: إذا كان Flutter SDK لا يعمل

يمكنك استخدام Dart مباشرة:

```bash
cd mobile-app
dart pub get
dart run build_runner build --delete-conflicting-outputs
```

## ملاحظة
بعد إعادة توليد الملفات، سيتم إصلاح الأخطاء تلقائياً وسيظهر حقل المكان في صفحة تفاصيل الدورة.

