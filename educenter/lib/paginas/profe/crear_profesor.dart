import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';

class CrearProfesor extends StatefulWidget {
  Centro centro;
  CrearProfesor({super.key, required this.centro});

  @override
  State<CrearProfesor> createState() => _CrearProfesorState();
}

class _CrearProfesorState extends State<CrearProfesor> {
  Clase? claseSeleccionada;
  List<DropdownMenuItem> itemsDropDown = List.empty(growable: true);
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorApellido = TextEditingController();
  TextEditingController controladorDNI = TextEditingController();
  TextEditingController controladorEmailContacto = TextEditingController();
  TextEditingController controladorEmailUsuario = TextEditingController();

  int controladorIdClaseTutor = 0;
  bool loading = true;
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () async {
        List<Clase> clases =
            await ClasesBBDD().getClasesSinTutor(widget.centro);
        for (var clase in clases) {
          itemsDropDown.add(DropdownMenuItem(
            value: clase,
            child: Text(clase.nombre_clase),
          ));
        }
        setState(() {
          loading = false;
        });
      },
    );
    setState(() {
      loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Crear profesor",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: controladorNombre,
                decoration: const InputDecoration(
                    label: Text(
                  "Nombre*",
                )),
              ),
              TextField(
                controller: controladorApellido,
                decoration: const InputDecoration(
                    label: Text(
                  "Apellido*",
                )),
              ),
              TextField(
                controller: controladorDNI,
                decoration: const InputDecoration(
                    label: Text(
                  "DNI*",
                )),
              ),
              TextField(
                controller: controladorEmailUsuario,
                decoration: const InputDecoration(
                    label: Text(
                  "Email de usuario*",
                )),
              ),
              TextField(
                controller: controladorEmailContacto,
                decoration: const InputDecoration(
                    label: Text(
                  "Email de contacto*",
                )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Clases sin tutor:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          DropdownButton(
                            hint: const Text("Clases..."),
                            isExpanded: true,
                            items: itemsDropDown,
                            value: claseSeleccionada,
                            onChanged: (value) {
                              setState(() {});
                              claseSeleccionada = value;
                            },
                          ),
                        ],
                      ),
              ),
              TextButton(
                  onPressed: () {
                    comprobarCampos(
                        controladorNombre.text,
                        controladorApellido.text,
                        controladorDNI.text,
                        controladorEmailContacto.text,
                        controladorEmailUsuario.text,
                        context);
                  },
                  child: Text("Crear"))
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(String nombre, String apellido, String dni,
      String emailContacto, String emailUsuario, BuildContext context) async {
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        dni.isEmpty ||
        emailContacto.isEmpty ||
        emailUsuario.isEmpty ||
        claseSeleccionada == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ProfesoresBBDD().crearProfesor(nombre, apellido, dni, emailContacto,
          emailUsuario, claseSeleccionada, widget.centro);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profesor creado")));
    }
  }
}
