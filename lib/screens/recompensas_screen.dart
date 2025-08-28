import 'package:flutter/material.dart';

class RecompensasScreen extends StatelessWidget {
  const RecompensasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de recompensas simuladas relacionadas ao descarte de e-lixo
    final recompensas = [
      {'titulo': 'Desconto em loja de eletrônicos', 'pontos': 50},
      {'titulo': 'Participação em sorteio sustentável', 'pontos': 30},
      {'titulo': 'Ingresso para evento de tecnologia verde', 'pontos': 70},
      {'titulo': 'Badge EcoTech de Conscientização', 'pontos': 20},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recompensas'), // Título no topo
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // Espaçamento da tela
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha uma recompensa:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Lista de recompensas
            Expanded(
              child: ListView.builder(
                itemCount: recompensas.length, // Número total de recompensas na lista
                itemBuilder: (context, index) {
                  final item = recompensas[index]; // Pegamos a recompensa da vez

                  return Card(
                    elevation: 3, // Sombra para dar destaque ao card
                    margin: const EdgeInsets.symmetric(vertical: 8), // Espaço entre os cards
                    child: ListTile(
                      title: Text(
                        item['titulo'] as String, // Corrigido: garantimos que é uma String
                      ),
                      trailing: Text(
                        '${item['pontos']} pts', // Mostra quantos pontos são necessários
                      ),
                      onTap: () {
                        // Ao clicar, mostra uma mensagem dizendo que a recompensa foi resgatada (simulado)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Recompensa resgatada!'),
                          ),
                        );
                      },
                    ),
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
