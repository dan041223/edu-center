import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditarAsignatura extends StatefulWidget {
  final Centro centro;
  final Asignatura asignatura;

  const EditarAsignatura({
    Key? key,
    required this.asignatura,
    required this.centro,
  }) : super(key: key);

  @override
  State<EditarAsignatura> createState() => _EditarAsignaturaState();
}

class _EditarAsignaturaState extends State<EditarAsignatura> {
  Usuario? profesorActual;
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
    controllerNombreAsignatura.text = widget.asignatura.nombre_asignatura;
    colorSeleccionado = widget.asignatura.color_codigo;
    color = Utils.hexToColor(colorSeleccionado);

    profesorActual =
        await ProfesoresBBDD().getProfesorDeId(widget.asignatura.id_profesor!);

    profesoresCentro = await CentroBBDD().getProfesoresCentro(widget.centro);
    profesoresCentro.removeWhere(
        (profe) => profe.id_usuario == widget.asignatura.id_profesor);
    items = profesoresCentro
        .map((profesor) => DropdownMenuItem(
              child: Text("${profesor.nombre} ${profesor.apellido}"),
              value: profesor,
            ))
        .toList();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Fondo azul claro
      appBar: AppBar(
        title: const Text('Editar Asignatura'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.library_books,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Editar asignatura",
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
                          : Column(
                              children: [
                                Text(
                                  "Profesor actual:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${widget.asignatura.profesor.nombre} ${widget.asignatura.profesor.apellido}",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DropdownButton(
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
                              ],
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
                              );
                            },
                            child: const Text("Editar asignatura"),
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

  void comprobarCampos(
    String nombreAsignatura,
    Usuario? profesor,
    Color colorSeleccionado,
  ) async {
    if (nombreAsignatura.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No están rellenos todos los campos"),
        ),
      );
    } else {
      await ClasesBBDD().editarAsignatura(
        widget.asignatura,
        nombreAsignatura,
        profeSeleccionado,
        Utils.colorToString(colorSeleccionado),
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Asignatura modificada")),
      );
    }
  }
}
