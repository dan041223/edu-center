import 'package:educenter/drawer.dart';
import 'package:educenter/models/alumno.dart';
import 'package:flutter/material.dart';

class AnotacionesHijo extends StatefulWidget {
  Alumno alumnoElegido;
  AnotacionesHijo({super.key, required this.alumnoElegido});

  @override
  State<AnotacionesHijo> createState() => _AnotacionesHijoState();
}

class _AnotacionesHijoState extends State<AnotacionesHijo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Title"),
        ),
        drawer: DrawerMio(),
        body: Center());
  }
}
