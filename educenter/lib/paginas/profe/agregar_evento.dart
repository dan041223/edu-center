// ignore_for_file: use_build_context_synchronously

import 'package:educenter/bbdd/eventos_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AgregarEvento extends StatefulWidget {
  Usuario profesor;
  AgregarEvento({super.key, required this.profesor});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  Color color = Colors.lightBlue;
  String colorSeleccionado = "";
  List<Clase> listaClasesSeleccionadas = List.empty(growable: true);
  List<ValueItem> listaClasesDropdown = List.empty(growable: true);
  List<ValueItem> listaClasesDropdownSeleccionadas = List.empty(growable: true);
  DateTime? fechaInicioPropuesta;
  DateTime? fechaFinPropuesta;
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerDescripcion = TextEditingController();
  TextEditingController controllerUbicacion = TextEditingController();
  dynamic tipoEventoSeleccionadaDyn;
  String tipoEventoSeleccionada = "";
  List<DropdownMenuItem> items = List.empty(growable: true);
  List<String> tiposEvento = Utils.tiposEvento;
  bool loading = true;
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        List<Clase> listaClases =
            await ProfesoresBBDD().getClasesProfesor(widget.profesor);
        for (var clase in listaClases) {
          listaClasesDropdown
              .add(ValueItem(label: clase.nombre_clase, value: clase));
        }
        for (var element in tiposEvento) {
          items.add(DropdownMenuItem(
            value: element,
            child: Text(element),
          ));
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
        title: const Text('Crear Evento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event,
                size: 100,
                color: Colors.blue, // Color azul principal
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Crear evento",
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
                        decoration: const InputDecoration(
                          labelText: "Tipo de evento*",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event),
                        ),
                        value: tipoEventoSeleccionadaDyn,
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            tipoEventoSeleccionadaDyn = value;
                            tipoEventoSeleccionada = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      loading
                          ? CircularProgressIndicator()
                          : MultiSelectDropDown(
                              hint: "Clases a las que impartes...",
                              fieldBackgroundColor: Utils.hexToColor("#1c272b"),
                              dropdownBackgroundColor:
                                  Utils.hexToColor("#1c272b"),
                              optionsBackgroundColor:
                                  Utils.hexToColor("#1c272b"),
                              onOptionSelected: (selectedOptions) {
                                setState(() {
                                  listaClasesDropdownSeleccionadas =
                                      selectedOptions;
                                  listaClasesSeleccionadas = selectedOptions
                                      .map((e) => e.value as Clase)
                                      .toList();
                                });
                              },
                              options: listaClasesDropdown),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerNombre,
                        decoration: const InputDecoration(
                          labelText: "Nombre del evento*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerDescripcion,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          labelText: "Descripción del evento*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerUbicacion,
                        decoration: const InputDecoration(
                          labelText: "Ubicación del evento*",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Selector de color*",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ColorPicker(
                        pickerColor: color,
                        onColorChanged: (value) {
                          setState(() {
                            color = value;
                            colorSeleccionado = Utils.colorToString(color);
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Fecha de inicio*",
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
                                  fechaInicioPropuesta = time;
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
                                        fechaInicioPropuesta != null
                                            ? fechaInicioPropuesta
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
                                        fechaInicioPropuesta != null
                                            ? Utils.formatTimeString(
                                                fechaInicioPropuesta!
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
                      const Text(
                        "Fecha final*",
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
                                  fechaFinPropuesta = time;
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
                                        fechaFinPropuesta != null
                                            ? fechaFinPropuesta
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
                                        fechaFinPropuesta != null
                                            ? Utils.formatTimeString(
                                                fechaFinPropuesta!
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
                                colorSeleccionado,
                                controllerUbicacion.text,
                                tipoEventoSeleccionada,
                                listaClasesSeleccionadas,
                                controllerNombre.text,
                                controllerDescripcion.text,
                                fechaInicioPropuesta,
                                fechaFinPropuesta,
                                widget.profesor,
                                context,
                              );
                            },
                            child: const Text("Crear evento"),
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

  comprobarCampos(
      String color,
      String ubicacion,
      String tipoEvento,
      List<Clase> clasesSeleccionadas,
      String nombre,
      String descripcion,
      DateTime? fechaInicioPropuesta,
      DateTime? fechaFinPropuesta,
      Usuario profe,
      BuildContext context) async {
    if (ubicacion.isEmpty ||
        tipoEvento.isEmpty ||
        nombre.isEmpty ||
        descripcion.isEmpty ||
        fechaInicioPropuesta == null ||
        fechaFinPropuesta == null ||
        clasesSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await EventosBBDD().crearEvento(
          profe,
          color,
          ubicacion,
          tipoEvento,
          clasesSeleccionadas,
          nombre,
          descripcion,
          fechaInicioPropuesta,
          fechaFinPropuesta);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Evento creado")));
    }
  }
}
