import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'projeto.dart';

Future<void> main() async {
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
      home: const ProjetoDominion(),
    );
  }
}