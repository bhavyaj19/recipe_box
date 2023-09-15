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

    // Make the following changes to the UI:

    // 1. Use a `SingleChildScrollView` to wrap the `Column` widget so that the UI can scroll if it is too long.
    // 2. Use a `SizedBox` widget to add some padding around the `CircleAvatar` widget.
    // 3. Use a `Card` widget to wrap the `Column` widget so that it has a border and a shadow.
    // 4. Use a `ListView` widget to display the username and email in a list, with each item in the list having its own `ListTile` widget.

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
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF4a4458), // Customize the avatar background color
                    child: Icon(
                      Icons.person_rounded,
                      size: 80,
                      color: Colors.white, // Customize the icon color
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Add vertical spacing
                ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: Text(
                        user!.username, // Replace with the user's name
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        user!.email, // Replace with the user's email
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
