# 🚀 تشغيل مشروع IDEC Mobile App من WSL

## الطريقة السريعة (موصى بها)

### من WSL Terminal:
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
powershell.exe -File run.ps1
```

## الطرق المتاحة

### 1️⃣ استخدام PowerShell Script (الأسهل)
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
powershell.exe -File run.ps1
```

### 2️⃣ استخدام CMD Batch File
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
cmd.exe /c run.bat
```

### 3️⃣ استخدام Bash Script المخصص
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
./run-from-wsl.sh
```

### 4️⃣ تشغيل مباشر من WSL
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
powershell.exe -Command "cd D:\IDEC\IDEC2.4\mobile-app; flutter pub get; flutter run -d chrome --web-port=8080"
```

## الخيارات المتاحة

### تشغيل على Chrome (افتراضي):
```bash
powershell.exe -File run.ps1
```

### تشغيل على Edge:
```bash
powershell.exe -File run.ps1 -Device edge
```

### تشغيل على Windows Desktop:
```bash
powershell.exe -File run.ps1 -Device windows
```

### تشغيل على Android:
```bash
powershell.exe -File run.ps1 -Android
```

### تشغيل على منفذ مخصص:
```bash
powershell.exe -File run.ps1 -Port 3000
```

## عرض المساعدة

```bash
powershell.exe -File run.ps1 -Help
```

## الأجهزة المتاحة

للتحقق من الأجهزة المتاحة:
```bash
powershell.exe -Command "cd D:\IDEC\IDEC2.4\mobile-app; flutter devices"
```

## ملاحظات مهمة

1. ✅ Flutter يجب أن يكون مثبت في Windows
2. ✅ المسار: `C:\dev\flutter\bin` (موجود في PATH)
3. ✅ المشروع موجود في: `D:\IDEC\IDEC2.4\mobile-app`
4. ✅ يمكن تشغيله من WSL باستخدام `powershell.exe` أو `cmd.exe`

## استكشاف الأخطاء

### إذا لم يعمل Flutter:
```bash
powershell.exe -Command "flutter --version"
```

### إذا فشل تحميل التبعيات:
```bash
powershell.exe -Command "cd D:\IDEC\IDEC2.4\mobile-app; flutter clean; flutter pub get"
```

### للتحقق من حالة Flutter:
```bash
powershell.exe -Command "cd D:\IDEC\IDEC2.4\mobile-app; flutter doctor"
```

## الملفات المتاحة

- `run.ps1` - سكريبت PowerShell للتشغيل (موصى به)
- `run.bat` - سكريبت CMD للتشغيل
- `run-from-wsl.sh` - سكريبت Bash للتشغيل من WSL
- `build_web.ps1` - بناء للويب
- `rebuild-flutter-web.bat` - إعادة بناء للويب

---

## مثال كامل للتشغيل

```bash
# 1. الانتقال إلى مجلد المشروع
cd /mnt/d/IDEC/IDEC2.4/mobile-app

# 2. تشغيل المشروع
powershell.exe -File run.ps1

# التطبيق سيفتح في Chrome على المنفذ 8080
# اضغط 'r' لإعادة التحميل
# اضغط 'q' للخروج
```













