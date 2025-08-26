import 'package:json_annotation/json_annotation.dart';

part 'update_user_dto.g.dart';

@JsonSerializable()
class UpdateUserDto {
  final String? email;
  final String? fullName;
  final String? password;
  final String? roleId;

  const UpdateUserDto({
    this.email,
    this.fullName,
    this.password,
    this.roleId,
  });

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);

  UpdateUserDto copyWith({
    String? email,
    String? fullName,
    String? password,
    String? roleId,
  }) {
    return UpdateUserDto(
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
    );
  }
}
