import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/auth/screen/login_screen.dart';
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
      debugShowCheckedModeBanner: false,
      theme: Pallete.darkModeAppTheme,
      home: const LoginScreen(),
    );
  }
}
