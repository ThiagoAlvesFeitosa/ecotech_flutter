/// Modelos usados na funcionalidade de recompensas.

/// Recompensa disponível no catálogo.
class RewardModel {
  final int id;
  final String title;
  final int costPoints;

  RewardModel({
    required this.id,
    required this.title,
    required this.costPoints,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as int,
      title: json['title'] as String,
      costPoints: json['costPoints'] as int,
    );
  }
}

/// Resposta (simples) do resgate. O backend pode devolver uma mensagem ou nada.
/// Deixo flexível para não quebrar se vier só 200 sem body.
class RedeemResponse {
  final String? message;

  RedeemResponse({this.message});

  factory RedeemResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return RedeemResponse(message: json['message'] as String?);
    }
    return RedeemResponse(message: null);
  }
}
