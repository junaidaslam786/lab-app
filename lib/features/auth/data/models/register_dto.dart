import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDto {
  final String email;
  final String password;
  final String fullName;
  final String? roleId;

  const RegisterDto({
    required this.email,
    required this.password,
    required this.fullName,
    this.roleId,
  });

  factory RegisterDto.fromJson(Map<String, dynamic> json) => _$RegisterDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterDtoToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterDto &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          fullName == other.fullName &&
          roleId == other.roleId;

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      fullName.hashCode ^
      roleId.hashCode;

  @override
  String toString() =>
      'RegisterDto(email: $email, password: [HIDDEN], fullName: $fullName, roleId: $roleId)';
}
