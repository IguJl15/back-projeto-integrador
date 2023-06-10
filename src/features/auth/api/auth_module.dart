import 'package:shelf_modular/shelf_modular.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/create_and_save_tokens.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/register.dart';
import 'controllers/auth_resource.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthRepository>((i) => AuthRepositoryImpl(dbConnection: i())),
        Bind.factory((i) => CreateAndSaveTokens(authRepository: i(), tolkien: i())),
        Bind.factory((i) => RegisterUseCase(createTokens: i(), authRepository: i(), hasher: i())),
        Bind.factory((i) => Login(createTokens: i(), authRepository: i(), hasher: i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
