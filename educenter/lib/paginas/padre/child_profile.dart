// ignore_for_file: camel_case_types

import 'package:educenter/paginas/padre/asignaturas_hijo.dart';
import 'package:educenter/bbdd/centro_bbdd.dart';
import 'package:educenter/paginas/padre/centro_panel.dart';
import 'package:educenter/citas_panel.dart';
import 'package:educenter/calendario.dart';
import 'package:educenter/paginas/padre/horario.dart';
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
                child: widget.alumnoElegido.url_foto_perfil != null
                    ? Image.network(
                        widget.alumnoElegido.url_foto_perfil.toString(),
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.person),
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
                              builder: (context) => Calendario(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Horario(
                                  alumnoSeleccionado: widget.alumnoElegido)));
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
