import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../data/models/auth_credentials_dto.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<UserEntity> call(String email, String password) async {
    final dto = AuthCredentialsDto(email: email, password: password);
    final loginResponse = await _repo.login(dto);
    return loginResponse.user.toEntity();
  }
}
