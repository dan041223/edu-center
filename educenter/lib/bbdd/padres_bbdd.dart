// ignore_for_file: camel_case_types

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';

class padresBBDD {
  Future<List<Alumno>> getHijosDePadre() async {
    List<Alumno> listaHijos = List.empty(growable: true);

    final data = await usersBBDD.supabase
        .from("padres_alumnos")
        .select("id_hijo")
        .eq("id_padre", usersBBDD.user!.id);

    List<int> idsHijos = data.map((item) => item["id_hijo"] as int).toList();

    final hijosData = await usersBBDD.supabase
        .from("alumnos")
        .select("*")
        .inFilter("id_alumno", idsHijos);
    // final data = await usersBBDD.supabase.from("alumnos").select("*").eq(
    //     "id_alumno",
    //     usersBBDD.supabase
    //         .from("padres_alumnos")
    //         .select("id_hijo")
    //         .eq("id_padre", usersBBDD.user!.id));

    for (var hijosMap in hijosData) {
      Clase clase = await AlumnosBBDD().getClaseAlumno(hijosMap["id_clase"]);
      List<Asignatura> asignaturas =
          await AlumnosBBDD().getAsignaturasAlumno(hijosMap["id_alumno"]);
      Alumno alumno = Alumno(
          hijosMap["id_alumno"],
          hijosMap["nombre"],
          hijosMap["apellido"],
          DateTime.parse(hijosMap["fecha_nacimiento"]),
          hijosMap["id_clase"],
          clase,
          hijosMap["url_foto_perfil"],
          asignaturas);
      listaHijos.add(alumno);
    }
    return listaHijos;
  }
}
