import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
        ),
        title: Text('Language', style: AppTextStyles.titleT3),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Text(
          'Coming soon',
          style: AppTextStyles.titleT2.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}
