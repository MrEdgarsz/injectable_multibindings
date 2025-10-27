# injectable_multibindings

[![pub package](https://img.shields.io/pub/v/injectable_multibindings.svg)](https://pub.dev/packages/injectable_multibindings)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Multibinding support for injectable dependency injection in Dart. Automatically collect multiple implementations of the same interface using GetIt's native `getAll<T>()` functionality.

## Features

- 🎯 **GetIt Native**: Uses GetIt's built-in multibinding support
- 🔒 **Type Safe**: Full type information preserved
- 🔄 **Multiple Interfaces**: Single class can implement multiple interfaces
- ⚡ **Injectable Integration**: Seamlessly works with injectable's code generation
- 🚀 **Zero Boilerplate**: Just annotate and generate
- 🔍 **Auto Discovery**: Scans all files in `lib/` directory

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  injectable_multibindings: ^1.0.0
  injectable: ^2.3.0
  get_it: ^7.6.0

dev_dependencies:
  injectable_multibindings_generator: ^1.0.0
  build_runner: ^2.4.0
  injectable_generator: ^2.6.0
```

Then run:

```bash
dart pub get
```

## Quick Start

### 1. Define your interface

```dart
abstract class NotificationService {
  void send(String message);
}
```

### 2. Annotate implementations

```dart
import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';

@MultiBinding()
@injectable
class EmailService implements NotificationService {
  @override
  void send(String message) {
    print('📧 Email: $message');
  }
}

@MultiBinding()
@injectable
class PushService implements NotificationService {
  @override
  void send(String message) {
    print('🔔 Push: $message');
  }
}

@MultiBinding()
@injectable
class SMSService implements NotificationService {
  @override
  void send(String message) {
    print('💬 SMS: $message');
  }
}
```

### 3. Configure GetIt

```dart
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'app.config.dart';
import 'app.multibindings.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
  
  // Enable multibinding support (required by GetIt)
  getIt.enableRegisteringMultipleInstancesOfOneType();
  
  // Configure multibindings
  getIt.configureMultibindings();
}
```

### 4. Run code generation

```bash
dart run build_runner build
```

This generates `app.multibindings.dart` with:
- Multiple registrations of `NotificationService` interface
- A factory for `Iterable<NotificationService>` using `getAll<T>()`

### 5. Inject and use

```dart
@injectable
class NotificationManager {
  final Iterable<NotificationService> services;
  
  NotificationManager(this.services);
  
  void broadcast(String message) {
    print('Broadcasting to ${services.length} services:');
    for (final service in services) {
      service.send(message);
    }
  }
}
```

Injectable automatically injects `Iterable<NotificationService>` which will contain all registered implementations.

## How It Works

The generator uses GetIt's native multibinding support:

1. **Discovery**: Scans all files in `lib/` for `@MultiBinding()` classes
2. **Registration**: Registers each implementation under its interface type
3. **Collection**: Uses `getAll<T>()` to collect all implementations
4. **Integration**: Provides `Iterable<T>` factory for injection

### Generated Code Example

```dart
// GENERATED CODE - DO NOT MODIFY MANUALLY
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

## Important Notes

### `enableRegisteringMultipleInstancesOfOneType()`

**This must be called** before `configureMultibindings()`. This is a GetIt requirement that allows registering multiple instances of the same type.

The generator does NOT call this automatically - you control when/how to enable it.

### Factory vs Singleton

The generator uses `registerLazySingleton` for multibindings to respect the original registration strategy:
- If your service is registered as `@factory`, each multibinding lookup creates a new instance
- If your service is registered as `@singleton`, the same instance is reused

### No Duplicate Instances

Registering as both concrete type and interface does NOT create duplicates:
- `EmailService` instance → registered as `EmailService` (by injectable)
- Same `EmailService` instance → also registered as `NotificationService` (by multibinding)
- GetIt manages this efficiently with lazy singletons

## Multiple Interfaces

A single class can implement multiple interfaces and will be included in each interface's binding list:

```dart
abstract class Writer {
  void write();
}

abstract class Reader {
  void read();
}

@MultiBinding()
@injectable
class FileIO implements Writer, Reader {
  @override
  void write() {}
  
  @override
  void read() {}
}
```

This generates bindings for both `Writer` and `Reader`.

## Requirements

- Dart SDK >= 3.7.2
- injectable >= 2.3.0
- get_it >= 7.6.0

## Limitations

- Classes must implement at least one interface
- Abstract classes cannot be annotated with `@MultiBinding`
- Classes should also be annotated with `@injectable` for proper registration
- Must call `enableRegisteringMultipleInstancesOfOneType()` before `configureMultibindings()`

## API Reference

### `@MultiBinding()`

Annotation for multibinding classes.

**Usage:**
```dart
@MultiBinding()
@injectable
class MyImplementation implements MyInterface {}
```

## Examples

See the [example](../multibidings_example/) directory for a complete working example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Related Packages

- [injectable](https://pub.dev/packages/injectable) - Dependency injection for Dart
- [get_it](https://pub.dev/packages/get_it) - Service locator for Dart
