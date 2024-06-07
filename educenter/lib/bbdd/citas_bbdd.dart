import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/cita.dart';
import 'package:educenter/models/usuario.dart';

class CitasBBDD {
  updateFechaCitaPadre(Cita cita, DateTime nuevaFecha) async {
    await usersBBDD.supabase
        .from("citas")
        .update({"fecha_padre": nuevaFecha.toIso8601String()}).match(
            {"id_cita": cita.id_cita});
  }

  updateFechaCitaTutor(Cita cita, DateTime nuevaFecha) async {
    await usersBBDD.supabase
        .from("citas")
        .update({"fecha_tutor": nuevaFecha.toIso8601String()}).match(
            {"id_cita": cita.id_cita});
  }

  crearCita(String titulo, String descripcion, DateTime fechaPropuesta,
      Alumno alumno) async {
    Usuario tutor = await AlumnosBBDD().getTutorAlumno(alumno);

    await usersBBDD.supabase.from("citas").insert({
      "id_alumno": alumno.id_alumno,
      "id_profesor": tutor.id_usuario,
      "fecha_padre": fechaPropuesta.toIso8601String(),
      "titulo": titulo,
      "descripcion": descripcion
    });
  }

  crearCitaProfesor(String titulo, String descripcion, DateTime fechaPropuesta,
      Alumno alumno, Usuario user) async {
    await usersBBDD.supabase.from("citas").insert({
      "id_alumno": alumno.id_alumno,
      "id_profesor": user.id_usuario,
      "fecha_tutor": fechaPropuesta.toIso8601String(),
      "titulo": titulo,
      "descripcion": descripcion
    });
  }
}
