// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripInformation _$TripInformationFromJson(Map<String, dynamic> json) =>
    TripInformation(
      code: json['code'] as String,
      routes: (json['routes'] as List<dynamic>)
          .map((e) => Route.fromJson(e as Map<String, dynamic>))
          .toList(),
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => Waypoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TripInformationToJson(TripInformation instance) =>
    <String, dynamic>{
      'code': instance.code,
      'routes': instance.routes,
      'waypoints': instance.waypoints,
    };
