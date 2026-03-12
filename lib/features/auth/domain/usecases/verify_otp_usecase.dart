import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class VerifyOtpUseCase {
  final AuthRepository _repo;
  VerifyOtpUseCase(this._repo);

  Future<Either<Failure, AuthTokens>> call({required String email, required String code}) {
    return _repo.verifyOtp(email: email, code: code);
  }
}
