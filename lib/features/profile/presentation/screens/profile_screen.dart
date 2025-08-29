import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
