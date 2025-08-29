import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: AppColors.background, body: Center(child: Text('Search')));
}
