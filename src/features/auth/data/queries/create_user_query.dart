import '../../../../core/database/query_parser.dart';
import '../../domain/errors/errors.dart';
import '../data_models/user_data_model.dart';

class CreateUserQuery extends QueryParser<UserDataModel> {
  static const _tableName = "systemuser";

  CreateUserQuery({
    required String fullName,
    required String email,
    required String? phone,
    required String passwordHash,
  }) : super(
          queryString: """
INSERT INTO $_tableName (complete_name, email, phone_number, password_hash)
    values (@fullName, @email, @phone, @passwordHash) returning *;
""",
          variables: {
            'fullName': fullName,
            'email': email,
            'phone': phone ?? 'null',
            'passwordHash': passwordHash,
          },
        );

  @override
  UserDataModel fromDbRowsMaps(List<Map<String, Map<String, dynamic>>> dbResult) {
    final uniqueRow = dbResult.singleOrNull;
    if (uniqueRow == null) throw UserNotFound(null);

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
