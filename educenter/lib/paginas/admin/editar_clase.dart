import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class EditarClase extends StatefulWidget {
  Centro centro;
  Clase clase;
  EditarClase({super.key, required this.clase, required this.centro});

  @override
  State<EditarClase> createState() => _EditarClaseState();
}

class _EditarClaseState extends State<EditarClase> {
  bool loading = true;
  Usuario? tutorClase;
  Usuario? tutorSeleccionado;
  List<Usuario> profesoresNoTutores = List.empty(growable: true);
  List<DropdownMenuItem> itemsDropDown = List.empty(growable: true);
  TextEditingController controladorNombreClase = TextEditingController();
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () async {
        controladorNombreClase.text = widget.clase.nombre_clase;
        tutorClase = await ProfesoresBBDD().getTutorClase(widget.clase);
        profesoresNoTutores =
            await ClasesBBDD().getProfesoresNoTutores(widget.centro);
        for (var profesor in profesoresNoTutores) {
          itemsDropDown.add(DropdownMenuItem(
            value: profesor,
            child: Text("${profesor.nombre} ${profesor.apellido}"),
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Editar clase",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: controladorNombreClase,
                decoration: const InputDecoration(
                    label: Text(
                  "Nombre de la clase*",
                )),
              ),
              loading
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : tutorClase != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                    "El tutor actual es ${tutorClase!.nombre} ${tutorClase!.apellido}"),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              DropdownButton(
                                  hint: const Text("Cambio de tutor"),
                                  value: tutorSeleccionado,
                                  items: itemsDropDown,
                                  onChanged: (tutor) {
                                    setState(() {
                                      tutorSeleccionado = tutor;
                                    });
                                  }),
                            ],
                          ),
                        )
                      : DropdownButton(
                          items: itemsDropDown,
                          value: tutorSeleccionado,
                          onChanged: (tutor) {
                            setState(() {
                              tutorSeleccionado = tutor;
                            });
                          }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading
                      ? Container()
                      : TextButton(
                          onPressed: () {
                            comprobarCampos(controladorNombreClase.text,
                                tutorSeleccionado, context);
                          },
                          child: const Text("Editar clase")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(
      String nombre, Usuario? tutorSeleccionado, BuildContext context) async {
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ClasesBBDD().editarClase(
          nombre, tutorClase, tutorSeleccionado, widget.centro, widget.clase);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Clase editada")));
    }
  }
}
