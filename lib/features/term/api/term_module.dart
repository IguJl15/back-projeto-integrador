import 'package:shelf_modular/shelf_modular.dart';

import '../data/repositories/term_repository_impl.dart';
import '../domain/repositories/term_repository.dart';
import '../domain/usecases/is_term_forbidden.dart';
import '../domain/usecases/save_term.dart';

class TermModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<TermRepository>((i) => TermRepositoryImpl(dbConnection: i()), export: true),
        Bind.factory<SaveTerm>((i) => SaveTerm(i(), i()), export: true),
        Bind.factory<IsTermForbidden>((i) => IsTermForbidden(i()), export: true),
      ];
}
