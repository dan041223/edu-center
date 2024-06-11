import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class EditarClase extends StatefulWidget {
  final Centro centro;
  final Clase clase;

  const EditarClase({Key? key, required this.clase, required this.centro})
      : super(key: key);

  @override
  State<EditarClase> createState() => _EditarClaseState();
}

class _EditarClaseState extends State<EditarClase> {
  bool loading = true;
  Usuario? tutorClase;
  Usuario? tutorSeleccionado;
  List<Usuario> profesoresNoTutores = [];
  List<DropdownMenuItem<Usuario>> itemsDropDown = [];
  TextEditingController controladorNombreClase = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    controladorNombreClase.text = widget.clase.nombre_clase;
    tutorClase = await ProfesoresBBDD().getTutorClase(widget.clase);
    profesoresNoTutores =
        await ClasesBBDD().getProfesoresNoTutores(widget.centro);
    itemsDropDown = profesoresNoTutores
        .map((profesor) => DropdownMenuItem(
              value: profesor,
              child: Text("${profesor.nombre} ${profesor.apellido}"),
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
        backgroundColor: Colors.blue,
        title: const Text('Editar Clase'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.class_,
                  size: 100,
                  color: Colors.blue, // Color azul principal
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Editar clase",
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
                      children: [
                        TextField(
                          controller: controladorNombreClase,
                          decoration: const InputDecoration(
                            labelText: "Nombre de la clase*",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.class_),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Tutor de la clase",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Color azul principal
                          ),
                        ),
                        const SizedBox(height: 10),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : DropdownButtonFormField<Usuario>(
                                hint: const Text("Seleccionar tutor"),
                                isExpanded: true,
                                value: tutorSeleccionado,
                                items: itemsDropDown,
                                onChanged: (tutor) {
                                  setState(() {
                                    tutorSeleccionado = tutor as Usuario?;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controladorNombreClase.text,
                              tutorSeleccionado,
                            );
                          },
                          child: const Text("Editar"),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void comprobarCampos(String nombre, Usuario? tutorSeleccionado) async {
    if (nombre.isEmpty || tutorSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No están rellenos todos los campos"),
        ),
      );
    } else {
      await ClasesBBDD().editarClase(
        nombre,
        tutorClase,
        tutorSeleccionado,
        widget.centro,
        widget.clase,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Clase editada")),
      );
    }
  }
}
