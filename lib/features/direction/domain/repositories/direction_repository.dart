import '../models/direction.dart';

abstract interface class DirectionRepository {
  Future<String> saveNewDirection(Direction direction);
}
