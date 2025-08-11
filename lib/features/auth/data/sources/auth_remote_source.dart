import 'package:dio/dio.dart';
import '../models/auth_tokens.dart';
import '../models/user_dto.dart';

class AuthRemoteSource {
  AuthRemoteSource(this._dio);
  final Dio _dio;

  Future<(UserDto, AuthTokens)> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    final user = UserDto.fromJson(res.data['user']);
    final tokens = AuthTokens.fromJson(res.data['tokens']);
    return (user, tokens);
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout'); // optional server-side token invalidation
  }

  Future<UserDto> me() async {
    final res = await _dio.get('/auth/me');
    return UserDto.fromJson(res.data);
  }
}
