import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:numberpicker/numberpicker.dart';

class EditarExamenAlumno extends StatefulWidget {
  String? comentarioAlumno;
  double? notaElegida;
  Alumno alumno;
  Examen examen;
  DateTime? fechaPropuesta;
  Usuario user;
  String notaExamen;
  EditarExamenAlumno(
      {super.key,
      required this.examen,
      required this.user,
      required this.alumno,
      required this.notaExamen,
      this.comentarioAlumno});

  @override
  State<EditarExamenAlumno> createState() => _EditarExamenAlumnoState();
}

class _EditarExamenAlumnoState extends State<EditarExamenAlumno> {
  TextEditingController controllerDescripcionExamen = TextEditingController();
  TextEditingController controllerComentarioAlumno = TextEditingController();

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () {
        print("");
        widget.notaElegida != null
            ? widget.notaElegida = double.parse(widget.notaExamen)
            : widget.notaElegida = 10;
        widget.comentarioAlumno != "null"
            ? controllerComentarioAlumno.text = widget.comentarioAlumno!
            : controllerComentarioAlumno;
        widget.examen.descripcion != null || widget.examen.descripcion != "null"
            ? controllerDescripcionExamen.text = widget.examen.descripcion!
            : controllerDescripcionExamen;
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Editor de examen'),
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
                  "Editor de examen",
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
                        controller: controllerDescripcionExamen,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Descripción del examen*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerComentarioAlumno,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText:
                              "Comentario acerca de ${widget.alumno.nombre}*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nota del examen*",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DecimalNumberPicker(
                            axis: Axis.horizontal,
                            value: widget.notaElegida == null
                                ? 0
                                : widget.notaElegida!,
                            minValue: 0,
                            maxValue: 10,
                            decimalPlaces: 2,
                            onChanged: (value) =>
                                setState(() => widget.notaElegida = value),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Trimestre*",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                                  value: widget.examen.trimestre,
                                  onChanged: (value) => setState(
                                      () => widget.examen.trimestre = value),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Fecha del examen*",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
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
                                  widget.fechaPropuesta = time;
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
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        widget.fechaPropuesta != null
                                            ? widget.fechaPropuesta
                                                .toString()
                                                .split(" ")
                                                .first
                                            : "No se ha seleccionado una fecha*",
                                        style: TextStyle(
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
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        widget.fechaPropuesta != null
                                            ? Utils.formatTimeString(widget
                                                .fechaPropuesta
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
                                controllerComentarioAlumno.text,
                                widget.notaElegida,
                                widget.fechaPropuesta,
                                context,
                              );
                            },
                            child: const Text("Editar examen"),
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

  comprobarCampos(String? descripcion, String? comentario, double? calificacion,
      DateTime? fechaPropuesta, BuildContext context) async {
    if (calificacion == null || fechaPropuesta == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ExamenesBBDD().editarExamenAlumno(
          widget.examen,
          descripcion,
          comentario,
          calificacion.toString(),
          fechaPropuesta,
          widget.alumno,
          widget.user,
          widget.examen.trimestre,
          widget.notaElegida.toString());

      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Examen modificado")));
    }
  }
}
