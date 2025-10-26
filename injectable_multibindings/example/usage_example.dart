import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';

// STEP 1: Add this part directive to the file where you want the modules generated
// This is typically your main.dart or a dedicated di.dart file
part 'usage_example.g.dart';

// STEP 2: Define your interface
abstract class NotificationService {
  void send(String message);
}

// STEP 3: Annotate implementations with @MultiBinding
@MultiBinding()
@injectable
class EmailNotificationService implements NotificationService {
  @override
  void send(String message) {
    print('Email: $message');
  }
}

@MultiBinding()
@injectable
class PushNotificationService implements NotificationService {
  @override
  void send(String message) {
    print('Push: $message');
  }
}

@MultiBinding()
@injectable
class SMSNotificationService implements NotificationService {
  @override
  void send(String message) {
    print('SMS: $message');
  }
}

// STEP 4: Use the generated multibindings
@injectable
class NotificationManager {
  final List<NotificationService> services;

  NotificationManager(this.services);

  void sendToAll(String message) {
    for (final service in services) {
      service.send(message);
    }
  }
}

// STEP 5: Initialize GetIt
@InjectableInit()
void configureDependencies() {
  // The generated modules are automatically registered
  getIt.init();
}

void main() {
  configureDependencies();

  // STEP 6: Use the multibindings
  final manager = getIt<NotificationManager>();
  manager.sendToAll('Hello World');

  // Or access directly
  final services = getIt<NotificationServiceBindingsModule>().multiBindings;
  print('Total services: ${services.length}');
}
