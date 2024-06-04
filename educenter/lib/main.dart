import 'package:educenter/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dnivtdyhjruxnqlorqas.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRuaXZ0ZHloanJ1eG5xbG9ycWFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE1NzQyMDAsImV4cCI6MjAyNzE1MDIwMH0.NyrSmU0Kyc44CB25xPTQ-4b7lHaEGxM1y3s8ywJgSCk',
  );
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(child: Login()),
    ),
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
  ));
}
