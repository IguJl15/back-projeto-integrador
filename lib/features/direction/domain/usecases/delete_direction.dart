import '../../../auth/domain/models/user.dart';
import '../repositories/direction_repository.dart';
import 'get_direction.dart';

class DeleteDirection {
  final DirectionRepository repository;
  final GetDirection getDirection;

  DeleteDirection(this.repository, this.getDirection);

  Future<void> call(User user, String directionId) async {
    final direction = await getDirection(user, directionId);

    await repository.deleteDirection(direction.id);
  }
}
