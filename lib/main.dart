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

const Color roxo = Color(0xFF210B45);
const Color roxoClaro = Color(0xFF713AC0);
const Color dourado = Color(0xFFFFD76A);
const Color painel = Color(0xFF321653);
const Color fundo = Color(0xFF170729);
const String slogan = 'Sua voz. Sua família. Seu império!';

enum EstiloMonstro { fofo, sombrio, lendario }

class SalaDominion {
  SalaDominion({required this.nome, required this.dono, this.emoji = '🐺', this.privada = false, this.casalAtivado = true});
  final String nome; final String dono; final String emoji; final bool privada; final bool casalAtivado;
  final List<String?> assentos = List<String?>.filled(8, null);
  final List<String?> casal = List<String?>.filled(2, null);
  int get participantes => assentos.where((p) => p != null).length + casal.where((p) => p != null).length;
}

class FamiliaDominion {
  FamiliaDominion({required this.nome, required this.lema, required this.lider, List<String>? membros}) : membros = membros ?? [lider];
  final String nome; final String lema; final String lider; final List<String> membros;
}

class DadosDominion {
  static final List<SalaDominion> salas = [
    SalaDominion(nome: 'Sala da Família', dono: 'ALFA GAEL', emoji: '🐺'),
    SalaDominion(nome: 'Sala do Casal', dono: 'ALFA GAEL', emoji: '💜'),
    SalaDominion(nome: 'Sala de Música', dono: 'ALFA GAEL', emoji: '🎵', casalAtivado: false),
    SalaDominion(nome: 'Sala VIP', dono: 'ALFA GAEL', emoji: '👑', privada: true),
  ];
  static final List<FamiliaDominion> familias = [
    FamiliaDominion(nome: 'DOMÍNION ALFA', lema: slogan, lider: 'ALFA GAEL', membros: ['ALFA GAEL', 'IMPERATRIZ ALFA']),
  ];
}

// CORREÇÃO AQUI: MyApp agora existe
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const DominionLiveApp();
  }
}

class DominionLiveApp extends StatefulWidget {
  const DominionLiveApp({super.key});
  @override
  State<DominionLiveApp> createState() => _DominionLiveAppState();
}

class _DominionLiveAppState extends State<DominionLiveApp> {
  String? usuario;
  void entrar(String nome) => setState(() => usuario = nome);
  void sair() async {
    await Supabase.instance.client.auth.signOut();
    setState(() => usuario = null);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOMÍNION LIVE',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: fundo, colorScheme: ColorScheme.fromSeed(seedColor: dourado, brightness: Brightness.dark), appBarTheme: const AppBarTheme(backgroundColor: roxo, foregroundColor: dourado, centerTitle: true), inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: painel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
      home: usuario == null ? TelaLogin(onEntrar: entrar) : TelaPrincipal(usuario: usuario!, onSair: sair),
    );
  }
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key, required this.onEntrar});
  final ValueChanged<String> onEntrar;
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool cadastro = false;
  bool ocultarSenha = true;
  bool loading = false;

  @override
  void dispose() { nomeController.dispose(); emailController.dispose(); senhaController.dispose(); super.dispose(); }

  Future<void> continuar() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha os campos para continuar.')));
      return;
    }
    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha com pelo menos 6 caracteres.')));
      return;
    }

    setState(() => loading = true);
    try {
      final supabase = Supabase.instance.client;
      if (cadastro) {
        final res = await supabase.auth.signUp(email: email, password: senha);
        if (res.user != null) {
          await supabase.from('profiles').upsert({'id': res.user!.id, 'email': email, 'name': nome});
        }
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada! Verifique seu e-mail ou faça login.')));
        setState(() => cadastro = false);
      } else {
        await supabase.auth.signInWithPassword(email: email, password: senha);
        widget.onEntrar(nome.isNotEmpty ? nome : email);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Column(children: [
        const MonsterAvatar(emoji: '🐺', estilo: EstiloMonstro.lendario, tamanho: 116),
        const SizedBox(height: 18),
        const Text('DOMÍNION LIVE', textAlign: TextAlign.center, style: TextStyle(color: dourado, fontSize: 29, fontWeight: FontWeight.bold, letterSpacing: 1.3)),
        const SizedBox(height: 8), const Text(slogan, textAlign: TextAlign.center), const SizedBox(height: 30),
        Text(cadastro ? 'CRIAR CONTA' : 'BEM-VINDO À ALCATEIA', style: const TextStyle(color: dourado, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        TextField(controller: nomeController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Seu nome ou apelido', prefixIcon: Icon(Icons.person))),
        const SizedBox(height: 12),
        TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email))),
        const SizedBox(height: 12),
        TextField(controller: senhaController, obscureText: ocultarSenha, decoration: InputDecoration(labelText: 'Senha', prefixIcon: const Icon(Icons.lock), suffixIcon: IconButton(onPressed: () => setState(() => ocultarSenha = !ocultarSenha), icon: Icon(ocultarSenha ? Icons.visibility : Icons.visibility_off)))),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: loading ? null : continuar, style: ElevatedButton.styleFrom(backgroundColor: dourado, foregroundColor: roxo), child: loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(cadastro ? 'CRIAR CONTA' : 'ENTRAR', style: const TextStyle(fontWeight: FontWeight.bold)))),
        TextButton(onPressed: () => setState(() => cadastro = !cadastro), child: Text(cadastro ? 'Já tenho uma conta' : 'Quero criar uma conta')),
        const SizedBox(height: 10),
        Text(cadastro ? 'A conta será salva no Supabase!' : 'Conectado ao Supabase ✅', textAlign: TextAlign.center, style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
      ]))))),
    );
  }
}

class MonsterAvatar extends StatefulWidget {
  const MonsterAvatar({super.key, required this.emoji, this.estilo = EstiloMonstro.fofo, this.tamanho = 58, this.animado = true});
  final String emoji; final EstiloMonstro estilo; final double tamanho; final bool animado;
  @override
  State<MonsterAvatar> createState() => _MonsterAvatarState();
}
class _MonsterAvatarState extends State<MonsterAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController animacao;
  @override
  void initState() { super.initState(); animacao = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500)); if (widget.animado) animacao.repeat(reverse: true); }
  @override
  void dispose() { animacao.dispose(); super.dispose(); }
  Color get aura { switch (widget.estilo) { case EstiloMonstro.fofo: return dourado; case EstiloMonstro.sombrio: return const Color(0xFFB15CFF); case EstiloMonstro.lendario: return const Color(0xFF45E8FF); } }
  @override
  Widget build(BuildContext context) { return AnimatedBuilder(animation: animacao, builder: (context, child) { final movimento = widget.animado ? animacao.value : 0.0; return Transform.translate(offset: Offset(0, -4 * movimento), child: Container(width: widget.tamanho, height: widget.tamanho, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [aura.withOpacity(0.4), painel, fundo]), border: Border.all(color: aura, width: 2), boxShadow: [BoxShadow(color: aura.withOpacity(0.4), blurRadius: 10 + 8 * movimento, spreadRadius: 1 + movimento)]), child: Text(widget.emoji, style: TextStyle(fontSize: widget.tamanho * 0.48)))); }); }
}
class TelaPrincipal extends StatefulWidget { const TelaPrincipal({super.key, required this.usuario, required this.onSair}); final String usuario; final VoidCallback onSair; @override State<TelaPrincipal> createState() => _TelaPrincipalState(); }
class _TelaPrincipalState extends State<TelaPrincipal> { int indice = 0; void atualizar() => setState(() {}); @override Widget build(BuildContext context) { final paginas = [InicioPage(usuario: widget.usuario, irPara: (i) => setState(() => indice = i)), SalasPage(usuario: widget.usuario), CriarSalaPage(usuario: widget.usuario, onCriada: () => setState(() => indice = 1)), FamiliasPage(onChanged: atualizar), PerfilPage(usuario: widget.usuario, onSair: widget.onSair)]; return Scaffold(appBar: AppBar(title: const Text('DOMÍNION LIVE', style: TextStyle(fontWeight: FontWeight.bold))), body: IndexedStack(index: indice, children: paginas), bottomNavigationBar: NavigationBar(selectedIndex: indice, backgroundColor: roxo, indicatorColor: roxoClaro, onDestinationSelected: (i) => setState(() => indice = i), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'), NavigationDestination(icon: Icon(Icons.meeting_room_outlined), selectedIcon: Icon(Icons.meeting_room), label: 'Salas'), NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Criar'), NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Família'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil')])); } }
class InicioPage extends StatelessWidget { const InicioPage({super.key, required this.usuario, required this.irPara}); final String usuario; final ValueChanged<int> irPara; @override Widget build(BuildContext context) { return ListView(padding: const EdgeInsets.all(16), children: [Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [roxoClaro, roxo, fundo], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), border: Border.all(color: dourado)), child: Column(children: [const MonsterAvatar(emoji: '🐺', estilo: EstiloMonstro.lendario, tamanho: 100), const SizedBox(height: 12), const Text('DOMÍNION LIVE', style: TextStyle(color: dourado, fontSize: 25, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text('Seja bem-vindo, $usuario!', textAlign: TextAlign.center), const SizedBox(height: 6), const Text(slogan, textAlign: TextAlign.center)])), const SizedBox(height: 22), _atalho(context, 'Entrar nas salas', Icons.meeting_room, () => irPara(1)), _atalho(context, 'Criar uma sala', Icons.add_circle, () => irPara(2)), _atalho(context, 'Minha família', Icons.groups, () => irPara(3)), _atalho(context, 'Meu perfil', Icons.person, () => irPara(4)), const SizedBox(height: 18), const Text('ESCOLHA SEU ESTILO', textAlign: TextAlign.center, style: TextStyle(color: dourado, fontWeight: FontWeight.bold)), const SizedBox(height: 14), const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [MonsterAvatar(emoji: '👾', estilo: EstiloMonstro.fofo), MonsterAvatar(emoji: '👹', estilo: EstiloMonstro.sombrio), MonsterAvatar(emoji: '🐉', estilo: EstiloMonstro.lendario)])]); } Widget _atalho(BuildContext context, String texto, IconData icone, VoidCallback acao) { return Padding(padding: const EdgeInsets.only(bottom: 10), child: SizedBox(height: 54, child: ElevatedButton.icon(onPressed: acao, icon: Icon(icone, color: dourado), label: Text(texto), style: ElevatedButton.styleFrom(backgroundColor: painel, foregroundColor: Colors.white, side: const BorderSide(color: dourado))))); } }
class SalasPage extends StatefulWidget { const SalasPage({super.key, required this.usuario}); final String usuario; @override State<SalasPage> createState() => _SalasPageState(); }
class _SalasPageState extends State<SalasPage> { @override Widget build(BuildContext context) { return Scaffold(body: ListView(padding: const EdgeInsets.all(14), children: [const Text('SALAS DA ALCATEIA', style: TextStyle(color: dourado, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 10), ...DadosDominion.salas.map((sala) { return Card(color: painel, child: ListTile(leading: MonsterAvatar(emoji: sala.emoji, estilo: sala.privada ? EstiloMonstro.lendario : EstiloMonstro.fofo, tamanho: 48), title: Text(sala.nome, style: const TextStyle(color: dourado, fontWeight: FontWeight.bold)), subtitle: Text('${sala.privada ? '🔒 Privada' : '🌎 Pública'} • ${sala.participantes}/${sala.casalAtivado ? 10 : 8} lugares\nResponsável: ${sala.dono}'), isThreeLine: true, trailing: const Icon(Icons.arrow_forward_ios, color: dourado, size: 16), onTap: () { if (sala.privada) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sala privada: solicite autorização ao responsável.'))); return; } Navigator.push(context, MaterialPageRoute(builder: (_) => SalaAoVivoPage(sala: sala, usuario: widget.usuario))).then((_) { if (mounted) setState(() {}); }); })); })])); } }
class CriarSalaPage extends StatefulWidget { const CriarSalaPage({super.key, required this.usuario, required this.onCriada}); final String usuario; final VoidCallback onCriada; @override State<CriarSalaPage> createState() => _CriarSalaPageState(); }
class _CriarSalaPageState extends State<CriarSalaPage> { final nomeController = TextEditingController(); bool privada = false; bool casalAtivado = true; String emoji = '🐺'; @override void dispose() { nomeController.dispose(); super.dispose(); } void criar() { final nome = nomeController.text.trim(); if (nome.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite o nome da sala.'))); return; } final sala = SalaDominion(nome: nome, dono: widget.usuario, emoji: emoji, privada: privada, casalAtivado: casalAtivado); DadosDominion.salas.add(sala); Navigator.push(context, MaterialPageRoute(builder: (_) => SalaAoVivoPage(sala: sala, usuario: widget.usuario))).then((_) => widget.onCriada()); } @override Widget build(BuildContext context) { return ListView(padding: const EdgeInsets.all(18