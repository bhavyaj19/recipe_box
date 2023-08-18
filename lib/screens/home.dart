import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_box/screens/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToTab() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TabScreen()));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
            children: [
              Text(FirebaseAuth.instance.currentUser!.email.toString()),
              ElevatedButton(
                onPressed: _signOut,
                child: const Text("Log out"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                  onPressed: navigateToTab, child: const Text("Tab Screen"))
            ],
          ),
        ),
      ),
    );
  }
}
