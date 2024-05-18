import 'package:delivery_apps/api/osrm/models/trip_information.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'osrm_api_client.g.dart';

@RestApi(baseUrl: 'https://router.project-osrm.org/route/v1/')
abstract class OsrmApiClient {
  factory OsrmApiClient(Dio dio, {String baseUrl}) = _OsrmApiClient;

  @GET('/car/{pointStartLag},{pointStartLng};{pointEndLag},{pointEndLng}')
  Future<TripInformation> getOsrmResponse(
      @Path('pointStartLag') double pointStartLag,
      @Path('pointStartLng') double pointStartLng,
      @Path('pointEndLag') double pointEndLag,
      @Path('pointEndLng') double pointEndLng,
      @Query('overview') String overview,
      @Query('alternatives') int alternatives,
      @Query('steps') bool steps,
      @Query('annotations') bool annotations,
      @Query('geometries') String geometries
      );
}