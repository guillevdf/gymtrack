# GymTrack Development Setup Guide

## Prerequisites

### Required Software
1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add to PATH

2. **Git**
   - For version control

3. **IDE** (choose one):
   - Android Studio (recommended for Android development)
   - Visual Studio Code with Flutter extension
   - IntelliJ IDEA

### Platform-Specific Requirements

#### For Android Development
- Android Studio
- Android SDK (API 21 or higher)
- Java JDK 8 or higher
- Android Emulator or physical device

#### For iOS Development (macOS only)
- Xcode 12.0 or higher
- CocoaPods (`sudo gem install cocoapods`)
- iOS Simulator or physical device
- Apple Developer account (for physical device testing)

#### For WearOS Development
- WearOS emulator or physical device
- Android Studio with Wear OS support

## Installation Steps

### 1. Clone the Repository
```bash
git clone https://github.com/guillevdf/gymtrack.git
cd gymtrack
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Verify Flutter Installation
```bash
flutter doctor
```
This will check your Flutter installation and show any issues.

### 4. Platform-Specific Setup

#### Android Setup
```bash
# Accept Android licenses
flutter doctor --android-licenses

# Check Android setup
flutter doctor
```

#### iOS Setup (macOS only)
```bash
# Install CocoaPods dependencies
cd ios
pod install
cd ..

# Check iOS setup
flutter doctor
```

## Running the Application

### Mobile Version (iOS/Android)

#### Run on Connected Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

#### Run on Emulator/Simulator
```bash
# Run on default device
flutter run
```

#### Development Mode with Hot Reload
```bash
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit
```

### WearOS Version

```bash
# Run WearOS version on connected device
flutter run -t lib/main_wear.dart

# Run on specific device
flutter run -t lib/main_wear.dart -d <device_id>
```

## Development Workflow

### 1. Making Changes
- Edit files in `lib/` directory
- Use hot reload (`r`) for quick UI changes
- Use hot restart (`R`) for state changes

### 2. Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models_test.dart

# Run tests with coverage
flutter test --coverage
```

### 3. Code Quality

#### Analyze Code
```bash
flutter analyze
```

#### Format Code
```bash
# Format all files
flutter format .

# Format specific file
flutter format lib/main.dart
```

### 4. Building for Release

#### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS
```bash
flutter build ios --release
# Then open Xcode to archive and submit
```

## Debugging

### Enable Debug Mode
```bash
flutter run --debug
```

### Debugging in IDE

#### VS Code
1. Set breakpoints in code
2. Press F5 or use Debug menu
3. Use Debug Console for logs

#### Android Studio
1. Set breakpoints in code
2. Click Debug button or Shift+F9
3. Use Debug panel for inspection

### Common Debug Commands
```bash
# Enable verbose logging
flutter run -v

# Clear build cache
flutter clean
flutter pub get

# Check for issues
flutter doctor -v
```

## Project Structure for Development

```
lib/
├── models/          # Add new data models here
├── services/        # Add business logic services
├── screens/         # Add new UI screens
│   └── wear/        # Wearable-specific screens
├── widgets/         # Reusable widgets (if needed)
├── main.dart        # Mobile app entry
└── main_wear.dart   # WearOS app entry

test/
└── *_test.dart      # Add tests matching lib/ structure

android/             # Android-specific code
ios/                 # iOS-specific code
```

## Common Issues and Solutions

### Issue: "Flutter command not found"
**Solution**: Add Flutter to your PATH
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

### Issue: "Android licenses not accepted"
**Solution**:
```bash
flutter doctor --android-licenses
```

### Issue: iOS build fails
**Solution**:
```bash
cd ios
pod repo update
pod install
cd ..
flutter clean
flutter run
```

### Issue: Dependencies not resolving
**Solution**:
```bash
flutter clean
flutter pub get
```

### Issue: Hot reload not working
**Solution**: Use hot restart (R) or full restart

## Development Tips

### 1. Use Flutter DevTools
```bash
# Run app first, then:
flutter pub global activate devtools
flutter pub global run devtools
```

### 2. Improve Build Performance
- Use `flutter run --profile` for performance testing
- Enable incremental builds
- Use `--no-sound-null-safety` if needed

### 3. Testing on Physical Devices

#### Android
1. Enable Developer Options on device
2. Enable USB Debugging
3. Connect via USB
4. Run `flutter devices` to verify

#### iOS
1. Connect device via USB
2. Trust computer on device
3. Select device in Xcode
4. Run `flutter run`

### 4. Code Organization
- Keep screens simple, extract widgets
- Use const constructors where possible
- Follow Flutter style guide
- Add comments for complex logic

## Continuous Integration

### GitHub Actions (Example)
```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk
```

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)

## Support

For issues or questions:
1. Check existing GitHub issues
2. Create new issue with details
3. Provide logs and error messages
4. Include device/platform information

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Run `flutter analyze` and `flutter test`
5. Submit pull request

Happy coding! 🚀
