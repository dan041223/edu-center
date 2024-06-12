// ignore_for_file: camel_case_types

import 'package:educenter/bbdd/alumnos_bbdd.dart';
import 'package:educenter/bbdd/users_bbdd.dart';
import 'package:educenter/models/alumno.dart';
import 'package:educenter/models/asignatura.dart';
import 'package:educenter/models/centro.dart';
import 'package:educenter/models/clase.dart';
import 'package:educenter/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class padresBBDD {
  Future<List<Alumno>> getHijosDeUser() async {
    List<Alumno> listaHijos = List.empty(growable: true);

    final data = await usersBBDD.supabase
        .from("padres_alumnos")
        .select("id_hijo")
        .eq("id_padre", usersBBDD.user!.id);

    List<int> idsHijos = data.map((item) => item["id_hijo"] as int).toList();

    final hijosData = await usersBBDD.supabase
        .from("alumnos")
        .select("*")
        .inFilter("id_alumno", idsHijos);
    // final data = await usersBBDD.supabase.from("alumnos").select("*").eq(
    //     "id_alumno",
    //     usersBBDD.supabase
    //         .from("padres_alumnos")
    //         .select("id_hijo")
    //         .eq("id_padre", usersBBDD.user!.id));

    for (var hijosMap in hijosData) {
      Clase clase = await AlumnosBBDD().getClaseAlumno(hijosMap["id_clase"]);
      List<Asignatura> asignaturas =
          await AlumnosBBDD().getAsignaturasAlumno(hijosMap["id_alumno"]);
      Alumno alumno = Alumno(
          hijosMap["id_alumno"],
          hijosMap["nombre"],
          hijosMap["apellido"],
          DateTime.parse(hijosMap["fecha_nacimiento"]),
          hijosMap["id_clase"],
          clase,
          hijosMap["url_foto_perfil"],
          asignaturas);
      listaHijos.add(alumno);
    }
    return listaHijos;
  }

  Future crearPadre(
      String nombre,
      String apellido,
      String dni,
      String emailContacto,
      String emailUsuario,
      Centro centro,
      BuildContext context) async {
    UserResponse data = await usersBBDD.supabase.auth.admin.createUser(
        AdminUserAttributes(
            email: emailUsuario,
            password: "claveTemporal",
            emailConfirm: true));
    await usersBBDD.supabase.from("usuarios").insert({
      "id_usuario": data.user!.id,
      "nombre": nombre,
      "apellido": apellido,
      "dni": dni,
      "email_contacto": emailContacto,
      "id_centro": centro.id_centro,
      "tipo_usuario": "padre_madre"
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Padre/madre creado")));
  }

  Future<List<Alumno>> getHijosDePadre(Usuario padre) async {
    var data = await usersBBDD.supabase
        .from("padres_alumnos")
        .select("id_hijo")
        .eq("id_padre", padre.id_usuario);

    List<int> idsHijosPadre = data.map((id) => id["id_hijo"] as int).toList();
    List<Alumno> hijosPadre = List.empty(growable: true);
    for (var idHijoPadre in idsHijosPadre) {
      Alumno hijo = await AlumnosBBDD().getAlumno(idHijoPadre);
      hijosPadre.add(hijo);
    }

    return hijosPadre;
  }

  editarPadre(String nombre, String apellido, String dni, String emailContacto,
      Centro centro, Usuario padre) async {
    await usersBBDD.supabase.from("usuarios").update({
      "nombre": nombre,
      "apellido": apellido,
      "dni": dni,
      "email_contacto": emailContacto,
      "id_centro": centro.id_centro,
    }).eq("id_usuario", padre.id_usuario);
  }
}
