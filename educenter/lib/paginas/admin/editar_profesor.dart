import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class EditarProfesor extends StatefulWidget {
  Centro centro;
  Usuario profesor;
  EditarProfesor({super.key, required this.profesor, required this.centro});

  @override
  State<EditarProfesor> createState() => _EditarProfesorState();
}

class _EditarProfesorState extends State<EditarProfesor> {
  Clase? claseDeTutor;
  Clase? claseSeleccionada;
  List<DropdownMenuItem> itemsDropDown = List.empty(growable: true);
  TextEditingController controladorNombre = TextEditingController();
  TextEditingController controladorApellido = TextEditingController();
  TextEditingController controladorDNI = TextEditingController();
  TextEditingController controladorEmailContacto = TextEditingController();
  int controladorIdClaseTutor = 0;
  bool esTutor = false;
  bool loading = true;
  @override
  void initState() {
    esTutor = widget.profesor.id_clase != null ? true : false;

    widget.profesor.id_clase != null
        ? controladorIdClaseTutor = widget.profesor.id_clase!
        : controladorIdClaseTutor;
    controladorNombre.text = widget.profesor.nombre;
    controladorApellido.text = widget.profesor.apellido;
    controladorDNI.text = widget.profesor.dni;
    widget.profesor.email_contacto != null
        ? controladorEmailContacto.text = widget.profesor.email_contacto!
        : controladorEmailContacto.text;
    setState(() {});
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
                "Modificar a ${widget.profesor.nombre}",
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
                controller: controladorEmailContacto,
                decoration: const InputDecoration(
                    label: Text(
                  "Email de contacto*",
                )),
              ),
              TextButton(
                  onPressed: () {
                    comprobarCampos(
                        controladorNombre.text,
                        controladorApellido.text,
                        controladorDNI.text,
                        controladorEmailContacto.text,
                        context);
                  },
                  child: Text("Modificar"))
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(String nombre, String apellido, String dni, String email,
      BuildContext context) async {
    if (nombre.isEmpty || apellido.isEmpty || dni.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await ProfesoresBBDD()
          .modificarProfesor(nombre, apellido, dni, email, widget.profesor);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profesor modificado")));
    }
  }
}
