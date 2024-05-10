// ignore_for_file: camel_case_types

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class childProfile extends StatefulWidget {
  Alumno alumnoElegido;
  childProfile({super.key, required this.alumnoElegido});

  @override
  State<childProfile> createState() => _childProfileState();
}

class _childProfileState extends State<childProfile> {
  List<Asignatura> asignaturas = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      asignaturas =
          await AlumnosBBDD().getAsignaturasAlumno(widget.alumnoElegido);
      setState(() {});
    });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EduCenter"),
      ),
      drawer: const DrawerMio(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://media.istockphoto.com/id/1399611777/es/foto/retrato-de-un-ni%C3%B1o-sonriente-de-pelo-casta%C3%B1o-mirando-a-la-c%C3%A1mara-ni%C3%B1o-feliz-con-buenos-dientes.jpg?s=612x612&w=0&k=20&c=OZZF4QU3PJvEuDHB8Q4ttDKuUhjtJax-GeZZQJFrOXo=',
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                "${widget.alumnoElegido.nombre} ${widget.alumnoElegido.apellido}",
                style: const TextStyle(fontSize: 25),
              )
            ],
          ),
          const Divider(
            color: Colors.black,
            height: 20,
          ),
          Container(
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(asignaturas.length, (index) {
                return Center(
                  child: Container(
                    color: Colors.red,
                    child: Text(asignaturas[index].nombre_asignatura),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
