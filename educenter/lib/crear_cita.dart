import 'package:educenter/bbdd/citas_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CrearCita extends StatefulWidget {
  Alumno? alumnoSeleccionado;
  Color colorTitulo = Colors.white;
  Color colorDescripcion = Colors.white;
  Color colorFecha = Colors.white;
  DateTime? fechaPropuesta;
  Alumno? alumno;
  List<Alumno>? alumnosDeTutor;
  Usuario? tutor;
  CrearCita({super.key, this.alumno, this.alumnosDeTutor, this.tutor});

  @override
  State<CrearCita> createState() => _CrearCitaState();
}

class _CrearCitaState extends State<CrearCita> {
  dynamic elementoSeleccionado;
  List<DropdownMenuItem> dropDownItems = List.empty(growable: true);
  bool loading = true;
  TextEditingController controllerTitulo = TextEditingController();
  TextEditingController controllerDescripcion = TextEditingController();
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        if (widget.tutor != null) {
          widget.alumnosDeTutor =
              await ProfesoresBBDD().getAlumnosClaseTutor(widget.tutor!);
          widget.alumnosDeTutor!.forEach((alumno) {
            dropDownItems.add(DropdownMenuItem(
                value: alumno,
                child: Text("${alumno.nombre} ${alumno.apellido}")));
          });
          setState(() {
            loading = false;
          });
        }
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
                  "Creacion de cita",
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
                        hint: const Text("Alumnos..."),
                        items: dropDownItems,
                        value: elementoSeleccionado,
                        onChanged: (value) {
                          setState(() {
                            widget.alumnoSeleccionado = value;
                            elementoSeleccionado = value;
                          });
                        },
                      ),
                TextField(
                  controller: controllerTitulo,
                  decoration: InputDecoration(
                      label: Text(
                    "Titulo*",
                    style: TextStyle(color: widget.colorTitulo),
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controllerDescripcion,
                    maxLines: 8, //or null
                    decoration: InputDecoration(
                      label: Text(
                        "Razón de la cita...*",
                      ),
                      hintText: "Introduce la razón de la cita...",
                    ),
                  ),
                )),
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
                              Icon(
                                Icons.calendar_month_outlined,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                // ignore: unnecessary_null_comparison
                                widget.fechaPropuesta != null
                                    ? widget.fechaPropuesta
                                        .toString()
                                        .split(" ")
                                        .first
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
                                widget.fechaPropuesta != null
                                    ? Utils.formatTimeString(widget
                                        .fechaPropuesta
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
                          comprobarCampos(
                              controllerDescripcion.text,
                              controllerTitulo.text,
                              widget.fechaPropuesta,
                              context);
                        },
                        child: Text("Crear cita"))
                  ],
                )
              ],
            ),
          ),
        ));
  }

  comprobarCampos(String text, String text2, DateTime? fechaPropuesta,
      BuildContext context) async {
    if (text.isEmpty ||
        text2.isEmpty ||
        fechaPropuesta == null ||
        widget.alumnoSeleccionado == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await CitasBBDD().crearCitaProfesor(
          controllerTitulo.text,
          controllerDescripcion.text,
          fechaPropuesta,
          widget.alumnoSeleccionado!,
          widget.tutor!);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cita creada")));
    }
  }
}
