import 'package:injectable_multibindings/injectable_multibindings.dart';

abstract class Service {
  void doWork();
}

@MultiBinding()
class ServiceA implements Service {
  @override
  void doWork() {}
}

@MultiBinding()
class ServiceB implements Service {
  @override
  void doWork() {}
}
