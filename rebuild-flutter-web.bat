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
    
    REM Extract version from pubspec.yaml
    echo 📋 Extracting version from pubspec.yaml...
    for /f "tokens=2 delims=: " %%a in ('findstr /c:"version:" pubspec.yaml') do set VERSION=%%a
    echo 📦 Version: %VERSION%
    
    REM Update version in index.html
    echo 🔄 Updating version in index.html...
    powershell -Command "(Get-Content build\web\index.html) -replace '2\.0\.2', '%VERSION%' | Set-Content build\web\index.html"
    
    REM Update version in manifest.json
    echo 🔄 Updating version in manifest.json...
    powershell -Command "(Get-Content build\web\manifest.json) -replace '\"version\": \"[^\"]+\"', '\"version\": \"%VERSION%\"' | Set-Content build\web\manifest.json"
    powershell -Command "(Get-Content build\web\manifest.json) -replace '\"start_url\": \"/\\?v=[^\"]+\"', '\"start_url\": \"/?v=%VERSION%\"' | Set-Content build\web\manifest.json"
    
    REM Copy simplified configuration files (if they exist)
    if exist web\flutter_web_config_simple.js (
        echo 📋 Copying simplified configuration files...
        copy web\flutter_web_config_simple.js build\web\flutter_web_config.js
    )
    if exist web\index_simple.html (
        copy web\index_simple.html build\web\index.html
        REM Update version in copied index.html
        powershell -Command "(Get-Content build\web\index.html) -replace '2\.0\.2', '%VERSION%' | Set-Content build\web\index.html"
    )
    
    echo 🎉 Flutter Web application is ready for deployment!
    echo 📁 Build output: mobile-app\build\web
    echo 🌐 Deploy the contents of build\web to your web server
    echo 📦 Version: %VERSION%
    
) else (
    echo ❌ Flutter Web build failed!
    exit /b 1
)

echo 🏁 Build process completed!
pause




