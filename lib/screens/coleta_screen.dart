import 'package:flutter/material.dart';

class ColetaScreen extends StatelessWidget {
  const ColetaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold define a estrutura visual da tela
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Coleta de E-lixo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto para o usuário digitar o tipo de eletrônico
            const Text(
              'Tipo de eletrônico:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ex: Notebook, Celular, Bateria...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Campo para data
            const Text(
              'Data para retirada:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ex: 08/08/2025',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Campo para horário
            const Text(
              'Horário aproximado:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ex: 14:00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Botão de agendamento (simulado)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Mostra mensagem simulada de confirmação
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coleta agendada com sucesso!'),
                    ),
                  );
                },
                child: const Text('Agendar Coleta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
