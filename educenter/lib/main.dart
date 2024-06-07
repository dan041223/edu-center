import 'package:educenter/paginas/autenticacion/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kudmswbqgstalgnayidv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1ZG1zd2JxZ3N0YWxnbmF5aWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTc2NjkyMTQsImV4cCI6MjAzMzI0NTIxNH0.wR6O6mFovd51NrSoRgXWnbpLnYfzaSTVx1mMaUHGMqs',
  );
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(child: Login()),
    ),
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
  ));
}
