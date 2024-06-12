import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CrearAlumno extends StatefulWidget {
  final Clase clase;

  const CrearAlumno({super.key, required this.clase});

  @override
  State<CrearAlumno> createState() => _CrearAlumnoState();
}

class _CrearAlumnoState extends State<CrearAlumno> {
  TextEditingController controllerNombreAlumno = TextEditingController();
  TextEditingController controllerApellidoAlumno = TextEditingController();
  DateTime? fechaNacimiento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Crear Alumno'),
      ),
      body: SingleChildScrollView(
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
              const Center(
                child: Text(
                  "Crear alumno",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controllerNombreAlumno,
                        decoration: const InputDecoration(
                          labelText: "Nombre del alumno*",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerApellidoAlumno,
                        decoration: const InputDecoration(
                          labelText: "Apellido del alumno*",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Fecha de nacimiento",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Color azul principal
                          ),
                        ),
                      ),
                      const Divider(height: 10),
                      Card(
                        child: InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(DateTime.now().year - 20, 1, 1),
                              maxTime: DateTime.now(),
                              currentTime: DateTime.now(),
                              locale: LocaleType.es,
                              onConfirm: (time) async {
                                setState(() {
                                  fechaNacimiento = time;
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 20),
                                Flexible(
                                  child: Text(
                                    // ignore: unnecessary_null_comparison
                                    fechaNacimiento != null
                                        ? fechaNacimiento
                                            .toString()
                                            .split(" ")
                                            .first
                                        : "No se ha seleccionado una fecha*",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              comprobarCampos(
                                  controllerNombreAlumno.text,
                                  controllerApellidoAlumno.text,
                                  fechaNacimiento,
                                  widget.clase,
                                  context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text("Crear alumno"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void comprobarCampos(String nombre, String apellido,
      DateTime? fechaNacimiento, Clase clase, BuildContext context) async {
    if (nombre.isEmpty || apellido.isEmpty || fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No están rellenos todos los campos"),
        ),
      );
    } else {
      await AlumnosBBDD().crearAlumno(nombre, apellido, fechaNacimiento, clase);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alumno creado")),
      );
    }
  }
}
