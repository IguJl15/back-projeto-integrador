import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/utils/tolkien.dart';
import '../../auth/domain/middleware/authorization.dart';
import '../data/repositories/direction_repository_impl.dart';
import '../domain/repositories/direction_repository.dart';
import '../domain/usecases/create_direction.dart';
import '../domain/usecases/get_all_direction.dart';
import '../domain/usecases/get_direction.dart';
import 'resource/direction_resource.dart';

class DirectionModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory<DirectionRepository>((i) => DirectionRepositoryImpl(dbConnection: i())),
        Bind.factory<CreateDirection>((i) => CreateDirection(i(), i(), i(), i())),
        Bind.factory<GetAllDirection>((i) => GetAllDirection(i())),
        Bind.factory<GetDirection>((i) => GetDirection(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(DirectionResource(), middlewares: [AuthorizationMiddleware(Modular.get<Tolkien>())]),
      ];
}
