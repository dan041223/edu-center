import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';

class Asignatura {
  int id_asignatura;
  String? id_profesor;
  int id_clase;
  String nombre_asignatura;
  String color_codigo;
  Usuario profesor;
  Clase? clase;

  Asignatura(this.id_asignatura, this.id_clase, this.id_profesor,
      this.nombre_asignatura, this.color_codigo, this.profesor,
      [this.clase]);
}
