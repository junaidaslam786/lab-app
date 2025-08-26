import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:lab_app/features/users/data/models/create_user_dto.dart';
import 'package:lab_app/features/users/data/models/update_user_dto.dart';
import 'package:lab_app/features/users/data/models/user_dto.dart';
import 'package:lab_app/features/users/data/sources/users_remote_source.dart';
import 'package:lab_app/features/users/data/repositories/users_repository_impl.dart';
import 'package:lab_app/features/users/domain/repositories/users_repository.dart';

// <-- adjust import path to your actual dioProvider location
import 'package:lab_app/features/auth/presentation/providers/auth_providers.dart';

final usersRemoteProvider = Provider<UsersRemoteSource>((ref) {
  final dio = ref.watch(dioProvider); // same Dio with auth interceptor
  return UsersRemoteSource(dio);
});

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepositoryImpl(ref.watch(usersRemoteProvider)),
);

/// List all users with better error handling
final usersListProvider = FutureProvider<List<UserDto>>((ref) async {
  try {
    // Ensure we have a valid auth state before making the request
    final authState = ref.watch(authStateProvider);

    // Wait for auth state to be available
    if (authState.isLoading) {
      throw Exception('Authentication state is loading');
    }

    if (!authState.hasValue || authState.value == null) {
      throw Exception('User not authenticated');
    }

    final user = authState.value!;
    if (!user.isAdmin) {
      throw Exception('Insufficient permissions');
    }

    return await ref.watch(usersRepositoryProvider).findAll();
  } catch (e) {
    // Log the error for debugging
    print('Error fetching users: $e');
    rethrow;
  }
});


// Get single user by ID
final userByIdProvider = FutureProviderFamily<UserDto, String>((ref, id) async {
  try {
    return await ref.watch(usersRepositoryProvider).findById(id);
  } catch (e) {
    print('Error fetching user by ID: $e');
    rethrow;
  }
});

/// Create user controller (refreshes list on success)
class CreateUserController extends StateNotifier<AsyncValue<UserDto?>> {
  CreateUserController(this._ref, this._repo)
    : super(const AsyncValue.data(null));

  final Ref _ref;
  final UsersRepository _repo;

  Future<void> submit(CreateUserDto dto) async {
    state = const AsyncValue.loading();
    try {
      final created = await _repo.createUser(dto);
      // Refresh list after creation
      _ref.invalidate(usersListProvider);
      state = AsyncValue.data(created);
    } catch (e, st) {
      print('Error creating user: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final createUserControllerProvider =
    StateNotifierProvider<CreateUserController, AsyncValue<UserDto?>>(
      (ref) => CreateUserController(ref, ref.watch(usersRepositoryProvider)),
    );

  /// Update user controller
class UpdateUserController extends StateNotifier<AsyncValue<UserDto?>> {
  UpdateUserController(this._ref, this._repo)
      : super(const AsyncValue.data(null));

  final Ref _ref;
  final UsersRepository _repo;

  Future<void> submit(String userId, UpdateUserDto dto) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _repo.updateUser(userId, dto);
      // Refresh both the list and the individual user
      _ref.invalidate(usersListProvider);
      _ref.invalidate(userByIdProvider(userId));
      state = AsyncValue.data(updated);
    } catch (e, st) {
      print('Error updating user: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final updateUserControllerProvider =
    StateNotifierProvider<UpdateUserController, AsyncValue<UserDto?>>(
      (ref) => UpdateUserController(ref, ref.watch(usersRepositoryProvider)),
    );

/// Delete user controller
class DeleteUserController extends StateNotifier<AsyncValue<void>> {
  DeleteUserController(this._ref, this._repo)
      : super(const AsyncValue.data(null));

  final Ref _ref;
  final UsersRepository _repo;

  Future<void> delete(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteUser(userId);
      // Refresh the list after deletion
      _ref.invalidate(usersListProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      print('Error deleting user: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final deleteUserControllerProvider =
    StateNotifierProvider<DeleteUserController, AsyncValue<void>>(
      (ref) => DeleteUserController(ref, ref.watch(usersRepositoryProvider)),
    );
