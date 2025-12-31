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
    
    # Extract version from pubspec.yaml
    echo "📋 Extracting version from pubspec.yaml..."
    VERSION=$(grep -E "^version:" pubspec.yaml | sed -E 's/^version: //' | tr -d ' ')
    echo "📦 Version: $VERSION"
    
    # Update version in index.html
    echo "🔄 Updating version in index.html..."
    if [ -f "build/web/index.html" ]; then
        sed -i.bak "s/2\.0\.2/$VERSION/g" build/web/index.html
        rm -f build/web/index.html.bak
    fi
    
    # Update version in manifest.json
    echo "🔄 Updating version in manifest.json..."
    if [ -f "build/web/manifest.json" ]; then
        sed -i.bak "s/\"version\": \"[^\"]\+\"/\"version\": \"$VERSION\"/g" build/web/manifest.json
        sed -i.bak "s/\"start_url\": \"\/?v=[^\"]\+\"/\"start_url\": \"\/?v=$VERSION\"/g" build/web/manifest.json
        rm -f build/web/manifest.json.bak
    fi
    
    # Copy simplified configuration files (if they exist)
    if [ -f "web/flutter_web_config_simple.js" ]; then
        echo "📋 Copying simplified configuration files..."
        cp web/flutter_web_config_simple.js build/web/flutter_web_config.js
    fi
    if [ -f "web/index_simple.html" ]; then
        cp web/index_simple.html build/web/index.html
        # Update version in copied index.html
        sed -i.bak "s/2\.0\.2/$VERSION/g" build/web/index.html
        rm -f build/web/index.html.bak
    fi
    
    # Set proper permissions
    chmod -R 755 build/web
    
    echo "🎉 Flutter Web application is ready for deployment!"
    echo "📁 Build output: mobile-app/build/web"
    echo "🌐 Deploy the contents of build/web to your web server"
    echo "📦 Version: $VERSION"
    
else
    echo "❌ Flutter Web build failed!"
    exit 1
fi

echo "🏁 Build process completed!"




