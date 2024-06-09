// ignore_for_file: camel_case_types

import 'package:educenter/paginas/admin/main_menu_admin.dart';
import 'package:educenter/paginas/autenticacion/login.dart';
import 'package:educenter/paginas/padre/main_menu.dart';
import 'package:educenter/paginas/profe/clases_profe.dart';
import 'package:educenter/models/usuario.dart';
import 'package:educenter/paginas/profe/main_menu_profe.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class usersBBDD {
  inicializarBBDD() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
      url: 'https://dnivtdyhjruxnqlorqas.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRuaXZ0ZHloanJ1eG5xbG9ycWFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE1NzQyMDAsImV4cCI6MjAyNzE1MDIwMH0.NyrSmU0Kyc44CB25xPTQ-4b7lHaEGxM1y3s8ywJgSCk',
    );
  }

  static final supabase = Supabase.instance.client;

  static Session? session;
  static User? user;

  Future<bool> signUp(email, pass, context) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: pass,
    );
    session = res.session;
    user = res.user;
    if (session != null && user != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User registered")));
      return true;
    }
    return true;
  }

  signInWithEmail(email, pass, context, Function action) async {
    try {
      final AuthResponse res =
          await supabase.auth.signInWithPassword(email: email, password: pass);
      session = res.session;
      user = res.user;
      print(res.session?.accessToken.toString());

      if (session != null && user != null && context != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Usuario encontrado")));
        action();

        Usuario usuario = await getUsuario();
        if (usuario.tipo_usuario == "profesor") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MainMenuProfe(profe: usuario),
            ),
          );
        } else if (usuario.tipo_usuario == "padre_madre") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const main_menu(
              body: Center(
                child: Text("No tienes hijos en el sistema"),
              ),
            ),
          ));
        } else if (usuario.tipo_usuario == "administrador") {
          // TODO: menu principal del administrador
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MainMenuAdmin(),
            ),
          );
        }
      }
    } catch (AuthApiException) {
      print(AuthApiException);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Usuario incorrecto")));
    }
  }

  Future<void> signOut(context) async {
    await supabase.auth.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Usuario deslogueado")));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Login(),
    ));
  }

  Future<Usuario> getUsuario() async {
    var data = await supabase
        .from("usuarios")
        .select("*")
        .eq("id_usuario", user!.id)
        .single();

    Usuario usuario = Usuario(
        data["id_usuario"],
        data["nombre"],
        data["apellido"],
        data["dni"],
        data["id_clase"],
        data["id_centro"],
        data["tipo_usuario"],
        data["url_foto_perfil"],
        data["email_contacto"]);

    return usuario;
  }

  Future<Usuario> getUserPorId(String idPadre) async {
    var data = await usersBBDD.supabase
        .from("usuarios")
        .select("*")
        .eq("id_usuario", idPadre)
        .single();

    return Usuario(
      data["id_usuario"],
      data["nombre"],
      data["apellido"],
      data["dni"],
      data["id_clase"],
      data["id_centro"],
      data["tipo_usuario"],
      data["url_foto_perfil"],
      data["email_contacto"],
    );
  }

  Future<void> deleteUser(String userId) async {
    final response = await supabase.rpc('delete_user', params: {
      'user_id': userId,
    });

    if (response.error != null) {
      print('Error: ${response.error.message}');
    } else {
      print('Usuario eliminado exitosamente');
    }
  }

  borrarUsuario(Usuario profe) async {
    await usersBBDD.supabase.auth.admin.deleteUser(profe.id_usuario);
    await usersBBDD.supabase
        .from("usuarios")
        .delete()
        .eq("id_usuario", profe.id_usuario)
        .select();
  }
}
