# How injectable_multibindings Works

## Overview

The `injectable_multibindings` generator creates **standalone `.multibindings.dart` files** containing abstract classes with factory constructors that return `List<T>`.

## The Two Annotations

### 1. `@MultiBinding()` 
Annotate your implementation classes:
```dart
@MultiBinding()
@injectable
class EmailService implements Service {}
```

### 2. `@HasMultibindings()`
Annotate your GetIt configuration function to tell the generator where to create the file:
```dart
@HasMultibindings()
@InjectableInit()
void configureDependencies() {
  getIt.init();
}
```

This file (`configure.dart`) will generate `configure.multibindings.dart`.

## How Generation Works

### Step 1: Find Target File
The generator looks for files with `@HasMultibindings` annotation on functions. This tells it:
- **Where** to generate the file
- **What filename** to use (same as source file)

### Step 2: Scan for Implementations
It scans **all Dart files** in your project for classes annotated with `@MultiBinding()`.

### Step 3: Generate Abstract Classes
For each interface type, it generates:

```dart
abstract class ServiceBindingsModule {
  factory ServiceBindingsModule() => _ServiceBindingsModule();
  
  List<Service> get multiBindings;
}

class _ServiceBindingsModule implements ServiceBindingsModule {
  _ServiceBindingsModule();
  
  @override
  List<Service> get multiBindings => [
    getIt<EmailService>(),
    getIt<PushService>(),
  ];
}
```

### Step 4: Import and Use
Import the generated file:
```dart
import 'configure.multibindings.dart';

void main() {
  configureDependencies();
  
  final module = ServiceBindingsModule();
  final services = module.multiBindings;
}
```

## Why This Approach?

✅ **Controlled Location**: You decide where files are generated via `@HasMultibindings`  
✅ **Standalone Files**: No part directives needed  
✅ **Abstract Classes**: Clean public API with private implementation  
✅ **Factory Pattern**: Instantiate modules like `ServiceBindingsModule()`  
✅ **Type Safe**: Full type information preserved  
✅ **Scoped Support**: Automatic scope-aware generation  

## Generated File Structure

```
lib/
  ├── di.dart                              <- Has @HasMultibindings
  ├── di.multibindings.dart                <- Generated file
  ├── services/
  │   ├── email_service.dart               <- Has @MultiBinding
  │   └── push_service.dart                <- Has @MultiBinding
  └── main.dart
```

## Complete Example

### di.dart
```dart
import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';

@HasMultibindings()
@InjectableInit()
void configureDependencies() {
  getIt.init();
}
```

### email_service.dart
```dart
import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';

@MultiBinding()
@injectable
class EmailService implements NotificationService {
  @override
  void send(String message) {}
}
```

### main.dart
```dart
import 'di.dart';
import 'di.multibindings.dart';  // Import generated file

void main() {
  configureDependencies();
  
  final module = NotificationServiceBindingsModule();
  final services = module.multiBindings;
}
```

## Comparison to Old Approach

### Old (SharedPartBuilder)
❌ Needed `part` directive  
❌ Couldn't control exact location  
❌ Less intuitive  

### New (HasMultibindings)
✅ Explicit marker annotation  
✅ Complete control over location  
✅ Standalone importable files  
✅ Clearer intent  


