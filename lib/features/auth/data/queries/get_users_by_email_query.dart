import '../../../../core/database/query_parser.dart';
import '../data_models/user_data_model.dart';

final class GetUsersByEmailQuery implements QueryParser<List<UserDataModel>> {
  static const _tableName = "systemuser";

  @override
  final String queryString = "SELECT * FROM $_tableName where $_tableName.email = @email";
  @override
  final Map<String, dynamic> variables;

  GetUsersByEmailQuery({required String email})
      : variables = {
          'email': email,
        };

  @override
  List<UserDataModel> fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {
    return dbResult
        .map((row) => UserDataModel(
              id: row[_tableName]?['user_id'],
              fullName: row[_tableName]?['complete_name'],
              email: row[_tableName]?['email'],
              phone: row[_tableName]?['phone_number'],
              createdAt: row[_tableName]?['created_at'],
              updatedAt: row[_tableName]?['updated_at'],
              deletedAt: row[_tableName]?['deleted_at'],
              completeHash: row[_tableName]?['password_hash'],
            ))
        .toList();
  }
}
