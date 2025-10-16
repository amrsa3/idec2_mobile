# إعداد Virtualmin Proxy لحل مشكلة Mixed Content

## 🔍 **المشكلة:**

- **التطبيق:** `https://app.idec-ye.com` (HTTPS)
- **API:** `http://idec-ye.com:3000` (HTTP)
- **المشكلة:** Mixed Content Error + CORS Issues

## 🛠️ **الحل: إعداد Proxy في Virtualmin**

### **الخطوة 1: إعداد Virtualmin**

1. **ادخل إلى Webmin:**

   ```
   https://84.247.128.128:10000
   ```

2. **اذهب إلى Virtualmin:**
   - Server Configuration
   - Create Virtual Server
   - أو تعديل الموجود: `app.idec-ye.com`

### **الخطوة 2: إعداد Apache Proxy**

في Virtualmin، أضف هذه الإعدادات:

```apache
# في Apache Directives
ProxyPreserveHost On
ProxyPass /api/ http://idec-ye.com:3000/api/
ProxyPassReverse /api/ http://idec-ye.com:3000/api/
ProxyPass /health http://idec-ye.com:3000/health
ProxyPassReverse /health http://idec-ye.com:3000/health

# CORS Headers
Header always set Access-Control-Allow-Origin "*"
Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"

# Handle preflight requests
RewriteEngine On
RewriteCond %{REQUEST_METHOD} OPTIONS
RewriteRule ^(.*)$ $1 [R=200,L]
```

### **الخطوة 3: تحديث التطبيق**

```dart
// في api_constants.dart
class ApiConstants {
  // Default URLs - using same subdomain with proxy
  static const String defaultBaseUrl = 'https://app.idec-ye.com';
  static const String devUrl = 'https://app.idec-ye.com';
  static const String prodUrl = 'https://app.idec-ye.com';

  // Fallback domain URL
  static const String domainUrl = 'https://app.idec-ye.com';
```

### **الخطوة 4: إعادة بناء التطبيق**

```bash
flutter build web --release
```

## 🎯 **النتيجة المتوقعة:**

1. **✅ التطبيق:** `https://app.idec-ye.com` (HTTPS)
2. **✅ API Calls:** `https://app.idec-ye.com/api/v1/auth/login` (HTTPS)
3. **✅ Proxy:** يوجه الطلبات إلى `http://idec-ye.com:3000`
4. **✅ لا توجد مشاكل Mixed Content**

## 🔄 **كيف يعمل:**

1. **المستخدم:** يفتح `https://app.idec-ye.com`
2. **التطبيق:** يرسل طلب إلى `https://app.idec-ye.com/api/v1/auth/login`
3. **Apache Proxy:** يوجه الطلب إلى `http://idec-ye.com:3000/api/v1/auth/login`
4. **Node.js:** يستجيب بالبيانات
5. **Apache Proxy:** يرسل الاستجابة للمستخدم

## 📋 **الخطوات التفصيلية:**

### **في Virtualmin:**

1. **اذهب إلى:** `app.idec-ye.com` → Apache Website
2. **أضف في Directives:**
   ```apache
   ProxyPreserveHost On
   ProxyPass /api/ http://idec-ye.com:3000/api/
   ProxyPassReverse /api/ http://idec-ye.com:3000/api/
   ```
3. **احفظ التغييرات**
4. **أعد تشغيل Apache**

### **في التطبيق:**

1. **حدث `api_constants.dart`:**
   ```dart
   static const String defaultBaseUrl = 'https://app.idec-ye.com';
   ```
2. **أعد بناء التطبيق:**
   ```bash
   flutter build web --release
   ```
3. **ارفع الملفات الجديدة**

## 🧪 **اختبار النظام:**

```bash
# اختبار التطبيق
curl -I https://app.idec-ye.com

# اختبار API عبر Proxy
curl -I https://app.idec-ye.com/api/v1/auth/login

# اختبار API مباشرة
curl -I http://idec-ye.com:3000/api/v1/auth/login
```

## ⚠️ **ملاحظات مهمة:**

1. **تأكد من أن Apache modules مفعلة:**

   ```bash
   sudo a2enmod proxy proxy_http headers rewrite
   sudo systemctl restart apache2
   ```

2. **تأكد من أن Node.js يعمل:**

   ```bash
   curl -I http://idec-ye.com:3000/health
   ```

3. **تحقق من CORS في Node.js:**
   ```typescript
   // في main.ts
   origin: ['https://app.idec-ye.com'];
   ```

## 🎉 **الخلاصة:**

هذا الحل يحل مشكلة Mixed Content Error ويسمح للتطبيق بالعمل بشكل صحيح مع API عبر
HTTPS.
