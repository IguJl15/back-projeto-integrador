import 'package:shelf_modular/shelf_modular.dart';

import 'resource/scrapper_resource.dart';

class ScrapperModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.resource(ScrapperResource()),
      ];
}
