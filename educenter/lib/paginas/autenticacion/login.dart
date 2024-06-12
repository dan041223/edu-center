import 'package:educenter/bbdd/users_bbdd.dart';
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
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school,
                  size: 100,
                  color: Colors.blue, // Color azul principal
                ),
                const SizedBox(height: 20),
                const Text(
                  "EduCenter",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Color azul principal
                  ),
                ),
                const SizedBox(height: 50),
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerEmail,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controllerPass,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Aquí iría la lógica para recuperar la contraseña
                            },
                            child: const Text(
                              "¿Olvidaste la contraseña?",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: const Text("Login"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Botón azul
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "O inicia sesión como:",
                  style: TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 10),
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
                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text("Padre"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Botón azul
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
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
                            "profesor",
                            context,
                            () => {
                                  setState(() {
                                    loading = false;
                                  })
                                });
                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text("Profesor"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Botón azul
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
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
                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text("Admin"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Botón azul
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
