import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:recipe_box/screens/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providerConfigs: const [
                EmailProviderConfiguration(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                          'https://images-platform.99static.com//CH5AFmVy3tp7wTX3l4d6lCNSQ4o=/724x723:1316x1315/fit-in/500x500/99designs-contests-attachments/144/144904/attachment_144904334')),
                );
              },
            );
          }
          return const TempLogin();
        });
  }
}
