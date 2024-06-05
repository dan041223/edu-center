// ignore_for_file: prefer_const_constructors

import 'package:educenter/paginas/profe/clase_asignatura.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AsignaturasClase extends StatefulWidget {
  Clase clase;
  List<Asignatura> asignaturas;
  AsignaturasClase({super.key, required this.clase, required this.asignaturas});

  @override
  State<AsignaturasClase> createState() => AasignaturasClaseState();
}

class AasignaturasClaseState extends State<AsignaturasClase> {
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
              Text(
                "Asignaturas de ${widget.clase.nombre_clase}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                              builder: (context) => ClaseAsignatura(
                                    asignatura: widget.asignaturas[index],
                                    clase: widget.clase,
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
