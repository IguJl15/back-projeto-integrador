import 'dart:async';

import '../dto/create_user_dto.dart';
import '../models/user.dart';

abstract interface class AuthRepository {
  // user
  FutureOr<User> saveUser(CreateUserDto createUserDto);
  FutureOr<User?> getUserOrNull(String id);
  FutureOr<User?> getUserByEmailOrNull(String email);

  // user tokens
  Future<void> saveRefreshToken(String jti, String userId);
  Future<void> deleteToken(String jwtId);
}
