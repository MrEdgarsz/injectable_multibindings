import 'package:injectable_multibindings/injectable_multibindings.dart';

// Define an interface
abstract class Service {
  String get name;
}

// Implementations annotated with @MultiBinding
@MultiBinding()
class ServiceA implements Service {
  @override
  String get name => 'ServiceA';
}

@MultiBinding()
class ServiceB implements Service {
  @override
  String get name => 'ServiceB';
}

@MultiBinding()
class ServiceC implements Service {
  @override
  String get name => 'ServiceC';
}

// When you run build_runner, this will generate:
// A ServiceBindingsModule that provides List<Service> with all three implementations
