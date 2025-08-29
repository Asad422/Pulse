import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: FilledButton.tonal(
          onPressed: () => context.go(AppPaths.login), // “logout” пока просто уводит на логин
          child: const Text('Logout (mock)'),
        ),
      ),
    );
  }
}
