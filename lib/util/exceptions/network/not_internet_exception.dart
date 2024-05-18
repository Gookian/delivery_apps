class NotInternetException implements Exception {
  int statusCode = 500;
  final message = "Не удалось достучаться до сервера!";

  NotInternetException();
}