import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'notification_service.dart';

import 'app.config.dart';
import 'app.multibindings.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();

  // Enable multibinding support (required by GetIt)
  getIt.enableRegisteringMultipleInstancesOfOneType();

  // Configure multibindings
  getIt.configureMultibindings();
}

@injectable
class NotificationManager {
  final Iterable<NotificationService> services;

  NotificationManager(this.services);

  void broadcast(String message) {
    print('Broadcasting to ${services.length} services:');
    for (final service in services) {
      service.send(message);
    }
  }
}
