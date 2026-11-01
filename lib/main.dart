import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'projeto.dart';

const String supabaseUrl = 'https://kjkbxvlceefxsdhwvusj.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtqa2J4dmxjZWVmeHNkaHd2dXNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMjM5MDAsImV4cCI6MjEwODY5OTkwMH0.aMkzXs5_sOY2Q095cG8Q03V4FqpfAUHGrVquRT8m9jE';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const DominionLiveApp());
}
