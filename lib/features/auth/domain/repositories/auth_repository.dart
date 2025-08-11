import '../entities/user_entity.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_credentials_dto.dart';
import '../../data/models/login_response_dto.dart';
import '../../data/models/refresh_token_dto.dart';

abstract interface class AuthRepository {
  Future<UserEntity> register(RegisterDto dto);
  Future<LoginResponseDto> login(AuthCredentialsDto dto);
  Future<String> refreshToken(RefreshTokenDto dto);
  Future<void> logout(String refreshToken);
  Future<UserEntity> getCurrentUser();
  Future<void> requestPasswordReset(PasswordResetDto dto);
  Future<void> resetPassword(ResetPasswordDto dto);
}
