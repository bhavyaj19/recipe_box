import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_box/screens/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    print(snap.data());
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
    });
    print(username);
  }

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
              Text('hello user: $username'),
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
