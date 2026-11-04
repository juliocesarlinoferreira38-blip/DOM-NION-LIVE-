import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'projeto.dart';

const Color dlPreto = Color(0xFF08060B);
const Color dlPainel = Color(0xFF171020);
const Color dlRoxo = Color(0xFF6A1B9A);
const Color dlDourado = Color(0xFFE5BC58);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }

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
      ),
      home: const ProjetoDominion(),
    );
  }
}
