import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sqflite Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Sqflite Demo'),
    );
  }
}
