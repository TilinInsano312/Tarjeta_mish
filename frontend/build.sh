#!/bin/bash
set -e

echo "🚀 Starting Flutter Web Build for Vercel..."

# Check if Flutter is installed, if not install it
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter..."
    git clone --depth 1 -b stable https://github.com/flutter/flutter.git /tmp/flutter
    export PATH="/tmp/flutter/bin:$PATH"
    flutter doctor
fi

# Update Flutter
echo "🔄 Updating Flutter..."
flutter pub global activate fvm

# Get dependencies
echo "📚 Getting dependencies..."
flutter pub get

# Build web
echo "🔨 Building Flutter web..."
flutter build web --release --web-renderer=html

echo "✅ Build completed successfully!"
