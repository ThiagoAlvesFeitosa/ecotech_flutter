import 'package:ecotech/screens/escanear_screen.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/coleta_screen.dart';
import '../screens/pontos_screen.dart';
import '../screens/cadastro_screen.dart';
import '../screens/home_screen.dart';
import '../screens/recompensas_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/impacto_screen.dart';
import '../screens/assistente_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String home = '/home';
  static const String escanear = '/escanear';
  static const String coleta = '/coleta';
  static const String pontos = '/pontos';
  static const String recompensas = '/recompensas';
  static const String perfil = '/perfil';
  static const String impacto = '/impacto';
  static const String assistente = '/assistente';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case cadastro:
        return MaterialPageRoute(builder: (_) => const CadastroScreen());
      case escanear:
        return MaterialPageRoute(builder: (_) => const EscanearScreen());
      case coleta:
        return MaterialPageRoute(builder: (_) => const ColetaScreen());
      case pontos:
        return MaterialPageRoute(builder: (_) => const PontosScreen());
      case impacto:
        return MaterialPageRoute(builder: (_) => const ImpactoScreen());
      case recompensas:
        return MaterialPageRoute(builder: (_) => const RecompensasScreen());
      case perfil:
        return MaterialPageRoute(builder: (_) => const PerfilScreen());
      case assistente:
        return MaterialPageRoute(builder: (_) => const AssistenteScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
