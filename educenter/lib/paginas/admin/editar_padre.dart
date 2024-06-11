import 'package:educenter/bbdd/padres_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class EditarPadre extends StatefulWidget {
  final Centro centro;
  final Usuario padre;

  const EditarPadre({super.key, required this.padre, required this.centro});

  @override
  State<EditarPadre> createState() => _EditarPadreState();
}

class _EditarPadreState extends State<EditarPadre> {
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerDni = TextEditingController();
  TextEditingController controllerEmailContacto = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerNombre.text = widget.padre.nombre;
    controllerApellido.text = widget.padre.apellido;
    controllerDni.text = widget.padre.dni;
    controllerEmailContacto.text = widget.padre.email_contacto ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Editar Padre/Madre'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.blue, // Color azul principal
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Editar a ${widget.padre.nombre}",
                    style: const TextStyle(
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
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controllerNombre.text,
                              controllerApellido.text,
                              controllerDni.text,
                              controllerEmailContacto.text,
                              context,
                            );
                          },
                          child: const Text("Editar padre/madre"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
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
      String emailContacto, BuildContext context) async {
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        dni.isEmpty ||
        emailContacto.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No están rellenos todos los campos")),
      );
    } else {
      await padresBBDD().editarPadre(
        nombre,
        apellido,
        dni,
        emailContacto,
        widget.centro,
        widget.padre,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Padre/madre editado")),
      );
    }
  }
}
