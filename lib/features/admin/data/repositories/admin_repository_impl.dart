import '../sources/admin_remote_source.dart';
import '../models/admin_stats.dart';

abstract interface class AdminRepository {
  Future<AdminStats> getStats();
  Future<List<Map<String, dynamic>>> getUsers({int page});
}

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remote);
  final AdminRemoteSource _remote;

  @override
  Future<AdminStats> getStats() => _remote.fetchStats();

  @override
  Future<List<Map<String, dynamic>>> getUsers({int page = 1}) => _remote.fetchUsers(page: page);
}
