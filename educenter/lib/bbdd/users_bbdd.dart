// ignore_for_file: camel_case_types

import 'package:educenter/login.dart';
import 'package:educenter/main_menu.dart';
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

  signInWithEmail(email, pass, context) async {
    try {
      final AuthResponse res =
          await supabase.auth.signInWithPassword(email: email, password: pass);
      session = res.session;
      user = res.user;
      if (session != null && user != null && context != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Usuario encontrado")));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const main_menu(
            body: Center(
              child: Text("No tienes hijos"),
            ),
          ),
        ));
      }
    } on AuthApiException {
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
}
