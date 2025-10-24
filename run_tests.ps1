# سكريبت PowerShell للتشغيل والاختبار - النظام المحسن للمصادقة
# Enhanced Auth System - PowerShell Run and Test Script

param(
    [Parameter(Position = 0)]
    [string]$Command = "help"
)

# دالة طباعة الرسائل الملونة
function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️ $Message" -ForegroundColor Blue
}

# التحقق من وجود Flutter
function Test-Flutter {
    Write-Info "التحقق من وجود Flutter..."
    try {
        $flutterVersion = flutter --version
        Write-Success "Flutter موجود"
        return $true
    }
    catch {
        Write-Error "Flutter غير مثبت. يرجى تثبيت Flutter أولاً."
        return $false
    }
}

# التحقق من وجود Dart
function Test-Dart {
    Write-Info "التحقق من وجود Dart..."
    try {
        $dartVersion = dart --version
        Write-Success "Dart موجود"
        return $true
    }
    catch {
        Write-Error "Dart غير مثبت. يرجى تثبيت Dart أولاً."
        return $false
    }
}

# تنظيف المشروع
function Clear-Project {
    Write-Info "تنظيف المشروع..."
    try {
        flutter clean
        Write-Success "تم تنظيف المشروع"
        return $true
    }
    catch {
        Write-Error "فشل في تنظيف المشروع"
        return $false
    }
}

# تثبيت التبعيات
function Install-Dependencies {
    Write-Info "تثبيت التبعيات..."
    try {
        flutter pub get
        Write-Success "تم تثبيت التبعيات بنجاح"
        return $true
    }
    catch {
        Write-Error "فشل في تثبيت التبعيات"
        return $false
    }
}

# تشغيل تحليل الكود
function Start-Analysis {
    Write-Info "تشغيل تحليل الكود..."
    try {
        flutter analyze
        Write-Success "تحليل الكود مكتمل بدون أخطاء"
        return $true
    }
    catch {
        Write-Warning "تم العثور على تحذيرات في الكود"
        return $false
    }
}

# تشغيل الاختبارات
function Start-Tests {
    Write-Info "تشغيل الاختبارات..."
    try {
        flutter test
        Write-Success "جميع الاختبارات نجحت"
        return $true
    }
    catch {
        Write-Error "بعض الاختبارات فشلت"
        return $false
    }
}

# تشغيل اختبارات الوحدة
function Start-UnitTests {
    Write-Info "تشغيل اختبارات الوحدة..."
    try {
        flutter test test/unit/
        Write-Success "اختبارات الوحدة نجحت"
        return $true
    }
    catch {
        Write-Error "اختبارات الوحدة فشلت"
        return $false
    }
}

# تشغيل اختبارات التكامل
function Start-IntegrationTests {
    Write-Info "تشغيل اختبارات التكامل..."
    try {
        flutter test test/integration/
        Write-Success "اختبارات التكامل نجحت"
        return $true
    }
    catch {
        Write-Error "اختبارات التكامل فشلت"
        return $false
    }
}

# تشغيل اختبارات الأداء
function Start-PerformanceTests {
    Write-Info "تشغيل اختبارات الأداء..."
    try {
        flutter test test/performance/
        Write-Success "اختبارات الأداء نجحت"
        return $true
    }
    catch {
        Write-Error "اختبارات الأداء فشلت"
        return $false
    }
}

# تشغيل اختبارات الأمان
function Start-SecurityTests {
    Write-Info "تشغيل اختبارات الأمان..."
    try {
        flutter test test/security/
        Write-Success "اختبارات الأمان نجحت"
        return $true
    }
    catch {
        Write-Error "اختبارات الأمان فشلت"
        return $false
    }
}

# بناء التطبيق للويب
function Build-Web {
    Write-Info "بناء التطبيق للويب..."
    try {
        flutter build web
        Write-Success "تم بناء التطبيق للويب بنجاح"
        return $true
    }
    catch {
        Write-Error "فشل في بناء التطبيق للويب"
        return $false
    }
}

# بناء التطبيق للأندرويد
function Build-Android {
    Write-Info "بناء التطبيق للأندرويد..."
    try {
        flutter build apk
        Write-Success "تم بناء التطبيق للأندرويد بنجاح"
        return $true
    }
    catch {
        Write-Error "فشل في بناء التطبيق للأندرويد"
        return $false
    }
}

# بناء التطبيق لـ iOS
function Build-iOS {
    Write-Info "بناء التطبيق لـ iOS..."
    try {
        flutter build ios
        Write-Success "تم بناء التطبيق لـ iOS بنجاح"
        return $true
    }
    catch {
        Write-Error "فشل في بناء التطبيق لـ iOS"
        return $false
    }
}

# تشغيل التطبيق في وضع التطوير
function Start-Dev {
    Write-Info "تشغيل التطبيق في وضع التطوير..."
    try {
        flutter run
        return $true
    }
    catch {
        Write-Error "فشل في تشغيل التطبيق"
        return $false
    }
}

# تشغيل التطبيق للويب
function Start-Web {
    Write-Info "تشغيل التطبيق للويب..."
    try {
        flutter run -d web-server --web-port 8080
        return $true
    }
    catch {
        Write-Error "فشل في تشغيل التطبيق للويب"
        return $false
    }
}

# تشغيل التطبيق للأندرويد
function Start-Android {
    Write-Info "تشغيل التطبيق للأندرويد..."
    try {
        flutter run -d android
        return $true
    }
    catch {
        Write-Error "فشل في تشغيل التطبيق للأندرويد"
        return $false
    }
}

# تشغيل التطبيق لـ iOS
function Start-iOS {
    Write-Info "تشغيل التطبيق لـ iOS..."
    try {
        flutter run -d ios
        return $true
    }
    catch {
        Write-Error "فشل في تشغيل التطبيق لـ iOS"
        return $false
    }
}

# تشغيل جميع الاختبارات
function Start-AllTests {
    Write-Info "تشغيل جميع الاختبارات..."
    $unitResult = Start-UnitTests
    $integrationResult = Start-IntegrationTests
    $performanceResult = Start-PerformanceTests
    $securityResult = Start-SecurityTests
    
    if ($unitResult -and $integrationResult -and $performanceResult -and $securityResult) {
        Write-Success "جميع الاختبارات مكتملة"
        return $true
    }
    else {
        Write-Error "بعض الاختبارات فشلت"
        return $false
    }
}

# بناء جميع المنصات
function Build-All {
    Write-Info "بناء التطبيق لجميع المنصات..."
    $webResult = Build-Web
    $androidResult = Build-Android
    $iosResult = Build-iOS
    
    if ($webResult -and $androidResult -and $iosResult) {
        Write-Success "تم بناء التطبيق لجميع المنصات"
        return $true
    }
    else {
        Write-Error "فشل في بناء بعض المنصات"
        return $false
    }
}

# إعداد المشروع
function Initialize-Project {
    Write-Info "إعداد المشروع..."
    if (-not (Test-Flutter)) { return $false }
    if (-not (Test-Dart)) { return $false }
    if (-not (Clear-Project)) { return $false }
    if (-not (Install-Dependencies)) { return $false }
    Write-Success "تم إعداد المشروع بنجاح"
    return $true
}

# تشغيل التحقق الشامل
function Start-FullCheck {
    Write-Info "تشغيل التحقق الشامل..."
    if (-not (Initialize-Project)) { return $false }
    if (-not (Start-Analysis)) { return $false }
    if (-not (Start-AllTests)) { return $false }
    Write-Success "التحقق الشامل مكتمل"
    return $true
}

# عرض المساعدة
function Show-Help {
    Write-Host "استخدام: .\run_tests.ps1 [الخيار]"
    Write-Host ""
    Write-Host "الخيارات المتاحة:"
    Write-Host "  setup          - إعداد المشروع"
    Write-Host "  clean          - تنظيف المشروع"
    Write-Host "  install        - تثبيت التبعيات"
    Write-Host "  analyze        - تحليل الكود"
    Write-Host "  test           - تشغيل جميع الاختبارات"
    Write-Host "  test-unit      - اختبارات الوحدة فقط"
    Write-Host "  test-integration - اختبارات التكامل فقط"
    Write-Host "  test-performance - اختبارات الأداء فقط"
    Write-Host "  test-security  - اختبارات الأمان فقط"
    Write-Host "  build-web      - بناء التطبيق للويب"
    Write-Host "  build-android  - بناء التطبيق للأندرويد"
    Write-Host "  build-ios      - بناء التطبيق لـ iOS"
    Write-Host "  build-all      - بناء التطبيق لجميع المنصات"
    Write-Host "  run-dev        - تشغيل التطبيق في وضع التطوير"
    Write-Host "  run-web        - تشغيل التطبيق للويب"
    Write-Host "  run-android    - تشغيل التطبيق للأندرويد"
    Write-Host "  run-ios        - تشغيل التطبيق لـ iOS"
    Write-Host "  full-check     - التحقق الشامل"
    Write-Host "  help           - عرض هذه المساعدة"
}

# المعالجة الرئيسية
function Main {
    Write-Host "🚀 بدء تشغيل واختبار النظام المحسن للمصادقة" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    
    switch ($Command.ToLower()) {
        "setup" {
            Initialize-Project
        }
        "clean" {
            Clear-Project
        }
        "install" {
            Install-Dependencies
        }
        "analyze" {
            Start-Analysis
        }
        "test" {
            Start-AllTests
        }
        "test-unit" {
            Start-UnitTests
        }
        "test-integration" {
            Start-IntegrationTests
        }
        "test-performance" {
            Start-PerformanceTests
        }
        "test-security" {
            Start-SecurityTests
        }
        "build-web" {
            Build-Web
        }
        "build-android" {
            Build-Android
        }
        "build-ios" {
            Build-iOS
        }
        "build-all" {
            Build-All
        }
        "run-dev" {
            Start-Dev
        }
        "run-web" {
            Start-Web
        }
        "run-android" {
            Start-Android
        }
        "run-ios" {
            Start-iOS
        }
        "full-check" {
            Start-FullCheck
        }
        "help" {
            Show-Help
        }
        default {
            Write-Error "خيار غير صحيح: $Command"
            Show-Help
            exit 1
        }
    }
}

# تشغيل السكريبت
Main



