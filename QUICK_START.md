# 🚀 دليل التشغيل السريع - IDEC Mobile App

## تشغيل المشروع من Windows

### من PowerShell:
```powershell
cd D:\IDEC\IDEC2.4\mobile-app
.\run.ps1
```

### من CMD:
```cmd
cd D:\IDEC\IDEC2.4\mobile-app
run.bat
```

### تشغيل على Chrome (افتراضي):
```powershell
.\run.ps1
```

### تشغيل على Edge:
```powershell
.\run.ps1 -Device edge
```

### تشغيل على Android:
```powershell
.\run.ps1 -Android
```

### تشغيل على منفذ مخصص:
```powershell
.\run.ps1 -Port 3000
```

---

## تشغيل المشروع من WSL

### طريقة 1: استخدام PowerShell من WSL
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
powershell.exe -File run.ps1
```

### طريقة 2: استخدام CMD من WSL
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
cmd.exe /c run.bat
```

### طريقة 3: تشغيل مباشر من WSL
```bash
cd /mnt/d/IDEC/IDEC2.4/mobile-app
powershell.exe -Command "cd D:\IDEC\IDEC2.4\mobile-app; flutter pub get; flutter run -d chrome --web-port=8080"
```

---

## الأوامر الأساسية

### تحميل التبعيات:
```powershell
flutter pub get
```

### التحقق من الأجهزة المتاحة:
```powershell
flutter devices
```

### تشغيل على Chrome:
```powershell
flutter run -d chrome --web-port=8080
```

### تشغيل على Edge:
```powershell
flutter run -d edge --web-port=8080
```

### تشغيل على Android:
```powershell
flutter run -d android
```

### بناء للتطوير:
```powershell
flutter build web --web-renderer html
```

### بناء للإنتاج:
```powershell
flutter build web --release
```

---

## استكشاف الأخطاء

### Flutter غير موجود:
```powershell
# التحقق من Flutter
flutter --version

# إذا لم يكن موجوداً، أضفه إلى PATH:
# C:\dev\flutter\bin
```

### مشاكل في التبعيات:
```powershell
# تنظيف المشروع
flutter clean

# إعادة تحميل التبعيات
flutter pub get
```

### مشاكل في المنفذ:
```powershell
# استخدام منفذ مختلف
flutter run -d chrome --web-port=3000
```

---

## الملفات المتاحة

- `run.ps1` - سكريبت PowerShell للتشغيل
- `run.bat` - سكريبت CMD للتشغيل
- `build_web.ps1` - بناء للويب
- `rebuild-flutter-web.bat` - إعادة بناء للويب

---

## المساعدة

لعرض المساعدة:
```powershell
.\run.ps1 -Help
```






