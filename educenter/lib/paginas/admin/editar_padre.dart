import 'package:educenter/bbdd/padres_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class EditarPadre extends StatefulWidget {
  Centro centro;
  Usuario padre;
  EditarPadre({super.key, required this.padre, required this.centro});

  @override
  State<EditarPadre> createState() => _EditarPadreState();
}

class _EditarPadreState extends State<EditarPadre> {
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerDni = TextEditingController();
  TextEditingController controllerEmailContacto = TextEditingController();
  @override
  void initState() {
    controllerNombre.text = widget.padre.nombre;
    controllerApellido.text = widget.padre.apellido;
    controllerDni.text = widget.padre.dni;
    controllerEmailContacto.text = widget.padre.email_contacto.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Editar padre o madre",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controllerNombre,
                decoration: InputDecoration(
                    label: Text(
                  "Nombre...*",
                )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controllerApellido,
                decoration: InputDecoration(
                    label: Text(
                  "Apellido...*",
                )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controllerDni,
                decoration: InputDecoration(
                    label: Text(
                  "Dni...*",
                )),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controllerEmailContacto,
                decoration: InputDecoration(
                    label: Text(
                  "Email de contacto...*",
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        comprobarCampos(
                            controllerNombre.text,
                            controllerApellido.text,
                            controllerDni.text,
                            controllerEmailContacto.text,
                            context);
                      },
                      child: Text("Editar padre/madre")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(String nombre, String apellido, String dni,
      String emailContacto, BuildContext context) async {
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        dni.isEmpty ||
        emailContacto.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await padresBBDD().editarPadre(
          nombre, apellido, dni, emailContacto, widget.centro, widget.padre);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Padre/madre creado")));
    }
  }
}
