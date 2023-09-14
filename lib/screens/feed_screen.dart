import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/models/user.dart' as model;
import 'package:recipe_box/providers/user_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(user!.username),
          ),
          ElevatedButton(onPressed: _signOut, child: const Text("LogOut"))
        ],
      ),
    );
  }
}
