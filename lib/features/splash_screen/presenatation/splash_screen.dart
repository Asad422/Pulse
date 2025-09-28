import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/token_storage.dart';
import '../../../../app/di/di.dart';
import '../../../../core/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final tokenStorage = sl<TokenStorage>();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final refreshToken = await tokenStorage.readRefreshToken();

      if (!mounted) return;

      if (refreshToken != null && refreshToken.isNotEmpty) {
        // не вызываем refresh руками, доверяем AuthInterceptor
        context.go(AppPaths.home);
      } else {
        context.go(AppPaths.login);
      }
    } catch (_) {
      await tokenStorage.clear();
      if (!mounted) return;
      context.go(AppPaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
