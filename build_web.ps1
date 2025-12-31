# Flutter Web Build Script for IDEC Mobile App
# This script builds the Flutter web app and prepares it for deployment

Write-Host "🚀 بدء بناء تطبيق IDEC للويب..." -ForegroundColor Green

# Clean previous build
Write-Host "🧹 تنظيف البناء السابق..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "📦 تحميل التبعيات..." -ForegroundColor Yellow
flutter pub get

# Build for web
Write-Host "🔨 بناء التطبيق للويب..." -ForegroundColor Yellow
flutter build web --release

# Check if build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ تم بناء التطبيق بنجاح!" -ForegroundColor Green
    
    # Display build info
    Write-Host "`n📊 معلومات البناء:" -ForegroundColor Cyan
    Write-Host "📁 مجلد البناء: build/web" -ForegroundColor White
    
    # List important files
    Write-Host "`n📋 الملفات المهمة:" -ForegroundColor Cyan
    $buildPath = "build/web"
    
    if (Test-Path "$buildPath/index.html") {
        Write-Host "✅ index.html" -ForegroundColor Green
    } else {
        Write-Host "❌ index.html مفقود" -ForegroundColor Red
    }
    
    if (Test-Path "$buildPath/main.dart.js") {
        Write-Host "✅ main.dart.js" -ForegroundColor Green
    } else {
        Write-Host "❌ main.dart.js مفقود" -ForegroundColor Red
    }
    
    if (Test-Path "$buildPath/flutter.js") {
        Write-Host "✅ flutter.js" -ForegroundColor Green
    } else {
        Write-Host "❌ flutter.js مفقود" -ForegroundColor Red
    }
    
    if (Test-Path "$buildPath/flutter_bootstrap.js") {
        Write-Host "✅ flutter_bootstrap.js" -ForegroundColor Green
    } else {
        Write-Host "❌ flutter_bootstrap.js مفقود" -ForegroundColor Red
    }
    
    if (Test-Path "$buildPath/cors_handler.js") {
        Write-Host "✅ cors_handler.js" -ForegroundColor Green
    } else {
        Write-Host "❌ cors_handler.js مفقود" -ForegroundColor Red
    }
    
    if (Test-Path "$buildPath/disable_google_fonts.js") {
        Write-Host "✅ disable_google_fonts.js" -ForegroundColor Green
    } else {
        Write-Host "❌ disable_google_fonts.js مفقود" -ForegroundColor Red
    }
    
    if (Test-Path "$buildPath/flutter_web_config.js") {
        Write-Host "✅ flutter_web_config.js" -ForegroundColor Green
    } else {
        Write-Host "❌ flutter_web_config.js مفقود" -ForegroundColor Red
    }
    
    # Check fonts
    if (Test-Path "$buildPath/assets/assets/fonts") {
        $fontCount = (Get-ChildItem "$buildPath/assets/assets/fonts" -Recurse -File).Count
        Write-Host "✅ ملفات الخطوط: $fontCount ملف" -ForegroundColor Green
    } else {
        Write-Host "❌ مجلد الخطوط مفقود" -ForegroundColor Red
    }
    
    # Display deployment instructions
    Write-Host "`n🚀 تعليمات النشر:" -ForegroundColor Cyan
    Write-Host "1. ارفع محتويات مجلد build/web إلى خادم app.idec-ye.com" -ForegroundColor White
    Write-Host "2. تأكد من رفع جميع الملفات والمجلدات" -ForegroundColor White
    Write-Host "3. تأكد من إعدادات الخادم لدعم SPA (Single Page Application)" -ForegroundColor White
    Write-Host "4. تأكد من إعدادات CORS إذا لزم الأمر" -ForegroundColor White
    
    Write-Host "`n🎉 جاهز للنشر!" -ForegroundColor Green
    
} else {
    Write-Host "❌ فشل في بناء التطبيق!" -ForegroundColor Red
    Write-Host "تحقق من الأخطاء أعلاه وحاول مرة أخرى." -ForegroundColor Yellow
}

Write-Host "`nانتهى البناء." -ForegroundColor Blue