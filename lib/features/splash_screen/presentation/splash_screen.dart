import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/token_storage.dart';
import '../../../core/resources/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app/di/di.dart';
import '../../../core/router/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final tokenStorage = sl<TokenStorage>();
    try {
      final refreshToken = await tokenStorage.readRefreshToken();
      if (!mounted) return;

      FlutterNativeSplash.remove();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        context.go(AppPaths.politicians);
      } else {
        context.go(AppPaths.login);
      }
    } catch (_) {
      await tokenStorage.clear();
      if (!mounted) return;
      FlutterNativeSplash.remove();
      context.go(AppPaths.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: AppIcons.icLogo.svg(
            width: 180,
            height: 95,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
