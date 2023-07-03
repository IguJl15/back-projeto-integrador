import '../models/term.dart';

abstract interface class TermRepository {
  Future<List<Term>> getAllTerms();
  Future<List<Term>> getForbiddenTerms();

  /// Save a **new** term to persistence device
  Future<Term> saveTerm(Term term);

  /// Save all the new terms to persistence device
  Future<List<Term>> saveAllTerms(List<Term> terms);

  /// Returns the id from the found term, or null if the given description don't match
  /// any term
  Future<Term?> getTermByDescriptionOrNull(String description);
}
