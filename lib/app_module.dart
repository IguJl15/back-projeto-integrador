import 'package:shelf_modular/shelf_modular.dart';

import 'core/modules/core_module.dart';
import 'features/auth/api/auth_module.dart';
import 'features/direction/api/direction_module.dart';
import 'features/term/api/term_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
        TermModule(),
        DirectionModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.module('/term', module: TermModule()),
        Route.module('/direction', module: DirectionModule()),
        Route.module('/auth', module: AuthModule()),
      ];
}
