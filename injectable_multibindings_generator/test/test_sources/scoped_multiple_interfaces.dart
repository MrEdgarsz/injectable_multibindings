import 'package:injectable_multibindings/injectable_multibindings.dart';

abstract class Processor {
  void process();
}

abstract class Validator {
  bool validate();
}

// Unscoped - implements multiple interfaces
@MultiBinding()
class DefaultProcessor implements Processor, Validator {
  @override
  void process() {}

  @override
  bool validate() => true;
}

// Scoped example (commented out to avoid compilation errors)
// Would need actual injectable imports:
// @MultiBinding()
// @singleton(scope: Environment.test)
// class TestProcessor implements Processor {
//   @override
//   void process() {}
// }
