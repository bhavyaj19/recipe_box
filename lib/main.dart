import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/firebase_options.dart';
// import 'package:recipe_box/screens/login.dart';
import 'package:recipe_box/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// PENDING FROM https://firebase.google.com/codelabs/firebase-auth-in-flutter-apps#3
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
        body: MyApp(),
      ),
    );
  }
}
