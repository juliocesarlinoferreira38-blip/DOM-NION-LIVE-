
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// =====================================================
// DOMÍNION LIVE
// Login, cadastro, salas criadas e chat
// =====================================================

const String supabaseUrl =
    'https://xmmaemdayfwvxambhaiu.supabase.co';

// COLOQUE AQUI SUA CHAVE PUBLICÁVEL DO SUPABASE.
const String supabaseKey = 'sb_publishable_hIyp9xdiQhUj1h_VnTsHZg_yMWDW9dc';

const Color fundo = Color(0xFF08060B);
const Color painel = Color(0xFF171020);
const Color roxo = Color(0xFF6A1B9A);
const Color roxoClaro = Color(0xFF9C4DCC);
const Color dourado = Color(0xFFE5BC58);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (supabaseKey == 'COLE_AQUI_SUA_CHAVE_PUBLISHABLE' ||
      supabaseKey.trim().isEmpty) {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: fundo,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'DOMÍNION LIVE\n\n'
              'Configure a chave publicável do Supabase '
              'no arquivo main.dart.',
              textAlign: TextAlign.center,
              style: TextStyle(color: dourado, fontSize: 18),
            ),
          ),
        ),
      ),
    ));
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
    runApp(const DominionApp());
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: fundo,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Erro ao conectar ao Supabase:\n$e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: dourado),
            ),
          ),
        ),
      ),
    ));
  }
}

SupabaseClient get db => Supabase.instance.client;

// =====================================================
// APLICATIVO
// =====================================================

class DominionApp extends StatelessWidget {
  const DominionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOMÍNION LIVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fundo,
        colorScheme: const ColorScheme.dark(
          primary: dourado,
          secondary: roxoClaro,
          surface: painel,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          foregroundColor: dourado,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: painel,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: dourado),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// =====================================================
// LOGIN E CADASTRO
// =====================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmar = TextEditingController();

  bool cadastro = false;
  bool carregando = false;
  bool mostrarSenha = false;
  String? erro;

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    confirmar.dispose();
    super.dispose();
  }

  Future<void> enviar() async {
    final e = email.text.trim();
    final s = senha.text;

    if (!e.contains('@')) {
      setState(() => erro = 'Digite um e-mail válido.');
      return;
    }

    if (s.length < 6) {
      setState(() =>
          erro = 'A senha precisa ter pelo menos 6 caracteres.');
      return;
    }

    if (cadastro && s != confirmar.text) {
      setState(() => erro = 'As senhas não são iguais.');
      return;
    }

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      if (cadastro) {
        final resposta = await db.auth.signUp(
          email: e,
          password: s,
        );

        if (!mounted) return;

        if (resposta.session != null) {
          abrirSalas();
        } else {
          setState(() {
            erro = 'Cadastro criado! Confirme seu e-mail '
                'e depois entre no aplicativo.';
          });
        }
      } else {
        await db.auth.signInWithPassword(
          email: e,
          password: s,
        );

        if (mounted) abrirSalas();
      }
    } on AuthException catch (ex) {
      if (mounted) {
        setState(() => erro = ex.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() =>
            erro = 'Falha de conexão. Confira sua internet e a chave.');
      }
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  void abrirSalas() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const SalasPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const Icon(
                    Icons.castle,
                    size: 76,
                    color: dourado,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'DOMÍNION LIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dourado,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SUA VOZ. SUA FAMÍLIA. SEU IMPÉRIO!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    cadastro ? 'CRIAR CONTA' : 'ENTRAR',
                    style: const TextStyle(
                      color: dourado,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: senha,
                    obscureText: !mostrarSenha,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() =>
                              mostrarSenha = !mostrarSenha);
                        },
                        icon: Icon(
                          mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  if (cadastro) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmar,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar senha',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                  ],
                  if (erro != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      erro!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: roxo,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: carregando ? null : enviar,
                      child: carregando
                          ? const CircularProgressIndicator()
                          : Text(cadastro ? 'CADASTRAR' : 'ENTRAR'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        cadastro = !cadastro;
                        erro = null;
                      });
                    },
                    child: Text(
                      cadastro
                          ? 'Já tenho conta — entrar'
                          : 'Criar uma conta',
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

// =====================================================
// LISTA E CRIAÇÃO DE SALAS
// =====================================================

class SalasPage extends StatefulWidget {
  const SalasPage({super.key});

  @override
  State<SalasPage> createState() => _SalasPageState();
}

class _SalasPageState extends State<SalasPage> {
  final nomeSala = TextEditingController();

  bool criando = false;
  String? erro;

  Future<void> criarSala() async {
    final nome = nomeSala.text.trim();

    if (nome.isEmpty) {
      setState(() => erro = 'Digite o nome da sala.');
      return;
    }

    setState(() {
      criando = true;
      erro = null;
    });

    try {
      await db.from('salas_dominion').insert({
        'nome': nome,
        'criada_por': db.auth.currentUser!.id,
      });

      nomeSala.clear();

      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        setState(() => erro = 'Erro ao criar sala: $e');
      }
    } finally {
      if (mounted) {
        setState(() => criando = false);
      }
    }
  }

  Future<void> sair() async {
    await db.auth.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );
  }

  @override
  void dispose() {
    nomeSala.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SALAS DOMÍNION'),
        actions: [
          IconButton(
            onPressed: sair,
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeSala,
              decoration: const InputDecoration(
                labelText: 'Nome da nova sala',
                prefixIcon: Icon(Icons.meeting_room),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: roxo,
                  foregroundColor: Colors.white,
                ),
                onPressed: criando ? null : criarSala,
                icon: const Icon(Icons.add),
                label: Text(
                  criando ? 'CRIANDO...' : 'CRIAR SALA',
                ),
              ),
            ),
            if (erro != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  erro!,
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SALAS CRIADAS',
                style: TextStyle(
                  color: dourado,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: db
                    .from('salas_dominion')
                    .stream(primaryKey: ['id'])
                    .order('criada_em', ascending: false),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar salas:\n${snapshot.error}',
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final salas = snapshot.data!;

                  if (salas.isEmpty) {
                    return const Center(
                      child: Text(
                        'Ainda não há salas. Crie a primeira!',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: salas.length,
                    itemBuilder: (context, i) {
                      final sala = salas[i];
                      final id = sala['id'].toString();
                      final nome = '${sala['nome'] ?? 'Sala'}';

                      return Card(
                        color: painel,
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: roxo,
                            child: Icon(
                              Icons.headset_mic,
                              color: dourado,
                            ),
                          ),
                          title: Text(
                            nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text('Áudio e chat da sala'),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: dourado,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalaPage(
                                  salaId: id,
                                  nome: nome,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// SALA: BOTÃO DE MICROFONE E CHAT EM TEMPO REAL
// =====================================================

class SalaPage extends StatefulWidget {
  final String salaId;
  final String nome;

  const SalaPage({
    super.key,
    required this.salaId,
    required this.nome,
  });

  @override
  State<SalaPage> createState() => _SalaPageState();
}

class _SalaPageState extends State<SalaPage> {
  final texto = TextEditingController();

  bool microfoneLigado = false;
  String? erro;

  Stream<List<Map<String, dynamic>>> get mensagens {
    return db
        .from('mensagens_dominion')
        .stream(primaryKey: ['id'])
        .eq('sala_id', int.parse(widget.salaId))
        .order('criada_em', ascending: true);
  }

  Future<void> enviar() async {
    final conteudo = texto.text.trim();

    if (conteudo.isEmpty) return;

    texto.clear();

    try {
      await db.from('mensagens_dominion').insert({
        'sala_id': int.parse(widget.salaId),
        'usuario_id': db.auth.currentUser!.id,
        'email': db.auth.currentUser!.email ?? 'Membro',
        'mensagem': conteudo,
      });

      if (mounted) {
        setState(() => erro = null);
      }
    } catch (e) {
      if (mounted) {
        setState(() => erro = 'Não foi possível enviar: $e');
      }
    }
  }

  @override
  void dispose() {
    texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: painel,
            child: Column(
              children: [
                const Icon(
                  Icons.groups,
                  color: dourado,
                  size: 38,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.nome,
                  style: const TextStyle(
                    color: dourado,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        microfoneLigado ? Colors.redAccent : roxo,
                  ),
                  onPressed: () {
                    setState(() {
                      microfoneLigado = !microfoneLigado;
                    });
                  },
                  icon: Icon(
                    microfoneLigado ? Icons.mic_off : Icons.mic,
                  ),
                  label: Text(
                    microfoneLigado
                        ? 'DESLIGAR MICROFONE'
                        : 'LIGAR MICROFONE',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'O áudio ao vivo precisa de integração com um '
                  'serviço de transmissão de voz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CHAT DA SALA',
                style: TextStyle(
                  color: dourado,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: mensagens,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro no chat: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final lista = snapshot.data!;

                if (lista.isEmpty) {
                  return const Center(
                    child: Text(
                      'Seja o primeiro a mandar uma mensagem!',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: lista.length,
                  itemBuilder: (context, i) {
                    final m = lista[i];
                    final meu = m['usuario_id'] ==
                        db.auth.currentUser?.id;

                    return Align(
                      alignment: meu
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 300,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: meu ? roxo : painel,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${m['email'] ?? 'Membro'}',
                              style: const TextStyle(
                                color: dourado,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text('${m['mensagem'] ?? ''}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (erro != null)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                erro!,
                style: const TextStyle(
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: texto,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Escreva uma mensagem...',
                      ),
                      onSubmitted: (_) => enviar(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: roxo,
                    ),
                    onPressed: enviar,
                    icon: const Icon(Icons.send),
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
