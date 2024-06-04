import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';

class Examen {
  int id_examen;
  int id_asignatura;
  String id_profesor;
  int id_clase;
  DateTime fecha_examen;
  int trimestre;
  Asignatura asignatura;
  Usuario profesor;
  Clase clase;
  String? descripcion;

  Examen(
      this.id_examen,
      this.id_asignatura,
      this.id_profesor,
      this.id_clase,
      this.fecha_examen,
      this.trimestre,
      this.asignatura,
      this.profesor,
      this.clase,
      this.descripcion);
}
