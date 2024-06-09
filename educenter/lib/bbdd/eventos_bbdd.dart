// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/utils.dart';

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

  Future crearEvento(
      Usuario profe,
      String color,
      String ubicacion,
      String tipo_evento,
      List<Clase> clasesSeleccionadas,
      String nombre,
      String descripcion,
      DateTime fechaInicioPropuesta,
      DateTime fechaFinPropuesta) async {
    var data = await usersBBDD.supabase
        .from("evento")
        .insert({
          "nombre_evento": nombre,
          "descripcion_evento": descripcion,
          "tipo_evento": Utils.stringToTipoEvento(tipo_evento),
          "fecha_inicio": fechaInicioPropuesta.toIso8601String(),
          "fecha_fin": fechaFinPropuesta.toIso8601String(),
          "ubicacion": ubicacion,
          "color_evento": color
        })
        .select()
        .single();
    List<Alumno> alumnosDeClases = List.empty(growable: true);
    for (var clase in clasesSeleccionadas) {
      List<Alumno> alumnos = await AlumnosBBDD().getAlumnosClase(clase);
      alumnosDeClases.addAll(alumnos);
    }

    Evento evento = Evento(
        data["id_evento"],
        nombre,
        descripcion,
        tipo_evento,
        fechaInicioPropuesta,
        fechaFinPropuesta,
        ubicacion,
        [profe],
        alumnosDeClases,
        color);
    await agregarAlumnosAEvento(alumnosDeClases, evento);
    await agregarProfesorAEvento(evento, profe);
  }

  Future agregarProfesorAEvento(Evento evento, Usuario profe) async {
    await usersBBDD.supabase.from("profesor_evento").insert(
        {"id_evento": evento.id_evento, "id_profesor": profe.id_usuario});
  }

  Future agregarAlumnosAEvento(
      List<Alumno> alumnosDeClases, Evento evento) async {
    alumnosDeClases.forEach((alumno) async {
      await usersBBDD.supabase.from("alumnos_evento").insert(
          {"id_evento": evento.id_evento, "id_alumno": alumno.id_alumno});
    });
  }
}
