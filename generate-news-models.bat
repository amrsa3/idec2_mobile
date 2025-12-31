@echo off
echo ========================================
echo Generating News Models Files...
echo ========================================
cd /d "%~dp0"

echo.
echo Step 1: Running flutter pub get...
call flutter pub get
if errorlevel 1 (
    echo ERROR: flutter pub get failed!
    pause
    exit /b 1
)

echo.
echo Step 2: Running build_runner to generate freezed files...
echo This may take a few minutes...
call flutter pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo ERROR: build_runner failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! News model files generated.
echo ========================================
echo.
echo Now you can run the app with:
echo flutter run -d web-server --web-port 5600 --web-hostname 0.0.0.0 --dart-define=FIREBASE_WEB_VAPID_KEY=BLNkdbApNtiJ9JyXhWBcRufoZaq_yP7ayv-KebWfEMuhBvrtKgmMQF3Z-glAJFJlP4ITyrZwOnsXV_xp6PIHs-E
echo.
pause

