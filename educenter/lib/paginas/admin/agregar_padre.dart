import 'package:educenter/bbdd/padres_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/centro.dart';
import 'package:flutter/material.dart';

class AgregarPadre extends StatefulWidget {
  Centro centro;
  AgregarPadre({super.key, required this.centro});

  @override
  State<AgregarPadre> createState() => _AgregarPadreState();
}

class _AgregarPadreState extends State<AgregarPadre> {
  TextEditingController controllerNombre = TextEditingController();
  TextEditingController controllerApellido = TextEditingController();
  TextEditingController controllerDni = TextEditingController();
  TextEditingController controllerEmailContacto = TextEditingController();
  TextEditingController controllerEmailUsuario = TextEditingController();
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
              Text(
                "Crear padre o madre",
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
              TextField(
                controller: controllerEmailUsuario,
                decoration: InputDecoration(
                    label: Text(
                  "Email de usuario...*",
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
                            controllerEmailUsuario.text,
                            context);
                      },
                      child: Text("Crear padre/madre")),
                ],
              )
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
        emailUsuario.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await padresBBDD().crearPadre(
          nombre, apellido, dni, emailContacto, emailUsuario, widget.centro);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Padre/madre creado")));
    }
  }
}
