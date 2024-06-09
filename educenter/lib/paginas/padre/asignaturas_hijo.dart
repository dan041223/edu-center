// ignore_for_file: prefer_const_constructors

import 'package:educenter/paginas/padre/asignatura_hijo.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AsignaturasHijo extends StatefulWidget {
  List<Asignatura> asignaturas;
  Alumno alumnoElegido;
  AsignaturasHijo(
      {super.key, required this.asignaturas, required this.alumnoElegido});

  @override
  State<AsignaturasHijo> createState() => AasignaturasHijoState();
}

class AasignaturasHijoState extends State<AsignaturasHijo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Title"),
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
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.asignaturas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Utils.hexToColor(
                          widget.asignaturas[index].color_codigo),
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => asignatura_hijo(
                                    alumnoElegido: widget.alumnoElegido,
                                    asignaturaElegida:
                                        widget.asignaturas[index],
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            widget.asignaturas[index].nombre_asignatura,
                            style: const TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
