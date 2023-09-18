// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/resources/auth_method.dart';
import 'package:recipe_box/screens/auth_screens/login_screen.dart';
import 'package:recipe_box/screens/main_screen.dart';
import 'package:recipe_box/widgets/text_feild_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) => checkEmailVerification(),
    );
  }

  void checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (_usernameController.text.isNotEmpty && user != null) {
      await user.reload();

      if (user.emailVerified) {
        timer?.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TabScreen(),
          ),
        );
      } else {
        print("Email not verified yet");
      }
    }
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethod().signupUser(
      email: _emailController.text,
      password: _passController.text,
      username: _usernameController.text,
    );

    setState(() {
      _isLoading = false;
    });

    final user = FirebaseAuth.instance.currentUser;
    print(res);

    if (res == "success") {
      if (user != null && user.emailVerified) {
        timer?.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TabScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("An Email Verification Link was sent to your Email Id"),
          ),
        );
      }
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "CookBook",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFeildInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                TextFeildInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFeildInput(
                  textEditingController: _passController,
                  hintText: 'Enter your Password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : signupUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Sign Up"),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
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
