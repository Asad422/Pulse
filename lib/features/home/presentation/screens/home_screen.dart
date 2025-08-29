import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/showcase_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text('title')),
        body: const ButtonsShowcase(),
      );
}
