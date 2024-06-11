import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CrearAsignatura extends StatefulWidget {
  final Centro centro;
  final Clase clase;

  CrearAsignatura({Key? key, required this.clase, required this.centro})
      : super(key: key);

  @override
  State<CrearAsignatura> createState() => _CrearAsignaturaState();
}

class _CrearAsignaturaState extends State<CrearAsignatura> {
  bool loading = true;
  List<Usuario> profesoresCentro = [];
  List<DropdownMenuItem> items = [];
  Usuario? profeSeleccionado;
  Color color = Colors.lightBlue;
  String colorSeleccionado = "";
  TextEditingController controllerNombreAsignatura = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    profesoresCentro = await CentroBBDD().getProfesoresCentro(widget.centro);
    setState(() {
      items = profesoresCentro
          .map((profesor) => DropdownMenuItem(
                child: Text("${profesor.nombre} ${profesor.apellido}"),
                value: profesor,
              ))
          .toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        title: Text('Crear Asignatura'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Crear asignatura",
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
                      controller: controllerNombreAsignatura,
                      decoration: const InputDecoration(
                        labelText: "Nombre de la asignatura*",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        "Profesor que la imparte:*",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    loading
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: const Text("Profesores"),
                              value: profeSeleccionado,
                              items: items,
                              onChanged: (profe) {
                                setState(() {
                                  profeSeleccionado = profe;
                                });
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        "Selector de color:*",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controllerNombreAsignatura.text,
                              profeSeleccionado,
                              color,
                              context,
                            );
                          },
                          child: const Text("Crear asignatura"),
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
    String nombreAsignatura,
    Usuario? profesor,
    Color colorSeleccionado,
    BuildContext context,
  ) async {
    if (nombreAsignatura.isEmpty || profesor == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No están rellenos todos los campos")),
      );
    } else {
      await ClasesBBDD().crearAsignatura(
        nombreAsignatura,
        profesor,
        Utils.colorToString(colorSeleccionado),
        widget.clase,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Asignatura creada")),
      );
    }
  }
}
