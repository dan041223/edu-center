import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/evento.dart';
import 'package:educenter/eventos_examenes.dart';
import 'package:educenter/examen.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/examen.dart';
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
  List<Object> examenesEventosDelDiaSeleccionado = List.empty(growable: true);
  List<Evento> listaEventos = List.empty(growable: true);
  List<Examen> listaExamenes = List.empty(growable: true);
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
      setState(() {});
    });
  }

  List<Object> _getEventsForDay(DateTime day, Alumno alumnoElegido) {
    List<Object> eventosDeHoy = List.empty(growable: true);
    List<Object> examenesDeHoy = List.empty(growable: true);

    List<Object> examenesEventosDeHoy = List.empty(growable: true);

    if (eventosBool) {
      for (var evento in listaEventos) {
        if (evento.fecha_inicio.day.compareTo(day.day) == 0 &&
            evento.fecha_inicio.month.compareTo(day.month) == 0 &&
            evento.fecha_inicio.year.compareTo(day.year) == 0) {
          eventosDeHoy.add(evento);
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
    examenesEventosDeHoy = eventosDeHoy + examenesDeHoy;

    return examenesEventosDeHoy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos - Examenes"),
      ),
      drawer: const DrawerMio(),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Eventos"),
            Checkbox(
                value: eventosBool,
                onChanged: (value) {
                  if (eventosBool) {
                    setState(() {
                      eventosBool = false;
                      examenesEventosDelDiaSeleccionado =
                          _getEventsForDay(_focusedDay, widget.alumnoElegido);
                    });
                  } else {
                    setState(() {
                      eventosBool = true;
                      examenesEventosDelDiaSeleccionado =
                          _getEventsForDay(_focusedDay, widget.alumnoElegido);
                    });
                  }
                }),
            Text("Examenes"),
            Checkbox(
              value: examenesBool,
              onChanged: (value) {
                if (examenesBool) {
                  setState(() {
                    examenesBool = false;
                    examenesEventosDelDiaSeleccionado =
                        _getEventsForDay(_focusedDay, widget.alumnoElegido);
                  });
                } else {
                  setState(() {
                    examenesBool = true;
                    examenesEventosDelDiaSeleccionado =
                        _getEventsForDay(_focusedDay, widget.alumnoElegido);
                  });
                }
              },
            ),
          ]),
          TableCalendar(
            calendarStyle: CalendarStyle(),
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
                examenesEventosDelDiaSeleccionado =
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
            child: examenesEventosDelDiaSeleccionado.isEmpty
                ? const Center(
                    child: Text('No hay eventos en el día seleccionado'))
                : ListView.builder(
                    itemCount: examenesEventosDelDiaSeleccionado.length,
                    itemBuilder: (context, index) {
                      var item = examenesEventosDelDiaSeleccionado[index];
                      String nombreEventoExamen = "prueba";

                      // Comprobar el tipo del elemento y asignar la fecha correspondiente
                      if (item is Evento) {
                        nombreEventoExamen = item
                            .nombre_evento; // Suponiendo que fecha_inicio es la fecha del evento
                      } else if (item is Examen) {
                        Asignatura asignatura = item.asignatura;
                        nombreEventoExamen =
                            "Examen de " + asignatura.nombre_asignatura;
                      }

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              if (item is Examen) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ExamenPanel(
                                          alumnoSeleccionado:
                                              widget.alumnoElegido,
                                          examenSeleccionado: item,
                                          profesorSeleccionado: item.profesor,
                                          claseExamen: item.clase,
                                        )));
                              } else if (item is Evento) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const EventoPanel()));
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
      ),
    );
  }
}
