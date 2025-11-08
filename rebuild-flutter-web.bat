@echo off
setlocal enabledelayedexpansion
REM Flutter Web Build Script for IDEC Mobile App (Windows)
REM This script rebuilds the Flutter Web application with proper configuration
REM Automatically extracts and updates version from pubspec.yaml

echo 🚀 Starting Flutter Web rebuild for IDEC Mobile App...

REM Navigate to mobile app directory (script is already in mobile-app)
cd /d "%~dp0"

REM Extract version from pubspec.yaml FIRST (before build)
echo 📋 Extracting version from pubspec.yaml...
set VERSION=
for /f "tokens=2 delims=: " %%a in ('findstr /c:"version:" pubspec.yaml') do (
    set VERSION_RAW=%%a
    REM Remove any trailing spaces or build number (e.g., "2.0.3+1" becomes "2.0.3")
    for /f "tokens=1 delims=+" %%b in ("!VERSION_RAW!") do set VERSION=%%b
)

REM Trim whitespace from version
set VERSION=!VERSION: =!
echo 📦 Extracted Version: !VERSION!

if "!VERSION!"=="" (
    echo ❌ ERROR: Could not extract version from pubspec.yaml!
    exit /b 1
)

REM Generate build timestamp and service worker version (guarantees cache busting)
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMddHHmmss"') do set BUILD_TIMESTAMP=%%i
if "!BUILD_TIMESTAMP!"=="" (
    echo ⚠️  Warning: Failed to generate build timestamp via PowerShell, using fallback.
    set BUILD_TIMESTAMP=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
    set BUILD_TIMESTAMP=!BUILD_TIMESTAMP: =0!
)
set SW_VERSION=!VERSION!-!BUILD_TIMESTAMP!
echo 🕒 Build timestamp: !BUILD_TIMESTAMP!
echo 🛰️ Service Worker Version: !SW_VERSION!

REM Update source files in web\ directory BEFORE building (so they are correct)
echo 🔄 Updating source files in web\ directory (before build)...
if exist "web\index.html" (
    echo 📝 Updating web\index.html...
    set "PS_SCRIPT=%TEMP%\update_web_source_!RANDOM!.ps1"
    > "!PS_SCRIPT!" (
        echo $version = '%VERSION%'
        echo $swVersion = '%SW_VERSION%'
        echo $indexFile = 'web\index.html'
        echo $manifestFile = 'web\manifest.json'
        echo $configFile = 'web\flutter_web_config.js'
        echo.
        echo Write-Host '🔄 Updating source files with version:' $version
        echo.
        echo if ^(Test-Path $indexFile^) {
        echo     Write-Host '📝 Updating web\index.html...'
        echo     $content = [System.IO.File]::ReadAllText($indexFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = $content -replace "const APP_VERSION = '[^']+'", "const APP_VERSION = '$version'"
        echo     $content = $content -replace 'src=\"flutter_web_config\.js\?v=[0-9.]+', "src=`"flutter_web_config.js?v=$version"
        echo     $content = $content -replace 'src=\"flutter_bootstrap\.js\?v=[0-9.]+', "src=`"flutter_bootstrap.js?v=$version"
        echo     $content = $content -replace 'VERSION_PARAM = `\?v=[0-9.]+', "VERSION_PARAM = `?v=$version"
        echo     $content = $content -replace '\?v=[0-9.]+', "?v=$version"
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $indexFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated web\index.html'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in web\index.html'
        echo     }
        echo } else {
        echo     Write-Host '⚠️  File not found: ' + $indexFile
        echo }
        echo.
        echo if ^(Test-Path $manifestFile^) {
        echo     Write-Host '📝 Updating web\manifest.json...'
        echo     $content = [System.IO.File]::ReadAllText($manifestFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = $content -replace '\"version\":\s*\"[^\"]+\"', "`"version`": `"$version`""
        echo     $content = $content -replace '\"start_url\":\s*\"\/\?v=[^\"]+\"', "`"start_url`": `"/?v=$version`""
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $manifestFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated web\manifest.json'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in web\manifest.json'
        echo     }
        echo } else {
        echo     Write-Host '⚠️  File not found: ' + $manifestFile
        echo }
        echo.
        echo if ^(Test-Path $configFile^) {
        echo     Write-Host '📝 Updating web\flutter_web_config.js...'
        echo     $content = [System.IO.File]::ReadAllText($configFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = [System.Text.RegularExpressions.Regex]::Replace^($content, "serviceWorkerVersion:\s*(['""])([^'""]*)\1", "serviceWorkerVersion: '$swVersion'"^)
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $configFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated web\flutter_web_config.js'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in web\flutter_web_config.js'
        echo     }
        echo } else {
        echo     Write-Host '⚠️  File not found: ' + $configFile
        echo }
    )
    call powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_SCRIPT!"
    if exist "!PS_SCRIPT!" del "!PS_SCRIPT!" >nul 2>&1
)

REM Clean previous build
echo 🧹 Cleaning previous build...
call flutter clean
set CLEAN_RESULT=%errorlevel%
if %CLEAN_RESULT% neq 0 (
    echo ⚠️  Warning: flutter clean had issues, continuing anyway...
)
if exist build\web (
    echo Removing old build\web directory...
    rmdir /s /q build\web
)

REM Get dependencies
echo.
echo 📦 Getting Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ ERROR: Failed to get Flutter dependencies!
    exit /b 1
)

REM Build Flutter Web with HTML renderer (will copy updated files from web\ to build\web)
echo.
echo ========================================
echo 🔨 Building Flutter Web Application...
echo ========================================
echo This may take several minutes, please wait...
echo.
echo Starting build command...
call flutter build web --release --base-href /
set BUILD_RESULT=%errorlevel%
echo.
echo Build command completed with exit code: %BUILD_RESULT%
echo.

REM Check if build was successful
if %BUILD_RESULT% equ 0 (
    echo ========================================
    echo ✅ Flutter Web build completed successfully!
    echo ========================================
    
    REM Note: Files in build\web should already have correct version (copied from updated web\ files)
    REM But we'll update them again to be sure (in case Flutter modified them)
    REM Check if build files exist
    if not exist "build\web\index.html" (
        echo ❌ ERROR: build\web\index.html not found!
        exit /b 1
    )
    
    if not exist "build\web\manifest.json" (
        echo ❌ ERROR: build\web\manifest.json not found!
        exit /b 1
    )
    
    REM Create temporary PowerShell script to update build files (as backup, in case Flutter modified them)
    echo 🔄 Updating build files (ensuring correct version)...
    set "PS_SCRIPT=%TEMP%\update_version_!RANDOM!.ps1"
    > "!PS_SCRIPT!" (
        echo $version = '%VERSION%'
        echo $swVersion = '%SW_VERSION%'
        echo $indexFile = 'build\web\index.html'
        echo $manifestFile = 'build\web\manifest.json'
        echo $configFile = 'build\web\flutter_web_config.js'
        echo $bootstrapFile = 'build\web\flutter_bootstrap.js'
        echo $serviceWorkerFile = 'build\web\flutter_service_worker.js'
        echo.
        echo Write-Host '🔄 Updating files with version:' $version
        echo.
        echo if ^(Test-Path $indexFile^) {
        echo     Write-Host '📝 Updating index.html...'
        echo     $content = [System.IO.File]::ReadAllText($indexFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = $content -replace "const APP_VERSION = '[^']+'", "const APP_VERSION = '$version'"
        echo     $content = $content -replace 'src=\"flutter_web_config\.js\?v=[0-9.]+', "src=`"flutter_web_config.js?v=$version"
        echo     $content = $content -replace 'src=\"flutter_bootstrap\.js\?v=[0-9.]+', "src=`"flutter_bootstrap.js?v=$version"
        echo     $content = $content -replace 'VERSION_PARAM = `\?v=[0-9.]+', "VERSION_PARAM = `?v=$version"
        echo     $content = $content -replace '\?v=[0-9.]+', "?v=$version"
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $indexFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated index.html'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in index.html'
        echo     }
        echo } else {
        echo     Write-Host '❌ File not found: ' + $indexFile
        echo }
        echo.
        echo if ^(Test-Path $manifestFile^) {
        echo     Write-Host '📝 Updating manifest.json...'
        echo     $content = [System.IO.File]::ReadAllText($manifestFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = $content -replace '\"version\":\s*\"[^\"]+\"', "`"version`": `"$version`""
        echo     $content = $content -replace '\"start_url\":\s*\"\/\?v=[^\"]+\"', "`"start_url`": `"/?v=$version`""
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $manifestFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated manifest.json'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in manifest.json'
        echo     }
        echo } else {
        echo     Write-Host '❌ File not found: ' + $manifestFile
        echo }
        echo.
        echo if ^(Test-Path $configFile^) {
        echo     Write-Host '📝 Updating flutter_web_config.js...'
        echo     $content = [System.IO.File]::ReadAllText($configFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = [System.Text.RegularExpressions.Regex]::Replace^($content, "serviceWorkerVersion:\s*(['""])([^'""]*)\1", "serviceWorkerVersion: '$swVersion'"^)
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $configFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated flutter_web_config.js'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in flutter_web_config.js'
        echo     }
        echo } else {
        echo     Write-Host '❌ File not found: ' + $configFile
        echo }
        echo.
        echo if ^(Test-Path $bootstrapFile^) {
        echo     Write-Host '📝 Updating flutter_bootstrap.js service worker version...'
        echo     $content = [System.IO.File]::ReadAllText($bootstrapFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = [System.Text.RegularExpressions.Regex]::Replace^($content, "serviceWorkerVersion:\s*(['""])([^'""]*)\1", "serviceWorkerVersion: '$swVersion'"^)
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $bootstrapFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated flutter_bootstrap.js'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in flutter_bootstrap.js'
        echo     }
        echo } else {
        echo     Write-Host '❌ File not found: ' + $bootstrapFile
        echo }
        echo.
        echo if ^(Test-Path $serviceWorkerFile^) {
        echo     Write-Host '📝 Updating flutter_service_worker.js cache names...'
        echo     $content = [System.IO.File]::ReadAllText($serviceWorkerFile, [System.Text.Encoding]::UTF8^)
        echo     $oldContent = $content
        echo     $content = [System.Text.RegularExpressions.Regex]::Replace^($content, "const MANIFEST = 'flutter-app-manifest[^']*';", "const MANIFEST = 'flutter-app-manifest-$swVersion';"^)
        echo     $content = [System.Text.RegularExpressions.Regex]::Replace^($content, "const TEMP = 'flutter-temp-cache[^']*';", "const TEMP = 'flutter-temp-cache-$swVersion';"^)
        echo     $content = [System.Text.RegularExpressions.Regex]::Replace^($content, "const CACHE_NAME = 'flutter-app-cache[^']*';", "const CACHE_NAME = 'flutter-app-cache-$swVersion';"^)
        echo     if ^($content -ne $oldContent^) {
        echo         [System.IO.File]::WriteAllText((Resolve-Path $serviceWorkerFile^), $content, [System.Text.Encoding]::UTF8^)
        echo         Write-Host '✅ Updated flutter_service_worker.js'
        echo     } else {
        echo         Write-Host '⚠️  No changes needed in flutter_service_worker.js'
        echo     }
        echo } else {
        echo     Write-Host '❌ File not found: ' + $serviceWorkerFile
        echo }
    )
    
    REM Execute PowerShell script
    echo 🔄 Updating version in files...
    call powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_SCRIPT!"
    if %errorlevel% neq 0 (
        echo ❌ ERROR: Failed to update version in files!
        if exist "!PS_SCRIPT!" del "!PS_SCRIPT!" >nul 2>&1
        exit /b 1
    )
    
    REM Clean up temporary script
    if exist "!PS_SCRIPT!" del "!PS_SCRIPT!" >nul 2>&1
    
    REM Copy simplified configuration files (if they exist)
    if exist web\flutter_web_config_simple.js (
        echo 📋 Copying simplified configuration files...
        copy /Y web\flutter_web_config_simple.js build\web\flutter_web_config.js >nul
    )
    if exist web\index_simple.html (
        echo 📋 Copying simplified index.html...
        copy /Y web\index_simple.html build\web\index.html >nul
        REM Re-run update script for copied file
        set "PS_SCRIPT=%TEMP%\update_index_copy_!RANDOM!.ps1"
        set "PS_SCRIPT=%TEMP%\update_index_copy_!RANDOM!.ps1"
        > "!PS_SCRIPT!" (
            echo $version = '%VERSION%'
            echo $indexFile = 'build\web\index.html'
            echo if ^(Test-Path $indexFile^) {
            echo     Write-Host '📝 Updating copied index.html...'
            echo     $content = [System.IO.File]::ReadAllText($indexFile, [System.Text.Encoding]::UTF8^)
            echo     $content = $content -replace "const APP_VERSION = '[^']+'", "const APP_VERSION = '$version'"
            echo     $content = $content -replace 'src=\"flutter_web_config\.js\?v=[0-9.]+', "src=`"flutter_web_config.js?v=$version"
            echo     $content = $content -replace 'src=\"flutter_bootstrap\.js\?v=[0-9.]+', "src=`"flutter_bootstrap.js?v=$version"
            echo     $content = $content -replace 'VERSION_PARAM = `\?v=[0-9.]+', "VERSION_PARAM = `?v=$version"
            echo     $content = $content -replace '\?v=[0-9.]+', "?v=$version"
            echo     [System.IO.File]::WriteAllText((Resolve-Path $indexFile^), $content, [System.Text.Encoding]::UTF8^)
            echo     Write-Host '✅ Updated index.html (copied)'
            echo }
        )
        call powershell -NoProfile -ExecutionPolicy Bypass -File "!PS_SCRIPT!"
        if exist "!PS_SCRIPT!" del "!PS_SCRIPT!" >nul 2>&1
    )
    
    REM Verify the updates
    echo.
    echo 🔍 Verifying updates...
    findstr /C:"!VERSION!" build\web\index.html >nul
    if %errorlevel% equ 0 (
        echo ✅ Version !VERSION! found in index.html
    ) else (
        echo ⚠️  Warning: Version !VERSION! not found in index.html
    )
    
    findstr /C:"!VERSION!" build\web\manifest.json >nul
    if %errorlevel% equ 0 (
        echo ✅ Version !VERSION! found in manifest.json
    ) else (
        echo ⚠️  Warning: Version !VERSION! not found in manifest.json
    )

    findstr /C:"!SW_VERSION!" build\web\flutter_bootstrap.js >nul
    if %errorlevel% equ 0 (
        echo ✅ Service worker version !SW_VERSION! found in flutter_bootstrap.js
    ) else (
        echo ⚠️  Warning: Service worker version !SW_VERSION! not found in flutter_bootstrap.js
    )

    findstr /C:"!SW_VERSION!" build\web\flutter_service_worker.js >nul
    if %errorlevel% equ 0 (
        echo ✅ Cache version !SW_VERSION! found in flutter_service_worker.js
    ) else (
        echo ⚠️  Warning: Cache version !SW_VERSION! not found in flutter_service_worker.js
    )
    
    echo.
    echo 🎉 Flutter Web application is ready for deployment!
    echo 📁 Build output: %CD%\\build\\web
    echo 🌐 Deploy the contents of build\web to your web server
    echo 📦 Version: !VERSION!
    echo 🛰️ Service Worker Version: !SW_VERSION!
    echo.
    
) else (
    echo.
    echo ❌ Flutter Web build failed with error code: %BUILD_RESULT%
    echo Please check the error messages above.
    exit /b 1
)

echo 🏁 Build process completed!
pause
endlocal