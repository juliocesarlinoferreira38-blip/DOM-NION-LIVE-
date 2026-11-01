import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'projeto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kjkbxvlceefxsdhwvusj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtqa2J4dmxjZWVmeHNkaHd2dXNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMjM5MDAsImV4cCI6MjEwODY5OTkwMH0.aMkzXs5_sOY2Q095cG8Q03V4FqpfAUHGrVquRT8m9jE',);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dominion Live',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProjetoApp(), // sua tela principal que está em projeto.dart
    );
  }
}