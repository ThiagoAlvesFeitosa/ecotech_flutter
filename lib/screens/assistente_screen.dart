import 'package:flutter/material.dart';

class AssistenteScreen extends StatelessWidget {
  const AssistenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistente EcoTech'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação inicial
            const Text(
              'Olá! Sou o Assistente EcoTech 🌱',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Descrição do que o assistente faz
            const Text(
              'Posso te ajudar com recomendações, dicas de coleta, dados ambientais e muito mais!',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            // Botão para simular interação
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Mostra uma mensagem simulando uma IA
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                      Text('Simulação de interação com o assistente.'),
                    ),
                  );
                },
                icon: const Icon(Icons.smart_toy),
                label: const Text('Interagir com o assistente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
