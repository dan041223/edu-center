// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:educenter/paginas/padre/profesor_panel.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/usuario.dart';
import 'package:url_launcher/url_launcher.dart';

class EventoPanel extends StatefulWidget {
  final Evento eventoSeleccionado;
  final Alumno? alumnoSeleccionado;
  final List<Usuario> listaProfesores;
  final List<Alumno> listaAlumnos;

  // ignore: use_super_parameters
  EventoPanel({
    Key? key,
    required this.eventoSeleccionado,
    required this.alumnoSeleccionado,
    required this.listaAlumnos,
    required this.listaProfesores,
  }) : super(key: key);

  @override
  State<EventoPanel> createState() => _EventoPanelState();
}

class _EventoPanelState extends State<EventoPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventoSeleccionado.nombre_evento),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Utils.hexToColor(widget.eventoSeleccionado.color),
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
                              : "",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            Text(
                              widget.eventoSeleccionado.fecha_inicio
                                  .toString()
                                  .split(" ")
                                  .first,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.calendar_month_outlined),
                            Text(
                              widget.eventoSeleccionado.fecha_fin
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.eventoSeleccionado.nombre_evento,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    widget.eventoSeleccionado.descripcion_evento != ""
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Información",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.eventoSeleccionado.descripcion_evento,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Container()
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Profesores:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.listaProfesores.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfesorPanel(
                                profesor: widget.listaProfesores[index],
                                alumno: widget.alumnoSeleccionado,
                              ),
                            ));
                          },
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
                                  child: widget.listaProfesores[index]
                                                  .url_foto_perfil !=
                                              null &&
                                          widget.listaProfesores[index]
                                                  .url_foto_perfil !=
                                              ""
                                      ? Image.network(
                                          widget.listaProfesores[index]
                                              .url_foto_perfil!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.person,
                                        )),
                              Text(
                                widget.listaProfesores[index].nombre,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Ubicacion:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 20,
                  ),
                  Card(
                    elevation: 0.2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Uri googleUrl = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${widget.eventoSeleccionado.ubicacion}');
                        launchUrl(googleUrl);

                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => AsignaturasHijo(
                        //           asignaturas: asignaturas,
                        //           alumnoElegido: widget.alumnoElegido,
                        //         )));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.map,
                              size: 25,
                            ),
                            Text(
                              "Ver ubicación en Maps...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
