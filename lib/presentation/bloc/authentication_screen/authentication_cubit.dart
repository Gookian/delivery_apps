import 'dart:async';
import 'dart:convert';

import 'package:delivery_apps/api/logistic/logistic_api_client.dart';
import 'package:delivery_apps/api/logistic/models/network_error.dart';
import 'package:delivery_apps/presentation/bloc/authentication_screen/authentication_state.dart';
import 'package:delivery_apps/repositories/token_repository.dart';
import 'package:delivery_apps/util/exceptions/network/not_found_user_exception.dart';
import 'package:delivery_apps/util/exceptions/network/not_internet_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationIdleState());

  final client = LogisticApiClient(Dio());

  Future<void> authentication(username, password) async {
    try {
      emit(AuthenticationLoadingState());
      var result = await client.authentication(username, password);
      TokenRepository.token = result.replaceAll("\"", "");
      emit(AuthenticationIdleState());
    } catch (obj) {
      switch (obj.runtimeType) {
        case DioException:
          final res = (obj as DioException).response;
          switch (res?.statusCode) {
            case null:
              emit(AuthenticationIdleState());
              throw NotInternetException();
            case 404:
              final jsonMap = json.decode(res?.data);
              final networkError = NetworkError.fromJson(jsonMap);

              if (networkError.statusCode == 1) {
                emit(AuthenticationIdleState());
                throw NotFoundUserException(networkError);
              }
              break;
          }
          break;
        default:
          break;
      }
    }
  }
}