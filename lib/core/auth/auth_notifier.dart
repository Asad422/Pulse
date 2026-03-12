import 'package:flutter/foundation.dart';

import '../network/token_storage.dart';

/// Listenable that tracks authentication state.
/// GoRouter uses this via `refreshListenable` to re-evaluate `redirect`
/// whenever auth status changes (login / logout).
class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._tokenStorage);

  final TokenStorage _tokenStorage;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  /// Call once at startup to read the initial token state.
  Future<void> init() async {
    final token = await _tokenStorage.readRefreshToken();
    _isLoggedIn = token != null && token.isNotEmpty;
  }

  /// Call after successful login / token write.
  void setLoggedIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Call on logout / token clear.
  void setLoggedOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
