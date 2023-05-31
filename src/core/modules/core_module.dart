import 'package:shelf_modular/shelf_modular.dart';

import '../../features/auth/domain/utils/hasher.dart';
import '../../features/auth/domain/utils/tolkien.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory<Hasher>((i) => Hasher(), export: true),
        Bind.factory<Tolkien>((i) => Tolkien(), export: true),
      ];
}
