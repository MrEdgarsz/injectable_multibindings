import 'package:injectable_multibindings/injectable_multibindings.dart';

abstract class Handler {
  void handle();
}

// Example scope names (would typically come from your app's enum or constants)
enum Environment { auth, admin }

// Without scope
@MultiBinding()
class DefaultHandler implements Handler {
  @override
  void handle() {}
}

// Scoped to 'auth'
// Note: These examples show the pattern but would need actual injectable imports to compile
// @MultiBinding()
// @singleton(scope: Environment.auth)
// class AuthHandler implements Handler {
//   @override
//   void handle() {}
// }

// Scoped to 'admin'
// @MultiBinding()
// @singleton(scope: Environment.admin)
// class AdminHandler implements Handler {
//   @override
//   void handle() {}
// }
