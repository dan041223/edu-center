// ignore_for_file: must_be_immutable

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/evento.dart';
import 'package:educenter/examen_panel.dart';
import 'package:educenter/incidencia_hijo.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/profe/agregar_evento.dart';
import 'package:educenter/paginas/profe/agregar_examen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  DateTime fechaHoy = DateTime.now();
  Alumno? alumnoElegido;
  Usuario? profe;
  Calendario({super.key, this.alumnoElegido, this.profe});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  bool eventosBool = true;
  bool examenesBool = true;
  bool incidenciasBool = true;
  List<Object> calendarioItemsDelDiaSeleccionado = List.empty(growable: true);
  List<Object> calendarioItems = List.empty(growable: true);
  List<Object> listaEventosObjeto = List.empty(growable: true);
  List<Object> listaExamenesObjeto = List.empty(growable: true);
  List<Object> listaIncidenciasObjeto = List.empty(growable: true);
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      if (widget.alumnoElegido != null) {
        await getItemCalendarioAlumno(widget.alumnoElegido!);
      } else if (widget.profe != null) {
        await getItemCalendarioProfe(widget.profe!);
      }
      if (!mounted) {
        return;
      }
      if (!mounted) {
        return;
      }
      setState(() {
        loading = false;
      });
    });
  }

  Future getItemCalendarioAlumno(Alumno alumno) async {
    final results = await Future.wait([
      AlumnosBBDD().getListaEventosDeAlumno(alumno),
      AlumnosBBDD().getListaExamenesDeAlumno(alumno),
      AlumnosBBDD().getListaIncidenciasDeAlumno(alumno),
    ]);

    listaIncidenciasObjeto = results[2];
    listaExamenesObjeto = results[1];
    listaEventosObjeto = results[0];

    calendarioItems.addAll(listaIncidenciasObjeto);
    calendarioItems.addAll(listaExamenesObjeto);
    calendarioItems.addAll(listaEventosObjeto);
  }

  Future getItemCalendarioProfe(Usuario profe) async {
    final results = await Future.wait([
      ProfesoresBBDD().getListaEventos(profe),
      ProfesoresBBDD().getListaExamenes(profe),
      ProfesoresBBDD().getListaIncidencias(profe),
    ]);

    listaIncidenciasObjeto = results[2];
    listaExamenesObjeto = results[1];
    listaEventosObjeto = results[0];

    calendarioItems.addAll(listaIncidenciasObjeto);
    calendarioItems.addAll(listaExamenesObjeto);
    calendarioItems.addAll(listaEventosObjeto);
  }

  List<Object> _getEvents() {
    List<Object> eventosDeHoy = List.empty(growable: true);
    List<Object> examenesDeHoy = List.empty(growable: true);
    List<Object> incidentesDeHoy = List.empty(growable: true);

    calendarioItems = List.empty(growable: true);

    if (eventosBool) {
      for (var evento in listaEventosObjeto) {
        eventosDeHoy.add(evento);
      }
    }

    if (incidenciasBool) {
      for (var incidencia in listaIncidenciasObjeto) {
        incidentesDeHoy.add(incidencia);
      }
    }

    if (examenesBool) {
      for (var examen in listaExamenesObjeto) {
        examenesDeHoy.add(examen);
      }
    }
    calendarioItems.addAll(eventosDeHoy);
    calendarioItems.addAll(examenesDeHoy);
    calendarioItems.addAll(incidentesDeHoy);

    return calendarioItems;
  }

  List<Object> _getEventsForDay(DateTime day) {
    List<Object> eventosDeHoy = List.empty(growable: true);
    List<Object> examenesDeHoy = List.empty(growable: true);
    List<Object> incidentesDeHoy = List.empty(growable: true);

    List<Object> examenesEventosIncidenciasDeHoy = List.empty(growable: true);

    if (eventosBool) {
      for (var evento in listaEventosObjeto) {
        if ((evento as Evento).fecha_inicio.day.compareTo(day.day) == 0 &&
            evento.fecha_inicio.month.compareTo(day.month) == 0 &&
            evento.fecha_inicio.year.compareTo(day.year) == 0) {
          eventosDeHoy.add(evento);
        }
      }
    }

    if (incidenciasBool) {
      for (var incidencia in listaIncidenciasObjeto) {
        if ((incidencia as Incidencia)
                    .fecha_incidencia
                    .day
                    .compareTo(day.day) ==
                0 &&
            incidencia.fecha_incidencia.month.compareTo(day.month) == 0 &&
            incidencia.fecha_incidencia.year.compareTo(day.year) == 0) {
          incidentesDeHoy.add(incidencia);
        }
      }
    }

    if (examenesBool) {
      for (var examen in listaExamenesObjeto) {
        if ((examen as Examen).fecha_examen.day.compareTo(day.day) == 0 &&
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
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          openButtonBuilder:
              DefaultFloatingActionButtonBuilder(child: const Icon(Icons.add)),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.format_list_numbered_sharp),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AgregarExamen(profe: widget.profe!),
                ));
              },
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.calendar_month_outlined),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AgregarEvento(
                    profesor: widget.profe!,
                  ),
                ));
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            loading
                ? Center(child: const CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Eventos"),
                            Checkbox(
                                value: eventosBool,
                                onChanged: (value) {
                                  if (eventosBool) {
                                    setState(() {
                                      eventosBool = false;
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEventsForDay(_focusedDay);
                                    });
                                  } else {
                                    setState(() {
                                      eventosBool = true;
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEventsForDay(_focusedDay);
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
                                    calendarioItemsDelDiaSeleccionado =
                                        _getEventsForDay(_focusedDay);
                                  });
                                } else {
                                  setState(() {
                                    examenesBool = true;
                                    calendarioItemsDelDiaSeleccionado =
                                        _getEventsForDay(_focusedDay);
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
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEventsForDay(_focusedDay);
                                    });
                                  } else {
                                    setState(() {
                                      incidenciasBool = true;
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEventsForDay(_focusedDay);
                                    });
                                  }
                                }),
                          ]),
                      TableCalendar(
                        locale: "es_ES",
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Mes',
                          CalendarFormat.twoWeeks: '2 semanas',
                          CalendarFormat.week: 'Semana',
                        },
                        calendarStyle: const CalendarStyle(),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            calendarioItemsDelDiaSeleccionado =
                                _getEventsForDay(selectedDay);
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
                          return _getEventsForDay(day);
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: calendarioItemsDelDiaSeleccionado.isEmpty
                            ? const Center(
                                child: Text(
                                    'No hay eventos en el día seleccionado'))
                            : ListView.builder(
                                itemCount:
                                    calendarioItemsDelDiaSeleccionado.length,
                                itemBuilder: (context, index) {
                                  var item =
                                      calendarioItemsDelDiaSeleccionado[index];
                                  String nombreEventoIncidenciaExamen = "";

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
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExamenPanel(
                                                        alumnoSeleccionado:
                                                            widget
                                                                .alumnoElegido,
                                                        examenSeleccionado:
                                                            item,
                                                        profesorSeleccionado:
                                                            item.profesor,
                                                        claseExamen: item.clase,
                                                      )));
                                        } else if (item is Evento) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventoPanel(
                                                        alumnoSeleccionado:
                                                            widget
                                                                .alumnoElegido,
                                                        eventoSeleccionado:
                                                            item,
                                                        listaAlumnos:
                                                            item.alumnos,
                                                        listaProfesores:
                                                            item.profesores,
                                                      )));
                                        } else if (item is Incidencia) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IncidenciaHijo(
                                                          incidenciaSeleccionada:
                                                              item)));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              item is Examen
                                                  ? const Icon(Icons
                                                      .format_list_numbered_sharp)
                                                  : item is Evento
                                                      ? const Icon(Icons
                                                          .calendar_month_outlined)
                                                      : item is Incidencia
                                                          ? const Icon(Icons
                                                              .crisis_alert)
                                                          : Container(),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  nombreEventoIncidenciaExamen,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                children: [
                                                  Text(
                                                    item is Examen
                                                        ? item.fecha_examen
                                                            .toString()
                                                            .split(" ")
                                                            .first
                                                        : item is Evento
                                                            ? item.fecha_inicio
                                                                .toString()
                                                                .split(" ")
                                                                .first
                                                            : item is Incidencia
                                                                ? item
                                                                    .fecha_incidencia
                                                                    .toString()
                                                                    .split(" ")
                                                                    .first
                                                                : "",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const Icon(Icons
                                                      .calendar_month_outlined),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
            loading
                ? Center(child: const CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Eventos"),
                            Checkbox(
                                value: eventosBool,
                                onChanged: (value) {
                                  if (eventosBool) {
                                    setState(() {
                                      eventosBool = false;
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEvents();
                                    });
                                  } else {
                                    setState(() {
                                      eventosBool = true;
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEvents();
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
                                    calendarioItemsDelDiaSeleccionado =
                                        _getEvents();
                                  });
                                } else {
                                  setState(() {
                                    examenesBool = true;
                                    calendarioItemsDelDiaSeleccionado =
                                        _getEvents();
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
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEvents();
                                    });
                                  } else {
                                    setState(() {
                                      incidenciasBool = true;
                                      calendarioItemsDelDiaSeleccionado =
                                          _getEvents();
                                    });
                                  }
                                }),
                          ]),
                      Expanded(
                        child: calendarioItems.isEmpty
                            ? Center(
                                child: Text(widget.alumnoElegido != null
                                    ? '${widget.alumnoElegido!.nombre} ${widget.alumnoElegido!.apellido} no tiene eventos próximos'
                                    : "No tienes eventos próximos"))
                            : ListView.builder(
                                itemCount: calendarioItems.length,
                                itemBuilder: (context, index) {
                                  var item = calendarioItems[index];
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
                                    nombreEventoExamen =
                                        incidencia.titulo_incidencia;
                                  }

                                  return Card(
                                    margin: const EdgeInsets.all(8.0),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (item is Examen) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExamenPanel(
                                                          alumnoSeleccionado:
                                                              widget
                                                                  .alumnoElegido,
                                                          examenSeleccionado:
                                                              item,
                                                          profesorSeleccionado:
                                                              item.profesor,
                                                          claseExamen:
                                                              item.clase,
                                                        )));
                                          } else if (item is Evento) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EventoPanel(
                                                          alumnoSeleccionado:
                                                              widget
                                                                  .alumnoElegido,
                                                          eventoSeleccionado:
                                                              item,
                                                          listaAlumnos:
                                                              item.alumnos,
                                                          listaProfesores:
                                                              item.profesores,
                                                        )));
                                          } else if (item is Incidencia) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        IncidenciaHijo(
                                                            incidenciaSeleccionada:
                                                                item)));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                item is Examen
                                                    ? const Icon(Icons
                                                        .format_list_numbered_sharp)
                                                    : item is Evento
                                                        ? const Icon(Icons
                                                            .calendar_month_outlined)
                                                        : item is Incidencia
                                                            ? const Icon(Icons
                                                                .crisis_alert)
                                                            : Container(),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                  child: Text(
                                                    nombreEventoExamen,
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  children: [
                                                    Text(
                                                      item is Examen
                                                          ? item.fecha_examen
                                                              .toString()
                                                              .split(" ")
                                                              .first
                                                          : item is Evento
                                                              ? item
                                                                  .fecha_inicio
                                                                  .toString()
                                                                  .split(" ")
                                                                  .first
                                                              : item
                                                                      is Incidencia
                                                                  ? item
                                                                      .fecha_incidencia
                                                                      .toString()
                                                                      .split(
                                                                          " ")
                                                                      .first
                                                                  : "",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Icon(Icons
                                                        .calendar_month_outlined),
                                                  ],
                                                ),
                                              ]),
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
