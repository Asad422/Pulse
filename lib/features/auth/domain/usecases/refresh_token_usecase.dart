import 'package:injectable/injectable.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RefreshTokenUseCase {
  final AuthRepository _repo;
  RefreshTokenUseCase(this._repo);

  Future<AuthTokens> call(String refreshToken) {
    return _repo.refresh(refreshToken);
  }
}
