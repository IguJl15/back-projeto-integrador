import '../dtos/update_direction_dto.dart';
import '../models/direction.dart';

abstract interface class DirectionRepository {
  Future<Direction> saveNewDirection(Direction direction);

  Future<List<Direction>> getDirectionsByUserId(String userId);
  Future<Direction?> getDirectionOrNull(String directionId);

  Future<Direction> updateDirection(UpdateDirectionDto updateDto);
  Future<void> deleteDirection(String directionId);
}
