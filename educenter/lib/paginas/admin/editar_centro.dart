import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class EditarCentro extends StatefulWidget {
  Centro centro;
  EditarCentro({super.key, required this.centro});

  @override
  State<EditarCentro> createState() => _EditarCentroState();
}

class _EditarCentroState extends State<EditarCentro> {
  Color color = Colors.lightBlue;
  String colorSeleccionado = "";
  TimeOfDay? horarioAperturaActual;
  TimeOfDay? horarioCierreActual;
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorUbicacion = TextEditingController();
  TextEditingController controladorEmail = TextEditingController();
  TextEditingController controladorTelefono = TextEditingController();
  @override
  void initState() {
    colorSeleccionado = widget.centro.color;
    color = Utils.hexToColor(colorSeleccionado);
    controladorNombre.text = widget.centro.nombre_centro;
    controladorUbicacion.text = widget.centro.direccion_centro;
    controladorEmail.text = widget.centro.email_centro;
    horarioAperturaActual = widget.centro.horario_centro_inicio;
    horarioCierreActual = widget.centro.horario_centro_fin;
    controladorTelefono.text = widget.centro.telefono.toString();
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
            children: [
              Text(
                "Editar centro",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controladorNombre,
                decoration: InputDecoration(
                    label: Text(
                  "Nombre del centro*",
                )),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                "Horarios de apertura y salida:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 20,
              ),
              GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {
                        DatePicker.showTime12hPicker(
                          context,
                          locale: LocaleType.es,
                          onConfirm: (time) {
                            setState(() {
                              horarioAperturaActual =
                                  TimeOfDay.fromDateTime(time);
                            });
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                size: 80,
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 80,
                              ),
                            ],
                          ),
                          Text(
                            Utils.timeOfDayToString(horarioAperturaActual
                                .toString()
                                .split(" ")
                                .last),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        DatePicker.showTime12hPicker(
                          context,
                          locale: LocaleType.es,
                          onConfirm: (time) {
                            setState(() {
                              horarioCierreActual =
                                  TimeOfDay.fromDateTime(time);
                            });
                          },
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                size: 80,
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                size: 80,
                              ),
                            ],
                          ),
                          Text(
                            Utils.timeOfDayToString(
                                horarioCierreActual.toString().split(" ").last),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controladorUbicacion,
                decoration: InputDecoration(
                    label: Text(
                  "Ubicacion del centro*",
                )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controladorEmail,
                decoration: InputDecoration(
                    label: Text(
                  "Correo electronico del centro*",
                )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controladorTelefono,
                decoration: InputDecoration(
                    label: Text(
                  "Telefono del centro*",
                )),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ColorPicker(
                    pickerColor: color,
                    onColorChanged: (value) {
                      setState(() {
                        color = value;
                        colorSeleccionado = Utils.colorToString(color);
                      });
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        comprobarCampos(
                            controladorNombre.text,
                            controladorEmail.text,
                            controladorUbicacion.text,
                            horarioAperturaActual,
                            horarioCierreActual,
                            controladorTelefono.text,
                            context);
                      },
                      child: const Text("Editar centro"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(
      String nombre,
      String email,
      String ubicacion,
      TimeOfDay? horarioAperturaActual,
      TimeOfDay? horarioCierreActual,
      String telefono,
      BuildContext context) async {
    if (nombre.isEmpty ||
        ubicacion.isEmpty ||
        ubicacion.isEmpty ||
        telefono.isEmpty ||
        horarioAperturaActual == null ||
        horarioCierreActual == null ||
        telefono.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await CentroBBDD().editarCentro(
          nombre,
          ubicacion,
          email,
          horarioAperturaActual,
          horarioCierreActual,
          widget.centro,
          telefono,
          colorSeleccionado);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Alumno editado")));
    }
  }
}
