# إصلاح شامل لجميع ملفات المصادقة
Write-Host "🔧 بدء الإصلاح الشامل للملفات..."

# قائمة الملفات التي تحتاج إصلاح
$files = @(
    "lib/features/auth/presentation/login_screen.dart",
    "lib/features/auth/presentation/otp_verification_screen.dart", 
    "lib/features/auth/presentation/register_screen.dart",
    "lib/features/auth/presentation/reset_password_screen.dart",
    "lib/features/profile/presentation/screens/profile_main_screen.dart",
    "lib/features/language/presentation/language_selection_screen.dart",
    "lib/shared/services/verification_notification_service.dart"
)

# إصلاح كل ملف
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "🔧 إصلاح $file..."
    
        # قراءة محتوى الملف
        $content = Get-Content $file -Raw
    
        # استبدال enhancedAuthProvider بـ simpleAuthProvider
        $content = $content -replace 'enhancedAuthProvider', 'simpleAuthProvider'
    
        # استبدال الاستيرادات
        $content = $content -replace '../../../providers/enhanced_auth_provider.dart', '../../../services/simple_auth_service.dart'
        $content = $content -replace '../../providers/enhanced_auth_provider.dart', '../../services/simple_auth_service.dart'
    
        # كتابة المحتوى المحدث
        Set-Content $file $content
    
        Write-Host "✅ تم إصلاح $file"
    }
    else {
        Write-Host "⚠️ الملف $file غير موجود"
    }
}

Write-Host "🎉 تم الانتهاء من الإصلاح الشامل!"




