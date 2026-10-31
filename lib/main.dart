import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kjkbxvlceefxsdhwvusj.supabase.co',
    anonKey: 'sb_publishable_77p5ibIx-9mnV57Ew1MGrw_GRuGbORp',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dominion Live',
      theme: ThemeData.dark(),
      home: const DominionLiveApp(),
    );
  }
}

// SEU APP CONTINUA AQUI EMBAIXO
// Se você já tem a classe DominionLiveApp, pode apagar essa de exemplo e manter a sua
class DominionLiveApp extends StatelessWidget {
  const DominionLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dominion Live')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Supabase conectado com sucesso!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final supabase = Supabase.instance.client;
                // teste de conexão
                debugPrint('Conectado: ${supabase.auth.currentUser}');
              },
              child: const Text('Testar Supabase'),
            ),
          ],
        ),
      ),
    );
  }
}