import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==========================================
// DOMÍNION LIVE
// PARTE 1 DE 7
// CONFIGURAÇÃO E INICIALIZAÇÃO
// ==========================================

const String supabaseUrl =
    'https://xmmaemdayfwvxambhaiu.supabase.co';

const String supabasePublishableKey = 
 'sb_publishable_hIyp9xdiQhUj1h_VnTsHZg_yMWDW9dc),

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublishableKey,
  );

  runApp(const DominionLive());
}

// ==========================================
// CORES DO APLICATIVO
// ==========================================

class DominionColors {
  static const Color fundo = Color(0xFF080808);
  static const Color painel = Color(0xFF151515);
  static const Color dourado = Color(0xFFD4AF37);
  static const Color douradoClaro = Color(0xFFFFD700);
  static const Color branco = Colors.white;
  static const Color cinza = Color(0xFFAAAAAA);
}

// ==========================================
// APLICATIVO PRINCIPAL
// ==========================================

class DominionLive extends StatelessWidget {
  const DominionLive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOMÍNION LIVE',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DominionColors.fundo,

        primaryColor: DominionColors.dourado,

        colorScheme: const ColorScheme.dark(
          primary: DominionColors.dourado,
          secondary: DominionColors.douradoClaro,
          surface: DominionColors.painel,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: DominionColors.fundo,
          foregroundColor: DominionColors.dourado,
          elevation: 0,
          centerTitle: true,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: DominionColors.painel,
          hintStyle: const TextStyle(
            color: DominionColors.cinza,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: DominionColors.dourado,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.white24,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: DominionColors.dourado,
              width: 2,
            ),
          ),
        ),
      ),

      home: const TelaInicialDominion(),
    );
  }
}

// ==========================================
// TELA INICIAL
// ==========================================

class TelaInicialDominion extends StatelessWidget {
  const TelaInicialDominion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF202020),
              Color(0xFF080808),
              Color(0xFF000000),
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Icon(
                    Icons.workspace_premium,
                    color: DominionColors.dourado,
                    size: 95,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'DOMÍNION LIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DominionColors.dourado,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'SEU MUNDO. SUA SALA. SEU DOMÍNIO.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const CircularProgressIndicator(
                    color: DominionColors.dourado,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Preparando seu domínio...',
                    style: TextStyle(
                      color: DominionColors.cinza,
                      fontSize: 13,
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
class TelaInicialDominion extends StatefulWidget {
  const TelaInicialDominion({super.key});

  @override
  State<TelaInicialDominion> createState() =>
      _TelaInicialDominionState();
}

class _TelaInicialDominionState
    extends State<TelaInicialDominion> {

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _modoCadastro = false;
  bool _carregando = false;
  bool _mostrarSenha = false;

  String? _mensagem;
  bool _mensagemErro = false;

  Future<void> _entrar() async {
    if (_emailController.text.trim().isEmpty ||
        _senhaController.text.isEmpty) {
      setState(() {
        _mensagem = 'Preencha seu e-mail e senha.';
        _mensagemErro = true;
      });
      return;
    }

    setState(() {
      _carregando = true;
      _mensagem = null;
    });

    try {
      final auth = Supabase.instance.client.auth;

      if (_modoCadastro) {
        final resposta = await auth.signUp(
          email: _emailController.text.trim(),
          password: _senhaController.text,
        );

        if (resposta.user != null) {
          _mostrarMensagem(
            'Cadastro realizado! Verifique seu e-mail.',
          );
        }
      } else {
        await auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text,
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const TelaPrincipalDominion(),
            ),
          );
        }
      }
    } on AuthException catch (e) {
      _mostrarMensagem(e.message, erro: true);
    } catch (e) {
      _mostrarMensagem(
        'Não foi possível conectar. Tente novamente.',
        erro: true,
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _recuperarSenha() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _mostrarMensagem(
        'Digite seu e-mail primeiro.',
        erro: true,
      );
      return;
    }

    try {
      await Supabase.instance.client.auth
          .resetPasswordForEmail(email);

      _mostrarMensagem(
        'Verifique seu e-mail para redefinir a senha.',
      );
    } on AuthException catch (e) {
      _mostrarMensagem(e.message, erro: true);
    }
  }

  void _mostrarMensagem(
    String mensagem, {
    bool erro = false,
  }) {
    if (!mounted) return;

    setState(() {
      _mensagem = mensagem;
      _mensagemErro = erro;
    });
  }

  void _alternarModo() {
    setState(() {
      _modoCadastro = !_modoCadastro;
      _mensagem = null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF202020),
              Color(0xFF080808),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: DominionColors.dourado,
                    size: 85,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'DOMÍNION LIVE',
                    style: TextStyle(
                      color: DominionColors.dourado,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _modoCadastro
                        ? 'CRIE SUA CONTA'
                        : 'ENTRE NO SEU DOMÍNIO',
                    style: const TextStyle(
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: DominionColors.dourado,
                      ),
                      hintText: 'Seu e-mail',
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: DominionColors.dourado,
                      ),
                      hintText: 'Sua senha',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: DominionColors.dourado,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (!_modoCadastro)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _recuperarSenha,
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: DominionColors.dourado,
                          ),
                        ),
                      ),
                    ),

                  if (_mensagem != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: DominionColors.painel,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _mensagemErro
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      child: Text(
                        _mensagem!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _mensagemErro
                              ? Colors.red[200]
                              : Colors.green[200],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _entrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DominionColors.dourado,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _carregando
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : Text(
                              _modoCadastro
                                  ? 'CRIAR CONTA'
                                  : 'ENTRAR',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: _alternarModo,
                    child: Text(
                      _modoCadastro
                          ? 'Já tem conta? Entrar'
                          : 'Não tem conta? Cadastre-se',
                      style: const TextStyle(
                        color: DominionColors.dourado,
                      ),
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

// ==========================================
// DOMÍNION LIVE - PARTE 3 DE 7
// TELA PRINCIPAL DO APLICATIVO
// ==========================================

class TelaPrincipalDominion extends StatefulWidget {
  const TelaPrincipalDominion({super.key});

  @override
  State<TelaPrincipalDominion> createState() =>
      _TelaPrincipalDominionState();
}

class _TelaPrincipalDominionState
    extends State<TelaPrincipalDominion> {

  String _nomeUsuario = 'Membro DOMÍNION';
  String? _fotoUsuario;
  bool _carregandoPerfil = true;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) return;

    try {
      final dados = await Supabase.instance.client
          .from('perfis')
          .select()
          .eq('id', usuario.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _nomeUsuario =
              dados?['nome'] ?? usuario.email ?? 'Membro';
          _fotoUsuario = dados?['foto_url'];
          _carregandoPerfil = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _nomeUsuario = usuario.email ?? 'Membro';
          _carregandoPerfil = false;
        });
      }
    }
  }

  Future<void> _sair() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const TelaInicialDominion(),
      ),
      (route) => false,
    );
  }

  void _abrirPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PerfilDominion(),
      ),
    );
  }

  void _criarSala() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CriarSalaDominion(),
      ),
    );
  }

  Widget _botaoMenu({
    required IconData icone,
    required String titulo,
    required VoidCallback acao,
  }) {
    return InkWell(
      onTap: acao,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: DominionColors.painel,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: DominionColors.dourado.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icone,
              color: DominionColors.dourado,
              size: 27,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: DominionColors.dourado,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DOMÍNION LIVE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _sair,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF493813),
                      Color(0xFF17130A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: DominionColors.dourado,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: DominionColors.dourado,
                      backgroundImage: _fotoUsuario != null
                          ? NetworkImage(_fotoUsuario!)
                          : null,
                      child: _fotoUsuario == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 38,
                            )
                          : null,
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BEM-VINDO AO DOMÍNIO',
                            style: TextStyle(
                              color: DominionColors.dourado,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _carregandoPerfil
                                ? 'Carregando...'
                                : _nomeUsuario,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'SEU DOMÍNIO',
                style: TextStyle(
                  color: DominionColors.dourado,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              _botaoMenu(
                icone: Icons.add_circle_outline,
                titulo: 'CRIAR UMA SALA',
                acao: _criarSala,
              ),

              const SizedBox(height: 13),

              _botaoMenu(
                icone: Icons.meeting_room,
                titulo: 'SALAS DISPONÍVEIS',
                acao: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ListaSalasDominion(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 13),

              _botaoMenu(
                icone: Icons.person_outline,
                titulo: 'MEU PERFIL',
                acao: _abrirPerfil,
              ),

              const SizedBox(height: 13),

              _botaoMenu(
                icone: Icons.card_giftcard,
                titulo: 'PRESENTES',
                acao: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Sistema de presentes será ativado.',
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 35),

              const Center(
                child: Text(
                  'DOMÍNION LIVE © 2026',
                  style: TextStyle(
                    color: Colors.white38,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// DOMÍNION LIVE - PARTE 4 DE 7
// CRIAÇÃO DE SALAS
// ==========================================

class CriarSalaDominion extends StatefulWidget {
  const CriarSalaDominion({super.key});

  @override
  State<CriarSalaDominion> createState() =>
      _CriarSalaDominionState();
}

class _CriarSalaDominionState
    extends State<CriarSalaDominion> {

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool _privada = false;
  bool _carregando = false;

  Future<void> _criarSala() async {
    final nome = _nomeController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (nome.isEmpty) {
      _mensagem('Digite o nome da sala.');
      return;
    }

    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) {
      _mensagem('Faça login novamente.');
      return;
    }

    setState(() => _carregando = true);

    try {
      await Supabase.instance.client
          .from('salas')
          .insert({
        'nome': nome,
        'descricao': descricao,
        'privada': _privada,
        'criador_id': usuario.id,
        'total_cadeiras': 10,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sala criada com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } on PostgrestException catch (e) {
      _mensagem('Erro ao criar sala: ${e.message}');
    } catch (_) {
      _mensagem('Não foi possível criar a sala.');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRIAR SALA'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: Icon(
                Icons.meeting_room,
                color: DominionColors.dourado,
                size: 85,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'CRIE SEU DOMÍNIO',
                style: TextStyle(
                  color: DominionColors.dourado,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'NOME DA SALA',
              style: TextStyle(
                color: DominionColors.dourado,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _nomeController,
              maxLength: 40,
              decoration: const InputDecoration(
                hintText: 'Digite o nome da sua sala',
                prefixIcon: Icon(
                  Icons.edit,
                  color: DominionColors.dourado,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'DESCRIÇÃO',
              style: TextStyle(
                color: DominionColors.dourado,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _descricaoController,
              maxLines: 3,
              maxLength: 150,
              decoration: const InputDecoration(
                hintText: 'Descreva sua sala...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: DominionColors.painel,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: DominionColors.dourado,
                ),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.event_seat,
                    color: DominionColors.dourado,
                    size: 30,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      '10 CADEIRAS DISPONÍVEIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            SwitchListTile(
              value: _privada,
              onChanged: (valor) {
                setState(() => _privada = valor);
              },
              activeThumbColor: DominionColors.dourado,
              title: const Text(
                'Sala privada',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Restringir o acesso à sala',
                style: TextStyle(color: Colors.white54),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _carregando ? null : _criarSala,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DominionColors.dourado,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _carregando
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Text(
                        'CRIAR SALA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// DOMÍNION LIVE - PARTE 5 DE 7
// LISTA DE SALAS EM TEMPO REAL
// ==========================================

class ListaSalasDominion extends StatefulWidget {
  const ListaSalasDominion({super.key});

  @override
  State<ListaSalasDominion> createState() =>
      _ListaSalasDominionState();
}

class _ListaSalasDominionState
    extends State<ListaSalasDominion> {

  late final Stream<List<Map<String, dynamic>>> _salasStream;

  @override
  void initState() {
    super.initState();

    _salasStream = Supabase.instance.client
        .from('salas')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<void> _atualizar() async {
    setState(() {
      _salasStream = Supabase.instance.client
          .from('salas')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false);
    });
  }

  void _abrirSala(Map<String, dynamic> sala) {
    if (sala['privada'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Esta sala é privada. Acesso por convite.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaSalaDominion(
          sala: sala,
        ),
      ),
    );
  }

  Widget _cartaoSala(Map<String, dynamic> sala) {
    final nome = sala['nome'] ?? 'Sala DOMÍNION';
    final descricao = sala['descricao'] ?? '';
    final privada = sala['privada'] == true;

    return InkWell(
      onTap: () => _abrirSala(sala),
      borderRadius: BorderRadius.circular(16),

      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: DominionColors.painel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: DominionColors.dourado.withOpacity(0.6),
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF30250D),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.meeting_room,
                color: DominionColors.dourado,
                size: 30,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    nome.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DominionColors.dourado,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    descricao.toString().isEmpty
                        ? 'Bem-vindo à sala!'
                        : descricao.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    privada ? 'SALA PRIVADA' : 'SALA PÚBLICA',
                    style: TextStyle(
                      color: privada
                          ? Colors.orange
                          : Colors.greenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: DominionColors.dourado,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SALAS DISPONÍVEIS'),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _salasStream,

        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar salas: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState ==
                  ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: DominionColors.dourado,
              ),
            );
          }

          final salas = snapshot.data ?? [];

          if (salas.isEmpty) {
            return RefreshIndicator(
              color: DominionColors.dourado,
              onRefresh: _atualizar,
              child: ListView(
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.meeting_room_outlined,
                    size: 75,
                    color: DominionColors.dourado,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Nenhuma sala disponível.',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: DominionColors.dourado,
            onRefresh: _atualizar,

            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: salas.length,
              itemBuilder: (context, index) {
                return _cartaoSala(salas[index]);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: DominionColors.dourado,
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CriarSalaDominion(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

 // ==========================================
 // DOMÍNION LIVE - PARTE 6 DE 7
 // INTERIOR DAS SALAS
 // ==========================================

class TelaSalaDominion extends StatefulWidget {
  final Map<String, dynamic> sala;

  const TelaSalaDominion({
    super.key,
    required this.sala,
  });

  @override
  State<TelaSalaDominion> createState() =>
      _TelaSalaDominionState();
}

class _TelaSalaDominionState extends State<TelaSalaDominion> {
  final _mensagemController = TextEditingController();

  late final Stream<List<Map<String, dynamic>>> _mensagensStream;

  @override
  void initState() {
    super.initState();

    _mensagensStream = Supabase.instance.client
        .from('mensagens_sala')
        .stream(primaryKey: ['id'])
        .eq('sala_id', widget.sala['id'])
        .order('created_at', ascending: true);
  }

  Future<void> _enviarMensagem() async {
    final texto = _mensagemController.text.trim();

    if (texto.isEmpty) return;

    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) return;

    try {
      await Supabase.instance.client
          .from('mensagens_sala')
          .insert({
        'sala_id': widget.sala['id'],
        'usuario_id': usuario.id,
        'mensagem': texto,
      });

      _mensagemController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar a mensagem.'),
        ),
      );
    }
  }

  Widget _cadeira(int numero) {
    return Container(
      width: 65,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: DominionColors.painel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DominionColors.dourado.withOpacity(0.7),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.account_circle,
            color: DominionColors.dourado,
            size: 35,
          ),
          const SizedBox(height: 4),
          Text(
            'Lugar $numero',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mensagem(Map<String, dynamic> dados) {
    final usuarioAtual =
        Supabase.instance.client.auth.currentUser?.id;

    final minhaMensagem =
        dados['usuario_id'] == usuarioAtual;

    return Align(
      alignment: minhaMensagem
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 270),
        decoration: BoxDecoration(
          color: minhaMensagem
              ? const Color(0xFF493813)
              : DominionColors.painel,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: DominionColors.dourado.withOpacity(0.4),
          ),
        ),
        child: Text(
          dados['mensagem']?.toString() ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sala['nome']?.toString() ?? 'Sala DOMÍNION',
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF493813),
                  Color(0xFF15110A),
                ],
              ),
            ),
            child: const Text(
              'DOMÍNION LIVE • SALA DE CONEXÃO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DominionColors.dourado,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'ÁREA DE PARTICIPANTES',
            style: TextStyle(
              color: DominionColors.dourado,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // 2 CADEIRAS NA PARTE SUPERIOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cadeira(1),
              _cadeira(2),
            ],
          ),

          // 8 CADEIRAS NA PARTE INFERIOR
          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              8,
              (index) => _cadeira(index + 3),
            ),
          ),

          const Divider(
            color: DominionColors.dourado,
            height: 25,
          ),

          const Text(
            'CHAT DA SALA',
            style: TextStyle(
              color: DominionColors.dourado,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: StreamBuilder<
                List<Map<String, dynamic>>>(
              stream: _mensagensStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Erro ao carregar mensagens.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: DominionColors.dourado,
                    ),
                  );
                }

                final mensagens = snapshot.data!;

                if (mensagens.isEmpty) {
                  return const Center(
                    child: Text(
                      'Seja o primeiro a conversar!',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    return _mensagem(mensagens[index]);
                  },
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: _enviarMensagem,
                    icon: const Icon(
                      Icons.send,
                      color: DominionColors.dourado,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 // ==========================================
 // DOMÍNION LIVE - PARTE 7 DE 7
 // PERFIL, AVATAR, PRESENTES E ADMINISTRAÇÃO
 // ==========================================

// ==========================================
// PERFIL DO USUÁRIO
// ==========================================

class PerfilDominion extends StatefulWidget {
  const PerfilDominion({super.key});

  @override
  State<PerfilDominion> createState() =>
      _PerfilDominionState();
}

class _PerfilDominionState extends State<PerfilDominion> {
  final _nomeController = TextEditingController();
  bool _carregando = false;
  String? _fotoUrl;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) return;

    try {
      final dados = await Supabase.instance.client
          .from('perfis')
          .select()
          .eq('id', usuario.id)
          .maybeSingle();

      if (!mounted) return;

      setState(() {
        _nomeController.text =
            dados?['nome'] ?? '';
        _fotoUrl = dados?['foto_url'];
      });
    } catch (_) {
      _mensagem('Não foi possível carregar o perfil.');
    }
  }

  Future<void> _selecionarFoto() async {
    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) return;

    try {
      final arquivo = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (arquivo == null) return;

      setState(() => _carregando = true);

      final bytes = await arquivo.readAsBytes();
      final extensao = arquivo.name.toLowerCase();

      final tipo = extensao.endsWith('.png')
          ? 'image/png'
          : 'image/jpeg';

      final caminho =
          '${usuario.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.${extensao.endsWith('.png') ? 'png' : 'jpg'}';

      await Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(
            caminho,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              contentType: tipo,
            ),
          );

      final url = Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(caminho);

      await Supabase.instance.client
          .from('perfis')
          .upsert({
        'id': usuario.id,
        'foto_url': url,
      });

      if (!mounted) return;

      setState(() {
        _fotoUrl = url;
      });

      _mensagem('Avatar atualizado!');
    } catch (e) {
      _mensagem('Erro ao enviar foto. Verifique o Storage.');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _salvarPerfil() async {
    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) return;

    final nome = _nomeController.text.trim();

    if (nome.isEmpty) {
      _mensagem('Digite seu nome.');
      return;
    }

    setState(() => _carregando = true);

    try {
      await Supabase.instance.client
          .from('perfis')
          .upsert({
        'id': usuario.id,
        'nome': nome,
        'foto_url': _fotoUrl,
      });

      _mensagem('Perfil atualizado com sucesso!');
    } catch (_) {
      _mensagem('Não foi possível salvar o perfil.');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEU PERFIL'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 20),

            GestureDetector(
              onTap: _carregando ? null : _selecionarFoto,
              child: CircleAvatar(
                radius: 65,
                backgroundColor: DominionColors.dourado,
                backgroundImage: _fotoUrl != null
                    ? NetworkImage(_fotoUrl!)
                    : null,
                child: _fotoUrl == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 70,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: _selecionarFoto,
              icon: const Icon(
                Icons.camera_alt,
                color: DominionColors.dourado,
              ),
              label: const Text(
                'ALTERAR AVATAR',
                style: TextStyle(
                  color: DominionColors.dourado,
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nome do perfil',
                prefixIcon: Icon(
                  Icons.person,
                  color: DominionColors.dourado,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    _carregando ? null : _salvarPerfil,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DominionColors.dourado,
                  foregroundColor: Colors.black,
                ),
                child: _carregando
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Text('SALVAR PERFIL'),
              ),
            ),

            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(
                Icons.card_giftcard,
                color: DominionColors.dourado,
              ),
              title: const Text('Presentes gratuitos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PresentesDominion(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: DominionColors.dourado,
              ),
              title: const Text('Painel administrativo'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PainelAdminDominion(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PRESENTES GRATUITOS
// ==========================================

class PresentesDominion extends StatelessWidget {
  const PresentesDominion({super.key});

  final List<Map<String, dynamic>> presentes = const [
    {'nome': 'Coração', 'icone': Icons.favorite},
    {'nome': 'Estrela', 'icone': Icons.star},
    {'nome': 'Rosa', 'icone': Icons.local_florist},
    {'nome': 'Coroa', 'icone': Icons.workspace_premium},
    {'nome': 'Diamante', 'icone': Icons.diamond},
    {'nome': 'Fogo', 'icone': Icons.local_fire_department},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRESENTES GRATUITOS'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: presentes.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final presente = presentes[index];

          return Container(
            decoration: BoxDecoration(
              color: DominionColors.painel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DominionColors.dourado,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  presente['icone'] as IconData,
                  color: DominionColors.dourado,
                  size: 48,
                ),
                const SizedBox(height: 10),
                Text(
                  presente['nome'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'GRÁTIS',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// PAINEL ADMINISTRATIVO PROTEGIDO
// ==========================================

class PainelAdminDominion extends StatelessWidget {
  const PainelAdminDominion({super.key});

  Future<bool> _verificarAdministrador() async {
    final usuario =
        Supabase.instance.client.auth.currentUser;

    if (usuario == null) return false;

    final perfil = await Supabase.instance.client
        .from('perfis')
        .select('role')
        .eq('id', usuario.id)
        .maybeSingle();

    return perfil?['role'] == 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAINEL ADMINISTRATIVO'),
      ),
      body: FutureBuilder<bool>(
        future: _verificarAdministrador(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: DominionColors.dourado,
              ),
            );
          }

          if (snapshot.hasError ||
              snapshot.data != true) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    color: Colors.redAccent,
                    size: 65,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'ACESSO RESTRITO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Você não possui permissão administrativa.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: DominionColors.dourado,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'BEM-VINDO, ADMINISTRADOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DominionColors.dourado,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Área administrativa do DOMÍNION LIVE.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
