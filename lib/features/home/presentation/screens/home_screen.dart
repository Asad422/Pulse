import 'package:flutter/material.dart';

import '../../../../core/widgets/showcase_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text('title')),
        body: const ButtonsShowcase(),
      );
}
