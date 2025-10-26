# Usage Guide

## How the Generator Works

The `injectable_multibindings_generator` generates code using the `SharedPartBuilder` pattern. This means:

1. **You control where the code is generated** via a `part` directive
2. **Generated code is merged** into files you specify
3. **One file can contain generated modules** from multiple source files

## Setup Steps

### 1. Choose Your File

Create or choose a file where you want the multibinding modules generated. Common choices:
- `lib/main.dart` - Your app's entry point
- `lib/di.dart` - Dedicated dependency injection file
- `lib/app.dart` - Your app configuration file

### 2. Add Part Directive

Add this line at the top of your chosen file:

```dart
part 'your_file_name.g.dart';
```

**Important:** Replace `your_file_name` with the actual name of your file (without `.dart` extension).

Example in `lib/main.dart`:
```dart
import 'package:my_app/app.dart';

part 'main.g.dart';  // <-- Add this

void main() {
  runApp(MyApp());
}
```

### 3. Annotate Your Classes

In any file in your project, annotate classes with `@MultiBinding`:

```dart
@MultiBinding()
@injectable
class EmailService implements Service {
  // ...
}
```

### 4. Run Code Generation

```bash
dart run build_runner build
```

### 5. Import and Use

The generated code will be in your `.g.dart` file. Import it where needed:

```dart
import 'package:my_app/main.dart'; // Includes main.g.dart via part

final services = getIt<ServiceBindingsModule>().multiBindings;
```

## Example Structure

```
lib/
  ├── main.dart           <- Add part 'main.g.dart';
  ├── main.g.dart         <- Generated file (auto-created)
  ├── services/
  │   ├── email_service.dart
  │   ├── push_service.dart
  │   └── sms_service.dart
  └── app.dart
```

## Important Notes

### File Location
- The generator scans **all Dart files** in your `lib/` directory
- Generated code goes into the `.g.dart` file you specify with `part`
- Multiple files with `part` directives can exist, each gets code for its scanned files

### Import Strategy
Since generated code is in a `.g.dart` file via `part`:
- **Don't import** `.g.dart` files directly
- **Import** the parent file that has the `part` directive
- The part file is automatically included

### Multiple Part Files
You can have multiple files with `part` directives:
- Each generates modules for files scanned during its build step
- Useful for organizing different parts of your app

## Troubleshooting

### "No code generated"
- Check that your file has `part 'filename.g.dart';`
- Ensure classes are annotated with `@MultiBinding()`
- Run `dart run build_runner clean` then rebuild

### "Import errors"
- Don't import `.g.dart` files directly
- Import the parent file with the `part` directive

### "Modules not found"
- Ensure `@InjectableInit()` is called
- Check that generated modules are in scope
- Verify GetIt initialization runs after code generation


