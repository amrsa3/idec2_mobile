#!/bin/bash

# Flutter Web Build Script for IDEC Mobile App
# This script rebuilds the Flutter Web application with proper configuration

echo "🚀 Starting Flutter Web rebuild for IDEC Mobile App..."

# Navigate to mobile app directory
cd mobile-app

# Clean previous build
echo "🧹 Cleaning previous build..."
flutter clean
rm -rf build/web

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Build Flutter Web with HTML renderer
echo "🔨 Building Flutter Web with HTML renderer..."
flutter build web \
  --web-renderer html \
  --release \
  --dart-define=FLUTTER_WEB_USE_SKIA=false \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=./canvaskit/ \
  --base-href /

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Flutter Web build completed successfully!"
    
    # Copy simplified configuration files
    echo "📋 Copying simplified configuration files..."
    cp web/flutter_web_config_simple.js build/web/flutter_web_config.js
    cp web/index_simple.html build/web/index.html
    
    # Set proper permissions
    chmod -R 755 build/web
    
    echo "🎉 Flutter Web application is ready for deployment!"
    echo "📁 Build output: mobile-app/build/web"
    echo "🌐 Deploy the contents of build/web to your web server"
    
else
    echo "❌ Flutter Web build failed!"
    exit 1
fi

echo "🏁 Build process completed!"


