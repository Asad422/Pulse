// lib/core/network/token_storage.dart
import '../../features/auth/domain/entities/auth_tokens.dart';

abstract class TokenStorage {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> writeTokens(AuthTokens tokens);
  Future<void> clear();
}
