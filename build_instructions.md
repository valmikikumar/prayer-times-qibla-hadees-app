# How to Build APK for Prayer Times App

## Quick Solutions to Get APK File:

### 1. **Use GitHub Actions (Easiest)**
1. Push this code to GitHub
2. GitHub Actions will automatically build the APK
3. Download the APK from the Actions tab

### 2. **Use Codemagic (Cloud Build)**
1. Sign up at codemagic.io
2. Connect your GitHub repository
3. Use the provided `codemagic.yaml` file
4. Build will run in the cloud and provide APK

### 3. **Use Flutter Web (Alternative)**
```bash
# If you have Flutter installed
flutter build web
# Then use PWA to install on mobile
```

### 4. **Use Android Studio**
1. Open the project in Android Studio
2. Build → Build Bundle(s) / APK(s) → Build APK(s)
3. APK will be generated in `build/app/outputs/flutter-apk/`

### 5. **Use Online Flutter Builders**
- **AppCircle**: appcircle.io
- **Bitrise**: bitrise.io
- **GitHub Actions**: (Recommended)

## Manual Flutter Installation (if needed):

### For macOS:
```bash
# Download Flutter
curl -o flutter_macos.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.16.0-stable.zip

# Extract
unzip flutter_macos.zip

# Add to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# Verify
flutter doctor

# Build APK
flutter build apk --release
```

### For Windows:
```bash
# Download Flutter for Windows
# Extract to C:\flutter
# Add C:\flutter\bin to PATH
# Run: flutter build apk --release
```

### For Linux:
```bash
# Download Flutter for Linux
# Extract to ~/flutter
# Add to PATH
# Run: flutter build apk --release
```

## APK Location:
After successful build, APK will be at:
`build/app/outputs/flutter-apk/app-release.apk`

## Install on Phone:
1. Enable "Unknown Sources" in Android settings
2. Transfer APK to phone
3. Install the APK file
4. Launch the app

## App Features:
- ✅ Prayer Times with countdown
- ✅ Qibla Compass
- ✅ Hadees Collection
- ✅ Digital Tasbeeh
- ✅ Islamic Calendar
- ✅ Duas Collection
- ✅ Settings & Notifications
- ✅ AdMob Integration
- ✅ Dark/Light Mode




