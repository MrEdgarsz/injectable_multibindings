# injectable_multibindings

[![pub package](https://img.shields.io/pub/v/injectable_multibindings.svg)](https://pub.dev/packages/injectable_multibindings)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Multibinding support for injectable dependency injection in Dart. Automatically collect multiple implementations of the same interface into lists, similar to Dagger's multibindings.

## Features

- 🎯 **Automatic Collection**: Automatically collect multiple implementations
- 🔒 **Type Safe**: Full type information preserved in generated code
- 🌐 **Scope Aware**: Built-in support for GetIt scopes
- 🔄 **Multiple Interfaces**: Single class can implement multiple interfaces
- ⚡ **Injectable Integration**: Seamlessly works with injectable's code generation
- 🚀 **Zero Boilerplate**: Just annotate and generate

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  injectable_multibindings: ^1.0.0

dev_dependencies:
  injectable_multibindings_generator: ^1.0.0
  build_runner: ^2.4.0
  injectable_generator: ^4.0.0
```

Then run:

```bash
dart pub get
```

The generator automatically runs before `injectable_generator` using `runs_before` configuration - no additional setup needed!

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
class EmailNotificationService implements NotificationService {
  @override
  void send(String message) {
    print('Email: $message');
  }
}

@MultiBinding()
@injectable
class PushNotificationService implements NotificationService {
  @override
  void send(String message) {
    print('Push: $message');
  }
}

@MultiBinding()
@injectable
class SMSNotificationService implements NotificationService {
  @override
  void send(String message) {
    print('SMS: $message');
  }
}
```

### 3. Mark your configuration function

Add `@HasMultibindings()` to your injectable configuration function:

```dart
import 'package:injectable_multibindings/injectable_multibindings.dart';

@HasMultibindings()
@InjectableInit()
void configureDependencies() {
  getIt.init();
}
```

This tells the generator to create `configure.multibindings.dart` in the same directory.

### 4. Run code generation

```bash
dart run build_runner build
```

This generates `configure.multibindings.dart` with the multibinding modules.

### 5. Import and use the generated modules

Import the generated file and use the abstract class:

```dart
import 'configure.multibindings.dart';

// Use the factory to get an instance
final module = NotificationServiceBindingsModule();
final services = module.multiBindings;
```

The generator creates abstract classes with factory constructors:

```dart
abstract class NotificationServiceBindingsModule {
  factory NotificationServiceBindingsModule() => _NotificationServiceBindingsModule();
  
  List<NotificationService> get multiBindings;
}
```

### 6. Inject and use

```dart
@injectable
class NotificationManager {
  final List<NotificationService> services;
  
  NotificationManager(this.services);
  
  void sendToAll(String message) {
    for (final service in services) {
      service.send(message);
    }
  }
}
```

## Important: File Control

The generator uses the `@HasMultibindings()` annotation to determine:
- **Where** to generate the `.multibindings.dart` file
- **What filename** to use (matches the source file)
- Generated files are **standalone** and can be imported directly

See [HOW_IT_WORKS.md](HOW_IT_WORKS.md) for detailed explanation.

## Scoped Multibindings

The generator supports GetIt scopes, automatically grouping implementations by their scope:

```dart
// Define your scope
enum Environment { auth, admin }

// Unscoped service
@MultiBinding()
@injectable
class DefaultHandler implements Handler {}

// Scoped to 'auth'
@MultiBinding()
@singleton(scope: Environment.auth)
class AuthHandler implements Handler {}

// Scoped to 'admin'
@MultiBinding()
@singleton(scope: Environment.admin)
class AdminHandler implements Handler {}
```

This generates separate modules:
- `HandlerBindingsModule` - contains `DefaultHandler`
- `HandlerBindingsModule_auth` - contains `AuthHandler`
- `HandlerBindingsModule_admin` - contains `AdminHandler`

### Using Scoped Bindings

```dart
// Before pushing any scopes
final defaultHandlers = getIt<HandlerBindingsModule>().multiBindings;
// Returns: [DefaultHandler]

// After pushing auth scope
getIt.pushNewScope(scopeName: 'auth');
final authHandlers = getIt<HandlerBindingsModule_auth>().multiBindings;
// Returns: [AuthHandler]

// Merged accessor (all bindings regardless of scope)
final allHandlers = handlerMultibindings();
// Returns: [DefaultHandler, AuthHandler, AdminHandler]
```

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

## How It Works

1. **Annotation**: Classes annotated with `@MultiBinding()` are discovered
2. **Collection**: Implementations are grouped by their implemented interfaces
3. **Scope Detection**: Scope information is extracted from `@injectable` annotations
4. **Module Generation**: Injectable-compatible modules are generated
5. **Integration**: Modules are automatically registered by injectable

## Requirements

- Dart SDK >= 3.7.2
- Works with injectable >= 1.5.0
- Works with get_it >= 7.6.0

## Limitations

- Classes must implement at least one interface
- Abstract classes cannot be annotated with `@MultiBinding`
- Classes should also be annotated with `@injectable` (or related annotations) for proper registration
- Scope names are extracted from the `scope` or `environment` parameter of injectable annotations

## API Reference

### `@MultiBinding()`

Annotation for multibinding classes.

**Usage:**
```dart
@MultiBinding()
class MyImplementation implements MyInterface {}
```

## Examples

See the [example](example/) directory for complete examples.

For detailed usage instructions including file control and part directives, see [USAGE.md](../USAGE.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Related Packages

- [injectable](https://pub.dev/packages/injectable) - Dependency injection for Dart
- [get_it](https://pub.dev/packages/get_it) - Service locator for Dart
