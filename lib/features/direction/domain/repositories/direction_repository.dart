import '../models/direction.dart';

abstract interface class DirectionRepository {
  Future<Direction> saveNewDirection(Direction direction);

  Future<List<Direction>> getDirectionsByUserId(String userId);
}
