import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasourses/auth_remote_ds.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._ds);

  final AuthRemoteDataSource _ds;

  @override
  Future<void> requestOtp({required String email, required String login}) {
    return _ds.requestOtp(email: email, login: login);
  }

  @override
  Future<AuthTokens> verifyOtp({required String email, required String code}) {
    return _ds.verifyOtp(email: email, code: code);
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) {
    return _ds.refresh(refreshToken);
  }
}
