import '../../../../core/database/query_parser.dart';
import '../../../../core/database/tables.dart';
import '../data_models/user_data_model.dart';

final class CreateUserQuery implements QueryParser<UserDataModel> {
  @override
  final String queryString = """
INSERT INTO $usersTable (complete_name, email, phone_number, password_hash)
    values (@fullName, @email, @phone, @passwordHash) returning *;
""";
  @override
  final Map<String, dynamic> variables;

  CreateUserQuery({
    required String fullName,
    required String email,
    required String? phone,
    required String passwordHash,
  }) : variables = {
          'fullName': fullName,
          'email': email,
          'phone': phone ?? 'null',
          'passwordHash': passwordHash,
        };

  @override
  UserDataModel fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {
    final uniqueRow = dbResult.single;

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
