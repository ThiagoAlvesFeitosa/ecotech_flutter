// main.dart
import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/theme.dart';

void main() {
  runApp(const EcoTechApp());
}

class EcoTechApp extends StatelessWidget {
  const EcoTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoTech',
      theme: AppTheme.lightTheme, // aplica o tema global
      debugShowCheckedModeBanner: false,
      // Começamos no login. Depois dá pra trocar por uma splash que checa token.
      initialRoute: AppRoutes.login, // tela inicial do app
      onGenerateRoute: AppRoutes.generateRoute, // rotas
    );
  }
}
