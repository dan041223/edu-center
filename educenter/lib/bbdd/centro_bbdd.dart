import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/utils.dart';
import 'package:flutter/material.dart';

class CentroBBDD {
  Future<Centro> getCentroAlumno(Alumno alumno) async {
    var data = await usersBBDD.supabase
        .from("alumnos")
        .select("id_clase")
        .eq("id_alumno", alumno.id_alumno)
        .single();

    int idClase = data["id_clase"] as int;

    var data2 = await usersBBDD.supabase
        .from("clases")
        .select("id_centro")
        .eq("id_clase", idClase)
        .single();

    int idCentro = data2["id_centro"] as int;

    var centro = await usersBBDD.supabase
        .from("centro")
        .select("*")
        .eq("id_centro", idCentro)
        .single();

    String horaInicioString = centro["horario_centro_inicio"].toString();
    TimeOfDay horaInicio = Utils.parseTimeOfDay(horaInicioString);

    String horaFinString = centro["horario_centro_fin"].toString();
    TimeOfDay horaFin = Utils.parseTimeOfDay(horaFinString);

    Centro centroObjeto = Centro(
        centro["id_centro"],
        centro["nombre_centro"],
        centro["direccion_centro"],
        centro["email_centro"],
        centro["telefono"],
        horaInicio,
        horaFin,
        centro["color"],
        centro["url_imagen_centro"]);
    return centroObjeto;
  }
}
