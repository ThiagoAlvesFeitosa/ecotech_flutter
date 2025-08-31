/// ------------------------------------------------------------
/// MODELOS DE COLETA (REQUEST/RESPONSE)
/// ------------------------------------------------------------
/// Este arquivo define "formatos" (modelos) dos dados que trafegam
/// entre o app e a API quando falamos de COLETAS.
///
/// Por que criar modelos?
/// - Para ter **tipos fortes** (em vez de Map/dynamic solto).
/// - Para **documentar** exatamente o que a API espera e devolve.
/// - Para **facilitar** conversões de/para JSON.
/// ------------------------------------------------------------

/// Corpo que EU envio ao backend no POST /collects.
///
/// OBS IMPORTANTE:
/// O backend valida `qrCode` com @NotBlank. Para rodar sem scanner,
/// eu permito passar null aqui e **o service vai gerar** um valor
/// “manual-<timestamp>” antes de mandar para a API.
class CollectRequest {
  /// QR code escaneado. Se eu não tiver scanner, mando um valor gerado
  /// (ex.: "manual-1699999999999") para satisfazer a validação do backend.
  final String qrCode;

  /// Tipo do e-lixo (ex.: "bateria", "celular", "notebook").
  /// No backend, isso vai no campo 'eWasteType'.
  final String eWasteType;

  /// Peso em quilogramas (ex.: 1.2).
  /// No backend, isso vai no campo 'weightKg'.
  final double weightKg;

  CollectRequest({
    required this.qrCode,
    required this.eWasteType,
    required this.weightKg,
  });

  /// Converte o objeto para JSON **exatamente** do jeito que a API espera.
  Map<String, dynamic> toJson() => {
    'qrCode': qrCode,
    'eWasteType': eWasteType,
    'weightKg': weightKg,
  };
}

/// Resposta (simples) que o backend devolve ao criar uma coleta.
/// (Se o backend devolver mais campos, é só ampliar aqui depois.)
class CollectResponse {
  /// ID gerado para a coleta (se o backend devolve).
  final int? id;

  /// Tipo (ecoado pelo backend, às vezes).
  final String? eWasteType;

  /// Peso que voltou do backend.
  final double? weightKg;

  /// Data/hora de criação da coleta (se o backend manda).
  final DateTime? createdAt;

  /// Pontos concedidos nesta coleta (se o backend informa).
  final int? awardedPoints;

  CollectResponse({
    this.id,
    this.eWasteType,
    this.weightKg,
    this.createdAt,
    this.awardedPoints,
  });

  /// Constrói a partir de um JSON genérico retornado pelo backend.
  /// Eu faço "parse defensivo": se um campo não existir, não quebro.
  factory CollectResponse.fromJson(Map<String, dynamic> json) {
    int? _toInt(dynamic x) => switch (x) {
      int v => v,
      String s => int.tryParse(s),
      _ => null,
    };
    double? _toDouble(dynamic x) => switch (x) {
      double v => v,
      int v => v.toDouble(),
      String s => double.tryParse(s),
      _ => null,
    };
    DateTime? _toDate(dynamic x) =>
        (x is String) ? DateTime.tryParse(x) : null;

    return CollectResponse(
      id: _toInt(json['id']),
      eWasteType: json['eWasteType'] as String?,
      weightKg: _toDouble(json['weightKg']),
      createdAt: _toDate(json['createdAt']),
      awardedPoints: _toInt(json['awardedPoints']),
    );
  }
}
