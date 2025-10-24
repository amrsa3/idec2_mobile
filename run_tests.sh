#!/bin/bash

# سكريبت التشغيل والاختبار للنظام المحسن للمصادقة
# Enhanced Auth System - Run and Test Script

echo "🚀 بدء تشغيل واختبار النظام المحسن للمصادقة"
echo "================================================"

# الألوان للرسائل
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة طباعة الرسائل الملونة
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

# التحقق من وجود Flutter
check_flutter() {
    print_info "التحقق من وجود Flutter..."
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter غير مثبت. يرجى تثبيت Flutter أولاً."
        exit 1
    fi
    print_success "Flutter موجود"
}

# التحقق من وجود Dart
check_dart() {
    print_info "التحقق من وجود Dart..."
    if ! command -v dart &> /dev/null; then
        print_error "Dart غير مثبت. يرجى تثبيت Dart أولاً."
        exit 1
    fi
    print_success "Dart موجود"
}

# تنظيف المشروع
clean_project() {
    print_info "تنظيف المشروع..."
    flutter clean
    print_success "تم تنظيف المشروع"
}

# تثبيت التبعيات
install_dependencies() {
    print_info "تثبيت التبعيات..."
    flutter pub get
    if [ $? -eq 0 ]; then
        print_success "تم تثبيت التبعيات بنجاح"
    else
        print_error "فشل في تثبيت التبعيات"
        exit 1
    fi
}

# تشغيل تحليل الكود
run_analysis() {
    print_info "تشغيل تحليل الكود..."
    flutter analyze
    if [ $? -eq 0 ]; then
        print_success "تحليل الكود مكتمل بدون أخطاء"
    else
        print_warning "تم العثور على تحذيرات في الكود"
    fi
}

# تشغيل الاختبارات
run_tests() {
    print_info "تشغيل الاختبارات..."
    flutter test
    if [ $? -eq 0 ]; then
        print_success "جميع الاختبارات نجحت"
    else
        print_error "بعض الاختبارات فشلت"
        exit 1
    fi
}

# تشغيل اختبارات الوحدة
run_unit_tests() {
    print_info "تشغيل اختبارات الوحدة..."
    flutter test test/unit/
    if [ $? -eq 0 ]; then
        print_success "اختبارات الوحدة نجحت"
    else
        print_error "اختبارات الوحدة فشلت"
        exit 1
    fi
}

# تشغيل اختبارات التكامل
run_integration_tests() {
    print_info "تشغيل اختبارات التكامل..."
    flutter test test/integration/
    if [ $? -eq 0 ]; then
        print_success "اختبارات التكامل نجحت"
    else
        print_error "اختبارات التكامل فشلت"
        exit 1
    fi
}

# تشغيل اختبارات الأداء
run_performance_tests() {
    print_info "تشغيل اختبارات الأداء..."
    flutter test test/performance/
    if [ $? -eq 0 ]; then
        print_success "اختبارات الأداء نجحت"
    else
        print_error "اختبارات الأداء فشلت"
        exit 1
    fi
}

# تشغيل اختبارات الأمان
run_security_tests() {
    print_info "تشغيل اختبارات الأمان..."
    flutter test test/security/
    if [ $? -eq 0 ]; then
        print_success "اختبارات الأمان نجحت"
    else
        print_error "اختبارات الأمان فشلت"
        exit 1
    fi
}

# بناء التطبيق للويب
build_web() {
    print_info "بناء التطبيق للويب..."
    flutter build web
    if [ $? -eq 0 ]; then
        print_success "تم بناء التطبيق للويب بنجاح"
    else
        print_error "فشل في بناء التطبيق للويب"
        exit 1
    fi
}

# بناء التطبيق للأندرويد
build_android() {
    print_info "بناء التطبيق للأندرويد..."
    flutter build apk
    if [ $? -eq 0 ]; then
        print_success "تم بناء التطبيق للأندرويد بنجاح"
    else
        print_error "فشل في بناء التطبيق للأندرويد"
        exit 1
    fi
}

# بناء التطبيق لـ iOS
build_ios() {
    print_info "بناء التطبيق لـ iOS..."
    flutter build ios
    if [ $? -eq 0 ]; then
        print_success "تم بناء التطبيق لـ iOS بنجاح"
    else
        print_error "فشل في بناء التطبيق لـ iOS"
        exit 1
    fi
}

# تشغيل التطبيق في وضع التطوير
run_dev() {
    print_info "تشغيل التطبيق في وضع التطوير..."
    flutter run
}

# تشغيل التطبيق للويب
run_web() {
    print_info "تشغيل التطبيق للويب..."
    flutter run -d web-server --web-port 8080
}

# تشغيل التطبيق للأندرويد
run_android() {
    print_info "تشغيل التطبيق للأندرويد..."
    flutter run -d android
}

# تشغيل التطبيق لـ iOS
run_ios() {
    print_info "تشغيل التطبيق لـ iOS..."
    flutter run -d ios
}

# تشغيل جميع الاختبارات
run_all_tests() {
    print_info "تشغيل جميع الاختبارات..."
    run_unit_tests
    run_integration_tests
    run_performance_tests
    run_security_tests
    print_success "جميع الاختبارات مكتملة"
}

# بناء جميع المنصات
build_all() {
    print_info "بناء التطبيق لجميع المنصات..."
    build_web
    build_android
    build_ios
    print_success "تم بناء التطبيق لجميع المنصات"
}

# إعداد المشروع
setup_project() {
    print_info "إعداد المشروع..."
    check_flutter
    check_dart
    clean_project
    install_dependencies
    print_success "تم إعداد المشروع بنجاح"
}

# تشغيل التحقق الشامل
run_full_check() {
    print_info "تشغيل التحقق الشامل..."
    setup_project
    run_analysis
    run_all_tests
    print_success "التحقق الشامل مكتمل"
}

# عرض المساعدة
show_help() {
    echo "استخدام: $0 [الخيار]"
    echo ""
    echo "الخيارات المتاحة:"
    echo "  setup          - إعداد المشروع"
    echo "  clean          - تنظيف المشروع"
    echo "  install        - تثبيت التبعيات"
    echo "  analyze        - تحليل الكود"
    echo "  test           - تشغيل جميع الاختبارات"
    echo "  test-unit      - اختبارات الوحدة فقط"
    echo "  test-integration - اختبارات التكامل فقط"
    echo "  test-performance - اختبارات الأداء فقط"
    echo "  test-security  - اختبارات الأمان فقط"
    echo "  build-web      - بناء التطبيق للويب"
    echo "  build-android  - بناء التطبيق للأندرويد"
    echo "  build-ios      - بناء التطبيق لـ iOS"
    echo "  build-all      - بناء التطبيق لجميع المنصات"
    echo "  run-dev        - تشغيل التطبيق في وضع التطوير"
    echo "  run-web        - تشغيل التطبيق للويب"
    echo "  run-android    - تشغيل التطبيق للأندرويد"
    echo "  run-ios        - تشغيل التطبيق لـ iOS"
    echo "  full-check     - التحقق الشامل"
    echo "  help           - عرض هذه المساعدة"
}

# المعالجة الرئيسية
main() {
    case "$1" in
        "setup")
            setup_project
            ;;
        "clean")
            clean_project
            ;;
        "install")
            install_dependencies
            ;;
        "analyze")
            run_analysis
            ;;
        "test")
            run_all_tests
            ;;
        "test-unit")
            run_unit_tests
            ;;
        "test-integration")
            run_integration_tests
            ;;
        "test-performance")
            run_performance_tests
            ;;
        "test-security")
            run_security_tests
            ;;
        "build-web")
            build_web
            ;;
        "build-android")
            build_android
            ;;
        "build-ios")
            build_ios
            ;;
        "build-all")
            build_all
            ;;
        "run-dev")
            run_dev
            ;;
        "run-web")
            run_web
            ;;
        "run-android")
            run_android
            ;;
        "run-ios")
            run_ios
            ;;
        "full-check")
            run_full_check
            ;;
        "help"|"--help"|"-h"|"")
            show_help
            ;;
        *)
            print_error "خيار غير صحيح: $1"
            show_help
            exit 1
            ;;
    esac
}

# تشغيل السكريبت
main "$@"



