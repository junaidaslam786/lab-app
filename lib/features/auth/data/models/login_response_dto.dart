import 'package:json_annotation/json_annotation.dart';
import 'user_dto.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  final String accessToken;
  final String refreshToken;
  final UserDto user;

  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginResponseDto &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          user == other.user;

  @override
  int get hashCode =>
      accessToken.hashCode ^
      refreshToken.hashCode ^
      user.hashCode;

  @override
  String toString() =>
      'LoginResponseDto(accessToken: [HIDDEN], refreshToken: [HIDDEN], user: $user)';
}
