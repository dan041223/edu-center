import 'package:educenter/models/clase.dart';

class Alumno {
  int id_alumno;
  String nombre;
  String apellido;
  DateTime fecha_nacimiento;
  int id_clase;
  Clase clase;

  Alumno(this.id_alumno, this.nombre, this.apellido, this.fecha_nacimiento,
      this.id_clase, this.clase);
}
