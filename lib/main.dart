import 'package:flutter/material.dart';
import 'package:pulse/core/widgets/app_button_widget.dart';
import 'package:pulse/core/widgets/showcase_widget.dart'; // путь к вашему классу AppButtonWidget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buttons Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Buttons'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const ButtonsShowcase(),
      // body: AppButtonWidget.rightIcon(
      //   label: "Button",
      //   onPressed: () {},
      //   rightIcon: Icons.access_time_filled,
      //   tone: AppButtonWidgetTone.subtle
      // ),
    );
  }
}
