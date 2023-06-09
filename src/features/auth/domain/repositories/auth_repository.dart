import 'dart:async';

import '../dto/create_user_dto.dart';
import '../models/user.dart';

abstract class AuthRepository {
  FutureOr<User> saveUser(CreateUserDto createUserDto);
  FutureOr<User?> getUser(String id);
  FutureOr<User?> getUserByEmail(String email);
}
