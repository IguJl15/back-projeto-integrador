import '../../../../core/database/database.dart';
import '../../domain/models/direction.dart';
import '../../domain/repositories/direction_repository.dart';
import '../queries/create_direction_query.dart';
import '../queries/get_direction_query.dart';
import '../queries/get_directions_by_user_query.dart';

final class DirectionRepositoryImpl implements DirectionRepository {
  DatabaseConnection dbConnection;

  DirectionRepositoryImpl({required this.dbConnection});

  @override
  Future<Direction> saveNewDirection(Direction direction) async {
    final transaction = CreateDirectionQuery.fromDirection(direction);
    final userDataModel = await dbConnection.executeTransaction(transaction);

    return userDataModel;
  }

  @override
  Future<List<Direction>> getDirectionsByUserId(String userId) async {
    return await dbConnection.executeTransaction(GetDirectionsByUserQuery(userId));
  }

  @override
  Future<Direction?> getDirectionOrNull(String directionId) async {
    return await dbConnection.executeTransaction(GetDirectionQuery(directionId));
  }
}
