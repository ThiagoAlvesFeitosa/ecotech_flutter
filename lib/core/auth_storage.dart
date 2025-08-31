import 'package:shared_preferences/shared_preferences.dart';

/// Camada simples de persistência do token JWT.
///
/// Por que criar esta classe?
/// - Centraliza onde e como guardo o token.
/// - Facilita trocar SharedPreferences por outro storage no futuro.
/// - Deixa o código de UI/Service mais limpo.
class AuthStorage {
  static const _kTokenKey = 'auth_token';

  /// Salva o token JWT em armazenamento local (SharedPreferences).
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
  }

  /// Lê o token JWT, se existir. Retorna `null` se não houver.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTokenKey);
  }

  /// Remove o token (logout).
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
  }
}
