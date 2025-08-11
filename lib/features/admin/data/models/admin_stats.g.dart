// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => AdminStats(
  totalUsers: (json['totalUsers'] as num).toInt(),
  activeUsers: (json['activeUsers'] as num).toInt(),
  monthlySignups: (json['monthlySignups'] as num).toInt(),
);

Map<String, dynamic> _$AdminStatsToJson(AdminStats instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'activeUsers': instance.activeUsers,
      'monthlySignups': instance.monthlySignups,
    };
