import 'package:supabase_flutter/supabase_flutter.dart';

class TempoReal {
  final supabase = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> ouvirSalas() {
    return supabase.from('salas_dominion').stream(primaryKey: ['id']).order('criada_em', ascending: false);
  }

  Future<void> criarSala(String nome) async {
    await supabase.from('salas_dominion').insert({
      'nome': nome,
      'dono': 'Julio Alfa',
      'online': 1,
    });
  }
}