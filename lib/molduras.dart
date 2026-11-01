
import 'package:flutter/material.dart';

const Color molduraPreto = Color(0xFF08060B);
const Color molduraRoxo = Color(0xFF6A1B9A);
const Color molduraDourado = Color(0xFFE5BC58);

enum TipoMoldura {
  vipDourada,
  vipRoxa,
  dominionBlack,
  loboImperial,
  semMoldura,
}

class MolduraConfig {
  final TipoMoldura tipo;
  final String nome;
  final Color cor;
  final IconData icone;

  const MolduraConfig({
    required this.tipo,
    required this.nome,
    required this.cor,
    required this.icone,
  });
}

const List<MolduraConfig> moldurasDisponiveis = [
  MolduraConfig(
    tipo: TipoMoldura.vipDourada,
    nome: 'VIP GOLD',
    cor: molduraDourado,
    icone: Icons.workspace_premium,
  ),
  MolduraConfig(
    tipo: TipoMoldura.vipRoxa,
    nome: 'VIP ROXA',
    cor: molduraRoxo,
    icone: Icons.auto_awesome,
  ),
  MolduraConfig(
    tipo: TipoMoldura.dominionBlack,
    nome: 'BLACK GOLD',
    cor: molduraDourado,
    icone: Icons.shield,
  ),
  MolduraConfig(
    tipo: TipoMoldura.loboImperial,
    nome: 'LOBO IMPERIAL',
    cor: molduraDourado,
    icone: Icons.pets,
  ),
  MolduraConfig(
    tipo: TipoMoldura.semMoldura,
    nome: 'SEM MOLDURA',
    cor: Colors.transparent,
    icone: Icons.person,
  ),
];

class MolduraWidget extends StatelessWidget {
  final Widget child;
  final TipoMoldura tipo;
  final double raio;
  final double espessura;
  final bool mostrarSelo;

  const MolduraWidget({
    super.key,
    required this.child,
    this.tipo = TipoMoldura.loboImperial,
    this.raio = 18,
    this.espessura = 3,
    this.mostrarSelo = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = moldurasDisponiveis.firstWhere(
      (item) => item.tipo == tipo,
    );

    if (tipo == TipoMoldura.semMoldura) {
      return child;
    }

    final Color corInterna = tipo == TipoMoldura.vipRoxa
        ? const Color(0xFFB56AFF)
        : config.cor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raio),
        boxShadow: [
          BoxShadow(
            color: corInterna.withOpacity(0.45),
            blurRadius: tipo == TipoMoldura.loboImperial ? 22 : 12,
            spreadRadius: tipo == TipoMoldura.loboImperial ? 2 : 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(raio),
            child: child,
          ),

          // A borda fica por cima, sem esconder a foto.
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(raio),
                  border: Border.all(
                    color: corInterna,
                    width: espessura,
                  ),
                  gradient: tipo == TipoMoldura.loboImperial
                      ? null
                      : null,
                ),
              ),
            ),
          ),

          // Detalhes especiais da moldura de lobo.
          if (tipo == TipoMoldura.loboImperial)
            Positioned(
              top: 5,
              right: 5,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: molduraPreto.withOpacity(0.85),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: molduraDourado,
                      width: 1.2,
                    ),
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: molduraDourado,
                    size: 15,
                  ),
                ),
              ),
            ),

          if (mostrarSelo)
            Positioned(
              left: 7,
              top: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: molduraPreto.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: corInterna,
                    width: 1,
                  ),
                ),
                child: Text(
                  config.nome,
                  style: TextStyle(
                    color: corInterna,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// TELA PARA VISUALIZAR E ESCOLHER AS MOLDURAS.
class MolduraPreviewPage extends StatefulWidget {
  const MolduraPreviewPage({super.key});

  @override
  State<MolduraPreviewPage> createState() =>
      _MolduraPreviewPageState();
}

class _MolduraPreviewPageState extends State<MolduraPreviewPage> {
  TipoMoldura selecionada = TipoMoldura.loboImperial;

  @override
  Widget build(BuildContext context) {
    final config = moldurasDisponiveis.firstWhere(
      (item) => item.tipo == selecionada,
    );

    return Scaffold(
      backgroundColor: molduraPreto,
      appBar: AppBar(
        backgroundColor: molduraPreto,
        foregroundColor: molduraDourado,
        title: const Text(
          'MOLDURAS VIP',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'DOMÍNION LIVE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: molduraDourado,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ESCOLHA SUA IDENTIDADE',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 30),

          Center(
            child: MolduraWidget(
              tipo: selecionada,
              raio: 100,
              espessura: 5,
              child: Container(
                width: 150,
                height: 150,
                color: const Color(0xFF21152B),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pets,
                      size: 65,
                      color: molduraDourado,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'ALFA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),
          Text(
            config.nome,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: config.cor == Colors.transparent
                  ? Colors.white
                  : config.cor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),

          const Text(
            'MOLDURAS DISPONÍVEIS',
            style: TextStyle(
              color: molduraDourado,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...moldurasDisponiveis.map((item) {
            final bool ativa = selecionada == item.tipo;

            return Card(
              color: ativa
                  ? const Color(0xFF291638)
                  : const Color(0xFF151119),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: ativa
                      ? molduraDourado
                      : Colors.white12,
                  width: ativa ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: Icon(
                  item.icone,
                  color: item.cor == Colors.transparent
                      ? Colors.white70
                      : item.cor,
                ),
                title: Text(
                  item.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: ativa
                    ? const Icon(
                        Icons.check_circle,
                        color: molduraDourado,
                      )
                    : const Icon(
                        Icons.chevron_right,
                        color: Colors.white54,
                      ),
                onTap: () {
                  setState(() {
                    selecionada = item.tipo;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 20),
          const Text(
            'A prévia mostra o estilo escolhido. '
            'Salvar a moldura no perfil do usuário '
            'será uma etapa de integração posterior.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
