// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_box/resources/auth_method.dart';
import 'package:recipe_box/screens/login/signup/login_screen.dart';
import 'package:recipe_box/screens/main_screen.dart';
import 'package:recipe_box/widgets/text_feild_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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
      Duration(seconds: 5),
      (Timer t) => checkEmailVerification(),
    );
  }

  void checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (_usernameController.text.isNotEmpty && user != null) {
      await user.reload(); // Reload user data to get the latest email verification status
      
      if (user.emailVerified) {
        timer?.cancel(); // Stop the timer once email is verified
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
      _isLoading = true;
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
            content: Text("An Email Verification Link was sent to your Email Id"),
          ),
        );
      }
    }
  }
  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              // usrname
              TextFeildInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text),
              const SizedBox(height: 24),
              // E-mail
              TextFeildInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              // Password
              TextFeildInput(
                textEditingController: _passController,
                hintText: 'Enter your Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24),
              // Login Button
              ElevatedButton(
                onPressed: signupUser,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 228, 228, 228),
                      ))
                    : const Text("Sign Up"),
              ),
              const SizedBox(height: 12),

              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("already have an account?"),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
