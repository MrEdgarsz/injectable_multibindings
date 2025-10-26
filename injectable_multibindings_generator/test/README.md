# Tests

This directory contains tests for the injectable_multibindings_generator.

## Test Files

- `injectable_multibindings_generator_test.dart` - Unit tests for the generator
- `integration_test.dart` - Integration tests
- `test_sources/` - Sample Dart files used for testing

## Running Tests

```bash
dart test
```

## Test Coverage

The tests verify:

1. **Generator instantiation** - The generator can be created successfully
2. **Annotation functionality** - The `@MultiBinding` annotation works correctly
3. **Annotation equality** - Multiple instances of the annotation are equal
4. **Integration** - Test source files exist and are valid

## Test Sources

The `test_sources/` directory contains example files:

- `single_interface.dart` - Multiple implementations of a single interface
- `multiple_interfaces.dart` - Classes implementing multiple interfaces

These files demonstrate how the generator should process annotated classes.

## Future Testing

For full integration testing with actual code generation, run:

```bash
dart run build_runner build
```

This will generate `.multibindings.dart` files from the test sources, which can then be manually verified.

