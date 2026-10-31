import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjetoDominion extends StatefulWidget {
  const ProjetoDominion({super.key});
  @override
  State<ProjetoDominion> createState() => _ProjetoDominionState();
}

class _ProjetoDominionState extends State<ProjetoDominion> {
  final supabase = Supabase.instance.client;
  List<dynamic> lives = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    buscarLives();
  }

  Future<void> buscarLives() async {
    final res = await supabase.from('dominion_lives').select().order('created_at');
    setState(() {
      lives = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aoVivo = lives.where((e) => e['ao_vivo'] == true).toList();
    final gravados = lives.where((e) => e['ao_vivo'] == false).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('DOMINION LIVE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w900, letterSpacing: 3)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: buscarLives, icon: const Icon(Icons.refresh, color: Colors.white))
        ],
      ),
      body: loading 
        ? const Center(child: CircularProgressIndicator(color: Colors.red))
        : RefreshIndicator(
            onRefresh: buscarLives,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (aoVivo.isNotEmpty)
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.red, Colors.black]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)), child: const Text('● AO VIVO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                              const SizedBox(height: 10),
                              Text(aoVivo[0]['titulo'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              Text('${aoVivo[0]['views']} assistindo agora', style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                        const Positioned(bottom: 15, right: 15, child: Icon(Icons.play_circle_fill, color: Colors.white, size: 45)),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 25),
                const Text('Ao Vivo Agora', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...aoVivo.map((live) => _card(live, true)),
                
                const SizedBox(height: 25),
                const Text('Conteúdos Gravados', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...gravados.map((live) => _card(live, false)),
              ],
            ),
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'Ao Vivo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _card(dynamic live, bool isLive) {
    return Card(
      color: const Color(0xFF151515),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(width: 50, height: 50, decoration: BoxDecoration(color: isLive ? Colors.red : Colors.grey[800], borderRadius: BorderRadius.circular(8)), child: Icon(isLive ? Icons.videocam : Icons.play_arrow, color: Colors.white)),
        title: Text(live['titulo'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(live['descricao'] ?? '', style: const TextStyle(color: Colors.white54), maxLines: 1),
        trailing: isLive ? const Icon(Icons.circle, color: Colors.red, size: 12) : Text('${live['views']} views', style: const TextStyle(color: Colors.white24, fontSize: 11)),
      ),
    );
  }
}