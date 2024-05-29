import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/horario_clase.dart';

class ClasesBBDD {
  Future<List<HorarioClase>> getHorarioClase(int id_clase) async {
    var data = await usersBBDD.supabase
        .from("horario_clase")
        .select("*")
        .eq("id_clase", id_clase)
        .order("hora_inicial", ascending: true);

    List<HorarioClase> listaHorario = List.empty(growable: true);

    for (var horario in data) {
      Asignatura asignatura = await getAsignatura(horario["id_asignatura"]);
      Clase clase = await getClase(horario["id_clase"]);
      HorarioClase horarioClase = HorarioClase(
          horario["id_clase"],
          horario["dia_semana"],
          horario["hora_inicial"],
          horario["hora_final"],
          horario["id_asignatura"],
          asignatura,
          clase);
      listaHorario.add(horarioClase);
    }
    return listaHorario;
  }

  Future<List<String>> getHorasPosiblesHorario(Clase clase) async {
    var data = await usersBBDD.supabase
        .from("horario_clase")
        .select("hora_inicial")
        .eq("id_clase", clase.id_clase);

    List<String> horasPosiblesHorario =
        data.map((item) => item["hora_inicial"] as String).toList();
    Set<String> horasRepetidasSet = horasPosiblesHorario.toSet();
    List<String> horasNoRepetidasSet = horasRepetidasSet.toList();

    return horasNoRepetidasSet;
  }

  Future<Asignatura> getAsignatura(int id_asignatura) async {
    var data = await usersBBDD.supabase
        .from("asignatura")
        .select("*")
        .eq("id_asignatura", id_asignatura)
        .single();

    Asignatura asignatura = Asignatura(data["id_asignatura"], data["id_clase"],
        data["id_profesor"], data["nombre_asignatura"], data["color_codigo"]);

    return asignatura;
  }

  Future<Clase> getClase(int id_clase) async {
    var data = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .eq("id_clase", id_clase)
        .single();

    Clase clase =
        Clase(data["id_clase"], data["nombre_clase"], data["id_centro"]);

    return clase;
  }
}
