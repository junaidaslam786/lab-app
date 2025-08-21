import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_credentials_dto.dart';
import '../../../../core/network/dio_client.dart';

// Secure storage provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Dio provider using DioClient with interceptors
final dioProvider = Provider<Dio>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient(secureStorage).build();
});

// Auth repository provider - now passing both required parameters
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(dio, secureStorage);
});

// Auth state provider
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
      return AuthNotifier(ref.watch(authRepositoryProvider));
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.loading()) {
    loadSession();
  }

  Future<void> loadSession() async {
    try {
      final user = await _repo.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final dto = AuthCredentialsDto(email: email, password: password);
      final loginResponse = await _repo.login(dto);
      state = AsyncValue.data(loginResponse.user.toEntity());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register(RegisterDto dto) async {
    try {
      await _repo.register(dto);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repo.logout('');
      state = const AsyncValue.data(null);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }
}
