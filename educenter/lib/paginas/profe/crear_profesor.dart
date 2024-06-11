import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';

class CrearProfesor extends StatefulWidget {
  final Centro centro;

  const CrearProfesor({super.key, required this.centro});

  @override
  State<CrearProfesor> createState() => _CrearProfesorState();
}

class _CrearProfesorState extends State<CrearProfesor> {
  Clase? claseSeleccionada;
  List<DropdownMenuItem> itemsDropDown = List.empty(growable: true);
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorApellido = TextEditingController();
  TextEditingController controladorDNI = TextEditingController();
  TextEditingController controladorEmailContacto = TextEditingController();
  TextEditingController controladorEmailUsuario = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      List<Clase> clases = await ClasesBBDD().getClasesSinTutor(widget.centro);
      for (var clase in clases) {
        itemsDropDown.add(DropdownMenuItem(
          value: clase,
          child: Text(clase.nombre_clase),
        ));
      }
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Crear Profesor'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add,
                  size: 100,
                  color: Colors.blue, // Color azul principal
                ),
                const SizedBox(height: 20),
                const Text(
                  "Crear Profesor",
                  style: TextStyle(
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
                          controller: controladorEmailUsuario,
                          decoration: const InputDecoration(
                            labelText: "Email de usuario*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
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
                        loading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Clases sin tutor:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  DropdownButton(
                                    hint: const Text("Clases..."),
                                    isExpanded: true,
                                    items: itemsDropDown,
                                    value: claseSeleccionada,
                                    onChanged: (value) {
                                      setState(() {
                                        claseSeleccionada = value as Clase?;
                                      });
                                    },
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controladorNombre.text,
                              controladorApellido.text,
                              controladorDNI.text,
                              controladorEmailContacto.text,
                              controladorEmailUsuario.text,
                              context,
                            );
                          },
                          child: const Text("Crear"),
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
      String emailContacto, String emailUsuario, BuildContext context) async {
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        dni.isEmpty ||
        emailContacto.isEmpty ||
        emailUsuario.isEmpty ||
        claseSeleccionada == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No están rellenos todos los campos")),
      );
    } else {
      await ProfesoresBBDD().crearProfesor(
        nombre,
        apellido,
        dni,
        emailContacto,
        emailUsuario,
        claseSeleccionada!,
        widget.centro,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profesor creado")),
      );
    }
  }
}
