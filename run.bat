@echo off
REM Flutter Run Script for IDEC Mobile App (CMD)
REM تشغيل مشروع IDEC Mobile App

setlocal enabledelayedexpansion

REM الانتقال إلى مجلد المشروع
cd /d "%~dp0"

echo ═══════════════════════════════════════════════════
echo 🚀 تشغيل مشروع IDEC Mobile App
echo ═══════════════════════════════════════════════════
echo.

REM التحقق من وجود Flutter
echo 🔍 التحقق من Flutter...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ خطأ: Flutter غير موجود أو غير مثبت بشكل صحيح!
    echo    تأكد من تثبيت Flutter وإضافته إلى PATH
    pause
    exit /b 1
)
echo ✅ Flutter جاهز
echo.

REM الحصول على التبعيات
echo 📦 تحميل التبعيات...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ فشل تحميل التبعيات!
    pause
    exit /b 1
)
echo ✅ تم تحميل التبعيات بنجاح
echo.

REM التحقق من الأجهزة المتاحة
echo 📱 الأجهزة المتاحة:
flutter devices
echo.

REM تحديد الجهاز (افتراضي: chrome)
set DEVICE=chrome
set PORT=8080

REM التحقق من المعاملات
if "%1"=="android" set DEVICE=android
if "%1"=="edge" set DEVICE=edge
if "%2" neq "" set PORT=%2

echo 🌐 تشغيل على %DEVICE% (المنفذ: %PORT%)...
echo.
echo ═══════════════════════════════════════════════════
echo 🚀 بدء التشغيل...
echo ═══════════════════════════════════════════════════
echo.
echo 💡 نصيحة: اضغط 'r' لإعادة التحميل، 'R' لإعادة التشغيل الكامل
echo 💡 اضغط 'q' للخروج
echo.

REM تشغيل التطبيق
if "%DEVICE%"=="android" (
    flutter run -d android
) else (
    flutter run -d %DEVICE% --web-port=%PORT%
)

REM في حالة الإغلاق
echo.
echo ✅ تم إيقاف التطبيق
pause














