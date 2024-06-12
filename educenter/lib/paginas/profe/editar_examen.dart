import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:numberpicker/numberpicker.dart';

// ignore: must_be_immutable
class EditarExamen extends StatefulWidget {
  double? notaElegida;
  int trimestre = 1;
  Examen examen;
  DateTime? fechaPropuesta;
  Usuario user;
  EditarExamen({
    super.key,
    required this.examen,
    required this.user,
  });

  @override
  State<EditarExamen> createState() => _EditarExamenState();
}

class _EditarExamenState extends State<EditarExamen> {
  TextEditingController controllerDescripcionExamen = TextEditingController();
  @override
  void initState() {
    controllerDescripcionExamen.text =
        (widget.examen.descripcion == null ? "" : widget.examen.descripcion!);
    setState(() {});
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
                Icons.edit,
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
                      const Text(
                        "Trimestre:*",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
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
                                        value: widget.trimestre,
                                        onChanged: (value) => setState(
                                            () => widget.trimestre = value),
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
                                    const Icon(Icons.calendar_today),
                                    const SizedBox(width: 20),
                                    Flexible(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        widget.fechaPropuesta != null
                                            ? widget.fechaPropuesta
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
                                    const Icon(Icons.watch_later),
                                    const SizedBox(width: 20),
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
                          TextButton(
                            onPressed: () async {
                              comprobarCampos(
                                controllerDescripcionExamen.text,
                                widget.fechaPropuesta,
                                context,
                              );
                            },
                            child: const Text("Editar examen"),
                          )
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

  comprobarCampos(String? descripcion, DateTime? fechaPropuesta,
      BuildContext context) async {
    if (fechaPropuesta == null || descripcion == null || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ExamenesBBDD().editarExamen(
        widget.examen,
        descripcion,
        fechaPropuesta,
        widget.user,
        widget.trimestre,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Examen modificado")));
    }
  }
}
