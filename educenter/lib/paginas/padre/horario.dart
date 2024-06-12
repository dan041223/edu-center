// ignore_for_file: must_be_immutable

import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/horario_clase.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

class Horario extends StatefulWidget {
  Alumno alumnoSeleccionado;

  Horario({super.key, required this.alumnoSeleccionado});

  @override
  State<Horario> createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  int getNumeroDia(String dia) {
    switch (dia) {
      case "lunes":
        return 0;
      case "martes":
        return 1;
      case "miercoles":
        return 2;
      case "jueves":
        return 3;
      default:
        return 4;
    }
  }

  List<DataRow> conseguirFilas() {
    List<DataRow> filas = List.empty(growable: true);
    for (var hora = 0; hora < Utils.horasSemanaIniciales.length; hora++) {
      List<DataCell> celdasFila = List.empty(growable: true);
      celdasFila.add(DataCell(Text(Utils.horasSemanaIniciales[hora] +
          " - " +
          Utils.horasSemanaFinales[hora])));
      for (var dia = 0; dia < Utils.diasSemana.length; dia++) {
        for (HorarioClase valor in horario) {
          if (valor.dia_semana == Utils.diasSemana[dia] &&
              valor.hora_inicial == Utils.horasSemanaIniciales[hora]) {
            celdasFila.add(DataCell(Text(valor.asignatura.nombre_asignatura)));
          }
        }
      }
      filas.add(DataRow(cells: celdasFila));
    }
    return filas;
  }

  List<HorarioClase> horario = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () async {
      horario = await ClasesBBDD()
          .getHorarioClase(widget.alumnoSeleccionado.id_clase);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: horario.length > 0
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Horas")),
                      DataColumn(label: Text("Lunes")),
                      DataColumn(label: Text("Martes")),
                      DataColumn(label: Text("Miercoles")),
                      DataColumn(label: Text("Jueves")),
                      DataColumn(label: Text("Viernes")),
                    ],
                    rows: conseguirFilas(),
                  ),
                ),
              ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
