import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';
import '../notification_service.dart';

@MultiBinding()
@LazySingleton()
class EmailService implements NotificationService {
  @override
  void send(String message) {
    print('📧 Email: $message');
  }
}
