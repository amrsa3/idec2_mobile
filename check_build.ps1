# Flutter Web Build Verification Script
# يتحقق من وجود جميع الملفات المطلوبة للنشر

Write-Host "🔍 فحص ملفات البناء..." -ForegroundColor Cyan

$buildPath = "build\web"
$allGood = $true

# التحقق من الملفات الأساسية
$requiredFiles = @(
    "index.html",
    "main.dart.js", 
    "flutter.js",
    "flutter_bootstrap.js",
    "flutter_service_worker.js",
    "cors_handler.js",
    "disable_google_fonts.js",
    "flutter_web_config.js",
    "manifest.json",
    "favicon.png"
)

Write-Host "`n📋 الملفات الأساسية:" -ForegroundColor Yellow
foreach ($file in $requiredFiles) {
    $filePath = Join-Path $buildPath $file
    if (Test-Path $filePath) {
        $size = (Get-Item $filePath).Length
        Write-Host "✅ $file ($([math]::Round($size/1KB, 1)) KB)" -ForegroundColor Green
    } else {
        Write-Host "❌ $file مفقود" -ForegroundColor Red
        $allGood = $false
    }
}

# التحقق من مجلد الخطوط
Write-Host "`n🔤 ملفات الخطوط:" -ForegroundColor Yellow
$fontsPath = Join-Path $buildPath "assets\assets\fonts"
if (Test-Path $fontsPath) {
    $fontFiles = Get-ChildItem $fontsPath -Recurse -File -Filter "*.ttf"
    foreach ($font in $fontFiles) {
        $size = [math]::Round($font.Length/1KB, 1)
        Write-Host "✅ $($font.Name) ($size KB)" -ForegroundColor Green
    }
    Write-Host "📊 إجمالي ملفات الخطوط: $($fontFiles.Count)" -ForegroundColor Cyan
} else {
    Write-Host "❌ مجلد الخطوط مفقود" -ForegroundColor Red
    $allGood = $false
}

# التحقق من مجلد canvaskit
Write-Host "`n🎨 ملفات CanvasKit:" -ForegroundColor Yellow
$canvaskitPath = Join-Path $buildPath "canvaskit"
if (Test-Path $canvaskitPath) {
    $canvaskitFiles = Get-ChildItem $canvaskitPath -Recurse -File
    Write-Host "✅ مجلد CanvasKit ($($canvaskitFiles.Count) ملف)" -ForegroundColor Green
} else {
    Write-Host "❌ مجلد CanvasKit مفقود" -ForegroundColor Red
    $allGood = $false
}

# التحقق من مجلد الأيقونات
Write-Host "`n🖼️ ملفات الأيقونات:" -ForegroundColor Yellow
$iconsPath = Join-Path $buildPath "icons"
if (Test-Path $iconsPath) {
    $iconFiles = Get-ChildItem $iconsPath -File
    foreach ($icon in $iconFiles) {
        Write-Host "✅ $($icon.Name)" -ForegroundColor Green
    }
} else {
    Write-Host "❌ مجلد الأيقونات مفقود" -ForegroundColor Red
    $allGood = $false
}

# النتيجة النهائية
Write-Host "`n" + "="*50 -ForegroundColor Blue
if ($allGood) {
    Write-Host "🎉 جميع الملفات موجودة وجاهزة للنشر!" -ForegroundColor Green
    Write-Host "`n📤 خطوات النشر:" -ForegroundColor Cyan
    Write-Host "1. ارفع محتويات مجلد build\web إلى app.idec-ye.com" -ForegroundColor White
    Write-Host "2. تأكد من الحفاظ على بنية المجلدات" -ForegroundColor White
    Write-Host "3. تحقق من إعدادات الخادم (.htaccess أو nginx)" -ForegroundColor White
    
    # حساب حجم البناء الإجمالي
    $totalSize = (Get-ChildItem $buildPath -Recurse -File | Measure-Object -Property Length -Sum).Sum
    $totalSizeMB = [math]::Round($totalSize/1MB, 2)
    Write-Host "`n📊 حجم البناء الإجمالي: $totalSizeMB MB" -ForegroundColor Cyan
    
} else {
    Write-Host "⚠️ بعض الملفات مفقودة! قم بإعادة البناء." -ForegroundColor Red
    Write-Host "تشغيل: flutter clean && flutter build web --release" -ForegroundColor Yellow
}
Write-Host "="