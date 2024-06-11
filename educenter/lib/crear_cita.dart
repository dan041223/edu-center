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
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Crear Cita'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today,
                size: 100,
                color: Colors.blue, // Color azul principal
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Crear cita",
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
                      widget.tutor != null
                          ? DropdownButtonFormField<Alumno>(
                              decoration: const InputDecoration(
                                labelText: "Seleccionar alumno*",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              value: widget.alumnoSeleccionado,
                              items: widget.alumnosDeTutor?.map((alumno) {
                                return DropdownMenuItem<Alumno>(
                                  value: alumno,
                                  child: Text(
                                      "${alumno.nombre} ${alumno.apellido}"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  widget.alumnoSeleccionado = value;
                                });
                              },
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerTitulo,
                        decoration: const InputDecoration(
                          labelText: "Título*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerDescripcion,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: "Descripción*",
                          border: OutlineInputBorder(),
                        ),
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
                                  widget.fechaPropuesta = time;
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
                                    widget.fechaPropuesta != null
                                        ? widget.fechaPropuesta
                                            .toString()
                                            .split(" ")
                                            .first
                                        : "No se ha seleccionado una fecha*",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                controllerTitulo.text,
                                controllerDescripcion.text,
                                widget.fechaPropuesta,
                                context,
                              );
                            },
                            child: const Text("Crear cita"),
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
