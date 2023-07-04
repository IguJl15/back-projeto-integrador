import 'package:shelf_modular/shelf_modular.dart';

import '../data/scrapper_respository.dart';
import 'resource/scrapper_resource.dart';

class ScrapperModule extends Module {
  @override
  List<Bind<Object>> get binds => [Bind.factory<ScrapperRepository>((i) => ScrapperRepository())];

  @override
  List<ModularRoute> get routes => [
        Route.resource(ScrapperResource()),
      ];
}
