# Injectable Multibindings Example

A complete working example demonstrating how to use `injectable_multibindings` with GetIt's native multibinding support.

## Quick Start

1. Install dependencies:
```bash
dart pub get
```

2. Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Run the example:
```bash
dart run bin/multibidings_example.dart
```

## Expected Output

```
🚀 Injectable Multibindings Example

Broadcasting to 3 services:
📧 Email: Hello from multibindings!
🔔 Push: Hello from multibindings!
💬 SMS: Hello from multibindings!

✅ Example completed successfully!
```

## What This Example Shows

- Multiple implementations of `NotificationService` interface
- Automatic collection into `Iterable<NotificationService>` using GetIt's `getAll<T>()`
- Injection into `NotificationManager`
- Zero manual registration boilerplate
- Using `enableRegisteringMultipleInstancesOfOneType()` from GetIt

## Project Structure

```
lib/
  ├── app.dart                        - Main app setup with GetIt configuration
  ├── notification_service.dart       - Interface definition
  ├── app.config.dart                 - Injectable generated code
  ├── app.multibindings.dart         - Multibinding configuration (generated)
  └── services/
      ├── email_service.dart          - Email implementation
      ├── push_service.dart           - Push implementation
      └── sms_service.dart             - SMS implementation
```

## Key Files

### `lib/app.dart`

```dart
@InjectableInit()
void configureDependencies() {
  getIt.init();
  
  // Enable multibinding support (required by GetIt)
  getIt.enableRegisteringMultipleInstancesOfOneType();
  
  // Configure multibindings
  getIt.configureMultibindings();
}
```

### `lib/services/email_service.dart`

```dart
@MultiBinding()
@injectable
class EmailService implements NotificationService {
  @override
  void send(String message) {
    print('📧 Email: $message');
  }
}
```

### Generated: `lib/app.multibindings.dart`

```dart
extension ConfigureMultibindings on GetIt {
  void configureMultibindings() {
    // Register multibindings for NotificationService
    registerLazySingleton<NotificationService>(() => getIt<EmailService>());
    registerLazySingleton<NotificationService>(() => getIt<PushService>());
    registerLazySingleton<NotificationService>(() => getIt<SMSService>());
    
    // Register factory for Iterable<NotificationService> using getAll
    registerFactory<Iterable<NotificationService>>(() => getAll<NotificationService>());
  }
}
```

## How It Works

1. Services are annotated with `@MultiBinding()` and `@injectable`
2. Generator scans all files in `lib/` directory
3. Groups implementations by interface type
4. Generates multibinding configuration using GetIt's native support
5. Injectable injects `Iterable<NotificationService>` automatically

## Important Notes

- Must call `enableRegisteringMultipleInstancesOfOneType()` before `configureMultibindings()`
- Generator automatically discovers services - no manual imports needed
- Uses GetIt's `getAll<T>()` for efficient multibinding collection
- Registration strategy is respected (factory vs singleton)

## See Also

- [Main Package README](../injectable_multibindings/README.md)
- [Generator README](../injectable_multibindings_generator/README.md)
