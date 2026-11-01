
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const Color dlPreto = Color(0xFF08060B);
const Color dlPainel = Color(0xFF171020);
const Color dlRoxo = Color(0xFF6A1B9A);
const Color dlRoxoClaro = Color(0xFFB56AFF);
const Color dlDourado = Color(0xFFE5BC58);

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
        final resposta = await _supabase.auth.signUp(
          email: email,
          password: senha,
        );

        if (!mounted) return;

        if (resposta.session != null) {
          _abrirInicio();
        } else {
          _mostrarMensagem(
            'Cadastro recebido! Confira seu e-mail para confirmar '
            'a conta antes de entrar.',
          );
        }
      } else {
        await _supabase.auth.signInWithPassword(
          email: email,
          password: senha,
        );

        if (!mounted) return;

        _abrirInicio();
      }
    } on AuthException catch (e) {
      if (!mounted) return;

      _mostrarMensagem(
        _traduzirErro(e.message),
        erro: true,
      );
    } catch (e) {
      if (!mounted) return;

      _mostrarMensagem(
        'Não foi possível conectar. Confira sua internet '
        'e tente novamente.',
        erro: true,
      );
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  String _traduzirErro(String erro) {
    final texto = erro.toLowerCase();

    if (texto.contains('invalid login credentials')) {
      return 'E-mail ou senha incorretos.';
    }

    if (texto.contains('user already registered')) {
      return 'Este e-mail já possui cadastro. Tente entrar.';
    }

    if (texto.contains('password should be at least')) {
      return 'A senha não atende ao tamanho mínimo exigido.';
    }

    if (texto.contains('email not confirmed')) {
      return 'Confirme seu e-mail antes de entrar.';
    }

    if (texto.contains('invalid email')) {
      return 'Digite um endereço de e-mail válido.';
    }

    if (texto.contains('rate limit')) {
      return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
    }

    return 'Não foi possível concluir a operação. '
        'Confira os dados e as configurações do Supabase.';
  }

  void _abrirInicio() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const InicioDominionPage(),
      ),
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
                    width: 106,
                    height: 106,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dlPainel,
                      border: Border.all(
                        color: dlDourado,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: dlRoxo.withOpacity(0.65),
                          blurRadius: 28,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pets,
                      size: 58,
                      color: dlDourado,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'DOMÍNION LIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dlDourado,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'SUA VOZ. SUA FAMÍLIA. SEU IMPÉRIO.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dlRoxoClaro,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: dlPainel,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: dlRoxo.withOpacity(0.7),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _modoCadastro
                                ? 'CRIAR CONTA'
                                : 'BEM-VINDO DE VOLTA',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _modoCadastro
                                ? 'Faça parte da nossa família.'
                                : 'Entre no seu império.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white60,
                            ),
                          ),

                          const SizedBox(height: 25),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [
                              AutofillHints.email,
                            ],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: _decoracao(
                              'E-mail',
                              Icons.email_outlined,
                            ),
                            validator: (valor) {
                              final email = valor?.trim() ?? '';

                              if (email.isEmpty) {
                                return 'Digite seu e-mail.';
                              }

                              if (!RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(email)) {
                                return 'Digite um e-mail válido.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _senhaController,
                            obscureText: !_mostrarSenha,
                            textInputAction: _modoCadastro
                                ? TextInputAction.next
                                : TextInputAction.done,
                            autofillHints: [
                              _modoCadastro
                                  ? AutofillHints.newPassword
                                  : AutofillHints.password,
                            ],
                            onFieldSubmitted: (_) {
                              if (!_modoCadastro && !_carregando) {
                                _autenticar();
                              }
                            },
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: _decoracao(
                              'Senha',
                              Icons.lock_outline,
                              sufixo: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _mostrarSenha = !_mostrarSenha;
                                  });
                                },
                                icon: Icon(
                                  _mostrarSenha
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: dlDourado,
                                ),
                              ),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) {
                                return 'Digite sua senha.';
                              }

                              if (_modoCadastro && valor.length < 6) {
                                return 'Use pelo menos 6 caracteres.';
                              }

                              return null;
                            },
                          ),

                          if (_modoCadastro) ...[
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _confirmarController,
                              obscureText: !_mostrarConfirmacao,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _decoracao(
                                'Confirmar senha',
                                Icons.lock_reset,
                                sufixo: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _mostrarConfirmacao =
                                          !_mostrarConfirmacao;
                                    });
                                  },
                                  icon: Icon(
                                    _mostrarConfirmacao
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: dlDourado,
                                  ),
                                ),
                              ),
                              validator: (valor) {
                                if (valor == null || valor.isEmpty) {
                                  return 'Confirme sua senha.';
                                }

                                if (valor != _senhaController.text) {
                                  return 'As senhas não coincidem.';
                                }

                                return null;
                              },
                            ),
                          ],

                          const SizedBox(height: 24),

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed:
                                  _carregando ? null : _autenticar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: dlDourado,
                                foregroundColor: dlPreto,
                                disabledBackgroundColor:
                                    dlDourado.withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _carregando
                                  ? const SizedBox(
                                      height: 23,
                                      width: 23,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: dlPreto,
                                      ),
                                    )
                                  : Text(
                                      _modoCadastro
                                          ? 'CRIAR MINHA CONTA'
                                          : 'ENTRAR NO DOMÍNION',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextButton(
                            onPressed:
                                _carregando ? null : _alternarModo,
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                                children: [
                                  TextSpan(
                                    text: _modoCadastro
                                        ? 'Já tem uma conta? '
                                        : 'Ainda não tem conta? ',
                                  ),
                                  TextSpan(
                                    text: _modoCadastro
                                        ? 'Entrar'
                                        : 'Cadastre-se',
                                    style: const TextStyle(
                                      color: dlDourado,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (_mensagem != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _mensagemErro
                                    ? Colors.red.withOpacity(0.12)
                                    : dlRoxo.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _mensagemErro
                                      ? Colors.redAccent
                                      : dlRoxoClaro,
                                ),
                              ),
                              child: Text(
                                _mensagem!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _mensagemErro
                                      ? Colors.redAccent
                                      : dlDourado,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'DOMÍNION LIVE • SUA FAMÍLIA, SUA HISTÓRIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 0.7,
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

  InputDecoration _decoracao(
    String titulo,
    IconData icone, {
    Widget? sufixo,
  }) {
    return InputDecoration(
      labelText: titulo,
      labelStyle: const TextStyle(color: Colors.white60),
      prefixIcon: Icon(icone, color: dlRoxoClaro),
      suffixIcon: sufixo,
      filled: true,
      fillColor: dlPreto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: dlDourado,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

// TELA PROVISÓRIA APÓS O LOGIN.
// Depois podemos conectar aqui as salas, família e perfil.
class InicioDominionPage extends StatelessWidget {
  const InicioDominionPage({super.key});

  Future<void> _sair(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (!context.mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const ProjetoDominion(),
        ),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível sair: ${e.message}')),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao sair. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Supabase.instance.client.auth.currentUser;
    final email = usuario?.email ?? 'Membro DOMÍNION';

    return Scaffold(
      backgroundColor: dlPreto,
      appBar: AppBar(
        backgroundColor: dlPainel,
        foregroundColor: dlDourado,
        title: const Text(
          'DOMÍNION LIVE',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Sair da conta',
            onPressed: () => _sair(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dlPainel,
                  border: Border.all(
                    color: dlDourado,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: dlRoxo.withOpacity(0.6),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets,
                  color: dlDourado,
                  size: 62,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'BEM-VINDO AO IMPÉRIO!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dlDourado,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 32),
              const Text(
                'Sua jornada no DOMÍNION LIVE começa aqui.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dlRoxoClaro,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              const Card(
                color: dlPainel,
                child: ListTile(
                  leading: Icon(Icons.mic, color: dlDourado),
                  title: Text(
                    'Salas ao vivo',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Próxima etapa de desenvolvimento',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const Card(
                color: dlPainel,
                child: ListTile(
                  leading: Icon(Icons.groups, color: dlDourado),
                  title: Text(
                    'Família DOMÍNION',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Sua comunidade será integrada aqui',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const Card(
                color: dlPainel,
                child: ListTile(
                  leading: Icon(Icons.person, color: dlDourado),
                  title: Text(
                    'Meu perfil',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Perfil e molduras VIP serão integrados aqui',
                    style: TextStyle(color: Colors.white54),
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
