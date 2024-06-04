import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/usuario.dart';

class Cita {
  int id_cita;
  int id_alumno;
  String id_tutor;
  DateTime? fecha_padre;
  DateTime? fecha_tutor;
  String titulo;
  String descripcion;
  Usuario tutor;
  Alumno alumno;

  Cita(this.id_cita, this.id_alumno, this.id_tutor, this.fecha_padre,
      this.fecha_tutor, this.titulo, this.descripcion, this.tutor, this.alumno);
}
