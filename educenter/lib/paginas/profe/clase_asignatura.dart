import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

class ClaseAsignatura extends StatefulWidget {
  Clase clase;
  Asignatura asignatura;
  ClaseAsignatura({super.key, required this.clase, required this.asignatura});

  @override
  State<ClaseAsignatura> createState() => _ClaseAsignaturaState();
}

class _ClaseAsignaturaState extends State<ClaseAsignatura> {
  List<Alumno>? alumnos;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Utils.hexToColor(widget.asignatura.color_codigo),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.asignatura.nombre_asignatura,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.clase.nombre_clase,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              children: [
                Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 40,
                          ),
                          Text(
                            "Crear examen...",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
                Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 40,
                          ),
                          Center(
                              child: Text(
                            "Crear evento...",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: 40,
                          ),
                          Center(
                            child: Text(
                              "Ver examenes...",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: 40,
                          ),
                          Center(
                              child: Text(
                            "Ver eventos...",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        size: 40,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Ver alumnos...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
