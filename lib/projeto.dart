import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DominionLiveApp extends StatelessWidget {
  const DominionLiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DOMINION LIVE',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF171021),
      ),
      home: const ProjetoDominion(),
    );
  }
}

class ProjetoDominion extends StatefulWidget {
  const ProjetoDominion({super.key});
  @override
  State<ProjetoDominion> createState() => _ProjetoDominionState();
}

class _ProjetoDominionState extends State<ProjetoDominion> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  String? _mensagem;

  Future<void> _cadastrar() async {
    setState(() { _isLoading = true; _mensagem = null; });
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      if (response.user != null) {
        setState(() { _mensagem = 'Cadastro OK! Verifique seu e-mail.'; });
      }
    } catch (e) {
      setState(() { _mensagem = 'Erro: $e'; });
    }
    setState(() { _isLoading = false; });
  }

  Future<void> _logar() async {
    setState(() { _isLoading = true; _mensagem = null; });
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );
      setState(() { _mensagem = 'Login OK! Bem-vindo ao DOMINION LIVE'; });
    } catch (e) {
      setState(() { _mensagem = 'Erro login: $e'; });
    }
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOMINION LIVE'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_moon, size: 80, color: Color(0xFFE5BC58)),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator()
            else Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: _logar, child: const Text('ENTRAR'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: _cadastrar, child: const Text('CADASTRAR'))),
              ],
            ),
            const SizedBox(height: 20),
            if (_mensagem != null)
              Text(_mensagem!, style: const TextStyle(color: Colors.amber), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}