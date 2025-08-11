import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String email;
  @JsonKey(name: 'role', fromJson: _roleFromJson)
  final String role;
  final String? fullName;
  final String? roleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserDto({
    required this.id,
    required this.email,
    required this.role,
    this.fullName,
    this.roleId,
    this.createdAt,
    this.updatedAt,
  });

  // Custom JSON converter for role field
  static String _roleFromJson(dynamic roleData) {
    if (roleData is String) {
      return roleData; // Direct string value
    } else if (roleData is Map<String, dynamic>) {
      return roleData['name'] ?? 'user'; // Extract name from role object
    }
    return 'user'; // Fallback
  }

  // Custom getter
  bool get isAdmin => role == 'admin';

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  // Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      role: role,
      name: fullName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          role == other.role &&
          fullName == other.fullName &&
          roleId == other.roleId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      role.hashCode ^
      fullName.hashCode ^
      roleId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'UserDto(id: $id, email: $email, role: $role, fullName: $fullName, roleId: $roleId, createdAt: $createdAt, updatedAt: $updatedAt)';
}
