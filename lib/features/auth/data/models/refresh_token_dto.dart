import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_dto.g.dart';

@JsonSerializable()
class RefreshTokenDto {
  final String refreshToken;

  const RefreshTokenDto({
    required this.refreshToken,
  });

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) => _$RefreshTokenDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$RefreshTokenDtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefreshTokenDto &&
          runtimeType == other.runtimeType &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode => refreshToken.hashCode;

  @override
  String toString() => 'RefreshTokenDto(refreshToken: [HIDDEN])';
}

@JsonSerializable()
class PasswordResetDto {
  final String email;

  const PasswordResetDto({
    required this.email,
  });

  factory PasswordResetDto.fromJson(Map<String, dynamic> json) => _$PasswordResetDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$PasswordResetDtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordResetDto &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;

  @override
  String toString() => 'PasswordResetDto(email: $email)';
}

@JsonSerializable()
class ResetPasswordDto {
  final String token;
  final String password;

  const ResetPasswordDto({
    required this.token,
    required this.password,
  });

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) => _$ResetPasswordDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$ResetPasswordDtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResetPasswordDto &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          password == other.password;

  @override
  int get hashCode => token.hashCode ^ password.hashCode;

  @override
  String toString() => 'ResetPasswordDto(token: [HIDDEN], password: [HIDDEN])';
}
