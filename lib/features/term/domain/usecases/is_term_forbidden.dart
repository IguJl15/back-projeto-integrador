import '../models/term.dart';
import '../repositories/term_repository.dart';

/// Verify if the given [term] is a forbidden (excluded) term. Exclude terms would be offensives
/// terms or excluded by some other reason.
class IsTermForbidden {
  final TermRepository termRepository;

  IsTermForbidden(this.termRepository);

  Future<bool> call(Term term) async {
    final forbiddenTerms = await termRepository.getForbiddenTerms();

    return forbiddenTerms.contains(term);
  }
}
