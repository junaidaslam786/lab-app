import 'package:dio/dio.dart';
import '../models/register_dto.dart';
import '../models/auth_credentials_dto.dart';
import '../models/login_response_dto.dart';
import '../models/refresh_token_dto.dart';
import '../models/api_response.dart';
import '../models/user_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/config/env.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<UserEntity> register(RegisterDto dto) async {
    try {
      final response = await _dio.post(
        '${Env.apiBaseUrl}/auth/register',
        data: dto.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }

      final userData = UserDto.fromJson(apiResponse.data!);
      return userData.toEntity();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<LoginResponseDto> login(AuthCredentialsDto dto) async {
    try {
      final response = await _dio.post(
        '${Env.apiBaseUrl}/auth/login',
        data: dto.toJson(),
      );

      print('Login Response: ${response.data}');

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }

      print('API Response Data: ${apiResponse.data}');

      return LoginResponseDto.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<String> refreshToken(RefreshTokenDto dto) async {
    try {
      final response = await _dio.post(
        '${Env.apiBaseUrl}/auth/refresh',
        data: dto.toJson(),
      );

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }

      return apiResponse.data!['accessToken'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Token refresh failed');
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(
        '${Env.apiBaseUrl}/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Logout failed');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _dio.post('${Env.apiBaseUrl}/auth/me');

      final apiResponse = ApiResponse.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message);
      }

      final userData = UserDto.fromJson(apiResponse.data!);
      return userData.toEntity();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get user');
    }
  }

  @override
  Future<void> requestPasswordReset(PasswordResetDto dto) async {
    try {
      await _dio.post(
        '${Env.apiBaseUrl}/auth/password-forgot',
        data: dto.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Password reset request failed');
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordDto dto) async {
    try {
      await _dio.post(
        '${Env.apiBaseUrl}/auth/reset-password',
        data: dto.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Password reset failed');
    }
  }
}
