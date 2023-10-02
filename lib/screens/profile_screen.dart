import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/models/user.dart' as model;
import 'package:recipe_box/providers/user_provider.dart';
import 'package:recipe_box/resources/firestore_method.dart';
import 'package:recipe_box/screens/auth_screens/login_screen.dart';
import 'package:recipe_box/utils/colors.dart';
import 'package:recipe_box/widgets/text_feild_input.dart';
import 'package:recipe_box/resources/auth_method.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEditing = false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> deleteUserAccount(String username, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Authenticate user
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email.toString(), password: password);

        await user.reauthenticateWithCredential(credential);
        // delete account
        await user.delete();
        print("deleted");
        // delete posts
        FirestoreMethod firestoreMethod = FirestoreMethod();
        await firestoreMethod.deletePostByUsername(username);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> _updateUsername(UserProvider userProvider) async {
    model.User? user = userProvider.getUser;
    String newUsername = _newUsernameController.text.trim();
    if (newUsername != user?.username) {
      AuthMethod authMethod = AuthMethod();
      await authMethod.updateUserUsername(newUsername);
      FirestoreMethod firestoreMethod = FirestoreMethod();
      await firestoreMethod.updateUserUsername(user!.username, newUsername);

      // Refresh user data from Firestore and update the provider
      await userProvider.refreshUser();

      setState(() {
        isEditing = false;
      });
    } else {
      print("user exist krta hai");
      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text("Delete Account?"),
                                content:
                                    const Text("You will loose all your data"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text("Password"),
                                                actions: [
                                                  TextFeildInput(
                                                      textEditingController:
                                                          _passwordController,
                                                      hintText:
                                                          "Enter Password",
                                                      textInputType:
                                                          TextInputType.text),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Cancel")),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await deleteUserAccount(
                                                          user!.username,
                                                          _passwordController
                                                              .text);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .red[200]),
                                                    child: const Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 170, 0, 0)),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[200]),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 170, 0, 0)),
                                    ),
                                  ),
                                ],
                              ));
                    },
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
                const Stack(
                  alignment: Alignment
                      .bottomRight, // Align the icon to the bottom right corner
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        backgroundColor: AppColors.accentColor,
                        child: Icon(
                          Icons.person_rounded,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
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
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              _newUsernameController.text = user.username;
                              isEditing = true;
                            });
                          },
                          icon: const Icon(Icons.edit_rounded)),
                    ),
                    if (isEditing) ...[
                      ListTile(
                        title: TextFeildInput(
                          textEditingController: _newUsernameController,
                          hintText: "update username",
                          textInputType: TextInputType.text,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _updateUsername(userProvider);
                            },
                            child: const Text("Update"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[200],
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 170, 0, 0)),
                            ),
                          ),
                        ],
                      )
                    ],
                    ListTile(
                      title: Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
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
