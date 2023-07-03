import 'package:back_projeto_integrador/features/term/domain/usecases/save_term.dart';

import '../../../term/domain/models/term.dart';
import '../../../term/domain/usecases/filter_terms_list.dart';
import '../dtos/patch_direction_dto.dart';
import '../dtos/update_direction_dto.dart';
import '../models/direction.dart';
import '../repositories/direction_repository.dart';
import 'get_direction.dart';

class UpdateDirection {
  final GetDirection getDirection;
  final FilterTermsList filterTermsList;
  final SaveTerm saveTerm;

  final DirectionRepository repository;

  UpdateDirection(
    this.getDirection,
    this.filterTermsList,
    this.saveTerm,
    this.repository,
  );

  Future<Direction> call(PatchDirectionDto dto) async {
    final Direction original = await getDirection(dto.user, dto.originalDirectionId);

    if (dto.equalsToDirection(original)) {
      return original;
    }

    final newInclusionTerms = <Term>[];
    final removedInclusionTerms = <Term>[];
    if (dto.newInclusionTermsList != null) {
      dto.newInclusionTermsList = await filterTermsList(dto.newInclusionTermsList!);

      removedInclusionTerms.addAll(original.inclusionTerms.where((t) => !dto.newInclusionTermsList!.contains(t)));

      final newTerms = dto.newInclusionTermsList!.where((t) => !original.inclusionTerms.contains(t));
      newInclusionTerms.addAll(await saveTerm.saveAll(newTerms.toList()));
    }

    final newExclusionTerms = <Term>[];
    final removedExclusionTerms = <Term>[];
    if (dto.newExclusionTermsList != null) {
      dto.newExclusionTermsList = await filterTermsList(dto.newExclusionTermsList!);
      removedExclusionTerms.addAll(original.exclusionTerms.where((t) => !dto.newExclusionTermsList!.contains(t)));

      final newTerms = dto.newExclusionTermsList!.where((t) => !original.exclusionTerms.contains(t));
      newExclusionTerms.addAll(await saveTerm.saveAll(newTerms.toList()));
    }

    return await repository.updateDirection(
      UpdateDirectionDto(
        originalDirectionId: dto.originalDirectionId,
        newTitle: dto.newTitle,
        newRedirectEmail: dto.newRedirectEmail,
        newStatus: dto.newStatus,
        addedIncTerms: newInclusionTerms,
        removedIncTerms: removedInclusionTerms,
        addedExcTerms: newExclusionTerms,
        removedExcTerms: removedExclusionTerms,
      ),
    );
  }
}
