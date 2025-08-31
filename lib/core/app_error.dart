/// Exceção simples para eu carregar uma mensagem amigável até a UI.
/// Eu uso essa classe para não vazar detalhes da DioException nas telas.
class AppError implements Exception {
  final String message;
  final int? status;

  AppError(this.message, {this.status});

  @override
  String toString() => message;
}
