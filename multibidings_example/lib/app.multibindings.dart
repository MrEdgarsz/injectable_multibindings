// GENERATED CODE - DO NOT MODIFY MANUALLY
// Multibinding modules

import 'package:get_it/get_it.dart' as i1;
import 'package:multibidings_example/services/email_service.dart';
import 'package:multibidings_example/notification_service.dart';
import 'package:multibidings_example/services/push_service.dart';
import 'package:multibidings_example/services/sms_service.dart';

final getIt = i1.GetIt.instance;

// Extension to configure multibindings
// IMPORTANT: Call getIt.enableRegisteringMultipleInstancesOfOneType() before calling configureMultibindings()
extension ConfigureMultibindings on i1.GetIt {
  void configureMultibindings() {
    // Register multibindings for NotificationService
    registerFactory<NotificationService>(() => getIt<EmailService>());
    registerFactory<NotificationService>(() => getIt<PushService>());
    registerFactory<NotificationService>(() => getIt<SMSService>());
    registerFactory<Iterable<NotificationService>>(() => getAll<NotificationService>());
  }
}
