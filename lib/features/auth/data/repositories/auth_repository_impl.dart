import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pulse/core/failure/failure.dart';
import 'package:pulse/core/network/data/mapper.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_ds.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._ds);

  final AuthRemoteDataSource _ds;

  @override
  Future<Either<Failure, void>> requestOtp({
    required String email,
    required String login,
  }) =>
      safeCall(() => _ds.requestOtp(email: email, login: login));

  @override
  Future<Either<Failure, AuthTokens>> verifyOtp({
    required String email,
    required String code,
  }) =>
      safeCall(() => _ds.verifyOtp(email: email, code: code));

  @override
  Future<Either<Failure, AuthTokens>> refresh(String refreshToken) =>
      safeCall(() => _ds.refresh(refreshToken));
}
