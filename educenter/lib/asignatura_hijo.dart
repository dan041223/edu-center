import 'package:educenter/drawer.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:flutter/material.dart';

import 'models/alumno.dart';

class asignatura_hijo extends StatefulWidget {
  Alumno alumnoElegido;
  Asignatura asignaturaElegida;
  asignatura_hijo(
      {super.key,
      required this.alumnoElegido,
      required this.asignaturaElegida});

  @override
  State<asignatura_hijo> createState() => _asignatura_hijoState();
}

class _asignatura_hijoState extends State<asignatura_hijo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "${widget.asignaturaElegida.nombre_asignatura} - ${widget.alumnoElegido.nombre} ${widget.alumnoElegido.apellido}")),
      drawer: const DrawerMio(),
      body: Column(),
    );
  }
}
