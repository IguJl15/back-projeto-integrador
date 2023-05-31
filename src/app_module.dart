import 'package:shelf_modular/shelf_modular.dart';

import 'core/modules/core_module.dart';
import 'features/auth/api/auth_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.module('/auth', module: AuthModule()),
      ];
}
