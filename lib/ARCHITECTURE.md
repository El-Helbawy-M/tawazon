# Architecture & Development Guidelines  

## Overview  
This document outlines Clean Architecture principles with the BLoC pattern for state management.  
It serves as a reference for maintaining consistency when building new features or modifying existing ones.  

---

## Architecture Pattern  

### Core Principles  
- **Clean Architecture** with clear separation of concerns  
- **BLoC (Business Logic Component)** pattern for state management  
- **Feature-based modular structure** for scalability  
- **Repository pattern** for data abstraction  
- **Dependency injection** using a service locator (e.g., `get_it`)
- **Singletone pattern**  create a single instance for a class that will be used in more than one place

### Architecture Layers  
```
┌─────────────────┐
│       Ui        │ ← Pages, Widgets, BLoCs
├─────────────────┤
│      Core       │ ← Repositories Interface, Entities, Use Cases
├─────────────────┤
│      Data       │ ← Repositories, Network Models
└─────────────────┘
```

---

## Project Structure  

### Root Directory Structure  
```
lib/
├── app/                    # App-level components
│   ├── bloc/              # Global BLoCs (theme, auth, etc.)
│   ├── models/            # App-wide models
│   └── widgets/           # Global reusable widgets
├── configurations/        # App configs, colors, constants
├── core/                  # Core utilities, extensions, validations
├── features/              # Feature modules (self-contained)
├── handlers/              # Utility handlers (security, preferences)
├── navigation/            # Route management and navigation
├── network/               # Network layer and API services
└── main.dart
```

### Feature Module Structure  
Each feature follows Clean Architecture with this structure:  
```
features/[feature_name]/
├── data/
│   ├── models/
│   │   └── [model_name]_model.dart            # DTOs with JSON serialization
│   └── repositories/
│       └── [feature]_repository_impl.dart  # Repository implementation
├── domain/
│   ├── entities/
│   │   └── [enitiy_name]_entity.dart           # Pure business objects
│   ├── repositories/
│   │   └── [feature]_repository.dart       # Repository interface
│   └── usecases/
│       ├── get_[name].dart              # Specific use cases
│       └── create_[name].dart
└── presentation/
    ├── bloc/
    │   ├── [feature]_bloc.dart             # BLoC implementation
    │   ├── [feature]_event.dart (optional)           # Events (optional)
    │   └── [feature]_state.dart (optional)           # States (optional)
    ├── pages/
    │   └── [feature]_page.dart             # Screen widgets
    └── widgets/
        └── [feature]_[widget/view/component].dart           # Feature-specific widgets
```

---

## State Management  

### BLoC Pattern Implementation  
- **Primary**: `flutter_bloc`  
- **Persistence**: `hydrated_bloc` for persistent state  
- **Architecture**: Event-driven with separation of concerns  

### BLoC Types & Usage  
```dart
// Regular BLoC - for complex business logic
class ExampleBloc extends Bloc<AppEvents, AppStates> {
  // Implementation
}

// Cubit - for simple state management
class ThemeCubit extends Cubit<AppStates> {
  // Implementation
}

// Hydrated BLoC - for persistent state
class AuthBloc extends HydratedBloc<AppEvents, AppStates> {
  // Implementation with fromJson/toJson
}
```

### Naming Conventions  
- **BLoC Classes**: `[Feature]Bloc` → `AuthBloc`, `ProductsBloc`  
- **Cubit Classes**: `[Feature]Cubit` → `ThemeCubit`, `LanguageCubit`  
- **Events**: `[Feature][Action]Event` → `AuthLoginEvent`, `ProductsLoadEvent`  
- **States**: `[Feature][Status]State` → `AuthLoadingState`, `ProductsLoadedState`  

### State Categories  
```dart
// Initial state
class ExampleInitialState extends ExampleState {}

// Loading states
class ExampleLoadingState extends ExampleState {}

// Success states
class ExampleLoadedState extends ExampleState {
  final List<Item> items;
  ExampleLoadedState(this.items);
}

// Error states
class ExampleErrorState extends ExampleState {
  final String message;        // User-friendly message
  final int? code;             // Error code (e.g., HTTP 401, 500, custom codes)
  final Exception? exception;  // Original exception (for debugging/logging)
  final StackTrace? stackTrace; // To trace the error source
  final bool isRetryable;      // Whether the user can retry the action

  ExampleErrorState({
    required this.message,
    this.code,
    this.exception,
    this.stackTrace,
    this.isRetryable = true,
  });
}

// Empty state - when request is successful but returns no data
class ExampleEmptyState extends ExampleState {}

// Refreshing state - when reloading data but still showing cached data
class ExampleRefreshingState extends ExampleState {
  final List<Item> cachedItems;
  ExampleRefreshingState(this.cachedItems);
}

// Updating state - for background updates or partial data modifications
class ExampleUpdatingState extends ExampleState {
  final Item updatingItem;
  ExampleUpdatingState(this.updatingItem);
}

// Pagination state - when loading more items (infinite scroll)
class ExamplePaginationState extends ExampleState {
  final List<Item> currentItems;
  ExamplePaginationState(this.currentItems);
}

```

---

## Dependency Rules  

### Layer Dependencies  
1. **Ui → Core** (UI depends on business logic)  
2. **Data → Core** (Data implements domain interfaces)  
3. **Core → Nothing** (Pure business logic, no dependencies)  

### Cross-Feature Communication  
- Features should **not** import directly from other features  
- Use app-level BLoCs for cross-feature state sharing  
- Shared utilities go in `core/` or `handlers/` or `app/widgets/`  
- Use dependency injection for service sharing  

### Repository Pattern  
```dart
// Core layer - Interface
abstract class ExampleRepository {
  Future<Either<List<Item>,Failure>> getItems();
  Future<Either<Item,Failure>> getItemById(String id);
}

// Data layer - Implementation
class ExampleRepositoryImpl implements ExampleRepository {
  // Implementation with caching logic
}
```

---

## Data Layer Guidelines  

### Model Classes  
```dart
class ItemModel {
  const ItemModel({
    required super.id,
    required super.name,
    required super.value,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    // JSON deserialization
  }

  Map<String, dynamic> toJson() {
    // JSON serialization
  }
}
```

### Network Layer  
- **Base URL**: Configured in app configurations  
- **Interceptors**: Authentication, logging, error handling  
- **Retry Logic**: Automatic retry for failed requests  
- **Caching**: Local caching strategy for offline support  

---

## UI Guidelines  

### Widget Structure  
```dart
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExampleBloc()..add(LoadExampleEvent()),
      child: BlocBuilder<ExampleBloc, ExampleState>(
        builder: (context, state) {
          // UI based on state
        },
      ),
    );
  }
}
```

### Theme & Styling  
- **Material Design**: Base design system  
- **Custom Theming**: Centralized theme configuration  
- **Dark/Light Mode**: Supported via a ThemeCubit  
- **Responsive Design**: Adaptive layouts for screen sizes  

### Internationalization  
- **Languages**: Multiple (e.g., Arabic `ar`, English `en`)  
- **Structure**: JSON files in `assets/langs/`  
- **Implementation**: `flutter_localizations` with custom delegate  

---

## Testing Strategy  

### Test Structure  
```
test/
├── unit/
│   ├── features/
│   └── core/
├── widget/
└── integration/
```

### Testing Guidelines  
- **Unit Tests**: BLoCs, use cases, repositories  
- **Widget Tests**: Individual widgets and pages  
- **Integration Tests**: End-to-end user flows  
- **Mocking**: Use a mocking framework (e.g., mockito)  

---

## Development Workflow  

### Feature Development Process  
1. Create feature directory following the structure  
2. Define domain entities and repository interfaces  
3. Implement data layer with models and data sources  
4. Create repository implementation with proper error handling  
5. Build use cases for business logic  
6. Implement BLoC with events and states  
7. Create UI components following design system  
8. Write tests for all layers  
9. Update documentation if needed  

### Code Quality  
- **Linting**: Follow analysis options rules  
- **Formatting**: Use `dart format` consistently  
- **Documentation**: Document complex business logic  
- **Error Handling**: Consistent error types and messages  

---

## Security Guidelines  

### Data Protection  
- **Encryption**: Use encryption for sensitive data  
- **Local Storage**: Secure storage for authentication tokens  
- **API Security**: Proper authentication headers and HTTPS  

### Best Practices  
- **Input Validation**: Validate all user inputs  
- **Error Messages**: Avoid exposing sensitive info  
- **Permissions**: Request minimal necessary permissions  
- **Secure Communication**: Use HTTPS for all network requests  

---

## Performance Guidelines  

### Optimization Strategies  
- **Image Caching**: Use efficient image caching packages  
- **List Performance**: Implement proper list builders  
- **State Management**: Minimize unnecessary rebuilds  
- **Memory Management**: Dispose resources properly  

### Monitoring  
- **Performance Metrics**: Monitor app performance  
- **Error Tracking**: Implement error reporting  
- **Analytics**: Track user interactions (privacy-compliant)  

---

## Deployment  

### Build Configurations  
- **Development**: Debug builds with logging  
- **Staging**: Release builds for testing  
- **Production**: Optimized builds for app stores  

### Platform-Specific Notes  
- **Android**: Configure ProGuard rules  
- **iOS**: Handle App Store requirements

---

## Quick Reference  

### Creating a New Feature  
1. Create directory: `features/new_feature/`  
2. Follow the standard structure (data/domain/presentation)  
3. Implement layers in order: Core → Data → Ui  
4. Register dependencies in service locator  
5. Add navigation routes if needed  
6. Write comprehensive tests  

### Common Patterns  
- **Loading States**: Always show loading indicators  
- **Error Handling**: Consistent error UI across features  
- **Empty States**: Handle empty data gracefully  
- **Offline Support**: Cache data for offline access  
- **Refresh Mechanisms**: Pull-to-refresh where appropriate  

---

This architecture ensures maintainable, scalable, and testable code while following Flutter and Dart best practices.  
