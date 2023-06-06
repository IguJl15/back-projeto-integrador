import 'package:shelf_modular/shelf_modular.dart';

import '../utils/hasher.dart';
import '../utils/tolkien.dart';
import '../utils/uu_aidi.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.factory<Hasher>((i) => Hasher(), export: true),
        Bind.factory<UuAidi>((i) => UuAidi(), export: true),
        Bind.factory<Tolkien>((i) => Tolkien(uuAidi: i()), export: true),
      ];
}