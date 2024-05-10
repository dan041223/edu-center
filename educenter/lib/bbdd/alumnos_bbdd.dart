import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';

class AlumnosBBDD {
  Future<Alumno> getAlumno(int idAlumno) async {
    var data = await usersBBDD.supabase
        .from('alumnos')
        .select('*')
        .eq("id_alumno", idAlumno)
        .single();
    Alumno alumnoSeleccionado = Alumno(
        data["id_alumno"],
        data["nombre"],
        data["apellido"],
        DateTime.parse(data["fecha_nacimiento"]),
        data["id_clase"]);
    return alumnoSeleccionado;
  }

  Future<List<Asignatura>> getAsignaturasAlumno(Alumno alumno) async {
    //Pillo la clase del alumno - Pillo las asignaturas de esa clase
    List<Asignatura> listaAsignaturas = List.empty(growable: true);
    var idClaseDeAlumno = await usersBBDD.supabase
        .from("alumnos")
        .select("id_clase")
        .eq("id_alumno", alumno.id_alumno)
        .single();
    var asignaturasDeAlumno = await usersBBDD.supabase
        .from("asignatura")
        .select()
        .eq("id_clase", int.parse(idClaseDeAlumno[0]));
    for (var asignaturas in asignaturasDeAlumno) {
      Asignatura asignatura = Asignatura(
          asignaturas["id_asignatura"],
          asignaturas["id_clase"],
          asignaturas["id_profesor"],
          asignaturas["nombre_asignatura"]);
      listaAsignaturas.add(asignatura);
    }
    return listaAsignaturas;
  }
}
