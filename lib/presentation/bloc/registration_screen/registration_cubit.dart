import 'dart:async';
import 'dart:convert';

import 'package:delivery_apps/api/logistic/logistic_api_client.dart';
import 'package:delivery_apps/api/logistic/models/credentials.dart';
import 'package:delivery_apps/api/logistic/models/network_error.dart';
import 'package:delivery_apps/presentation/bloc/registration_screen/registration_state.dart';
import 'package:delivery_apps/util/exceptions/network/conflict_user_exception.dart';
import 'package:delivery_apps/util/exceptions/network/not_internet_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationIdleState());

  final client = LogisticApiClient(Dio());

  Future<void> registration(username, password) async {
    try {
      emit(RegistrationLoadingState());
      await client.registration(Credentials(username: username, password: password));
      emit(RegistrationIdleState());
    } catch (obj) {
      switch (obj.runtimeType) {
        case DioException:
          final res = (obj as DioException).response;
          debugPrint(res?.statusCode.toString());
          switch (res?.statusCode) {
            case null:
              emit(RegistrationIdleState());
              throw NotInternetException();
            case 409:
              final networkError = NetworkError.fromJson(res?.data);
              if (networkError.statusCode == 1) {
                emit(RegistrationIdleState());
                throw ConflictUserException(networkError);
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