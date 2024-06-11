import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditarCentro extends StatefulWidget {
  final Centro centro;

  const EditarCentro({Key? key, required this.centro}) : super(key: key);

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
    super.initState();
    loadData();
  }

  void loadData() {
    colorSeleccionado = widget.centro.color;
    color = Utils.hexToColor(colorSeleccionado);
    controladorNombre.text = widget.centro.nombre_centro;
    controladorUbicacion.text = widget.centro.direccion_centro;
    controladorEmail.text = widget.centro.email_centro;
    horarioAperturaActual = widget.centro.horario_centro_inicio;
    horarioCierreActual = widget.centro.horario_centro_fin;
    controladorTelefono.text = widget.centro.telefono.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        title: const Text('Editar Centro'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.business,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Editar centro",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
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
                      controller: controladorNombre,
                      decoration: const InputDecoration(
                        labelText: "Nombre del centro*",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Horarios de apertura y cierre:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20),
                    GridView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 1,
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
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 80,
                                ),
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 80,
                                ),
                                Text(
                                  Utils.timeOfDayToString(horarioAperturaActual
                                      .toString()
                                      .split(" ")
                                      .last),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
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
                                Icon(
                                  Icons.watch_later_outlined,
                                  size: 80,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 80,
                                ),
                                Text(
                                  Utils.timeOfDayToString(horarioCierreActual
                                      .toString()
                                      .split(" ")
                                      .last),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controladorUbicacion,
                      decoration: const InputDecoration(
                        labelText: "Ubicación del centro*",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controladorEmail,
                      decoration: const InputDecoration(
                        labelText: "Correo electrónico del centro*",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controladorTelefono,
                      decoration: const InputDecoration(
                        labelText: "Teléfono del centro*",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controladorNombre.text,
                              controladorEmail.text,
                              controladorUbicacion.text,
                              horarioAperturaActual,
                              horarioCierreActual,
                              controladorTelefono.text,
                            );
                          },
                          child: const Text("Editar centro"),
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
    );
  }

  void comprobarCampos(
    String nombre,
    String email,
    String ubicacion,
    TimeOfDay? horarioAperturaActual,
    TimeOfDay? horarioCierreActual,
    String telefono,
  ) async {
    if (nombre.isEmpty ||
        ubicacion.isEmpty ||
        email.isEmpty ||
        telefono.isEmpty ||
        horarioAperturaActual == null ||
        horarioCierreActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No están rellenos todos los campos")),
      );
    } else {
      await CentroBBDD().editarCentro(
        nombre,
        ubicacion,
        email,
        horarioAperturaActual,
        horarioCierreActual,
        widget.centro,
        telefono,
        colorSeleccionado,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Centro editado")),
      );
    }
  }
}
