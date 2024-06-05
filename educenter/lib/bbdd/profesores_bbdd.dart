import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';

class ProfesoresBBDD {
  Future<bool> profesorEsTutorDeAlumno(Usuario profesor, Alumno alumno) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("id_clase_tutor")
        .eq("id_usuario", profesor.id_usuario)
        .single();

    int? idClaseTutor = data["id_clase_tutor"];

    // ignore: unrelated_type_equality_checks
    if (idClaseTutor != null && idClaseTutor == alumno.id_clase) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Asignatura>> getAsignaturasProfeDeAlumno(
      Alumno alumno, Usuario profesor) async {
    var data = await usersBBDD.supabase
        .from("asignatura")
        .select("*")
        .eq("id_profesor", profesor.id_usuario)
        .eq("id_clase", alumno.clase.id_clase);

    List<Asignatura> listaAsignaturas = List.empty(growable: true);

    for (var asignatura in data) {
      Usuario profesor =
          await getProfesorDeAsignatura(asignatura["id_asignatura"]);
      Asignatura asignaturaObjeto = Asignatura(
          asignatura["id_asignatura"],
          asignatura["id_clase"],
          asignatura["id_profesor"],
          asignatura["nombre_asignatura"],
          asignatura["color_codigo"],
          profesor);
      listaAsignaturas.add(asignaturaObjeto);
    }

    return listaAsignaturas;
  }

  Future<List<Asignatura>> getAsignaturasProfesor(Usuario profesor) async {
    var data = await usersBBDD.supabase
        .from("asignatura")
        .select("*")
        .eq("id_profesor", profesor.id_usuario);

    List<Asignatura> listaAsignaturas = List.empty(growable: true);

    for (var asignatura in data) {
      Usuario profesor =
          await getProfesorDeAsignatura(asignatura["id_asignatura"]);

      Asignatura asignaturaObjeto = Asignatura(
          asignatura["id_asignatura"],
          asignatura["id_clase"],
          asignatura["id_profesor"],
          asignatura["nombre_asignatura"],
          asignatura["color_codigo"],
          profesor);
      listaAsignaturas.add(asignaturaObjeto);
    }

    return listaAsignaturas;
  }

  Future<Usuario> getProfesorDeAsignatura(int id_asignatura) async {
    var data = await usersBBDD.supabase
        .from("asignatura")
        .select("id_profesor")
        .eq("id_asignatura", id_asignatura)
        .single();

    String idUsuario = data["id_profesor"] as String;

    Usuario profesor = await getProfesorDeId(idUsuario);

    return profesor;
  }

  Future<Usuario> getProfesorDeId(String idProfesor) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_usuario", idProfesor)
        .single();

    Usuario profesor = Usuario(
        data["id_usuario"],
        data["nombre"],
        data["apellido"],
        data["dni"],
        data["id_clase"],
        data["id_centro,"],
        data["tipo_usuario"],
        data["url_foto_perfil"],
        data["email_contacto"]);

    return profesor;
  }

  Future<Usuario> getProfesorDeIncidencia(int id_incidencia) async {
    var data = await usersBBDD.supabase
        .from("incidencias")
        .select("id_profesor")
        .eq("id_incidencia", id_incidencia)
        .single();

    String idUsuario = data["id_profesor"] as String;

    Usuario profesor = await getProfesorDeId(idUsuario);

    return profesor;
  }

  Future<List<Clase>> getClasesProfesor(Usuario profesor) async {
    var asignaturasBD = await usersBBDD.supabase
        .from("asignatura")
        .select("id_clase")
        .eq("id_profesor", profesor.id_usuario);

    List<int> idClasesProfesor =
        asignaturasBD.map((valor) => valor["id_clase"] as int).toSet().toList();

    var clases = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .inFilter("id_clase", idClasesProfesor);

    List<Clase> listaClases = List.empty(growable: true);
    for (var clase in clases) {
      listaClases.add(Clase(
        clase["id_clase"],
        clase["nombre_clase"],
        clase["id_centro"],
      ));
    }

    return listaClases;
  }
}
