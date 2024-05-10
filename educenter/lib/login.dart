import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/main_menu.dart';
import 'package:educenter/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              "Login",
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
                ElevatedButton(
                    onPressed: () async {
                      usersBBDD().signInWithEmail(
                          controllerEmail.text, controllerPass.text, context);
                    },
                    child: const Text("Login")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ));
                    },
                    child: const Text("Sign Up")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      usersBBDD()
                          .signInWithEmail("padre@email.com", "padre", context);
                    },
                    child: const Text("LoginPadre")),
                ElevatedButton(
                    onPressed: () {
                      usersBBDD().signInWithEmail(
                          "profesor@email.com", "profe", context);
                    },
                    child: const Text("LoginProfe")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      usersBBDD()
                          .signInWithEmail("admin@email.com", "admin", context);
                    },
                    child: const Text("LoginAdmin")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
