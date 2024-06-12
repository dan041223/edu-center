import 'package:educenter/bbdd/examenes_alumno_bbdd.dart';
import 'package:educenter/examen_panel.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/examen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExamenesAlumno extends StatefulWidget {
  Alumno alumno;
  Asignatura asignatura;
  ExamenesAlumno({
    super.key,
    required this.alumno,
    required this.asignatura,
  });

  @override
  State<ExamenesAlumno> createState() => _ExamenesAlumnoState();
}

class _ExamenesAlumnoState extends State<ExamenesAlumno> {
  bool loading = true;
  List<Examen> examenesAlumnoAsignatura = List.empty(growable: true);
  List<Examen> examenesAlumnoAsignaturaPasados = List.empty(growable: true);
  List<Examen> examenesAlumnoAsignaturaProximos = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 1),
      () async {
        examenesAlumnoAsignatura = await ExamenesAlumnoBBDD()
            .getExamenesAsignaturaAlumno(widget.alumno, widget.asignatura);

        examenesAlumnoAsignaturaPasados = examenesAlumnoAsignatura
            .where((element) => element.fecha_examen.isBefore(DateTime.now()))
            .toList();

        examenesAlumnoAsignaturaProximos = examenesAlumnoAsignatura
            .where((element) => element.fecha_examen.isAfter(DateTime.now()))
            .toList();
        if (!mounted) {
          return;
        }
        setState(() {
          loading = false;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brillo = Theme.of(context).brightness;
    bool esOscuro = brillo == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: esOscuro ? Colors.white : Colors.black,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: widget.alumno.url_foto_perfil != null
                              ? Image.network(
                                  widget.alumno.url_foto_perfil!.toString(),
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person,
                                  color: Colors.black, size: 80),
                        ),
                        Flexible(
                          child: Text(
                            "Examenes de ${widget.alumno.nombre}",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: esOscuro ? Colors.black : Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Examenes próximos:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 20,
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : examenesAlumnoAsignaturaProximos.isEmpty
                    ? Text(
                        "${widget.alumno.nombre} no tiene exámenes próximos de ${widget.asignatura.nombre_asignatura}")
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: examenesAlumnoAsignaturaProximos.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ExamenPanel(
                                          alumnoSeleccionado: widget.alumno,
                                          examenSeleccionado:
                                              examenesAlumnoAsignaturaProximos[
                                                  index],
                                          profesorSeleccionado:
                                              examenesAlumnoAsignaturaProximos[
                                                      index]
                                                  .profesor,
                                          claseExamen:
                                              examenesAlumnoAsignaturaProximos[
                                                      index]
                                                  .clase,
                                          editor: true,
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timelapse_outlined),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "Examen de ${examenesAlumnoAsignatura[index].asignatura.nombre_asignatura}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Examenes pasados:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 20,
            ),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : examenesAlumnoAsignaturaPasados.isEmpty
                    ? Text(
                        "${widget.alumno.nombre} no ha tenido exámenes pasados de ${widget.asignatura.nombre_asignatura}")
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: examenesAlumnoAsignaturaPasados.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ExamenPanel(
                                          alumnoSeleccionado: widget.alumno,
                                          examenSeleccionado:
                                              examenesAlumnoAsignaturaPasados[
                                                  index],
                                          profesorSeleccionado:
                                              examenesAlumnoAsignaturaPasados[
                                                      index]
                                                  .profesor,
                                          claseExamen:
                                              examenesAlumnoAsignaturaPasados[
                                                      index]
                                                  .clase,
                                        )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.history_toggle_off_sharp),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        "Examen de ${examenesAlumnoAsignatura[index].asignatura.nombre_asignatura}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
