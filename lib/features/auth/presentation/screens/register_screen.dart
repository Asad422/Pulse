import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Register form…'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go(AppPaths.home),
            child: const Text('Create account'),
          ),
        ]),
      ),
    );
  }
}
