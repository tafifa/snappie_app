# Snappie App

A Flutter application built with Clean Architecture principles, featuring user authentication, state management with GetX, and local storage with Isar database.

## Architecture Overview

This project follows **Clean Architecture** principles, ensuring separation of concerns, testability, and maintainability. The architecture is divided into three main layers:

- **Domain Layer**: Contains business logic, entities, and use cases
- **Data Layer**: Handles data sources, repositories implementation, and models
- **Presentation Layer**: UI components, controllers, and state management

## Project Structure

```
lib/
├── app/
│   ├── core/                    # Core utilities and configurations
│   │   ├── constants/           # App-wide constants
│   │   ├── database/            # Database configuration (Isar)
│   │   ├── dependency_injection.dart  # DI setup with GetX
│   │   ├── errors/              # Error handling and exceptions
│   │   ├── network/             # Network configuration and interceptors
│   │   └── utils/               # Utility functions and helpers
│   ├── data/                    # Data Layer
│   │   ├── datasources/         # Data sources (local & remote)
│   │   ├── models/              # Data models with JSON serialization
│   │   └── repositories/        # Repository implementations
│   ├── domain/                  # Domain Layer (Business Logic)
│   │   ├── entities/            # Business entities
│   │   ├── repositories/        # Repository interfaces
│   │   └── usecases/            # Business use cases
│   ├── modules/                 # Feature modules
│   │   └── home/                # Home feature
│   │       ├── bindings/        # GetX bindings for dependency injection
│   │       ├── controllers/     # GetX controllers for state management
│   │       └── views/           # UI screens and widgets
│   ├── routes/                  # App routing configuration
│   └── shared/                  # Shared UI components and widgets
└── main.dart                    # App entry point
```

## Layer Details

### 🏗️ Core Layer (`lib/app/core/`)
Contains foundational components used across the entire application:

- **`constants/`**: App-wide constants like API endpoints, colors, strings
- **`database/`**: Isar database service and configuration
- **`dependency_injection.dart`**: Centralized dependency injection setup using GetX
- **`errors/`**: Custom exceptions, failures, and error handling
- **`network/`**: HTTP client configuration, interceptors, and network utilities
- **`utils/`**: Helper functions, extensions, and utility classes

### 📊 Data Layer (`lib/app/data/`)
Handles all data operations and external dependencies:

- **`datasources/`**: 
  - `local/`: Local data sources (Isar database operations)
  - `remote/`: Remote data sources (API calls)
- **`models/`**: Data models that extend domain entities with serialization
- **`repositories/`**: Concrete implementations of domain repository interfaces

### 🎯 Domain Layer (`lib/app/domain/`)
Contains pure business logic, independent of external frameworks:

- **`entities/`**: Core business objects (pure Dart classes)
- **`repositories/`**: Abstract repository interfaces
- **`usecases/`**: Business use cases that orchestrate data flow

### 🎨 Presentation Layer (`lib/app/modules/`)
Handles UI and user interactions:

- **`bindings/`**: GetX bindings for dependency injection per feature
- **`controllers/`**: GetX controllers managing UI state and business logic
- **`views/`**: Flutter widgets and screens

### 🛣️ Routes (`lib/app/routes/`)
Centralized routing configuration using GetX navigation.

### 🔄 Shared (`lib/app/shared/`)
Reusable UI components, widgets, and utilities used across multiple features.

## Key Technologies

- **State Management**: GetX
- **Local Database**: Isar (NoSQL database)
- **HTTP Client**: Dio with custom interceptors
- **Dependency Injection**: GetX
- **Architecture**: Clean Architecture
- **Error Handling**: Dartz (Either type for functional error handling)

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd snappie_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Isar database schemas:
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## Development Guidelines

### Adding New Features

1. **Create Domain Layer**:
   - Define entities in `domain/entities/`
   - Create repository interfaces in `domain/repositories/`
   - Implement use cases in `domain/usecases/`

2. **Implement Data Layer**:
   - Create models in `data/models/`
   - Implement data sources in `data/datasources/`
   - Implement repository in `data/repositories/`

3. **Build Presentation Layer**:
   - Create controller in `modules/feature/controllers/`
   - Design views in `modules/feature/views/`
   - Set up bindings in `modules/feature/bindings/`

4. **Update Dependencies**:
   - Register new dependencies in `core/dependency_injection.dart`
   - Add routes in `routes/`

### Code Generation

When modifying Isar models, run:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Testing

The clean architecture makes testing straightforward:
- **Unit Tests**: Test use cases and entities
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows

## Contributing

1. Follow the established architecture patterns
2. Maintain separation of concerns
3. Write tests for new features
4. Update documentation when adding new modules

For more information about Flutter development, visit the [official documentation](https://docs.flutter.dev/).
