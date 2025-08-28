import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados do usuário
    final nome = 'Thiago Alves';
    final email = 'thiago@ecotech.com';
    final pontos = 120;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.jpg'), // imagem fictícia
            ),
            const SizedBox(height: 16),

            // Nome do usuário
            Text(
              nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Email do usuário
            Text(
              email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Pontuação do usuário
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Pontos acumulados'),
                trailing: Text('$pontos pts'),
              ),
            ),

            const SizedBox(height: 16),

            // Botão de logout simulado
            ElevatedButton(
              onPressed: () {
                // Retorna para a tela de login
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, //  Cor de fundo vermelha
                foregroundColor: Colors.white, // Cor do texto branca
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Sair do App'),
                ],
              ),

            ),

          ],
        ),
      ),
    );
  }
}
