// ignore_for_file: must_be_immutable

import 'package:educenter/bbdd/examenes_alumno_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/components/fecha_xs.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/profe/editar_examen.dart';
import 'package:educenter/paginas/profe/editar_examen_alumno.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExamenPanel extends StatefulWidget {
  Examen examenSeleccionado;
  Alumno? alumnoSeleccionado;
  Usuario profesorSeleccionado;
  bool? editor = false;
  Clase claseExamen;
  Usuario? user;
  ExamenPanel(
      {super.key,
      required this.examenSeleccionado,
      required this.alumnoSeleccionado,
      required this.profesorSeleccionado,
      required this.claseExamen,
      this.user,
      this.editor});

  @override
  State<ExamenPanel> createState() => _ExamenPanelState();
}

class _ExamenPanelState extends State<ExamenPanel> {
  String notaExamen = "N/A";
  String observacionesProfeAlumnoExamen = "N/A";
  bool loading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      if (!mounted) return;
      widget.user = await usersBBDD().getUsuario();

      if (widget.alumnoSeleccionado != null) {
        notaExamen = await ExamenesAlumnoBBDD().getNotaExamenAlumno(
            widget.alumnoSeleccionado!, widget.examenSeleccionado);
        observacionesProfeAlumnoExamen = await ExamenesAlumnoBBDD()
            .getObservacionesExamenAlumno(
                widget.alumnoSeleccionado!, widget.examenSeleccionado);
      }

      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: loading
          ? Container()
          : widget.user != null && widget.user!.tipo_usuario != "profesor"
              ? Container()
              : widget.alumnoSeleccionado != null
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditarExamenAlumno(
                              alumno: widget.alumnoSeleccionado!,
                              examen: widget.examenSeleccionado,
                              user: widget.profesorSeleccionado,
                              notaExamen: notaExamen,
                              comentarioAlumno: observacionesProfeAlumnoExamen,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.edit),
                    )
                  : FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditarExamen(
                              examen: widget.examenSeleccionado,
                              user: widget.profesorSeleccionado,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.edit),
                    ),
      appBar: AppBar(
          title: Text(
              "Examen de ${widget.examenSeleccionado.asignatura.nombre_asignatura} ${widget.examenSeleccionado.clase.nombre_clase}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Utils.hexToColor(
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
                        Text(
                          widget.alumnoSeleccionado != null
                              ? "${widget.alumnoSeleccionado!.nombre} ${widget.alumnoSeleccionado!.apellido}"
                              : "${widget.profesorSeleccionado.nombre} ${widget.profesorSeleccionado.apellido}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        fechaXS(
                            widget.examenSeleccionado.fecha_examen.toString(),
                            Colors.white)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.examenSeleccionado.asignatura
                                .nombre_asignatura,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    widget.examenSeleccionado.descripcion != null &&
                            widget.examenSeleccionado.descripcion!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "A tener en cuenta...",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.examenSeleccionado.descripcion!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Container()
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView(
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
                          child: widget.profesorSeleccionado.url_foto_perfil !=
                                  null
                              ? Image.network(
                                  widget.profesorSeleccionado.url_foto_perfil
                                      .toString(),
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person),
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
            widget.alumnoSeleccionado != null
                ? Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Utils.hexToColor(
                            widget.examenSeleccionado.asignatura.color_codigo),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
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
                              loading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      notaExamen == "N/A" ||
                                              notaExamen == "null"
                                          ? "-/10"
                                          : "$notaExamen/10",
                                      style: const TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          observacionesProfeAlumnoExamen == "N/A" ||
                                  observacionesProfeAlumnoExamen == "null" ||
                                  observacionesProfeAlumnoExamen.isEmpty
                              ? Container()
                              : Text(
                                  "¿Que tal lo ha hecho ${widget.alumnoSeleccionado!.nombre}?",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                          observacionesProfeAlumnoExamen == "N/A" ||
                                  observacionesProfeAlumnoExamen == "null"
                              ? Container()
                              : const SizedBox(
                                  height: 10,
                                ),
                          observacionesProfeAlumnoExamen == "N/A" ||
                                  observacionesProfeAlumnoExamen == "null" ||
                                  observacionesProfeAlumnoExamen.isEmpty
                              ? Text(
                                  "Sin observaciones",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  observacionesProfeAlumnoExamen,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                        ]),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
