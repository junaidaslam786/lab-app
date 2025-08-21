import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  AuthRepositoryImpl(this._dio, this._storage);
  final Dio _dio;
  final FlutterSecureStorage _storage;

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
  Future<LoginResponseDto> login(AuthCredentialsDto credentials) async {
    try {
      print('🔐 Attempting login for: ${credentials.email}');
      
      final response = await _dio.post('/auth/login', data: credentials.toJson());
      print('Login Response: ${response.data}');
      
      if (response.statusCode == 200) {
        final loginResponse = LoginResponseDto.fromJson(response.data['data']);
        
        // Store tokens immediately after successful login
        await _storage.write(key: 'access_token', value: loginResponse.accessToken);
        await _storage.write(key: 'refresh_token', value: loginResponse.refreshToken);
        
        print('✅ Tokens stored successfully');
        print('Access Token: ${loginResponse.accessToken.substring(0, 50)}...');
        
        return loginResponse;
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
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
