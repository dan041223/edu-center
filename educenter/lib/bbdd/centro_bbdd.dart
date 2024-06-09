import 'package:educenter/bbdd/profesores_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
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

  Future<Centro> getMiCentro() async {
    Usuario user = await usersBBDD().getUsuario();
    var data = await usersBBDD.supabase
        .from("centro")
        .select("*")
        .eq("id_centro", user.id_centro!)
        .single();

    Centro centro = Centro(
        data["id_centro"],
        data["nombre_centro"],
        data["direccion_centro"],
        data["email_centro"],
        data["telefono"],
        Utils.parseTimeOfDay(data["horario_centro_inicio"]),
        Utils.parseTimeOfDay(data["horario_centro_fin"]),
        data["color"],
        data["url_imagen_centro"]);
    return centro;
  }

  Future<List<Usuario>> getProfesoresCentro(Centro centro) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_centro", centro.id_centro)
        .eq("tipo_usuario", "profesor");

    List<Usuario> profesores = List.empty(growable: true);

    for (var profesor in data) {
      Usuario profesorObj = Usuario(
        profesor["id_usuario"],
        profesor["nombre"],
        profesor["apellido"],
        profesor["dni"],
        profesor["id_clase_tutor"],
        profesor["id_centro"],
        profesor["tipo_usuario"],
        profesor["url_foto_perfil"],
        profesor["email_contacto"],
      );
      profesores.add(profesorObj);
    }
    return profesores;
  }

  Future<List<Clase>> getClasesCentro(Centro centro) async {
    var data = await usersBBDD.supabase
        .from("clases")
        .select("*")
        .eq("id_centro", centro.id_centro);

    List<Clase> clasesCentro = List.empty(growable: true);

    for (var clase in data) {
      Clase claseObj = Clase(
        clase["id_clase"],
        clase["nombre_clase"],
        clase["id_centro"],
      );
      clasesCentro.add(claseObj);
    }
    return clasesCentro;
  }

  Future<List<Asignatura>> getAsignaturasCentro(Centro centro) async {
    List<Clase> clases = await CentroBBDD().getClasesCentro(centro);
    var data = await usersBBDD.supabase
        .from("asignatura")
        .select("*")
        .inFilter("id_clase", clases.map((e) => e.id_clase).toList());

    List<Asignatura> asignaturas = List.empty(growable: true);

    for (var asignatura in data) {
      Usuario profesor = await ProfesoresBBDD()
          .getProfesorDeAsignatura(asignatura["id_asignatura"]);
      Asignatura asignaturaObj = Asignatura(
        asignatura["id_asignatura"],
        asignatura["id_clase"],
        asignatura["id_profesor"],
        asignatura["nombre_asignatura"],
        asignatura["color_codigo"],
        profesor,
        clases.where((clase) => clase.id_clase == asignatura["id_clase"]).first,
      );
      asignaturas.add(asignaturaObj);
    }
    return asignaturas;
  }

  Future getPadresCentro(Centro centro) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_centro", centro.id_centro)
        .eq("tipo_usuario", "padre_madre");

    List<Usuario> padresCentro = List.empty(growable: true);

    for (var padreMadre in data) {
      Usuario padreMadreObj = Usuario(
        padreMadre["id_usuario"],
        padreMadre["nombre"],
        padreMadre["apellido"],
        padreMadre["dni"],
        padreMadre["id_clase"],
        padreMadre["id_centro"],
        padreMadre["tipo_usuario"],
        padreMadre["url_foto_perfil"],
        padreMadre["email_contacto"],
      );
      padresCentro.add(padreMadreObj);
    }
    return padresCentro;
  }

  Future editarCentro(
      String nombre,
      String direccion,
      String email,
      TimeOfDay horarioAperturaActual,
      TimeOfDay horarioCierreActual,
      Centro centro,
      String telefono,
      String colorSeleccionado) async {
    await usersBBDD.supabase.from("centro").update({
      "nombre_centro": nombre,
      "direccion_centro": direccion,
      "email_centro": email,
      "telefono": int.parse(telefono),
      "horario_centro_inicio": Utils.formatTimeOfDay(horarioAperturaActual),
      "horario_centro_fin": Utils.formatTimeOfDay(horarioCierreActual),
      "color": colorSeleccionado,
    }).eq("id_centro", centro.id_centro);
  }
}
