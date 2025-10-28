import '../../features/auth/domain/entities/auth_tokens.dart';

/// Контракт для работы с токенами (хранилище)
abstract class TokenStorage {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> writeTokens(AuthTokens tokens);
  Future<void> clear();
}
