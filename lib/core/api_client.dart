import 'package:dio/dio.dart';
import 'app_config.dart';
import 'auth_storage.dart';

/// Cliente HTTP (Dio) com:
/// - baseUrl da API
/// - timeouts
/// - interceptor para anexar "Authorization: Bearer <token>" em rotas protegidas.
///   Obs: eu NÃO envio Authorization em /auth/** (login/register), porque são públicas.
class ApiClient {
  final Dio _dio;
  final AuthStorage _authStorage;

  Dio get dio => _dio;

  ApiClient({AuthStorage? authStorage})
      : _authStorage = authStorage ?? AuthStorage(),
        _dio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
          responseType: ResponseType.json,
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // pego o PATH final já resolvido (ex.: "/auth/login", "/points/total")
        final path = options.uri.path;

        // eu considero públicas todas as rotas que começam com "/auth/"
        final isAuthRoute = path.startsWith('/auth/');

        // só anexo o Bearer quando NÃO for rota pública
        if (!isAuthRoute) {
          final token = await _authStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }

        return handler.next(options);
      },
      onError: (e, handler) => handler.next(e),
    ));
  }
}
