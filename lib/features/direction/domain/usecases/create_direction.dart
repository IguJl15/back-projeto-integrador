import 'package:back_projeto_integrador/features/term/domain/usecases/filter_terms_list.dart';

import '../../../../core/utils/uu_aidi.dart';
import '../../../term/domain/models/term.dart';
import '../../../term/domain/usecases/is_term_forbidden.dart';
import '../../../term/domain/usecases/save_term.dart';
import '../dtos/create_direction_dto.dart';
import '../errors/direction_errors.dart';
import '../models/direction.dart';
import '../repositories/direction_repository.dart';

/// Create a new direction linking it to [userId]. All [terms] not existing in the DB are created.
/// Before adding the term, it should be check as a Excluded Term. After saved or fetched, all the
/// terms are linked to the new Direction
class CreateDirection {
  final FilterTermsList filterTermsList;
  final DirectionRepository dirRepository;
  final SaveTerm saveTerm;

  final UuAidi uuAidi;

  CreateDirection(
    this.filterTermsList,
    this.dirRepository,
    this.saveTerm,
    this.uuAidi,
  );

  Future<Direction> call(CreateDirectionDto params) async {
    final terms = await filterTermsList(params.terms);

    final savedTerms = <Term>[];
    for (final term in terms) {
      savedTerms.add(await saveTerm(term));
    }

    final newDirection = Direction(
      id: uuAidi.generateV4(),
      title: params.title,
      redirectEmail: params.redirectEmail,
      terms: savedTerms,
      userId: params.userId,
      createdAt: DateTime.now(),
    );

    return await dirRepository.saveNewDirection(newDirection);
  }
}
