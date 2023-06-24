import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../data_models/user_data_model.dart';

final class GetUsersByEmailQuery implements QueryParser<List<UserDataModel>> {
  @override
  final String queryString = "SELECT * FROM $usersTable where $usersTable.email = @email";
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
              id: row[usersTable]?['user_id'],
              fullName: row[usersTable]?['complete_name'],
              email: row[usersTable]?['email'],
              phone: row[usersTable]?['phone_number'],
              createdAt: row[usersTable]?['created_at'],
              updatedAt: row[usersTable]?['updated_at'],
              deletedAt: row[usersTable]?['deleted_at'],
              completeHash: row[usersTable]?['password_hash'],
            ))
        .toList();
  }
}
