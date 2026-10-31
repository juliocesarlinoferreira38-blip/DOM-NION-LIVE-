import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {WidgetsFlutterBinding.ensureInitialized();await Supabase.initialize(url: 'https://kjkbxvlceefxsdhwvusj.supabase.co', anonKey:'sb_publishable_77p5ibIx-9mnV57Ew1MGrw_GRuGbORp');runApp(const DominionLiveApp());}

// ======================================================
// DOMINION LIVE — IDENTIDADE VISUAL
// ======================================================

const Color roxo = Color(0xFF210B45);
const Color roxoClaro = Color(0xFF713AC0);
const Color dourado = Color(0xFFFFD76A);
const Color painel = Color(0xFF321653);
const Color fundo = Color(0xFF170729);

const String slogan = 'Sua voz. Sua família. Seu império!';

// ======================================================
// MODELOS
// ======================================================

enum EstiloMonstro { fofo, sombrio, lendario }

class SalaDominion {
  SalaDominion({
    required this.nome,
    required this.dono,
    this.emoji = '🐺',
    this.privada = false,
    this.casalAtivado = true,
  });

  final String nome;
  final String dono;
  final String emoji;
  final bool privada;
  final bool casalAtivado;

  // Oito lugares comuns e dois lugares opcionais do casal.
  final List<String?> assentos = List<String?>.filled(8, null);
  final List<String?> casal = List<String?>.filled(2, null);

  int get participantes =>
      assentos.where((p) => p != null).length +
      casal.where((p) => p != null).length;
}

class FamiliaDominion {
  FamiliaDominion({
    required this.nome,
    required this.lema,
    required this.lider,
    List<String>? membros,
  }) : membros = membros ?? [lider];

  final String nome;
  final String lema;
  final String lider;
  final List<String> membros;
}

// ======================================================
// DADOS DEMONSTRATIVOS
// Mantidos em memória; Firebase será integrado depois.
// ======================================================

class DadosDominion {
  static final List<SalaDominion> salas = [
    SalaDominion(
      nome: 'Sala da Família',
      dono: 'ALFA GAEL',
      emoji: '🐺',
    ),
    SalaDominion(
      nome: 'Sala do Casal',
      dono: 'ALFA GAEL',
      emoji: '💜',
    ),
    SalaDominion(
      nome: 'Sala de Música',
      dono: 'ALFA GAEL',
      emoji: '🎵',
      casalAtivado: false,
    ),
    SalaDominion(
      nome: 'Sala VIP',
      dono: 'ALFA GAEL',
      emoji: '👑',
      privada: true,
    ),
  ];

  static final List<FamiliaDominion> familias = [
    FamiliaDominion(
      nome: 'DOMÍNION ALFA',
      lema: slogan,
      lider: 'ALFA GAEL',
      membros: ['ALFA GAEL', 'IMPERATRIZ ALFA'],
    ),
    FamiliaDominion(
      nome: 'Família Scorpion',
      lema: 'União e lealdade',
      lider: 'Scorpion',
    ),
    FamiliaDominion(
      nome: 'Tribo Alpha',
      lema: 'Força da alcateia',
      lider: 'Tribo Alpha',
    ),
  ];
}

// ======================================================
// APLICATIVO PRINCIPAL
// ======================================================

class DominionLiveApp extends StatefulWidget {
  const DominionLiveApp({super.key});

  @override
  State<DominionLiveApp> createState() => _DominionLiveAppState();
}

class _DominionLiveAppState extends State<DominionLiveApp> {
  String? usuario;

  void entrar(String nome) {
    setState(() => usuario = nome);
  }

  void sair() {
    setState(() => usuario = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOMÍNION LIVE',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: dourado,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: roxo,
          foregroundColor: dourado,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: painel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: usuario == null
          ? TelaLogin(onEntrar: entrar)
          : TelaPrincipal(
              usuario: usuario!,
              onSair: sair,
            ),
    );
  }
}

// ======================================================
// LOGIN DEMONSTRATIVO — NÃO É AUTENTICAÇÃO REAL
// ======================================================

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

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void continuar() {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos para continuar.'),
        ),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido.')),
      );
      return;
    }

    if (senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Use uma senha com pelo menos 6 caracteres.'),
        ),
      );
      return;
    }

    // Demonstração local: nenhuma conta é criada no servidor.
    widget.onEntrar(nome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                children: [
                  const MonsterAvatar(
                    emoji: '🐺',
                    estilo: EstiloMonstro.lendario,
                    tamanho: 116,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'DOMÍNION LIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dourado,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(slogan, textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  Text(
                    cadastro ? 'CRIAR CONTA' : 'BEM-VINDO À ALCATEIA',
                    style: const TextStyle(
                      color: dourado,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: nomeController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Seu nome ou apelido',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: senhaController,
                    obscureText: ocultarSenha,
                    decoration: InputDecoration(
                      labelText: 'Senha de demonstração',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => ocultarSenha = !ocultarSenha,
                        ),
                        icon: Icon(
                          ocultarSenha
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: continuar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dourado,
                        foregroundColor: roxo,
                      ),
                      child: Text(
                        cadastro ? 'CRIAR CONTA DEMO' : 'ENTRAR',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(
                      () => cadastro = !cadastro,
                    ),
                    child: Text(
                      cadastro
                          ? 'Já tenho uma conta'
                          : 'Quero criar uma conta',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Modo de teste. A conta ainda não é salva.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// AVATAR ANIMADO
// ======================================================

class MonsterAvatar extends StatefulWidget {
  const MonsterAvatar({
    super.key,
    required this.emoji,
    this.estilo = EstiloMonstro.fofo,
    this.tamanho = 58,
    this.animado = true,
  });

  final String emoji;
  final EstiloMonstro estilo;
  final double tamanho;
  final bool animado;

  @override
  State<MonsterAvatar> createState() => _MonsterAvatarState();
}

class _MonsterAvatarState extends State<MonsterAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController animacao;

  @override
  void initState() {
    super.initState();
    animacao = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.animado) {
      animacao.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MonsterAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animado && !animacao.isAnimating) {
      animacao.repeat(reverse: true);
    } else if (!widget.animado && animacao.isAnimating) {
      animacao.stop();
    }
  }

  @override
  void dispose() {
    animacao.dispose();
    super.dispose();
  }

  Color get aura {
    switch (widget.estilo) {
      case EstiloMonstro.fofo:
        return dourado;
      case EstiloMonstro.sombrio:
        return const Color(0xFFB15CFF);
      case EstiloMonstro.lendario:
        return const Color(0xFF45E8FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animacao,
      builder: (context, child) {
        final movimento = widget.animado ? animacao.value : 0.0;

        return Transform.translate(
          offset: Offset(0, -4 * movimento),
          child: Container(
            width: widget.tamanho,
            height: widget.tamanho,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  aura.withOpacity(0.4),
                  painel,
                  fundo,
                ],
              ),
              border: Border.all(color: aura, width: 2),
              boxShadow: [
                BoxShadow(
                  color: aura.withOpacity(0.4),
                  blurRadius: 10 + 8 * movimento,
                  spreadRadius: 1 + movimento,
                ),
              ],
            ),
            child: Text(
              widget.emoji,
              style: TextStyle(fontSize: widget.tamanho * 0.48),
            ),
          ),
        );
      },
    );
  }
}

// ======================================================
// NAVEGAÇÃO PRINCIPAL
// ======================================================

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({
    super.key,
    required this.usuario,
    required this.onSair,
  });

  final String usuario;
  final VoidCallback onSair;

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int indice = 0;

  void atualizar() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final paginas = [
      InicioPage(
        usuario: widget.usuario,
        irPara: (i) => setState(() => indice = i),
      ),
      SalasPage(usuario: widget.usuario),
      CriarSalaPage(
        usuario: widget.usuario,
        onCriada: () => setState(() => indice = 1),
      ),
      FamiliasPage(onChanged: atualizar),
      PerfilPage(
        usuario: widget.usuario,
        onSair: widget.onSair,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DOMÍNION LIVE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(
        index: indice,
        children: paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indice,
        backgroundColor: roxo,
        indicatorColor: roxoClaro,
        onDestinationSelected: (i) => setState(() => indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.meeting_room_outlined),
            selectedIcon: Icon(Icons.meeting_room),
            label: 'Salas',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Criar',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Família',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ======================================================
// INÍCIO
// ======================================================

class InicioPage extends StatelessWidget {
  const InicioPage({
    super.key,
    required this.usuario,
    required this.irPara,
  });

  final String usuario;
  final ValueChanged<int> irPara;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [roxoClaro, roxo, fundo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: dourado),
          ),
          child: Column(
            children: [
              const MonsterAvatar(
                emoji: '🐺',
                estilo: EstiloMonstro.lendario,
                tamanho: 100,
              ),
              const SizedBox(height: 12),
              const Text(
                'DOMÍNION LIVE',
                style: TextStyle(
                  color: dourado,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seja bem-vindo, $usuario!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(slogan, textAlign: TextAlign.center),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _atalho(
          context,
          'Entrar nas salas',
          Icons.meeting_room,
          () => irPara(1),
        ),
        _atalho(
          context,
          'Criar uma sala',
          Icons.add_circle,
          () => irPara(2),
        ),
        _atalho(
          context,
          'Minha família',
          Icons.groups,
          () => irPara(3),
        ),
        _atalho(
          context,
          'Meu perfil',
          Icons.person,
          () => irPara(4),
        ),
        const SizedBox(height: 18),
        const Text(
          'ESCOLHA SEU ESTILO',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dourado,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MonsterAvatar(
              emoji: '👾',
              estilo: EstiloMonstro.fofo,
            ),
            MonsterAvatar(
              emoji: '👹',
              estilo: EstiloMonstro.sombrio,
            ),
            MonsterAvatar(
              emoji: '🐉',
              estilo: EstiloMonstro.lendario,
            ),
          ],
        ),
      ],
    );
  }

  Widget _atalho(
    BuildContext context,
    String texto,
    IconData icone,
    VoidCallback acao,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 54,
        child: ElevatedButton.icon(
          onPressed: acao,
          icon: Icon(icone, color: dourado),
          label: Text(texto),
          style: ElevatedButton.styleFrom(
            backgroundColor: painel,
            foregroundColor: Colors.white,
            side: const BorderSide(color: dourado),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// LISTA DE SALAS
// ======================================================

class SalasPage extends StatefulWidget {
  const SalasPage({super.key, required this.usuario});

  final String usuario;

  @override
  State<SalasPage> createState() => _SalasPageState();
}

class _SalasPageState extends State<SalasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Text(
            'SALAS DA ALCATEIA',
            style: TextStyle(
              color: dourado,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...DadosDominion.salas.map((sala) {
            return Card(
              color: painel,
              child: ListTile(
                leading: MonsterAvatar(
                  emoji: sala.emoji,
                  estilo: sala.privada
                      ? EstiloMonstro.lendario
                      : EstiloMonstro.fofo,
                  tamanho: 48,
                ),
                title: Text(
                  sala.nome,
                  style: const TextStyle(
                    color: dourado,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${sala.privada ? '🔒 Privada' : '🌎 Pública'}'
                  ' • ${sala.participantes}/${sala.casalAtivado ? 10 : 8} lugares\n'
                  'Responsável: ${sala.dono}',
                ),
                isThreeLine: true,
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: dourado,
                  size: 16,
                ),
                onTap: () {
                  if (sala.privada) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Sala privada: solicite autorização ao responsável.',
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SalaAoVivoPage(
                        sala: sala,
                        usuario: widget.usuario,
                      ),
                    ),
                  ).then((_) {
                    if (mounted) setState(() {});
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ======================================================
// CRIAR SALA
// ======================================================

class CriarSalaPage extends StatefulWidget {
  const CriarSalaPage({
    super.key,
    required this.usuario,
    required this.onCriada,
  });

  final String usuario;
  final VoidCallback onCriada;

  @override
  State<CriarSalaPage> createState() => _CriarSalaPageState();
}

class _CriarSalaPageState extends State<CriarSalaPage> {
  final nomeController = TextEditingController();
  bool privada = false;
  bool casalAtivado = true;
  String emoji = '🐺';

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  void criar() {
    final nome = nomeController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome da sala.')),
      );
      return;
    }

    final sala = SalaDominion(
      nome: nome,
      dono: widget.usuario,
      emoji: emoji,
      privada: privada,
      casalAtivado: casalAtivado,
    );

    DadosDominion.salas.add(sala);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SalaAoVivoPage(
          sala: sala,
          usuario: widget.usuario,
        ),
      ),
    ).then((_) => widget.onCriada());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'CRIAR MINHA SALA',
          style: TextStyle(
            color: dourado,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome da sala',
            prefixIcon: Icon(Icons.meeting_room),
          ),
        ),
        const SizedBox(height: 18),
        const Text('Símbolo da sala'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['🐺', '👑', '💜', '🎵', '🐉', '👹']
              .map(
                (e) => ChoiceChip(
                  label: Text(e, style: const TextStyle(fontSize: 23)),
                  selected: emoji == e,
                  onSelected: (_) => setState(() => emoji = e),
                ),
              )
              .toList(),
        ),
        SwitchListTile(
          title: const Text('Sala privada'),
          value: privada,
          activeColor: dourado,
          onChanged: (v) => setState(() => privada = v),
        ),
        SwitchListTile(
          title: const Text('Ativar dois lugares para o casal'),
          value: casalAtivado,
          activeColor: dourado,
          onChanged: (v) => setState(() => casalAtivado = v),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: criar,
            icon: const Icon(Icons.add),
            label: const Text('CRIAR SALA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: dourado,
              foregroundColor: roxo,
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// SALA — OITO ASSENTOS E DOIS DO CASAL
// ======================================================

class SalaAoVivoPage extends StatefulWidget {
  const SalaAoVivoPage({
    super.key,
    required this.sala,
    required this.usuario,
  });

  final SalaDominion sala;
  final String usuario;

  @override
  State<SalaAoVivoPage> createState() => _SalaAoVivoPageState();
}

class _SalaAoVivoPageState extends State<SalaAoVivoPage> {
  final mensagemController = TextEditingController();
  final List<String> mensagens = [
    'Sistema: bem-vindo à sala!',
    '🐺 Respeito e união na alcateia.',
  ];

  bool microfoneDemo = false;

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }

  void sentar(List<String?> lugares, int indice) {
    setState(() {
      if (lugares[indice] == widget.usuario) {
        lugares[indice] = null;
        return;
      }

      if (lugares[indice] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este lugar já está ocupado.')),
        );
        return;
      }

      final jaSentado =
          widget.sala.assentos.contains(widget.usuario) ||
          widget.sala.casal.contains(widget.usuario);

      if (jaSentado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Levante-se do lugar atual primeiro.'),
          ),
        );
        return;
      }

      lugares[indice] = widget.usuario;
    });
  }

  Widget assento(
    List<String?> lugares,
    int indice, {
    bool casal = false,
  }) {
    final nome = lugares[indice];
    final ocupado = nome != null;

    return InkWell(
      onTap: () => sentar(lugares, indice),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 3),
        decoration: BoxDecoration(
          color: painel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ocupado ? dourado : roxoClaro,
            width: ocupado ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MonsterAvatar(
              emoji: ocupado
                  ? (casal ? '💞' : '👹')
                  : (casal ? '💜' : '👾'),
              estilo: ocupado
                  ? EstiloMonstro.sombrio
                  : EstiloMonstro.fofo,
              tamanho: casal ? 48 : 42,
            ),
            const SizedBox(height: 5),
            Text(
              nome ?? (casal ? 'Casal ${indice + 1}' : 'Lugar ${indice + 1}'),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: ocupado ? dourado : Colors.white,
              ),
            ),
            if (nome == widget.usuario)
              const Text(
                'VOCÊ',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 9,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void enviarMensagem() {
    final texto = mensagemController.text.trim();
    if (texto.isEmpty) return;

    setState(() {
      mensagens.add('${widget.usuario}: $texto');
      mensagemController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sala = widget.sala;

    return Scaffold(
      appBar: AppBar(
        title: Text(sala.nome),
        actions: [
          IconButton(
            tooltip: 'Sair da sala',
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [roxoClaro, roxo, fundo],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dourado),
            ),
            child: Column(
              children: [
                MonsterAvatar(
                  emoji: sala.emoji,
                  estilo: EstiloMonstro.lendario,
                  tamanho: 76,
                ),
                const SizedBox(height: 8),
                Text(
                  sala.nome,
                  style: const TextStyle(
                    color: dourado,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Responsável: ${sala.dono}'),
                Text(
                  'Participantes: ${sala.participantes}/'
                  '${sala.casalAtivado ? 10 : 8}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'PALCO DA ALCATEIA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dourado,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, i) => assento(sala.assentos, i),
          ),
          if (sala.casalAtivado) ...[
            const SizedBox(height: 20),
            const Text(
              '💜 LUGARES DO CASAL 💜',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dourado,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: assento(sala.casal, 0, casal: true)),
                const SizedBox(width: 12),
                Expanded(child: assento(sala.casal, 1, casal: true)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => microfoneDemo = !microfoneDemo);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Controle demonstrativo: o áudio ao vivo ainda não foi conectado.',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  microfoneDemo ? Icons.mic : Icons.mic_off,
                ),
                label: Text(
                  microfoneDemo ? 'Microfone demo ligado' : 'Microfone demo',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: painel,
                  foregroundColor: dourado,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(
                  () => mensagens.add(
                    '${widget.usuario} enviou um presente 🎁 (demo)',
                  ),
                ),
                icon: const Icon(Icons.card_giftcard),
                label: const Text('Presente demo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: painel,
                  foregroundColor: dourado,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'CHAT DEMONSTRATIVO',
            style: TextStyle(
              color: dourado,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 180,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: mensagens.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(mensagens[i]),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: mensagemController,
                  decoration: const InputDecoration(
                    hintText: 'Escreva uma mensagem...',
                  ),
                  onSubmitted: (_) => enviarMensagem(),
                ),
              ),
              IconButton(
                onPressed: enviarMensagem,
                icon: const Icon(Icons.send, color: dourado),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// FAMÍLIAS
// ======================================================

class FamiliasPage extends StatefulWidget {
  const FamiliasPage({super.key, required this.onChanged});

  final VoidCallback onChanged;

  @override
  State<FamiliasPage> createState() => _FamiliasPageState();
}

class _FamiliasPageState extends State<FamiliasPage> {
  final nomeController = TextEditingController();
  final lemaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    lemaController.dispose();
    super.dispose();
  }

  void criarFamilia() {
    final nome = nomeController.text.trim();
    final lema = lemaController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome da família.')),
      );
      return;
    }

    final existe = DadosDominion.familias.any(
      (f) => f.nome.toLowerCase() == nome.toLowerCase(),
    );

    if (existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Já existe uma família com esse nome.'),
        ),
      );
      return;
    }

    setState(() {
      DadosDominion.familias.add(
        FamiliaDominion(
          nome: nome,
          lema: lema.isEmpty ? 'União e lealdade' : lema,
          lider: 'ALFA GAEL',
        ),
      );
      nomeController.clear();
      lemaController.clear();
    });

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'FAMÍLIAS DOMÍNION',
          style: TextStyle(
            color: dourado,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome da família',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: lemaController,
          decoration: const InputDecoration(
            labelText: 'Lema da família',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: criarFamilia,
          icon: const Icon(Icons.group_add),
          label: const Text('CRIAR FAMÍLIA'),
          style: ElevatedButton.styleFrom(
            backgroundColor: dourado,
            foregroundColor: roxo,
          ),
        ),
        const SizedBox(height: 18),
        ...DadosDominion.familias.map(
          (familia) => Card(
            color: painel,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MonsterAvatar(
                        emoji: '🐺',
                        estilo: EstiloMonstro.lendario,
                        tamanho: 48,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          familia.nome,
                          style: const TextStyle(
                            color: dourado,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(familia.lema),
                  Text('Líder: ${familia.lider}'),
                  Text('Membros: ${familia.membros.length}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: familia.membros
                        .map((m) => Chip(label: Text(m)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// PERFIL
// ======================================================

class PerfilPage extends StatelessWidget {
  const PerfilPage({
    super.key,
    required this.usuario,
    required this.onSair,
  });

  final String usuario;
  final VoidCallback onSair;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        const Center(
          child: MonsterAvatar(
            emoji: '🐺',
            estilo: EstiloMonstro.lendario,
            tamanho: 120,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            usuario,
            style: const TextStyle(
              color: dourado,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Center(child: Text('Membro da alcateia')),
        const SizedBox(height: 22),
        _item(Icons.shield, 'Nível', '1'),
        _item(Icons.groups, 'Família', 'DOMÍNION ALFA'),
        _item(Icons.card_giftcard, 'Presentes', '0'),
        _item(Icons.emoji_events, 'Ranking', 'Em breve'),
        const SizedBox(height: 18),
        const Text(
          'Foto, personalização de monstrinhos, molduras VIP '
          'e ranking persistente serão adicionados nas próximas etapas.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: onSair,
          icon: const Icon(Icons.logout),
          label: const Text('SAIR DA DEMONSTRAÇÃO'),
          style: OutlinedButton.styleFrom(
            foregroundColor: dourado,
            side: const BorderSide(color: dourado),
          ),
        ),
      ],
    );
  }

  Widget _item(IconData icone, String titulo, String valor) {
    return Card(
      color: painel,
      child: ListTile(
        leading: Icon(icone, color: dourado),
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(
            color: dourado,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
