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
  static const int maximumTerms = 100;

  final IsTermForbidden isTermForbidden;
  final DirectionRepository dirRepository;
  final SaveTerm saveTerm;

  final UuAidi uuAidi;

  CreateDirection(
    this.isTermForbidden,
    this.dirRepository,
    this.saveTerm,
    this.uuAidi,
  );

  Future<Direction> call(CreateDirectionDto params) async {
    final terms = await filterTerms(params.terms);

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

  /// Returns a new list. Before validating the terms, the terms list will be filtered.
  ///
  /// - Throw [MaximumTermsAllowedExceeded] if it length exceed maximum defined
  /// - Throw [ForbiddenTermError] if it contains any forbidden term
  Future<List<Term>> filterTerms(List<Term> terms) async {
    final termsDescriptions = terms.map((e) => e.description.trim()).toList();
    termsDescriptions.removeWhere(_shouldRemoveTerm);

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

  /// returns true the given term should be filtered out from the terms list. All filters defined
  /// here serve as micro validations just like in length check or empty/nullable values. These
  /// filters will **not** throw any exception
  bool _shouldRemoveTerm(String term) {
    return switch (term) {
      String t when t.length < 3 || t.length >= 64 => true,
      '' => true,
      _ => false,
    };
  }
}
