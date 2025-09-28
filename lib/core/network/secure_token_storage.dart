import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../features/auth/domain/entities/auth_tokens.dart';
import 'token_storage.dart';

/// Реализация [TokenStorage] через FlutterSecureStorage
@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _s;
  SecureTokenStorage(this._s);

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  @override
  Future<String?> readAccessToken() => _s.read(key: _kAccess);

  @override
  Future<String?> readRefreshToken() => _s.read(key: _kRefresh);

  @override
  Future<void> writeTokens(AuthTokens tokens) async {
    await _s.write(key: _kAccess, value: tokens.accessToken);
    await _s.write(key: _kRefresh, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    await _s.delete(key: _kAccess);
    await _s.delete(key: _kRefresh);
  }
}
