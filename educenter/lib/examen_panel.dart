import 'package:educenter/bbdd/examenes_alumno_bbdd.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExamenPanel extends StatefulWidget {
  Examen examenSeleccionado;
  Alumno alumnoSeleccionado;
  Usuario profesorSeleccionado;
  Clase claseExamen;
  ExamenPanel(
      {super.key,
      required this.examenSeleccionado,
      required this.alumnoSeleccionado,
      required this.profesorSeleccionado,
      required this.claseExamen});

  @override
  State<ExamenPanel> createState() => _ExamenPanelState();
}

class _ExamenPanelState extends State<ExamenPanel> {
  String notaExamen = "N/A";
  String observacionesProfeAlumnoExamen = "N/A";
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      if (!mounted) return;
      notaExamen = await ExamenesAlumnoBBDD().getNotaExamenAlumno(
          widget.alumnoSeleccionado, widget.examenSeleccionado);
      observacionesProfeAlumnoExamen = await ExamenesAlumnoBBDD()
          .getObservacionesExamenAlumno(
              widget.alumnoSeleccionado, widget.examenSeleccionado);
      setState(() {});
    });
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Examen de ${widget.examenSeleccionado.asignatura.nombre_asignatura} ${widget.examenSeleccionado.clase.nombre_clase}")),
        drawer: const DrawerMio(),
        body: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: hexToColor(
                        widget.examenSeleccionado.asignatura.color_codigo),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.alumnoSeleccionado.nombre} ${widget.alumnoSeleccionado.apellido}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.examenSeleccionado.asignatura
                                  .nombre_asignatura,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.calendar_month),
                            Text(
                              widget.examenSeleccionado.fecha_examen
                                  .toString()
                                  .split(" ")
                                  .first,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                    widget.examenSeleccionado.descripcion != null &&
                            widget.examenSeleccionado.descripcion != ""
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "A tener en cuenta...",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.examenSeleccionado.descripcion!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Container()
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                children: [
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://st2.depositphotos.com/1025740/5398/i/950/depositphotos_53989307-stock-photo-profesora.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "${widget.profesorSeleccionado.nombre} ${widget.profesorSeleccionado.apellido}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.examenSeleccionado.trimestre.toString(),
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Trimestre",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: hexToColor(
                        widget.examenSeleccionado.asignatura.color_codigo),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Nota:",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$notaExamen/10",
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "¿Que tal lo ha hecho ${widget.alumnoSeleccionado.nombre}?",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      observacionesProfeAlumnoExamen,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  ],
                ))
          ],
        ));
  }
}
