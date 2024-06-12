import 'package:educenter/bbdd/eventos_bbdd.dart';
import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/cita.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/models/usuario.dart';

class AlumnosBBDD {
  Future<Alumno> getAlumno(int idAlumno) async {
    var data = await usersBBDD.supabase
        .from('alumnos')
        .select('*')
        .eq("id_alumno", idAlumno)
        .single();

    Clase clase = await getClaseAlumno(data["id_clase"]);
    List<Asignatura> asignaturas =
        await AlumnosBBDD().getAsignaturasAlumno(idAlumno);

    Alumno alumnoSeleccionado = Alumno(
        data["id_alumno"],
        data["nombre"],
        data["apellido"],
        DateTime.parse(data["fecha_nacimiento"]),
        data["id_clase"],
        clase,
        data["url_foto_perfil"],
        asignaturas);
    return alumnoSeleccionado;
  }

  Future<List<Asignatura>> getAsignaturasAlumno(int id_alumno) async {
    //Pillo la clase del alumno - Pillo las asignaturas de esa clase
    List<Asignatura> listaAsignaturas = List.empty(growable: true);
    var idClaseDeAlumno = await usersBBDD.supabase
        .from("alumnos")
        .select("id_clase")
        .eq("id_alumno", id_alumno)
        .single();
    var asignaturasDeAlumno = await usersBBDD.supabase
        .from("asignatura")
        .select()
        .eq("id_clase", idClaseDeAlumno["id_clase"]);
    for (var asignatura in asignaturasDeAlumno) {
      Usuario profesor = await ProfesoresBBDD()
          .getProfesorDeAsignatura(asignatura["id_asignatura"]);

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

  Future<List<Evento>> getListaEventosDeAlumno(Alumno alumno) async {
    List<Evento> listaEventos = List.empty(growable: true);
    var eventosAlumno = await usersBBDD.supabase
        .from("alumnos_evento")
        .select("id_evento")
        .eq("id_alumno", alumno.id_alumno);

    List<int> idsEventosAlumno =
        eventosAlumno.map((item) => item["id_evento"] as int).toList();

    var eventosData = await usersBBDD.supabase
        .from("evento")
        .select("*")
        .inFilter("id_evento", idsEventosAlumno);

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

  Future<Clase> getClaseAlumno(int idClase) async {
    var data = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .eq("id_clase", idClase)
        .single();

    Clase clase =
        Clase(data["id_clase"], data["nombre_clase"], data["id_centro"]);

    return clase;
  }

  Future<List<Examen>> getListaExamenesDeAlumno(Alumno alumno) async {
    List<Examen> listaExamenes = List.empty(growable: true);
    var examenesAlumno = await usersBBDD.supabase
        .from("examen_alumno")
        .select("id_examen")
        .eq("id_alumno", alumno.id_alumno);

    List<int> idsExamenesAlumno =
        examenesAlumno.map((item) => item["id_examen"] as int).toList();

    var examenesData = await usersBBDD.supabase
        .from("examenes")
        .select("*")
        .inFilter("id_examen", idsExamenesAlumno);

    for (var examenesMap in examenesData) {
      Asignatura asignatura =
          await ExamenesBBDD().getAsignaturaExamen(examenesMap["id_examen"]);

      Usuario profesor =
          await ExamenesBBDD().getProfesorExamen(examenesMap["id_examen"]);

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
          profesor,
          clase,
          examenesMap["descripcion"]);

      listaExamenes.add(examen);
    }

    return listaExamenes;
  }

  Future<List<Incidencia>> getListaIncidenciasDeAlumno(Alumno alumno) async {
    List<Incidencia> listaIncidencias = List.empty(growable: true);
    var incidenciasAlumno = await usersBBDD.supabase
        .from("incidencias")
        .select("*")
        .eq("id_alumno", alumno.id_alumno);

    for (var incidencia in incidenciasAlumno) {
      Usuario profesor = await ProfesoresBBDD()
          .getProfesorDeIncidencia(incidencia["id_incidencia"]);
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
          profesor);
      listaIncidencias.add(incidenciaObjeto);
    }

    return listaIncidencias;
  }

  Future<Usuario> getTutorAlumno(Alumno alumno) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_clase_tutor", alumno.id_clase)
        .single();

    Usuario tutor = Usuario(
        data["id_usuario"],
        data["nombre"],
        data["apellido"],
        data["dni"],
        data["id_clase"],
        data["id_centro"],
        data["tipo_usuario"],
        data["url_foto_perfil"],
        data["email_contacto"]);

    return tutor;
  }

  Future<List<Cita>> getCitasAlumno(Alumno alumno) async {
    var data = await usersBBDD.supabase
        .from("citas")
        .select("*")
        .eq("id_alumno", alumno.id_alumno);

    List<Cita> listaCitasAlumno = List.empty(growable: true);
    Usuario tutor = await getTutorAlumno(alumno);

    for (var cita in data) {
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

  Future<List<Alumno>> getAlumnosClase(Clase clase) async {
    var alumnosDB = await usersBBDD.supabase
        .from('alumnos')
        .select('*')
        .eq("id_clase", clase.id_clase);

    List<Alumno> alumnos = List.empty(growable: true);
    for (var alumno in alumnosDB) {
      Alumno alumnoObj = Alumno(
          alumno["id_alumno"],
          alumno["nombre"],
          alumno["apellido"],
          DateTime.parse(alumno["fecha_nacimiento"]),
          alumno["id_clase"],
          clase,
          alumno["url_foto_perfil"], []);
      alumnos.add(alumnoObj);
    }

    return alumnos;
  }

  Future<List<Usuario>> getPadresDeAlumno(Alumno alumno) async {
    var data = await usersBBDD.supabase
        .from("padres_alumnos")
        .select("id_padre")
        .eq("id_hijo", alumno.id_alumno);

    List<String> idsPadres = data.map((e) => e["id_padre"] as String).toList();

    List<Usuario> listaPadres = List.empty(growable: true);

    for (var idPadre in idsPadres) {
      listaPadres.add(await usersBBDD().getUserPorId(idPadre));
    }
    return listaPadres;
  }

  Future deleteAlumno(int id_alumno) async {
    await usersBBDD.supabase
        .from("alumnos")
        .delete()
        .eq("id_alumno", id_alumno);
  }

  Future crearAlumno(String nombre, String apellido, DateTime fechaNacimiento,
      Clase clase) async {
    await usersBBDD.supabase.from("alumnos").insert({
      "nombre": nombre,
      "apellido": apellido,
      "fecha_nacimiento": fechaNacimiento.toIso8601String(),
      "id_clase": clase.id_clase
    });
  }

  Future agregarPadres(List<Usuario> padresSeleccionados, Alumno alumno) async {
    padresSeleccionados.forEach((padre) async {
      await usersBBDD.supabase
          .from("padres_alumnos")
          .insert({"id_padre": padre.id_usuario, "id_hijo": alumno.id_alumno});
    });
  }

  Future editarAlumno(String nombre, String apellido, DateTime fechaNacimiento,
      Clase? clase, Alumno alumno) async {
    clase?.id_clase != null
        ? await usersBBDD.supabase.from("alumnos").update({
            "nombre": nombre,
            "apellido": apellido,
            "fecha_nacimiento": fechaNacimiento.toIso8601String(),
            "id_clase": clase!.id_clase,
          }).eq("id_alumno", alumno.id_alumno)
        : await usersBBDD.supabase.from("alumnos").update({
            "nombre": nombre,
            "apellido": apellido,
            "fecha_nacimiento": fechaNacimiento.toIso8601String(),
          }).eq("id_alumno", alumno.id_alumno);
  }
}
