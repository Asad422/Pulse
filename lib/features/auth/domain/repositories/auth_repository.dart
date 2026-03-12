import 'package:dartz/dartz.dart';
import 'package:pulse/core/failure/failure.dart';

import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> requestOtp({
    required String email,
    required String login,
  });

  Future<Either<Failure, AuthTokens>> verifyOtp({
    required String email,
    required String code,
  });

  Future<Either<Failure, AuthTokens>> refresh(String refreshToken);
}
