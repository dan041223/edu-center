import 'package:educenter/bbdd/padres_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:flutter/material.dart';

class AgregarPadre extends StatefulWidget {
  final Centro centro;
  const AgregarPadre({super.key, required this.centro});

  @override
  State<AgregarPadre> createState() => _AgregarPadreState();
}

class _AgregarPadreState extends State<AgregarPadre> {
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerDni = TextEditingController();
  TextEditingController controllerEmailContacto = TextEditingController();
  TextEditingController controllerEmailUsuario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Agregar Padre/Madre'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.family_restroom,
                  size: 100,
                  color: Colors.blue, // Color azul principal
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Crear padre o madre",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Color azul principal
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
                          controller: controllerNombre,
                          decoration: const InputDecoration(
                            labelText: "Nombre*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controllerApellido,
                          decoration: const InputDecoration(
                            labelText: "Apellido*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controllerDni,
                          decoration: const InputDecoration(
                            labelText: "DNI*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controllerEmailContacto,
                          decoration: const InputDecoration(
                            labelText: "Email de contacto*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.contact_mail),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controllerEmailUsuario,
                          decoration: const InputDecoration(
                            labelText: "Email de usuario*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controllerNombre.text,
                              controllerApellido.text,
                              controllerDni.text,
                              controllerEmailContacto.text,
                              controllerEmailUsuario.text,
                              context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text("Crear padre/madre"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void comprobarCampos(String nombre, String apellido, String dni,
      String emailContacto, String emailUsuario, BuildContext context) async {
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        dni.isEmpty ||
        emailContacto.isEmpty ||
        emailUsuario.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      try {
        await padresBBDD().crearPadre(nombre, apellido, dni, emailContacto,
            emailUsuario, widget.centro, context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ya existe un usuario con esos datos")));
      }
    }
  }
}
