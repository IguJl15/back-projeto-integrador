import 'package:back_projeto_integrador/features/direction/domain/repositories/direction_repository.dart';

import '../models/direction.dart';

class GetAllDirection {
  final DirectionRepository repository;

  GetAllDirection(this.repository);

  Future<List<Direction>> call(GetDirectionsDto params) async {
    params.validate();

    final directions = await repository.getDirectionsByUserId(params.userId);

    return directions.where(notDeleted).toList();
  }

  bool notDeleted(Direction dir) => !dir.isDeleted;
}

class GetDirectionsDto {
  String userId;
  GetDirectionsDto(this.userId);

  void validate() {}
}
