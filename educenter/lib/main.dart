import 'package:educenter/paginas/autenticacion/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Para bloquear en modo retrato hacia arriba
    // DeviceOrientation.portraitDown, // Descomenta esta línea si también quieres permitir el retrato hacia abajo
    // DeviceOrientation.landscapeLeft, // Descomenta esta línea si quieres permitir el paisaje hacia la izquierda
    // DeviceOrientation.landscapeRight, // Descomenta esta línea si quieres permitir el paisaje hacia la derecha
  ]).then((_) {
    initializeDateFormatting('es_ES', null).then((_) => runApp(MaterialApp(
          home: Scaffold(
            body: Center(child: Login()),
          ),
          theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.lightBlue,
              brightness: Brightness.dark),
          debugShowCheckedModeBanner: false,
        )));
  });

  await Supabase.initialize(
    url: 'https://kudmswbqgstalgnayidv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1ZG1zd2JxZ3N0YWxnbmF5aWR2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcxNzY2OTIxNCwiZXhwIjoyMDMzMjQ1MjE0fQ.QOlxc2haawVV-xX_FQzf7y5pgIXKrIeTtm4_tSNMvk4',
  );
}
