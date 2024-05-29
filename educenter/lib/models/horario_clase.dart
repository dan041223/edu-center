import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:flutter/material.dart';

class HorarioClase {
  int id_clase;
  String dia_semana;
  String hora_inicial;
  String hora_final;
  int id_asignatura;
  Asignatura asignatura;
  Clase clase;

  HorarioClase(this.id_clase, this.dia_semana, this.hora_inicial,
      this.hora_final, this.id_asignatura, this.asignatura, this.clase);
}
