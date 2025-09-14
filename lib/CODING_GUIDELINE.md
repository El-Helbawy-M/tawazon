\# Flutter/Dart Coding Guidelines



\## Overview

This document outlines coding standards and best practices for Flutter/Dart development. These guidelines ensure code consistency, maintainability, and readability across projects.



\## Dart Style Conventions



\### Naming Conventions



\#### Variables \& Methods

```dart

// ✅ Good - camelCase

String userName = 'john\_doe';

int itemCount = 0;

bool isVisible = true;



void getUserData() {}

Future<String> fetchUserProfile() async {}

```



\#### Classes \& Enums

```dart

// ✅ Good - PascalCase

class UserProfile {}

class DatabaseHelper {}

enum ConnectionStatus { connected, disconnected, connecting }



// ✅ Good - Abstract classes

abstract class BaseRepository {}

abstract class DataSource {}

```



\#### Constants

```dart

// ✅ Good - SCREAMING\_SNAKE\_CASE

const String API\_BASE\_URL = 'https://api.example.com';

const int MAX\_RETRY\_ATTEMPTS = 3;

const Duration REQUEST\_TIMEOUT = Duration(seconds: 30);



// ✅ Good - Static constants in classes

class AppConstants {

&nbsp; static const String appName = 'MyApp';

&nbsp; static const double defaultPadding = 16.0;

}

```



\#### Files \& Directories

```dart

// ✅ Good - snake\_case

user\_profile\_page.dart

database\_helper.dart

api\_service.dart



// Directory names

user\_management/

data\_sources/

```



\#### Private Members

```dart

class MyClass {

&nbsp; // ✅ Good - Leading underscore for private

&nbsp; String \_privateField;

&nbsp; int \_internalCounter = 0;

&nbsp; 

&nbsp; void \_privateMethod() {}

&nbsp; 

&nbsp; // ✅ Good - Public members without underscore

&nbsp; String publicField;

&nbsp; void publicMethod() {}

}

```



\### Code Formatting



\#### Line Length \& Indentation

```dart

// ✅ Good - Max 80 characters per line

String longText = 'This is a very long string that should be '

&nbsp;   'broken into multiple lines for better readability';



// ✅ Good - 2-space indentation

class MyWidget extends StatelessWidget {

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return Container(

&nbsp;     child: Text('Hello World'),

&nbsp;   );

&nbsp; }

}

```



\#### Import Organization

```dart

// ✅ Good - Import order

// 1. Dart core libraries

import 'dart:async';

import 'dart:convert';



// 2. Flutter libraries

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';



// 3. Third-party packages

import 'package:dio/dio.dart';

import 'package:flutter\_bloc/flutter\_bloc.dart';



// 4. Local imports

import '../models/user.dart';

import '../services/api\_service.dart';

import 'widgets/custom\_button.dart';

```



\## Widget Guidelines



\### Widget Splitting Rules



\#### When to Create Reusable Widgets

```dart

// ✅ Good - Extract when used multiple times

class CustomButton extends StatelessWidget {

&nbsp; final String text;

&nbsp; final VoidCallback onPressed;

&nbsp; final Color? backgroundColor;

&nbsp; 

&nbsp; const CustomButton({

&nbsp;   Key? key,

&nbsp;   required this.text,

&nbsp;   required this.onPressed,

&nbsp;   this.backgroundColor,

&nbsp; }) : super(key: key);

&nbsp; 

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return ElevatedButton(

&nbsp;     onPressed: onPressed,

&nbsp;     style: ElevatedButton.styleFrom(

&nbsp;       backgroundColor: backgroundColor,

&nbsp;     ),

&nbsp;     child: Text(text),

&nbsp;   );

&nbsp; }

}



// ✅ Good - Extract complex UI sections

class UserProfileHeader extends StatelessWidget {

&nbsp; final User user;

&nbsp; 

&nbsp; const UserProfileHeader({Key? key, required this.user}) : super(key: key);

&nbsp; 

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return Column(

&nbsp;     children: \[

&nbsp;       CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),

&nbsp;       Text(user.name, style: Theme.of(context).textTheme.headlineSmall),

&nbsp;       Text(user.email, style: Theme.of(context).textTheme.bodyMedium),

&nbsp;     ],

&nbsp;   );

&nbsp; }

}

```



\### Widget Performance Best Practices

```dart

// ✅ Good - Use const constructors

const Text('Static text');

const SizedBox(height: 16);



// ✅ Good - Extract static widgets

class \_StaticHeader extends StatelessWidget {

&nbsp; const \_StaticHeader();

&nbsp; 

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return const Text('Header');

&nbsp; }

}



// ✅ Good - Use ListView.builder for large lists

ListView.builder(

&nbsp; itemCount: items.length,

&nbsp; itemBuilder: (context, index) {

&nbsp;   return ListTile(title: Text(items\[index].name));

&nbsp; },

);

```



\## Comments \& Documentation



\### Documentation Rules



\#### Class Documentation

```dart

/// A service class for handling user authentication.

/// 

/// This class provides methods for login, logout, and token management.

/// It uses secure storage for persisting authentication tokens.

/// 

/// Example usage:

/// ```dart

/// final authService = AuthService();

/// final result = await authService.login('email', 'password');

/// ```

class AuthService {

&nbsp; /// Authenticates a user with email and password.

&nbsp; /// 

&nbsp; /// Returns \[AuthResult] containing user data on success,

&nbsp; /// or error information on failure.

&nbsp; /// 

&nbsp; /// Throws \[NetworkException] if network request fails.

&nbsp; /// Throws \[AuthException] if credentials are invalid.

&nbsp; Future<AuthResult> login(String email, String password) async {

&nbsp;   // Implementation

&nbsp; }

}

```



\#### Method Documentation

```dart

/// Calculates the total price including tax and discounts.

/// 

/// \[basePrice] The original price before calculations

/// \[taxRate] Tax rate as a decimal (e.g., 0.08 for 8%)

/// \[discountPercent] Discount percentage (0-100)

/// 

/// Returns the final calculated price.

/// 

/// Example:

/// ```dart

/// final total = calculateTotal(100.0, 0.08, 10);

/// print(total); // 97.2

/// ```

double calculateTotal(double basePrice, double taxRate, int discountPercent) {

&nbsp; final discountAmount = basePrice \* (discountPercent / 100);

&nbsp; final discountedPrice = basePrice - discountAmount;

&nbsp; return discountedPrice \* (1 + taxRate);

}

```



\#### Inline Comments

```dart

class UserRepository {

&nbsp; Future<List<User>> getUsers() async {

&nbsp;   try {

&nbsp;     // Fetch from remote API first

&nbsp;     final response = await apiService.getUsers();

&nbsp;     

&nbsp;     // Cache the results locally for offline access

&nbsp;     await localDatabase.saveUsers(response.users);

&nbsp;     

&nbsp;     return response.users;

&nbsp;   } catch (e) {

&nbsp;     // Fallback to cached data if network fails

&nbsp;     return await localDatabase.getUsers();

&nbsp;   }

&nbsp; }

}

```



\### Comment Guidelines

```dart

// ✅ Good - Explain WHY, not WHAT

// Using exponential backoff to handle rate limiting

await Future.delayed(Duration(seconds: math.pow(2, retryCount).toInt()));



// ✅ Good - Explain complex business logic

// Apply loyalty discount only for premium users with 5+ orders

if (user.isPremium \&\& user.orderCount >= 5) {

&nbsp; discount = calculateLoyaltyDiscount(user.membershipLevel);

}



// ❌ Avoid - Obvious comments

// Increment counter by 1

counter++;

```





\## Error Handling Guidelines



\### Overview

This document outlines the standardized error handling practices for the Gold4Cards Flutter application, based on the established patterns in `lib/configurations/app\_errors.dart`.



\### Core Principles



\### 1. Abstract Failure Base Class

\- All errors must extend the abstract `Failure` class

\- Every failure must have a descriptive `message` property

\- Implement `toString()` method to return the error message

\- Failures should implement `Exception` interface for proper exception handling



```dart

abstract class Failure implements Exception {

&nbsp; final String message;

&nbsp; Failure(this.message);

&nbsp; 

&nbsp; @override

&nbsp; String toString() {

&nbsp;   return message;

&nbsp; }

}

```



\### 2. Specific Failure Types

Create specific failure classes for different error categories:



\#### Network-Related Failures

\- \*\*ConnectionFailure\*\*: For internet connectivity issues

\- \*\*TimeoutFailure\*\*: For request timeout scenarios (send/receive)

\- \*\*ServerFailure\*\*: For server-side errors and cancelled requests



\#### HTTP Response Failures

\- \*\*BadRequestFailure\*\*: For 4xx HTTP status codes and malformed requests

\- \*\*UnauthorizedFailure\*\*: For authentication/authorization failures

\- \*\*NotFoundFailure\*\*: For 404 errors and missing resources



\#### Application Failures

\- \*\*ValidationFailure\*\*: For input validation errors

\- \*\*UnknownFailure\*\*: For unexpected or unhandled errors



\### 3. Dio Exception Handling Pattern



\#### Centralized Exception Mapping

Use a static factory method to convert `DioException` to appropriate `Failure` types:



```dart

static Failure handleDioException(DioException exception) {

&nbsp; log(exception.type.name); // Always log the exception type

&nbsp; 

&nbsp; switch (exception.type) {

&nbsp;   case DioExceptionType.connectionTimeout:

&nbsp;   case DioExceptionType.connectionError:

&nbsp;     return ConnectionFailure("Failed due to internet connection");

&nbsp;   

&nbsp;   case DioExceptionType.sendTimeout:

&nbsp;   case DioExceptionType.receiveTimeout:

&nbsp;     return TimeoutFailure("Send/Receive Timeout");

&nbsp;   

&nbsp;   case DioExceptionType.cancel:

&nbsp;     return ServerFailure('Request to API server was cancelled');

&nbsp;   

&nbsp;   case DioExceptionType.badResponse:

&nbsp;     String message = (exception.response?.data\['message'] ?? "Something Went Wrong").toString();

&nbsp;     return BadRequestFailure(message);

&nbsp;   

&nbsp;   case DioExceptionType.unknown:

&nbsp;   default:

&nbsp;     return UnknownFailure("Unexpected error occurred");

&nbsp; }

}

```



\## Implementation Guidelines



\### 1. Error Message Standards

\- \*\*User-Friendly\*\*: Messages should be understandable by end users

\- \*\*Descriptive\*\*: Provide context about what went wrong

\- \*\*Consistent\*\*: Use standardized messages for common scenarios

\- \*\*Fallback\*\*: Always provide a default message when server response is unavailable



\### 2. Logging Requirements

\- Log exception types using `dart:developer` log function

\- Include relevant context information

\- Log before converting to user-friendly messages



\### 3. Repository Layer Error Handling

```dart

// Example implementation in repository

try {

&nbsp; final response = await apiClient.getData();

&nbsp; return Right(response.data);

} on DioException catch (e) {

&nbsp; return Left(Failure.handleDioException(e));

} catch (e) {

&nbsp; return Left(UnknownFailure("Unexpected error occurred"));

}

```



\### 4. BLoC Layer Error Handling

```dart

// Example in BLoC event handler

try {

&nbsp; final result = await repository.fetchData();

&nbsp; result.fold(

&nbsp;   (failure) => emit(ErrorState(failure.message)),

&nbsp;   (data) => emit(LoadedState(data)),

&nbsp; );

} catch (e) {

&nbsp; emit(ErrorState("An unexpected error occurred"));

}

```



\## Error Categories and Usage



| Failure Type | When to Use | Example Scenarios |

|--------------|-------------|-------------------|

| `ConnectionFailure` | Network connectivity issues | No internet, DNS resolution failed |

| `TimeoutFailure` | Request timeouts | Slow network, server not responding |

| `ServerFailure` | Server-side issues | 5xx errors, request cancelled |

| `BadRequestFailure` | Client-side request issues | 4xx errors, invalid parameters |

| `UnauthorizedFailure` | Authentication issues | Invalid token, expired session |

| `NotFoundFailure` | Resource not found | 404 errors, deleted resources |

| `ValidationFailure` | Input validation | Form validation, business rule violations |

| `UnknownFailure` | Unexpected errors | Unhandled exceptions, system errors |



\## Best Practices



\### 1. Naming Conventions

\- Failure class names should end with "Failure"

\- Use descriptive names that indicate the error category

\- Follow PascalCase naming convention



\### 2. Error Propagation

\- Always propagate errors up through the layers

\- Convert technical errors to user-friendly messages at the presentation layer

\- Maintain error context through the application layers



\### 3. Testing Error Scenarios

\- Write unit tests for each failure type

\- Test error handling in repositories and BLoCs

\- Mock network failures to test error flows



\### 4. Error Recovery

\- Implement retry mechanisms for transient failures

\- Provide fallback options when possible

\- Guide users on how to resolve errors



\## Example Usage



```dart

// In a repository method

Future<Either<Failure, UserData>> getUserData(String userId) async {

&nbsp; try {

&nbsp;   final response = await \_apiClient.get('/users/$userId');

&nbsp;   return Right(UserData.fromJson(response.data));

&nbsp; } on DioException catch (e) {

&nbsp;   return Left(Failure.handleDioException(e));

&nbsp; } catch (e) {

&nbsp;   return Left(UnknownFailure("Failed to fetch user data"));

&nbsp; }

}



// In a BLoC

void \_onFetchUserData(FetchUserData event, Emitter<UserState> emit) async {

&nbsp; emit(UserLoadingState());

&nbsp; 

&nbsp; final result = await \_userRepository.getUserData(event.userId);

&nbsp; result.fold(

&nbsp;   (failure) => emit(UserErrorState(failure.message)),

&nbsp;   (userData) => emit(UserLoadedState(userData)),

&nbsp; );

}

```



\## Migration Guidelines



When adding new error types:

1\. Create a new failure class extending `Failure`

2\. Add appropriate mapping in `handleDioException` if needed

3\. Update this documentation with the new error type

4\. Add corresponding unit tests



\## Related Files

\- `lib/configurations/app\_errors.dart` - Core error definitions

\- Repository implementations - Error handling usage

\- BLoC implementations - Error state management



``` dart

// Usage example

Future<Result<User>> getUser(String id) async {

&nbsp; try {

&nbsp;   final user = await userRepository.getUser(id);

&nbsp;   return Success(user);

&nbsp; } on AuthException catch (e) {

&nbsp;   return Failure('Authentication failed: ${e.message}', code: e.code);

&nbsp; } on NetworkException catch (e) {

&nbsp;   return Failure('Network error: ${e.message}', code: e.code);

&nbsp; } catch (e) {

&nbsp;   return Failure('Unexpected error occurred');

&nbsp; }

}

```



\## Async/Await \& Stream Usage



\### Async/Await Best Practices



\#### Proper Async Function Declaration

```dart

// ✅ Good - Return Future<Either<Failure, T>> for error handling

Future<Either<Failure, String>> fetchUserName(String id) async {

&nbsp; try {

&nbsp;   final response = await apiService.getUser(id);

&nbsp;   return Either.right(response.name);

&nbsp; } on DioException catch (e) {

&nbsp;   return Either.left(Failure.handleDioException(e));

&nbsp; } catch (e) {

&nbsp;   return Either.left(Failure('Failed to fetch user name'));

&nbsp; }

}



// ✅ Good - Handle nullable returns with proper error context

Future<Either<Failure, String?>> fetchOptionalData(String id) async {

&nbsp; try {

&nbsp;   final data = await apiService.getData(id);

&nbsp;   return Either.right(data?.value);

&nbsp; } on DioException catch (e) {

&nbsp;   return Either.left(Failure.handleDioException(e));

&nbsp; } catch (e) {

&nbsp;   return Either.left(Failure('Failed to fetch optional data'));

&nbsp; }

}



// ✅ Good - Repository pattern with Either return type

Future<Either<Failure, User>> getUser(String userId) async {

&nbsp; try {

&nbsp;   final response = await \_apiClient.get('/users/$userId');

&nbsp;   final user = User.fromJson(response.data);

&nbsp;   return Either.right(user);

&nbsp; } on DioException catch (e) {

&nbsp;   return Either.left(Failure.handleDioException(e));

&nbsp; } catch (e) {

&nbsp;   log('Unexpected error in getUser: $e');

&nbsp;   return Either.left(Failure('Failed to retrieve user data'));

&nbsp; }

}

```



\#### Error Handling with Failure Pattern

```dart

// ✅ Repository layer error handling

class UserRepository {

&nbsp; Future<Either<Failure, void>> updateUser(User user) async {

&nbsp;   try {

&nbsp;     // Validate input first

&nbsp;     final validation = \_validateUser(user);

&nbsp;     if (validation != null) {

&nbsp;       return Either.left(Failure(validation));

&nbsp;     }

&nbsp;     

&nbsp;     final response = await \_apiClient.put('/users/${user.id}', data: user.toJson());

&nbsp;     return Either.right(null);

&nbsp;   } on DioException catch (e) {

&nbsp;     return Either.left(Failure.handleDioException(e));

&nbsp;   } catch (e) {

&nbsp;     log('Unexpected error updating user: $e');

&nbsp;     return Either.left(Failure('Failed to update user'));

&nbsp;   }

&nbsp; }

&nbsp; 

&nbsp; String? \_validateUser(User user) {

&nbsp;   if (user.email.isEmpty) return "Email is required";

&nbsp;   if (!user.email.contains('@')) return "Invalid email format";

&nbsp;   return null;

&nbsp; }

}



// ✅ BLoC layer error handling

void \_onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {

&nbsp; emit(UserLoadingState());

&nbsp; 

&nbsp; final result = await \_userRepository.updateUser(event.user);

&nbsp; result.fold(

&nbsp;   (failure) => emit(UserErrorState(failure.message)),

&nbsp;   (\_) => emit(UserUpdatedState(event.user)),

&nbsp; );

}



// ✅ Parallel operations with proper error handling

Future<Either<Failure, UserProfile>> loadCompleteUserProfile(String userId) async {

&nbsp; try {

&nbsp;   final results = await Future.wait(\[

&nbsp;     \_userRepository.getUser(userId),

&nbsp;     \_profileRepository.getProfile(userId),

&nbsp;     \_preferencesRepository.getUserPreferences(userId),

&nbsp;   ]);

&nbsp;   

&nbsp;   // Check if any operation failed

&nbsp;   for (final result in results) {

&nbsp;     if (result.isLeft()) {

&nbsp;       return result.fold((failure) => Either.left(failure), (\_) => throw StateError('Impossible'));

&nbsp;     }

&nbsp;   }

&nbsp;   

&nbsp;   // All operations succeeded, extract data

&nbsp;   final user = results\[0].getOrElse(() => throw StateError('Impossible'));

&nbsp;   final profile = results\[1].getOrElse(() => throw StateError('Impossible'));

&nbsp;   final preferences = results\[2].getOrElse(() => throw StateError('Impossible'));

&nbsp;   

&nbsp;   return Either.right(UserProfile(user: user, profile: profile, preferences: preferences));

&nbsp; } catch (e) {

&nbsp;   log('Error loading complete user profile: $e');

&nbsp;   return Either.left(Failure('Failed to load user profile'));

&nbsp; }

}

```



\### Stream Usage with Error Handling



\#### Stream Creation and Management

```dart

class UserService {

&nbsp; final StreamController<Either<Failure, User>> \_userController = 

&nbsp;     StreamController<Either<Failure, User>>.broadcast();

&nbsp; 

&nbsp; /// Stream of user updates with error handling

&nbsp; Stream<Either<Failure, User>> get userStream => \_userController.stream;

&nbsp; 

&nbsp; /// Updates user data and notifies listeners

&nbsp; Future<void> updateUser(User user) async {

&nbsp;   final result = await \_userRepository.updateUser(user);

&nbsp;   \_userController.add(result.fold(

&nbsp;     (failure) => Either.left(failure),

&nbsp;     (\_) => Either.right(user),

&nbsp;   ));

&nbsp; }

&nbsp; 

&nbsp; /// Clean up resources

&nbsp; void dispose() {

&nbsp;   \_userController.close();

&nbsp; }

}

```



\#### Stream Listening with Failure Handling

```dart

class UserBloc extends Bloc<UserEvent, UserState> {

&nbsp; late final StreamSubscription \_userSubscription;

&nbsp; 

&nbsp; void \_initializeStreams() {

&nbsp;   \_userSubscription = \_userService.userStream.listen(

&nbsp;     (result) {

&nbsp;       result.fold(

&nbsp;         (failure) => add(UserErrorEvent(failure.message)),

&nbsp;         (user) => add(UserUpdatedEvent(user)),

&nbsp;       );

&nbsp;     },

&nbsp;     onError: (error) {

&nbsp;       add(UserErrorEvent("Stream error occurred"));

&nbsp;       log('User stream error: $error');

&nbsp;     },

&nbsp;     onDone: () {

&nbsp;       log('User stream closed');

&nbsp;     },

&nbsp;   );

&nbsp; }

&nbsp; 

&nbsp; @override

&nbsp; Future<void> close() {

&nbsp;   \_userSubscription.cancel();

&nbsp;   return super.close();

&nbsp; }

}

```



\#### Stream Transformations with Error Recovery

```dart

class SearchService {

&nbsp; /// Debounced search stream with error handling

&nbsp; Stream<Either<Failure, List<SearchResult>>> searchStream(Stream<String> queryStream) {

&nbsp;   return queryStream

&nbsp;       .debounceTime(const Duration(milliseconds: 300))

&nbsp;       .distinct()

&nbsp;       .where((query) => query.length >= 2)

&nbsp;       .asyncMap((query) => \_performSearch(query))

&nbsp;       .handleError((error) {

&nbsp;         log('Search stream error: $error');

&nbsp;         return Either.left(Failure('Search failed'));

&nbsp;       });

&nbsp; }

&nbsp; 

&nbsp; Future<Either<Failure, List<SearchResult>>> \_performSearch(String query) async {

&nbsp;   try {

&nbsp;     final results = await \_searchRepository.search(query);

&nbsp;     return Either.right(results);

&nbsp;   } on DioException catch (e) {

&nbsp;     return Either.left(Failure.handleDioException(e));

&nbsp;   } catch (e) {

&nbsp;     log('Search error: $e');

&nbsp;     return Either.left(Failure('Search operation failed'));

&nbsp;   }

&nbsp; }

}

```



\### Async Widget Patterns with Failure Handling



```dart

// ✅ FutureBuilder with Either pattern

class UserProfileWidget extends StatelessWidget {

&nbsp; final String userId;

&nbsp; 

&nbsp; const UserProfileWidget({Key? key, required this.userId}) : super(key: key);

&nbsp; 

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return FutureBuilder<Either<Failure, User>>(

&nbsp;     future: context.read<UserRepository>().getUser(userId),

&nbsp;     builder: (context, snapshot) {

&nbsp;       if (snapshot.connectionState == ConnectionState.waiting) {

&nbsp;         return const Center(child: CircularProgressIndicator());

&nbsp;       }

&nbsp;       

&nbsp;       if (snapshot.hasError) {

&nbsp;         return ErrorDisplayWidget(

&nbsp;           message: "An unexpected error occurred",

&nbsp;           onRetry: () => setState(() {}), // Trigger rebuild

&nbsp;         );

&nbsp;       }

&nbsp;       

&nbsp;       if (!snapshot.hasData) {

&nbsp;         return const ErrorDisplayWidget(message: "No data available");

&nbsp;       }

&nbsp;       

&nbsp;       return snapshot.data!.fold(

&nbsp;         (failure) => ErrorDisplayWidget(

&nbsp;           message: failure.message,

&nbsp;           onRetry: () => setState(() {}),

&nbsp;         ),

&nbsp;         (user) => UserDetailsWidget(user: user),

&nbsp;       );

&nbsp;     },

&nbsp;   );

&nbsp; }

}



// ✅ StreamBuilder with Either pattern

class LiveUserProfileWidget extends StatelessWidget {

&nbsp; final String userId;

&nbsp; 

&nbsp; const LiveUserProfileWidget({Key? key, required this.userId}) : super(key: key);

&nbsp; 

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return StreamBuilder<Either<Failure, User>>(

&nbsp;     stream: context.read<UserService>().getUserStream(userId),

&nbsp;     builder: (context, snapshot) {

&nbsp;       return switch (snapshot.connectionState) {

&nbsp;         ConnectionState.waiting => const Center(child: CircularProgressIndicator()),

&nbsp;         ConnectionState.active || ConnectionState.done => switch (snapshot) {

&nbsp;           AsyncSnapshot(hasError: true) => ErrorDisplayWidget(

&nbsp;               message: "Connection error occurred",

&nbsp;               onRetry: () => context.read<UserService>().refreshUser(userId),

&nbsp;             ),

&nbsp;           AsyncSnapshot(hasData: true, :final data) => data!.fold(

&nbsp;               (failure) => ErrorDisplayWidget(

&nbsp;                 message: failure.message,

&nbsp;                 onRetry: () => context.read<UserService>().refreshUser(userId),

&nbsp;               ),

&nbsp;               (user) => UserDetailsWidget(user: user),

&nbsp;             ),

&nbsp;           \_ => const ErrorDisplayWidget(message: "No user data available"),

&nbsp;         },

&nbsp;         \_ => const SizedBox.shrink(),

&nbsp;       };

&nbsp;     },

&nbsp;   );

&nbsp; }

}



// ✅ Reusable Error Display Widget

class ErrorDisplayWidget extends StatelessWidget {

&nbsp; final String message;

&nbsp; final VoidCallback? onRetry;

&nbsp; 

&nbsp; const ErrorDisplayWidget({

&nbsp;   Key? key,

&nbsp;   required this.message,

&nbsp;   this.onRetry,

&nbsp; }) : super(key: key);

&nbsp; 

&nbsp; @override

&nbsp; Widget build(BuildContext context) {

&nbsp;   return Center(

&nbsp;     child: Column(

&nbsp;       mainAxisAlignment: MainAxisAlignment.center,

&nbsp;       children: \[

&nbsp;         Icon(

&nbsp;           Icons.error\_outline,

&nbsp;           size: 64,

&nbsp;           color: Theme.of(context).colorScheme.error,

&nbsp;         ),

&nbsp;         const SizedBox(height: 16),

&nbsp;         Text(

&nbsp;           message,

&nbsp;           textAlign: TextAlign.center,

&nbsp;           style: Theme.of(context).textTheme.bodyLarge,

&nbsp;         ),

&nbsp;         if (onRetry != null) ...\[

&nbsp;           const SizedBox(height: 16),

&nbsp;           ElevatedButton(

&nbsp;             onPressed: onRetry,

&nbsp;             child: const Text('Retry'),

&nbsp;           ),

&nbsp;         ],

&nbsp;       ],

&nbsp;     ),

&nbsp;   );

&nbsp; }

}

```



\## General Best Practices



\### Code Organization

\- Keep files under 500 lines when possible

\- Group related functionality together

\- Use meaningful file and directory names

\- Separate concerns (UI, business logic, data)

\- Follow the established Failure pattern for all error handling



\### Performance Considerations

\- Use `const` constructors wherever possible

\- Implement proper `dispose()` methods for resources

\- Use `ListView.builder` for large lists

\- Cache expensive computations using Either pattern

\- Minimize widget rebuilds with proper state management



\### Testing Guidelines

\- Write unit tests for business logic including error scenarios

\- Test all Failure types and error paths

\- Use widget tests for UI components with error states

\- Mock external dependencies and simulate failures

\- Test error recovery mechanisms

\- Maintain good test coverage including error cases



\### Security Best Practices

\- Validate all user inputs using ValidationFailure

\- Use secure storage for sensitive data

\- Implement proper authentication with UnauthorizedFailure

\- Handle errors without exposing sensitive information

\- Use HTTPS for network requests

\- Log errors appropriately without exposing secrets



---



\## Quick Reference Checklist



\### Before Committing Code

\- \[ ] Follow naming conventions (camelCase, PascalCase, snake\_case)

\- \[ ] Add proper documentation for public APIs

\- \[ ] Handle errors using the Failure pattern consistently

\- \[ ] Use async/await with Either<Failure, T> return types

\- \[ ] Extract reusable widgets including error display components

\- \[ ] Add const constructors where possible

\- \[ ] Clean up resources (dispose streams, controllers)

\- \[ ] Write or update tests including error scenarios

\- \[ ] Format code (`dart format`)

\- \[ ] Run static analysis (`dart analyze`)

\- \[ ] Verify all network calls use Failure.handleDioException()

\- \[ ] Ensure proper error logging without exposing sensitive data



These guidelines ensure consistent, maintainable, and robust Flutter/Dart code with comprehensive error handling across all projects.



