import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/examen.dart';

class ExamenesAlumnoBBDD {
  Future<String> getNotaExamenAlumno(Alumno alumno, Examen examen) async {
    var data = await usersBBDD.supabase
        .from("examen_alumno")
        .select("calificacion")
        .eq("id_alumno", alumno.id_alumno)
        .eq("id_examen", examen.id_examen)
        .single();

    String nota;

    // ignore: unnecessary_null_comparison
    if (data == null) {
      return "N/A";
    } else {
      nota = data["calificacion"].toString();
      return nota;
    }
  }

  Future<String> getObservacionesExamenAlumno(
      Alumno alumno, Examen examen) async {
    var data = await usersBBDD.supabase
        .from("examen_alumno")
        .select("observaciones")
        .eq("id_alumno", alumno.id_alumno)
        .eq("id_examen", examen.id_examen)
        .single();

    String observaciones;

    // ignore: unnecessary_null_comparison
    if (data == null) {
      return "N/A";
    } else {
      observaciones = data["observaciones"].toString();
      return observaciones;
    }
  }

  Future<List<Examen>> getExamenesAsignaturaAlumno(
    Alumno alumno,
    Asignatura asignatura,
  ) async {
    List<Examen> listaExamenesAlumno =
        await AlumnosBBDD().getListaExamenesDeAlumno(alumno);
    List<Examen> listaExamenesAsignaturaAlumno = [];
    for (var examen in listaExamenesAlumno) {
      if (examen.asignatura.id_asignatura == asignatura.id_asignatura) {
        listaExamenesAsignaturaAlumno.add(examen);
      }
    }
    return listaExamenesAsignaturaAlumno;
  }
}
