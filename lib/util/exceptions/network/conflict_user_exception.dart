import 'package:delivery_apps/api/logistic/models/network_error.dart';

class ConflictUserException implements Exception {
  int statusCode = 409;
  NetworkError networkError;

  ConflictUserException(this.networkError);
}