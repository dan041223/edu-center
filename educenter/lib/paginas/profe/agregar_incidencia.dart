import 'package:educenter/bbdd/incidencia_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Creacion de incidencia",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                isExpanded: true,
                hint: const Text("Tipos de incidencia..."),
                items: items,
                value: tipoIncidenciaSeleccionadaDyn,
                onChanged: (value) {
                  tipoIncidenciaSeleccionada = value;
                  tipoIncidenciaSeleccionadaDyn = value;
                  setState(() {});
                },
              ),
              TextField(
                controller: controllerTitulo,
                decoration: InputDecoration(
                    label: Text(
                  "Titulo*",
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
                      "Razón de la incidencia...*",
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
                                  ? Utils.formatTimeString(
                                      fechaPropuesta.toString().split(" ").last)
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
                        comprobarCampos(
                            controllerDescripcion.text,
                            controllerTitulo.text,
                            fechaPropuesta,
                            Utils.stringToTipoIncidencia(
                                tipoIncidenciaSeleccionada),
                            context);
                      },
                      child: Text("Crear incidencia"))
                ],
              )
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
