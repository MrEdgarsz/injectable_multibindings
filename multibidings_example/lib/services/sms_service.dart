import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable/injectable.dart';
import '../notification_service.dart';

@MultiBinding()
@injectable
class SMSService implements NotificationService {
  @override
  void send(String message) {
    print('💬 SMS: $message');
  }
}
