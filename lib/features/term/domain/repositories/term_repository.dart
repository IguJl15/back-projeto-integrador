import '../models/term.dart';

abstract interface class TermRepository {
  Future<List<Term>> getForbiddenTerms();

  /// Save a **new** term to persistence device
  Future<String> saveTerm(Term term);

  /// Returns the id from the found term, or null if the given description don't match
  /// any term
  Future<Term?> getTermByDescriptionOrNull(String description);
}
