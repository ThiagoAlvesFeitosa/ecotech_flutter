import 'user.dart'; // se você ainda não tem um User model, dá pra remover e deixar 'user' como dynamic

/// Representa UMA linha do histórico de pontos.
/// Isso aqui é basicamente o JSON que o backend manda em GET /points.
/// Exemplo do backend:
/// {
///   "id": 1,
///   "user": { ... },
///   "title": "Coleta: bateria (1.2kg)",
///   "points": 18,
///   "createdAt": "2025-08-29T17:02:05.98767"
/// }
class PointEntry {
  final int id;
  final String title;
  final int points;
  final DateTime createdAt;
  final UserModel user;

  // (opcional) quem gerou – deixei fora para simplificar a tela
  // final User user;

  PointEntry({
    required this.id,
    required this.title,
    required this.points,
    required this.createdAt,
    required this.user,
  });

  factory PointEntry.fromJson(Map<String, dynamic> json) {
    return PointEntry(
      id: json['id'] as int,
      title: json['title'] as String,
      points: json['points'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

/// Representa a resposta do endpoint GET /points/total
/// O backend retorna algo do tipo: { "total": 18 }
class PointsTotal {
  final int total;

  PointsTotal(this.total);

  factory PointsTotal.fromJson(Map<String, dynamic> json) {
    return PointsTotal(json['total'] as int);
  }
}
