import '../../../../core/errors/application_error.dart';
import '../../../auth/domain/models/user.dart';
import '../models/direction.dart';
import '../repositories/direction_repository.dart';

class GetDirection {
  final DirectionRepository repository;

  GetDirection(this.repository);

  Future<Direction> call(User user, String directionId) async {
    final direction = await repository.getDirectionOrNull(directionId);

    if (direction == null || direction.userId != user.id) {
      throw NotFoundError("Direcionamento não encontrado");
    }

    return direction;
  }
}
