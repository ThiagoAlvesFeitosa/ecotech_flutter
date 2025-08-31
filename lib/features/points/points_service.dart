import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/app_error.dart';
import '../../models/point_models.dart';

/// Serviço responsável por falar com o backend sobre PONTOS.
/// - GET /points        -> histórico
/// - GET /points/total  -> total acumulado
///
/// Eu deixo esse serviço separado para a tela só pedir o que precisa.
class PointsService {
  final ApiClient _api;

  PointsService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  /// Busca o TOTAL de pontos no endpoint GET /points/total
  Future<int> getTotal() async {
    try {
      final res = await _api.dio.get('/points/total');
      final model = PointsTotal.fromJson(res.data as Map<String, dynamic>);
      return model.total;
    } on DioException catch (e) {
      // Mapeio para uma AppError com uma mensagem amigável
      throw _mapError(e, action: 'carregar total de pontos');
    }
  }

  /// Busca o HISTÓRICO no endpoint GET /points
  Future<List<PointEntry>> getHistory() async {
    try {
      final res = await _api.dio.get('/points');
      final list = (res.data as List)
          .map((j) => PointEntry.fromJson(j as Map<String, dynamic>))
          .toList();
      // ordeno do mais recente para o mais antigo (só para UX ficar melhor)
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } on DioException catch (e) {
      throw _mapError(e, action: 'carregar histórico de pontos');
    }
  }

  // ---------- helpers ----------

  AppError _mapError(DioException e, {required String action}) {
    final status = e.response?.statusCode;
    // Se o backend retornar {message: "..."} eu posso priorizar:
    final data = e.response?.data;
    String? serverMsg;
    if (data is Map && data['message'] is String) serverMsg = data['message'] as String;

    switch (status) {
      case 401:
        return AppError('Sessão expirada. Faça login novamente.', status: status);
      case 403:
        return AppError('Acesso negado. Verifique suas permissões.', status: status);
      case 500:
        return AppError('Erro no servidor ao $action.', status: status);
      default:
        if (status == null) {
          // Sem status normalmente é erro de rede (timeout/DNS/baseUrl)
          final url = e.requestOptions.uri.toString();
          return AppError('Falha de rede ao $action.\n$url', status: status);
        }
        return AppError(serverMsg ?? 'Erro inesperado (HTTP $status) ao $action.', status: status);
    }
  }
}
