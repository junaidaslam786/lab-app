import '../../../users/data/models/create_user_dto.dart';
import '../../../users/data/models/update_user_dto.dart';
import '../../../users/data/models/user_dto.dart';

abstract interface class UsersRepository {
  Future<List<UserDto>> findAll();
  Future<UserDto> findById(String id);
  Future<UserDto> createUser(CreateUserDto dto);
  Future<UserDto> updateUser(String id, UpdateUserDto dto);
  Future<void> deleteUser(String id);
}
