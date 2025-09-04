import 'package:injectable/injectable.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasourses/auth_remote_ds.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._ds);

  final AuthRemoteDataSource _ds;

  @override
  Future<AuthTokens> login({required String login, required String password}) {
    return _ds.login(login: login, password: password);
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) {
    return _ds.refresh(refreshToken);
  }
}
