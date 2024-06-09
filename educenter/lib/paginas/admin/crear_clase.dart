import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class CrearClase extends StatefulWidget {
  Centro centro;
  CrearClase({super.key, required this.centro});

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Creacion de clase",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: controllerNombreClase,
                decoration: InputDecoration(
                    label: Text(
                  "Nombre de la clase*",
                )),
              ),
              const Text(
                "Tutor de la clase",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
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
              TextButton(
                  onPressed: () {
                    comprobarCampos(
                        controllerNombreClase.text, profeSeleccionado, context);
                  },
                  child: Text("Crear"))
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(
      String nombre, Usuario? profeSeleccionado, BuildContext context) async {
    if (nombre.isEmpty) {
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
