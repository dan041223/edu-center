// ignore_for_file: camel_case_types

import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';

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
      Alumno alumno = Alumno(
          hijosMap["id_alumno"],
          hijosMap["nombre"],
          hijosMap["apellido"],
          DateTime.parse(hijosMap["fecha_nacimiento"]),
          hijosMap["id_clase"]);
      listaHijos.add(alumno);
    }
    return listaHijos;
  }
}
