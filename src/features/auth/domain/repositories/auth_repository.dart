import '../dto/create_user_dto.dart';
import '../models/user.dart';

abstract class AuthRepository {
  User saveUser(CreateUserDto createUserDto);
  User? getUser(String id);
  User? getUserByEmail(String email);
}

class ListAuthRepository implements AuthRepository {
  final List<User> list = [];

  @override
  User? getUser(String id) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  User? getUserByEmail(String email) {
    return list.first;
  }

  @override
  User saveUser(CreateUserDto createUserDto) {
    list.add(createUserDto.toUser());
    return list.first;
  }
}
