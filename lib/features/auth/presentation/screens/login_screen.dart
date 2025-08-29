import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Login form…'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go(AppPaths.home), // сразу в приложение
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => context.go(AppPaths.register),
            child: const Text('Go to Register'),
          ),
        ]),
      ),
    );
  }
}
