
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'projeto.dart';

const supabaseUrl =
    'https://kjkbxvlceefxsdhwvusj.supabase.co';

const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtqa2J4dmxjZWVmeHNkaHd2dXNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMjM5MDAsImV4cCI6MjEwODY5OTkwMH0.aMkzXs5_sOY2Q095cG8Q03V4FqpfAUHGrVquRT8m9jE');

const Color dlPreto = Color(0xFF08060B);
const Color dlPainel = Color(0xFF171020);
const Color dlRoxo = Color(0xFF6A1B9A);
const Color dlDourado = Color(0xFFE5BC58);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const DominionLiveApp());
}

class DominionLiveApp extends StatelessWidget {
  const DominionLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOMÍNION LIVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: dlPreto,
        colorScheme: ColorScheme.fromSeed(
          seedColor: dlRoxo,
          brightness: Brightness.dark,
          primary: dlRoxo,
          secondary: dlDourado,
          surface: dlPainel,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: dlPainel,
          foregroundColor: dlDourado,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: dlPainel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: dlDourado,
              width: 2,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: dlDourado,
            foregroundColor: dlPreto,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
      home: const ProjetoDominion(),
    );
  }
}
