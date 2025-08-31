import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/auth_storage.dart';
import '../../models/auth_models.dart';
import '../../core/app_error.dart';

/// Serviço de autenticação.
/// Eu centralizo aqui as chamadas /auth e o tratamento de erros,
/// para as telas só lidarem com mensagens prontas.
class AuthService {
  final ApiClient _api;
  final AuthStorage _auth;

  AuthService({ApiClient? apiClient, AuthStorage? authStorage})
      : _api = apiClient ?? ApiClient(),
        _auth = authStorage ?? AuthStorage();

  /// Cadastro: se OK, salvo token e devolvo AuthResponse.
  Future<AuthResponse> register(RegisterRequest req) async {
    try {
      final res = await _api.dio.post('/auth/register', data: req.toJson());
      final auth = AuthResponse.fromJson(res.data as Map<String, dynamic>);
      await _auth.saveToken(auth.token);
      return auth;
    } on DioException catch (e) {
      throw _mapDioError(e, context: 'registrar');
    } catch (_) {
      throw AppError('Erro inesperado ao registrar.');
    }
  }

  /// Login: se OK, salvo token e devolvo AuthResponse.
  Future<AuthResponse> login(LoginRequest req) async {
    try {
      final res = await _api.dio.post('/auth/login', data: req.toJson());
      final auth = AuthResponse.fromJson(res.data as Map<String, dynamic>);
      await _auth.saveToken(auth.token);
      return auth;
    } on DioException catch (e) {
      throw _mapDioError(e, context: 'fazer login');
    } catch (_) {
      throw AppError('Erro inesperado ao fazer login.');
    }
  }

  Future<void> logout() async => _auth.clearToken();

  Future<bool> hasToken() async {
    final t = await _auth.getToken();
    return t != null && t.isNotEmpty;
  }

  // ---------------- helpers privados ----------------

  /// Eu pego status/response do Dio e devolvo uma AppError com texto amigável.
  AppError _mapDioError(DioException e, {required String context}) {
    final status = e.response?.statusCode;
    final data = e.response?.data; // backend pode mandar {message: "..."}
    final serverMsg = _extractServerMessage(data);

    switch (status) {
      case 400:
        return AppError(serverMsg ?? 'Dados inválidos.', status: status);
      case 401:
      // AQUI está o pedido: mensagem clara no login com 401.
        return AppError('E-mail ou senha incorretos.', status: status);
      case 403:
        return AppError('Acesso negado. Faça login novamente.', status: status);
      case 404:
        return AppError('Rota não encontrada na API.', status: status);
      case 409:
        return AppError(serverMsg ?? 'E-mail já cadastrado.', status: status);
      case 500:
        return AppError('Erro no servidor. Tente novamente mais tarde.', status: status);
      default:
        if (status == null) {
          // Quando não há status, normalmente é rede/timeout/DNS/baseUrl errado.
          final url = e.requestOptions.uri.toString();
          return AppError(
            'Falha de rede ao $context.\n'
                'Verifique sua conexão e a URL da API.\n$url',
            status: status,
          );
        }
        return AppError('Erro inesperado (HTTP $status).', status: status);
    }
  }

  /// Tento achar uma mensagem de erro vinda do backend.
  String? _extractServerMessage(dynamic data) {
    if (data is Map && data['message'] is String) return data['message'] as String;
    if (data is Map && data['error'] is String) return data['error'] as String;
    return null;
  }
}
