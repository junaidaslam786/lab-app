import 'package:json_annotation/json_annotation.dart';

part 'admin_stats.g.dart';

@JsonSerializable()
class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int monthlySignups;

  const AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.monthlySignups,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) => _$AdminStatsFromJson(json);
  
  Map<String, dynamic> toJson() => _$AdminStatsToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminStats &&
          runtimeType == other.runtimeType &&
          totalUsers == other.totalUsers &&
          activeUsers == other.activeUsers &&
          monthlySignups == other.monthlySignups;

  @override
  int get hashCode =>
      totalUsers.hashCode ^
      activeUsers.hashCode ^
      monthlySignups.hashCode;

  @override
  String toString() =>
      'AdminStats(totalUsers: $totalUsers, activeUsers: $activeUsers, monthlySignups: $monthlySignups)';

  AdminStats copyWith({
    int? totalUsers,
    int? activeUsers,
    int? monthlySignups,
  }) {
    return AdminStats(
      totalUsers: totalUsers ?? this.totalUsers,
      activeUsers: activeUsers ?? this.activeUsers,
      monthlySignups: monthlySignups ?? this.monthlySignups,
    );
  }
}
