import 'dart:collection';

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

    return await termRepository.saveTerm(term);
  }

  Future<List<Term>> saveAll(List<Term> terms) async {
    final existingTerms = HashMap.fromIterable(
      await termRepository.getAllTerms(),
      key: (element) => element.description,
      value: (element) => element,
    );

    final savedTerms = <Term>[];
    final notSavedAlreadyTerms = <Term>[];

    for (var term in terms) {
      if (existingTerms.containsKey(term.description)) {
        savedTerms.add(existingTerms[term.description]);
      } else {
        notSavedAlreadyTerms.add(term);
      }
    }
    savedTerms.addAll(
      await termRepository.saveAllTerms(notSavedAlreadyTerms),
    );

    return savedTerms;
  }
}
