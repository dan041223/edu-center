import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/clases_bbdd.dart';
import 'package:educenter/bbdd/eventos_bbdd.dart';
import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/cita.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/models/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      Clase clase =
          await ClasesBBDD().getClaseAsignatura(asignatura["id_asignatura"]);
      Asignatura asignaturaObjeto = Asignatura(
          asignatura["id_asignatura"],
          asignatura["id_clase"],
          asignatura["id_profesor"],
          asignatura["nombre_asignatura"],
          asignatura["color_codigo"],
          profesor,
          clase);
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

  Future<List<Cita>> getCitasTutor(Usuario tutor) async {
    var data = await usersBBDD.supabase
        .from("citas")
        .select("*")
        .eq("id_profesor", tutor.id_usuario);

    List<Cita> listaCitasAlumno = List.empty(growable: true);

    for (var cita in data) {
      Alumno alumno = await AlumnosBBDD().getAlumno(cita["id_alumno"]);
      Cita citaObjeto = Cita(
          cita["id_cita"],
          cita["id_alumno"],
          cita["id_profesor"],
          cita["fecha_padre"] != null
              ? DateTime.parse(cita["fecha_padre"])
              : null,
          cita["fecha_tutor"] != null
              ? DateTime.parse(cita["fecha_tutor"])
              : null,
          cita["titulo"],
          cita["descripcion"],
          tutor,
          alumno);
      listaCitasAlumno.add(citaObjeto);
    }

    return listaCitasAlumno;
  }

  Future<List<Alumno>> getAlumnosClaseTutor(Usuario tutor) async {
    Clase clase = await getClaseDeTutor(tutor);

    var alumnos = await usersBBDD.supabase
        .from("alumnos")
        .select("*")
        .eq("id_clase", clase.id_clase);

    List<Alumno> alumnosTutor = List.empty(growable: true);

    for (var alumno in alumnos) {
      Alumno alumnoObj = Alumno(
        alumno["id_alumno"],
        alumno["nombre"],
        alumno["apellido"],
        DateTime.parse(alumno["fecha_nacimiento"]),
        alumno["id_clase"],
        clase,
        alumno["url_foto_perfil"],
        [],
      );
      alumnosTutor.add(alumnoObj);
    }
    return alumnosTutor;
  }

  Future<Clase> getClaseDeTutor(Usuario tutor) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("id_clase_tutor")
        .eq("id_usuario", tutor.id_usuario)
        .single();

    int id = data["id_clase_tutor"];

    var clase = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .eq("id_clase", id)
        .single();

    Clase claseObj = Clase(
      clase["id_clase"],
      clase["nombre_clase"],
      clase["id_centro"],
    );

    return claseObj;
  }

  Future<List<Evento>> getListaEventos(Usuario profe) async {
    List<Evento> listaEventos = List.empty(growable: true);
    var eventosBD = await usersBBDD.supabase
        .from("profesor_evento")
        .select("id_evento")
        .eq("id_profesor", profe.id_usuario);

    List<int> idsEventos =
        eventosBD.map((item) => item["id_evento"] as int).toList();

    var eventosData = await usersBBDD.supabase
        .from("evento")
        .select("*")
        .inFilter("id_evento", idsEventos);

    for (var eventosMap in eventosData) {
      List<Usuario> listaProfesores =
          await EventosBBDD().getListaProfesoresEvento(eventosMap["id_evento"]);
      List<Alumno> listaAlumnos =
          await EventosBBDD().getListaAlumnosEvento(eventosMap["id_evento"]);

      Evento evento = Evento(
          eventosMap["id_evento"],
          eventosMap["nombre_evento"],
          eventosMap["descripcion_evento"],
          eventosMap["tipo_evento"],
          DateTime.parse(eventosMap["fecha_inicio"]),
          DateTime.parse(eventosMap["fecha_fin"]),
          eventosMap["ubicacion"],
          listaProfesores,
          listaAlumnos,
          eventosMap["color_evento"]);

      listaEventos.add(evento);
    }

    return listaEventos;
  }

  Future<List<Examen>> getListaExamenes(Usuario profe) async {
    List<Examen> listaExamenes = List.empty(growable: true);
    var examenesBD = await usersBBDD.supabase
        .from("examenes")
        .select("id_examen")
        .eq("id_profesor", profe.id_usuario);

    List<int> idsExamenes =
        examenesBD.map((item) => item["id_examen"] as int).toList();

    var examenesData = await usersBBDD.supabase
        .from("examenes")
        .select("*")
        .inFilter("id_examen", idsExamenes);

    for (var examenesMap in examenesData) {
      Asignatura asignatura =
          await ExamenesBBDD().getAsignaturaExamen(examenesMap["id_examen"]);

      Clase clase =
          await ExamenesBBDD().getClaseExamen(examenesMap["id_examen"]);

      Examen examen = Examen(
          examenesMap["id_examen"],
          examenesMap["id_asignatura"],
          examenesMap["id_profesor"],
          examenesMap["id_clase"],
          DateTime.parse(examenesMap["fecha_examen"]),
          examenesMap["trimestre"],
          asignatura,
          profe,
          clase,
          examenesMap["descripcion"]);

      listaExamenes.add(examen);
    }

    return listaExamenes;
  }

  Future<List<Incidencia>> getListaIncidencias(Usuario profe) async {
    List<Incidencia> listaIncidencias = List.empty(growable: true);
    var incidenciasBD = await usersBBDD.supabase
        .from("incidencias")
        .select("*")
        .eq("id_profesor", profe.id_usuario);

    for (var incidencia in incidenciasBD) {
      Alumno alumno = await AlumnosBBDD().getAlumno(incidencia["id_alumno"]);
      Incidencia incidenciaObjeto = Incidencia(
          incidencia["id_incidencia"],
          incidencia["tipo_incidencia"],
          incidencia["titulo_incidencia"],
          incidencia["descripcion"],
          incidencia["id_alumno"],
          incidencia["id_profesor"],
          incidencia["justificante_url"],
          incidencia["justificacion"],
          incidencia["justificante_nombre"],
          DateTime.parse(incidencia["fecha_incidencia"]),
          alumno,
          profe);
      listaIncidencias.add(incidenciaObjeto);
    }

    return listaIncidencias;
  }

  Future cambiarAsignaturasProfe(
      Usuario profesor, List<Asignatura> listaAsignaturasSeleccionadas) async {
    // await desvincularAsignaturasProfe(profesor);
    await usersBBDD.supabase
        .from("asignatura")
        .update({"id_profesor": profesor.id_usuario}).inFilter(
            "id_asignatura", listaAsignaturasSeleccionadas);
  }

  Future modificarProfesor(String nombre, String apellido, String dni,
      String email, Usuario profesor) async {
    await usersBBDD.supabase.from("usuarios").update({
      "nombre": nombre,
      "apellido": apellido,
      "dni": dni,
      "email_contacto": email
    }).eq("id_usuario", profesor.id_usuario);
  }

  Future crearProfesor(
      String nombre,
      String apellido,
      String dni,
      String emailContacto,
      String emailUsuario,
      Clase? claseSeleccionada,
      Centro centro) async {
    UserResponse data =
        await usersBBDD.supabase.auth.admin.createUser(AdminUserAttributes(
      email: emailUsuario,
      password: "claveTemporal",
      emailConfirm: true,
    ));
    claseSeleccionada != null
        ? await usersBBDD.supabase.from("usuarios").insert({
            "id_usuario": data.user!.id,
            "nombre": nombre,
            "apellido": apellido,
            "dni": dni,
            "email_contacto": emailContacto,
            "id_clase_tutor": claseSeleccionada.id_clase,
            "id_centro": centro.id_centro,
            "tipo_usuario": "profesor"
          })
        : await usersBBDD.supabase.from("usuarios").insert({
            "id_usuario": data.user!.id,
            "nombre": nombre,
            "apellido": apellido,
            "dni": dni,
            "email_contacto": emailContacto,
            "id_centro": centro.id_centro,
            "tipo_usuario": "profesor"
          });
  }

  Future<Usuario?> getTutorClase(Clase clase) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_clase_tutor", clase.id_clase);

    if (data.isEmpty) {
      return null;
    }
    Usuario? usuario = Usuario(
      data[0]["id_usuario"],
      data[0]["nombre"],
      data[0]["apellido"],
      data[0]["dni"],
      data[0]["id_clase"],
      data[0]["id_centro"],
      data[0]["tipo_usuario"],
      data[0]["url_foto_perfil"],
      data[0]["email_contacto"],
    );
    return usuario;
  }

  // Future desvincularAsignaturasProfe(Usuario profesor) async {
  //   await usersBBDD.supabase
  //       .from("asignatura")
  //       .update({"id_profesor": profesor.id_usuario}).eq(
  //           "id_profesor", profesor.id_usuario);
  // }
}
