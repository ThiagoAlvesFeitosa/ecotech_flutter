/// Configurações globais do app.
/// Em emulador Android, "localhost" NÃO é a sua máquina.
/// Por isso usamos 10.0.2.2: ele mapeia p/ o host da sua máquina.
class AppConfig {
  static const String baseUrl = 'http://10.0.2.2:8080';
// Em desktop / iOS simulador, pode usar: 'http://localhost:8080'
}
