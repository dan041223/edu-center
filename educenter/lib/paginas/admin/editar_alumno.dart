import 'dart:ffi';

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class EditarAlumno extends StatefulWidget {
  Centro centro;
  Alumno alumno;
  EditarAlumno({super.key, required this.alumno, required this.centro});

  @override
  State<EditarAlumno> createState() => _EditarAlumnoState();
}

class _EditarAlumnoState extends State<EditarAlumno> {
  bool loading = true;
  List<Clase> listaClasesCentro = List.empty(growable: true);
  List<DropdownMenuItem<Clase>> itemsDropDown = List.empty(growable: true);
  TextEditingController controllerNombreAlumno = TextEditingController();
  TextEditingController controllerApellidoAlumno = TextEditingController();
  DateTime? fecha_nacimiento;
  Clase? claseSeleccionada;

  @override
  void initState() {
    controllerNombreAlumno.text = widget.alumno.nombre;
    controllerApellidoAlumno.text = widget.alumno.apellido;
    fecha_nacimiento = widget.alumno.fecha_nacimiento;
    Future.delayed(
      Duration(milliseconds: 1),
      () async {
        listaClasesCentro = await CentroBBDD().getClasesCentro(widget.centro);
        listaClasesCentro.forEach((clase) {
          itemsDropDown.add(DropdownMenuItem(
            child: Text(clase.nombre_clase),
            value: clase,
          ));
        });
        setState(() {
          loading = false;
        });
      },
    );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Editar alumno",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: controllerNombreAlumno,
                decoration: InputDecoration(
                    label: Text(
                  "Nombre del alumno*",
                )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controllerApellidoAlumno,
                decoration: InputDecoration(
                    label: Text(
                  "Apellido del alumno*",
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Fecha de nacimiento",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                height: 10,
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(DateTime.now().year - 20, 1, 1),
                      maxTime: DateTime.now(),
                      currentTime: DateTime.now(),
                      locale: LocaleType.es,
                      onConfirm: (time) async {
                        setState(() {
                          fecha_nacimiento = time;
                        });
                      },
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              // ignore: unnecessary_null_comparison
                              fecha_nacimiento != null
                                  ? fecha_nacimiento.toString().split(" ").first
                                  : "No se ha seleccionado una fecha*",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Clase actual de ${widget.alumno.nombre}: ${widget.alumno.clase.nombre_clase}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text("Clase a cambiar:"),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton(
                              items: itemsDropDown,
                              value: claseSeleccionada,
                              onChanged: (Clase? value) {
                                setState(() {
                                  claseSeleccionada = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        comprobarCampos(
                            controllerNombreAlumno.text,
                            controllerApellidoAlumno.text,
                            fecha_nacimiento,
                            claseSeleccionada,
                            context);
                      },
                      child: const Text("Editar alumno"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(String nombre, String apellido, DateTime? fechaNacimiento,
      Clase? clase, BuildContext context) async {
    if (nombre.isEmpty || apellido.isEmpty || fechaNacimiento == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await AlumnosBBDD().editarAlumno(
          nombre, apellido, fechaNacimiento, clase, widget.alumno);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Alumno editado")));
    }
  }
}
