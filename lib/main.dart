
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'projeto.dart';

const String supabaseUrl =
    'https://kjkbxvlceefxsdhwvusj.supabase.co';

const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtqa2J4dmxjZWVmeHNkaHd2dXNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMjM5MDAsImV4cCI6MjEwODY5OTkwMH0.aMkzXs5_sOY2Q095cG8Q03V4FqpfAUHGrVquRT8m9jE';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DominionLiveApp());

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Erro ao conectar ao Supabase: $e');
  }
}

class DominionLiveApp extends StatelessWidget {
  const DominionLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOMÍNION LIVE',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF171021),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B59FF),
          brightness: Brightness.dark,
          primary: const Color(0xFFB57AFF),
          secondary: const Color(0xFFE5BC58),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF241535),
          foregroundColor: Color(0xFFE5BC58),
          centerTitle: true,
        ),
      ),
      home: const ProjetoApp(),
    );
  }
}
