import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../data_models/user_data_model.dart';

final class GetUserByIdQuery implements QueryParser<UserDataModel?> {
  @override
  final String queryString = "SELECT * FROM $usersTable where $usersTable.user_id = @id";

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
      id: uniqueRow[usersTable]?['user_id'],
      fullName: uniqueRow[usersTable]?['complete_name'],
      email: uniqueRow[usersTable]?['email'],
      phone: uniqueRow[usersTable]?['phone_number'],
      createdAt: uniqueRow[usersTable]?['created_at'],
      updatedAt: uniqueRow[usersTable]?['updated_at'],
      deletedAt: uniqueRow[usersTable]?['deleted_at'],
      completeHash: uniqueRow[usersTable]?['password_hash'],
    );
  }
}
