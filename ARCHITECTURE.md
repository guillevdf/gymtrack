# GymTrack Architecture

## Overview

GymTrack is a Flutter-based mobile application designed to help users track their gym workouts with a focus on progressive overload training principles.

## Architecture Pattern

The application follows a simple **Provider-based State Management** pattern with a clear separation of concerns:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│   (Screens, Widgets, UI Components)     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         State Management Layer          │
│        (Provider + AppState)            │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Service Layer                 │
│     (StorageService, Business Logic)    │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Data Layer                   │
│   (Models, Local Storage via Prefs)    │
└─────────────────────────────────────────┘
```

## Core Components

### 1. Models (`lib/models/`)

Data models that represent the domain entities:

- **ExerciseSet**: Represents a single set with weight and repetitions
- **Exercise**: Contains exercise details (name, type) and multiple sets
- **WorkoutRoutine**: A collection of exercises that form a workout
- **TrainingStage**: Records a specific training session with weights used per week

All models include:
- JSON serialization/deserialization
- `copyWith` methods for immutability
- Clear data structure

### 2. Services (`lib/services/`)

Business logic and state management:

- **StorageService**: Handles data persistence using SharedPreferences
  - Saves/loads workout routines
  - Saves/loads training stages
  - JSON-based serialization

- **AppState**: Central state management using ChangeNotifier
  - Manages application state
  - Provides CRUD operations for routines and stages
  - Notifies listeners of state changes
  - Handles data loading/saving

### 3. Screens (`lib/screens/`)

UI screens for different functionalities:

#### Mobile Screens
- **HomeScreen**: Main entry point, displays list of routines
- **CreateRoutineScreen**: Create/edit workout routines with exercises
- **RoutineDetailScreen**: View routine details and training history
- **TrainingStageScreen**: Track current workout with progressive overload

#### Wearable Screens (`lib/screens/wear/`)
- **WearHomeScreen**: Simplified interface for WearOS devices
- **WearRoutineDetailScreen**: View routine on small screens

### 4. Platform Support

#### Android
- Configuration in `android/` directory
- Supports Android 5.0 (API 21) and above
- Material Design 3 components
- WearOS compatibility

#### iOS
- Configuration in `ios/` directory
- Supports iOS 12.0 and above
- Cupertino widgets when appropriate
- WatchOS compatible (uses iOS build)

## Data Flow

### Creating a Routine
1. User navigates to CreateRoutineScreen
2. Fills in routine name and adds exercises
3. For each exercise, adds sets with weight/reps
4. Saves routine → AppState.addRoutine()
5. AppState calls StorageService.saveRoutines()
6. Data persisted to SharedPreferences as JSON
7. UI updated via notifyListeners()

### Tracking Progressive Overload
1. User starts training from RoutineDetailScreen
2. TrainingStageScreen loads routine with current/suggested weights
3. User adjusts weights for each set
4. Saves stage → AppState.addStage()
5. Stage stored with week number and date
6. Historical data available for comparison

## Progressive Overload Implementation

The app supports progressive overload through:

1. **Week Tracking**: Each training stage is tagged with a week number
2. **Historical Data**: All past training stages are stored
3. **Weight Progression**: Users can see and increment weights over time
4. **Per-Set Tracking**: Each set can have different weights

## State Management Flow

```
User Action
    ↓
UI Event
    ↓
AppState Method
    ↓
StorageService (persist)
    ↓
notifyListeners()
    ↓
UI Rebuild (Consumer)
```

## Data Persistence

Uses `shared_preferences` plugin for local storage:
- Simple key-value storage
- JSON serialization for complex objects
- No external database required
- Cross-platform compatibility

Storage Keys:
- `workout_routines`: List of all routines
- `training_stages`: List of all training sessions

## UI/UX Principles

### Mobile Interface
- Full-featured Material Design 3
- Clear navigation hierarchy
- Form validation
- Confirmation dialogs for destructive actions
- Loading states

### Wearable Interface
- Simplified, essential information only
- Larger touch targets
- Dark theme by default
- Minimal text, more icons
- Quick access to routines

## Scalability Considerations

Current implementation is suitable for:
- Personal use (single user)
- Dozens of routines
- Hundreds of training sessions

Future enhancements could include:
- Cloud synchronization
- Multi-user support
- Analytics and charts
- Exercise database
- Social features
- AI-powered recommendations

## Testing Strategy

The application structure supports:
- Unit tests for models
- Widget tests for UI components
- Integration tests for user flows
- Mock StorageService for testing

## Dependencies

Key dependencies:
- `flutter`: Core framework
- `provider`: State management
- `shared_preferences`: Data persistence
- `uuid`: Unique ID generation
- `intl`: Date formatting (if needed)

## Platform Considerations

### Android-specific
- Gradle-based build system
- Kotlin support
- Material Components
- WearOS module compatibility

### iOS-specific
- CocoaPods for dependency management
- Swift integration
- iOS/WatchOS target support
- Cupertino design patterns

## Build Variants

The app can be built in different modes:
- **Mobile**: `flutter run` (main.dart)
- **Wear**: `flutter run -t lib/main_wear.dart`

Both variants share the same models, services, and business logic, only the UI layer differs.
