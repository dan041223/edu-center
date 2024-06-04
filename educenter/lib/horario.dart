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
  List<String> diasSemana = List.empty(growable: true);
  List<String> horas = List.empty(growable: true);
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1), () async {
      diasSemana = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"];
      horas = await ClasesBBDD()
          .getHorasPosiblesHorario(widget.alumnoSeleccionado.clase);
    });
    super.initState();
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
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [
      const DataColumn(label: Text("Horas")),
    ];
    for (var dia in diasSemana) {
      columns.add(DataColumn(label: Text(dia)));
    }
    return columns;
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];
    for (var hora in horas) {
      List<DataCell> cells = [DataCell(Text(hora))];
      for (var dia in diasSemana) {
        var clase = widget.horario.firstWhere(
          (element) =>
              element.dia_semana == dia && element.hora_inicial == hora,
          orElse: () => HorarioClase(
              0,
              "",
              "",
              "",
              0,
              Asignatura(
                  0, 0, "", "", "", Usuario("", "", "", "", 0, 0, "", "", "")),
              Clase(0, "", 0)),
        );
        cells.add(DataCell(Text(clase.asignatura.nombre_asignatura)));
      }
      rows.add(DataRow(cells: cells));
    }
    return rows;
  }
}
