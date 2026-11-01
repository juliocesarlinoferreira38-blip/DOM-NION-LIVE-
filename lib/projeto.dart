
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'projeto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kjkbxvlceefxsdhwvusj.supabase.co',
    anonKey: 'SUA_CHAVE_PUBLICA_DO_SUPABASE',
  );

  runApp(const DominionLiveApp());
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B59FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF171021),
      ),
      home: const ProjetoDominion(),
    );
  }
}
