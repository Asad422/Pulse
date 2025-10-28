import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<void> requestOtp({
    required String email,
    required String login,
  });

  Future<AuthTokens> verifyOtp({
    required String email,
    required String code,
  });

  Future<AuthTokens> refresh(String refreshToken);
}
