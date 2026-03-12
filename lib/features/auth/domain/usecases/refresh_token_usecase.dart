import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class RefreshTokenUseCase {
  final AuthRepository _repo;
  RefreshTokenUseCase(this._repo);

  Future<Either<Failure, AuthTokens>> call(String refreshToken) {
    return _repo.refresh(refreshToken);
  }
}
