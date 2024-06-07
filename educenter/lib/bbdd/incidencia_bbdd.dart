import 'dart:io';

import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/incidencia.dart';
import 'package:educenter/models/usuario.dart';

// import 'package:educenter/bbdd/users_bbdd.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class IncidenciaBBDD {
  uploadImage(
    File file,
  ) async {
    // final String fullPath = await usersBBDD.supabase.storage
    //     .from('avatars')
    //     .upload(
    //       'public/avatar1.png',
    //       file,
    //       fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    //     );
  }

  Future<List<Incidencia>> getIncidenciasAlumno(Alumno alumno) async {
    var data = await usersBBDD.supabase
        .from("incidencias")
        .select("*")
        .eq("id_alumno", alumno.id_alumno);

    List<Incidencia> incidencias = List.empty(growable: true);

    for (var incidencia in data) {
      Usuario profe = await usersBBDD().getUserPorId(incidencia["id_profesor"]);
      Incidencia incidenciObj = Incidencia(
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
        profe,
      );
      incidencias.add(incidenciObj);
    }
    return incidencias;
  }

  crearIncidencia(String titulo, String descripcion, DateTime fechaPropuesta,
      String tipo_incidencia, Alumno alumno, Usuario profesor) async {
    await usersBBDD.supabase.from("incidencias").insert({
      "tipo_incidencia": tipo_incidencia,
      "descripcion": descripcion,
      "id_alumno": alumno.id_alumno,
      "id_profesor": profesor.id_usuario,
      "titulo_incidencia": titulo,
      "fecha_incidencia": fechaPropuesta.toIso8601String()
    });
  }
}
