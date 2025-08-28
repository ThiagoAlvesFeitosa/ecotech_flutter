import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar superior do app
      appBar: AppBar(
        title: const Text('EcoTech'), // Título da tela
        actions: [
          // Ícone de perfil no canto superior direito
          IconButton(
            icon: const Icon(Icons.person),
            iconSize: 42,
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.perfil); // Navega para tela de perfil
            },
          ),
        ],
      ),

      // Corpo principal da tela
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaço nas bordas
        child: GridView.count(
          crossAxisCount: 2, // 2 colunas
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Cada card é um "atalho" visual para outra tela do app

            // Ir para a tela de escanear QR Code
            _buildMenuCard(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Escanear QR Code',
              route: AppRoutes.escanear,
            ),

            // Ir para a tela de coleta de e-lixo
            _buildMenuCard(
              context,
              icon: Icons.recycling,
              label: 'Registrar Coleta',
              route: AppRoutes.coleta,
            ),

            // Ver pontos acumulados
            _buildMenuCard(
              context,
              icon: Icons.star,
              label: 'Meus Pontos',
              route: AppRoutes.pontos,
            ),

            // Ver recompensas disponíveis
            _buildMenuCard(
              context,
              icon: Icons.card_giftcard,
              label: 'Recompensas',
              route: AppRoutes.recompensas,
            ),

            // Ver impacto ambiental gerado
            _buildMenuCard(
              context,
              icon: Icons.eco,
              label: 'Impacto Ambiental',
              route: AppRoutes.impacto,
            ),

            // Assistente virtual ManageEngine
            _buildMenuCard(
              context,
              icon: Icons.smart_toy,
              label: 'Assistente Virtual',
              route: AppRoutes.assistente,
            ),
          ],
        ),
      ),
    );
  }

  // Método que cria um "card de menu"
  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
        required String label,
        required String route}) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route), // Vai para a tela correspondente
      child: Card(
        elevation: 4, // Sombra do card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.green), // Ícone central
              const SizedBox(height: 8),
              Text(
                label, // Texto abaixo do ícone
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
