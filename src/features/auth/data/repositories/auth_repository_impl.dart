import 'dart:async';

import '../../../../core/database/database.dart';
import '../../domain/dto/create_user_dto.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../queries/create_user_query.dart';
import '../queries/get_user_by_id_query.dart';
import '../queries/get_users_by_email_query.dart';

final class AuthRepositoryImpl implements AuthRepository {
  DatabaseConnection dbConnection;

  AuthRepositoryImpl({
    required this.dbConnection,
  });

  @override
  Future<User> saveUser(CreateUserDto createUserDto) async {
    final query = CreateUserQuery(
      fullName: createUserDto.fullName,
      email: createUserDto.email,
      phone: createUserDto.phone,
      passwordHash: createUserDto.passwordHash,
    );

    final userDataModel = await dbConnection.query(query);

    return userDataModel.toEntity();
  }

  @override
  Future<User?> getUser(String id) async {
    final query = GetUserByIdQuery(id: id);
    final userDataModel = await dbConnection.query(query);

    return userDataModel.toEntity();
  }

  @override
  FutureOr<User?> getUserByEmail(String email) async {
    final query = GetUsersByEmailQuery(email: email);
    final dbResult = await dbConnection.query(query);

    if (dbResult.isEmpty) return null;

    return dbResult.first.toEntity();
  }
}
