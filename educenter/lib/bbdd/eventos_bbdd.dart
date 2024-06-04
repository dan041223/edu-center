import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';

class EventosBBDD {
  // ignore: non_constant_identifier_names
  Future<List<Alumno>> getListaAlumnosEvento(int id_evento) async {
    var data = await usersBBDD.supabase
        .from("alumnos_evento")
        .select("id_alumno")
        .eq("id_evento", id_evento);

    List<int> idsAlumnosEvento =
        data.map((item) => item["id_alumno"] as int).toList();

    var alumnosData = await usersBBDD.supabase
        .from("alumnos")
        .select("*")
        .inFilter("id_alumno", idsAlumnosEvento);

    List<Alumno> listaAlumnos = List.empty(growable: true);

    for (var alumnosMap in alumnosData) {
      Clase clase = await AlumnosBBDD().getClaseAlumno(alumnosMap["id_clase"]);
      List<Asignatura> asignaturas =
          await AlumnosBBDD().getAsignaturasAlumno(alumnosMap["id_alumno"]);

      Alumno alumno = Alumno(
          alumnosMap["id_alumno"],
          alumnosMap["nombre"],
          alumnosMap["apellido"],
          DateTime.parse(alumnosMap["fecha_nacimiento"]),
          alumnosMap["id_clase"],
          clase,
          alumnosMap["url_foto_perfil"],
          asignaturas);
      listaAlumnos.add(alumno);
    }
    return listaAlumnos;
  }

  // ignore: non_constant_identifier_names
  Future<List<Usuario>> getListaProfesoresEvento(int id_evento) async {
    var data = await usersBBDD.supabase
        .from("profesor_evento")
        .select("id_profesor")
        .eq("id_evento", id_evento);

    List<String> idsProfesoresEvento =
        data.map((item) => item["id_profesor"] as String).toList();

    var profesoresData = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .inFilter("id_usuario", idsProfesoresEvento);

    List<Usuario> listaProfesores = List.empty(growable: true);

    for (var profesoresMap in profesoresData) {
      Usuario profesor = Usuario(
          profesoresMap["id_usuario"],
          profesoresMap["nombre"],
          profesoresMap["apellido"],
          profesoresMap["dni"],
          profesoresMap["id_clase"],
          profesoresMap["id_centro"],
          profesoresMap["tipo_usuario"],
          profesoresMap["url_foto_perfil"],
          profesoresMap["email_contacto"]);
      listaProfesores.add(profesor);
    }
    return listaProfesores;
  }
}
