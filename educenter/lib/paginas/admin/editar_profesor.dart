import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class EditarProfesor extends StatefulWidget {
  final Centro centro;
  final Usuario profesor;

  const EditarProfesor(
      {super.key, required this.profesor, required this.centro});

  @override
  State<EditarProfesor> createState() => _EditarProfesorState();
}

class _EditarProfesorState extends State<EditarProfesor> {
  Clase? claseDeTutor;
  Clase? claseSeleccionada;
  List<DropdownMenuItem> itemsDropDown = List.empty(growable: true);
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorApellido = TextEditingController();
  TextEditingController controladorDNI = TextEditingController();
  TextEditingController controladorEmailContacto = TextEditingController();
  int controladorIdClaseTutor = 0;
  bool esTutor = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    esTutor = widget.profesor.id_clase != null;
    controladorIdClaseTutor = widget.profesor.id_clase ?? 0;
    controladorNombre.text = widget.profesor.nombre;
    controladorApellido.text = widget.profesor.apellido;
    controladorDNI.text = widget.profesor.dni;
    controladorEmailContacto.text = widget.profesor.email_contacto ?? '';
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Editar Profesor'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.edit,
                  size: 100,
                  color: Colors.blue, // Color azul principal
                ),
                const SizedBox(height: 20),
                Text(
                  "Modificar a ${widget.profesor.nombre}",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Color azul principal
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
                          controller: controladorNombre,
                          decoration: const InputDecoration(
                            labelText: "Nombre*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controladorApellido,
                          decoration: const InputDecoration(
                            labelText: "Apellido*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controladorDNI,
                          decoration: const InputDecoration(
                            labelText: "DNI*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: controladorEmailContacto,
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
                              controladorNombre.text,
                              controladorApellido.text,
                              controladorDNI.text,
                              controladorEmailContacto.text,
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
                          child: const Text("Modificar"),
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

  void comprobarCampos(String nombre, String apellido, String dni, String email,
      BuildContext context) async {
    if (nombre.isEmpty || apellido.isEmpty || dni.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No están rellenos todos los campos")),
      );
    } else {
      await ProfesoresBBDD()
          .modificarProfesor(nombre, apellido, dni, email, widget.profesor);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profesor modificado")),
      );
    }
  }
}
