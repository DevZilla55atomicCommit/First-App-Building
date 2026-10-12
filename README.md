# First App Building

A demonstration Flutter app for learning iOS app development with clean architecture, feature-first organization, and modern Flutter best practices.

## Project Structure

```
lib/
├── core/                    # Shared code across features
│   ├── config/             # App configuration (environment, API)
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection (Riverpod)
│   ├── errors/             # Error handling (Result type, AppError)
│   ├── network/            # API client (Dio)
│   ├── theme/              # App theming (light/dark)
│   ├── usecase/            # Base use case interface
│   └── utils/              # Utilities (local storage)
├── features/               # Feature modules (feature-first)
│   ├── home/               # Home feature
│   │   ├── data/           # Data layer
│   │   │   ├── datasources/    # Remote & local data sources
│   │   │   ├── models/         # DTOs (Freezed + JSON)
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/         # Domain layer (pure Dart)
│   │   │   ├── entities/       # Business entities
│   │   │   ├── repositories/   # Repository contracts
│   │   │   └── usecases/       # Business logic
│   │   └── presentation/   # Presentation layer
│   │       ├── viewmodels/     # State management (Riverpod)
│   │       ├── views/          # Screens/Pages
│   │       └── widgets/        # Feature-specific widgets
│   ├── settings/           # Settings feature (structure ready)
│   └── onboarding/         # Onboarding feature (structure ready)
├── shared/                 # Shared across features
│   ├── widgets/            # Reusable UI components
│   ├── models/             # Shared models
│   ├── extensions/         # Dart extensions
│   └── constants/          # Shared constants
└── main.dart               # App entry point
```

## Architecture

This project follows **Flutter's official architecture recommendations**:
- **MVVM** (Model-View-ViewModel) pattern
- **Feature-First** organization (group by feature, not layer)
- **Clean Architecture** layers within each feature:
  - **Domain** → Pure Dart, no Flutter dependencies
  - **Data** → Repository implementations, data sources, DTOs
  - **Presentation** → Widgets, ViewModels, State

### Key Technologies

| Purpose | Technology |
|---------|------------|
| State Management | Riverpod 2.5+ (code generation) |
| Navigation | go_router |
| Networking | Dio |
| Serialization | Freezed + json_serializable |
| Dependency Injection | Riverpod (built-in) |
| Local Storage | SharedPreferences |
| Testing | mocktail, bloc_test |

## Getting Started

### Prerequisites

- Flutter SDK 3.24+
- Xcode 27+ (for iOS Simulator)
- VS Code with Flutter & Dart extensions

### Installation

```bash
# Navigate to project
cd /Volumes/LEDFLSHDRV/First-App-Building

# Install dependencies
flutter pub get

# Generate code (Freezed, Riverpod, JSON)
flutter pub run build_runner build --delete-conflicting-outputs

# Run on iOS Simulator
flutter run -d "iPhone 16"

# Run on Web
flutter run -d chrome
```

### VS Code Setup

1. Open folder in VS Code: `code .`
2. Install recommended extensions (Flutter, Dart)
3. Press `F5` to launch with debugging

## Features

- ✅ **Home Screen** - List items with CRUD operations
- ✅ **Favorites** - Toggle favorite status (persisted locally)
- ✅ **Add/Delete Items** - Full CRUD demo
- ✅ **Pull-to-refresh** - Refresh data
- ✅ **Light/Dark theme** - System-aware theming
- ✅ **Error handling** - Graceful error states with retry
- ✅ **Loading states** - Skeleton loading overlays
- ✅ **Empty states** - Helpful empty state UI

## Development Commands

```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate code after model changes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter pub run build_runner watch --delete-conflicting-outputs

# Build iOS
flutter build ios

# Build for release
flutter build ios --release
```

## Adding a New Feature

1. Create feature folder structure:
   ```
   lib/features/my_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── viewmodels/
       ├── views/
       └── widgets/
   ```

2. Define domain entities (pure Dart)
3. Create repository interface
4. Implement data sources & repository
5. Create use cases
6. Build ViewModel with Riverpod
7. Create UI widgets & screens
8. Register providers in `injection.dart`

## iOS-Specific Notes

- **Simulator**: iOS 27.0 runtime installed and working
- **CocoaPods**: 1.17.0 installed via Homebrew Ruby
- **Bundle ID**: Configure in `ios/Runner/Info.plist`
- **Signing**: Set team in Xcode for device testing

## Next Steps for Learning

1. Run the app and explore the home feature
2. Add a new feature (e.g., "Notes" or "Tasks")
3. Connect to a real API (replace `HomeRemoteDataSource`)
4. Add authentication flow
5. Implement unit tests for use cases
6. Add widget tests for screens
7. Set up CI/CD with GitHub Actions

## Resources

- [Flutter Architecture Guide](https://docs.flutter.dev/app-architecture/recommendations)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Clean Architecture in Flutter](https://dev.to/techwithsam/clean-architecture-in-flutter-2026-practical-implementation-guide-1dfb)