# injectable_multibindings_generator

[![pub package](https://img.shields.io/pub/v/injectable_multibindings_generator.svg)](https://pub.dev/packages/injectable_multibindings_generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Code generator for [injectable_multibindings](../injectable_multibindings) package. Automatically generates injectable modules that collect multiple implementations of the same interface.

## Overview

This package contains the build-time code generator that scans for `@MultiBinding` annotations and generates injectable-compatible modules with Lists of implementations.

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

The generator scans all Dart files in your project for classes annotated with `@MultiBinding()`.

### 2. Collection

For each annotated class, it:
- Extracts all implemented interfaces
- Groups implementations by interface type
- Extracts scope information from `@injectable` annotations
- Validates that classes are not abstract and implement at least one interface

### 3. Module Generation

Generates injectable modules for each interface:
- One module per scope combination
- Modules provide `List<T>` containing all implementations
- Creates merged accessor functions when multiple scopes exist

### Example Input

```dart
@MultiBinding()
@injectable
class EmailService implements Service {}

@MultiBinding()
@singleton(scope: Environment.test)
class TestService implements Service {}
```

### Example Output

```dart
// GENERATED CODE - DO NOT MODIFY MANUALLY
@module
abstract class ServiceBindingsModule {
  @singleton
  List<Service> get multiBindings => [
    getIt<EmailService>(),
  ];
}

@module
abstract class ServiceBindingsModule_test {
  @singleton
  List<Service> get multiBindings => [
    getIt<TestService>(),
  ];
}

// Merged accessor for all scopes
List<Service> serviceMultibindings() {
  final List<Service> result = [];
  result.addAll(getIt<ServiceBindingsModule>().multiBindings);
  result.addAll(getIt<ServiceBindingsModule_test>().multiBindings);
  return result;
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
- Scope-aware generation
- Type-safe generated code
- Injectable module compatibility
- Merged accessor generation
- Full library path preservation

### ⚠️ Limitations

- Only scans classes annotated with `@MultiBinding`
- Requires `@injectable` annotations for scope detection
- Abstract classes are rejected
- Classes without interfaces are rejected

## Generated Files

The generator creates `.multibindings.dart` files alongside your source files. These files:

- Are regenerated on each build
- Should not be manually edited
- Are included in your project automatically
- Can be imported with `part` directive or as separate files

## Scope Extraction

The generator extracts scope information from:
- `@singleton(scope: ...)`
- `@lazySingleton(scope: ...)`
- `@factory(scope: ...)`
- `@singleton(environment: ...)`
- `@lazySingleton(environment: ...)`
- `@factory(environment: ...)`

The scope name is extracted from the enum value's `name` property.

## Error Handling

The generator provides clear error messages for:

- Abstract classes: "Abstract classes cannot be annotated with @MultiBinding"
- Missing interfaces: "Classes annotated with @MultiBinding must implement at least one interface"
- Invalid annotations: Type errors for non-classes

## Technical Details

### Build Integration

- Uses `source_gen` for code generation
- Compatible with `build_runner`
- Runs before `injectable_generator` (via build configuration)
- Uses `LibraryBuilder` for file generation

### Type Handling

- Preserves full qualified type names
- Handles generic types
- Maintains library boundaries
- Generates correct imports

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

### Scope issues

Verify that scope annotations match GetIt's expected format:
```dart
@singleton(scope: MyEnvironment.production)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Related Packages

- [injectable_multibindings](../injectable_multibindings) - Main package
- [injectable](https://pub.dev/packages/injectable) - Dependency injection framework
- [source_gen](https://pub.dev/packages/source_gen) - Code generation library
