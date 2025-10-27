import 'package:multibidings_example/app.dart';

void main(List<String> arguments) {
  print('🚀 Injectable Multibindings Example\n');

  // Initialize dependencies
  configureDependencies();

  // Get the notification manager with all services injected
  final manager = getIt<NotificationManager>();

  // Broadcast a message to all services
  manager.broadcast('Hello from multibindings!');

  print('\n✅ Example completed successfully!');
}
