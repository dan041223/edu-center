import 'package:flutter/material.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/usuario.dart';
import 'package:url_launcher/url_launcher.dart';

class EventoPanel extends StatefulWidget {
  final Evento eventoSeleccionado;
  final Alumno alumnoSeleccionado;
  final List<Usuario> listaProfesores;
  final List<Alumno> listaAlumnos;

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

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

class _EventoPanelState extends State<EventoPanel> {
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
        title: Text(widget.eventoSeleccionado.nombre_evento),
      ),
      drawer: const DrawerMio(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: hexToColor(widget.eventoSeleccionado.color),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(25),
              child: Column(
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
                            widget.eventoSeleccionado.nombre_evento,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
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
                          const Icon(Icons.calendar_month),
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
                  widget.eventoSeleccionado.descripcion_evento != null &&
                          widget.eventoSeleccionado.descripcion_evento != ""
                      ? Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            widget.eventoSeleccionado.descripcion_evento!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.listaProfesores.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          // Aquí puedes añadir la acción al hacer clic en el profesor.
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.map,
                            size: 70,
                          ),
                          Text(
                            "Ubicacion",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.open_in_new,
                            size: 40,
                          )
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
    );
  }
}
