import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/register_dto.dart';
import '../../data/models/auth_credentials_dto.dart';
import '../../../../core/config/env.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(dioProvider));
});

// Auth state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
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
      // You'll need to store refresh token somewhere to pass it here
      await _repo.logout(''); // Empty string for now
      state = const AsyncValue.data(null);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }
}
