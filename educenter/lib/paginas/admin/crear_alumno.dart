import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CrearAlumno extends StatefulWidget {
  Clase clase;
  CrearAlumno({super.key, required this.clase});

  @override
  State<CrearAlumno> createState() => _CrearAlumnoState();
}

class _CrearAlumnoState extends State<CrearAlumno> {
  TextEditingController controllerNombreAlumno = TextEditingController();
  TextEditingController controllerApellidoAlumno = TextEditingController();
  DateTime? fecha_nacimiento;
  Clase? claseSeleccionada;

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
                "Crear alumno",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () async {
                        comprobarCampos(
                            controllerNombreAlumno.text,
                            controllerApellidoAlumno.text,
                            fecha_nacimiento,
                            widget.clase,
                            context);
                      },
                      child: Text("Crear alumno"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  comprobarCampos(String nombre, String apellido, DateTime? fechaNacimiento,
      Clase clase, BuildContext context) async {
    if (nombre.isEmpty || apellido.isEmpty || fechaNacimiento == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No están rellenos todos los campos")));
    } else {
      await AlumnosBBDD().crearAlumno(nombre, apellido, fechaNacimiento, clase);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Alumno creado")));
    }
  }
}
