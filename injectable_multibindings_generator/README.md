# injectable_multibindings_generator

[![pub package](https://img.shields.io/pub/v/injectable_multibindings_generator.svg)](https://pub.dev/packages/injectable_multibindings_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Code generator for [injectable_multibindings](../injectable_multibindings) package. Generates GetIt extension methods that enable multibinding support using GetIt's native `getAll<T>()` functionality.

## Overview

This package contains the build-time code generator that:
1. Scans all files in `lib/` directory for `@MultiBinding` annotations
2. Groups implementations by their interface types
3. Generates GetIt extension methods for multibinding configuration

## Installation

This package is automatically added when you install `injectable_multibindings`:

```yaml
dependencies:
  injectable_multibindings: ^1.0.0

dev_dependencies:
  injectable_multibindings_generator: ^1.0.0
  build_runner: ^2.4.0
```

## How It Works

### 1. Scanning

The generator scans **all Dart files** in your `lib/` directory for classes annotated with `@MultiBinding()`. You don't need to import them manually - the generator finds them automatically.

### 2. Collection

For each annotated class, it:
- Extracts all implemented interfaces
- Groups implementations by interface type
- Validates that classes are not abstract and implement at least one interface

### 3. Generation

Generates GetIt extension methods that:
- Register each implementation under its interface type
- Create factories for `Iterable<T>` using `getAll<T>()`

### Example Input

```dart
@MultiBinding()
@injectable
class EmailService implements NotificationService {}

@MultiBinding()
@injectable
class PushService implements NotificationService {}

@MultiBinding()
@injectable
class SMSService implements NotificationService {}
```

### Example Output

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

## Usage

Run code generation:

```bash
dart run build_runner build
```

Or watch for changes:

```bash
dart run build_runner watch
```

## Generator Features

### ✅ Supported Features

- Automatic interface detection
- Multiple interface support per class
- Type-safe generated code
- Auto-discovery of all files in `lib/`
- Respects original registration strategy (factory vs singleton)
- Uses GetIt's native `getAll<T>()` functionality

### ⚠️ Limitations

- Only scans classes annotated with `@MultiBinding`
- Requires `@injectable` annotations for registration
- Abstract classes are rejected
- Classes without interfaces are rejected

## Generated Files

The generator creates `.multibindings.dart` files alongside your source files. These files:
- Are regenerated on each build
- Should not be manually edited
- Are imported as separate files (not part files)

## Technical Details

### Build Integration

- Uses `build` package for code generation
- Compatible with `build_runner`
- Runs before `injectable_generator` (via `runs_before` in `build.yaml`)
- Uses custom `Builder` for file generation

### Type Handling

- Preserves full qualified type names
- Generates correct imports for all types
- Handles multiple interfaces per class

### Registration Strategy

The generator uses `registerLazySingleton` for multibindings. This ensures:
- The original service instance is reused (respects `@singleton` vs `@factory`)
- No duplicate instances are created
- Efficient GetIt management with lazy initialization

## Troubleshooting

### Generator not running

Check that `build_runner` is in your dev_dependencies and run:
```bash
dart pub get
dart run build_runner clean
dart run build_runner build
```

### No files generated

Ensure your classes are:
- Annotated with `@MultiBinding()`
- Not abstract
- Implement at least one interface
- File name contains 'app', 'main', or 'di' (where @InjectableInit is)

### Circular dependency errors

Make sure `configureMultibindings()` is called **after** `getIt.init()`:

```dart
@InjectableInit()
void configureDependencies() {
  getIt.init();  // Must come first
  
  getIt.enableRegisteringMultipleInstancesOfOneType();
  getIt.configureMultibindings();
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Related Packages

- [injectable_multibindings](../injectable_multibindings) - Main package
- [injectable](https://pub.dev/packages/injectable) - Dependency injection framework
- [build](https://pub.dev/packages/build) - Code generation library
