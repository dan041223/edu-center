import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class EditarAlumno extends StatefulWidget {
  final Centro centro;
  final Alumno alumno;

  const EditarAlumno({Key? key, required this.alumno, required this.centro})
      : super(key: key);

  @override
  State<EditarAlumno> createState() => _EditarAlumnoState();
}

class _EditarAlumnoState extends State<EditarAlumno> {
  bool loading = true;
  List<Clase> listaClasesCentro = [];
  List<DropdownMenuItem<Clase>> itemsDropDown = [];
  TextEditingController controllerNombreAlumno = TextEditingController();
  TextEditingController controllerApellidoAlumno = TextEditingController();
  DateTime? fechaNacimiento;
  Clase? claseSeleccionada;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    controllerNombreAlumno.text = widget.alumno.nombre;
    controllerApellidoAlumno.text = widget.alumno.apellido;
    fechaNacimiento = widget.alumno.fecha_nacimiento;
    listaClasesCentro = await CentroBBDD().getClasesCentro(widget.centro);
    itemsDropDown = listaClasesCentro
        .map((clase) => DropdownMenuItem(
              value: clase,
              child: Text(clase.nombre_clase),
            ))
        .toList();
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
        title: const Text('Editar Alumno'),
      ),
      body: SingleChildScrollView(
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
              const Center(
                child: Text(
                  "Editar alumno",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
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
                                Icon(Icons.calendar_today),
                                SizedBox(width: 20),
                                Flexible(
                                  child: Text(
                                    // ignore: unnecessary_null_comparison
                                    fechaNacimiento != null
                                        ? formatDate(fechaNacimiento!)
                                        : "No se ha seleccionado una fecha*",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      loading
                          ? Center(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Clase actual de ${widget.alumno.nombre}: ${widget.alumno.clase.nombre_clase}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DropdownButton(
                                  items: itemsDropDown,
                                  value: claseSeleccionada,
                                  onChanged: (Clase? value) {
                                    setState(() {
                                      claseSeleccionada = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              comprobarCampos(
                                controllerNombreAlumno.text,
                                controllerApellidoAlumno.text,
                                fechaNacimiento,
                                claseSeleccionada,
                              );
                            },
                            child: const Text("Editar alumno"),
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

  void comprobarCampos(
    String nombre,
    String apellido,
    DateTime? fechaNacimiento,
    Clase? clase,
  ) async {
    if (nombre.isEmpty || apellido.isEmpty || fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No están rellenos todos los campos"),
        ),
      );
    } else {
      await AlumnosBBDD().editarAlumno(
        nombre,
        apellido,
        fechaNacimiento,
        clase,
        widget.alumno,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alumno editado")),
      );
    }
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}
