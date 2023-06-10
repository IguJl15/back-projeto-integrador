import 'dart:async';

import '../dto/create_user_dto.dart';
import '../models/user.dart';

abstract interface class AuthRepository {
  // user
  FutureOr<User> saveUser(CreateUserDto createUserDto);
  FutureOr<User?> getUser(String id);
  FutureOr<User?> getUserByEmail(String email);

  // user tokens
  Future<void> saveRefreshToken(String jti, String userId);
  Future<void> deleteToken(String jwtId);
}
