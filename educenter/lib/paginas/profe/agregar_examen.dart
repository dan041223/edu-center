import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:numberpicker/numberpicker.dart';

// ignore: must_be_immutable
class AgregarExamen extends StatefulWidget {
  dynamic elementoSeleccionado1;
  dynamic elementoSeleccionado2;
  Usuario profe;
  AgregarExamen({super.key, required this.profe});

  @override
  State<AgregarExamen> createState() => _AgregarExamenState();
}

class _AgregarExamenState extends State<AgregarExamen> {
  List<Clase> clasesDeProfesor = List.empty(growable: true);
  List<Asignatura> asignaturasDeClase = List.empty(growable: true);
  bool loading = true;
  Clase? claseSeleccionada;
  Asignatura? asignaturaSeleccionada;
  List<DropdownMenuItem> dropDownItemsClases = List.empty(growable: true);
  List<DropdownMenuItem> dropDownItemsAsignaturas = List.empty(growable: true);
  TextEditingController controllerDescripcionExamen = TextEditingController();
  DateTime? fechaPropuesta;
  int trimestre = 1;
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () async {
        clasesDeProfesor =
            await ProfesoresBBDD().getClasesProfesor(widget.profe);
        for (var clase in clasesDeProfesor) {
          dropDownItemsClases.add(
              DropdownMenuItem(value: clase, child: Text(clase.nombre_clase)));
        }
        setState(() {
          loading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Agregar Examen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.assignment,
                size: 100,
                color: Colors.blue, // Color azul principal
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Agregar examen",
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
                      DropdownButtonFormField<Clase>(
                        decoration: const InputDecoration(
                          labelText: "Seleccionar clase*",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                        ),
                        value: claseSeleccionada,
                        items: clasesDeProfesor.map((clase) {
                          return DropdownMenuItem<Clase>(
                            value: clase,
                            child: Text(clase.nombre_clase),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          claseSeleccionada = value;
                          asignaturasDeClase = await ClasesBBDD()
                              .getAsignaturasClaseProfesor(
                                  claseSeleccionada!.id_clase, widget.profe);
                          asignaturaSeleccionada = null;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Asignatura>(
                        decoration: const InputDecoration(
                          labelText: "Seleccionar asignatura*",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.book),
                        ),
                        value: asignaturaSeleccionada,
                        items: asignaturasDeClase.map((asignatura) {
                          return DropdownMenuItem<Asignatura>(
                            value: asignatura,
                            child: Text(asignatura.nombre_asignatura),
                          );
                        }).toList(),
                        onChanged: (value) {
                          asignaturaSeleccionada = value;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerDescripcionExamen,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: "Descripción del examen*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Trimestre*",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: NumberPicker(
                                        axis: Axis.horizontal,
                                        minValue: 1,
                                        maxValue: 3,
                                        value: trimestre,
                                        onChanged: (value) =>
                                            setState(() => trimestre = value),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: InkWell(
                          onTap: () {
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(DateTime.now().year + 2, 1, 1),
                              currentTime: DateTime.now(),
                              locale: LocaleType.es,
                              onConfirm: (time) async {
                                setState(() {
                                  fechaPropuesta = time;
                                });
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        fechaPropuesta != null
                                            ? fechaPropuesta
                                                .toString()
                                                .split(" ")
                                                .first
                                            : "No se ha seleccionado una fecha*",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.watch_later,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        fechaPropuesta != null
                                            ? Utils.formatTimeString(
                                                fechaPropuesta!
                                                    .toString()
                                                    .split(" ")
                                                    .last)
                                            : "No se ha seleccionado hora*",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
                                controllerDescripcionExamen.text,
                                fechaPropuesta,
                                widget.profe,
                                context,
                              );
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
                            child: const Text("Crear examen"),
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

  comprobarCampos(String descripcion, DateTime? fechaPropuesta, Usuario profe,
      BuildContext context) async {
    if (descripcion.isEmpty ||
        fechaPropuesta == null ||
        claseSeleccionada == null ||
        asignaturaSeleccionada == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ExamenesBBDD().crearExamen(descripcion, trimestre,
          claseSeleccionada!, asignaturaSeleccionada!, fechaPropuesta, profe);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Examen creado")));
    }
  }
}
