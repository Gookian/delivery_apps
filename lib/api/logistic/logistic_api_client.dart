import 'dart:ffi';

import 'package:delivery_apps/api/logistic/models/credentials.dart';
import 'package:delivery_apps/api/logistic/models/order_pick_up_point.dart';
import 'package:delivery_apps/api/logistic/models/sorting_center.dart';
import 'package:delivery_apps/api/logistic/models/warehouse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'logistic_api_client.g.dart';

@RestApi(baseUrl: 'http://79.136.223.154:5115/api/')
abstract class LogisticApiClient {
  factory LogisticApiClient(Dio dio, {String baseUrl}) = _LogisticApiClient;

  @GET('/Authentication')
  Future<String> authentication(
      @Query('username') String username,
      @Query('password') String password,
  );

  @POST('/Registration')
  Future<void> registration(
      @Body() Credentials credentials,
  );

  @GET('/Warehouse')
  Future<List<Warehouse>> getWarehouses(@Header("Authorization") String token);

  @GET('/OrderPickUpPoint')
  Future<List<OrderPickUpPoint>> getOrderPickUpPoints(@Header("Authorization") String token);

  @GET('/SortingCenter')
  Future<List<SortingCenter>> getSortingCenters(@Header("Authorization") String token);
}