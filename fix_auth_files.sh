#!/bin/bash

# إصلاح شامل لجميع ملفات المصادقة
echo "🔧 بدء الإصلاح الشامل للملفات..."

# قائمة الملفات التي تحتاج إصلاح
FILES=(
  "lib/features/auth/presentation/login_screen.dart"
  "lib/features/auth/presentation/otp_verification_screen.dart"
  "lib/features/auth/presentation/register_screen.dart"
  "lib/features/auth/presentation/reset_password_screen.dart"
  "lib/features/profile/presentation/screens/profile_main_screen.dart"
  "lib/features/language/presentation/language_selection_screen.dart"
  "lib/shared/services/verification_notification_service.dart"
)

# إصلاح كل ملف
for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "🔧 إصلاح $file..."
    
    # استبدال enhancedAuthProvider بـ simpleAuthProvider
    sed -i 's/enhancedAuthProvider/simpleAuthProvider/g' "$file"
    
    # استبدال الاستيرادات
    sed -i 's|../../../providers/enhanced_auth_provider.dart|../../../services/simple_auth_service.dart|g' "$file"
    sed -i 's|../../providers/enhanced_auth_provider.dart|../../services/simple_auth_service.dart|g' "$file"
    sed -i 's|../../../providers/enhanced_auth_provider.dart|../../../services/simple_auth_service.dart|g' "$file"
    
    echo "✅ تم إصلاح $file"
  else
    echo "⚠️ الملف $file غير موجود"
  fi
done

echo "🎉 تم الانتهاء من الإصلاح الشامل!"



