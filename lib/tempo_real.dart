import 'package:cloud_firestore/cloud_firestore.dart';

class TempoReal {
  final salas = FirebaseFirestore.instance.collection('salas_dominion');

  Stream<QuerySnapshot> ouvirSalas() {
    return salas.orderBy('criadaEm', descending: true).snapshots();
  }

  Future<void> criarSala(String nome) {
    return salas.add({
      'nome': nome,
      'dono': 'Julio Alfa',
      'online': 1,
      'criadaEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> entrarSala(String id) {
    return salas.doc(id).update({'online': FieldValue.increment(1)});
  }
}