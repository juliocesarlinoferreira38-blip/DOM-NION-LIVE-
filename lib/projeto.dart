import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color dlPreto = Color(0xFF08060B);
const Color dlPainel = Color(0xFF171020);
const Color dlRoxo = Color(0xFF6A1B9A);
const Color dlDourado = Color(0xFFE5BC58);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'SUA_URL_AQUI',
    anonKey: 'SUA_ANON_KEY_AQUI',
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProjetoDominion(),
  ));
}

class ProjetoDominion extends StatefulWidget {
  const ProjetoDominion({super.key});
  @override
  State<ProjetoDominion> createState() => _ProjetoDominionState();
}

class _ProjetoDominionState extends State<ProjetoDominion> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _modoCadastro = false;
  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;
  bool _carregando = false;
  String? _mensagem;
  bool _mensagemErro = false;

  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto, {bool erro = false}) {
    if (!mounted) return;
    setState(() {
      _mensagem = texto;
      _mensagemErro = erro;
    });
  }

  Future<void> _autenticar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _carregando = true;
      _mensagem = null;
    });
    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text;
      if (_modoCadastro) {
        final resposta = await _supabase.auth.signUp(email: email, password: senha);
        if (!mounted) return;
        if (resposta.session != null) {
          _abrirInicio();
        } else {
          _mostrarMensagem('Cadastro recebido! Confirme seu e-mail antes de entrar.');
        }
      } else {
        await _supabase.auth.signInWithPassword(email: email, password: senha);
        if (!mounted) return;
        _abrirInicio();
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      _mostrarMensagem(_traduzirErro(e.message), erro: true);
    } catch (_) {
      if (!mounted) return;
      _mostrarMensagem('Não foi possível conectar. Confira sua internet e tente novamente.', erro: true);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  String _traduzirErro(String erro) {
    final texto = erro.toLowerCase();
    if (texto.contains('invalid login credentials')) return 'E-mail ou senha incorretos.';
    if (texto.contains('user already registered')) return 'Este e-mail já possui cadastro. Tente entrar.';
    if (texto.contains('password should be at least')) return 'A senha não atende ao tamanho mínimo exigido.';
    if (texto.contains('email not confirmed')) return 'Confirme seu e-mail antes de entrar.';
    if (texto.contains('invalid email')) return 'Digite um endereço de e-mail válido.';
    if (texto.contains('rate limit')) return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
    return 'Não foi possível concluir a operação. Verifique os dados e a configuração do Supabase.';
  }

  void _abrirInicio() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const InicioDominionPage()),
    );
  }

  void _alternarModo() {
    setState(() {
      _modoCadastro = !_modoCadastro;
      _mensagem = null;
      _formKey.currentState?.reset();
      _senhaController.clear();
      _confirmarController.clear();
    });
  }

  InputDecoration _decoracao(String label, IconData icon, {Widget? sufixo}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: dlDourado),
      suffixIcon: sufixo,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: dlRoxo.withValues(alpha: 0.6))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: dlDourado)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dlPreto,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 106, height: 106,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: dlPainel,
                      border: Border.all(color: dlDourado, width: 2),
                      boxShadow: [BoxShadow(color: dlRoxo.withValues(alpha: 0.65), blurRadius: 28, spreadRadius: 3)],
                    ),
                    child: const Icon(Icons.sports_esports, size: 58, color: dlDourado),
                  ),
                  const SizedBox(height: 22),
                  const Text('DOMÍNION LIVE', textAlign: TextAlign.center, style: TextStyle(color: dlDourado, fontSize: 29, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  const Text('SUA VOZ. SUA FAMÍLIA. SEU IMPÉRIO.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(color: dlPainel, borderRadius: BorderRadius.circular(24), border: Border.all(color: dlRoxo.withValues(alpha: 0.7))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(_modoCadastro ? 'CRIAR CONTA' : 'BEM-VINDO DE VOLTA', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(_modoCadastro ? 'Faça parte da nossa família.' : 'Entre no seu império.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60)),
                          const SizedBox(height: 25),
                          TextFormField(
                            controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next,
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoracao('E-mail', Icons.email_outlined),
                            validator: (valor) {
                              final email = valor?.trim() ?? '';
                              if (email.isEmpty) return 'Digite seu e-mail.';
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) return 'Digite um e-mail válido.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _senhaController, obscureText: !_mostrarSenha,
                            textInputAction: _modoCadastro ? TextInputAction.next : TextInputAction.done,
                            onFieldSubmitted: (_) { if (!_modoCadastro && !_carregando) _autenticar(); },
                            style: const TextStyle(color: Colors.white),
                            decoration: _decoracao('Senha', Icons.lock_outline, sufixo: IconButton(onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha), icon: Icon(_mostrarSenha ? Icons.visibility_off : Icons.visibility, color: dlDourado))),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) return 'Digite sua senha.';
                              if (_modoCadastro && valor.length < 6) return 'Use pelo menos 6 caracteres.';
                              return null;
                            },
                          ),
                          if (_modoCadastro) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmarController, obscureText: !_mostrarConfirmacao, textInputAction: TextInputAction.done,
                              style: const TextStyle(color: Colors.white),
                              decoration: _decoracao('Confirmar senha', Icons.lock_reset, sufixo: IconButton(onPressed: () => setState(() => _mostrarConfirmacao = !_mostrarConfirmacao), icon: Icon(_mostrarConfirmacao ? Icons.visibility_off : Icons.visibility, color: dlDourado))),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) return 'Confirme sua senha.';
                                if (valor != _senhaController.text) return 'As senhas não coincidem.';
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: dlDourado, foregroundColor: dlPreto, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                              onPressed: _carregando ? null : _autenticar,
                              child: _carregando ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: dlPreto)) : Text(_modoCadastro ? 'CRIAR CONTA' : 'ENTRAR', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          if (_mensagem != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: _mensagemErro ? Colors.red.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: _mensagemErro ? Colors.red : Colors.green)),
                              child: Text(_mensagem!, textAlign: TextAlign.center, style: TextStyle(color: _mensagemErro ? Colors.red[200] : Colors.green[200])),
                            ),
                          ],
                          const SizedBox(height: 18),
                          TextButton(onPressed: _alternarModo, child: Text(_modoCadastro ? 'Já tem conta? Entrar' : 'Ainda não tem conta? Criar conta', style: const TextStyle(color: dlDourado))),
                        ],
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

// ================= INÍCIO - SÓ SALAS DE ÁUDIO, SEM VÍDEO, SEM CHAMADA =================

class InicioDominionPage extends StatelessWidget {
  const InicioDominionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dlPreto,
      appBar: AppBar(
        backgroundColor: dlPreto,
        title: const Text('DOMÍNION LIVE', style: TextStyle(color: dlDourado, fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const ProjetoDominion()), (route) => false);
              }
            },
            icon: const Icon(Icons.logout, color: dlDourado),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Escolha sua sala', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Só voz. Sem live de vídeo, sem chamada.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 16),
          _cardSala(context, titulo: 'SALA NORMAL', subtitulo: 'Sala do Alfa & Amor • 10 lugares • Só voz', icone: Icons.mic_rounded, cor: dlDourado, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaNormalPage()))),
          _cardSala(context, titulo: 'SALA DE VÍDEO / YOUTUBE', subtitulo: 'Pra todos • Assistir junto • Sem aparecer • Só voz e chat', icone: Icons.play_circle_fill_rounded, cor: Colors.redAccent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaVideoYoutubePage()))),
          _cardSala(context, titulo: 'SALA DE JOGOS', subtitulo: 'Pra todos • Jogar junto • Só voz • Sem chamada', icone: Icons.sports_esports_rounded, cor: Colors.purpleAccent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaJogosPage()))),
          _cardSala(context, titulo: 'SALA NORMAL 2', subtitulo: 'Sala aberta da família • Só voz', icone: Icons.groups_rounded, cor: Colors.greenAccent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaNormalPage(nomeInicial: 'Sala da Família')))),
        ],
      ),
    );
  }

  Widget _cardSala(BuildContext context, {required String titulo, required String subtitulo, required IconData icone, required Color cor, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: dlPainel, borderRadius: BorderRadius.circular(20), border: Border.all(color: cor.withValues(alpha: 0.6))),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: cor.withValues(alpha: 0.2), child: Icon(icone, color: cor)),
        title: Text(titulo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitulo, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      ),
    );
  }
}

// ================= SALA NORMAL - FOTO, NOME E PERFIL NO TOPO =================

class SalaNormalPage extends StatefulWidget {
  final String nomeInicial;
  const SalaNormalPage({super.key, this.nomeInicial = 'Sala do Alfa & Amor'});
  @override
  State<SalaNormalPage> createState() => _SalaNormalPageState();
}

class _SalaNormalPageState extends State<SalaNormalPage> {
  late String _nomeSala = widget.nomeInicial;
  bool _mutado = false;

  final List<Map<String, String>> _lugares = [
    {'nome': 'Luna', 'foto': 'L'}, {'nome': 'Theo', 'foto': 'T'},
    {'nome': 'Kira', 'foto': 'K'}, {'nome': 'Mateo', 'foto': 'M'},
    {'nome': 'Sofia', 'foto': 'S'}, {'nome': 'Jake', 'foto': 'J'},
    {'nome': 'Nina', 'foto': 'N'}, {'nome': 'Leo', 'foto': 'L'},
  ];

  void _editarNome() async {
    final controller = TextEditingController(text: _nomeSala);
    final novo = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dlPainel,
        title: const Text('Nome da sala', style: TextStyle(color: Colors.white)),
        content: TextField(controller: controller, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Digite o nome da sala', hintStyle: TextStyle(color: Colors.white54))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.white60))),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Salvar')),
        ],
      ),
    );
    if (novo != null && novo.isNotEmpty) setState(() => _nomeSala = novo);
  }

  void _trocarFotoSala() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aqui você conecta o image_picker para trocar a foto da sala')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dlPreto,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(18), border: Border.all(color: dlDourado)),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(radius: 31, backgroundColor: dlDourado, child: CircleAvatar(radius: 29, backgroundColor: dlRoxo, child: Icon(Icons.home_rounded, color: Colors.white, size: 30))),
                      Positioned(bottom: 0, right: 0, child: GestureDetector(onTap: _trocarFotoSala, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: dlDourado, shape: BoxShape.circle), child: const Icon(Icons.edit, size: 12, color: Colors.black)))),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [Expanded(child: Text(_nomeSala, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17), overflow: TextOverflow.ellipsis)), IconButton(onPressed: _editarNome, icon: const Icon(Icons.edit, size: 16, color: dlDourado), padding: EdgeInsets.zero, constraints: const BoxConstraints())]),
                      const Text('Hosted by • Alfa & Amor', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 6),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: dlDourado, borderRadius: BorderRadius.circular(20)), child: const Text('👑 DOMINION ▼', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold))),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abrir meu perfil'))),
                    child: const CircleAvatar(radius: 21, backgroundColor: dlRoxo, child: Icon(Icons.person, color: Colors.white)),
                  ),
                ],
              ),
            ),
            Container(margin: const EdgeInsets.symmetric(horizontal: 12), padding: const EdgeInsets.all(9), decoration: BoxDecoration(gradient: const LinearGradient(colors: [dlRoxo, Color(0xFFA855F7), dlDourado]), borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('✨ Bem-vindo(a) à sala DOMINION ✨', style: TextStyle(fontWeight: FontWeight.bold)))),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _host('👑 Alfa', 'HOST'),
              _host('❤️ Amor', 'HOST'),
            ]),
            const SizedBox(height: 18),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
                itemCount: _lugares.length,
                itemBuilder: (_, i) {
                  final p = _lugares[i];
                  return Column(children: [
                    CircleAvatar(radius: 31, backgroundColor: dlDourado, child: CircleAvatar(radius: 29, backgroundColor: dlPainel, child: Text(p['foto']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                    const SizedBox(height: 4),
                    Text('🎤 ${p['nome']}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: dlDourado.withValues(alpha: 0.5)))),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.card_giftcard, color: dlDourado, size: 28)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble, color: Colors.white, size: 26)),
                GestureDetector(
                  onTap: () => setState(() => _mutado = !_mutado),
                  child: Container(width: 58, height: 58, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [dlDourado, Color(0xFFB8860B)]), boxShadow: [BoxShadow(color: dlDourado.withValues(alpha: 0.6), blurRadius: 16)]), child: Icon(_mutado ? Icons.mic_off : Icons.mic, color: Colors.black, size: 28)),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white, size: 26)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _host(String nome, String cargo) {
    return Column(children: [
      Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dlDourado, width: 3), boxShadow: [BoxShadow(color: dlDourado.withValues(alpha: 0.5), blurRadius: 14)]), child: const CircleAvatar(radius: 50, backgroundColor: dlRoxo, child: Icon(Icons.person, size: 50, color: Colors.white))),
      const SizedBox(height: 6),
      Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      Text(cargo, style: const TextStyle(color: dlDourado, fontSize: 11)),
    ]);
  }
}

// ================= SALA DE VÍDEO / YOUTUBE - PRA TODOS, NORMAL =================

class SalaVideoYoutubePage extends StatelessWidget {
  const SalaVideoYoutubePage({super.key});

  @override
  Widget build(BuildContext context) {
    final salasPublicas = [
      {'nome': 'Sala de Vídeo 1 - YouTube da Família', 'assistindo': '1.2k assistindo', 'cor': Colors.redAccent},
      {'nome': 'Sala de Vídeo 2 - Clipes e Música', 'assistindo': '850 assistindo', 'cor': Colors.purpleAccent},
      {'nome': 'Sala de Vídeo 3 - Filmes Junto', 'assistindo': '430 assistindo', 'cor': Colors.orangeAccent},
      {'nome': 'Sala de Vídeo 4 - Aberta pra Todos', 'assistindo': '120 assistindo', 'cor': Colors.greenAccent},
    ];

    return Scaffold(
      backgroundColor: dlPreto,
      appBar: AppBar(backgroundColor: dlPreto, title: const Text('Sala de Vídeo / YouTube', style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Pra todos - é só entrar e assistir junto', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Sem live de vídeo facial. Sem chamada. Só assistir, voz e chat.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: dlDourado, foregroundColor: dlPreto),
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('CRIAR SALA DE VÍDEO PRA TODOS'),
            ),
          ),
          const SizedBox(height: 16),
          ...salasPublicas.map((sala) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: dlPainel, borderRadius: BorderRadius.circular(16), border: Border.all(color: (sala['cor'] as Color).withValues(alpha: 0.6))),
              child: ListTile(
                leading: Container(width: 60, height: 40, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.play_circle_fill, color: Colors.white)),
                title: Text(sala['nome'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${sala['assistindo']} • Aberta pra todos', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                trailing: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AssistirVideoJuntoPage())),
                  child: const Text('ENTRAR'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class AssistirVideoJuntoPage extends StatelessWidget {
  const AssistirVideoJuntoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dlPreto,
      appBar: AppBar(backgroundColor: dlPreto, title: const Text('Assistindo Junto - Pra Todos', style: TextStyle(color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Container(
            height: 210,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent)),
            child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 60),
              SizedBox(height: 8),
              Text('Vídeo do YouTube aqui', style: TextStyle(color: Colors.white)),
              Text('Todo mundo assiste junto', style: TextStyle(color: Colors.white60, fontSize: 12)),
            ])),
          ),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(hintText: 'Colar link do YouTube...', hintStyle: const TextStyle(color: Colors.white54), filled: true, fillColor: dlPainel, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: const Icon(Icons.link, color: dlDourado))),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: dlDourado, foregroundColor: dlPreto), onPressed: () {}, child: const Text('ASSISTIR JUNTO'))),
          const SizedBox(height: 16),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircleAvatar(backgroundColor: dlDourado, child: Text('A')),
            CircleAvatar(backgroundColor: dlRoxo, child: Text('M')),
            CircleAvatar(backgroundColor: dlPainel, child: Text('L')),
            CircleAvatar(backgroundColor: dlPainel, child: Text('T')),
          ]),
          const SizedBox(height: 8),
          const Text('Todos na voz • Sem aparecer em vídeo', style: TextStyle(color: Colors.white60, fontSize: 12)),
        ]),
      ),
    );
  }
}

// ================= SALA DE JOGOS - PRA TODOS, NORMAL =================

class SalaJogosPage extends StatelessWidget {
  const SalaJogosPage({super.key});
  @override
  Widget build(BuildContext context) {
    final jogos = [
      {'nome': '🎮 Free Fire', 'sub': 'Sala de voz do squad • Pra todos'},
      {'nome': '🎮 Roblox', 'sub': 'Jogar junto com a família • Pra todos'},
      {'nome': '🎮 Minecraft', 'sub': 'Mundo da família • Pra todos'},
      {'nome': '🎲 Uno / Truco', 'sub': 'Só voz e diversão • Pra todos'},
    ];
    return Scaffold(
      backgroundColor: dlPreto,
      appBar: AppBar(backgroundColor: dlPreto, title: const Text('Sala de Jogos', style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Pra todos - é só entrar e jogar junto', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Sem live de vídeo. Sem chamada. Só voz e jogo.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 16),
          ...jogos.map((j) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: dlPainel, borderRadius: BorderRadius.circular(16), border: Border.all(color: dlRoxo)),
                child: ListTile(
                  title: Text(j['nome']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(j['sub']!, style: const TextStyle(color: Colors.white60)),
                  trailing: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaNormalPage(nomeInicial: 'Sala de Jogos'))),
                    child: const Text('ENTRAR'),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}