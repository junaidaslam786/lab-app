class UserEntity {
  final String id;
  final String email;
  final String role;
  final String? name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.name,
  });

  // Add convenience getter for admin check
  bool get isAdmin => role == 'admin';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          role == other.role &&
          name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      role.hashCode ^
      name.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, email: $email, role: $role, name: $name)';

  // Create a copy with optional parameter changes
  UserEntity copyWith({
    String? id,
    String? email,
    String? role,
    String? name,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
    );
  }
}
