# 🔧 إصلاح مشاكل Flutter Web على الاستضافة

## 🚨 **المشكلة:**

```
flutter_bootstrap.js:156 🚨 [Flutter Bootstrap] Global error: Error
    at Object.d (main.dart.js:3986:20)
```

هذا خطأ شائع في تطبيقات Flutter Web عند النشر على الاستضافة، وعادة ما يكون سببه:

1. **Content Security Policy (CSP)** مقيدة جداً
2. **إعدادات Apache/Nginx** غير مناسبة لـ Flutter Web
3. **مشاكل في Cross-Origin** أو CORS
4. **ملفات JavaScript** لا تُحمل بشكل صحيح

## ✅ **الحلول:**

### **1. إصلاح إعدادات Apache:**

#### **أ) تحديث ملف Apache:**

```bash
# نسخ الإعدادات الجديدة
sudo cp /path/to/FLUTTER_WEB_APACHE_FIX.conf /etc/apache2/sites-available/app.idec-ye.com.conf

# إعادة تحميل Apache
sudo systemctl reload apache2
```

#### **ب) تفعيل الوحدات المطلوبة:**

```bash
sudo a2enmod headers
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo systemctl restart apache2
```

### **2. إصلاح إعدادات Nginx:**

#### **أ) تحديث ملف Nginx:**

```bash
# نسخ الإعدادات الجديدة
sudo cp /path/to/FLUTTER_WEB_NGINX_FIX.conf /etc/nginx/sites-available/app.idec-ye.com

# إعادة تحميل Nginx
sudo nginx -t
sudo systemctl reload nginx
```

### **3. إصلاح Content Security Policy:**

#### **المشكلة الحالية:**

```http
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' blob: data: https://www.gstatic.com; ...
```

#### **الحل:**

```http
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' blob: data: https://www.gstatic.com; script-src-elem 'self' 'unsafe-inline' blob: data: https://www.gstatic.com; style-src 'self' 'unsafe-inline' blob: data:; font-src 'self' data: blob:; img-src 'self' data: blob: https:; connect-src 'self' http://app.idec-ye.com http://idec-ye.com http://localhost:8080 blob: data: ws: wss:; worker-src 'self' blob:; child-src 'self' blob:; object-src 'none'; base-uri 'self'; frame-ancestors 'none';
```

### **4. إضافة Headers مطلوبة لـ Flutter Web:**

```http
Cross-Origin-Embedder-Policy: require-corp
Cross-Origin-Opener-Policy: same-origin
```

### **5. إصلاح أنواع الملفات:**

#### **ملفات JavaScript:**

```http
Content-Type: application/javascript
Cache-Control: public, max-age=31536000
```

#### **ملفات WebAssembly:**

```http
Content-Type: application/wasm
Cache-Control: public, max-age=31536000
```

#### **ملفات Dart:**

```http
Content-Type: application/dart
Cache-Control: public, max-age=31536000
```

## 🔍 **خطوات التشخيص:**

### **1. فحص الملفات:**

```bash
# فحص وجود الملفات الأساسية
curl -I http://app.idec-ye.com/index.html
curl -I http://app.idec-ye.com/main.dart.js
curl -I http://app.idec-ye.com/flutter_bootstrap.js
```

### **2. فحص Headers:**

```bash
# فحص Content Security Policy
curl -I http://app.idec-ye.com | grep -i "content-security-policy"

# فحص CORS Headers
curl -I http://app.idec-ye.com | grep -i "access-control"
```

### **3. فحص Console في المتصفح:**

- افتح Developer Tools (F12)
- اذهب إلى Console
- ابحث عن أخطاء CSP أو CORS
- ابحث عن أخطاء تحميل الملفات

## 🛠️ **خطوات الإصلاح:**

### **الخطوة 1: تحديث إعدادات الخادم**

```bash
# إذا كنت تستخدم Apache
sudo cp FLUTTER_WEB_APACHE_FIX.conf /etc/apache2/sites-available/app.idec-ye.com.conf
sudo systemctl reload apache2

# إذا كنت تستخدم Nginx
sudo cp FLUTTER_WEB_NGINX_FIX.conf /etc/nginx/sites-available/app.idec-ye.com
sudo nginx -t
sudo systemctl reload nginx
```

### **الخطوة 2: إعادة بناء Flutter Web**

```bash
cd mobile-app
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
```

### **الخطوة 3: رفع الملفات الجديدة**

```bash
# رفع الملفات المبنية إلى الخادم
rsync -av build/web/ user@server:/home/app/public_html/
```

### **الخطوة 4: اختبار التطبيق**

```bash
# اختبار HTTP
curl -I http://app.idec-ye.com

# اختبار HTTPS (إذا كان متاحاً)
curl -I https://app.idec-ye.com
```

## 🎯 **المشاكل الشائعة والحلول:**

### **1. خطأ CSP:**

```
Refused to load the script because it violates the following Content Security Policy directive
```

**الحل:** تحديث CSP لتشمل `https://www.gstatic.com` و `blob:` و `data:`

### **2. خطأ CORS:**

```
Access to fetch at '...' from origin '...' has been blocked by CORS policy
```

**الحل:** إضافة CORS headers صحيحة

### **3. خطأ Cross-Origin:**

```
Cross-Origin-Embedder-Policy: require-corp
```

**الحل:** إضافة Cross-Origin headers

### **4. خطأ تحميل الملفات:**

```
Failed to load resource: the server responded with a status of 404
```

**الحل:** التأكد من رفع جميع الملفات المطلوبة

## 📋 **قائمة التحقق:**

- [ ] تحديث إعدادات Apache/Nginx
- [ ] إضافة CSP headers صحيحة
- [ ] إضافة CORS headers
- [ ] إضافة Cross-Origin headers
- [ ] إعادة بناء Flutter Web
- [ ] رفع الملفات الجديدة
- [ ] اختبار التطبيق
- [ ] فحص Console للأخطاء

## 🚀 **النتيجة المتوقعة:**

بعد تطبيق هذه الإصلاحات، يجب أن يعمل تطبيق Flutter Web بشكل صحيح على الاستضافة
دون أخطاء في Console.

## 📞 **الدعم:**

إذا استمرت المشكلة، يرجى:

1. فحص Console في المتصفح
2. فحص logs الخادم
3. التأكد من رفع جميع الملفات المطلوبة
4. اختبار على متصفحات مختلفة
