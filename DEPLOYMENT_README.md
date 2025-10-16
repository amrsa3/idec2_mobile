# دليل نشر تطبيق IDEC Flutter Web مع حماية CSP

## 🎯 نظرة عامة

هذا الدليل يوضح كيفية نشر تطبيق IDEC Flutter Web مع حماية كاملة من Content Security Policy (CSP) ومنع تحميل الموارد الخارجية من Google CDN.

## 🛡️ الحماية المطبقة

### 1. حماية JavaScript (flutter_web_config.js)
- **اعتراض URL Constructor**: إعادة توجيه طلبات CanvasKit CDN إلى الملفات المحلية
- **اعتراض Fetch API**: منع وإعادة توجيه طلبات CDN
- **اعتراض XMLHttpRequest**: حماية من طلبات XHR للـ CDN
- **اعتراض createElement**: إعادة توجيه مصادر العناصر من CDN إلى محلي
- **اعتراض Dynamic Import**: حماية من استيراد الوحدات من CDN

### 2. حماية الخادم
- **Apache (.htaccess)**: قواعد إعادة كتابة وحظر CDN
- **Nginx (nginx.conf)**: تكوين شامل مع حماية CSP
- **Headers أمان**: Content Security Policy صارم

## 🚀 خطوات النشر

### الخطوة 1: إعداد ملفات Flutter Web

```bash
# في مجلد mobile-app
flutter build web --release --web-renderer canvaskit
```

### الخطوة 2: نسخ الملفات إلى الخادم

```bash
# نسخ محتويات build/web إلى مجلد الخادم
cp -r build/web/* /path/to/your/web/directory/
```

### الخطوة 3: إعداد Apache

#### أ. تفعيل الوحدات المطلوبة:
```bash
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod deflate
sudo a2enmod expires
sudo a2enmod mime
```

#### ب. تكوين Virtual Host:
```apache
<VirtualHost *:443>
    ServerName your-domain.com
    DocumentRoot /path/to/your/web/directory
    
    # SSL Configuration
    SSLEngine on
    SSLCertificateFile /path/to/certificate.crt
    SSLCertificateKeyFile /path/to/private.key
    
    # Include .htaccess rules
    <Directory "/path/to/your/web/directory">
        AllowOverride All
        Require all granted
    </Directory>
    
    # Error and Access logs
    ErrorLog ${APACHE_LOG_DIR}/flutter_app_error.log
    CustomLog ${APACHE_LOG_DIR}/flutter_app_access.log combined
</VirtualHost>
```

### الخطوة 4: إعداد Nginx

#### أ. نسخ ملف التكوين:
```bash
sudo cp nginx.conf /etc/nginx/sites-available/flutter-app
sudo ln -s /etc/nginx/sites-available/flutter-app /etc/nginx/sites-enabled/
```

#### ب. تحديث المسارات في nginx.conf:
```nginx
# تحديث هذه المسارات حسب إعدادك
server_name your-domain.com www.your-domain.com;
root /path/to/your/flutter/web/build;
ssl_certificate /path/to/your/certificate.crt;
ssl_certificate_key /path/to/your/private.key;
```

#### ج. اختبار وإعادة تشغيل Nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

### الخطوة 5: إعداد Apache + Nginx (Reverse Proxy)

إذا كنت تستخدم Nginx كـ reverse proxy أمام Apache:

#### تكوين Nginx (Frontend):
```nginx
upstream apache_backend {
    server 127.0.0.1:8080;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    # SSL configuration
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    # Security headers
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; font-src 'self' data:; img-src 'self' data:; connect-src 'self' https://app.idec-ye.com; object-src 'none';" always;
    
    # Block Google CDN
    location ~* (gstatic\.com|googleapis\.com) {
        return 403;
    }
    
    # Serve static files directly
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|wasm)$ {
        root /path/to/your/web/directory;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Proxy other requests to Apache
    location / {
        proxy_pass http://apache_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### تكوين Apache (Backend):
```apache
<VirtualHost *:8080>
    ServerName your-domain.com
    DocumentRoot /path/to/your/web/directory
    
    <Directory "/path/to/your/web/directory">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

## 🔧 استكشاف الأخطاء

### 1. فحص CSP Violations
```javascript
// في Developer Tools Console
window.addEventListener('securitypolicyviolation', (e) => {
    console.log('CSP Violation:', e.violatedDirective, e.blockedURI);
});
```

### 2. فحص طلبات الشبكة
- افتح Developer Tools → Network
- ابحث عن طلبات لـ `gstatic.com` أو `googleapis.com`
- يجب أن تكون محظورة أو معاد توجيهها

### 3. اختبار CanvasKit المحلي
```bash
# تحقق من وجود ملفات CanvasKit
ls -la /path/to/web/directory/canvaskit/
# يجب أن تجد: canvaskit.js, canvaskit.wasm, chromium/, skwasm.js, etc.
```

### 4. فحص سجلات الخادم
```bash
# Apache
tail -f /var/log/apache2/flutter_app_error.log

# Nginx
tail -f /var/log/nginx/flutter_app_error.log
```

## 📊 اختبار الأداء

### 1. اختبار سرعة التحميل
```bash
# استخدم curl لاختبار الاستجابة
curl -w "@curl-format.txt" -o /dev/null -s "https://your-domain.com"
```

### 2. اختبار CSP
```bash
# استخدم أدوات مثل securityheaders.com
curl -I https://your-domain.com | grep -i content-security-policy
```

### 3. اختبار الضغط
```bash
# تحقق من تفعيل gzip
curl -H "Accept-Encoding: gzip" -I https://your-domain.com/main.dart.js
```

## 🔒 نصائح الأمان

### 1. تحديث منتظم
- احرص على تحديث Flutter SDK
- حدث ملفات CanvasKit عند تحديث Flutter
- راجع CSP policy بانتظام

### 2. مراقبة السجلات
- راقب محاولات الوصول لـ CDN المحظور
- تتبع أخطاء CSP violations
- راجع سجلات الأمان بانتظام

### 3. النسخ الاحتياطي
- احتفظ بنسخة احتياطية من ملفات التكوين
- اختبر الاستعادة بانتظام
- وثق أي تغييرات في التكوين

## 📝 ملاحظات مهمة

1. **تحديث المسارات**: تأكد من تحديث جميع المسارات في ملفات التكوين
2. **شهادات SSL**: استخدم شهادات SSL صالحة للإنتاج
3. **DNS**: تأكد من إعداد DNS بشكل صحيح
4. **Firewall**: تأكد من فتح المنافذ المطلوبة (80, 443)
5. **Permissions**: تأكد من صلاحيات الملفات والمجلدات

## 🆘 الدعم

في حالة مواجهة مشاكل:

1. تحقق من سجلات الخادم
2. اختبر التكوين محلياً أولاً
3. استخدم أدوات Developer Tools للتشخيص
4. راجع ملف `diagnostic.html` للاختبارات التلقائية

---

**تم إنشاء هذا الدليل لضمان نشر آمن وفعال لتطبيق IDEC Flutter Web مع حماية كاملة من CSP.**