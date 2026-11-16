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
    'COLE_AQUI_SUA_CHAVE_PUBLISHABLE';

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