import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/app_error.dart';
import '../../models/reward_models.dart';

/// Serviço que conversa com a API de Recompensas.
class RewardsService {
  final ApiClient _api;

  RewardsService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  /// Busca a lista de recompensas (GET /rewards).
  Future<List<RewardModel>> getRewards() async {
    try {
      final res = await _api.dio.get('/rewards');
      final data = res.data;

      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(RewardModel.fromJson)
            .toList();
      }
      return <RewardModel>[];
    } on DioException catch (e) {
      throw _mapError(e, context: 'carregar recompensas');
    }
  }

  /// Tenta resgatar uma recompensa (POST /rewards/{id}/redeem).
  Future<RedeemResponse> redeemReward(int id) async {
    try {
      final res = await _api.dio.post('/rewards/$id/redeem');
      return RedeemResponse.fromJson(res.data);
    } on DioException catch (e) {
      throw _mapError(e, context: 'resgatar recompensa');
    }
  }

  AppError _mapError(DioException e, {required String context}) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String? serverMsg;
    if (data is Map && data['message'] is String) {
      serverMsg = data['message'] as String;
    }

    switch (status) {
      case 400:
        return AppError(serverMsg ?? 'Requisição inválida ao $context.', status: status);
      case 401:
        return AppError('Sessão expirada. Faça login novamente.', status: status);
      case 403:
        return AppError('Você não tem permissão para $context.', status: status);
      case 404:
        return AppError('Recurso não encontrado ao $context.', status: status);
      case 409:
        return AppError(serverMsg ?? 'Você não tem pontos suficientes.', status: status);
      case 500:
        return AppError('Erro interno do servidor ao $context.', status: status);
      default:
        if (status == null) {
          final url = e.requestOptions.uri.toString();
          return AppError('Falha de rede ao $context.\n$url');
        }
        return AppError('Erro inesperado (HTTP $status) ao $context.');
    }
  }
}
