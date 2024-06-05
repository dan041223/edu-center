import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/horario_clase.dart';
import 'package:educenter/models/usuario.dart';

class ClasesBBDD {
  Future<List<HorarioClase>> getHorarioClase(int id_clase) async {
    var data = await usersBBDD.supabase
        .from("horario_clase")
        .select("*")
        .eq("id_clase", id_clase)
        .order("hora_inicial", ascending: true);

    List<int> idAsignaturasUnicas = List.empty(growable: true);
    for (var horario in data) {
      if (!idAsignaturasUnicas.contains(horario["id_asignatura"])) {
        idAsignaturasUnicas.add(horario["id_asignatura"]);
      }
    }

    var claseBD = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .eq("id_clase", id_clase)
        .single();
    Clase clase = Clase(
        claseBD["id_clase"], claseBD["nombre_clase"], claseBD["id_centro"]);

    var asignaturasBD = await usersBBDD.supabase
        .from("asignatura")
        .select("*")
        .inFilter("id_asignatura", idAsignaturasUnicas);

    List<String> idProfesUnicos = asignaturasBD
        .map((e) => e["id_profesor"] as String)
        .toList()
        .toSet()
        .toList();

    var profesoresBD = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .inFilter("id_usuario", idProfesUnicos);

    List<Asignatura> asignaturas = List.empty(growable: true);
    for (var horasignaturaBDario in asignaturasBD) {
      var profesorDB = profesoresBD
          .where((element) =>
              element["id_usuario"] == horasignaturaBDario["id_profesor"])
          .toList()
          .first;
      Usuario profesor = Usuario(
        profesorDB["id_usuario"],
        profesorDB["nombre"],
        profesorDB["apellido"],
        profesorDB["dni"],
        profesorDB["id_clase"],
        profesorDB["id_centro"],
        profesorDB["tipo_usuario"],
        profesorDB["url_foto_perfil"],
        profesorDB["email_contacto"],
      );
      Asignatura asignatura = Asignatura(
        horasignaturaBDario["id_asignatura"],
        horasignaturaBDario["id_clase"],
        horasignaturaBDario["id_profesor"],
        horasignaturaBDario["nombre_asignatura"],
        horasignaturaBDario["color_codigo"],
        profesor,
      );
      asignaturas.add(asignatura);
    }

    List<HorarioClase> listaHorario = List.empty(growable: true);
    for (var horario in data) {
      HorarioClase horarioClase = HorarioClase(
          horario["id_clase"],
          horario["dia_semana"],
          horario["hora_inicial"],
          horario["hora_final"],
          horario["id_asignatura"],
          asignaturas.firstWhere(
              (element) => element.id_asignatura == horario["id_asignatura"]),
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

    Usuario profesor =
        await ProfesoresBBDD().getProfesorDeAsignatura(data["id_asignatura"]);

    Asignatura asignatura = Asignatura(
        data["id_asignatura"],
        data["id_clase"],
        data["id_profesor"],
        data["nombre_asignatura"],
        data["color_codigo"],
        profesor);

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
