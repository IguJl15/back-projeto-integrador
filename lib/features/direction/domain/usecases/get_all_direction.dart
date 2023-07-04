import '../models/direction.dart';
import '../repositories/direction_repository.dart';

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
