import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 50),
            ),
            TextField(
              controller: controllerEmail,
              decoration: const InputDecoration(label: Text("Email")),
            ),
            TextField(
              controller: controllerPass,
              decoration: const InputDecoration(label: Text("Password")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("Login")),
                ElevatedButton(onPressed: () {}, child: const Text("Sign Up")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
