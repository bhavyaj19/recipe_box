import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/models/user.dart' as model;
import 'package:recipe_box/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  child: GestureDetector(
                    onTap: _signOut,
                    child: const Row(
                      children: [
                        Icon(Icons.logout_rounded),
                        SizedBox(width: 8), // Add spacing
                        Text("Logout"),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.delete_forever_rounded),
                        SizedBox(width: 8), // Add spacing
                        Text("Delete"),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight, // Align the icon to the bottom right corner
                  children: [
                    const SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF4a4458),
                        child: Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_rounded),
                      onPressed: () {
                        // Handle the profile image change here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Add vertical spacing
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text(
                        user!.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
