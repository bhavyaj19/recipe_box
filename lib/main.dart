import 'package:flutter/material.dart';
import 'package:recipe_box/screens/login.dart';
import 'package:recipe_box/screens/temp_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RecipeBox",
      theme: ThemeData.dark(useMaterial3: true),
      home: const Scaffold(
        body: TempLogin(),
      ),
    );
  }
}
