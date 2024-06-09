// ignore_for_file: must_be_immutable, camel_case_types

import 'package:educenter/bbdd/examenes_alumno_bbdd.dart';
import 'package:educenter/components/fecha_xs.dart';
import 'package:educenter/examen_panel.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/paginas/padre/profesor_panel.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import '../../models/alumno.dart';

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
  List<Examen> listaExamenesAsignaturaHijo = List.empty(growable: true);
  List<Examen> listaExamenesPasados = List.empty(growable: true);
  List<Examen> listaExamenesProximos = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      listaExamenesAsignaturaHijo = await ExamenesAlumnoBBDD()
          .getExamenesAsignaturaAlumno(
              widget.alumnoElegido, widget.asignaturaElegida);
      listaExamenesAsignaturaHijo
          .sort((a, b) => a.fecha_examen.compareTo(b.fecha_examen));
      listaExamenesProximos = listaExamenesAsignaturaHijo
          .where((element) => element.fecha_examen.isAfter(DateTime.now()))
          .toList();

      listaExamenesPasados = listaExamenesAsignaturaHijo
          .where((element) => element.fecha_examen.isBefore(DateTime.now()))
          .toList();
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "${widget.asignaturaElegida.nombre_asignatura} - ${widget.alumnoElegido.nombre} ${widget.alumnoElegido.apellido}")),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color:
                      Utils.hexToColor(widget.asignaturaElegida.color_codigo),
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
                        widget.asignaturaElegida.nombre_asignatura,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.alumnoElegido.clase.nombre_clase,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profesor/a:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfesorPanel(
                            profesor: widget.asignaturaElegida.profesor,
                            alumno: widget.alumnoElegido,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: widget.asignaturaElegida.profesor
                                          .url_foto_perfil !=
                                      null
                                  ? Image.network(
                                      widget.asignaturaElegida.profesor
                                          .url_foto_perfil
                                          .toString(),
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.person),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${widget.asignaturaElegida.profesor.nombre} ${widget.asignaturaElegida.profesor.apellido}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Examenes proximos:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  listaExamenesProximos.isNotEmpty
                      ? Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listaExamenesProximos.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ExamenPanel(
                                        alumnoSeleccionado:
                                            widget.alumnoElegido,
                                        claseExamen: widget.alumnoElegido.clase,
                                        examenSeleccionado:
                                            listaExamenesProximos[index],
                                        profesorSeleccionado:
                                            widget.asignaturaElegida.profesor,
                                      ),
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.text_snippet_outlined),
                                        Text(
                                            "Examen de ${listaExamenesProximos[index].asignatura.nombre_asignatura}"),
                                        fechaXS(
                                            listaExamenesProximos[index]
                                                .fecha_examen
                                                .toString(),
                                            Colors.black12)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              "${widget.alumnoElegido.nombre} no tiene exámenes próximos de ${widget.asignaturaElegida.nombre_asignatura}."),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Examenes pasados:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  listaExamenesPasados.isNotEmpty
                      ? Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listaExamenesPasados.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ExamenPanel(
                                        alumnoSeleccionado:
                                            widget.alumnoElegido,
                                        claseExamen: widget.alumnoElegido.clase,
                                        examenSeleccionado:
                                            listaExamenesPasados[index],
                                        profesorSeleccionado:
                                            widget.asignaturaElegida.profesor,
                                      ),
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.text_snippet_outlined),
                                        Text(
                                            "Examen de ${listaExamenesPasados[index].asignatura.nombre_asignatura}"),
                                        fechaXS(
                                            listaExamenesPasados[index]
                                                .fecha_examen
                                                .toString(),
                                            Colors.black12)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              "${widget.alumnoElegido.nombre} aún no ha tenido exámenes de ${widget.asignaturaElegida.nombre_asignatura}."),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
