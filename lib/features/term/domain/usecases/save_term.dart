import '../../../../core/utils/uu_aidi.dart';
import '../models/term.dart';
import '../repositories/term_repository.dart';

class SaveTerm {
  final TermRepository termRepository;

  final UuAidi uuAidi;

  SaveTerm(this.termRepository, this.uuAidi);

  Future<Term> call(Term term) async {
    final existingTerm = await termRepository.getTermByDescriptionOrNull(term.description);

    if (existingTerm != null) {
      return existingTerm;
    }

    final newTerm = Term.newfound(uuAidi.generateV4(), term.description);
    await termRepository.saveTerm(newTerm);
    return newTerm;
  }
}
