import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DominionLiveApp extends StatelessWidget {
  const DominionLiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOMINION LIVE',
      theme: ThemeData.dark(),
      home: const ProjetoDominion(),
    );
  }
}

class ProjetoDominion extends StatefulWidget {
  const ProjetoDominion({super.key});
  @override
  State<ProjetoDominion> createState() => _ProjetoDominionState();
}

class _ProjetoDominionState extends State<ProjetoDominion> {
  // DAQUI PRA BAIXO COLA SEU CÓDIGO ANTIGO DO PROJETO
  // (o seu cadastro, login, etc)