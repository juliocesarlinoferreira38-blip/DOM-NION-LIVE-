
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// =====================================================
// DOMÍNION LIVE — PARTE 1 DE 7
// Configuração, dependências e identidade visual
// =====================================================

// Configure com os dados reais do seu projeto Supabase.
const String supabaseUrl =
    'https://xmmaemdayfwvxambhaiu.supabase.co';

const String supabasePublishableKey =
    'sb_publishable_hIyp9xdiQhUj1h_VnTsHZg_yMWDW9dc';

// =====================================================
// INICIALIZAÇÃO
// =====================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (supabasePublishableKey == 'COLE_AQUI_SUA_CHAVE_PUBLISHABLE' ||
      supabasePublishableKey.trim().isEmpty) {
    runApp(const ErroConfiguracaoDominion());
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabasePublishableKey,
    );

    runApp(const DominionLive());
  } catch (erro) {
    runApp(
      ErroInicializacaoDominion(
        mensagem: erro.toString(),
      ),
    );
  }
}

// =====================================================
// CORES OFICIAIS — PRETO, ROXO E DOURADO
// =====================================================

class DominionColors {
  static const Color fundo = Color(0xFF08060B);
  static const Color painel = Color(0xFF171020);
  static const Color roxo = Color(0xFF6A1B9A);
  static const Color roxoClaro = Color(0xFF9C4DCC);
  static const Color dourado = Color(0xFFE5BC58);
  static const Color douradoClaro = Color(0xFFFFD700);
  static const Color branco = Color(0xFFFFFFFF);
  static const Color cinza = Color(0xFFBDB6C7);
  static const Color preto = Color(0xFF000000);
}

// =====================================================
// APLICATIVO PRINCIPAL
// A tela de login será definida na PARTE 2.
// =====================================================

class DominionLive extends StatelessWidget {
  const DominionLive({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOMÍNION LIVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DominionColors.fundo,
        primaryColor: DominionColors.roxo,
        colorScheme: const ColorScheme.dark(
          primary: DominionColors.dourado,
          secondary: DominionColors.roxoClaro,
          surface: DominionColors.painel,
          error: Color(0xFFFF5252),
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
          labelStyle: const TextStyle(
            color: DominionColors.dourado,
          ),
          hintStyle: const TextStyle(
            color: DominionColors.cinza,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: DominionColors.roxo,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: DominionColors.roxo,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: DominionColors.dourado,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: const TelaInicialDominion(),
    );
  }
}

// =====================================================
// ERRO DE CONFIGURAÇÃO DO SUPABASE
// =====================================================

class ErroConfiguracaoDominion extends StatelessWidget {
  const ErroConfiguracaoDominion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DominionColors.fundo,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'DOMÍNION LIVE\n\n'
              'Configure a chave do Supabase '
              'antes de iniciar o aplicativo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: DominionColors.dourado,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// ERRO AO INICIAR A CONEXÃO
// =====================================================

class ErroInicializacaoDominion extends StatelessWidget {
  final String mensagem;

  const ErroInicializacaoDominion({
    super.key,
    required this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DominionColors.fundo,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off,
                  color: DominionColors.dourado,
                  size: 52,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Não foi possível iniciar o DOMÍNION LIVE.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DominionColors.branco,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DominionColors.cinza,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

 // =====================================================
// DOMÍNION LIVE — PARTE 2 DE 7
// LOGIN, CADASTRO E RECUPERAÇÃO DE SENHA
// =====================================================

class TelaInicialDominion extends StatefulWidget {
  const TelaInicialDominion({super.key});

  @override
  State<TelaInicialDominion> createState() =>
      _TelaInicialDominionState();
}

class _TelaInicialDominionState extends State<TelaInicialDominion> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _senhaController =
      TextEditingController();

  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  bool _modoCadastro = false;
  bool _carregando = false;
  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;

  String? _mensagem;
  bool _mensagemErro = false;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto, {bool erro = false}) {
    if (!mounted) return;

    setState(() {
      _mensagem = texto;
      _mensagemErro = erro;
    });
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || !email.contains('@')) {
      _mostrarMensagem(
        'Digite um endereço de e-mail válido.',
        erro: true,
      );
      return;
    }

    if (senha.length < 6) {
      _mostrarMensagem(
        'A senha precisa ter pelo menos 6 caracteres.',
        erro: true,
      );
      return;
    }

    if (_modoCadastro &&
        senha != _confirmarSenhaController.text) {
      _mostrarMensagem(
        'As senhas não são iguais.',
        erro: true,
      );
      return;
    }

    setState(() {
      _carregando = true;
      _mensagem = null;
    });

    try {
      if (_modoCadastro) {
        final resposta = await _supabase.auth.signUp(
          email: email,
          password: senha,
        );

        if (!mounted) return;

        if (resposta.session != null) {
          _abrirTelaPrincipal();
        } else {
          _mostrarMensagem(
            'Cadastro iniciado! Confira seu e-mail para '
            'confirmar a conta e depois entre no aplicativo.',
          );
        }
      } else {
        await _supabase.auth.signInWithPassword(
          email: email,
          password: senha,
        );

        if (!mounted) return;
        _abrirTelaPrincipal();
      }
    } on AuthException catch (erro) {
      _mostrarMensagem(
        _traduzirErro(erro.message),
        erro: true,
      );
    } catch (erro) {
      _mostrarMensagem(
        'Não foi possível concluir a operação. '
        'Confira sua internet e tente novamente.',
        erro: true,
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  String _traduzirErro(String mensagem) {
    final texto = mensagem.toLowerCase();

    if (texto.contains('invalid login credentials')) {
      return 'E-mail ou senha incorretos.';
    }

    if (texto.contains('email not confirmed')) {
      return 'Confirme seu e-mail antes de entrar.';
    }

    if (texto.contains('user already registered')) {
      return 'Este e-mail já possui uma conta.';
    }

    if (texto.contains('password should be at least')) {
      return 'A senha precisa ter pelo menos 6 caracteres.';
    }

    if (texto.contains('rate limit')) {
      return 'Muitas tentativas. Aguarde um pouco.';
    }

    return mensagem;
  }

  void _abrirTelaPrincipal() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const TelaPrincipalDominion(),
      ),
    );
  }

  Future<void> _recuperarSenha() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _mostrarMensagem(
        'Digite seu e-mail no campo acima para recuperar a senha.',
        erro: true,
      );
      return;
    }

    setState(() {
      _carregando = true;
      _mensagem = null;
    });

    try {
      await _supabase.auth.resetPasswordForEmail(email);

      _mostrarMensagem(
        'Se o e-mail estiver cadastrado, você receberá '
        'as instruções para redefinir sua senha.',
      );
    } on AuthException catch (erro) {
      _mostrarMensagem(
        _traduzirErro(erro.message),
        erro: true,
      );
    } catch (_) {
      _mostrarMensagem(
        'Não foi possível solicitar a recuperação. '
        'Tente novamente.',
        erro: true,
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Widget _campo({
    required TextEditingController controller,
    required String rotulo,
    required IconData icone,
    bool senha = false,
    bool mostrar = false,
    VoidCallback? alternar,
  }) {
    return TextField(
      controller: controller,
      enabled: !_carregando,
      obscureText: senha && !mostrar,
      keyboardType: rotulo == 'E-mail'
          ? TextInputType.emailAddress
          : TextInputType.text,
      autocorrect: false,
      enableSuggestions: !senha,
      style: const TextStyle(
        color: DominionColors.branco,
      ),
      decoration: InputDecoration(
        labelText: rotulo,
        prefixIcon: Icon(
          icone,
          color: DominionColors.dourado,
        ),
        suffixIcon: senha
            ? IconButton(
                onPressed: alternar,
                icon: Icon(
                  mostrar
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: DominionColors.dourado,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DominionColors.fundo,
              DominionColors.painel,
              DominionColors.fundo,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 440,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: DominionColors.painel,
                        border: Border.all(
                          color: DominionColors.dourado,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x556A1B9A),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 58,
                        color: DominionColors.dourado,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'DOMÍNION LIVE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: DominionColors.dourado,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SUA VOZ. SUA FAMÍLIA. SEU IMPÉRIO!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: DominionColors.branco,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _modoCadastro
                          ? 'CRIE SUA CONTA'
                          : 'BEM-VINDO DE VOLTA',
                      style: const TextStyle(
                        color: DominionColors.dourado,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _campo(
                      controller: _emailController,
                      rotulo: 'E-mail',
                      icone: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    _campo(
                      controller: _senhaController,
                      rotulo: 'Senha',
                      icone: Icons.lock_outline,
                      senha: true,
                      mostrar: _mostrarSenha,
                      alternar: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                    ),
                    if (_modoCadastro) ...[
                      const SizedBox(height: 16),
                      _campo(
                        controller: _confirmarSenhaController,
                        rotulo: 'Confirmar senha',
                        icone: Icons.lock_reset,
                        senha: true,
                        mostrar: _mostrarConfirmacao,
                        alternar: () {
                          setState(() {
                            _mostrarConfirmacao =
                                !_mostrarConfirmacao;
                          });
                        },
                      ),
                    ],
                    if (!_modoCadastro)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _carregando
                              ? null
                              : _recuperarSenha,
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(
                              color: DominionColors.dourado,
                            ),
                          ),
                        ),
                      ),
                    if (_mensagem != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _mensagemErro
                              ? const Color(0x332F1111)
                              : const Color(0x332A6B36),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _mensagemErro
                                ? Colors.redAccent
                                : Colors.greenAccent,
                          ),
                        ),
                        child: Text(
                          _mensagem!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _mensagemErro
                                ? Colors.redAccent
                                : Colors.greenAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _entrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DominionColors.dourado,
                          foregroundColor: DominionColors.preto,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: DominionColors.preto,
                                ),
                              )
                            : Text(
                                _modoCadastro
                                    ? 'CRIAR MINHA CONTA'
                                    : 'ENTRAR NO DOMÍNION',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _carregando
                          ? null
                          : () {
                              setState(() {
                                _modoCadastro = !_modoCadastro;
                                _mensagem = null;
                                _mensagemErro = false;
                              });
                            },
                      child: Text(
                        _modoCadastro
                            ? 'Já tenho conta — entrar'
                            : 'Ainda não tenho conta — cadastrar',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: DominionColors.branco,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'AG. DOMÍNION ALFA',
                      style: TextStyle(
                        color: DominionColors.dourado,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

 // =====================================================
// DOMÍNION LIVE — PARTE 3 DE 7
// TELA PRINCIPAL E NAVEGAÇÃO
// =====================================================

class TelaPrincipalDominion extends StatefulWidget {
  const TelaPrincipalDominion({super.key});

  @override
  State<TelaPrincipalDominion> createState() =>
      _TelaPrincipalDominionState();
}

class _TelaPrincipalDominionState
    extends State<TelaPrincipalDominion> {
  int _indiceSelecionado = 0;
  bool _carregandoPerfil = true;

  String _nomeUsuario = 'Guerreiro DOMÍNION';
  String? _fotoUsuario;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final usuario = _supabase.auth.currentUser;

    if (usuario == null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const TelaInicialDominion(),
          ),
        );
      }
      return;
    }

    try {
      final dados = await _supabase
          .from('perfis')
          .select('nome, foto_url')
          .eq('id', usuario.id)
          .maybeSingle();

      if (!mounted) return;

      if (dados != null) {
        final nome = dados['nome'] as String?;
        final foto = dados['foto_url'] as String?;

        setState(() {
          if (nome != null && nome.trim().isNotEmpty) {
            _nomeUsuario = nome.trim();
          }

          _fotoUsuario = foto;
        });
      }
    } catch (_) {
      // A tela continua funcionando mesmo se o perfil
      // ainda não existir na tabela "perfis".
    } finally {
      if (mounted) {
        setState(() => _carregandoPerfil = false);
      }
    }
  }

  Future<void> _sair() async {
    try {
      await _supabase.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => const TelaInicialDominion(),
        ),
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível sair da conta.'),
        ),
      );
    }
  }

  Future<void> _abrirPerfil() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PerfilDominion(),
      ),
    );

    if (mounted) {
      _carregarPerfil();
    }
  }

  void _abrirCriarSala() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CriarSalaDominion(),
      ),
    );
  }

  void _abrirSalas() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ListaSalasDominion(),
      ),
    );
  }

  void _abrirSalaDeVideos() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SalaVideosDominion(),
      ),
    );
  }

  void _abrirPresentes() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PresentesDominion(),
      ),
    );
  }

  Widget _botaoPrincipal({
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoTocar,
    Color cor = DominionColors.dourado,
  }) {
    return Card(
      color: DominionColors.painel,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: cor.withOpacity(0.55),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icone,
                  color: cor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        color: DominionColors.branco,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descricao,
                      style: const TextStyle(
                        color: DominionColors.cinza,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
      ),
    );
  }

  Widget _inicio() {
    return RefreshIndicator(
      color: DominionColors.dourado,
      backgroundColor: DominionColors.painel,
      onRefresh: _carregarPerfil,
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  DominionColors.painel,
                  DominionColors.roxo,
                  DominionColors.fundo,
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: DominionColors.dourado.withOpacity(0.65),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: DominionColors.dourado,
                  backgroundImage:
                      _fotoUsuario != null &&
                              _fotoUsuario!.isNotEmpty
                          ? NetworkImage(_fotoUsuario!)
                          : null,
                  child: _fotoUsuario == null ||
                          _fotoUsuario!.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: DominionColors.preto,
                          size: 42,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  _carregandoPerfil
                      ? 'Carregando perfil...'
                      : 'BEM-VINDO, $_nomeUsuario',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DominionColors.dourado,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'SUA VOZ. SUA FAMÍLIA. SEU IMPÉRIO!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DominionColors.branco,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _abrirPerfil,
                  icon: const Icon(Icons.edit),
                  label: const Text('MEU PERFIL'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DominionColors.dourado,
                    side: const BorderSide(
                      color: DominionColors.dourado,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'SEU IMPÉRIO COMEÇA AQUI',
            style: TextStyle(
              color: DominionColors.dourado,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          _botaoPrincipal(
            icone: Icons.headset_mic,
            titulo: 'Salas ao vivo',
            descricao: 'Entre nas salas e converse com a família.',
            aoTocar: _abrirSalas,
            cor: DominionColors.roxoClaro,
          ),
          _botaoPrincipal(
            icone: Icons.play_circle_fill,
            titulo: 'Sala de vídeos',
            descricao:
                'Assista aos vídeos disponíveis, sem gravar nem produzir.',
            aoTocar: _abrirSalaDeVideos,
          ),
          _botaoPrincipal(
            icone: Icons.add_circle,
            titulo: 'Criar sala ao vivo',
            descricao: 'Abra sua própria sala de conversa.',
            aoTocar: _abrirCriarSala,
          ),
          _botaoPrincipal(
            icone: Icons.card_giftcard,
            titulo: 'Presentes gratuitos',
            descricao: 'Acesse a área de presentes da comunidade.',
            aoTocar: _abrirPresentes,
            cor: DominionColors.roxoClaro,
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'AG. DOMÍNION ALFA',
              style: TextStyle(
                color: DominionColors.dourado,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paginas = <Widget>[
      _inicio(),
       ListaSalasDominion(),
       CriarSalaDominion(),
       SalaVideosDominion(),
       PerfilDominion(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DOMÍNION LIVE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Sair da conta',
            onPressed: _sair,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(
        index: _indiceSelecionado,
        children: paginas,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: DominionColors.painel,
        indicatorColor: DominionColors.roxo.withOpacity(0.55),
        selectedIndex: _indiceSelecionado,
        onDestinationSelected: (indice) {
          setState(() => _indiceSelecionado = indice);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.headset_mic_outlined),
            selectedIcon: Icon(Icons.headset_mic),
            label: 'Salas',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Criar',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle_fill),
            label: 'Vídeos',
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

class SalaVideoDominion extends StatefulWidget {
  const SalaVideoDominion({super.key});

  @override
  State<SalaVideoDominion> createState() =>
      _SalaVideoDominionState();
}

class _SalaVideoDominionState extends State<SalaVideoDominion> {
  final TextEditingController _videoController =
      TextEditingController();

  String? _videoUrl;

  static const Color roxo = Color(0xFF6A1B9A);
  static const Color dourado = Color(0xFFE5BC58);
  static const Color fundo = Color(0xFF08060B);
  static const Color painel = Color(0xFF171020);

  void _abrirVideo() {
    final url = _videoController.text.trim();

    final uri = Uri.tryParse(url);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um link de vídeo válido.'),
        ),
      );
      return;
    }

    setState(() {
      _videoUrl = url;
    });

    FocusScope.of(context).unfocus();
  }

  void _copiarLink() {
    if (_videoUrl == null) return;

    Clipboard.setData(ClipboardData(text: _videoUrl!));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copiado!'),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: painel,
        foregroundColor: dourado,
        title: const Text(
          'SALA DE VÍDEO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: painel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: roxo,
                  width: 1.5,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.ondemand_video,
                    color: dourado,
                    size: 58,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'CINEMA DOMÍNION',
                    style: TextStyle(
                      color: dourado,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Escolha um vídeo e reúna sua família '
                    'para assistir.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'LINK DO VÍDEO',
              style: TextStyle(
                color: dourado,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _videoController,
              keyboardType: TextInputType.url,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'https://...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                filled: true,
                fillColor: painel,
                prefixIcon: const Icon(
                  Icons.link,
                  color: dourado,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: roxo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _abrirVideo,
                icon: const Icon(Icons.play_circle_fill),
                label: const Text(
                  'CARREGAR VÍDEO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: roxo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              constraints: const BoxConstraints(
                minHeight: 180,
              ),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: painel,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white12,
                ),
              ),
              child: _videoUrl == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.smart_display,
                          color: Colors.white38,
                          size: 54,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Nenhum vídeo selecionado',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Cole um link acima para continuar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: dourado,
                          size: 42,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'LINK DO VÍDEO CARREGADO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: dourado,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SelectableText(
                          _videoUrl!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _copiarLink,
                          icon: const Icon(Icons.copy),
                          label: const Text('COPIAR LINK'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: dourado,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 18),
            const Text(
              'DOMÍNION LIVE • SUA VOZ. SUA FAMÍLIA. '
              'SEU IMPÉRIO!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dourado,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoDominion {
  final String titulo;
  final String descricao;
  final String url;
  final String categoria;

  const VideoDominion({
    required this.titulo,
    required this.descricao,
    required this.url,
    required this.categoria,
  });
}

class CatalogoVideoDominion extends StatefulWidget {
  const CatalogoVideoDominion({super.key});

  @override
  State<CatalogoVideoDominion> createState() =>
      _CatalogoVideoDominionState();
}

class _CatalogoVideoDominionState
    extends State<CatalogoVideoDominion> {
  static const Color roxo = Color(0xFF6A1B9A);
  static const Color dourado = Color(0xFFE5BC58);
  static const Color fundo = Color(0xFF08060B);
  static const Color painel = Color(0xFF171020);

  final List<VideoDominion> videos = [];
  final TextEditingController tituloController =
      TextEditingController();
  final TextEditingController descricaoController =
      TextEditingController();
  final TextEditingController urlController =
      TextEditingController();

  String categoriaSelecionada = 'Todos';

  final List<String> categorias = const [
    'Todos',
    'Música',
    'Família',
    'Entretenimento',
    'Outros',
  ];

  List<VideoDominion> get videosFiltrados {
    if (categoriaSelecionada == 'Todos') {
      return videos;
    }

    return videos
        .where((video) =>
            video.categoria == categoriaSelecionada)
        .toList();
  }

  void adicionarVideo() {
    final titulo = tituloController.text.trim();
    final descricao = descricaoController.text.trim();
    final url = urlController.text.trim();
    final uri = Uri.tryParse(url);

    if (titulo.isEmpty ||
        uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe um título e um link válido.',
          ),
        ),
      );
      return;
    }

    setState(() {
      videos.insert(
        0,
        VideoDominion(
          titulo: titulo,
          descricao: descricao,
          url: url,
          categoria: categoriaSelecionada == 'Todos'
              ? 'Outros'
              : categoriaSelecionada,
        ),
      );

      tituloController.clear();
      descricaoController.clear();
      urlController.clear();
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vídeo adicionado ao catálogo!'),
      ),
    );
  }

  void mostrarFormulario() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: painel,
          title: const Text(
            'Adicionar vídeo',
            style: TextStyle(color: dourado),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                campo(
                  controller: tituloController,
                  texto: 'Título do vídeo',
                ),
                const SizedBox(height: 12),
                campo(
                  controller: descricaoController,
                  texto: 'Descrição',
                ),
                const SizedBox(height: 12),
                campo(
                  controller: urlController,
                  texto: 'Link HTTP ou HTTPS',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: adicionarVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: roxo,
                foregroundColor: Colors.white,
              ),
              child: const Text('ADICIONAR'),
            ),
          ],
        );
      },
    );
  }

  Widget campo({
    required TextEditingController controller,
    required String texto,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: texto,
        labelStyle: const TextStyle(color: dourado),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: roxo),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: dourado),
        ),
      ),
    );
  }

  void abrirVideo(VideoDominion video) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: painel,
          title: Text(
            video.titulo,
            style: const TextStyle(color: dourado),
          ),
          content: SelectableText(
            '${video.descricao.isEmpty ? "Vídeo da família DOMÍNION." : video.descricao}\n\n'
            'Link para assistir:\n${video.url}',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SalaVideoDominion(),
                  ),
                );
              },
              child: const Text(
                'ABRIR SALA DE VÍDEO',
                style: TextStyle(color: dourado),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext),
              child: const Text(
                'FECHAR',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    tituloController.dispose();
    descricaoController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: painel,
        foregroundColor: dourado,
        title: const Text(
          'VÍDEOS DOMÍNION',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: mostrarFormulario,
            tooltip: 'Adicionar vídeo',
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mostrarFormulario,
        backgroundColor: roxo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 58,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              children: categorias.map((categoria) {
                final selecionada =
                    categoriaSelecionada == categoria;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(categoria),
                    selected: selecionada,
                    onSelected: (_) {
                      setState(() {
                        categoriaSelecionada = categoria;
                      });
                    },
                    selectedColor: roxo,
                    backgroundColor: painel,
                    labelStyle: TextStyle(
                      color: selecionada
                          ? Colors.white
                          : dourado,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: videosFiltrados.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.video_library_outlined,
                            color: dourado,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'CATÁLOGO VAZIO',
                            style: TextStyle(
                              color: dourado,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Toque no botão + para adicionar '
                            'um vídeo.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: videosFiltrados.length,
                    itemBuilder: (context, index) {
                      final video = videosFiltrados[index];

                      return Card(
                        color: painel,
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                          side: const BorderSide(
                            color: roxo,
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(14),
                          leading: const CircleAvatar(
                            backgroundColor: roxo,
                            child: Icon(
                              Icons.play_arrow,
                              color: dourado,
                            ),
                          ),
                          title: Text(
                            video.titulo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(top: 6),
                            child: Text(
                              '${video.categoria}\n${video.descricao}',
                              style: const TextStyle(
                                color: Colors.white60,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: dourado,
                            size: 18,
                          ),
                          onTap: () => abrirVideo(video),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ParticipanteVideoDominion {
  final String nome;
  final DateTime entrouEm;

  ParticipanteVideoDominion({
    required this.nome,
    DateTime? entrouEm,
  }) : entrouEm = entrouEm ?? DateTime.now();
}

class MensagemVideoDominion {
  final String autor;
  final String texto;
  final DateTime enviadaEm;

  MensagemVideoDominion({
    required this.autor,
    required this.texto,
    DateTime? enviadaEm,
  }) : enviadaEm = enviadaEm ?? DateTime.now();
}

class DetalheSalaVideoDominion extends StatefulWidget {
  final String nomeSala;
  final String nomeUsuario;
  final String? videoUrl;

  const DetalheSalaVideoDominion({
    super.key,
    this.nomeSala = 'CINEMA DOMÍNION',
    this.nomeUsuario = 'Visitante',
    this.videoUrl,
  });

  @override
  State<DetalheSalaVideoDominion> createState() =>
      _DetalheSalaVideoDominionState();
}

class _DetalheSalaVideoDominionState
    extends State<DetalheSalaVideoDominion> {
  static const Color roxo = Color(0xFF6A1B9A);
  static const Color dourado = Color(0xFFE5BC58);
  static const Color fundo = Color(0xFF08060B);
  static const Color painel = Color(0xFF171020);

  final TextEditingController mensagemController =
      TextEditingController();

  final List<ParticipanteVideoDominion> participantes = [];
  final List<MensagemVideoDominion> mensagens = [];

  bool entrouNaSala = false;

  @override
  void initState() {
    super.initState();

    participantes.add(
      ParticipanteVideoDominion(
        nome: widget.nomeUsuario,
      ),
    );

    entrouNaSala = true;

    mensagens.add(
      MensagemVideoDominion(
        autor: 'DOMÍNION',
        texto: 'Bem-vindo à ${widget.nomeSala}!',
      ),
    );
  }

  void enviarMensagem() {
    final texto = mensagemController.text.trim();

    if (texto.isEmpty || !entrouNaSala) return;

    setState(() {
      mensagens.add(
        MensagemVideoDominion(
          autor: widget.nomeUsuario,
          texto: texto,
        ),
      );

      mensagemController.clear();
    });
  }

  void sairDaSala() {
    setState(() {
      entrouNaSala = false;
      participantes.removeWhere(
        (p) => p.nome == widget.nomeUsuario,
      );
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    mensagemController.dispose();
    super.dispose();
  }

  Widget tituloSecao(String texto, IconData icone) {
    return Row(
      children: [
        Icon(icone, color: dourado),
        const SizedBox(width: 8),
        Text(
          texto,
          style: const TextStyle(
            color: dourado,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: painel,
        foregroundColor: dourado,
        title: Text(widget.nomeSala),
        actions: [
          IconButton(
            tooltip: 'Sair da sala',
            onPressed: sairDaSala,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: painel,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: roxo),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.movie_creation_outlined,
                          size: 54,
                          color: dourado,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.nomeSala,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: dourado,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entrouNaSala
                              ? 'Você está nesta sala.'
                              : 'Você saiu da sala.',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        if (widget.videoUrl != null) ...[
                          const SizedBox(height: 12),
                          SelectableText(
                            widget.videoUrl!,
                            style: const TextStyle(
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  tituloSecao(
                    'PARTICIPANTES',
                    Icons.people_outline,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: painel,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: participantes.isEmpty
                        ? const Text(
                            'Nenhum participante na sala.',
                            style: TextStyle(
                              color: Colors.white60,
                            ),
                          )
                        : Column(
                            children: participantes.map((p) {
                              return ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: roxo,
                                  child: Icon(
                                    Icons.person,
                                    color: dourado,
                                  ),
                                ),
                                title: Text(
                                  p.nome,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: const Text(
                                  'Participante',
                                  style: TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 24),
                  tituloSecao(
                    'CHAT DA SALA',
                    Icons.chat_bubble_outline,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: painel,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: mensagens.isEmpty
                        ? const Text(
                            'Envie a primeira mensagem!',
                            style: TextStyle(
                              color: Colors.white60,
                            ),
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: mensagens.map((m) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 7,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${m.autor}: ',
                                        style: const TextStyle(
                                          color: dourado,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: m.texto,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
            if (entrouNaSala)
              Container(
                padding: const EdgeInsets.all(12),
                color: painel,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: mensagemController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Digite sua mensagem...',
                          hintStyle: const TextStyle(
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: fundo,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(24),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(24),
                            borderSide: const BorderSide(
                              color: roxo,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => enviarMensagem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: enviarMensagem,
                      style: IconButton.styleFrom(
                        backgroundColor: roxo,
                      ),
                      icon: const Icon(
                        Icons.send,
                        color: dourado,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InicioVideoDominion extends StatelessWidget {
  const InicioVideoDominion({super.key});

  static const Color roxo = Color(0xFF6A1B9A);
  static const Color dourado = Color(0xFFE5BC58);
  static const Color fundo = Color(0xFF08060B);
  static const Color painel = Color(0xFF171020);

  Widget criarCard({
    required BuildContext context,
    required IconData icone,
    required String titulo,
    required String descricao,
    required VoidCallback aoTocar,
  }) {
    return Card(
      color: painel,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: roxo),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: roxo,
          child: Icon(
            icone,
            color: dourado,
            size: 28,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            color: dourado,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            descricao,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: dourado,
          size: 17,
        ),
        onTap: aoTocar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: painel,
        foregroundColor: dourado,
        title: const Text(
          'DOMÍNION LIVE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 28,
                horizontal: 18,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF171020),
                    Color(0xFF321044),
                    Color(0xFF08060B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: dourado,
                  width: 1.3,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.castle,
                    color: dourado,
                    size: 58,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'DOMÍNION LIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dourado,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'SUA VOZ. SUA FAMÍLIA. SEU IMPÉRIO!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'CENTRAL DE VÍDEOS',
              style: TextStyle(
                color: dourado,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            criarCard(
              context: context,
              icone: Icons.video_library,
              titulo: 'Catálogo de vídeos',
              descricao:
                  'Consulte e organize seus vídeos.',
              aoTocar: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const CatalogoVideoDominion(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            criarCard(
              context: context,
              icone: Icons.movie_filter,
              titulo: 'Sala de vídeo',
              descricao:
                  'Entre na área para assistir a vídeos.',
              aoTocar: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const SalaVideoDominion(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            criarCard(
              context: context,
              icone: Icons.people_alt,
              titulo: 'Sala com participantes',
              descricao:
                  'Consulte participantes e chat local.',
              aoTocar: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const DetalheSalaVideoDominion(),
                  ),
                );
              },
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: painel,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'DOMÍNION ALFA\n'
                'Uma família. Uma aliança. Um império.\n\n'
                'Esta área é dedicada a assistir a vídeos. '
                'Não utiliza câmera nem transmissão de vídeo ao vivo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
