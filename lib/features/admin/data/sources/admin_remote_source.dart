import 'package:dio/dio.dart';
import '../models/admin_stats.dart';

class AdminRemoteSource {
  AdminRemoteSource(this._dio);
  final Dio _dio;

  Future<AdminStats> fetchStats() async {
    final res = await _dio.get('/admin/stats');
    return AdminStats.fromJson(res.data);
  }

  Future<List<Map<String, dynamic>>> fetchUsers({int page = 1}) async {
    final res = await _dio.get('/admin/users', queryParameters: {'page': page});
    return (res.data as List).cast<Map<String, dynamic>>();
  }
}
