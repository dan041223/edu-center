import 'package:educenter/bbdd/incidencia_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

// ignore: must_be_immutable
class AgregarIncidencia extends StatefulWidget {
  Usuario profesor;
  Alumno alumno;
  AgregarIncidencia({super.key, required this.alumno, required this.profesor});

  @override
  State<AgregarIncidencia> createState() => _AgregarIncidenciaState();
}

class _AgregarIncidenciaState extends State<AgregarIncidencia> {
  // bool loading = true;
  // @override
  // void initState() {Future.delayed(Duration(milliseconds: 1), () {
  //   setState(() {

  //     loading = false;
  //   });
  // },);
  //   super.initState();
  // }
  TextEditingController controllerTitulo = TextEditingController();
  TextEditingController controllerDescripcion = TextEditingController();
  DateTime? fechaPropuesta;
  dynamic tipoIncidenciaSeleccionadaDyn;
  String tipoIncidenciaSeleccionada = "";
  List<DropdownMenuItem> items = List.empty(growable: true);
  List<String> tiposIncidencia = Utils.tiposIncidencia;
  @override
  void initState() {
    for (var element in tiposIncidencia) {
      items.add(DropdownMenuItem(
        value: element,
        child: Text(element),
      ));
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Creación de incidencia'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.report_problem,
                size: 100,
                color: Colors.blue, // Color azul principal
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Creación de incidencia",
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
                      DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: "Tipos de incidencia*",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.error),
                        ),
                        hint: const Text("Selecciona el tipo de incidencia..."),
                        value: tipoIncidenciaSeleccionadaDyn,
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            tipoIncidenciaSeleccionada = value;
                            tipoIncidenciaSeleccionadaDyn = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerTitulo,
                        decoration: const InputDecoration(
                          labelText: "Título*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: controllerDescripcion,
                            maxLines: 8,
                            decoration: const InputDecoration(
                              labelText: "Razón de la incidencia...*",
                              border: OutlineInputBorder(),
                              hintText:
                                  "Introduce la razón de la incidencia...",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Fecha de la incidencia*",
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
                              minTime: DateTime(DateTime.now().year - 1, 1, 1),
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
                                      color: Colors.blue,
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
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Text(
                                        // ignore: unnecessary_null_comparison
                                        fechaPropuesta != null
                                            ? Utils.formatTimeString(
                                                fechaPropuesta
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
                            onPressed: () {
                              comprobarCampos(
                                controllerDescripcion.text,
                                controllerTitulo.text,
                                fechaPropuesta,
                                Utils.stringToTipoIncidencia(
                                    tipoIncidenciaSeleccionada),
                                context,
                              );
                            },
                            child: const Text("Crear incidencia"),
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

  comprobarCampos(String titulo, String descripcion, DateTime? fechaPropuesta,
      String tipoIncidenciaSeleccionada, BuildContext context) async {
    if (titulo.isEmpty ||
        descripcion.isEmpty ||
        fechaPropuesta == null ||
        tipoIncidenciaSeleccionada.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await IncidenciaBBDD().crearIncidencia(
          controllerTitulo.text,
          controllerDescripcion.text,
          fechaPropuesta,
          tipoIncidenciaSeleccionada,
          widget.alumno,
          widget.profesor);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Incidencia creada")));
    }
  }
}
