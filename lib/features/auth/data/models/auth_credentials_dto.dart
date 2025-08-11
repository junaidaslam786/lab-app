import 'package:json_annotation/json_annotation.dart';

part 'auth_credentials_dto.g.dart';

@JsonSerializable()
class AuthCredentialsDto {
  final String email;
  final String password;

  const AuthCredentialsDto({
    required this.email,
    required this.password,
  });

  factory AuthCredentialsDto.fromJson(Map<String, dynamic> json) => _$AuthCredentialsDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuthCredentialsDtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCredentialsDto &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;

  @override
  String toString() => 'AuthCredentialsDto(email: $email, password: [HIDDEN])';
}
