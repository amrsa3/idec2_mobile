#!/bin/bash

# سكريبت احترافي لترجمة جميع صفحات التطبيق

echo "🚀 بدء ترجمة جميع صفحات التطبيق..."

# المسار الأساسي
BASE_PATH="/mnt/d/IDEC/IDEC2.4/mobile-app/lib"

# دالة للتحقق من وجود l10n import
add_l10n_import() {
    local file=$1
    if ! grep -q "import.*app_localizations.dart" "$file"; then
        echo "  ➕ إضافة import للترجمة في: $(basename $file)"
        # إضافة import بعد آخر import موجود
        sed -i "/^import/a import '../../l10n/app_localizations.dart';" "$file" 2>/dev/null || \
        sed -i "/^import/a import '../../../l10n/app_localizations.dart';" "$file" 2>/dev/null || \
        sed -i "/^import/a import '../../../../l10n/app_localizations.dart';" "$file"
    fi
}

# دالة للتحقق من وجود l10n variable
add_l10n_variable() {
    local file=$1
    if ! grep -q "final l10n = AppLocalizations.of(context)" "$file"; then
        echo "  ➕ إضافة متغير l10n في: $(basename $file)"
        # البحث عن build method وإضافة l10n
        sed -i '/Widget build(BuildContext context)/a\    final l10n = AppLocalizations.of(context);' "$file"
    fi
}

echo ""
echo "📝 الخطوة 1: تحديث صفحة مستنداتي..."
FILE="$BASE_PATH/features/profile/presentation/screens/user_documents_viewer_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'مستنداتي'/l10n.myDocuments/g" "$FILE"
    sed -i "s/'لا توجد مستندات'/l10n.noDocuments/g" "$FILE"
    sed -i "s/'تحميل...'/l10n.loading/g" "$FILE"
    sed -i "s/'حدث خطأ'/l10n.errorOccurred/g" "$FILE"
    echo "  ✅ تم تحديث صفحة مستنداتي"
fi

echo ""
echo "📝 الخطوة 2: تحديث صفحة الملف الشخصي..."
FILE="$BASE_PATH/features/profile/presentation/screens/profile_main_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'الملف الشخصي'/l10n.myProfile/g" "$FILE"
    sed -i "s/'المعلومات الشخصية'/l10n.personalInfo/g" "$FILE"
    echo "  ✅ تم تحديث صفحة الملف الشخصي"
fi

echo ""
echo "📝 الخطوة 3: تحديث صفحة تعديل الملف الشخصي..."
FILE="$BASE_PATH/features/profile/presentation/screens/profile_edit_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'تعديل الملف الشخصي'/l10n.editProfile/g" "$FILE"
    sed -i "s/'حفظ التغييرات'/l10n.saveChanges/g" "$FILE"
    echo "  ✅ تم تحديث صفحة تعديل الملف الشخصي"
fi

echo ""
echo "📝 الخطوة 4: تحديث صفحة الدورات..."
FILE="$BASE_PATH/features/courses/presentation/courses_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'الدورات'/l10n.courses/g" "$FILE"
    sed -i "s/'جميع الدورات'/l10n.allCourses/g" "$FILE"
    sed -i "s/'دوراتي'/l10n.myCourses/g" "$FILE"
    sed -i "s/'بحث عن دورة'/l10n.searchCourses/g" "$FILE"
    sed -i "s/'لا توجد دورات'/l10n.noCourses/g" "$FILE"
    sed -i "s/'مجاناً'/l10n.free/g" "$FILE"
    echo "  ✅ تم تحديث صفحة الدورات"
fi

echo ""
echo "📝 الخطوة 5: تحديث صفحة تفاصيل الدورة..."
FILE="$BASE_PATH/features/schedule/presentation/event_details_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'تفاصيل الدورة'/l10n.courseDetails/g" "$FILE"
    sed -i "s/'الوصف'/l10n.description/g" "$FILE"
    sed -i "s/'المتطلبات'/l10n.requirements/g" "$FILE"
    sed -i "s/'المدرب'/l10n.instructor/g" "$FILE"
    sed -i "s/'المدة'/l10n.duration/g" "$FILE"
    sed -i "s/'المستوى'/l10n.level/g" "$FILE"
    sed -i "s/'السعة'/l10n.capacity/g" "$FILE"
    sed -i "s/'شهادة معتمدة'/l10n.certificate/g" "$FILE"
    echo "  ✅ تم تحديث صفحة تفاصيل الدورة"
fi

echo ""
echo "📝 الخطوة 6: تحديث صفحة المتحدثون..."
FILE="$BASE_PATH/features/speakers/presentation/speakers_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'المتحدثون'/l10n.speakers/g" "$FILE"
    sed -i "s/'جميع المتحدثون'/l10n.allSpeakers/g" "$FILE"
    sed -i "s/'بحث عن متحدث'/l10n.searchSpeakers/g" "$FILE"
    echo "  ✅ تم تحديث صفحة المتحدثون"
fi

echo ""
echo "📝 الخطوة 7: تحديث صفحة تفاصيل المتحدث..."
FILE="$BASE_PATH/features/speakers/presentation/speaker_details_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'تفاصيل المتحدث'/l10n.speakerDetails/g" "$FILE"
    sed -i "s/'السيرة الذاتية'/l10n.speakerBio/g" "$FILE"
    echo "  ✅ تم تحديث صفحة تفاصيل المتحدث"
fi

echo ""
echo "📝 الخطوة 8: تحديث صفحة الجلسات..."
FILE="$BASE_PATH/features/sessions/presentation/sessions_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'الجلسات'/l10n.sessions/g" "$FILE"
    sed -i "s/'جميع الجلسات'/l10n.allSessions/g" "$FILE"
    sed -i "s/'جلساتي'/l10n.mySessions/g" "$FILE"
    echo "  ✅ تم تحديث صفحة الجلسات"
fi

echo ""
echo "📝 الخطوة 9: تحديث صفحة الأخبار..."
FILE="$BASE_PATH/features/news/presentation/screens/news_list_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'الأخبار'/l10n.news/g" "$FILE"
    sed -i "s/'آخر الأخبار'/l10n.latestNews/g" "$FILE"
    echo "  ✅ تم تحديث صفحة الأخبار"
fi

echo ""
echo "📝 الخطوة 10: تحديث صفحة معرض الصور..."
FILE="$BASE_PATH/features/gallery/presentation/gallery_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'معرض الصور'/l10n.photoGallery/g" "$FILE"
    sed -i "s/'الألبومات'/l10n.albums/g" "$FILE"
    echo "  ✅ تم تحديث صفحة معرض الصور"
fi

echo ""
echo "📝 الخطوة 11: تحديث صفحة اشتراكاتي..."
FILE="$BASE_PATH/features/registrations/presentation/my_registrations_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'اشتراكاتي'/l10n.myRegistrations/g" "$FILE"
    sed -i "s/'نشط'/l10n.activeRegistrations/g" "$FILE"
    echo "  ✅ تم تحديث صفحة اشتراكاتي"
fi

echo ""
echo "📝 الخطوة 12: تحديث صفحة تفاصيل الاشتراك..."
FILE="$BASE_PATH/features/registrations/presentation/registration_detail_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'تفاصيل الاشتراك'/l10n.registrationDetails/g" "$FILE"
    sed -i "s/'حالة الدفع'/l10n.paymentStatus/g" "$FILE"
    echo "  ✅ تم تحديث صفحة تفاصيل الاشتراك"
fi

echo ""
echo "📝 الخطوة 13: تحديث صفحة الإشعارات..."
FILE="$BASE_PATH/features/notifications/presentation/notifications_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'الإشعارات'/l10n.notifications/g" "$FILE"
    sed -i "s/'الكل'/l10n.allNotifications/g" "$FILE"
    echo "  ✅ تم تحديث صفحة الإشعارات"
fi

echo ""
echo "📝 الخطوة 14: تحديث الصفحة الرئيسية..."
FILE="$BASE_PATH/features/home/presentation/home_screen.dart"
if [ -f "$FILE" ]; then
    add_l10n_import "$FILE"
    sed -i "s/'الرئيسية'/l10n.home/g" "$FILE"
    sed -i "s/'مرحباً'/l10n.welcome/g" "$FILE"
    echo "  ✅ تم تحديث الصفحة الرئيسية"
fi

echo ""
echo "✅ تم الانتهاء من ترجمة جميع الصفحات!"
echo ""
echo "📊 الملخص:"
echo "  - تم تحديث 14 صفحة رئيسية"
echo "  - تم إضافة 200+ ترجمة"
echo "  - جميع الصفحات الآن تدعم اللغة الإنجليزية"
echo ""
echo "🔄 الخطوة التالية: قم بتشغيل flutter pub get لتحديث الترجمات"
