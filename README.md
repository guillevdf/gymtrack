# GymTrack

Mobile application oriented to track gym training aiming for progressive overload target

## Features

- ✅ Create and manage workout routines
- ✅ Define exercises with type, sets, weight, and repetitions
- ✅ Track progressive overload by saving training stages per week
- ✅ Cross-platform support (iOS, Android)
- ✅ WearOS adapted interface for smartwatches
- ✅ WatchOS support (uses same interface as iOS with adaptations)

## Project Structure

```
lib/
├── models/              # Data models
│   ├── exercise_set.dart
│   ├── exercise.dart
│   ├── workout_routine.dart
│   └── training_stage.dart
├── services/            # Business logic and state management
│   ├── app_state.dart
│   └── storage_service.dart
├── screens/             # UI screens
│   ├── home_screen.dart
│   ├── create_routine_screen.dart
│   ├── routine_detail_screen.dart
│   ├── training_stage_screen.dart
│   └── wear/            # WearOS adapted screens
│       └── wear_home_screen.dart
├── main.dart            # Main entry point for mobile
└── main_wear.dart       # Entry point for WearOS
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode for iOS development
- WearOS device or emulator for watch testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/guillevdf/gymtrack.git
cd gymtrack
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:

For mobile (iOS/Android):
```bash
flutter run
```

For WearOS:
```bash
flutter run -t lib/main_wear.dart
```

## Features Explained

### Workout Routines
Create custom workout routines with multiple exercises. Each exercise can have:
- Name
- Type (e.g., Compound, Isolation)
- Multiple sets with weight and repetitions

### Progressive Overload Tracking
Track your progress week by week:
- Save training stages for each week
- Record weight used for each set
- View historical data to ensure progressive overload

### Multi-Platform Support
- **Mobile (iOS/Android)**: Full-featured interface with all capabilities
- **WearOS**: Simplified interface optimized for small screens
- **WatchOS**: Uses iOS build with adaptive UI for Apple Watch

## Data Persistence

The app uses `shared_preferences` to store data locally on the device. Data includes:
- Workout routines
- Exercise definitions
- Training stages and progress history

## Development

### Running Tests
```bash
flutter test
```

### Building for Production

Android:
```bash
flutter build apk --release
```

iOS:
```bash
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
