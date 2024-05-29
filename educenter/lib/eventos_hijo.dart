import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/evento.dart';
import 'package:educenter/eventos_examenes.dart';
import 'package:educenter/examen_panel.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventosHijo extends StatefulWidget {
  Alumno alumnoElegido;
  EventosHijo({super.key, required this.alumnoElegido});

  @override
  State<EventosHijo> createState() => _EventosHijoState();
}

class _EventosHijoState extends State<EventosHijo> {
  bool eventosBool = true;
  bool examenesBool = true;
  bool incidenciasBool = true;
  List<Object> examenesEventosIncidenciasDelDiaSeleccionado =
      List.empty(growable: true);
  List<Object> examenesEventosIncidenciasDelAlumno = List.empty(growable: true);
  List<Evento> listaEventos = List.empty(growable: true);
  List<Examen> listaExamenes = List.empty(growable: true);
  List<Incidencia> listaIncidencias = List.empty(growable: true);
  List<Object> listaEventosObjeto = List.empty(growable: true);
  List<Object> listaExamenesObjeto = List.empty(growable: true);
  List<Object> listaIncidenciasObjeto = List.empty(growable: true);
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      listaEventos =
          await AlumnosBBDD().getListaEventosDeAlumno(widget.alumnoElegido);
      listaExamenes =
          await AlumnosBBDD().getListaExamenesDeAlumno(widget.alumnoElegido);
      listaIncidencias =
          await AlumnosBBDD().getListaIncidenciasDeAlumno(widget.alumnoElegido);
      listaIncidenciasObjeto = listaIncidencias;
      listaExamenesObjeto = listaExamenes;
      listaEventosObjeto = listaEventos;
      examenesEventosIncidenciasDelAlumno.addAll(listaIncidenciasObjeto);
      examenesEventosIncidenciasDelAlumno.addAll(listaExamenesObjeto);
      examenesEventosIncidenciasDelAlumno.addAll(listaEventosObjeto);
      setState(() {});
    });
  }

  List<Object> _getEvents(Alumno alumnoElegido) {
    List<Object> eventosDeHoy = List.empty(growable: true);
    List<Object> examenesDeHoy = List.empty(growable: true);
    List<Object> incidentesDeHoy = List.empty(growable: true);

    examenesEventosIncidenciasDelAlumno = List.empty(growable: true);

    if (eventosBool) {
      for (var evento in listaEventos) {
        eventosDeHoy.add(evento);
      }
    }

    if (incidenciasBool) {
      for (var incidencia in listaIncidencias) {
        incidentesDeHoy.add(incidencia);
      }
    }

    if (examenesBool) {
      for (var examen in listaExamenes) {
        examenesDeHoy.add(examen);
      }
    }
    examenesEventosIncidenciasDelAlumno.addAll(eventosDeHoy);
    examenesEventosIncidenciasDelAlumno.addAll(examenesDeHoy);
    examenesEventosIncidenciasDelAlumno.addAll(incidentesDeHoy);

    return examenesEventosIncidenciasDelAlumno;
  }

  List<Object> _getEventsForDay(DateTime day, Alumno alumnoElegido) {
    List<Object> eventosDeHoy = List.empty(growable: true);
    List<Object> examenesDeHoy = List.empty(growable: true);
    List<Object> incidentesDeHoy = List.empty(growable: true);

    List<Object> examenesEventosIncidenciasDeHoy = List.empty(growable: true);

    if (eventosBool) {
      for (var evento in listaEventos) {
        if (evento.fecha_inicio.day.compareTo(day.day) == 0 &&
            evento.fecha_inicio.month.compareTo(day.month) == 0 &&
            evento.fecha_inicio.year.compareTo(day.year) == 0) {
          eventosDeHoy.add(evento);
        }
      }
    }

    if (incidenciasBool) {
      for (var incidencia in listaIncidencias) {
        if (incidencia.fecha_incidencia.day.compareTo(day.day) == 0 &&
            incidencia.fecha_incidencia.month.compareTo(day.month) == 0 &&
            incidencia.fecha_incidencia.year.compareTo(day.year) == 0) {
          incidentesDeHoy.add(incidencia);
        }
      }
    }

    if (examenesBool) {
      for (var examen in listaExamenes) {
        if (examen.fecha_examen.day.compareTo(day.day) == 0 &&
            examen.fecha_examen.month.compareTo(day.month) == 0 &&
            examen.fecha_examen.year.compareTo(day.year) == 0) {
          examenesDeHoy.add(examen);
        }
      }
    }
    examenesEventosIncidenciasDeHoy.addAll(eventosDeHoy);
    examenesEventosIncidenciasDeHoy.addAll(examenesDeHoy);
    examenesEventosIncidenciasDeHoy.addAll(incidentesDeHoy);

    return examenesEventosIncidenciasDeHoy;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Eventos - Examenes"),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("Calendario"),
              ),
              Tab(
                child: Text("Listado"),
              ),
            ],
          ),
        ),
        drawer: const DrawerMio(),
        body: TabBarView(
          children: [
            Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Eventos"),
                  Checkbox(
                      value: eventosBool,
                      onChanged: (value) {
                        if (eventosBool) {
                          setState(() {
                            eventosBool = false;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEventsForDay(
                                    _focusedDay, widget.alumnoElegido);
                          });
                        } else {
                          setState(() {
                            eventosBool = true;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEventsForDay(
                                    _focusedDay, widget.alumnoElegido);
                          });
                        }
                      }),
                  const Text("Examenes"),
                  Checkbox(
                    value: examenesBool,
                    onChanged: (value) {
                      if (examenesBool) {
                        setState(() {
                          examenesBool = false;
                          examenesEventosIncidenciasDelDiaSeleccionado =
                              _getEventsForDay(
                                  _focusedDay, widget.alumnoElegido);
                        });
                      } else {
                        setState(() {
                          examenesBool = true;
                          examenesEventosIncidenciasDelDiaSeleccionado =
                              _getEventsForDay(
                                  _focusedDay, widget.alumnoElegido);
                        });
                      }
                    },
                  ),
                  const Text("Incidencias"),
                  Checkbox(
                      value: incidenciasBool,
                      onChanged: (value) {
                        if (incidenciasBool) {
                          setState(() {
                            incidenciasBool = false;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEventsForDay(
                                    _focusedDay, widget.alumnoElegido);
                          });
                        } else {
                          setState(() {
                            incidenciasBool = true;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEventsForDay(
                                    _focusedDay, widget.alumnoElegido);
                          });
                        }
                      }),
                ]),
                TableCalendar(
                  calendarStyle: const CalendarStyle(),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      examenesEventosIncidenciasDelDiaSeleccionado =
                          _getEventsForDay(selectedDay, widget.alumnoElegido);
                    });
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: (day) {
                    return _getEventsForDay(day, widget.alumnoElegido);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: examenesEventosIncidenciasDelDiaSeleccionado.isEmpty
                      ? const Center(
                          child: Text('No hay eventos en el día seleccionado'))
                      : ListView.builder(
                          itemCount:
                              examenesEventosIncidenciasDelDiaSeleccionado
                                  .length,
                          itemBuilder: (context, index) {
                            var item =
                                examenesEventosIncidenciasDelDiaSeleccionado[
                                    index];
                            String nombreEventoIncidenciaExamen = "prueba";

                            // Comprobar el tipo del elemento y asignar la fecha correspondiente
                            if (item is Evento) {
                              nombreEventoIncidenciaExamen = item
                                  .nombre_evento; // Suponiendo que fecha_inicio es la fecha del evento
                            } else if (item is Examen) {
                              Asignatura asignatura = item.asignatura;
                              nombreEventoIncidenciaExamen =
                                  "Examen de ${asignatura.nombre_asignatura}";
                            } else if (item is Incidencia) {
                              Incidencia incidencia = item;
                              nombreEventoIncidenciaExamen =
                                  incidencia.titulo_incidencia;
                            }

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              elevation: 5,
                              child: InkWell(
                                onTap: () {
                                  if (item is Examen) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ExamenPanel(
                                                  alumnoSeleccionado:
                                                      widget.alumnoElegido,
                                                  examenSeleccionado: item,
                                                  profesorSeleccionado:
                                                      item.profesor,
                                                  claseExamen: item.clase,
                                                )));
                                  } else if (item is Evento) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EventoPanel(
                                                  alumnoSeleccionado:
                                                      widget.alumnoElegido,
                                                  eventoSeleccionado: item,
                                                  listaAlumnos: item.alumnos,
                                                  listaProfesores:
                                                      item.profesores,
                                                )));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(children: [
                                    Text(
                                      nombreEventoIncidenciaExamen,
                                      style: const TextStyle(fontSize: 18),
                                    )
                                  ]),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
            Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Eventos"),
                  Checkbox(
                      value: eventosBool,
                      onChanged: (value) {
                        if (eventosBool) {
                          setState(() {
                            eventosBool = false;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEvents(widget.alumnoElegido);
                          });
                        } else {
                          setState(() {
                            eventosBool = true;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEvents(widget.alumnoElegido);
                          });
                        }
                      }),
                  const Text("Examenes"),
                  Checkbox(
                    value: examenesBool,
                    onChanged: (value) {
                      if (examenesBool) {
                        setState(() {
                          examenesBool = false;
                          examenesEventosIncidenciasDelDiaSeleccionado =
                              _getEvents(widget.alumnoElegido);
                        });
                      } else {
                        setState(() {
                          examenesBool = true;
                          examenesEventosIncidenciasDelDiaSeleccionado =
                              _getEvents(widget.alumnoElegido);
                        });
                      }
                    },
                  ),
                  const Text("Incidencias"),
                  Checkbox(
                      value: incidenciasBool,
                      onChanged: (value) {
                        if (incidenciasBool) {
                          setState(() {
                            incidenciasBool = false;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEvents(widget.alumnoElegido);
                          });
                        } else {
                          setState(() {
                            incidenciasBool = true;
                            examenesEventosIncidenciasDelDiaSeleccionado =
                                _getEvents(widget.alumnoElegido);
                          });
                        }
                      }),
                ]),
                Expanded(
                  child: examenesEventosIncidenciasDelAlumno.isEmpty
                      ? Center(
                          child: Text(
                              '${widget.alumnoElegido.nombre} ${widget.alumnoElegido.apellido} no tiene eventos próximos'))
                      : ListView.builder(
                          itemCount: examenesEventosIncidenciasDelAlumno.length,
                          itemBuilder: (context, index) {
                            var item =
                                examenesEventosIncidenciasDelAlumno[index];
                            String nombreEventoExamen = "prueba";

                            // Comprobar el tipo del elemento y asignar la fecha correspondiente
                            if (item is Evento) {
                              nombreEventoExamen = item
                                  .nombre_evento; // Suponiendo que fecha_inicio es la fecha del evento
                            } else if (item is Examen) {
                              Asignatura asignatura = item.asignatura;
                              nombreEventoExamen =
                                  "Examen de ${asignatura.nombre_asignatura}";
                            } else if (item is Incidencia) {
                              Incidencia incidencia = item;
                              nombreEventoExamen = incidencia.titulo_incidencia;
                            }

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () {
                                    if (item is Examen) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ExamenPanel(
                                                    alumnoSeleccionado:
                                                        widget.alumnoElegido,
                                                    examenSeleccionado: item,
                                                    profesorSeleccionado:
                                                        item.profesor,
                                                    claseExamen: item.clase,
                                                  )));
                                    } else if (item is Evento) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => EventoPanel(
                                                    alumnoSeleccionado:
                                                        widget.alumnoElegido,
                                                    eventoSeleccionado: item,
                                                    listaAlumnos: item.alumnos,
                                                    listaProfesores:
                                                        item.profesores,
                                                  )));
                                    }
                                  },
                                  child: Text(
                                    nombreEventoExamen,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
