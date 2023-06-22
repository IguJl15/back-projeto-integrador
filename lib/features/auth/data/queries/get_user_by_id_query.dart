import '../../../../core/database/query_parser.dart';
import '../data_models/user_data_model.dart';

final class GetUserByIdQuery implements QueryParser<UserDataModel?> {
  static const _tableName = "systemuser";

  @override
  final String queryString = "SELECT * FROM $_tableName where $_tableName.user_id = @id";

  @override
  final Map<String, dynamic> variables;

  GetUserByIdQuery({required String id})
      : variables = {
          'id': id,
        };

  @override
  UserDataModel? fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {
    final uniqueRow = dbResult.singleOrNull;
    if (uniqueRow == null) return null;

    return UserDataModel(
      id: uniqueRow[_tableName]?['user_id'],
      fullName: uniqueRow[_tableName]?['complete_name'],
      email: uniqueRow[_tableName]?['email'],
      phone: uniqueRow[_tableName]?['phone_number'],
      createdAt: uniqueRow[_tableName]?['created_at'],
      updatedAt: uniqueRow[_tableName]?['updated_at'],
      deletedAt: uniqueRow[_tableName]?['deleted_at'],
      completeHash: uniqueRow[_tableName]?['password_hash'],
    );
  }
}
