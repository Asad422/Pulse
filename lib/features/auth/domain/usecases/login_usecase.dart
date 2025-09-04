import 'package:injectable/injectable.dart';

import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<AuthTokens> call({
    required String login,
    required String password,
  }) {
    return _repo.login(login: login, password: password);
  }
}
