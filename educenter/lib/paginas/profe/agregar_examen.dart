import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:numberpicker/numberpicker.dart';

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
      Duration(milliseconds: 1),
      () async {
        clasesDeProfesor =
            await ProfesoresBBDD().getClasesProfesor(widget.profe);
        clasesDeProfesor.forEach((clase) {
          dropDownItemsClases.add(
              DropdownMenuItem(value: clase, child: Text(clase.nombre_clase)));
        });
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
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Creacion de examen",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                loading
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButton(
                        isExpanded: true,
                        hint: const Text("Clases"),
                        items: dropDownItemsClases,
                        value: widget.elementoSeleccionado1,
                        onChanged: (value) async {
                          claseSeleccionada = value;
                          widget.elementoSeleccionado1 = value;
                          asignaturasDeClase = await ClasesBBDD()
                              .getAsignaturasClaseProfesor(
                                  claseSeleccionada!.id_clase, widget.profe);
                          dropDownItemsAsignaturas.clear();
                          asignaturaSeleccionada = null;
                          widget.elementoSeleccionado2 = null;
                          setState(() {});
                          asignaturasDeClase.forEach((asignatura) {
                            dropDownItemsAsignaturas.add(DropdownMenuItem(
                                value: asignatura,
                                child: Text(asignatura.nombre_asignatura)));
                          });
                          setState(() {});
                        },
                      ),
                loading
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButton(
                        isExpanded: true,
                        hint: const Text("Asignaturas"),
                        items: dropDownItemsAsignaturas,
                        value: widget.elementoSeleccionado2,
                        onChanged: (value) {
                          setState(() {
                            asignaturaSeleccionada = value;
                            widget.elementoSeleccionado2 = value;
                          });
                        },
                      ),
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controllerDescripcionExamen,
                    maxLines: 8, //or null
                    decoration: InputDecoration(
                      label: Text(
                        "Descripcion del examen...*",
                      ),
                      hintText: "Introduce la descripcion del examen...",
                    ),
                  ),
                )),
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
                                    value: trimestre,
                                    onChanged: (value) =>
                                        setState(() => trimestre = value),
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
                              Icon(
                                Icons.calendar_month_outlined,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                // ignore: unnecessary_null_comparison
                                fechaPropuesta != null
                                    ? fechaPropuesta.toString().split(" ").first
                                    : "No se ha seleccionado una fecha*",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                fechaPropuesta != null
                                    ? Utils.formatTimeString(fechaPropuesta
                                        .toString()
                                        .split(" ")
                                        .last)
                                    : "No se ha seleccionado hora*",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                              fechaPropuesta, widget.profe, context);
                        },
                        child: const Text("Crear examen"))
                  ],
                )
              ],
            ),
          ),
        ));
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
