// ignore_for_file: camel_case_types

import 'package:educenter/asignaturas_hijo.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/centro_panel.dart';
import 'package:educenter/citas_panel.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/eventos_hijo.dart';
import 'package:educenter/horario.dart';
import 'package:educenter/models/alumno.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class childProfile extends StatefulWidget {
  Alumno alumnoElegido;
  childProfile({super.key, required this.alumnoElegido});

  @override
  State<childProfile> createState() => _childProfileState();
}

class _childProfileState extends State<childProfile> {
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Scrollbar(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Card(
                      color: Colors.amber,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AsignaturasHijo(
                                    asignaturas:
                                        widget.alumnoElegido.asignaturas,
                                    alumnoElegido: widget.alumnoElegido,
                                  )));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.book,
                                size: 40,
                              ),
                              Text(
                                "Asignaturas",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.red,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EventosHijo(
                                    alumnoElegido: widget.alumnoElegido,
                                  )));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.calendar_month,
                                size: 40,
                              ),
                              Text(
                                "Calendario",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.blue,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => AnotacionesHijo(
                          //         alumnoElegido: widget.alumnoElegido)));
                          ClasesBBDD()
                              .getHorarioClase(widget.alumnoElegido.id_clase)
                              .then((horario) => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Horario(
                                          alumnoSeleccionado:
                                              widget.alumnoElegido,
                                          horario: horario))));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.watch_later_outlined,
                                size: 40,
                              ),
                              Text(
                                "Horario",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.green,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => AnotacionesHijo(
                          //         alumnoElegido: widget.alumnoElegido)));
                          CentroBBDD()
                              .getCentroAlumno(widget.alumnoElegido)
                              .then((centro) =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CentroPanel(
                                            centro: centro,
                                            alumno: widget.alumnoElegido,
                                          ))));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.business_outlined,
                                size: 40,
                              ),
                              Text(
                                "Centro",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.purple,
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => AnotacionesHijo(
                          //         alumnoElegido: widget.alumnoElegido)));
                          CentroBBDD()
                              .getCentroAlumno(widget.alumnoElegido)
                              .then((centro) =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CitasPanel(
                                            alumno: widget.alumnoElegido,
                                          ))));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.ballot_outlined,
                                size: 40,
                              ),
                              Text(
                                "Citas",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
