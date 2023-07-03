import '../../../auth/domain/models/user.dart';
import '../../../term/domain/models/term.dart';
import '../models/direction.dart';

class PatchDirectionDto {
  final User user;
  final String originalDirectionId;
  final String? newTitle;
  final String? newRedirectEmail;
  final DirectionStatus? newStatus;
  List<Term>? newInclusionTermsList;
  List<Term>? newExclusionTermsList;

  PatchDirectionDto({
    required this.user,
    required this.originalDirectionId,
    required this.newTitle,
    required this.newRedirectEmail,
    required this.newStatus,
    required this.newInclusionTermsList,
    required this.newExclusionTermsList,
  });

  factory PatchDirectionDto.fromMap(User user, String id, Map<String, dynamic> map) {
    return PatchDirectionDto(
      user: user,
      originalDirectionId: id,
      newTitle: map['title'],
      newRedirectEmail: map['redirectEmail'],
      newStatus: DirectionStatus.tryParse(map['status'] ?? ''),
      newInclusionTermsList: map['inclusionTerms'] != null
          ? (map['inclusionTerms'] as List).map((e) => Term.fromClearMap(e)).toList()
          : null,
      newExclusionTermsList: map['exclusionTerms'] != null
          ? (map['exclusionTerms'] as List).map((e) => Term.fromClearMap(e)).toList()
          : null,
    );
  }

  equalsToDirection(Direction original) {
    return original ==
        Direction(
          id: originalDirectionId,
          title: newTitle ?? original.title,
          redirectEmail: newRedirectEmail ?? original.redirectEmail,
          inclusionTerms: newInclusionTermsList ?? original.inclusionTerms,
          exclusionTerms: newExclusionTermsList ?? original.exclusionTerms,
          status: newStatus ?? original.status,
          userId: user.id,
          createdAt: original.createdAt,
        );
  }
}
