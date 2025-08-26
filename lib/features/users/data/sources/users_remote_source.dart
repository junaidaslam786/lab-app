import 'package:dio/dio.dart';
import '../models/user_dto.dart';
import '../models/create_user_dto.dart';
import '../models/update_user_dto.dart';

class UsersRemoteSource {
  UsersRemoteSource(this._dio);
  final Dio _dio;

  /// GET /users  -> ServiceResponse<User[]>
  Future<List<UserDto>> findAll() async {
    try {
      print('Fetching users from API...');
      final res = await _dio.get('/users');
      print('Users API response: ${res.data}');

      // Handle different response structures
      dynamic data;
      if (res.data is Map<String, dynamic>) {
        data = res.data['data'];
      } else {
        data = res.data;
      }

      final list = (data as List?) ?? const [];
      final users =
          list.map((j) => UserDto.fromJson(j as Map<String, dynamic>)).toList();

      print('Parsed ${users.length} users');
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  /// POST /users  -> ServiceResponse<User>
  Future<UserDto> createUser(CreateUserDto dto) async {
    try {
      print('Creating user: ${dto.toJson()}');
      final res = await _dio.post('/users', data: dto.toJson());
      print('Create user response: ${res.data}');

      // Handle different response structures
      dynamic data;
      if (res.data is Map<String, dynamic>) {
        data = res.data['data'];
      } else {
        data = res.data;
      }

      return UserDto.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// GET /users/:id -> ServiceResponse<User>
  Future<UserDto> findById(String id) async {
    try {
      print('Fetching user by ID: $id');
      final res = await _dio.get('/users/$id');
      print('User API response: ${res.data}');

      // Handle different response structures
      dynamic data;
      if (res.data is Map<String, dynamic>) {
        data = res.data['data'];
      } else {
        data = res.data;
      }

      return UserDto.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching user by ID: $e');
      rethrow;
    }
  }

  /// PATCH /users/:id -> ServiceResponse<User>
  Future<UserDto> updateUser(String id, UpdateUserDto dto) async {
    try {
      print('Updating user $id: ${dto.toJson()}');
      final res = await _dio.patch('/users/$id', data: dto.toJson());
      print('Update user response: ${res.data}');

      // Handle different response structures
      dynamic data;
      if (res.data is Map<String, dynamic>) {
        data = res.data['data'];
      } else {
        data = res.data;
      }

      return UserDto.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// DELETE /users/:id -> ServiceResponse<void>
  Future<void> deleteUser(String id) async {
    try {
      print('Deleting user: $id');
      await _dio.delete('/users/$id');
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}
