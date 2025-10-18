@echo off
REM Flutter Web Build Script for IDEC Mobile App (Windows)
REM This script rebuilds the Flutter Web application with proper configuration

echo 🚀 Starting Flutter Web rebuild for IDEC Mobile App...

REM Navigate to mobile app directory
cd mobile-app

REM Clean previous build
echo 🧹 Cleaning previous build...
flutter clean
if exist build\web rmdir /s /q build\web

REM Get dependencies
echo 📦 Getting Flutter dependencies...
flutter pub get

REM Build Flutter Web with HTML renderer
echo 🔨 Building Flutter Web with HTML renderer...
flutter build web --web-renderer html --release --dart-define=FLUTTER_WEB_USE_SKIA=false --dart-define=FLUTTER_WEB_CANVASKIT_URL=./canvaskit/ --base-href /

REM Check if build was successful
if %errorlevel% equ 0 (
    echo ✅ Flutter Web build completed successfully!
    
    REM Copy simplified configuration files
    echo 📋 Copying simplified configuration files...
    copy web\flutter_web_config_simple.js build\web\flutter_web_config.js
    copy web\index_simple.html build\web\index.html
    
    echo 🎉 Flutter Web application is ready for deployment!
    echo 📁 Build output: mobile-app\build\web
    echo 🌐 Deploy the contents of build\web to your web server
    
) else (
    echo ❌ Flutter Web build failed!
    exit /b 1
)

echo 🏁 Build process completed!
pause




