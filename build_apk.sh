#!/bin/bash

echo "🕌 Prayer Times App - APK Builder"
echo "=================================="

# Check if Flutter is available
if command -v flutter &> /dev/null; then
    echo "✅ Flutter found"
    flutter --version
else
    echo "❌ Flutter not found in PATH"
    echo "📱 Alternative: Use Android Studio or GitHub Actions"
    echo ""
    echo "🔧 Quick Setup Options:"
    echo "1. Install Flutter: https://flutter.dev/docs/get-started/install"
    echo "2. Use Android Studio: File → Open → Select this folder"
    echo "3. Use GitHub Actions: Push to GitHub and build automatically"
    echo "4. Use Codemagic: Upload to codemagic.io"
    exit 1
fi

echo ""
echo "🔨 Building APK..."

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK
echo "🏗️ Building release APK..."
flutter build apk --release

# Check if APK was created
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo ""
    echo "✅ APK built successfully!"
    echo "📱 APK Location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "📲 To install on your phone:"
    echo "1. Transfer the APK file to your Android device"
    echo "2. Enable 'Unknown Sources' in Android settings"
    echo "3. Tap the APK file to install"
    echo ""
    echo "🎉 App Features:"
    echo "• Prayer Times with countdown"
    echo "• Qibla Compass"
    echo "• Hadees Collection"
    echo "• Digital Tasbeeh"
    echo "• Islamic Calendar"
    echo "• Duas Collection"
    echo "• Settings & Notifications"
else
    echo "❌ APK build failed"
    echo "🔧 Try using Android Studio or GitHub Actions instead"
fi




