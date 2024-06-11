import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class CrearClase extends StatefulWidget {
  final Centro centro;
  const CrearClase({super.key, required this.centro});

  @override
  State<CrearClase> createState() => _CrearClaseState();
}

class _CrearClaseState extends State<CrearClase> {
  bool loading = true;
  Usuario? profeSeleccionado;
  List<Usuario> profesNoTutores = List.empty(growable: true);
  List<DropdownMenuItem> itemsDropDown = List.empty(growable: true);
  TextEditingController controllerNombreClase = TextEditingController();

  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        profesNoTutores =
            await ClasesBBDD().getProfesoresNoTutores(widget.centro);
        profesNoTutores.forEach((profe) {
          itemsDropDown.add(DropdownMenuItem(
            child: Text(
              "${profe.nombre} ${profe.apellido}",
            ),
            value: profe,
          ));
        });
        print("");
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
        title: const Text('Crear Clase'),
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
                    "Creación de clase",
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
                          controller: controllerNombreClase,
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
                            : DropdownButton(
                                hint: const Text("Profesores del centro..."),
                                isExpanded: true,
                                items: itemsDropDown,
                                value: profeSeleccionado,
                                onChanged: (value) {
                                  setState(() {});
                                  profeSeleccionado = value;
                                },
                              ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            comprobarCampos(
                              controllerNombreClase.text,
                              profeSeleccionado,
                              context,
                            );
                          },
                          child: const Text("Crear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
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

  void comprobarCampos(
      String nombre, Usuario? profeSeleccionado, BuildContext context) async {
    if (nombre.isEmpty || profeSeleccionado == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ClasesBBDD().crearClase(nombre, profeSeleccionado, widget.centro);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Clase creada")));
    }
  }
}
