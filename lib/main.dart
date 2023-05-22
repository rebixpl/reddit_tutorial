import 'package:flutter/material.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit Tutorial',
      theme: Pallete.darkModeAppTheme,
      home: const SizedBox(),
    );
  }
}
