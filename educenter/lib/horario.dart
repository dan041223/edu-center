// ignore_for_file: must_be_immutable

import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/drawer.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/horario_clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';

class Horario extends StatefulWidget {
  Alumno alumnoSeleccionado;
  List<HorarioClase> horario;
  Horario({super.key, required this.alumnoSeleccionado, required this.horario});

  @override
  State<Horario> createState() => _HorarioState();
}

class _HorarioState extends State<Horario> {
  List<String> diasSemana = [
    "lunes",
    "martes",
    "miercoles",
    "jueves",
    "viernes"
  ];
  List<String> horasSemanaIniciales = [
    "08:00:00",
    "09:00:00",
    "10:00:00",
    "11:00:00",
    "12:00:00",
    "13:00:00"
  ];
  List<String> horasSemanaFinales = [
    "09:00:00",
    "10:00:00",
    "11:00:00",
    "12:00:00",
    "13:00:00",
    "14:00:00"
  ];

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
    for (var hora = 0; hora < horasSemanaIniciales.length; hora++) {
      List<DataCell> celdasFila = List.empty(growable: true);
      celdasFila.add(DataCell(
          Text(horasSemanaIniciales[hora] + " - " + horasSemanaFinales[hora])));
      for (var dia = 0; dia < diasSemana.length; dia++) {
        for (HorarioClase valor in widget.horario) {
          if (valor.dia_semana == diasSemana[dia] &&
              valor.hora_inicial == horasSemanaIniciales[hora]) {
            celdasFila.add(DataCell(Text(valor.asignatura.nombre_asignatura)));
          }
        }
      }
      filas.add(DataRow(cells: celdasFila));
    }
    return filas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const DrawerMio(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
        ),
      ),
    );
  }
}
