import 'package:injectable_multibindings/injectable_multibindings.dart';

abstract class Service {
  String getName();
}

// Unscoped service
@MultiBinding()
class UnscopedService implements Service {
  @override
  String getName() => 'Unscoped';
}

// This file demonstrates scoped multibindings but requires injectable imports to compile.
// Example scope definition:
// enum Environment { auth, admin }
//
// Scoped services would look like:
// @MultiBinding()
// @singleton(scope: Environment.auth)
// class AuthService implements Service {
//   @override
//   String getName() => 'AuthScoped';
// }
//
// Usage after code generation:
// 1. Before pushing scopes: List<Service> services = getIt<ServiceBindingsModule>().multiBindings;
//    -> Returns [UnscopedService]
//
// 2. After pushing 'auth' scope: getIt.pushNewScope(scopeName: 'auth');
//    -> Now use getIt<ServiceBindingsModule_auth>().multiBindings to get [AuthService]
//
// 3. After popping and pushing 'admin' scope: getIt.pushNewScope(scopeName: 'admin');
//    -> Now use getIt<ServiceBindingsModule_admin>().multiBindings to get [AdminService]
//
// 4. Merged access: List<Service> all = serviceMultibindings();
//    -> Returns all regardless of current scope
