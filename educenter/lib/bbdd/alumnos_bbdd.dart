import 'package:educenter/bbdd/examenes_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/evento.dart';
import 'package:educenter/models/examen.dart';
import 'package:educenter/models/usuario.dart';

class AlumnosBBDD {
  Future<Alumno> getAlumno(int idAlumno) async {
    var data = await usersBBDD.supabase
        .from('alumnos')
        .select('*')
        .eq("id_alumno", idAlumno)
        .single();
    Alumno alumnoSeleccionado = Alumno(
        data["id_alumno"],
        data["nombre"],
        data["apellido"],
        DateTime.parse(data["fecha_nacimiento"]),
        data["id_clase"]);
    return alumnoSeleccionado;
  }

  Future<List<Asignatura>> getAsignaturasAlumno(Alumno alumno) async {
    //Pillo la clase del alumno - Pillo las asignaturas de esa clase
    List<Asignatura> listaAsignaturas = List.empty(growable: true);
    var idClaseDeAlumno = await usersBBDD.supabase
        .from("alumnos")
        .select("id_clase")
        .eq("id_alumno", alumno.id_alumno)
        .single();
    var asignaturasDeAlumno = await usersBBDD.supabase
        .from("asignatura")
        .select()
        .eq("id_clase", idClaseDeAlumno["id_clase"]);
    for (var asignaturas in asignaturasDeAlumno) {
      Asignatura asignatura = Asignatura(
          asignaturas["id_asignatura"],
          asignaturas["id_clase"],
          asignaturas["id_profesor"],
          asignaturas["nombre_asignatura"],
          asignaturas["color_codigo"]);
      listaAsignaturas.add(asignatura);
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
      Evento evento = Evento(
          eventosMap["id_evento"],
          eventosMap["nombre_evento"],
          eventosMap["descripcion_evento"],
          eventosMap["tipo_evento"],
          DateTime.parse(eventosMap["fecha_inicio"]),
          DateTime.parse(eventosMap["fecha_fin"]),
          eventosMap["ubicacion"]);

      listaEventos.add(evento);
    }

    return listaEventos;
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
          examenesMap["realizado"],
          asignatura,
          profesor,
          clase);

      listaExamenes.add(examen);
    }

    return listaExamenes;
  }
}
