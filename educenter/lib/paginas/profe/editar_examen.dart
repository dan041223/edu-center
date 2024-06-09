import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:numberpicker/numberpicker.dart';

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Editor de examen",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controllerDescripcionExamen,
                  maxLines: 3, //or null
                  decoration: const InputDecoration(
                    label: Text(
                      "Descripcion examen*",
                    ),
                  ),
                ),
              )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Trimestre:*",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                NumberPicker(
                                  axis: Axis.horizontal,
                                  minValue: 1,
                                  maxValue: 3,
                                  value: widget.trimestre,
                                  onChanged: (value) =>
                                      setState(() => widget.trimestre = value),
                                )
                              ],
                            ))),
                  ),
                ],
              ),
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
                            const Icon(Icons.calendar_month_outlined),
                            const SizedBox(width: 20),
                            Text(
                              // ignore: unnecessary_null_comparison
                              widget.fechaPropuesta != null
                                  ? widget.fechaPropuesta
                                      .toString()
                                      .split(" ")
                                      .first
                                  : "No se ha seleccionado una fecha*",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.watch_later_outlined,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              // ignore: unnecessary_null_comparison
                              widget.fechaPropuesta != null
                                  ? Utils.formatTimeString(widget.fechaPropuesta
                                      .toString()
                                      .split(" ")
                                      .last)
                                  : "No se ha seleccionado hora*",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        comprobarCampos(controllerDescripcionExamen.text,
                            widget.fechaPropuesta, context);
                      },
                      child: const Text("Editar examen"))
                ],
              )
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

      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Examen modificado")));
    }
  }
}
