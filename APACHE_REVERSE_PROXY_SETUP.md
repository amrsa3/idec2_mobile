# إعداد Apache كـ Reverse Proxy للخادم Node.js

## 📋 **إعداد Apache للعمل مع Node.js**

### 1. **تحديث إعدادات Apache:**

```apache
# /etc/apache2/sites-available/app.idec-ye.com.conf

<VirtualHost *:8080>
    ServerName app.idec-ye.com

    # Frontend (Flutter Web App)
    DocumentRoot /home/app/public_html
    <Directory /home/app/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # API Proxy to Node.js Backend
    ProxyPreserveHost On
    ProxyPass /api/ http://localhost:3000/api/
    ProxyPassReverse /api/ http://localhost:3000/api/

    # Health Check Proxy
    ProxyPass /health http://localhost:3000/health
    ProxyPassReverse /health http://localhost:3000/health

    # Enable CORS for API requests
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"

    # Handle preflight requests
    RewriteEngine On
    RewriteCond %{REQUEST_METHOD} OPTIONS
    RewriteRule ^(.*)$ $1 [R=200,L]
</VirtualHost>

<VirtualHost *:8443>
    ServerName app.idec-ye.com
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/app.idec-ye.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/app.idec-ye.com/privkey.pem

    # Frontend (Flutter Web App)
    DocumentRoot /home/app/public_html
    <Directory /home/app/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # API Proxy to Node.js Backend
    ProxyPreserveHost On
    ProxyPass /api/ http://localhost:3000/api/
    ProxyPassReverse /api/ http://localhost:3000/api/

    # Health Check Proxy
    ProxyPass /health http://localhost:3000/health
    ProxyPassReverse /health http://localhost:3000/health

    # Enable CORS for API requests
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"

    # Handle preflight requests
    RewriteEngine On
    RewriteCond %{REQUEST_METHOD} OPTIONS
    RewriteRule ^(.*)$ $1 [R=200,L]
</VirtualHost>
```

### 2. **تفعيل الوحدات المطلوبة:**

```bash
# تفعيل mod_proxy و mod_headers
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod rewrite

# إعادة تشغيل Apache
sudo systemctl restart apache2
```

### 3. **تحديث التطبيق لاستخدام المنافذ الصحيحة:**

```dart
// في api_constants.dart
class ApiConstants {
  // Default URLs - using Apache ports (which proxy to Node.js)
  static const String defaultBaseUrl = 'https://app.idec-ye.com:8443';
  static const String devUrl = 'https://app.idec-ye.com:8443';
  static const String prodUrl = 'https://app.idec-ye.com:8443';

  // Fallback domain URL (HTTP version)
  static const String domainUrl = 'http://app.idec-ye.com:8080';
```

---

## 🔄 **كيف يعمل النظام:**

### **الطلبات:**

1. **التطبيق:** `https://app.idec-ye.com:8443/api/v1/auth/login`
2. **Apache:** يستقبل الطلب على المنفذ 8443
3. **Proxy:** يحول الطلب إلى `http://localhost:3000/api/v1/auth/login`
4. **Node.js:** يستقبل الطلب ويعالجه
5. **الاستجابة:** ترجع عبر Apache إلى التطبيق

### **المزايا:**

- ✅ **HTTPS للجميع** - لا توجد مشاكل Mixed Content
- ✅ **أمان أفضل** - SSL في Apache
- ✅ **أداء أفضل** - Apache محسن للـ static files
- ✅ **إدارة أسهل** - SSL في مكان واحد

---

## 🚀 **الخطوات السريعة:**

### 1. **تحديث إعدادات Apache:**

```bash
sudo nano /etc/apache2/sites-available/app.idec-ye.com.conf
# أضف الإعدادات أعلاه
```

### 2. **تفعيل الوحدات:**

```bash
sudo a2enmod proxy proxy_http headers rewrite
sudo systemctl restart apache2
```

### 3. **اختبار النظام:**

```bash
# اختبار Health Check
curl -I https://app.idec-ye.com:8443/health

# اختبار API
curl -X POST https://app.idec-ye.com:8443/api/v1/auth/login \
  -H "Content-Type: application/json" \
  --data '{"phone":"test","password":"test"}'
```

### 4. **تحديث التطبيق:**

```dart
// في api_constants.dart
static const String defaultBaseUrl = 'https://app.idec-ye.com:8443';
```

---

## 🎯 **النتيجة المتوقعة:**

بعد تطبيق هذا الإعداد:

- ✅ **التطبيق:** `https://app.idec-ye.com:8443` (HTTPS)
- ✅ **API Calls:** `https://app.idec-ye.com:8443/api/v1/auth/login` (HTTPS)
- ✅ **لا توجد مشاكل Mixed Content**
- ✅ **تسجيل الدخول يعمل بدون مشاكل**

**هل تريد تطبيق هذا الإعداد؟** 🤔
