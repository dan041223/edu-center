import 'package:educenter/drawer.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class ExamenPanel extends StatefulWidget {
  Examen examenSeleccionado;
  Alumno alumnoSeleccionado;
  Usuario profesorSeleccionado;
  Clase claseExamen;
  ExamenPanel(
      {super.key,
      required this.examenSeleccionado,
      required this.alumnoSeleccionado,
      required this.profesorSeleccionado,
      required this.claseExamen});

  @override
  State<ExamenPanel> createState() => _ExamenPanelState();
}

class _ExamenPanelState extends State<ExamenPanel> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Examen de ${widget.examenSeleccionado.asignatura.nombre_asignatura} ${widget.examenSeleccionado.clase.nombre_clase}")),
        drawer: const DrawerMio(),
        body: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(25),
                height: 150,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.examenSeleccionado.fecha_examen
                              .toString()
                              .split(" ")
                              .first,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.calendar_month)
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        widget.examenSeleccionado.asignatura.nombre_asignatura,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Profesor al mando:",
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://medac.es/sites/default/files/blog/destacadas/Qu%C3%A9%20hay%20que%20estudiar%20para%20ser%20profesora%20de%20infantil.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${widget.profesorSeleccionado.nombre} ${widget.profesorSeleccionado.apellido}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
