# Build Configuration

## Execution Order

The `injectable_multibindings_generator` must run **before** `injectable_generator` so that the generated modules are available for injectable's code generation.

## Automatic Ordering

The generator's `build.yaml` is configured with `runs_before` to ensure it executes before injectable:

```yaml
runs_before:
  - injectable_generator:injectable_builder
  - injectable_generator:injectable_config_builder
```

This ensures the correct execution order:
1. `injectable_multibindings_generator` scans for `@MultiBinding` and `@HasMultibindings` annotations
2. Generates `.multibindings.dart` files with abstract classes
3. `injectable_generator` runs and can reference the generated modules

## No User Configuration Needed

Users don't need to configure anything in their `build.yaml`. The execution order is handled automatically by the generator's configuration.

