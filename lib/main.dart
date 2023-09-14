import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/providers/user_provider.dart';
import 'package:recipe_box/screens/login/signup/login_screen.dart';
import 'package:recipe_box/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDfrQJmcShwZsAO7yGjRR9lvu6cPyPnpqc",
      appId: "1:638163581320:android:fea8162b3e228cc828e23d",
      messagingSenderId: "638163581320",
      projectId: "recipebox-c1053",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(useMaterial3: true),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const TabScreen();
                  }
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 231, 231, 231),
                    ),
                  );
                }
                return const LoginScreen();
              })),
    );
  }
}
