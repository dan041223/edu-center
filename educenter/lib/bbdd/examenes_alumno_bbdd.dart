import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
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
}
