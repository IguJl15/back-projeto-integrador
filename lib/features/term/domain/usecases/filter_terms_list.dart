import 'dart:collection';

import 'package:back_projeto_integrador/features/term/domain/models/term.dart';
import 'package:back_projeto_integrador/features/term/domain/usecases/is_term_forbidden.dart';

import '../../../direction/domain/errors/direction_errors.dart';

/// Returns a new list. Before validating the terms, the terms list will be filtered.
///
/// - Throw [MaximumTermsAllowedExceeded] if it length exceed maximum defined
/// - Throw [ForbiddenTermError] if it contains any forbidden term
class FilterTermsList {
  static const int maximumTerms = 100;

  final IsTermForbidden isTermForbidden;

  FilterTermsList(this.isTermForbidden);

  Future<List<Term>> call(List<Term> terms) async {
    removeTerms(terms);

    if (terms.length > maximumTerms) throw MaximumTermsAllowedExceeded(maximumTerms);

    final specialCharactersRegex = RegExp(r'[^A-Za-zÀ-ȕ ]');
    for (var term in terms) {
      if (await isTermForbidden(term)) throw ForbiddenTermError(term.description);

      if (specialCharactersRegex.hasMatch(term.description)) {
        throw InvalidTermError(
          term.description,
          "O termo não pode conter números ou caracteres especiais",
        );
      }
    }

    return terms;
  }

  removeTerms(List<Term> terms) {
    // duplicates control
    final HashMap<int, int> termsTable = HashMap();

    terms.removeWhere((term) {
      if (_shouldRemoveTerm(term) || termsTable.containsKey(term.hashCode)) {
        return true;
      } else {
        termsTable[term.hashCode] = 1;
        return false;
      }
    });
  }

  /// returns true the given term should be filtered out from the terms list. All filters defined
  /// here serve as micro validations just like in length check or empty/nullable values. These
  /// filters will **not** throw any exception
  bool _shouldRemoveTerm(Term term) {
    return switch (term.description) {
      String t when t.length < 3 || t.length >= 64 => true,
      '' => true,
      _ => false,
    };
  }
}
