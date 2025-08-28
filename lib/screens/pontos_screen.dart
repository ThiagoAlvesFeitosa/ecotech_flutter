import 'package:flutter/material.dart';

class PontosScreen extends StatelessWidget {
  const PontosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de atividades simuladas relacionadas ao descarte de e-lixo
    final atividades = [
      {'titulo': 'Descarte de pilhas usadas', 'pontos': 10},
      {'titulo': 'Entrega de celulares antigos', 'pontos': 20},
      {'titulo': 'Participação em campanha de coleta', 'pontos': 15},
      {'titulo': 'Compartilhou o app com amigos', 'pontos': 5},
    ];

    // Calcula o total de pontos somando todos os pontos das atividades
    final totalPontos = atividades.fold<int>(
      0,
          (soma, atividade) => soma + (atividade['pontos'] as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pontos'), // Título no topo da tela
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // Espaçamento interno da tela
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Histórico de Pontuação', // Título da seção
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Espaço entre os elementos

            // Lista de atividades
            Expanded(
              child: ListView.builder(
                itemCount: atividades.length,
                itemBuilder: (context, index) {
                  final atividade = atividades[index];
                  return ListTile(
                    leading: const Icon(Icons.electric_bolt_outlined),
                    title: Text(atividade['titulo'] as String), // Corrigido: conversão segura para String
                    trailing: Text('+${atividade['pontos']} pts'),
                  );
                },
              ),
            ),


            const SizedBox(height: 16),

            // Exibe o total de pontos ao final
            Center(
              child: Text(
                'Total: $totalPontos pontos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
