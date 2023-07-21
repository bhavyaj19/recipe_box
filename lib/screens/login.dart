import 'package:flutter/material.dart';
import 'package:recipe_box/widgets/text_input_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Login"),
          SizedBox(height: 10),
          TextFeildInput(
              textEditingController: _emailController,
              hintText: "Enter Email",
              textInputType: TextInputType.text),
          const SizedBox(height: 10),
          TextFeildInput(
              textEditingController: _passwordController,
              hintText: "Enter Password",
              textInputType: TextInputType.text,
              isPass: true),
          SizedBox(height: 10),
          // ElevatedButton(onPressed: () {}, child: const Text("Submit"))
        ],
      ),
    );
  }
}
