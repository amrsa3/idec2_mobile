# إصلاح مشكلة Flutter Web - الصفحة البيضاء

## المشكلة

تطبيق Flutter Web يظهر صفحة بيضاء مع أخطاء في الكونسول عند رفعه على الخادم.

## الأسباب المحتملة

1. **مشكلة في إعدادات CanvasKit**: استخدام CanvasKit renderer مع إعدادات خاطئة
2. **مشكلة في Content Security Policy**: الإعدادات تمنع بعض العمليات المطلوبة
3. **مشكلة في إعدادات nginx**: عدم وجود إعداد مخصص لتطبيق Flutter Web
4. **مشكلة في إعدادات API**: عدم الاتصال الصحيح مع الخادم

## الحلول المطبقة

### 1. إصلاح إعدادات Flutter Web

- تغيير renderer من `canvaskit` إلى `html` لتحسين التوافق
- إصلاح Content Security Policy
- تبسيط إعدادات التهيئة

### 2. إعدادات nginx الجديدة

تم إنشاء ملف إعداد nginx مخصص لتطبيق Flutter Web:

- `nginx/flutter-web-app.conf` - إعدادات nginx لتطبيق Flutter Web

### 3. ملفات التكوين المبسطة

- `mobile-app/web/flutter_web_config_simple.js` - إعدادات مبسطة
- `mobile-app/web/index_simple.html` - صفحة HTML مبسطة

## خطوات الإصلاح

### الخطوة 1: إعادة بناء تطبيق Flutter Web

```bash
cd mobile-app
chmod +x rebuild-flutter-web.sh
./rebuild-flutter-web.sh
```

### الخطوة 2: إعداد nginx

```bash
# نسخ إعدادات nginx
sudo cp nginx/flutter-web-app.conf /etc/nginx/sites-available/app.idec-ye.com

# تفعيل الإعدادات
sudo ln -s /etc/nginx/sites-available/app.idec-ye.com /etc/nginx/sites-enabled/

# اختبار الإعدادات
sudo nginx -t

# إعادة تحميل nginx
sudo systemctl reload nginx
```

### الخطوة 3: رفع الملفات

```bash
# رفع محتويات build/web إلى الخادم
scp -r mobile-app/build/web/* user@server:/home/idec-ye/domains/app.idec-ye.com/mobile-app/web/
```

### الخطوة 4: التحقق من الإعدادات

1. تأكد من أن مسار Flutter Web صحيح:
   `/home/idec-ye/domains/app.idec-ye.com/mobile-app/web`
2. تأكد من أن جميع ملفات Flutter Web موجودة
3. تأكد من أن DNS يشير إلى الخادم الصحيح

## إعدادات API

تأكد من أن إعدادات API في `mobile-app/lib/core/constants/api_constants.dart`
تشير إلى:

```dart
static const String defaultBaseUrl = 'https://api.idec-ye.com';
```

## اختبار الإصلاح

1. افتح المتصفح واذهب إلى `https://app.idec-ye.com`
2. افتح Developer Tools (F12)
3. تحقق من عدم وجود أخطاء في Console
4. تحقق من تحميل التطبيق بشكل صحيح

## استكشاف الأخطاء

### إذا استمرت المشكلة:

1. تحقق من سجلات nginx: `sudo tail -f /var/log/nginx/app.idec-ye.com.error.log`
2. تحقق من أن جميع ملفات Flutter Web موجودة
3. تأكد من أن شهادات SSL صحيحة
4. تحقق من إعدادات DNS

### رسائل الخطأ الشائعة:

- `Uncaught Error`: مشكلة في تهيئة Flutter Web
- `CORS error`: مشكلة في إعدادات CORS
- `404 Not Found`: ملفات Flutter Web غير موجودة

## ملاحظات مهمة

- استخدم HTML renderer بدلاً من CanvasKit لتحسين التوافق
- تأكد من أن جميع الخطوط محلية (لا تعتمد على Google Fonts)
- تأكد من أن إعدادات nginx تدعم Flutter Web بشكل صحيح
- تأكد من أن API server يعمل على `https://api.idec-ye.com`

## الدعم

إذا استمرت المشكلة، تحقق من:

1. سجلات nginx
2. سجلات المتصفح
3. حالة الخادم
4. إعدادات DNS


