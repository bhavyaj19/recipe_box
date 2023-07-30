import 'package:flutter/material.dart';
import 'package:recipe_box/screens/login_screen.dart';
import 'package:recipe_box/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: SignupScreen(),
      ),
    );
  }
}
