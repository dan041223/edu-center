import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';

class ExamenesBBDD {
  Future<Asignatura> getAsignaturaExamen(int idExamen) async {
    var data = await usersBBDD.supabase
        .from("examenes")
        .select("id_asignatura")
        .eq("id_examen", idExamen)
        .single();

    int idAsignatura = int.parse(data["id_asignatura"].toString());

    var asignatura = await usersBBDD.supabase
        .from("asignatura")
        .select("*")
        .eq("id_asignatura", idAsignatura)
        .single();

    Asignatura asignaturaObjeto = Asignatura(
        asignatura["id_asignatura"],
        asignatura["id_clase"],
        asignatura["id_profesor"],
        asignatura["nombre_asignatura"],
        asignatura["color_codigo"]);

    return asignaturaObjeto;
  }

  Future<Usuario> getProfesorExamen(int idExamen) async {
    var data = await usersBBDD.supabase
        .from("examenes")
        .select("id_profesor")
        .eq("id_examen", idExamen)
        .single();

    String idProfesor = data["id_profesor"].toString();

    var asignatura = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_usuario", idProfesor)
        .single();

    Usuario usuarioObjeto = Usuario(
        asignatura["id_usuario"],
        asignatura["nombre"],
        asignatura["apellido"],
        asignatura["dni"],
        asignatura["id_clase"],
        asignatura["id_centro"],
        asignatura["tipo_usuario"]);

    return usuarioObjeto;
  }

  Future<Clase> getClaseExamen(int idExamen) async {
    var data = await usersBBDD.supabase
        .from("examenes")
        .select("id_clase")
        .eq("id_examen", idExamen)
        .single();

    int idClase = int.parse(data["id_clase"].toString());

    var clase = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .eq("id_clase", idClase)
        .single();

    Clase claseObjeto =
        Clase(clase["id_clase"], clase["nombre_clase"], clase["id_centro"]);

    return claseObjeto;
  }
}
