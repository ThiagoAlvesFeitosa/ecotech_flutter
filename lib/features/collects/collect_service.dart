import 'package:dio/dio.dart';

import '../../core/api_client.dart';    // meu cliente HTTP (Dio com interceptor do Bearer)
import '../../core/app_error.dart';     // exceção amigável para UI
import '../../models/collect_models.dart';

/// Serviço responsável por criar coletas.
/// Ele chama o endpoint POST /collects do backend.
class CollectService {
  final ApiClient _api;

  CollectService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  /// Cria uma coleta no backend.
  ///
  /// Parâmetros:
  /// - [eWasteType] : tipo do e-lixo (ex.: "bateria")
  /// - [weightKg]   : peso em kg (ex.: 1.2)
  /// - [qrCode]     : opcional; se não vier, eu gero "manual-<timestamp>"
  ///
  /// Por que gerar o qrCode aqui?
  /// - O backend exige @NotBlank em qrCode. Como nem sempre terei scanner
  ///   habilitado na entrega, eu “simulo” um código válido.
  Future<CollectResponse> createCollect({
    required String eWasteType,
    required double weightKg,
    String? qrCode,
  }) async {
    try {
      // Se vier null/vazio, eu GERO um valor manual com timestamp.
      final ensuredQr = (qrCode != null && qrCode.trim().isNotEmpty)
          ? qrCode.trim()
          : 'manual-${DateTime.now().millisecondsSinceEpoch}';

      // Monta o corpo do request do JEITO que a API espera.
      final req = CollectRequest(
        qrCode: ensuredQr,
        eWasteType: eWasteType,
        weightKg: weightKg,
      );

      // Chamo a API (o ApiClient já injeta o Authorization Bearer se houver token)
      final res = await _api.dio.post('/collects', data: req.toJson());
      final data = res.data;

      // Tento converter a resposta em CollectResponse de forma segura
      if (data is Map<String, dynamic>) {
        return CollectResponse.fromJson(data);
      }

      // Se a API não devolver JSON estruturado, retorno um “sucesso mínimo”
      // só para a UI conseguir mostrar uma confirmação.
      return CollectResponse(
        eWasteType: eWasteType,
        weightKg: weightKg,
        awardedPoints: null,
      );
    } on DioException catch (e) {
      // Traduzo erros do Dio para mensagens amigáveis (AppError)
      throw _mapError(e);
    }
  }

  /// Mapeia status HTTP para mensagens compreensíveis.
  AppError _mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    // Se o backend mandar { "message": "texto" }, eu tento usar.
    String? serverMsg;
    if (data is Map && data['message'] is String) {
      serverMsg = data['message'] as String;
    }

    switch (status) {
      case 400:
        return AppError(serverMsg ?? 'Dados inválidos ao registrar coleta.', status: status);
      case 401:
        return AppError('Sessão expirada. Faça login novamente.', status: status);
      case 403:
        return AppError('Acesso negado. Verifique suas permissões.', status: status);
      case 404:
        return AppError('Recurso de coleta não encontrado.', status: status);
      case 500:
        return AppError('Erro interno do servidor ao registrar coleta.', status: status);
      default:
        if (status == null) {
          // Erro de rede / timeout
          final url = e.requestOptions.uri.toString();
          return AppError('Falha de rede ao registrar coleta.\n$url');
        }
        return AppError('Erro inesperado (HTTP $status) ao registrar coleta.');
    }
  }
}
