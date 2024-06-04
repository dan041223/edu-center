import 'package:flutter/material.dart';

class Centro {
  int id_centro;
  String nombre_centro;
  String direccion_centro;
  String email_centro;
  int telefono;
  TimeOfDay horario_centro_inicio;
  TimeOfDay horario_centro_fin;
  String color;
  String url_imagen_centro;

  Centro(
      this.id_centro,
      this.nombre_centro,
      this.direccion_centro,
      this.email_centro,
      this.telefono,
      this.horario_centro_inicio,
      this.horario_centro_fin,
      this.color,
      this.url_imagen_centro);
}
