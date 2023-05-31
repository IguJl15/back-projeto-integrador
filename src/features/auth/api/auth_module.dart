import 'package:shelf_modular/shelf_modular.dart';

import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/register.dart';
import 'controllers/auth_resource.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthRepository>((i) => ListAuthRepository()),
        Bind.factory((i) => RegisterUseCase(authRepository: i(), hasher: i(), tolkien: i())),
        Bind.factory((i) => Login(authRepository: i(), hasher: i(), tolkien: i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
