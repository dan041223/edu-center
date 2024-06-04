import 'package:educenter/bbdd/users_bbdd.dart';
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
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

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
                loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (loading) {
                            return;
                          }
                          setState(() {
                            loading = true;
                          });
                          await usersBBDD().signInWithEmail(
                              controllerEmail.text,
                              controllerPass.text,
                              context,
                              () => {
                                    setState(() {
                                      loading = false;
                                    })
                                  });
                        },
                        child: const Text("Login")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (loading) {
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      usersBBDD().signInWithEmail(
                          "padre@email.com",
                          "padre",
                          context,
                          () => {
                                setState(() {
                                  loading = false;
                                })
                              });
                    },
                    child: const Text("LoginPadre")),
                ElevatedButton(
                    onPressed: () {
                      if (loading) {
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      usersBBDD().signInWithEmail(
                          "profesor@email.com",
                          "profe",
                          context,
                          () => {
                                setState(() {
                                  loading = false;
                                })
                              });
                    },
                    child: const Text("LoginProfe")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (loading) {
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      usersBBDD().signInWithEmail(
                          "admin@email.com",
                          "admin",
                          context,
                          () => {
                                setState(() {
                                  loading = false;
                                })
                              });
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
