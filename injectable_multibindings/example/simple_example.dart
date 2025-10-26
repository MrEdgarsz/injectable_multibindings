import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';

// STEP 1: Add @HasMultibindings to your configuration function
@HasMultibindings()
@InjectableInit()
void configureDependencies() {
  getIt.init();
}

// STEP 2: Define your interface
abstract class Service {
  void doWork();
}

// STEP 3: Annotate implementations with @MultiBinding
@MultiBinding()
@injectable
class ServiceA implements Service {
  @override
  void doWork() => print('ServiceA');
}

@MultiBinding()
@injectable
class ServiceB implements Service {
  @override
  void doWork() => print('ServiceB');
}

// STEP 4: Use the generated module
void main() {
  configureDependencies();

  // Import the generated file
  // import 'simple_example.multibindings.dart';

  // Use the abstract class with factory
  final module = ServiceBindingsModule();
  final services = module.multiBindings;

  for (final service in services) {
    service.doWork();
  }
}
