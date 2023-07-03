import '../models/direction.dart';
import '../../../term/domain/models/term.dart';

class UpdateDirectionDto {
  final String originalDirectionId;
  final String? newTitle;
  final String? newRedirectEmail;
  final DirectionStatus? newStatus;
  final List<Term> addedIncTerms;
  final List<Term> removedIncTerms;
  final List<Term> addedExcTerms;
  final List<Term> removedExcTerms;

  UpdateDirectionDto({
    required this.originalDirectionId,
    required this.newTitle,
    required this.newRedirectEmail,
    required this.newStatus,
    required this.addedIncTerms,
    required this.removedIncTerms,
    required this.addedExcTerms,
    required this.removedExcTerms,
  });
}
