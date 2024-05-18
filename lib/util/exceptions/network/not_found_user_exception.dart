import 'package:delivery_apps/api/logistic/models/network_error.dart';

class NotFoundUserException implements Exception {
  int statusCode = 404;
  NetworkError networkError;

  NotFoundUserException(this.networkError);
}